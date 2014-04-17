Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338AbaDQHud (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 03:50:33 -0400
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:52498 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750910AbaDQHub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 03:50:31 -0400
Message-ID: <1397721028.24336.13.camel@x220>
Subject: Re: [PATCH] usb: phy: mv_u3d: Remove usb phy driver for mv_u3d
From: Paul Bolle <pebolle@tiscali.nl>
To: balbi@ti.com
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Richard Weinberger <richard@nod.at>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Date: Thu, 17 Apr 2014 09:50:28 +0200
In-Reply-To: <20140416043450.GB15056@saruman.home>
References: <1397561783.1985.55.camel@x220>
	 <20140415172310.GD16002@saruman.home> <1397585312.8212.13.camel@x220>
	 <20140416043450.GB15056@saruman.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Apr 2014 07:50:29.0273 (UTC) FILETIME=[B3B17890:01CF5A11]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-04-15 at 23:34 -0500, Felipe Balbi wrote:
> $ make drivers/usb/phy/phy-mv-u3d-usb.o
>   CHK     include/config/kernel.release
>   CHK     include/generated/uapi/linux/version.h
>   CHK     include/generated/utsrelease.h
> make[1]: `include/generated/mach-types.h' is up to date.
>   CALL    scripts/checksyscalls.sh
>   CC      drivers/usb/phy/phy-mv-u3d-usb.o

(On x86_64 this manual make command triggers the error Greg reported in
https://lkml.org/lkml/2014/2/11/693 .)

> yup, builds just fine. Even if the ARCH support isn't in place, this
> driver is *not* breaking anything, it's not preventing anyone from
> getting work done and it might be helping Marvell decrease the amount of
> changes they keep out of tree.
> 
> I don't see any problems this driver in tree as long as there are people
> working on it and I see the latest commit was 10 days ago, it wouldn't
> be fair to Marvell to delete their driver if they're still finding ways
> to make it useful one way or another.

Wouldn't it then be better if this driver is at least hooked into the
build system? Like, say, this:
    config MV_U3D_PHY
            bool "Marvell USB 3.0 PHY controller Driver"
            # XXX should depend on CPU_MMP3 when support for MMP3 lands
            depends on ARM && COMPILE_TEST
            select USB_PHY
            help
              Enable this to support Marvell USB 3.0 phy controller for Marvell
              SoC.

(Or perhaps only ARCH_MMP && COMPILE_TEST.) That should give it build
coverage by the automated tests people appear to run, while work is done
on adding MMP3 support.

Thanks,


Paul Bolle


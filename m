Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933162Ab3CMSvX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 14:51:23 -0400
Received: from canardo.mork.no ([148.122.252.1]:45508 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755178Ab3CMSvW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 14:51:22 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: manoj.iyer@canonical.com
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Whitcroft <apw@canonical.com>,
        Timo Aaltonen <tjaalton@ubuntu.com>, linux-usb@vger.kernel.org
Subject: Re: [PATCH 1/1] USB: Added quirk to recognize GE0301 3G modem as an interface.
Organization: m
References: <1363199082-7081-1-git-send-email-manoj.iyer@canonical.com>
	<1363199152-7113-1-git-send-email-manoj.iyer@canonical.com>
Date: Wed, 13 Mar 2013 19:51:16 +0100
In-Reply-To: <1363199152-7113-1-git-send-email-manoj.iyer@canonical.com>
	(manoj iyer's message of "Wed, 13 Mar 2013 13:25:52 -0500")
Message-ID: <87d2v36sm3.fsf@nemi.mork.no>
User-Agent: Gnus/5.11002 (No Gnus v0.20) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

manoj.iyer@canonical.com writes:

> +/* Reported by Timo Aaltonen <tjaalton@ubuntu.com> */
> +UNUSUAL_DEV( 0x0af0, 0x7011, 0x0000, 0x9999,
> +		"Option",
> +		"Mass Storage",
> +		USB_SC_DEVICE, USB_PR_DEVICE, option_ms_init,
> +		0 ),
> +
>  /* Reported by F. Aben <f.aben@option.com>
>   * This device (wrongly) has a vendor-specific device descriptor.
>   * The entry is needed so usb-storage can bind to it's mass-storage


This device is already supported by the default usb_modeswitch
configuration: 

               bjorn@nemi:~$ tar zxOvf /usr/share/usb_modeswitch/configPack.tar.gz 0af0:7011
               0af0:7011
               # Option HSO device

               TargetClass=0xff

               MessageContent="55534243785634120100000080000601000000000000000000000000000000"

               NoDriverLoading=1


Install the usb-modeswitch package and you're done.  No need to patch
the kernel for this.


Bjørn

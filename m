Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713AbaFKTkV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 15:40:21 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:57968 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750963AbaFKTkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 15:40:20 -0400
X-IronPort-AV: E=Sophos;i="5.01,460,1400018400"; 
   d="scan'208";a="79596536"
Date: Wed, 11 Jun 2014 20:40:15 +0100 (BST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: Alan Stern <stern@rowland.harvard.edu>
cc: Himangi Saraogi <himangi774@gmail.com>, Tony Prisk <linux@prisktech.co.nz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] uhci-platform: use devm_ioremap resource
In-Reply-To: <Pine.LNX.4.44L0.1406111528170.890-100000@iolanthe.rowland.org>
Message-ID: <alpine.DEB.2.10.1406112038420.2576@hadrien>
References: <Pine.LNX.4.44L0.1406111528170.890-100000@iolanthe.rowland.org>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-709298787-1402515617=:2576"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-709298787-1402515617=:2576
Content-Type: TEXT/PLAIN; charset=ISO-8859-7
Content-Transfer-Encoding: 8BIT

> > v2: pass correct arguments to devm_ioremap_resource
> > Not compile tested due to incompatible architecture.
>
> uhci-platform is compatible with all architectures.  But you have to
> add it to the .config file by hand.

What should one do exactly?  I added

CONFIG_USB_UHCI_PLATFORM=y

to the end of my .config file, but then running make just overwrites it:

> make drivers/usb/host/uhci-platform.o
scripts/kconfig/conf --silentoldconfig Kconfig
#
# configuration written to .config
#
  CHK     include/config/kernel.release
  CHK     include/generated/uapi/linux/version.h
  CHK     include/generated/utsrelease.h
  CALL    scripts/checksyscalls.sh
  CC      drivers/usb/host/uhci-platform.o
drivers/usb/host/uhci-platform.c:13:38: warning: ¡struct usb_hcd¢ declared
inside parameter list [enabled by default]
 static int uhci_platform_init(struct usb_hcd *hcd)
                                      ^

thanks,
julia
--8323329-709298787-1402515617=:2576--

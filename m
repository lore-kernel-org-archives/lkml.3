Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933745AbaKMRqV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 12:46:21 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:16198 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933357AbaKMRqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 12:46:17 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 104.193.169.186
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/xMNRmggWZ2ZGrzc2FZMhY
Date: Thu, 13 Nov 2014 09:45:36 -0800
From: Tony Lindgren <tony@atomide.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Sebastian Reichel <sre@kernel.org>, Pali Roh?r <pali.rohar@gmail.com>,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, khilman@kernel.org, aaro.koskinen@iki.fi,
        freemangordon@abv.bg
Subject: Re: N900 modem support in 3.18-rc1
Message-ID: <20141113174534.GO26481@atomide.com>
References: <20141104205117.GA17606@amd>
 <201411052137.31452@pali>
 <20141105203918.GA29199@amd>
 <201411052206.05379@pali>
 <20141105220359.GA32052@amd>
 <20141105234555.GA7097@earth.universe>
 <20141106124711.GA26944@amd>
 <20141106180335.GA21513@earth.universe>
 <20141113162155.GA8512@xo-6d-61-c0.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141113162155.GA8512@xo-6d-61-c0.localdomain>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pavel Machek <pavel@ucw.cz> [141113 08:23]:
> Hi!
> 
> > > I actually had pm=0 on the command line, but I removed it now, and no
> > > change: [...]
> > > 
> > > Let me try with explicit =1. .. aha, that helps. Thanks!
> > 
> > mh seems I actually missed to make 1 the default value. I will
> > prepare a patch for that.
> > 
> > I assume, that the example ofono commands work for you now?
> 
> Yes, it now works great.
> 
> > > Do you have an example client that can talk to ofonod?
> > 
> > I have not yet played with userland stuff. You could try
> > telepathy-ring, which integrates the ofono into the telepathy
> > framework.
> 
> Ok, I took a look, and telepathy-ring is not in debian, and has
> a lot of dependencies.
> 
> OTOH ofono seems pretty reasonable. So I played a bit, and result
> is python/pygtk gui which can receive an sms, initiate a call, and
> report missed call. If someone wants to play, source is at
> 
> https://gitorious.org/tui/tui/source/b6141107e9341a1412720aed4b0d09143dfa2f4e:ofone

Pavel, care to fill in the the following type patch with some
instructions in the description now that you got it working?

I did not have luck yet when I tried. I got the /dev/cmt/*
entries after adding pm=1 param, but no luck scanning any networks.

Regards,

Tony

8< -----------------
ARM: omap2plus_defconfig: Enable n900 modem as loadable modules

--- a/arch/arm/configs/omap2plus_defconfig
+++ b/arch/arm/configs/omap2plus_defconfig
@@ -88,6 +88,7 @@ CONFIG_IP_PNP_BOOTP=y
 CONFIG_IP_PNP_RARP=y
 # CONFIG_INET_LRO is not set
 CONFIG_NETFILTER=y
+CONFIG_PHONET=m
 CONFIG_CAN=m
 CONFIG_CAN_C_CAN=m
 CONFIG_CAN_C_CAN_PLATFORM=m
@@ -158,6 +159,7 @@ CONFIG_USB_ALI_M5632=y
 CONFIG_USB_AN2720=y
 CONFIG_USB_EPSON2888=y
 CONFIG_USB_KC2190=y
+CONFIG_USB_CDC_PHONET=m
 CONFIG_LIBERTAS=m
 CONFIG_LIBERTAS_USB=m
 CONFIG_LIBERTAS_SDIO=m
@@ -197,6 +199,11 @@ CONFIG_HW_RANDOM=y
 CONFIG_I2C_CHARDEV=y
 CONFIG_SPI=y
 CONFIG_SPI_OMAP24XX=y
+CONFIG_HSI=m
+CONFIG_OMAP_SSI=m
+CONFIG_NOKIA_MODEM=m
+CONFIG_SSI_PROTOCOL=m
+CONFIG_HSI_CHAR=m
 CONFIG_PINCTRL_SINGLE=y
 CONFIG_DEBUG_GPIO=y
 CONFIG_GPIO_SYSFS=y
@@ -312,9 +319,11 @@ CONFIG_USB_CONFIGFS_ECM=y
 CONFIG_USB_CONFIGFS_ECM_SUBSET=y
 CONFIG_USB_CONFIGFS_RNDIS=y
 CONFIG_USB_CONFIGFS_EEM=y
+CONFIG_USB_CONFIGFS_PHONET=y
 CONFIG_USB_CONFIGFS_MASS_STORAGE=y
 CONFIG_USB_CONFIGFS_F_LB_SS=y
 CONFIG_USB_CONFIGFS_F_FS=y
+CONFIG_USB_G_NOKIA=m
 CONFIG_MMC=y
 CONFIG_SDIO_UART=y
 CONFIG_MMC_OMAP=y
@@ -359,6 +368,7 @@ CONFIG_MSDOS_FS=y
 CONFIG_VFAT_FS=y
 CONFIG_TMPFS=y
 CONFIG_TMPFS_POSIX_ACL=y
+CONFIG_CONFIGFS_FS=y
 CONFIG_JFFS2_FS=y
 CONFIG_JFFS2_SUMMARY=y
 CONFIG_JFFS2_FS_XATTR=y

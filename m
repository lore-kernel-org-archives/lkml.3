Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757431Ab3GRI75 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 04:59:57 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:43701 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756667Ab3GRI7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 04:59:54 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18Ur4UN4HzJMG3GskIuO17Y
Date: Thu, 18 Jul 2013 01:59:51 -0700
From: Tony Lindgren <tony@atomide.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-omap@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Roger Quadros <rogerq@ti.com>
Subject: Re: Regression 3.11-rc1: omap4panda: no usb and consequently no
 ethernet
Message-ID: <20130718085951.GT7656@atomide.com>
References: <51E7AA24.6080600@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51E7AA24.6080600@broadcom.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arend van Spriel <arend@broadcom.com> [130718 01:47]:
> 
> We are using the panda board (es variant) for testing our SDIO based
> chips. For this we have an adapter card connection to expansion
> connector A. As this adapter is not publicly available we had
> internally patched board-omap4panda.c. Also we follow the -rc
> releases and use TFTP to boot the kernel image which requires USB.
> 
> Moving to 3.11-rc1 I found that the mentioned board file was removed
> by your commit:
> 
> commit b42b918194c4791510ac049e3d507169a7de8544
> Author: Tony Lindgren <tony@atomide.com>
> Date:   Thu May 30 12:53:05 2013 -0700
> 
>     ARM: OMAP2+: Remove board-omap4panda.c
> 
> As our patches on that file are internal I do not hold it against
> you. This is no regression and we need to fix it.

Right, we need to move on to device tree based booting. Most of
it should be pretty trivial configuring of the .dts file and
some .config changes so whatever issues are remaining should
be out of the way by v3.11.
 
> So my first step was to follow the recipe given in that commit.
> Beside that I noticed a thread about USB issue on LKML so I also
> applied the following commit:
> 
> commit 352f573e59050c7a604c35c58b4bbfc51edebbee
> Author: Roger Quadros <rogerq@ti.com>
> Date:   Tue Jun 18 19:04:47 2013 +0300
> 
>     ARM: OMAP2+: Provide alias to USB PHY clock
> 
> The attached kernel log seems to suggest that the device tree is
> picked up by the kernel, but the USB does not seem very active. No
> ethernet connectivity. This does seem a regression to me. Is there
> some other patch that I need to get it going again?

There are few .dts related patches missing for USB. Roger can
point you to the current versions that Benoit should be queueing
for the -rc series.

Then for the SDIO with device tree, take a look at the following
patches:

[PATCH 0/3] WLAN support for omap4 when booted with devicetree
http://comments.gmane.org/gmane.linux.ports.arm.omap/97522#

The wl12xx .dts changes for pandaboard are still missing too.

Then I'll be updating these soonish:
[PATCH 0/4] Updated omap_hsmmc SDIO and remuxing patches

Those are needed for the SDIO interrupt, SDIO will work also
without those.

Regards,

Tony

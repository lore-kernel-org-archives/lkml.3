Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752899AbbAMP56 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 10:57:58 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:37464 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751960AbbAMP54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 10:57:56 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 104.193.169.186
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19KylAQ8XSaixJGjjZUfqEG
Date: Tue, 13 Jan 2015 07:54:09 -0800
From: Tony Lindgren <tony@atomide.com>
To: Roger Quadros <rogerq@ti.com>
Cc: kishon@ti.com, nm@ti.com, balbi@ti.com, george.cherian@ti.com,
        nsekhar@ti.com, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v3 0/4] phy: ti-pipe3: fixes for 3.19-rc
Message-ID: <20150113155409.GA2419@atomide.com>
References: <1421151802-7396-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421151802-7396-1-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Roger Quadros <rogerq@ti.com> [150113 04:26]:
> Hi,
> 
> During system suspend L3INIT_960M_GFCLK and L3INIT_480M_GFCLK clocks remain
> active on the DRA7 platform. This is because the pipe3 driver doesn't shut
> them off as part of .suspend(). Patch 1 addresses this issue.
> 
> SATA on both OMAP5 and DRA7 breaks when SATA drive is plugged in after a
> system suspend/resume or if AHCI_PLATFORM driver is used as module.
> Patches 2,3,4 fix it.
> 
> Hope to get these patches in through the 3.19-rc cycle.
> 
> Tony,
> 
> Do you wish to take the DTS patches or let them go in through PHY tree?

Those look ok to me to merge along with the fixes, will ack those two.

Regards,

Tony

> Changelog
> - v3 : Commit message updated. dts changes moved to separate patch.
> - v2 : Don't break SATA with old DTB.
> 
> Roger Quadros (4):
>   phy: ti-pipe3: Disable clocks on system suspend
>   phy: ti-pipe3: Fix SATA across suspend/resume
>   ARM: dts: DRA7: Fix SATA PHY node
>   ARM: dts: OMAP5: Fix SATA PHY node
> 
>  arch/arm/boot/dts/dra7.dtsi  |   4 +-
>  arch/arm/boot/dts/omap5.dtsi |   4 +-
>  drivers/phy/phy-ti-pipe3.c   | 142 +++++++++++++++++++++++++++++++++----------
>  3 files changed, 115 insertions(+), 35 deletions(-)
> 
> -- 
> 2.1.0
> 

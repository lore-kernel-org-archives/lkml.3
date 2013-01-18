Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757227Ab3ARMgt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 07:36:49 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:33266 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751618Ab3ARMgp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 07:36:45 -0500
Message-ID: <50F941CB.1080808@ti.com>
Date: Fri, 18 Jan 2013 14:36:27 +0200
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Roger Quadros <rogerq@ti.com>
CC: <sameo@linux.intel.com>, <balbi@ti.com>, <tony@atomide.com>,
        <kishon@ti.com>, <sshtylyov@mvista.com>, <bjorn@mork.no>,
        <linux@arm.linux.org.uk>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH v8 01/22] USB: ehci-omap: Don't free gpios that we didn't
 request
References: <1358511445-26656-1-git-send-email-rogerq@ti.com> <1358511445-26656-2-git-send-email-rogerq@ti.com>
In-Reply-To: <1358511445-26656-2-git-send-email-rogerq@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/18/2013 02:17 PM, Roger Quadros wrote:
> This driver does not request any gpios so don't free them.
> Fixes L3 bus error on multiple modprobe/rmmod of ehci_hcd
> with ehci-omap in use.
> 
> Without this patch, EHCI will break on repeated insmod/rmmod
> of ehci_hcd for all OMAP2+ platforms that use EHCI and
> set 'phy_reset = true' in usbhs_omap_board_data.
> i.e.
> 
> board-3430sdp.c:	.phy_reset  = true,
> board-3630sdp.c:	.phy_reset  = true,
> board-am3517crane.c:	.phy_reset  = true,
> board-am3517evm.c:	.phy_reset  = true,
> board-cm-t3517.c:	.phy_reset  = true,
> board-cm-t35.c:	.phy_reset  = true,
> board-devkit8000.c:	.phy_reset  = true,
> board-igep0020.c:	.phy_reset = true,
> board-igep0020.c:	.phy_reset = true,
> board-omap3beagle.c:	.phy_reset  = true,
> board-omap3evm.c:	.phy_reset  = true,
> board-omap3pandora.c:	.phy_reset  = true,
> board-omap3stalker.c:	.phy_reset = true,
> board-omap3touchbook.c:	.phy_reset  = true,
> board-omap4panda.c:	.phy_reset  = false,
> board-overo.c:	.phy_reset  = true,
> board-zoom.c:	.phy_reset		= true,
> 
> CC: Alan Stern <stern@rowland.harvard.edu>
> Cc: stable@kernel.org

I messed up with the stable list id, so will resend just this one
and update the git repo.

> 
> Signed-off-by: Roger Quadros <rogerq@ti.com>
> Reviewed-by: Felipe Balbi <balbi@ti.com>
> Acked-by: Alan Stern <stern@rowland.harvard.edu>

cheers,
-roger


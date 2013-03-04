Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758684Ab3CDRih (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 12:38:37 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:45030 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758648Ab3CDRie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 12:38:34 -0500
Date: Mon, 4 Mar 2013 12:38:33 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Stephen Warren <swarren@wwwdotorg.org>
cc: Venu Byravarasu <vbyravarasu@nvidia.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: host: tegra: Reset Tegra USB controller before init
In-Reply-To: <5134D210.3060405@wwwdotorg.org>
Message-ID: <Pine.LNX.4.44L0.1303041237540.1750-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Mar 2013, Stephen Warren wrote:

> On 03/04/2013 12:55 AM, Venu Byravarasu wrote:
> > Stephen Warren wrote at Thursday, February 28, 2013 11:47 PM:
> >> On 02/27/2013 11:36 PM, Venu Byravarasu wrote:
> >>> To clear any configurations made by U-Boot on Tegra USB controller,
> >>> reset it before init in probe.
> >>
> >>> diff --git a/drivers/usb/host/ehci-tegra.c b/drivers/usb/host/ehci-tegra.c
> >>
> >>> @@ -691,6 +692,10 @@ static int tegra_ehci_probe(struct platform_device
> >> *pdev)
> >>>  	if (err)
> >>>  		goto fail_clk;
> >>>
> >>> +	tegra_periph_reset_assert(tegra->clk);
> >>> +	udelay(1);
> >>> +	tegra_periph_reset_deassert(tegra->clk);

> OK, in that case I have no objection to this patch.
> 
> I'd like to hold off on applying this though; I suspect I'll want to
> take the Tegra USB patches through the Tegra tree rather than the USB
> tree again for the 3.10 kernel cycle. I think I may have screwed the
> pooch on the DT binding I set up for the USB controller clocks, and
> fixing this may require some Tegra DT changes, which would be easiest
> taken through the Tegra tree, and so to reduce conflicts in the USB
> code, taking the rest through there migth just be easiest.
> 
> Alan, Greg, if you're OK with this patch now, or for any revised
> version, an Ack so I can take it through the Tegra tree would be great,
> thanks.

I have no other objections.

Acked-by: Alan Stern <stern@rowland.harvard.edu>

Alan Stern


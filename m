Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752998AbaKCDjQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 22:39:16 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:39456 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752301AbaKCDjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 22:39:15 -0500
Date: Mon, 3 Nov 2014 11:39:08 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Stefan Agner <stefan@agner.ch>
Cc: kernel@pengutronix.de, jingchang.lu@freescale.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] ARM: imx: clk-vf610: define PLL's clock tree
Message-ID: <20141103033907.GB10821@tiger>
References: <1414428044-22103-1-git-send-email-stefan@agner.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414428044-22103-1-git-send-email-stefan@agner.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2014 at 05:40:44PM +0100, Stefan Agner wrote:
> So far, the required PLL's (PLL1/PLL2/PLL5) have been initialized
> by boot loader and the kernel code defined fixed rates according
> to those default configurations. Beginning with the USB PLL7 the
> code started to initialize the PLL's itself (using imx_clk_pllv3).
> 
> However, since commit dc4805c2e78ba5a22ea1632f3e3e4ee601a1743b
> (ARM: imx: remove ENABLE and BYPASS bits from clk-pllv3 driver)
> imx_clk_pllv3 no longer takes care of the ENABLE and BYPASS bits,
> hence the USB PLL were not configured correctly anymore.

Sorry for that.

> 
> This patch not only fixes those USB PLL's, but also makes use of
> the imx_clk_pllv3 for all PLL's and alignes the code with the PLL
> support of the i.MX6 series.
> 
> Signed-off-by: Stefan Agner <stefan@agner.ch>
> ---
> Shawn, I sent this almost 1 month ago, along with a mail asking
> of the state a week ago. But both to your old e-mail, I guess you
> didn't received it then...?

> Also some other Vybrid related patches,
> shall I resend them with your new e-mail?

Yes, resending them helps.

> 
> If possible, it still would be great if this makes it into 3.18.
> Right now, because of the clk-pllv3 change, the newly added USB
> support is broken...
> 
> I could have created a patch which only fixes the USB PLL7, but
> then we touch the header file twice and its getting a mess in
> there. I prefer to have it fixed once for all PLL's. I hope this
> makes it into 3.18 nonetheless. If not, I'm also fine if this
> makes it into next.

The diff looks a little bit big, but it does fix a regression, so let
me try to send it for 3.18.

Thanks for the fixing.

Shawn

> 
>  arch/arm/mach-imx/clk-vf610.c           | 134 ++++++++++++++++++++++----------
>  include/dt-bindings/clock/vf610-clock.h |  39 ++++++++--
>  2 files changed, 123 insertions(+), 50 deletions(-)

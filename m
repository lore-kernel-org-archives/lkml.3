Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370Ab3JGCTf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 22:19:35 -0400
Received: from guitar.tcltek.co.il ([192.115.133.116]:45576 "EHLO
	sivan.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754845Ab3JGCTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 22:19:33 -0400
X-Greylist: delayed 526 seconds by postgrey-1.27 at vger.kernel.org; Sun, 06 Oct 2013 22:19:33 EDT
Date: Mon, 7 Oct 2013 05:10:41 +0300
From: Baruch Siach <baruch@tkos.co.il>
To: Felipe Pena <felipensp@gmail.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        Michal Simek <michal.simek@xilinx.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        =?iso-8859-1?Q?S=F6ren?= Brinkmann <soren.brinkmann@xilinx.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/1] clk/zynq: Fix possible memory leak
Message-ID: <20131007021041.GE4875@tarshish>
References: <1381107317-18120-1-git-send-email-felipensp@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381107317-18120-1-git-send-email-felipensp@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,

On Sun, Oct 06, 2013 at 09:55:17PM -0300, Felipe Pena wrote:
> The zynq_clk_register_fclk function can leak memory (fclk_lock) when unable 
> to alloc memory for fclk_gate_lock
> 
> Signed-off-by: Felipe Pena <felipensp@gmail.com>
> ---
>  drivers/clk/zynq/clkc.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/clk/zynq/clkc.c b/drivers/clk/zynq/clkc.c
> index cc40fe6..7ea4b5c 100644
> --- a/drivers/clk/zynq/clkc.c
> +++ b/drivers/clk/zynq/clkc.c
> @@ -117,6 +117,7 @@ static void __init zynq_clk_register_fclk(enum zynq_clk fclk,
>  		goto err;
>  	fclk_gate_lock = kmalloc(sizeof(*fclk_gate_lock), GFP_KERNEL);
>  	if (!fclk_gate_lock)
> +		kfree(fclk_lock);
>  		goto err;

Missing braces.

>  	spin_lock_init(fclk_lock);
>  	spin_lock_init(fclk_gate_lock);

baruch

-- 
     http://baruch.siach.name/blog/                  ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -

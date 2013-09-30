Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756103Ab3I3PZ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 11:25:57 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:52752 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755632Ab3I3PZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 11:25:41 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: takasi-y@ops.dti.ne.jp
Cc: SH-Linux <linux-sh@vger.kernel.org>, Magnus Damm <magnus.damm@gmail.com>,
        ben.dooks@codethink.co.uk,
        Shinya Kuribayashi <shinya.kuribayashi.px@renesas.com>,
        devicetree@vger.kernel.org, linux-serial@vger.kernel.org,
        Simon Horman <horms@verge.net.au>, Paul Mundt <lethal@linux-sh.org>,
        Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] clocksource: em_sti: convert to clk_prepare/unprepare
Date: Mon, 30 Sep 2013 17:25:41 +0200
Message-ID: <1504961.3u9y73MgII@avalon>
User-Agent: KMail/4.10.5 (Linux/3.8.13-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <20130924130924.61d4ecedf3d4fca5952d55fc@ops.dti.ne.jp>
References: <52410F86.4040301@renesas.com> <20130924130924.61d4ecedf3d4fca5952d55fc@ops.dti.ne.jp>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yoshii-san,

Thank you for the patch.

On Tuesday 24 September 2013 13:09:24 takasi-y@ops.dti.ne.jp wrote:
> From: Shinya Kuribayashi <shinya.kuribayashi.px@renesas.com>
> 
> Add calls to clk_prepare and unprepare so that EMMA Mobile EV2 can
> migrate to the common clock framework.
> 
> Signed-off-by: Shinya Kuribayashi <shinya.kuribayashi.px@renesas.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/clocksource/em_sti.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/clocksource/em_sti.c b/drivers/clocksource/em_sti.c
> index 3a5909c..9d17083 100644
> --- a/drivers/clocksource/em_sti.c
> +++ b/drivers/clocksource/em_sti.c
> @@ -78,7 +78,7 @@ static int em_sti_enable(struct em_sti_priv *p)
>  	int ret;
> 
>  	/* enable clock */
> -	ret = clk_enable(p->clk);
> +	ret = clk_prepare_enable(p->clk);
>  	if (ret) {
>  		dev_err(&p->pdev->dev, "cannot enable clock\n");
>  		return ret;
> @@ -107,7 +107,7 @@ static void em_sti_disable(struct em_sti_priv *p)
>  	em_sti_write(p, STI_INTENCLR, 3);
> 
>  	/* stop clock */
> -	clk_disable(p->clk);
> +	clk_disable_unprepare(p->clk);
>  }
> 
>  static cycle_t em_sti_count(struct em_sti_priv *p)
-- 
Regards,

Laurent Pinchart


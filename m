Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967131Ab3E2WtE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 18:49:04 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:63484 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755938Ab3E2Wsz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 18:48:55 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: =?utf-8?q?Emilio_L=C3=B3pez?= <emilio@elopez.com.ar>, cate@cateee.net
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1368798200-7063-1-git-send-email-emilio@elopez.com.ar>
Cc: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        =?utf-8?q?Emilio_L=C3=B3pez?= <emilio@elopez.com.ar>
References: <5195D615.70608@cateee.net>
 <1368798200-7063-1-git-send-email-emilio@elopez.com.ar>
Message-ID: <20130529224849.6058.25112@quantum>
User-Agent: alot/0.3.4
Subject: Re: [PATCH] clk: sunxi: "cpu_data" is defined in header files of some
 architectures
Date: Wed, 29 May 2013 15:48:49 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Emilio López (2013-05-17 06:43:20)
> From: "Giacomo A. Catenazzi" <cate@cateee.net>
> 
> In some architectures, the #define cpu_data is not a "macro-function",
> so the compiler will substitute the identifier with probably something
> wrong.
> 
> Signed-off-by: Giacomo A. Catenazzi <cate@cateee.net>
> Signed-off-by: Emilio López <emilio@elopez.com.ar>
> [emilio@elopez.com.ar: use cpu_mux_data instead of this_cpu_data]

Taken into clk-next.

Regards,
Mike

> ---
> 
> Hi Giacomo,
> 
> I have taken your patch and resent it to linux-arm-kernel and Mike 
> Turquette this time, but please try to use git send-email on your next 
> patch.
> 
> Here is a video from Greg that explains how to use it as well as other 
> things (checkpatch.pl, get_maintainer.pl, etc)
> 
> http://www.youtube.com/watch?v=LLBrBBImJt4
> 
> Thanks! :)
> 
> Emilio
> 
>  drivers/clk/sunxi/clk-sunxi.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/clk/sunxi/clk-sunxi.c b/drivers/clk/sunxi/clk-sunxi.c
> index 930d36f..412912b 100644
> --- a/drivers/clk/sunxi/clk-sunxi.c
> +++ b/drivers/clk/sunxi/clk-sunxi.c
> @@ -239,7 +239,7 @@ struct mux_data {
>         u8 shift;
>  };
>  
> -static const __initconst struct mux_data cpu_data = {
> +static const __initconst struct mux_data cpu_mux_data = {
>         .shift = 16,
>  };
>  
> @@ -433,7 +433,7 @@ static const __initconst struct of_device_id clk_div_match[] = {
>  
>  /* Matches for mux clocks */
>  static const __initconst struct of_device_id clk_mux_match[] = {
> -       {.compatible = "allwinner,sun4i-cpu-clk", .data = &cpu_data,},
> +       {.compatible = "allwinner,sun4i-cpu-clk", .data = &cpu_mux_data,},
>         {.compatible = "allwinner,sun4i-apb1-mux-clk", .data = &apb1_mux_data,},
>         {}
>  };
> -- 
> 1.8.2.3

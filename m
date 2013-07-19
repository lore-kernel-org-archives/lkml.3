Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761135Ab3GSTMO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 15:12:14 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:52337 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752182Ab3GSTMN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 15:12:13 -0400
Message-ID: <1374261131.2059.5.camel@joe-AO722>
Subject: Re: [PATCH 2/2] clk/zynq/pll: Use #defines for fbdiv min/max values
From: Joe Perches <joe@perches.com>
To: Soren Brinkmann <soren.brinkmann@xilinx.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Date: Fri, 19 Jul 2013 12:12:11 -0700
In-Reply-To: <1632076624.115.1374260902674.JavaMail.mail@webmail02>
References: <1374254205-9912-1-git-send-email-soren.brinkmann@xilinx.com>
	 <1632076624.115.1374260902674.JavaMail.mail@webmail02>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-07-19 at 10:16 -0700, Soren Brinkmann wrote:
> Use more descriptive #defines for the minimum and maximum PLL
> feedback divider.

trivial

> diff --git a/drivers/clk/zynq/pll.c b/drivers/clk/zynq/pll.c
[]
> @@ -63,10 +66,10 @@ static long zynq_pll_round_rate(struct clk_hw *hw, unsigned long rate,
>  	u32 fbdiv;
>  
>  	fbdiv = DIV_ROUND_CLOSEST(rate, *prate);
> -	if (fbdiv < 13)
> -		fbdiv = 13;
> -	else if (fbdiv > 66)
> -		fbdiv = 66;
> +	if (fbdiv < PLL_FBDIV_MIN)
> +		fbdiv = PLL_FBDIV_MIN;
> +	else if (fbdiv > PLL_FBDIV_MAX)
> +		fbdiv = PLL_FBDIV_MAX;

clamp



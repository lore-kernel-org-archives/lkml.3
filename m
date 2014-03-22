Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751203AbaCVHUq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 03:20:46 -0400
Received: from mx11.pku.edu.cn ([162.105.129.174]:54309 "EHLO mail.pku.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750826AbaCVHUn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 03:20:43 -0400
X-Spam-Flag: NO
X-Spam-Score: -307.293
Date: Sat, 22 Mar 2014 15:20:40 +0800 (CST)
From: =?utf-8?B?566h6Zuq5rab?= <gxt@pku.edu.cn>
To: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: gxt@mprc.pku.edu.cn, linux-kernel@vger.kernel.org,
        sunzhichuang <sunzhichuang@mprc.pku.edu.cn>
Message-ID: <1943297151.2164.1395472840681.JavaMail.root@bj-mail03.pku.edu.cn>
In-Reply-To: <5322592B.6060104@gmail.com>
Subject: =?utf-8?Q?=E5=9B=9E=E5=A4=8D=EF=BC=9A_[PATCH]_arch/unic?=
 =?utf-8?Q?ore32/kernel/clock.c:?=
 =?utf-8?Q?_add_readl()_and_writel()_for_'PM=5F'_macros?=
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [162.105.129.91]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Chen.

Cc: Zhichuang Sun <sunzhichuang@mprc.pku.edu.cn>
Tested-by: Zhichuang Sun <sunzhichuang@mprc.pku.edu.cn>
Acked-by: Xuetao Guan <gxt@pku.edu.cn>


----- Chen Gang <gang.chen.5i5j@gmail.com> 写道：
> Add readl() and writel() for 'PM_' macros, just like another areas have
> done within unicored32, or will cause compiling issue.
> 
> The related error (allmodconfig for unicored32):
> 
>     CC      arch/unicore32/kernel/clock.o
>   arch/unicore32/kernel/clock.c: In function ‘clk_set_rate’:
>   arch/unicore32/kernel/clock.c:182: warning: initialization makes integer from pointer without a cast
>   arch/unicore32/kernel/clock.c:204: error: lvalue required as left operand of assignment
>   arch/unicore32/kernel/clock.c:206: error: lvalue required as left operand of assignment
>   arch/unicore32/kernel/clock.c:207: error: invalid operands to binary & (have ‘void *’ and ‘long unsigned int’)
>   make[1]: *** [arch/unicore32/kernel/clock.o] Error 1
>   make: *** [arch/unicore32/kernel] Error 2
> 
> 
> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
> ---
>  arch/unicore32/kernel/clock.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/unicore32/kernel/clock.c b/arch/unicore32/kernel/clock.c
> index 18d4563..b1ca775 100644
> --- a/arch/unicore32/kernel/clock.c
> +++ b/arch/unicore32/kernel/clock.c
> @@ -179,7 +179,7 @@ int clk_set_rate(struct clk *clk, unsigned long rate)
>  	}
>  #ifdef CONFIG_CPU_FREQ
>  	if (clk == &clk_mclk_clk) {
> -		u32 pll_rate, divstatus = PM_DIVSTATUS;
> +		u32 pll_rate, divstatus = readl(PM_DIVSTATUS);
>  		int ret, i;
>  
>  		/* lookup mclk_clk_table */
> @@ -201,10 +201,10 @@ int clk_set_rate(struct clk *clk, unsigned long rate)
>  				/ (((divstatus & 0x0000f000) >> 12) + 1);
>  
>  		/* set pll sys cfg reg. */
> -		PM_PLLSYSCFG = pll_rate;
> +		writel(pll_rate, PM_PLLSYSCFG);
>  
> -		PM_PMCR = PM_PMCR_CFBSYS;
> -		while ((PM_PLLDFCDONE & PM_PLLDFCDONE_SYSDFC)
> +		writel(PM_PMCR_CFBSYS, PM_PMCR);
> +		while ((readl(PM_PLLDFCDONE) & PM_PLLDFCDONE_SYSDFC)
>  				!= PM_PLLDFCDONE_SYSDFC)
>  			udelay(100);
>  			/* about 1ms */
> -- 
> 1.7.9.5


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280Ab3FELvd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 07:51:33 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:30815 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384Ab3FELvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 07:51:31 -0400
X-AuditID: cbfee68f-b7f436d000000f81-b2-51af264160a5
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Doug Anderson'" <dianders@chromium.org>
Cc: "'Tomasz Figa'" <tomasz.figa@gmail.com>,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        "'Olof Johansson'" <olof@lixom.net>,
        "'Vikas Sajjan'" <vikas.sajjan@linaro.org>,
        "'Yadwinder Singh Brar'" <yadi.brar01@gmail.com>,
        "'linux-samsung-soc'" <linux-samsung-soc@vger.kernel.org>,
        "'Mike Turquette'" <mturquette@linaro.org>,
        "'Tomasz Figa'" <t.figa@samsung.com>, linux-kernel@vger.kernel.org
References: <1370026725-22910-1-git-send-email-dianders@chromium.org>
In-reply-to: <1370026725-22910-1-git-send-email-dianders@chromium.org>
Subject: RE: [PATCH] clk: samsung: Fix pll36xx_recalc_rate to handle kdiv
 properly
Date: Wed, 05 Jun 2013 20:51:29 +0900
Message-id: <08e301ce61e3$045828c0$0d087a40$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac5eMPV3WTFfPt2OQc60EcyZBKclLgDsbUJw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKIsWRmVeSWpSXmKPExsVy+t8zA11HtfWBBl3nbSzOLjvIZnF51xw2
	ixnn9zFZPJ1wkc3i1PXPbBbrZ7xmsTg2Ywmjxapdfxgtnjzaxmwx93cjqwOXx+yGiyweO2fd
	Zfe4c20Pm8eVE02sHn1bVjF6fN4kF8AWxWWTkpqTWZZapG+XwJWx+scs1oJ3AhVn/5xkaWDc
	w9vFyMkhIWAisb97KiOELSZx4d56ti5GLg4hgWWMEq13j7DBFK2+0QtmCwlMZ5SYsrsCougv
	o0TT6gusIAk2AQ2Jw++fsYPYIgLaEi8frGQGKWIWaGWW2HaoFarbVeLbl9lMXYwcHJwCbhId
	u1xBwsICIRIv/y8H62URUJU4uO8WC4jNK2Ar8er1HWYIW1Dix+R7YHFmAS2J9TuPM0HY8hKb
	17xlBhkpIaAu8eivLsQJRhJTLj9lgygRkdj34h0jyDkSAr0cEo+7ZjJC7BKQ+Db5EAtEr6zE
	pgPMEP9KShxccYNlAqPELCSbZyHZPAvJ5llIVixgZFnFKJpakFxQnJReZKxXnJhbXJqXrpec
	n7uJERLl/TsY7x6wPsSYDLR+IrOUaHI+MEnklcQbGpsZWZiamBobmVuakSasJM6r1mIdKCSQ
	nliSmp2aWpBaFF9UmpNafIiRiYNTqoExqH+tdtuuuJhfU/wbMwu85Cwi3Jf2PmuVfawUsPv4
	JO6DTcYKl79cNmc1/r5pra+m9c9OrQT9hGnTfq2Yz6vKmnj4dtAHwQPh7e+YHwl2fYj0XJjN
	3Z2d/rXu2HaH2QkcruXTu5UcWK4ubPkxUfvOjf171B7zTFP5q68rKNBdbJyQ/ld1e4cSS3FG
	oqEWc1FxIgCkASZrCAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEKsWRmVeSWpSXmKPExsVy+t9jQV1HtfWBBu1N5hZnlx1ks7i8aw6b
	xYzz+5gsnk64yGZx6vpnNov1M16zWBybsYTRYtWuP4wWTx5tY7aY+7uR1YHLY3bDRRaPnbPu
	snvcubaHzePKiSZWj74tqxg9Pm+SC2CLamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDU
	NbS0MFdSyEvMTbVVcvEJ0HXLzAG6TUmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+R
	ARpIWMeYsfrHLNaCdwIVZ/+cZGlg3MPbxcjJISFgIrH6Ri8bhC0mceHeejBbSGA6o8SU3RVd
	jFxA9l9GiabVF1hBEmwCGhKH3z9jB7FFBLQlXj5YyQxSxCzQyiyx7VArVLerxLcvs5m6GDk4
	OAXcJDp2uYKEhQVCJF7+Xw7WyyKgKnFw3y0WEJtXwFbi1es7zBC2oMSPyffA4swCWhLrdx5n
	grDlJTavecsMMlJCQF3i0V9diBOMJKZcfsoGUSIise/FO8YJjEKzkEyahWTSLCSTZiFpWcDI
	sopRNLUguaA4KT3XSK84Mbe4NC9dLzk/dxMjOIU8k97BuKrB4hCjAAejEg/vg09rA4VYE8uK
	K3MPMUpwMCuJ8F76vS5QiDclsbIqtSg/vqg0J7X4EGMy0KMTmaVEk/OB6S2vJN7Q2MTMyNLI
	zMLIxNycNGElcd6DrdaBQgLpiSWp2ampBalFMFuYODilGhjniF/JWqZwx0HW7H+kwmKP3V5H
	fe0OPXw/pUirUOevu2zee9mXbruUPRz6oq5K36n8XvNfcKqM7dsNVfKH5jkma/R3lu38bfo5
	6nYTlzuH8fIsNv0118OXTTzgKF6ilixoufvFt/xvbtWSN0I6+48qHlU4c/nfDOnve6a9/G/V
	yfD5X75UorsSS3FGoqEWc1FxIgDyyZOeZQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Doug Anderson wrote:
> 
> The KDIV value is often listed as unsigned but it needs to be treated
> as a 16-bit signed value when using it in calculations.  Fix our rate
> recalculation to do this correctly.
> 
> Before doing this, I tried setting EPLL on exynos5250 to:
>   rate, m, p, s, k = 80000000, 107, 2, 4, 43691
> 
> This rate is exactly from the table in the exynos5250 user manual.
> 
> I read this back as 80750003 with:
>   cat /sys/kernel/debug/clk/fin_pll/fout_epll/clk_rate
> 
> After this patch, it reads back as 80000003
> 
>   mw 0x10020130 a06b0204
>   mw 0x10020134 0000aaab
> 
> Signed-off-by: Doug Anderson <dianders@chromium.org>

Yeah,

Acked-by: Kukjin Kim <kgene.kim@samsung.com>

Mike, please apply in your fixes.

Thanks.

- Kukjin

> ---
> This patch is based upon another in-flight patch to avoid conflicts:
>   clk: samsung: Use clk->base instead of directly using clk->con0 for
> PLL3xxx
>   https://patchwork.kernel.org/patch/2629751/
> 
>  drivers/clk/samsung/clk-pll.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/clk/samsung/clk-pll.c b/drivers/clk/samsung/clk-pll.c
> index 01f17cf..26416bb 100644
> --- a/drivers/clk/samsung/clk-pll.c
> +++ b/drivers/clk/samsung/clk-pll.c
> @@ -115,7 +115,8 @@ static unsigned long
> samsung_pll36xx_recalc_rate(struct clk_hw *hw,
>  				unsigned long parent_rate)
>  {
>  	struct samsung_clk_pll *pll = to_clk_pll(hw);
> -	u32 mdiv, pdiv, sdiv, kdiv, pll_con0, pll_con1;
> +	u32 mdiv, pdiv, sdiv, pll_con0, pll_con1;
> +	s16 kdiv;
>  	u64 fvco = parent_rate;
> 
>  	pll_con0 = pll_readl(pll, PLL36XX_CON0_OFFSET);
> @@ -123,7 +124,7 @@ static unsigned long
> samsung_pll36xx_recalc_rate(struct clk_hw *hw,
>  	mdiv = (pll_con0 >> PLL36XX_MDIV_SHIFT) & PLL36XX_MDIV_MASK;
>  	pdiv = (pll_con0 >> PLL36XX_PDIV_SHIFT) & PLL36XX_PDIV_MASK;
>  	sdiv = (pll_con0 >> PLL36XX_SDIV_SHIFT) & PLL36XX_SDIV_MASK;
> -	kdiv = pll_con1 & PLL36XX_KDIV_MASK;
> +	kdiv = (s16)(pll_con1 & PLL36XX_KDIV_MASK);
> 
>  	fvco *= (mdiv << 16) + kdiv;
>  	do_div(fvco, (pdiv << sdiv));
> --
> 1.8.2.1


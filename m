Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310Ab3H0JaP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 05:30:15 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:11511 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752824Ab3H0JaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 05:30:12 -0400
X-AuditID: cbfec7f5-b7ef66d00000795a-a9-521c71a2b032
Message-id: <521C71A1.4070609@samsung.com>
Date: Tue, 27 Aug 2013 11:30:09 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-version: 1.0
To: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
Cc: linus.walleij@linaro.org, t.figa@samsung.com, thomas.abraham@linaro.org,
        kgene.kim@samsung.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH 1/4] pinctrl: Add s5pv210 support to pinctrl-exynos
References: <1377595171-31116-1-git-send-email-m.krawczuk@partner.samsung.com>
In-reply-to: <1377595171-31116-1-git-send-email-m.krawczuk@partner.samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrILMWRmVeSWpSXmKPExsVy+t/xK7qLCmWCDFqm2lj0LrjKZjHlz3Im
	i02Pr7FaXN41h81ixvl9TBan15xitlg/4zWLxbEZSxgdODzuXNvD5rF5Sb3HwXd7mDz6tqxi
	9Pi8SS6ANYrLJiU1J7MstUjfLoEr48G1qIJFXBW3N3QwNjCe4+hi5OSQEDCRmHbxDCuELSZx
	4d56ti5GLg4hgaWMEqfP32CFcD4xSix7+oUNpIpXQEti4vwT7CA2i4CqxO+PexlBbDYBQ4ne
	o31gtqhAgMTiJefYIeoFJX5MvscCYosImEq8u3sNbAOzwFlGiVfrO4ASHBzCAu4Spz7WgtQI
	CfhJ7L+zmQnE5hTwl3gw5xgziM0soCOxv3UaG4QtL7F5zVvmCYwCs5CsmIWkbBaSsgWMzKsY
	RVNLkwuKk9JzjfSKE3OLS/PS9ZLzczcxQoL96w7GpcesDjEKcDAq8fA+bJEOEmJNLCuuzD3E
	KMHBrCTCy3UHKMSbklhZlVqUH19UmpNafIiRiYNTqoFx8o9ZhrJMBgzXNVO3sXg5d095kPZa
	tXDi4Ymbq0Rat57P+1m7cdrrH4rHn3PNe1h8pmXie+XAhw+F6lLcRPp5RNIu5i3tvObZe3nz
	0RK7jgyX+C0LNkhvtRDNcN5md4RBROqHGL/m0Zesv6xiKt1zz8ryWUi2Xft6Xi7xV9vP2l6h
	Mmbz0FAlluKMREMt5qLiRACbOPt/VAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Just a few nits...

On 08/27/2013 11:19 AM, Mateusz Krawczuk wrote:
> This patch implements pinctrl for s5pv210 and adds required device tree bindings.

Would be good to wrap this to not exceed 80 columns.

> Signed-off-by: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
> ---
[...]
> diff --git a/drivers/pinctrl/pinctrl-exynos.c b/drivers/pinctrl/pinctrl-exynos.c
> index a74b3cb..fc3e1d7 100644
> --- a/drivers/pinctrl/pinctrl-exynos.c
> +++ b/drivers/pinctrl/pinctrl-exynos.c
> @@ -660,6 +660,64 @@ static void exynos_pinctrl_resume(struct samsung_pinctrl_drv_data *drvdata)
>  			exynos_pinctrl_resume_bank(drvdata, bank);
>  }
>  
> +/* pin banks of s5pv210 pin-controller */
> +static struct samsung_pin_bank s5pv210_pin_banks0[] = {

Couldn't it be 'static const' ?

> +	EXYNOS_PIN_BANK_EINTG(8, 0x000, "gpa0", 0x00),
> +	EXYNOS_PIN_BANK_EINTG(6, 0x020, "gpa1", 0x04),
> +	EXYNOS_PIN_BANK_EINTG(8, 0x040, "gpb", 0x08),
> +	EXYNOS_PIN_BANK_EINTG(5, 0x060, "gpc0", 0x0c),
> +	EXYNOS_PIN_BANK_EINTG(5, 0x080, "gpc1", 0x10),
> +	EXYNOS_PIN_BANK_EINTG(4, 0x0A0, "gpd0", 0x14),
> +	EXYNOS_PIN_BANK_EINTG(4, 0x0C0, "gpd1", 0x18),
> +	EXYNOS_PIN_BANK_EINTG(5, 0x0E0, "gpe0", 0x1c),

How about consistently using lower case for the hex numbers ?

--
Thanks,
Sylwester

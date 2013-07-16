Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758531Ab3GPBgd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 21:36:33 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:20509 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754395Ab3GPBga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 21:36:30 -0400
X-AuditID: cbfee68d-b7f096d0000043fc-ca-51e4a397ebfb
Message-id: <51E4A396.7010202@samsung.com>
Date: Tue, 16 Jul 2013 10:36:22 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130623
 Thunderbird/17.0.7
MIME-version: 1.0
To: Doug Anderson <dianders@chromium.org>
Cc: Chris Ball <cjb@laptop.org>, Olof Johansson <olof@lixom.net>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        James Hogan <james.hogan@imgtec.com>,
        Grant Grundler <grundler@chromium.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Kukjin Kim <kgene.kim@samsung.com>, linux-mmc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/5] mmc: dw_mmc: Add exynos resume_noirq callback to
 clear WAKEUP_INT
References: <1373411961-23812-1-git-send-email-dianders@chromium.org>
 <1373470926-19314-1-git-send-email-dianders@chromium.org>
 <1373470926-19314-4-git-send-email-dianders@chromium.org>
In-reply-to: <1373470926-19314-4-git-send-email-dianders@chromium.org>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGIsWRmVeSWpSXmKPExsWyRsSkWHf64ieBBueOaVo8XrOYyeLBvG1s
	Fttfb2SzOLvsIJvFqyM/mCzezXvBbHHjVxurRe+Cq2wWmx5fY7W4vGsOm8WR//2MFjPO72Oy
	OHX9M5vFh/sXmS1W7frD6MDvMbvhIovHzll32T16dp5h9Dh0ZS2jx+Yl9R5XTjSxevRtWcXo
	8XmTXABHFJdNSmpOZllqkb5dAlfG46vrGAs6hCsOLXnM3sA4j7+LkZNDQsBE4u6P2ewQtpjE
	hXvr2boYuTiEBJYySly6sIUZpmhi00RWiMQiRolpr2ZBVb1mlLh19R0jSBWvgJZEe/tWFhCb
	RUBVYsKWtUwgNpuAjsT2b8fBbFGBMIkl3x6zQdQLSvyYfA+sXkRAU+JZw0tmkKHMAm0sEn/f
	dYDdJCwQL9E1YzFYg5DAXkaJU3PqQGxOATeJd5t+gw1lBlqwv3UaG4QtL7F5zVuwQRICCzkk
	ut/vZ4O4SEDi2+RDQNs4gBKyEpsOQL0mKXFwxQ2WCYxis5DcNAvJ2FlIxi5gZF7FKJpakFxQ
	nJReZKhXnJhbXJqXrpecn7uJERjnp/89693BePuA9SHGZKCVE5mlRJPzgWkiryTe0NjMyMLU
	xNTYyNzSjDRhJXFetRbrQCGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2MV9qaf+7vtD3c0lab
	O/uBmsuq0vNSAX8SJJtnWq811/Rn7o5zfmr3odtd5Q2v+Om+KSy5aT731i/OnDLZZGfZrj7u
	tHs98/gO7XvyMGuL/b6fYdNb1to580ua7X8jI3j/HmvFsmitd4IJHNHz+bvO3XI42LOw7nca
	23vNHZdeb4/mW7F0yrRGJZbijERDLeai4kQAcM6aUQkDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMKsWRmVeSWpSXmKPExsVy+t9jAd3pi58EGjSvU7B4vGYxk8WDedvY
	LLa/3shmcXbZQTaLV0d+MFm8m/eC2eLGrzZWi94FV9ksNj2+xmpxedccNosj//sZLWac38dk
	cer6ZzaLD/cvMlus2vWH0YHfY3bDRRaPnbPusnv07DzD6HHoylpGj81L6j2unGhi9ejbsorR
	4/MmuQCOqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23
	zByg65UUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhDWMGY+vrmMs6BCuOLTk
	MXsD4zz+LkZODgkBE4mJTRNZIWwxiQv31rN1MXJxCAksYpSY9moWlPOaUeLW1XeMIFW8AloS
	7e1bWUBsFgFViQlb1jKB2GwCOhLbvx0Hs0UFwiSWfHvMBlEvKPFj8j2wehEBTYlnDS+ZQYYy
	C7SxSPx918EOkhAWiJfomrEYrEFIYC+jxKk5dSA2p4CbxLtNv8GGMgMt2N86jQ3ClpfYvOYt
	8wRGgVlIdsxCUjYLSdkCRuZVjKKpBckFxUnpuUZ6xYm5xaV56XrJ+bmbGMFJ5Jn0DsZVDRaH
	GAU4GJV4eA9yPgkUYk0sK67MPcQowcGsJMJrJwwU4k1JrKxKLcqPLyrNSS0+xJgMDIKJzFKi
	yfnABJdXEm9obGJmZGlkbmhhZGxOmrCSOO/BVutAIYH0xJLU7NTUgtQimC1MHJxSDYxlGdfL
	SuT8E7vdLt581nn590/d1PW/nmft/NI5S0FkN/s0J63ytXN57fqzklNXzJZausBjSYj1o8Vn
	cz4efV4wUyNEermvqMHCuJm8/sd8J+X1/HWYuNv1f3lh6oKtQgkSm2JqluXabuPtfjwjzVVG
	8feNvs/W9y/9fOLFaNhwuDCHn0v8ua4SS3FGoqEWc1FxIgAb4UqdZgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Doug,

I think these patch-set didn't base on latest mmc-next.
If you can rebase on latest mmc-next, it's helpful to me for testing.

Best Regards,
Jaehoon Chung

On 07/11/2013 12:42 AM, Doug Anderson wrote:
> If the WAKEUP_INT is asserted at wakeup and not cleared, we'll end up
> looping around forever.  This has been seen to happen on exynos5420
> silicon despite the fact that we haven't enabled any wakeup events.
> 
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> ---
> Changes in v3: None
> Changes in v2:
> - Use suspend_noirq as per James Hogan.
> 
>  drivers/mmc/host/dw_mmc-exynos.c | 23 +++++++++++++++++++++++
>  1 file changed, 23 insertions(+)
> 
> diff --git a/drivers/mmc/host/dw_mmc-exynos.c b/drivers/mmc/host/dw_mmc-exynos.c
> index f013e7e..36b9620 100644
> --- a/drivers/mmc/host/dw_mmc-exynos.c
> +++ b/drivers/mmc/host/dw_mmc-exynos.c
> @@ -30,6 +30,7 @@
>  #define SDMMC_CLKSEL_TIMING(x, y, z)	(SDMMC_CLKSEL_CCLK_SAMPLE(x) |	\
>  					SDMMC_CLKSEL_CCLK_DRIVE(y) |	\
>  					SDMMC_CLKSEL_CCLK_DIVIDER(z))
> +#define SDMMC_CLKSEL_WAKEUP_INT		BIT(11)
>  
>  #define SDMMC_CMD_USE_HOLD_REG		BIT(29)
>  
> @@ -102,6 +103,27 @@ static int dw_mci_exynos_setup_clock(struct dw_mci *host)
>  	return 0;
>  }
>  
> +/**
> + * dw_mci_exynos_resume_noirq - Exynos-specific resume code
> + *
> + * We have seen cases (at least on the exynos5420) where turning off the INT
> + * power rail during suspend will leave the WAKEUP_INT bit in the CLKSEL
> + * register asserted.  This bit is 1 to indicate that it fired and we can
> + * clear it by writing a 1 back.  Clear it to prevent interrupts from going off
> + * constantly.
> + */
> +
> +static int dw_mci_exynos_resume_noirq(struct dw_mci *host)
> +{
> +	u32 clksel;
> +
> +	clksel = mci_readl(host, CLKSEL);
> +	if (clksel & SDMMC_CLKSEL_WAKEUP_INT)
> +		mci_writel(host, CLKSEL, clksel);
> +
> +	return 0;
> +}
> +
>  static void dw_mci_exynos_prepare_command(struct dw_mci *host, u32 *cmdr)
>  {
>  	/*
> @@ -165,6 +187,7 @@ static const struct dw_mci_drv_data exynos_drv_data = {
>  	.caps			= exynos_dwmmc_caps,
>  	.init			= dw_mci_exynos_priv_init,
>  	.setup_clock		= dw_mci_exynos_setup_clock,
> +	.resume_noirq		= dw_mci_exynos_resume_noirq,
>  	.prepare_command	= dw_mci_exynos_prepare_command,
>  	.set_ios		= dw_mci_exynos_set_ios,
>  	.parse_dt		= dw_mci_exynos_parse_dt,
> 


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688AbaGNIFq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 04:05:46 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:9079 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960AbaGNIFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 04:05:32 -0400
X-AuditID: cbfee691-b7f2f6d0000040c4-40-53c38f49c8d9
Message-id: <53C38F49.7050504@samsung.com>
Date: Mon, 14 Jul 2014 17:05:29 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
MIME-version: 1.0
To: Tomasz Figa <t.figa@samsung.com>, linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, Ben Dooks <ben-linux@fluff.org>,
        Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>,
        linux-mmc@vger.kernel.org
Subject: Re: [PATCH 1/6] mmc: sdhci-s3c: Fix local I/O clock gating
References: <1403618235-19353-1-git-send-email-t.figa@samsung.com>
 <1403618235-19353-2-git-send-email-t.figa@samsung.com>
In-reply-to: <1403618235-19353-2-git-send-email-t.figa@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFIsWRmVeSWpSXmKPExsWyRsSkUNez/3CwwesmbYtJ6w4wWUy4vJ3R
	onfBVTaLTY+vsVpc3jWHzeLI/35Gixnn9zFZrD1yl91i/YzXLBardv1htDi+NtyB2+PvqhfM
	Hjtn3WX3uHNtD5vH5iX1HjdeLWTy6NuyitHj8ya5APYoLpuU1JzMstQifbsErowzE4QLmgQr
	Zh6+xt7A+Ii3i5GTQ0LARGLT/dvMELaYxIV769m6GLk4hASWMkrsXLCWBaao4d16FojEdEaJ
	/t2rGCGc14wSj+5vBGvnFdCS2HJrFpjNIqAq8aVjFSuIzSagI7H923EmEFtUIEziUNs8Joh6
	QYkfk+8BTeXgEBFwlzj3XAFkJrPAcSaJx72TwTYLCzhLLJ+7lh3EFhKolrgx4R4jiM0JFP+1
	/T4biM0MNH9/6zQoW15i85q3zCCDJAR+skucPHGHEeIgAYlvkw+BLZMQkJXYdADqZUmJgytu
	sExgFJuF5KRZSMbOQjJ2ASPzKkbR1ILkguKk9CJTveLE3OLSvHS95PzcTYzAeD3979nEHYz3
	D1gfYkwGWjmRWUo0OR8Y73kl8YbGZkYWpiamxkbmlmakCSuJ86Y/SgoSEkhPLEnNTk0tSC2K
	LyrNSS0+xMjEwSnVwGi+sHv2+YlPX5zdsPvWl/Nbfx18uJXf9UNvWuqzX4/NmDx6jl+W3brA
	WzN+/f0k7hlRz9atD7A23Dip+/CyxpkPDntZMKV9neaoX1zjdHP9AbtEX5l3qfrnt+k1p/zP
	sr8ZVSA5NaVg5dFbu3vDF51WWy91dFFsEuf12tdH5suc6/z2za2i1f6iEktxRqKhFnNRcSIA
	+Wy7/+0CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkleLIzCtJLcpLzFFi42I5/e+xoK5n/+Fgg8+XlSwmrTvAZDHh8nZG
	i94FV9ksNj2+xmpxedccNosj//sZLWac38dksfbIXXaL9TNes1is2vWH0eL42nAHbo+/q14w
	e+ycdZfd4861PWwem5fUe9x4tZDJo2/LKkaPz5vkAtijGhhtMlITU1KLFFLzkvNTMvPSbZW8
	g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4BuVFIoS8wpBQoFJBYXK+nbYZoQGuKmawHT
	GKHrGxIE12NkgAYS1jBmnJkgXNAkWDHz8DX2BsZHvF2MnBwSAiYSDe/Ws0DYYhIX7q1n62Lk
	4hASmM4o0b97FSOE85pR4tH9jcwgVbwCWhJbbs0Cs1kEVCW+dKxiBbHZBHQktn87zgRiiwqE
	SRxqm8cEUS8o8WPyPaANHBwiAu4S554rgMxkFjjOJPG4dzLYZmEBZ4nlc9eyg9hCAtUSNybc
	YwSxOYHiv7bfZwOxmYHm72+dBmXLS2xe85Z5AqPALCQrZiEpm4WkbAEj8ypG0dSC5ILipPRc
	Q73ixNzi0rx0veT83E2M4GTwTGoH48oGi0OMAhyMSjy8GRyHg4VYE8uKK3MPMUpwMCuJ8Ia7
	AYV4UxIrq1KL8uOLSnNSiw8xmgJDYCKzlGhyPjBR5ZXEGxqbmBlZGpkbWhgZmyuJ8x5otQ4U
	EkhPLEnNTk0tSC2C6WPi4JRqYHQ5ZHm4edkKpdbOz6vtvk5KD968SeC7EuMaho1nru/RM/v6
	hkVo2THHfdmpggoGvN8vXm77IbDg19rou0seXHz1Ufnw5BfW/65Y7BL84NRYen7L9IsLbjK9
	0JC5brL5zdKle24Um9vZq53hOXVs56yPd00rbHd6L7qndjZaru0zo8zDxnuPlT/WK7EUZyQa
	ajEXFScCAI8DPF0cAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good to me.

Acked-by: Jaehoon Chung <jh80.chung@samsung.com>

On 06/24/2014 10:57 PM, Tomasz Figa wrote:
> For internal card detection mechanism it is required that the local I/O
> clock is always running. However while current implementation accounts
> for this, it does so incorrectly leading to race conditions and warnings
> about unbalanced clock disables.
> 
> This patch fixes it by inverting the logic, which now increases local
> I/O clock enable count when internal card detect is used, instead of
> decreasing it otherwise.
> 
> Signed-off-by: Tomasz Figa <t.figa@samsung.com>
> Cc: Ben Dooks <ben-linux@fluff.org>
> Cc: Chris Ball <chris@printf.net>
> Cc: Ulf Hansson <ulf.hansson@linaro.org>
> Cc: linux-mmc@vger.kernel.org
> ---
>  drivers/mmc/host/sdhci-s3c.c | 17 ++++++++++-------
>  1 file changed, 10 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/mmc/host/sdhci-s3c.c b/drivers/mmc/host/sdhci-s3c.c
> index fa5954a..1795e1f 100644
> --- a/drivers/mmc/host/sdhci-s3c.c
> +++ b/drivers/mmc/host/sdhci-s3c.c
> @@ -487,8 +487,13 @@ static int sdhci_s3c_probe(struct platform_device *pdev)
>  		goto err_pdata_io_clk;
>  	}
>  
> -	/* enable the local io clock and keep it running for the moment. */
> -	clk_prepare_enable(sc->clk_io);
> +	/*
> +	 * Keep local I/O clock enabled for internal card detect pin
> +	 * or runtime PM is disabled.
> +	 */
> +	if (pdata->cd_type == S3C_SDHCI_CD_INTERNAL
> +	    || !IS_ENABLED(CONFIG_PM_RUNTIME))
> +		clk_prepare_enable(sc->clk_io);
>  
>  	for (clks = 0, ptr = 0; ptr < MAX_BUS_CLK; ptr++) {
>  		char name[14];
> @@ -611,15 +616,13 @@ static int sdhci_s3c_probe(struct platform_device *pdev)
>  		goto err_req_regs;
>  	}
>  
> -#ifdef CONFIG_PM_RUNTIME
> -	if (pdata->cd_type != S3C_SDHCI_CD_INTERNAL)
> -		clk_disable_unprepare(sc->clk_io);
> -#endif
>  	return 0;
>  
>   err_req_regs:
>   err_no_busclks:
> -	clk_disable_unprepare(sc->clk_io);
> +	if (pdata->cd_type == S3C_SDHCI_CD_INTERNAL
> +	    || !IS_ENABLED(CONFIG_PM_RUNTIME))
> +		clk_disable_unprepare(sc->clk_io);
>  
>   err_pdata_io_clk:
>  	sdhci_free_host(host);
> 


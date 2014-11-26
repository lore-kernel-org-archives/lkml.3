Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737AbaKZPyV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 10:54:21 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:8842 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbaKZPyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 10:54:20 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-a5-5475f7a93012
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: Stephen Boyd <sboyd@codeaurora.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] clk: qcom: fix driver dependencies
Date: Wed, 26 Nov 2014 16:54:13 +0100
Message-id: <2602622.MuWT6vUosD@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-70-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <2408462.Vr3YfHniN8@amdc1032>
References: <2408462.Vr3YfHniN8@amdc1032>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBLMWRmVeSWpSXmKPExsVy+t9jAd1V30tDDGY2sFmcbXrDbnF51xw2
	i6cTLrJZ/DjTzeLA4nG5r5fJ4861PWwefVtWMXp83iQXwBLFZZOSmpNZllqkb5fAldG99zB7
	wSzOinkTzrE1MJ5n72Lk5JAQMJG4vuURM4QtJnHh3nq2LkYuDiGBRYwSe1sesEM4LUwS7R//
	g1WxCVhJTGxfxQhiiwhoSWw70MoGYjMLFEksmfWTFcQWFjCXWLloAwuIzSKgKnHnyC8mEJtX
	QFOi/8hdsLiogKfEzukHwOZwAs053nkSbI4QUM32S0sZIeoFJX5MvscCMV9eYt/+qawQtpbE
	+p3HmSYwCsxCUjYLSdksJGULGJlXMYqmFiQXFCel5xrpFSfmFpfmpesl5+duYgSH7zPpHYyr
	GiwOMQpwMCrx8EZIlYYIsSaWFVfmHmKU4GBWEuHleAcU4k1JrKxKLcqPLyrNSS0+xCjNwaIk
	znvjZm6IkEB6YklqdmpqQWoRTJaJg1OqgbFNf//ZY+WrL+W5X461YBbt+m7SMomBy+PFKqO2
	Z5J3Av3fL3mkJ6py+AGzseubyosTJ+RwSBzx/nDdpuW29kqx8g9SCZONFskbLsz2kmD41CnD
	utVt28V9zl+CZ09iWLf9XlfrJ7c2z0lNV6Ym5pfZPjzrIbx156Np+zYaiz7rD7p4xOmpC6sS
	S3FGoqEWc1FxIgDxce3nWwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Mike,

Could you please apply this patch for 3.19?

It still applies fine to the current -next and I haven't got any
feedback for it since the initial posting in September.

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

On Monday, September 01, 2014 05:20:41 PM Bartlomiej Zolnierkiewicz wrote:
> Support for Qualcomm's clock controllers should be available only on
> Qualcomm platforms.
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Stephen Boyd <sboyd@codeaurora.org>
> ---
>  drivers/clk/qcom/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
> 
> Index: b/drivers/clk/qcom/Kconfig
> ===================================================================
> --- a/drivers/clk/qcom/Kconfig	2014-08-22 16:53:37.429123415 +0200
> +++ b/drivers/clk/qcom/Kconfig	2014-09-01 17:13:43.604778653 +0200
> @@ -1,6 +1,7 @@
>  config COMMON_CLK_QCOM
>  	tristate "Support for Qualcomm's clock controllers"
>  	depends on OF
> +	depends on ARCH_QCOM || COMPILE_TEST
>  	select REGMAP_MMIO
>  	select RESET_CONTROLLER


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923AbaJQI0q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 04:26:46 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:23143 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753898AbaJQI0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 04:26:42 -0400
X-AuditID: cbfee68f-f791c6d000004834-c5-5440d2c0d646
Message-id: <5440D2BF.8070702@samsung.com>
Date: Fri, 17 Oct 2014 17:26:39 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
MIME-version: 1.0
To: Sonny Rao <sonnyrao@chromium.org>, Alim Akhtar <alim.akhtar@gmail.com>,
        linux-mmc@vger.kernel.org
Cc: Heiko Stuebner <heiko@sntech.de>, Seungwon Jeon <tgih.jun@samsung.com>,
        Ulf Hansson <ulf.hansson@linaro.org>, dianders@chromium.org,
        eddie.cai@rock-chips.com, addy.ke@rock-chips.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mmc: dw_mmc: Reset DMA before enabling IDMAC
References: <1413478686-6857-1-git-send-email-sonnyrao@chromium.org>
In-reply-to: <1413478686-6857-1-git-send-email-sonnyrao@chromium.org>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCIsWRmVeSWpSXmKPExsWyRsSkRPfAJYcQg917eS2W/f/OZLH0VrXF
	2WUH2Sy+TDrJavH/0WtWi02Pr7FaXN41h83iyP9+RosnZ2YyWny4f5HZ4vjacAduj9kNF1k8
	ds66y+5x59oeNo/NS+o9/s7az+LRt2UVo8f2a/OYPT5vkgvgiOKySUnNySxLLdK3S+DKuLDg
	AHPBad6Km6e+sDQwdnJ3MXJySAiYSDxsfsIIYYtJXLi3nq2LkYtDSGApo8THlU8ZYYoWLe1l
	hUgsYpQ48+IYVNVrRonfvzYwgVTxCmhJ/Hq0GqyDRUBV4s7Vi8wgNpuAjsT2b8fBakQFwiQO
	tc2DqheU+DH5HguILSKQLvHvxWtmkKHMAs1MEg8PbAQbJCzgIvFi7kGwIiEg++DCCUDNHByc
	Aq4SD76XgoSZgebvb53GBmHLS2xe8xZsjoTAX3aJHc9usUAcJCDxbfIhFpBeCQFZiU0HmCE+
	k5Q4uOIGywRGsVlITpqFZOwsJGMXMDKvYhRNLUguKE5KLzLWK07MLS7NS9dLzs/dxAiM3NP/
	nvXvYLx7wPoQowAHoxIPL0OMQ4gQa2JZcWXuIUZToCsmMkuJJucD00NeSbyhsZmRhamJqbGR
	uaWZkjjvQqmfwUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoYI6MCGOarRV94NeXhYQe5opef
	nl9c+6Rk0ft/GTxbtr6IcZggZ+m3XnW7+IedGxqil89z/Wa/L38KL9M7vXmXsjhFFC2PFnMV
	X9v57fOrh1cnHDpr6yiyYGO2wbfZO19zT/ZrFtn4OKFG7tUvrW1ffq9hk700k21CiEP1NsOs
	g8sNzKdG74w9vUiJpTgj0VCLuag4EQBPCT021wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjleLIzCtJLcpLzFFi42I5/e+xgO6BSw4hBisus1gs+/+dyWLprWqL
	s8sOsll8mXSS1eL/o9esFpseX2O1uLxrDpvFkf/9jBZPzsxktPhw/yKzxfG14Q7cHrMbLrJ4
	7Jx1l93jzrU9bB6bl9R7/J21n8Wjb8sqRo/t1+Yxe3zeJBfAEdXAaJORmpiSWqSQmpecn5KZ
	l26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDdKeSQlliTilQKCCxuFhJ3w7ThNAQ
	N10LmMYIXd+QILgeIwM0kLCGMePCggPMBad5K26e+sLSwNjJ3cXIySEhYCKxaGkvK4QtJnHh
	3nq2LkYuDiGBRYwSZ14cg3JeM0r8/rWBCaSKV0BL4tej1YwgNouAqsSdqxeZQWw2AR2J7d+O
	g9WICoRJHGqbB1UvKPFj8j0WEFtEIF3i34vXzCBDmQWamSQeHtgINkhYwEXixdyDYEVCQPbB
	hROAmjk4OAVcJR58LwUJMwPN3986jQ3ClpfYvOYt8wRGgVlIVsxCUjYLSdkCRuZVjKKpBckF
	xUnpuUZ6xYm5xaV56XrJ+bmbGMFp4Zn0DsZVDRaHGAU4GJV4eBliHEKEWBPLiitzDzFKcDAr
	ifBqnwQK8aYkVlalFuXHF5XmpBYfYjQFhsBEZinR5HxgysoriTc0NjEzsjQyN7QwMjZXEuc9
	2GodKCSQnliSmp2aWpBaBNPHxMEp1cBYLXUwVOiroKO66LUzfS8fF2leSO82r9ZYO+3m/d9F
	O9fxXIv/1tca8vGwA+PKf+ez19XN3MS/sSrosHqbJ8u14/teH7mp0h95hz9k2bWFofKKf5wL
	3Nl/xS3eOsvMfVmHRO6fyMm+W+qOPzFJ8Pm95dHP1cc/Pmjni2z+FxWR8CxklV34+ysiSizF
	GYmGWsxFxYkAsGXYCiEDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Sonny.

On 10/17/2014 01:58 AM, Sonny Rao wrote:
> We've already got a reset of DMA after it's done.  Add one before we
> start DMA too.  This fixes a data corruption on Rockchip SoCs which
> will get bad data when doing a DMA transfer after doing a PIO transfer.
> 
> We tested this on an Exynos 5800 with HS200 and didn't notice any
> difference in sequential read throughput.

Didn't affect the write throughput?
I tested this on exynos3/4 with DDR50 and HS200.

Acked-by: Jaehoon Chung <jh80.chung@samsung.com>
Tested-by: Jaehoon Chung <jh80.chung@samsung.com>

> 
> Signed-off-by: Sonny Rao <sonnyrao@chromium.org>
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> Tested-by: Doug Anderson <dianders@chromium.org>
> ---
>  drivers/mmc/host/dw_mmc.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
> index 69f0cc6..ca67f69 100644
> --- a/drivers/mmc/host/dw_mmc.c
> +++ b/drivers/mmc/host/dw_mmc.c
> @@ -83,6 +83,7 @@ struct idmac_desc {
>  #endif /* CONFIG_MMC_DW_IDMAC */
>  
>  static bool dw_mci_reset(struct dw_mci *host);
> +static bool dw_mci_ctrl_reset(struct dw_mci *host, u32 reset);
>  
>  #if defined(CONFIG_DEBUG_FS)
>  static int dw_mci_req_show(struct seq_file *s, void *v)
> @@ -448,6 +449,10 @@ static void dw_mci_idmac_start_dma(struct dw_mci *host, unsigned int sg_len)
>  
>  	dw_mci_translate_sglist(host, host->data, sg_len);
>  
> +	/* Make sure to reset DMA in case we did PIO before this */
> +	dw_mci_ctrl_reset(host, SDMMC_CTRL_DMA_RESET);
> +	dw_mci_idmac_reset(host);
> +
>  	/* Select IDMAC interface */
>  	temp = mci_readl(host, CTRL);
>  	temp |= SDMMC_CTRL_USE_IDMAC;
> 


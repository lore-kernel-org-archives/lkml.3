Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836Ab3GARUw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 13:20:52 -0400
Received: from eu1sys200aog111.obsmtp.com ([207.126.144.131]:44988 "EHLO
	eu1sys200aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751889Ab3GARUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 13:20:49 -0400
Message-ID: <51D1BA65.5000406@st.com>
Date: Mon, 01 Jul 2013 19:20:37 +0200
From: Giuseppe CAVALLARO <peppe.cavallaro@st.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Cc: netdev@vger.kernel.org, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC 1/3] dt:net:stmmac: Allocate platform data only if
 its NULL.
References: <1372678962-12959-1-git-send-email-srinivas.kandagatla@st.com> <1372679024-13089-1-git-send-email-srinivas.kandagatla@st.com>
In-Reply-To: <1372679024-13089-1-git-send-email-srinivas.kandagatla@st.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/1/2013 1:43 PM, Srinivas KANDAGATLA wrote:
> From: Srinivas Kandagatla <srinivas.kandagatla@st.com>
>
> In some DT use-cases platform data might be already allocated and passed
> via AUXDATA. These are the cases where machine level code populates few
> callbacks in the platform data.
>
> This patch adds check and reuses platform_data if its valid, before
> allocating a new one.

Yes, we had seen this long time ago and IIRC i prepared the patch
so

Acked-by: Giuseppe Cavallaro <peppe.cavallaro@st.com>

>
> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
> ---
>   .../net/ethernet/stmicro/stmmac/stmmac_platform.c  |    6 +++---
>   1 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
> index 1d3780f..5907920 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
> @@ -92,8 +92,10 @@ static int stmmac_pltfr_probe(struct platform_device *pdev)
>   	if (IS_ERR(addr))
>   		return PTR_ERR(addr);
>
> +	plat_dat = pdev->dev.platform_data;
>   	if (pdev->dev.of_node) {
> -		plat_dat = devm_kzalloc(&pdev->dev,
> +		if (!plat_dat)
> +			plat_dat = devm_kzalloc(&pdev->dev,
>   					sizeof(struct plat_stmmacenet_data),
>   					GFP_KERNEL);
>   		if (!plat_dat) {
> @@ -106,8 +108,6 @@ static int stmmac_pltfr_probe(struct platform_device *pdev)
>   			pr_err("%s: main dt probe failed", __func__);
>   			return ret;
>   		}
> -	} else {
> -		plat_dat = pdev->dev.platform_data;
>   	}
>
>   	/* Custom initialisation (if needed)*/
>


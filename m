Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757120Ab3BAOk2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 09:40:28 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:26423 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756059Ab3BAOk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 09:40:26 -0500
X-AuditID: cbfec7f4-b7f6d6d000001620-ca-510bd3d83a85
Message-id: <510BD3D7.1090302@samsung.com>
Date: Fri, 01 Feb 2013 15:40:23 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130107
 Thunderbird/17.0.2
MIME-version: 1.0
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Chris Ball <cjb@laptop.org>,
        Kevin Liu <keyuan.liu@gmail.com>
Subject: Re: [PATCH 3/3] mmc: sdhci: check voltage range only on regulators
 aware of voltage value
References: <1354629663-29091-1-git-send-email-m.szyprowski@samsung.com>
 <1354629663-29091-4-git-send-email-m.szyprowski@samsung.com>
In-reply-to: <1354629663-29091-4-git-send-email-m.szyprowski@samsung.com>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprELMWRmVeSWpSXmKPExsVy+t/xa7o3LnMHGqw6Ym1xedccNosj//sZ
	HZg8Pm+SC2CM4rJJSc3JLEst0rdL4MrY27mDveAlV8WxBe9YGhjvcHQxcnJICJhInO2dwQRh
	i0lcuLeerYuRi0NIYCmjxP6lX9hBEkICzUwSqw6wgti8AloSs25OZAaxWQRUJZY+PwxWwyZg
	KNH1tosNxBYVCJVYu28NM0S9oMSPyfdYQGwRAX2J7rYrjCALmAV+MkpMnPQYrEhYIEVixsKt
	jBCb2xklPmy5A5bgFPCUaHtyEqybWcBM4lHLOmYIW15i85q3zBMYBWYhWTILSdksJGULGJlX
	MYqmliYXFCel5xrqFSfmFpfmpesl5+duYoSE45cdjIuPWR1iFOBgVOLhPfmTK1CINbGsuDL3
	EKMEB7OSCK9tLXegEG9KYmVValF+fFFpTmrxIUYmDk6pBsYywwrr9/Fhx1OTD319x7Wec67q
	7pk/5yw/tjRc9ZqXyK2Tf5TZxWIF5kyasYTdpXBmpchUB8tK1Q/Xl97T3N2T4ew+9Y5WuO2s
	WXttZ13dx7nrwvfngrWXNNdofn4ieJopcSsXK/OH0M2XQm28QoRux31j/vu8L3lnv+vMu3nB
	U6aIzjRI2PBFiaU4I9FQi7moOBEAH4mvliUCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 12/4/2012 3:01 PM, Marek Szyprowski wrote:
> Some regulators don't report any voltage values, so checking supported
> voltage range results in disabling all SDHCI_CAN_VDD_* flags and
> registration failure. This patch finally provides a correct fix for the
> registration of SDHCI driver with all possible voltage regulators:
> dummy, fixed and regulated without using regulator_count_voltages()
> hacks.
>
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>

Any chance to get this patch scheduled for v3.9?

> ---
>   drivers/mmc/host/sdhci.c |    6 +++++-
>   1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
> index a9ad2cd..d244dc0 100644
> --- a/drivers/mmc/host/sdhci.c
> +++ b/drivers/mmc/host/sdhci.c
> @@ -2930,7 +2930,11 @@ int sdhci_add_host(struct sdhci_host *host)
>   	}
>   
>   #ifdef CONFIG_REGULATOR
> -	if (host->vmmc && regulator_count_voltages(host->vmmc) > 1) {
> +	/*
> +	 * Voltage range check makes sense only if regulator reports
> +	 * any voltage value.
> +	 */
> +	if (host->vmmc && regulator_get_voltage(host->vmmc) > 0) {
>   		ret = regulator_is_supported_voltage(host->vmmc, 2700000,
>   			3600000);
>   		if ((ret <= 0) || (!(caps[0] & SDHCI_CAN_VDD_330)))

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center



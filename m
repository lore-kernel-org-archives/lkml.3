Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757078Ab3BAOjw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 09:39:52 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:26376 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756059Ab3BAOjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 09:39:49 -0500
X-AuditID: cbfec7f4-b7f6d6d000001620-35-510bd3b3977e
Message-id: <510BD3B1.3040601@samsung.com>
Date: Fri, 01 Feb 2013 15:39:45 +0100
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
Subject: Re: [PATCH 2/3] mmc: use regulator_can_change_voltage() instead of
 regulator_count_voltages() hacks
References: <1354629663-29091-1-git-send-email-m.szyprowski@samsung.com>
 <1354629663-29091-3-git-send-email-m.szyprowski@samsung.com>
In-reply-to: <1354629663-29091-3-git-send-email-m.szyprowski@samsung.com>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprELMWRmVeSWpSXmKPExsVy+t/xq7qbL3MHGhxs0ba4vGsOm8WR//2M
	DkwenzfJBTBGcdmkpOZklqUW6dslcGV8PPaOuWAlV0Xf8Tb2BsZVHF2MnBwSAiYSvad+sUPY
	YhIX7q1n62Lk4hASWMoosezVckYIp5lJYsaUOSwgVbwCWhK3btxlBLFZBFQldu45BtbNJmAo
	0fW2iw3EFhUIlVi7bw0zRL2gxI/J98B6RQT0JbrbroANZRb4ySgxcdJjsCJhgTyJj+c+gQ0V
	EmhnlJiwWwfE5hTwlJix7RFYM7OAmcSjlnXMELa8xOY1b5knMArMQrJjFpKyWUjKFjAyr2IU
	TS1NLihOSs811CtOzC0uzUvXS87P3cQICccvOxgXH7M6xCjAwajEw3vyJ1egEGtiWXFl7iFG
	CQ5mJRFe21ruQCHelMTKqtSi/Pii0pzU4kOMTBycUg2MZelb1ycKfv61SCFii4lgpZFXzdP/
	3w9yJP2TE17jszFD4em04i9WNWpfb33OfiLNqn1nq9icKTNvvF3Wc/xmiPsX3R/c6/2ObV0p
	M9Ox21HqWOWS94asiXXpqrslLjQY8pq/3mD+pD8n7+qBxqv/F3CU/ZxaKfeZz3QOh5O4GOPG
	XyqKm1UvKrEUZyQaajEXFScCAIonzMMlAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 12/4/2012 3:01 PM, Marek Szyprowski wrote:
> mmc_regulator_set_ocr() depends on the ability of regulator to change the
> voltage value. When regulator cannot change its voltage output, some code is
> skipped to avoid reporting false errors on some boards, which use MMC hosts
> with fixed regulators (example: Samsung Goni and UniversalC210 boards).
>
> This patch replaces a hacky workaround based on regulator_count_voltages()
> value with the correct call to recently introduced
> regulator_can_change_voltage() function in regulators core.
>
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>

Any chance to get this patch scheduled for v3.9?

> ---
>   drivers/mmc/core/core.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
> index aaed768..f5a0493 100644
> --- a/drivers/mmc/core/core.c
> +++ b/drivers/mmc/core/core.c
> @@ -1137,7 +1137,7 @@ int mmc_regulator_set_ocr(struct mmc_host *mmc,
>   		 */
>   		voltage = regulator_get_voltage(supply);
>   
> -		if (regulator_count_voltages(supply) == 1)
> +		if (!regulator_can_change_voltage(supply))
>   			min_uV = max_uV = voltage;
>   
>   		if (voltage < 0)

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center



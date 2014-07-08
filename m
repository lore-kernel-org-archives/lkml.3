Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754288AbaGHOcO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 10:32:14 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:27594 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753811AbaGHOcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 10:32:10 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-43-53bc00e88c36
Message-id: <53BC00C8.4000204@samsung.com>
Date: Tue, 08 Jul 2014 16:31:36 +0200
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Pankaj Dubey <pankaj.dubey@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, vikas.sajjan@samsung.com,
        joshi@samsung.com, naushad@samsung.com, thomas.ab@samsung.com,
        chow.kim@samsung.com
Subject: Re: [PATCH v6 3/4] ARM: EXYNOS: Add platform driver support for Exynos
 PMU
References: <1404710376-16448-1-git-send-email-pankaj.dubey@samsung.com>
 <1404710376-16448-4-git-send-email-pankaj.dubey@samsung.com>
In-reply-to: <1404710376-16448-4-git-send-email-pankaj.dubey@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBLMWRmVeSWpSXmKPExsVy+t/xq7ovGPYEG3zeoGSxbNJdNovvu76w
	W/QuuMpmsenxNVaLy7vmsFnMOL+PyeL2ZV6LT0f/s1os2gpU0bGM0eLms+1MDtweLc09bB6b
	l9R79G1ZxejxeZNcAEsUl01Kak5mWWqRvl0CV8bm5q1MBY/ZKo5M38jcwLiatYuRk0NCwETi
	8KYVbBC2mMSFe+uBbC4OIYGljBJ3d92Acj4zSuzbso0RpIpXQEti1a2FTCA2i4CqxOpNV8Em
	sQmoSXxueAQ2iR+oZk3TdZYuRg4OUYEIiccXhCBaBSV+TL7HAjJTRGAao8TFS7fZQRxmgSWM
	EntmnAJbICwQKrF06UZmiM3tjBLbn/wAS3AKeEosWb+cBcRmFtCR2N86jQ3ClpfYvOYt8wRG
	wVlItsxCUjYLSdkCRuZVjKKppckFxUnpuUZ6xYm5xaV56XrJ+bmbGCGx8XUH49JjVocYBTgY
	lXh4Dc7vDhZiTSwrrsw9xCjBwawkwvvlFFCINyWxsiq1KD++qDQntfgQIxMHp1QDYx9Lwf93
	2xZ07pj0kPuN46YIN1lJ+curW37+9db6sVV4xemLX+WerT5ZdqgqRl0mUeeV9cXsA0fcgjdl
	JJhVrVdhCe59Pnl9+znnuSu8uNiYLnifqJh4oXNqdnNZyXv7BP/nG9TOsqpdPSd41N1s2+3Z
	4Xtu7byfV7zt/RdJrhPNJYHZSTvLXiqxFGckGmoxFxUnAgDCueh9awIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pankaj,

Just one comment I already had to previous version.

On 07.07.2014 07:19, Pankaj Dubey wrote:

[snip]

> -static void exynos5_init_pmu(void)
> +static void exynos5_powerdown_conf(enum sys_powerdown mode)
>  {
>  	unsigned int i;
>  	unsigned int tmp;
> @@ -382,51 +398,143 @@ void exynos_sys_powerdown_conf(enum sys_powerdown mode)
>  {
>  	unsigned int i;
>  
> -	if (soc_is_exynos5250())
> -		exynos5_init_pmu();
> +	const struct exynos_pmu_data *pmu_data = pmu_context->pmu_data;
> +
> +	if (!pmu_data)
> +		return;

As I mentioned in my reply to previous version, I don't think there is
any point in probing this driver when there is no pmu_data. AFAIK the
generic syscon driver can take over in such case.

After fixing this, feel free to add

Reviewed-by: Tomasz Figa <t.figa@samsung.com>

--
Best regards,
Tomasz

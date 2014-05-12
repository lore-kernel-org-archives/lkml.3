Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758759AbaELPHc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 11:07:32 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:37464 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754881AbaELPHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 11:07:30 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f5-b7fae6d000004d6d-22-5370e3b04132
Content-transfer-encoding: 8BIT
Message-id: <5370E3AB.7090306@samsung.com>
Date: Mon, 12 May 2014 17:07:23 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
To: =?UTF-8?B?QW50b2luZSBUw6luYXJ0?= 
	<antoine.tenart@free-electrons.com>
Cc: kgene.kim@samsung.com, kishon@ti.com, sylvester.nawrocki@gmail.com,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] phy: exynos-mipi-video: fix check on array index
References: <1399899388-13101-1-git-send-email-antoine.tenart@free-electrons.com>
In-reply-to: <1399899388-13101-1-git-send-email-antoine.tenart@free-electrons.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrALMWRmVeSWpSXmKPExsVy+t/xK7obHhcEG/w+zmGxY8V/VoveBVfZ
	LC487WGz2PT4GqvF5V1z2CxmnN/HZDHv804mB3aPJ5suMnrsnHWX3WPzknqPvi2rGD2O39jO
	5PF5k1wAWxSXTUpqTmZZapG+XQJXRvO9g0wFRzgqnl3cy9bAOIu9i5GTQ0LAROLHizNMELaY
	xIV769m6GLk4hASWMkp8nXOTDSTBKyAo8WPyPZYuRg4OZgF5iSOXskHCzALqEpPmLWKGqP/E
	KPGwcSkLRL2WxOoH+xhBbBYBVYkjXy6BLWATMJToPdrHCDJHVCBC4vEFIZCwiICHxJyuRSwg
	c5gFNjJK7Hg8H+w4YQFXifuntrKC2EICwRITlpxmBrE5BUIkzh/oZJrAKDALyXmzEM6bheS8
	BYzMqxhFU0uTC4qT0nON9IoTc4tL89L1kvNzNzFCQv3rDsalx6wOMQpwMCrx8HowFwQLsSaW
	FVfmHmKU4GBWEuFVug0U4k1JrKxKLcqPLyrNSS0+xMjEwSnVwJhup/trkclZRqc9BSEsvnaT
	JCft4uh3vu51bNfuHZefPFqYdM9L0cvOWf3+qaasnO4aRsV63aVbPsysC9O5cuvljaZNAhHx
	YZ/WVD1r0Nmz8qtcut0VQcE7zwNrbz+9/P5o9MH+KeVflLVCdvkscP6zoH7NlCSFWkaugJ+v
	5FpuGk1I9Eh9vFqJpTgj0VCLuag4EQARkKt2UwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05/14 14:56, Antoine Ténart wrote:
> The phys array is of size EXYNOS_MIPI_PHYS_NUM. Trying to access the
> index EXYNOS_MIPI_PHYS_NUM should return an error.
> 
> Fixes: 069d2e26e9d6 "phy: Add driver for Exynos MIPI CSIS/DSIM DPHYs"
> 
> Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>

Thanks for the fix,

Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

> ---
>  drivers/phy/phy-exynos-mipi-video.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/phy/phy-exynos-mipi-video.c b/drivers/phy/phy-exynos-mipi-video.c
> index 7f139326a642..ff026689358c 100644
> --- a/drivers/phy/phy-exynos-mipi-video.c
> +++ b/drivers/phy/phy-exynos-mipi-video.c
> @@ -101,7 +101,7 @@ static struct phy *exynos_mipi_video_phy_xlate(struct device *dev,
>  {
>  	struct exynos_mipi_video_phy *state = dev_get_drvdata(dev);
>  
> -	if (WARN_ON(args->args[0] > EXYNOS_MIPI_PHYS_NUM))
> +	if (WARN_ON(args->args[0] >= EXYNOS_MIPI_PHYS_NUM))
>  		return ERR_PTR(-ENODEV);
>  
>  	return state->phys[args->args[0]].phy;

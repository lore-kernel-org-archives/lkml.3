Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751406Ab3LJXrz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 18:47:55 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:39885 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965Ab3LJXrx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 18:47:53 -0500
Message-ID: <52A7A827.3030607@codeaurora.org>
Date: Tue, 10 Dec 2013 15:47:51 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Chris Ball <cjb@laptop.org>
CC: David Brown <davidb@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/5] mmc: msm_sdcc: Limit driver to platforms that use
 it
References: <1386185952-27259-1-git-send-email-sboyd@codeaurora.org> <1386185952-27259-2-git-send-email-sboyd@codeaurora.org>
In-Reply-To: <1386185952-27259-2-git-send-email-sboyd@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/04/13 11:39, Stephen Boyd wrote:
> The msm_sdcc driver uses mach specific dma APIs. This is not
> compatible with the multi-platform ARM effort. Let's only compile
> this driver on MSM devices that are prepared to support it,
> allowing the DT based MSM devices to enter the multi-platform ARM
> build.
>
> Cc: Chris Ball <cjb@laptop.org>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---

Chris, can you please ack/review this change?

>  drivers/mmc/host/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
> index 7fc5099..4e8ca9d 100644
> --- a/drivers/mmc/host/Kconfig
> +++ b/drivers/mmc/host/Kconfig
> @@ -324,7 +324,7 @@ config MMC_ATMELMCI
>  
>  config MMC_MSM
>  	tristate "Qualcomm SDCC Controller Support"
> -	depends on MMC && ARCH_MSM
> +	depends on MMC && (ARCH_MSM7X00A || ARCH_MSM7X30 || ARCH_QSD8X50)
>  	help
>  	  This provides support for the SD/MMC cell found in the
>  	  MSM and QSD SOCs from Qualcomm. The controller also has


-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936630AbaBDXKA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 18:10:00 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:33639 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933694AbaBDXJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 18:09:57 -0500
Date: Tue, 4 Feb 2014 15:09:56 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
To: Kumar Gala <galak@codeaurora.org>
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, daniel.lezcano@linaro.org
Subject: Re: [PATCH v2 2/5] clocksource: qcom: Move clocksource code out of
 mach-msm
Message-ID: <20140204230956.GE20528@codeaurora.org>
References: <1391553532-27001-1-git-send-email-galak@codeaurora.org>
 <1391553532-27001-3-git-send-email-galak@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391553532-27001-3-git-send-email-galak@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04, Kumar Gala wrote:
> We intent to share the clocksource code for MSM platforms between legacy

s/intent/intend/

> and multiplatform supported qcom SoCs.
> 
> Acked-by: Olof Johansson <olof@lixom.net>
> Signed-off-by: Kumar Gala <galak@codeaurora.org>

> diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
> index cd6950f..81caa16 100644
> --- a/drivers/clocksource/Kconfig
> +++ b/drivers/clocksource/Kconfig
> @@ -140,3 +140,7 @@ config VF_PIT_TIMER
>  	bool
>  	help
>  	  Support for Period Interrupt Timer on Freescale Vybrid Family SoCs.
> +
> +config CLKSRC_QCOM
> +	bool
> +	depends on ARCH_MSM

It would be a a little less noisy if  you left this as MSM_TIMER
(msm is all over the code in that file anyway). Also, why do we
care about depending on ARCH_MSM here? This is a hidden Kconfig
option anyway.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

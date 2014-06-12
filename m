Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932940AbaFLI76 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 04:59:58 -0400
Received: from mail-qc0-f171.google.com ([209.85.216.171]:43003 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932680AbaFLI74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 04:59:56 -0400
MIME-Version: 1.0
In-Reply-To: <1402424839-25514-1-git-send-email-sboyd@codeaurora.org>
References: <1402424839-25514-1-git-send-email-sboyd@codeaurora.org>
Date: Thu, 12 Jun 2014 10:59:55 +0200
Message-ID: <CAPDyKFrK9daz4BvfmggLiGRfndxi24+Kqb=qVT2VFaf9XtTg0A@mail.gmail.com>
Subject: Re: [PATCH] mmc: sdhci-msm: Fix fallout from sdhci refactoring
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Chris Ball <chris@printf.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Kevin Hilman <khilman@linaro.org>, Georgi Djakov <gdjakov@mm-sol.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 June 2014 20:27, Stephen Boyd <sboyd@codeaurora.org> wrote:
> The sdhci core was refactored recently and some of those
> refactorings required changes in every sdhci platform driver.
> Those updates happened around the same time as when the msm
> driver was merged so the refactorings missed the msm driver.
> Hook in the basic library functions so that we can boot apq8074
> dragonboards again instead of crashing when we try to jump to
> NULL function pointers.
>
> Reported-by: Kevin Hilman <khilman@linaro.org>
> Cc: Georgi Djakov <gdjakov@mm-sol.com>
> Cc: Russell King <rmk+kernel@arm.linux.org.uk>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>

Thanks!

Applied for fixes.

Kind regards
Uffe

> ---
>
> Patch based on next-20140610
>
>  drivers/mmc/host/sdhci-msm.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/drivers/mmc/host/sdhci-msm.c b/drivers/mmc/host/sdhci-msm.c
> index acb0e9eb55f1..40573a58486a 100644
> --- a/drivers/mmc/host/sdhci-msm.c
> +++ b/drivers/mmc/host/sdhci-msm.c
> @@ -468,6 +468,10 @@ MODULE_DEVICE_TABLE(of, sdhci_msm_dt_match);
>
>  static struct sdhci_ops sdhci_msm_ops = {
>         .platform_execute_tuning = sdhci_msm_execute_tuning,
> +       .reset = sdhci_reset,
> +       .set_clock = sdhci_set_clock,
> +       .set_bus_width = sdhci_set_bus_width,
> +       .set_uhs_signaling = sdhci_set_uhs_signaling,
>  };
>
>  static int sdhci_msm_probe(struct platform_device *pdev)
> --
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> hosted by The Linux Foundation
>

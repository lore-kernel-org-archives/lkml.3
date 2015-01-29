Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762310AbbA2K2z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 05:28:55 -0500
Received: from mail-qg0-f51.google.com ([209.85.192.51]:63212 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753280AbbA2K2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 05:28:53 -0500
MIME-Version: 1.0
In-Reply-To: <1422524532-4275-1-git-send-email-jszhang@marvell.com>
References: <1422524532-4275-1-git-send-email-jszhang@marvell.com>
Date: Thu, 29 Jan 2015 11:28:53 +0100
Message-ID: <CAPDyKFq_nkPNdmUc0gxhEffDYDdPmunHgqPGUsfax=BtyUjPTw@mail.gmail.com>
Subject: Re: [PATCH] mmc: sdhci: switch voltage before sdhci_set_ios in
 runtime resume
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Jisheng Zhang <jszhang@marvell.com>
Cc: Chris Ball <chris@printf.net>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29 January 2015 at 10:42, Jisheng Zhang <jszhang@marvell.com> wrote:
> I observed the Host Control2 register isn't correctly restored
> after runtime resuming on BG2Q. For example, the register reads
> as 0x800c before runtime suspend, but it's set as 0x8004 after runtime
> resuming. This could results in a non working host.
>
> The reason is the Host Control2 is incorrectly reset when switching
> voltage. We fix this by following the same sequence during initialization.
>
> Signed-off-by: Jisheng Zhang <jszhang@marvell.com>

Thanks! Applied for next.

Kind regards
Uffe

> ---
>  drivers/mmc/host/sdhci.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
> index c9881ca..0ad412a 100644
> --- a/drivers/mmc/host/sdhci.c
> +++ b/drivers/mmc/host/sdhci.c
> @@ -2871,9 +2871,9 @@ int sdhci_runtime_resume_host(struct sdhci_host *host)
>         /* Force clock and power re-program */
>         host->pwr = 0;
>         host->clock = 0;
> +       sdhci_do_start_signal_voltage_switch(host, &host->mmc->ios);
>         sdhci_do_set_ios(host, &host->mmc->ios);
>
> -       sdhci_do_start_signal_voltage_switch(host, &host->mmc->ios);
>         if ((host_flags & SDHCI_PV_ENABLED) &&
>                 !(host->quirks2 & SDHCI_QUIRK2_PRESET_VALUE_BROKEN)) {
>                 spin_lock_irqsave(&host->lock, flags);
> --
> 2.1.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

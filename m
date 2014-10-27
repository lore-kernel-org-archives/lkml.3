Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194AbaJ0Njp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 09:39:45 -0400
Received: from mail-qa0-f51.google.com ([209.85.216.51]:55576 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752562AbaJ0Njn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 09:39:43 -0400
MIME-Version: 1.0
In-Reply-To: <1413883364-681-6-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1413883364-681-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<1413883364-681-6-git-send-email-sebastian.hesselbarth@gmail.com>
Date: Mon, 27 Oct 2014 14:39:42 +0100
Message-ID: <CAPDyKFqn2=rm8ROGBuvYuBscd6oNuOGLk=Z6pmW0Q3GqfPBzVQ@mail.gmail.com>
Subject: Re: [PATCH RESEND 05/12] mmc: sdhci-pxav3: Remove checks for
 mandatory host clock
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Chris Ball <chris@printf.net>,
        =?UTF-8?Q?Antoine_T=C3=A9nart?= <antoine.tenart@free-electrons.com>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 October 2014 11:22, Sebastian Hesselbarth
<sebastian.hesselbarth@gmail.com> wrote:
> NULL-checking a struct clk it not only wrong but also not required as
> for PXAv3 driver the corresponding clock is mandatory. Remove the
> checks from sdhci_pxav3_runtime_{suspend,resume}.
>
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>

Thanks! Applied for next!

Kind regards
Uffe


> ---
> Cc: Chris Ball <chris@printf.net>
> Cc: Ulf Hansson <ulf.hansson@linaro.org>
> Cc: "Antoine Ténart" <antoine.tenart@free-electrons.com>
> Cc: linux-mmc@vger.kernel.org
> Cc: devicetree@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  drivers/mmc/host/sdhci-pxav3.c | 20 ++++++++------------
>  1 file changed, 8 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/mmc/host/sdhci-pxav3.c b/drivers/mmc/host/sdhci-pxav3.c
> index d1f63d32b2cd..e52bbbb09d88 100644
> --- a/drivers/mmc/host/sdhci-pxav3.c
> +++ b/drivers/mmc/host/sdhci-pxav3.c
> @@ -448,13 +448,11 @@ static int sdhci_pxav3_runtime_suspend(struct device *dev)
>         struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
>         unsigned long flags;
>
> -       if (pltfm_host->clk) {
> -               spin_lock_irqsave(&host->lock, flags);
> -               host->runtime_suspended = true;
> -               spin_unlock_irqrestore(&host->lock, flags);
> +       spin_lock_irqsave(&host->lock, flags);
> +       host->runtime_suspended = true;
> +       spin_unlock_irqrestore(&host->lock, flags);
>
> -               clk_disable_unprepare(pltfm_host->clk);
> -       }
> +       clk_disable_unprepare(pltfm_host->clk);
>
>         return 0;
>  }
> @@ -465,13 +463,11 @@ static int sdhci_pxav3_runtime_resume(struct device *dev)
>         struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
>         unsigned long flags;
>
> -       if (pltfm_host->clk) {
> -               clk_prepare_enable(pltfm_host->clk);
> +       clk_prepare_enable(pltfm_host->clk);
>
> -               spin_lock_irqsave(&host->lock, flags);
> -               host->runtime_suspended = false;
> -               spin_unlock_irqrestore(&host->lock, flags);
> -       }
> +       spin_lock_irqsave(&host->lock, flags);
> +       host->runtime_suspended = false;
> +       spin_unlock_irqrestore(&host->lock, flags);
>
>         return 0;
>  }
> --
> 2.1.1
>

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164Ab3J0M5D (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 08:57:03 -0400
Received: from void.printf.net ([89.145.121.20]:60984 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753161Ab3J0M5A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 08:57:00 -0400
From: Chris Ball <cjb@laptop.org>
To: Thierry Reding <thierry.reding@gmail.com>,
        Jeremie Samuel <jeremie.samuel.ext@parrot.com>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mmc: sdhci: dove: Fix build breakage
References: <1382533832-21085-1-git-send-email-treding@nvidia.com>
Date: Sun, 27 Oct 2013 08:56:55 -0400
In-Reply-To: <1382533832-21085-1-git-send-email-treding@nvidia.com> (Thierry
	Reding's message of "Wed, 23 Oct 2013 15:10:32 +0200")
Message-ID: <87ppqqkh2g.fsf@octavius.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Oct 23 2013, Thierry Reding wrote:
> Commit 2d7c51f (mmc: sdhci: Use work structs instead of tasklets)
> converts tasklets to work structs, but typos the conversion in the Dove
> driver.
>
> Signed-off-by: Thierry Reding <treding@nvidia.com>
> ---
>  drivers/mmc/host/sdhci-dove.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/mmc/host/sdhci-dove.c b/drivers/mmc/host/sdhci-dove.c
> index 45c7f25..95f1076 100644
> --- a/drivers/mmc/host/sdhci-dove.c
> +++ b/drivers/mmc/host/sdhci-dove.c
> @@ -39,7 +39,7 @@ static irqreturn_t sdhci_dove_carddetect_irq(int irq, void *data)
>  {
>  	struct sdhci_host *host = data;
>  
> -	schedule_schedule(&host->card_detect_work);
> +	schedule_work(&host->card_detect_work);
>  	return IRQ_HANDLED;
>  }

Thanks, Thierry -- I hope it's okay with you if I merge your fix into
the original patch and add your S-o-b to that patch:

    Signed-off-by: Anton Vorontsov <avorontsov@mvista.com>
    Signed-off-by: Jeremie Samuel <jeremie.samuel.ext@parrot.com>
    [treding: Fix typo causing sdhci-dove build breakage]
    Signed-off-by: Thierry Reding <treding@nvidia.com>
    Signed-off-by: Chris Ball <cjb@laptop.org>

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>

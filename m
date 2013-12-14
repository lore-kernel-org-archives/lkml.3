Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754442Ab3LNVAb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 16:00:31 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:55544 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754419Ab3LNVAa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 16:00:30 -0500
X-Originating-IP: 50.43.14.201
Date: Sat, 14 Dec 2013 13:00:24 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel@vger.kernel.org, Chris Ball <cjb@laptop.org>,
        linux-mmc@vger.kernel.org
Subject: Re: [PATCH] drivers: mmc: Mark the function
 sdhci_disable_irq_wakeups() as static in sdhci.c
Message-ID: <20131214210024.GV17601@leaf>
References: <20131214131631.GA8543@rashika>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131214131631.GA8543@rashika>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 14, 2013 at 06:46:31PM +0530, Rashika Kheria wrote:
> This patch marks the function sdhci_disable_irq_wakeups() as static in
> host/sdhci.c because it is not used outside this file.
> 
> Thus, it also eliminates the following warning in host/sdhci.c:
> drivers/mmc/host/sdhci.c:2553:6: warning: no previous prototype for ‘sdhci_disable_irq_wakeups’ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>

This function has an EXPORT_SYMBOL_GPL, making it available for use
elsewhere in the kernel.  However, nothing in the kernel actually
*calls* this function, other than the one internal call in
sdhci_resume_host.  Thus, I'd suggest making this function static as you
have in this patch, and additionally deleting the EXPORT_SYMBOL_GPL for
it.

With that change:
Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  drivers/mmc/host/sdhci.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
> index bd8a098..8de50e8 100644
> --- a/drivers/mmc/host/sdhci.c
> +++ b/drivers/mmc/host/sdhci.c
> @@ -2550,7 +2550,7 @@ void sdhci_enable_irq_wakeups(struct sdhci_host *host)
>  }
>  EXPORT_SYMBOL_GPL(sdhci_enable_irq_wakeups);
>  
> -void sdhci_disable_irq_wakeups(struct sdhci_host *host)
> +static void sdhci_disable_irq_wakeups(struct sdhci_host *host)
>  {
>  	u8 val;
>  	u8 mask = SDHCI_WAKE_ON_INSERT | SDHCI_WAKE_ON_REMOVE
> -- 
> 1.7.9.5
> 

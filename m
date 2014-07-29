Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752139AbaG2UkR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 16:40:17 -0400
Received: from merkurneu.hrz.uni-giessen.de ([134.176.2.3]:52892 "EHLO
	merkurneu.hrz.uni-giessen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751607AbaG2UkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 16:40:15 -0400
From: Marc Dietrich <Marc.Dietrich@ap.physik.uni-giessen.de>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Julian Andres Klode <jak@jak-linux.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        ac100@lists.launchpad.net, linux-tegra@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] staging/nvec: Use platform_get_irq()
Date: Tue, 29 Jul 2014 22:24:03 +0200
Message-Id: <4292851.WR4mddmlu0@ax5200p>
User-Agent: KMail/4.13.2 (Linux/3.13.0-32-generic; KDE/4.13.2; x86_64; ; )
In-Reply-To: <1406632575-26075-2-git-send-email-thierry.reding@gmail.com>
References: <1406632575-26075-1-git-send-email-thierry.reding@gmail.com> <1406632575-26075-2-git-send-email-thierry.reding@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-HRZ-JLUG-MailScanner-Information: Passed JLUG virus check
X-HRZ-JLUG-MailScanner: No virus found
X-Envelope-From: marc.dietrich@ap.physik.uni-giessen.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag 29 Juli 2014, 13:16:15 schrieb Thierry Reding:
> From: Thierry Reding <treding@nvidia.com>
> 
> As opposed to platform_get_resource(), the platform_get_irq() function
> has special code to handle driver probe deferral when booting using DT
> and where an interrupt provider hasn't been registered yet. While this
> is unlikely to become an issue for nvec, platform_get_irq() is the
> recommended way to get at interrupts.
> 
> Signed-off-by: Thierry Reding <treding@nvidia.com>

Thanks again, Thierry!

Acked-by: Marc Dietrich <marvin24@gmx.de>



> ---
>  drivers/staging/nvec/nvec.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/staging/nvec/nvec.c b/drivers/staging/nvec/nvec.c
> index 815065837ce7..a93208adbfcf 100644
> --- a/drivers/staging/nvec/nvec.c
> +++ b/drivers/staging/nvec/nvec.c
> @@ -821,8 +821,8 @@ static int tegra_nvec_probe(struct platform_device
> *pdev) if (IS_ERR(base))
>  		return PTR_ERR(base);
> 
> -	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
> -	if (!res) {
> +	nvec->irq = platform_get_irq(pdev, 0);
> +	if (nvec->irq < 0) {
>  		dev_err(&pdev->dev, "no irq resource?\n");
>  		return -ENODEV;
>  	}
> @@ -840,7 +840,6 @@ static int tegra_nvec_probe(struct platform_device
> *pdev) }
> 
>  	nvec->base = base;
> -	nvec->irq = res->start;
>  	nvec->i2c_clk = i2c_clk;
>  	nvec->rx = &nvec->msg_pool[0];


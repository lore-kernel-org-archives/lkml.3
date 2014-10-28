Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919AbaJ1JxG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 05:53:06 -0400
Received: from mail-qg0-f51.google.com ([209.85.192.51]:34518 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751709AbaJ1JxD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 05:53:03 -0400
MIME-Version: 1.0
In-Reply-To: <1413883364-681-8-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1413883364-681-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<1413883364-681-8-git-send-email-sebastian.hesselbarth@gmail.com>
Date: Tue, 28 Oct 2014 10:53:01 +0100
Message-ID: <CAPDyKFqZKLXcaDx3gAiEe=mjEP4hemKoMwc1Y4_SDLDwKM8Mfg@mail.gmail.com>
Subject: Re: [PATCH RESEND 07/12] mmc: sdhci-pxav3: Try to get named I/O clock first
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
> With support for more than one clock, we'll need to distinguish between
> the clock by name. Change clock probing to first try to get "io" clock
> before falling back to unnamed clock.
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
>  drivers/mmc/host/sdhci-pxav3.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/mmc/host/sdhci-pxav3.c b/drivers/mmc/host/sdhci-pxav3.c
> index a34a589670e6..3dfd97977515 100644
> --- a/drivers/mmc/host/sdhci-pxav3.c
> +++ b/drivers/mmc/host/sdhci-pxav3.c
> @@ -309,7 +309,9 @@ static int sdhci_pxav3_probe(struct platform_device *pdev)
>         pltfm_host = sdhci_priv(host);
>         pltfm_host->priv = pxa;
>
> -       pxa->clk_io = devm_clk_get(dev, NULL);
> +       pxa->clk_io = devm_clk_get(dev, "io");
> +       if (IS_ERR(pxa->clk_io))
> +               pxa->clk_io = devm_clk_get(dev, NULL);
>         if (IS_ERR(pxa->clk_io)) {
>                 dev_err(dev, "failed to get io clock\n");
>                 ret = PTR_ERR(pxa->clk_io);
> --
> 2.1.1
>

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756283Ab3FFBhG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 21:37:06 -0400
Received: from mail-qc0-f171.google.com ([209.85.216.171]:44440 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755760Ab3FFBhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 21:37:04 -0400
MIME-Version: 1.0
In-Reply-To: <1370467796-4641-1-git-send-email-khoroshilov@ispras.ru>
References: <1370467796-4641-1-git-send-email-khoroshilov@ispras.ru>
From: Barry Song <21cnbao@gmail.com>
Date: Thu, 6 Jun 2013 09:36:43 +0800
Message-ID: <CAGsJ_4w6o9aSRDrH-nZRk77bRMxLUHDY5auePz_NzPC0pH1cjw@mail.gmail.com>
Subject: Re: [PATCH] spi/sirf: fix error propagation in spi_sirfsoc_probe()
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: Barry Song <baohua.song@csr.com>, ldv-project@linuxtesting.org,
        linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        spi-devel-general@lists.sourceforge.net,
        linux-arm-kernel@lists.infradead.org,
        DL-SHA-WorkGroupLinux <workgroup.linux@csr.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/6/6 Alexey Khoroshilov <khoroshilov@ispras.ru>:
> If pinctrl_get_select_default() fails, spi_sirfsoc_probe()
> returns IS_ERR(sspi->p) instead of PTR_ERR(sspi->p).
>
> Found by Linux Driver Verification project (linuxtesting.org).
>
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>

Acked-by: Barry Song <Baohua.Song@csr.com>

> ---
>  drivers/spi/spi-sirf.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/spi/spi-sirf.c b/drivers/spi/spi-sirf.c
> index 0808cd5..94c3920 100644
> --- a/drivers/spi/spi-sirf.c
> +++ b/drivers/spi/spi-sirf.c
> @@ -559,9 +559,10 @@ static int spi_sirfsoc_probe(struct platform_device *pdev)
>         sspi->bitbang.master->dev.of_node = pdev->dev.of_node;
>
>         sspi->p = pinctrl_get_select_default(&pdev->dev);
> -       ret = IS_ERR(sspi->p);
> -       if (ret)
> +       if (IS_ERR(sspi->p)) {
> +               ret = PTR_ERR(sspi->p);
>                 goto free_master;
> +       }
>
>         sspi->clk = clk_get(&pdev->dev, NULL);
>         if (IS_ERR(sspi->clk)) {
> --
> 1.8.1.2

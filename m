Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758228AbbA0OAD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 09:00:03 -0500
Received: from mail-qa0-f52.google.com ([209.85.216.52]:62458 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755780AbbA0N7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 08:59:03 -0500
MIME-Version: 1.0
In-Reply-To: <20150124003340.GA16286@dtor-ws>
References: <20150124003340.GA16286@dtor-ws>
Date: Tue, 27 Jan 2015 14:59:01 +0100
Message-ID: <CAPDyKFpk_SjBpT=+yCfNv8yGVVT64Z5GugjL+qoYubxjduxN3g@mail.gmail.com>
Subject: Re: [PATCH] mmc: dw_mmc: exynos: remove incorrect __exit_p()
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Seungwon Jeon <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>, Chris Ball <chris@printf.net>,
        Kukjin Kim <kgene@kernel.org>, Alim Akhtar <alim.akhtar@samsung.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        Beomho Seo <beomho.seo@samsung.com>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24 January 2015 at 01:33, Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> dw_mci_pltfm_remove() is not (nor should it be) marked as __exit,
> so we should not be using __exit_p() wrapper with it.
>
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Thanks! Applied for next.

Kind regards
Uffe


> ---
>  drivers/mmc/host/dw_mmc-exynos.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/mmc/host/dw_mmc-exynos.c b/drivers/mmc/host/dw_mmc-exynos.c
> index 12a5eaa..fe32948 100644
> --- a/drivers/mmc/host/dw_mmc-exynos.c
> +++ b/drivers/mmc/host/dw_mmc-exynos.c
> @@ -422,7 +422,7 @@ static const struct dev_pm_ops dw_mci_exynos_pmops = {
>
>  static struct platform_driver dw_mci_exynos_pltfm_driver = {
>         .probe          = dw_mci_exynos_probe,
> -       .remove         = __exit_p(dw_mci_pltfm_remove),
> +       .remove         = dw_mci_pltfm_remove,
>         .driver         = {
>                 .name           = "dwmmc_exynos",
>                 .of_match_table = dw_mci_exynos_match,
> --
> 2.2.0.rc0.207.ga3a616c
>
>
> --
> Dmitry

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469Ab3CZRbg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 13:31:36 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:51218 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753131Ab3CZRbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 13:31:35 -0400
MIME-Version: 1.0
In-Reply-To: <1364318953-5219-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <CAKohponTj8iHTZqs2pS9m1mOqgbGX5WUDa7B2-xcDP_0sN7ZsQ@mail.gmail.com>
	<1364318953-5219-1-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Tue, 26 Mar 2013 23:01:34 +0530
Message-ID: <CAKohpomxgQy0f51nYePaKs03Us4zfxQy+-_C6J9kYqNK8_iJoQ@mail.gmail.com>
Subject: Re: [PATCH v2.2] dw_dmac: remove unnecessary ENODEV check
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org, spear-devel <spear-devel@list.st.com>,
        Lars-Peter Clausen <lars@metafoo.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 March 2013 22:59, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> If CONFIG_OF is not set the of_node of the device will always be NULL.
>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/dma/dw_dmac.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
> index 274fd7d..736cffa 100644
> --- a/drivers/dma/dw_dmac.c
> +++ b/drivers/dma/dw_dmac.c
> @@ -1846,7 +1846,7 @@ static int dw_probe(struct platform_device *pdev)
>         if (pdev->dev.of_node) {
>                 err = of_dma_controller_register(pdev->dev.of_node,
>                                                  dw_dma_of_xlate, dw);
> -               if (err && err != -ENODEV)
> +               if (err)
>                         dev_err(&pdev->dev,
>                                 "could not register of_dma_controller\n");

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

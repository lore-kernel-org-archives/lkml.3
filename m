Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180AbaHSMh3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 08:37:29 -0400
Received: from mail-qg0-f54.google.com ([209.85.192.54]:40487 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161AbaHSMhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 08:37:24 -0400
MIME-Version: 1.0
In-Reply-To: <1408446847-1604-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1408446785-1399-1-git-send-email-srinivas.kandagatla@linaro.org>
	<1408446847-1604-1-git-send-email-srinivas.kandagatla@linaro.org>
Date: Tue, 19 Aug 2014 14:37:23 +0200
Message-ID: <CAPDyKFongXKhdM+2jVgzyaxjcsryCXOAztH727um5DCObrj-xw@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] mmc: mmci: Support any block sizes for ux500v2 and
 qcom variant
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc: linux-mmc <linux-mmc@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Chris Ball <chris@printf.net>, Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 August 2014 13:14, Srinivas Kandagatla
<srinivas.kandagatla@linaro.org> wrote:
> From: Ulf Hansson <ulf.hansson@linaro.org>
>
> For the ux500v2 variant of the PL18x block, any block sizes are
> supported. This will make it possible to decrease data overhead
> for SDIO transfers.
>
> This patch is based on Ulf Hansson patch
> http://www.spinics.net/lists/linux-mmc/msg12160.html
>
> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
>         enabled this support on qcom variant.
>
> Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  drivers/mmc/host/mmci.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
> index c11cb05..3089fba 100644
> --- a/drivers/mmc/host/mmci.c
> +++ b/drivers/mmc/host/mmci.c
> @@ -77,6 +77,7 @@ static unsigned int fmax = 515633;
>   * @qcom_fifo: enables qcom specific fifo pio read logic.
>   * @reversed_irq_handling: handle data irq before cmd irq.
>   * @qcom_dml: enables qcom specific dma glue for dma transfers.
> + * @any_blksize: true if block any sizes are supported
>   */
>  struct variant_data {
>         unsigned int            clkreg;
> @@ -102,6 +103,7 @@ struct variant_data {
>         bool                    qcom_fifo;
>         bool                    reversed_irq_handling;
>         bool                    qcom_dml;
> +       bool                    any_blksize;
>  };
>
>  static struct variant_data variant_arm = {
> @@ -194,6 +196,7 @@ static struct variant_data variant_ux500v2 = {
>         .pwrreg_clkgate         = true,
>         .busy_detect            = true,
>         .pwrreg_nopower         = true,
> +       .any_blksize            = true,
>  };

There are some prerequisites of the data buffers to supports any block
size, at least for ux500.
Try read up on this discussion:
http://marc.info/?t=135005062400002&r=2&w=2

The conclusion from the above is that we need to adopt
mmci_pio_write() to handle corner cases.

Now, I suppose, unless someone objects, we could go ahead and merge
this patch. Then you will have to fixup mmci_pio_write() later on.

Kind regards
Uffe

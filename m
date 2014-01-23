Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753051AbaAWKUz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 05:20:55 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:33840 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752968AbaAWKUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 05:20:53 -0500
MIME-Version: 1.0
In-Reply-To: <1389777291-15026-1-git-send-email-ch.naveen@samsung.com>
References: <1389243541-13122-1-git-send-email-ch.naveen@samsung.com> <1389777291-15026-1-git-send-email-ch.naveen@samsung.com>
From: Naveen Krishna Ch <naveenkrishna.ch@gmail.com>
Date: Thu, 23 Jan 2014 15:50:32 +0530
Message-ID: <CAHfPSqCv0r2ovgBGhrwejfocqEkAV_h4TAzYM4Ym8tbTOnn-RA@mail.gmail.com>
Subject: Re: [PATCH 2/8 v4] crypto:s5p-sss: Add device tree support
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Cc: linux-crypto@vger.kernel.org,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        linux-kernel@vger.kernel.org,
        Vladimir Zapolskiy <vzapolskiy@gmail.com>, herbert@gondor.apana.org.au,
        cpgs@samsung.com, tomasz.figa@gmail.com,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello All,

On 15 January 2014 14:44, Naveen Krishna Chatradhi
<ch.naveen@samsung.com> wrote:
> This patch adds device tree support to the s5p-sss.c crypto driver.
>
> Also, Documentation under devicetree/bindings added.
>
> Signed-off-by: Naveen Krishna Ch <ch.naveen@samsung.com>
> CC: Herbert Xu <herbert@gondor.apana.org.au>
> CC: David S. Miller <davem@davemloft.net>
> CC: Vladimir Zapolskiy <vzapolskiy@gmail.com>
> TO: <linux-crypto@vger.kernel.org>
> CC: <linux-samsung-soc@vger.kernel.org>
> ---
> Changes since v3:
> None
>
>  .../devicetree/bindings/crypto/samsung-sss.txt     |   20 ++++++++++++++++++++
>  drivers/crypto/s5p-sss.c                           |   10 +++++++++-
>  2 files changed, 29 insertions(+), 1 deletion(-)
>  create mode 100644 Documentation/devicetree/bindings/crypto/samsung-sss.txt
>
> diff --git a/Documentation/devicetree/bindings/crypto/samsung-sss.txt b/Documentation/devicetree/bindings/crypto/samsung-sss.txt
> new file mode 100644
> index 0000000..2f9d7e4
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/crypto/samsung-sss.txt
> @@ -0,0 +1,20 @@
> +Samsung SoC SSS (Security SubSystem) module
> +
> +The SSS module in S5PV210 SoC supports the following:
> +-- Feeder (FeedCtrl)
> +-- Advanced Encryption Standard (AES)
> +-- Data Encryption Standard (DES)/3DES
> +-- Public Key Accelerator (PKA)
> +-- SHA-1/SHA-256/MD5/HMAC (SHA-1/SHA-256/MD5)/PRNG
> +-- PRNG: Pseudo Random Number Generator
> +
> +Required properties:
> +
> +- compatible : Should contain entries for this and backward compatible
> +  SSS versions:
> +  - "samsung,s5pv210-secss" for S5PV210 SoC.
> +- reg : Offset and length of the register set for the module
> +- interrupts : the interrupt-specifier for the SSS module.
> +               Two interrupts "feed control and hash" in case of S5PV210
> +- clocks : the required gating clock for the SSS module.
> +- clock-names : the gating clock name to be requested in the SSS driver.
> diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
> index 93cddeb..2da5617 100644
> --- a/drivers/crypto/s5p-sss.c
> +++ b/drivers/crypto/s5p-sss.c
> @@ -22,6 +22,7 @@
>  #include <linux/scatterlist.h>
>  #include <linux/dma-mapping.h>
>  #include <linux/io.h>
> +#include <linux/of.h>
>  #include <linux/crypto.h>
>  #include <linux/interrupt.h>
>
> @@ -177,6 +178,12 @@ struct s5p_aes_dev {
>
>  static struct s5p_aes_dev *s5p_dev;
>
> +static const struct of_device_id s5p_sss_dt_match[] = {
> +       { .compatible = "samsung,s5pv210-secss", },
> +       { },
> +};
> +MODULE_DEVICE_TABLE(of, s5p_sss_dt_match);
> +
>  static void s5p_set_dma_indata(struct s5p_aes_dev *dev, struct scatterlist *sg)
>  {
>         SSS_WRITE(dev, FCBRDMAS, sg_dma_address(sg));
> @@ -676,7 +683,8 @@ static struct platform_driver s5p_aes_crypto = {
>         .remove = s5p_aes_remove,
>         .driver = {
>                 .owner  = THIS_MODULE,
> -               .name   = "s5p-secss",
> +               .name   = "s5pv210-secss",
> +               .of_match_table = s5p_sss_dt_match,
>         },
>  };
>
> --
> 1.7.9.5
Any update on this patch, Please
>



-- 
Shine bright,
(: Nav :)

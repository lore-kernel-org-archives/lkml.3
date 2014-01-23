Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815AbaAWK2Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 05:28:16 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:49434 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbaAWK2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 05:28:12 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-a7-52e0eeba4d50
Message-id: <52E0EEB8.4080602@samsung.com>
Date: Thu, 23 Jan 2014 11:28:08 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.1.1
MIME-version: 1.0
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, vzapolskiy@gmail.com,
        herbert@gondor.apana.org.au, naveenkrishna.ch@gmail.com,
        cpgs@samsung.com, tomasz.figa@gmail.com,
        "David S. Miller" <davem@davemloft.net>,
        devicetree <devicetree@vger.kernel.org>
Subject: Re: [PATCH 2/8 v4] crypto:s5p-sss: Add device tree support
References: <1389243541-13122-1-git-send-email-ch.naveen@samsung.com>
 <1389777291-15026-1-git-send-email-ch.naveen@samsung.com>
In-reply-to: <1389777291-15026-1-git-send-email-ch.naveen@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPLMWRmVeSWpSXmKPExsVy+t/xK7q73j0IMrj9RM7i7vPDjBYvD2la
	zDnfwmIx/8g5VovuVzIW9+/9ZLK4vGsOm8WM8/uYLBZt+89ssWrXH0aLs3MOMTlwe2xZeZPJ
	Y+esu+we2w6oevRtWcXo8XmTXABrFJdNSmpOZllqkb5dAlfGtEtXmQveSFZ8PuTRwPhfpIuR
	k0NCwESi/fNDVghbTOLCvfVsXYxcHEICSxkl3izaxA7hfGKU+HvvFyNIFa+AlsTpZSBVnBws
	AqoSu6+2sYDYbAKGEr1H+8BqRAUiJP7OWw9VLyjxY/I9sBoRgXKJfzfWgPUyC3xglJjR5QJi
	Cws4S9yZ0ccEsayRUeLMN4gFnAJuEvM2bGOBaNCR2N86DapZXmLzmrfMExgFZiHZMQtJ2Swk
	ZQsYmVcxiqaWJhcUJ6XnGukVJ+YWl+al6yXn525ihETC1x2MS49ZHWIU4GBU4uFN/HI/SIg1
	say4MvcQowQHs5II74U3D4KEeFMSK6tSi/Lji0pzUosPMTJxcEo1MO6covD9/bnb2ycaZuhn
	Wuw8wfjTMkb9qHA9v4HLVI6fKXq+Ef/rn7qlF+WJqUqcuHDh75d2/7k+u7qCMl5mqNgdl5l4
	8OeayX/MOJaL7oz/o/WxcMfyB8fW3Vr6XqsrODTOOT7issC9V7oTShdXqGoUBjxJ3hezhK1j
	zXn+G9fnPOw8wHLu0FUlluKMREMt5qLiRAAoId8/YgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

(Adding missing devicetre ML list at CC.)

On 15/01/14 10:14, Naveen Krishna Chatradhi wrote:
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
> +		Two interrupts "feed control and hash" in case of S5PV210

It should be described in what order both interrupts are supposed to be
specified.

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
> +	{ .compatible = "samsung,s5pv210-secss", },

nit: the first semicolon could be omitted.

> +	{ },
> +};
> +MODULE_DEVICE_TABLE(of, s5p_sss_dt_match);
> +
>  static void s5p_set_dma_indata(struct s5p_aes_dev *dev, struct scatterlist *sg)
>  {
>  	SSS_WRITE(dev, FCBRDMAS, sg_dma_address(sg));
> @@ -676,7 +683,8 @@ static struct platform_driver s5p_aes_crypto = {
>  	.remove	= s5p_aes_remove,
>  	.driver	= {
>  		.owner	= THIS_MODULE,
> -		.name	= "s5p-secss",
> +		.name	= "s5pv210-secss",

Why you're changing the driver name ? It's not related and not needed AFAICT.

> +		.of_match_table = s5p_sss_dt_match,
>  	},
>  };

--
Thanks,
Sylwester

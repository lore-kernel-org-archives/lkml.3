Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756732AbaAIJdB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 04:33:01 -0500
Received: from mail-oa0-f47.google.com ([209.85.219.47]:64782 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754170AbaAIJct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 04:32:49 -0500
MIME-Version: 1.0
In-Reply-To: <1389243569-13161-1-git-send-email-ch.naveen@samsung.com>
References: <1389095509-14357-4-git-send-email-ch.naveen@samsung.com>
	<1389243569-13161-1-git-send-email-ch.naveen@samsung.com>
Date: Thu, 9 Jan 2014 15:02:48 +0530
Message-ID: <CAK9yfHzh_xVpDA7ieY5zOJ60FOg3OHPcE4XZF38ZRnb2gWmLYQ@mail.gmail.com>
Subject: Re: [PATCH 3/6 v2] crypto:s5p-sss: Add support for SSS module on Exynos
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Cc: linux-crypto@vger.kernel.org,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, vzapolskiy@gmail.com,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Naveen,

On 9 January 2014 10:29, Naveen Krishna Chatradhi <ch.naveen@samsung.com> wrote:
> This patch adds new compatible and varient to support the SSS module
> on Exynos4 (Exynos4210), Exynos5 (Exynos5420 and Exynos5250) for which
> 1. AES register are at an offset of 0x200 and
> 2. hash interrupt is not available
>
> Signed-off-by: Naveen Krishna Ch <ch.naveen@samsung.com>
> CC: Herbert Xu <herbert@gondor.apana.org.au>
> CC: David S. Miller <davem@davemloft.net>
> CC: Vladimir Zapolskiy <vzapolskiy@gmail.com>
> TO: <linux-crypto@vger.kernel.org>
> CC: <linux-samsung-soc@vger.kernel.org>
> ---
> Changes since v1:
> 1. Used varient struct
> 2. Added description in Documentation
>
>  .../devicetree/bindings/crypto/samsung-sss.txt     |   20 +++++++++
>  drivers/crypto/s5p-sss.c                           |   43 ++++++++++++++------
>  2 files changed, 51 insertions(+), 12 deletions(-)
>
> diff --git a/Documentation/devicetree/bindings/crypto/samsung-sss.txt b/Documentation/devicetree/bindings/crypto/samsung-sss.txt
> index 0e45b0d..4531da2 100644
> --- a/Documentation/devicetree/bindings/crypto/samsung-sss.txt
> +++ b/Documentation/devicetree/bindings/crypto/samsung-sss.txt
> @@ -8,13 +8,33 @@ The SSS module in S5PV210 SoC supports the following:
>  -- SHA-1/SHA-256/MD5/HMAC (SHA-1/SHA-256/MD5)/PRNG
>  -- PRNG: Pseudo Random Number Generator
>
> +The SSS module in Exynos4 (Exynos4210) and
> +Exynos5 (Exynos5420 and Exynos5250) SoCs
> +supports the following also:
> +-- ARCFOUR (ARC4)
> +-- True Random Number Generator (TRNG)
> +-- Secure Key Manager
> +
>  Required properties:
>
>  - compatible : Should contain entries for this and backward compatible
>    SSS versions:
>    - "samsung,s5p-secss" for S5PV210 SoC.
> +  - "samsung,exynos-secss" for Exynos4210, Exynos5250 and Exynos5420 SoCs.

Shouldn't the compatible string be more specific with the name of the
first SoC that had this IP?

-- 
With warm regards,
Sachin

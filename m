Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752892AbaJ0TsR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 15:48:17 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:57793 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084AbaJ0TsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 15:48:15 -0400
Message-ID: <544EA178.3090506@collabora.co.uk>
Date: Mon, 27 Oct 2014 20:48:08 +0100
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org
CC: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: Re: [PATCH 3/8] mfd: max77686/802: Remove support for board files
References: <1414422226-10948-1-git-send-email-k.kozlowski@samsung.com> <1414422226-10948-4-git-send-email-k.kozlowski@samsung.com>
In-Reply-To: <1414422226-10948-4-git-send-email-k.kozlowski@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Krzysztof,

On 10/27/2014 04:03 PM, Krzysztof Kozlowski wrote:
> The driver is used only on Exynos based boards with DTS support.
> Convert the driver to DTS-only version. This simplifies a little the
> code:
> 1. No dead (unused) entries in platform_data structure.
> 2. More code removed (from all three patches: 34 insertions(+), 107
>    deletions).
> 3. Regulator driver does not depend on allocated memory
>    from MFD driver.
> 4. It makes also easier extending the regulator driver
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> ---
>  drivers/mfd/max77686.c               | 23 -----------------------
>  include/linux/mfd/max77686-private.h |  1 -
>  include/linux/mfd/max77686.h         | 22 ----------------------
>  3 files changed, 46 deletions(-)
> 
> diff --git a/drivers/mfd/max77686.c b/drivers/mfd/max77686.c
> index 929795eae9fc..3da237afacde 100644
> --- a/drivers/mfd/max77686.c
> +++ b/drivers/mfd/max77686.c

As I said in Patch 2/8, I think this driver should depend on OF since
is now DT-only. Regulator drivers don't need to do this since they
already depend on MFD_MAX77686. With that change feel free to add:

Reviewed-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>

Please also add my Reviewed-by tag to Patch 2/8 since I just noticed
that I forgot to add it.

Best regards,
Javier

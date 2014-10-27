Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752971AbaJ0Tvl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 15:51:41 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:57811 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858AbaJ0Tvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 15:51:39 -0400
Message-ID: <544EA245.7010100@collabora.co.uk>
Date: Mon, 27 Oct 2014 20:51:33 +0100
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
Subject: Re: [PATCH 5/8] regulator: max77686: Initialize opmode explicitly
 to normal mode
References: <1414422226-10948-1-git-send-email-k.kozlowski@samsung.com> <1414422226-10948-6-git-send-email-k.kozlowski@samsung.com>
In-Reply-To: <1414422226-10948-6-git-send-email-k.kozlowski@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Krzysztof,

On 10/27/2014 04:03 PM, Krzysztof Kozlowski wrote:
> Minor nit: Initialize the opmode for each regulator to normal mode in a
> readable explicit way.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Suggested-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> ---
>  drivers/regulator/max77686.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/regulator/max77686.c b/drivers/regulator/max77686.c
> index 7930b4f82c0b..e5738c363f07 100644
> --- a/drivers/regulator/max77686.c
> +++ b/drivers/regulator/max77686.c
> @@ -507,8 +507,8 @@ static int max77686_pmic_probe(struct platform_device *pdev)
>  		config.init_data = max77686->regulators[i].initdata;
>  		config.of_node = max77686->regulators[i].of_node;
>  
> -		max77686->opmode[i] = regulators[i].enable_mask >>
> -						max77686_get_opmode_shift(i);
> +		max77686->opmode[i] = MAX77686_NORMAL;
> +
>  		rdev = devm_regulator_register(&pdev->dev,
>  						&regulators[i], &config);
>  		if (IS_ERR(rdev)) {
> 

Reviewed-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>

Best regards,
Javier

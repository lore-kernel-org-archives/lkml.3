Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760939Ab3DCIW1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 04:22:27 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:33976 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760769Ab3DCIWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 04:22:24 -0400
Date: Wed, 3 Apr 2013 09:22:18 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Yvan FILLION <yvan.fillion@stericsson.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] regulator: ab8500: Fix 'match_size' undeclared and
 missing semicolon
Message-ID: <20130403082218.GC5580@gmail.com>
References: <1364956243.1328.1.camel@phoenix>
 <1364956405.1328.4.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1364956405.1328.4.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 03 Apr 2013, Axel Lin wrote:

> Fix below build errors:
>   CC      drivers/regulator/ab8500.o
> drivers/regulator/ab8500.c: In function 'ab8500_regulator_probe':
> drivers/regulator/ab8500.c:3018:3: error: 'match_size' undeclared (first use in this function)
> drivers/regulator/ab8500.c:3018:3: note: each undeclared identifier is reported only once for each function it appears in
> drivers/regulator/ab8500.c:3019:2: error: expected ';' before '}' token
> drivers/regulator/ab8500.c:3036:2: error: expected ';' before '}' token
> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
>  drivers/regulator/ab8500.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
> index bdd17e6..73d84d8 100644
> --- a/drivers/regulator/ab8500.c
> +++ b/drivers/regulator/ab8500.c
> @@ -3007,7 +3007,7 @@ static int ab8500_regulator_probe(struct platform_device *pdev)
>  	struct ab8500_regulator_info *regulator_info;
>  	int regulator_info_size;
>  	struct ab8500_reg_init *reg_init;
> -	int reg_init_size;
> +	int reg_init_size, match_size;
>  
>  	if (is_ab9540(ab8500)) {
>  		regulator_info = ab9540_regulator_info;
> @@ -3015,7 +3015,7 @@ static int ab8500_regulator_probe(struct platform_device *pdev)
>  		reg_init = ab9540_reg_init;
>  		reg_init_size = AB9540_NUM_REGULATOR_REGISTERS;
>  		match = ab9540_regulator_match;
> -		match_size = ARRAY_SIZE(ab9540_regulator_match)
> +		match_size = ARRAY_SIZE(ab9540_regulator_match);
>  	} else if (is_ab8505(ab8500)) {
>  		regulator_info = ab8505_regulator_info;
>  		regulator_info_size = ARRAY_SIZE(ab8505_regulator_info);
> @@ -3032,7 +3032,7 @@ static int ab8500_regulator_probe(struct platform_device *pdev)
>  		reg_init = ab8500_reg_init;
>  		reg_init_size = AB8500_NUM_REGULATOR_REGISTERS;
>  		match = ab8500_regulator_match;
> -		match_size = ARRAY_SIZE(ab8500_regulator_match)
> +		match_size = ARRAY_SIZE(ab8500_regulator_match);
>  	}
>  
>  	if (np) {

We already satisfy this requirement in:

"regulator: ab8500: Use a struct to select the good regulator
configuration"

... which is queued.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

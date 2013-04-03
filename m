Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761057Ab3DCIYr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 04:24:47 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:33940 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752407Ab3DCIYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 04:24:45 -0400
Date: Wed, 3 Apr 2013 09:24:39 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Yvan FILLION <yvan.fillion@stericsson.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] regulator: ab8500: Set match pointer and match_size
 for ab8505 and ab8540
Message-ID: <20130403082439.GD5580@gmail.com>
References: <1364956243.1328.1.camel@phoenix>
 <1364956458.1328.5.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1364956458.1328.5.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 03 Apr 2013, Axel Lin wrote:

> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
>  drivers/regulator/ab8500.c |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
> index 73d84d8..d3170ae 100644
> --- a/drivers/regulator/ab8500.c
> +++ b/drivers/regulator/ab8500.c
> @@ -3021,11 +3021,15 @@ static int ab8500_regulator_probe(struct platform_device *pdev)
>  		regulator_info_size = ARRAY_SIZE(ab8505_regulator_info);
>  		reg_init = ab8505_reg_init;
>  		reg_init_size = AB8505_NUM_REGULATOR_REGISTERS;
> +		match = ab8505_regulator_match;
> +		match_size = ARRAY_SIZE(ab8505_regulator_match);
>  	} else if (is_ab8540(ab8500)) {
>  		regulator_info = ab8540_regulator_info;
>  		regulator_info_size = ARRAY_SIZE(ab8540_regulator_info);
>  		reg_init = ab8540_reg_init;
>  		reg_init_size = AB8540_NUM_REGULATOR_REGISTERS;
> +		match = ab8540_regulator_match;
> +		match_size = ARRAY_SIZE(ab8540_regulator_match);
>  	} else {
>  		regulator_info = ab8500_regulator_info;
>  		regulator_info_size = ARRAY_SIZE(ab8500_regulator_info);

Hmm... looks like a merge error, sorry for that.

Again is solved by the next patch in Mark's list:

"regulator: ab8500: Use a struct to select the good regulator
configuration"

Ironically Mark this is No11.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751560AbaHRNGc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 09:06:32 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:41629 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbaHRNGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 09:06:31 -0400
Message-ID: <53F1FA49.5000508@linaro.org>
Date: Mon, 18 Aug 2014 21:06:17 +0800
From: Guodong Xu <guodong.xu@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Axel Lin <axel.lin@ingics.com>, Mark Brown <broonie@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] regulator: core: Fix build error due to const qualifier
 for ops
References: <1408329248.12083.2.camel@phoenix>
In-Reply-To: <1408329248.12083.2.camel@phoenix>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm sending a patch to fix the build error on mc13892-regulator.c

-Guodong

On 08/18/2014 10:34 AM, Axel Lin wrote:
> Drop const qualifier for ops of struct regulator_desc.
> Allow regulator drivers to update ops before registering regulator.
> 
> Fix below build error:
>   CC [M]  drivers/regulator/mc13892-regulator.o
> drivers/regulator/mc13892-regulator.c: In function 'mc13892_regulator_probe':
> drivers/regulator/mc13892-regulator.c:586:3: error: assignment of member 'set_mode' in read-only object
> drivers/regulator/mc13892-regulator.c:588:3: error: assignment of member 'get_mode' in read-only object
> make[2]: *** [drivers/regulator/mc13892-regulator.o] Error 1
> make[1]: *** [drivers/regulator] Error 2
> make: *** [drivers] Error 2
> 
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
>  include/linux/regulator/driver.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/regulator/driver.h b/include/linux/regulator/driver.h
> index efe058f..3abda75 100644
> --- a/include/linux/regulator/driver.h
> +++ b/include/linux/regulator/driver.h
> @@ -246,7 +246,7 @@ struct regulator_desc {
>  	int id;
>  	bool continuous_voltage_range;
>  	unsigned n_voltages;
> -	const struct regulator_ops *ops;
> +	struct regulator_ops *ops;
>  	int irq;
>  	enum regulator_type type;
>  	struct module *owner;
> 

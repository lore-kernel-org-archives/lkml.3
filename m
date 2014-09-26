Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756094AbaIZUlj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 16:41:39 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:61097 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754829AbaIZUli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 16:41:38 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] pinctrl: remove remaining users of gpiochip_remove() retval
Date: Fri, 26 Sep 2014 22:41:32 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-35-generic; KDE/4.3.2; x86_64; ; )
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        linux-gpio@vger.kernel.org
References: <1410905274-22339-1-git-send-email-linus.walleij@linaro.org>
In-Reply-To: <1410905274-22339-1-git-send-email-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201409262241.32579.arnd@arndb.de>
X-Provags-ID: V02:K0:25gBSlvalXQZhka6v2HuDUHVBN8GQuG940fNSY3Ygat
 Dew0G8vMhrVQglIdf3qVzWsUbPzOfQQ/DytJxrxfgbxBDiI0PI
 qMnWUWMgVV1CX3COyllr1S0NJ+QAaqckhTniZ9Q264TPn9zJvd
 angUHoEOOEJS0A7xeKt7lf+NDAFSd9XCKQjd/SnEEMAbCktIS7
 LlTVjMyNMKxXZ2gtD0LV2r+9LDFsMvWc2ePGNkIp8vJCMnBaTO
 Zeq7Z6cY6KUGFph7qTj5XeJsnqpvI1KnjvtFeCDQoJkSj4+yrU
 CyAG4tix1I4n/DZ/xzGFenHNb0vWI22m18ofnUUMMWCYRbgH80
 V8uyfayeiwTW6xUpndGI=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 17 September 2014, Linus Walleij wrote:
> Some drivers accidentally still use the return value from
> gpiochip_remove(). Get rid of them so we can simplify this function
> and get rid of the return value.
> 
> Cc: Abdoulaye Berthe <berthe.ab@gmail.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> This patch will be merged through the GPIO tree.

Hi Linus, this patch caused a new build warning in some configurations:

> diff --git a/drivers/pinctrl/nomadik/pinctrl-abx500.c b/drivers/pinctrl/nomadik/pinctrl-abx500.c
> index a53a689a2bfa..7df34b70e8b6 100644
> --- a/drivers/pinctrl/nomadik/pinctrl-abx500.c
> +++ b/drivers/pinctrl/nomadik/pinctrl-abx500.c
> @@ -1298,10 +1298,7 @@ static int abx500_gpio_probe(struct platform_device *pdev)
>  	return 0;
>  
>  out_rem_chip:
> -	err = gpiochip_remove(&pct->chip);
> -	if (err)
> -		dev_info(&pdev->dev, "failed to remove gpiochip\n");
> -
> +	gpiochip_remove(&pct->chip);
>  	return ret;
>  }


drivers/pinctrl/nomadik/pinctrl-abx500.c: In function 'abx500_gpio_probe':
drivers/pinctrl/nomadik/pinctrl-abx500.c:1208:11: warning: unused variable 'err' [-Wunused-variable]

Please fix by removing that variable.

	Arnd

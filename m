Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757567Ab3LFJzi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 04:55:38 -0500
Received: from gloria.sntech.de ([95.129.55.99]:34146 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756253Ab3LFJzb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 04:55:31 -0500
From: Heiko =?iso-8859-1?q?St=FCbner?= <heiko@sntech.de>
To: Jingoo Han <jg1.han@samsung.com>
Subject: Re: [PATCH 4/6] regulator: gpio-regulator: use devm_regulator_register()
Date: Fri, 6 Dec 2013 10:12:05 +0100
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-686-pae; KDE/4.8.4; i686; ; )
Cc: "'Mark Brown'" <broonie@kernel.org>,
        "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Axel Lin'" <axel.lin@ingics.com>
References: <000a01cef251$c79ea9e0$56dbfda0$%han@samsung.com> <000d01cef252$4680cf90$d3826eb0$%han@samsung.com>
In-Reply-To: <000d01cef252$4680cf90$d3826eb0$%han@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201312061012.05535.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Am Freitag, 6. Dezember 2013, 08:10:42 schrieb Jingoo Han:

> @@ -351,8 +352,6 @@ static int gpio_regulator_remove(struct platform_device
> *pdev) {
>  	struct gpio_regulator_data *drvdata = platform_get_drvdata(pdev);
> 
> -	regulator_unregister(drvdata->dev);
> -
>  	gpio_free_array(drvdata->gpios, drvdata->nr_gpios);
> 
>  	kfree(drvdata->states);

I'm not this firm in the core driver/device behaviour, but when looking at 
__device_release_driver I see that the remove callback runs before 
devres_release_all, which would effectively free the gpios before the 
regulator gets unregistered - is this racy with a regulator change at the same 
time?


Heiko

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755462Ab3IZGUT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 02:20:19 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:43701 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007Ab3IZGUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 02:20:17 -0400
MIME-Version: 1.0
In-Reply-To: <000c01ceba5d$014e32f0$03ea98d0$%han@samsung.com>
References: <000701ceba5c$69459b10$3bd0d130$%han@samsung.com>
	<000c01ceba5d$014e32f0$03ea98d0$%han@samsung.com>
Date: Thu, 26 Sep 2013 11:50:17 +0530
Message-ID: <CAK9yfHy+96DfxKibu3nnT49EoxH_K9VaL4v+exC86qikxTWYyA@mail.gmail.com>
Subject: Re: [PATCH V2 06/18] regulator: gpio-regulator: use devm_regulator_register()
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 September 2013 07:36, Jingoo Han <jg1.han@samsung.com> wrote:
> Use devm_regulator_register() to make cleanup paths simpler.
> @@ -349,8 +350,6 @@ static int gpio_regulator_remove(struct platform_device *pdev)
>  {
>         struct gpio_regulator_data *drvdata = platform_get_drvdata(pdev);
>
> -       regulator_unregister(drvdata->dev);
> -
>         gpio_free_array(drvdata->gpios, drvdata->nr_gpios);
>
>         kfree(drvdata->states);

In most of the cases where unregister doesn't happen to be the only or
last call in the remove path,
I am not sure if change in ordering wouldn't cause any functional
issues. For. e.g., in this patch we are freeing the gpios and the
driver states even before unregistering the device which is logically
not right.

-- 
With warm regards,
Sachin

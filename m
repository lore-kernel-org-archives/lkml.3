Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755047Ab3IYKRg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 06:17:36 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:58800 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754730Ab3IYKRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 06:17:34 -0400
MIME-Version: 1.0
In-Reply-To: <001201ceb9c5$95268ab0$bf73a010$%han@samsung.com>
References: <000901ceb9c3$97fe74c0$c7fb5e40$%han@samsung.com>
	<001201ceb9c5$95268ab0$bf73a010$%han@samsung.com>
Date: Wed, 25 Sep 2013 15:47:34 +0530
Message-ID: <CAK9yfHxu3LxaKVSX9WO6J7dd+xtGWF4304pUHwN=oFd_hwy3hQ@mail.gmail.com>
Subject: Re: [PATCH 09/20] regulator: lp3972: use devm_regulator_register()
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 September 2013 13:32, Jingoo Han <jg1.han@samsung.com> wrote:
> Use devm_regulator_register() to make cleanup paths simpler.

>  static int lp3972_i2c_remove(struct i2c_client *i2c)
>  {
>         struct lp3972 *lp3972 = i2c_get_clientdata(i2c);
> -       int i;
>
> -       for (i = 0; i < lp3972->num_regulators; i++)
> -               regulator_unregister(lp3972->rdev[i]);
>         kfree(lp3972->rdev);

With devm the unregister would happen after the freeing of the device.
Wouldn't this re-ordering cause any
problems?

-- 
With warm regards,
Sachin

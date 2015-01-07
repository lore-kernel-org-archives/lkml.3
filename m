Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753008AbbAGMsm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 07:48:42 -0500
Received: from mail-ig0-f180.google.com ([209.85.213.180]:63813 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950AbbAGMsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 07:48:41 -0500
MIME-Version: 1.0
In-Reply-To: <20150106181842.GA618@roeck-us.net>
References: <1420467656-6112-6-git-send-email-bgolaszewski@baylibre.com>
	<20150106181842.GA618@roeck-us.net>
Date: Wed, 7 Jan 2015 13:48:40 +0100
Message-ID: <CAMpxmJUeX1J+wHW_c0NLeOgPcUyv82s9fH+xo8aisdwBYH2hUg@mail.gmail.com>
Subject: Re: [v8, 5/5] hwmon: ina2xx: allow to change the averaging rate at run-time
From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Patrick Titiano <ptitiano@baylibre.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Benoit Cousson <bcousson@baylibre.com>,
        LM Sensors <lm-sensors@lm-sensors.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2015-01-06 19:18 GMT+01:00 Guenter Roeck <linux@roeck-us.net>:
> ina226_avg_val() calculates the average value from ina226_avg_tab
> and then you loop through ina226_avg_tab to find the index into ina226_avg_tab
> again, only to use the thus calculated index for accessing ina226_avg_tab[]
> once more. Think about it. A simple
>         avg = ina226_avg_tab[INA226_READ_AVG(data->regs[INA2XX_CONFIG])];
>         return snprintf(buf, PAGE_SIZE, "%d\n", avg);
> or even
>         return snprintf(buf, PAGE_SIZE, "%d\n",
>                         ina226_avg_tab[INA226_READ_AVG(data->regs[INA2XX_CONFIG])]);
>
> would accomplish exactly the same.

This was stupid, I admit. Fixed in the new version. Hope it's ok now.

> I kind of dislike that attribute name. I don't have a better idea though, so
> I'll let it pass unless you have a better idea.

I don't really. What's wrong with this one?

Bart

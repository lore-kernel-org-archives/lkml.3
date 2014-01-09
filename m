Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752334AbaAIOnT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 09:43:19 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:40932 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060AbaAIOnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 09:43:08 -0500
MIME-Version: 1.0
In-Reply-To: <20140108223933.GD18611@lee--X1>
References: <1387814889-16670-1-git-send-email-lpapp@kde.org>
	<1387814889-16670-2-git-send-email-lpapp@kde.org>
	<20140108223933.GD18611@lee--X1>
Date: Thu, 9 Jan 2014 14:43:07 +0000
X-Google-Sender-Auth: 11OX-dlRd45MOo2OChjnjTy3z4A
Message-ID: <CAOMwXhPhOGn2n2ca1aenxS_-b0pYiZ_KvX7bR666MsoxaQeL9g@mail.gmail.com>
Subject: Re: [PATCH 1/3] mfd: MAX6650/6651 support
From: Laszlo Papp <lpapp@kde.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Guenter Roeck <linux@roeck-us.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> +int max6651_read_reg(struct i2c_client *i2c, u8 reg, u8 *dest)
>> +{
>
> Probably best to use Regmap instead.
>
> regmap_i2c_read()

>> +int max6651_write_reg(struct i2c_client *i2c, u8 reg, u8 value)
>> +{
>> +    struct max6651_dev *max6651 = i2c_get_clientdata(i2c);
>> +    int ret;
>
> Same here.
>
> regmap_i2c_write()

Hmm, but what Linus linked is using regmap_read/write(...) instead of
regmap_i2c_read/write(...).

I thought I would need to be using the former. Perhaps, I
misunderstand something?

I do not even find the aforementioend functions used by drivers based
on this LXR result:
http://lxr.free-electrons.com/ident?i=regmap_i2c_write

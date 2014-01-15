Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751673AbaAOICN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 03:02:13 -0500
Received: from mail-ob0-f179.google.com ([209.85.214.179]:50335 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237AbaAOICM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 03:02:12 -0500
MIME-Version: 1.0
In-Reply-To: <20140110095648.GA28141@lee--X1>
References: <1387814889-16670-1-git-send-email-lpapp@kde.org>
	<1387814889-16670-2-git-send-email-lpapp@kde.org>
	<20140108223933.GD18611@lee--X1>
	<CAOMwXhPhOGn2n2ca1aenxS_-b0pYiZ_KvX7bR666MsoxaQeL9g@mail.gmail.com>
	<20140110095648.GA28141@lee--X1>
Date: Wed, 15 Jan 2014 09:02:11 +0100
Message-ID: <CACRpkdZcMUQzaDB7SyWvq+HYdpvd0r-jJvnRZoBymV6Zyy3gAw@mail.gmail.com>
Subject: Re: [PATCH 1/3] mfd: MAX6650/6651 support
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>, Mark Brown <broonie@kernel.org>
Cc: Laszlo Papp <lpapp@kde.org>, Guenter Roeck <linux@roeck-us.net>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 10, 2014 at 10:56 AM, Lee Jones <lee.jones@linaro.org> wrote:
> On Thu, 09 Jan 2014, Laszlo Papp wrote:
>
>> >> +int max6651_read_reg(struct i2c_client *i2c, u8 reg, u8 *dest)
>> >> +{
>> >
>> > Probably best to use Regmap instead.
>> >
>> > regmap_i2c_read()
>>
>> >> +int max6651_write_reg(struct i2c_client *i2c, u8 reg, u8 value)
>> >> +{
>> >> +    struct max6651_dev *max6651 = i2c_get_clientdata(i2c);
>> >> +    int ret;
>> >
>> > Same here.
>> >
>> > regmap_i2c_write()
>>
>> Hmm, but what Linus linked is using regmap_read/write(...) instead of
>> regmap_i2c_read/write(...).
>>
>> I thought I would need to be using the former. Perhaps, I
>> misunderstand something?
>>
>> I do not even find the aforementioend functions used by drivers based
>> on this LXR result:
>> http://lxr.free-electrons.com/ident?i=regmap_i2c_write
>
> Linus is in a better position to know, use his suggestion.

Just use regmap_read/write to abstract things and hide the
underlying marshalling in regmap.

regmap_i2c_write is some regmap-internal thing.

Yours,
Linus Walleij

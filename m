Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751594AbaJEMjG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 08:39:06 -0400
Received: from mail-qg0-f51.google.com ([209.85.192.51]:65150 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359AbaJEMjD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 08:39:03 -0400
MIME-Version: 1.0
In-Reply-To: <20141005083358.072f5909.m.chehab@samsung.com>
References: <cover.1412497399.git.knightrider@are.ma>
	<5bff3e029fe189f44222961dc04790d4f58a4659.1412497399.git.knightrider@are.ma>
	<20141005083358.072f5909.m.chehab@samsung.com>
Date: Sun, 5 Oct 2014 21:39:01 +0900
X-Google-Sender-Auth: HF7tckJKUFLlHj5lNWEx-b5p2Kc
Message-ID: <CAKnK8-REGVgdgQM+2KP0ibrf_gHMm_UO3oLr0MRoiu=-7vXUPw@mail.gmail.com>
Subject: Re: [PATCH 02/11] tc90522 is a client
From: "AreMa Inc." <info@are.ma>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media <linux-media@vger.kernel.org>, linux-kernel@vger.kernel.org,
        Antti Palosaari <crope@iki.fi>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Hans De Goede <hdegoede@redhat.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Peter Senna Tschudin <peter.senna@gmail.com>, knightrider@are.ma
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mauro,

As this _stable_ patch series is developed originally
(and already submitted for review) since 2013,
not based on Tsukada's patch you just linked,
it is difficult to split into one patch per logic.

As you said, for example, to fix the Tsukada's patch of tuner - FE - bridge
communication, we need to fix all the files.

We started developing and publishing PT3 drivers (chardev and DVB versions)
on 2013 and have been submitting the patches to this community since then.
We were waiting for reviews.

However this July, a man named Tsukada, who has been annoying us since
the beginning of development (we invited him to merge/join the project,
in other words, opted him to be co-author), interrupted our submission
and started
speaking ill of us that we didn't want to split the driver and stopped
the development, etc.
This is not true. What we meant was that, it is too early to implement
Regmap I2C
for now (except if it is a firm consensus, surely we will do).

Unfortunately, you trusted him and put on the tree. If "backstabbing"
is permitted,
this will be a very bad precedence in our community.

We can send per logic patches without breaking the compilation,
but we cannot guarantee the behaviour if you apply only one patch or two.
Thus, pulling the clean package from

       https://github.com/knight-rider/ptx/tree/master/pt3_dvb

is the best bet. Or, do you have the card with you?

Best Regards
-Bud

2014-10-05 20:33 GMT+09:00 Mauro Carvalho Chehab <m.chehab@samsung.com>:
> Em Sun, 05 Oct 2014 17:59:38 +0900
> "Буди Романто, AreMa Inc" <info@are.ma> escreveu:
>
>> tc90522 is an I2C client functioning as a frontend
>> thus, it is enough to return the FE pointer.
>>
>> Signed-off-by: Буди Романто, AreMa Inc <knightrider@are.ma>
>> ---
>>  drivers/media/dvb-frontends/tc90522.h | 41 ++++++++++++-----------------------
>>  1 file changed, 14 insertions(+), 27 deletions(-)
>>
>> diff --git a/drivers/media/dvb-frontends/tc90522.h b/drivers/media/dvb-frontends/tc90522.h
>> index b1cbddf..c78a5b0 100644
>> --- a/drivers/media/dvb-frontends/tc90522.h
>> +++ b/drivers/media/dvb-frontends/tc90522.h
>> @@ -1,12 +1,12 @@
>>  /*
>> - * Toshiba TC90522 Demodulator
>> + * Earthsoft PT3 demodulator frontend Toshiba TC90522XBG OFDM(ISDB-T)/8PSK(ISDB-S)
>>   *
>> - * Copyright (C) 2014 Akihiro Tsukada <tskd08@gmail.com>
>> - *
>> - * This program is free software; you can redistribute it and/or
>> - * modify it under the terms of the GNU General Public License as
>> - * published by the Free Software Foundation version 2.
>> + * Copyright (C) 2014 Budi Rachmanto, AreMa Inc. <info@are.ma>
>>   *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License as published by
>> + * the Free Software Foundation; either version 2 of the License, or
>> + * (at your option) any later version.
>>   *
>>   * This program is distributed in the hope that it will be useful,
>>   * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> @@ -14,29 +14,16 @@
>>   * GNU General Public License for more details.
>>   */
>>
>> -/*
>> - * The demod has 4 input (2xISDB-T and 2xISDB-S),
>> - * and provides independent sub modules for each input.
>> - * As the sub modules work in parallel and have the separate i2c addr's,
>> - * this driver treats each sub module as one demod device.
>> - */
>
> None of the above is related to the patch description. Also, we don't
> remove copyrights from the driver.
>
>> -
>> -#ifndef TC90522_H
>> -#define TC90522_H
>> +#ifndef      __TC90522_H__
>> +#define      __TC90522_H__
>>
>> -#include <linux/i2c.h>
>> -#include "dvb_frontend.h"
>> -
>> -/* I2C device types */
>> -#define TC90522_I2C_DEV_SAT "tc90522sat"
>> -#define TC90522_I2C_DEV_TER "tc90522ter"
>> +#define TC90522_DRVNAME "tc90522"
>
> This would break the driver, as the two macros above are used at
> tc90522.c.
>
>>  struct tc90522_config {
>> -     /* [OUT] frontend returned by driver */
>> -     struct dvb_frontend *fe;
>> -
>> -     /* [OUT] tuner I2C adapter returned by driver */
>> -     struct i2c_adapter *tuner_i2c;
>> +     fe_delivery_system_t    type;   /* IN   SYS_ISDBS or SYS_ISDBT */
>> +     bool                    pwr;    /* IN   set only once after all demods initialized */
>> +     struct dvb_frontend     *fe;    /* OUT  allocated frontend */
>>  };
>
> A change like that at the struct would break the driver.
>
> There are several problems at the approach you're taking. It seems that
> you're just doing a diff from the driver that it is committed from the
> driver you have, without:
>         - splitting one change par patch;
>         - caring if a patch would break compilation.
>
> Instead, if you need, for example, to add a new field at the config struct,
> like "pwr", your patch would need to be touching both the header and the
> tc90522 to use this new field.
>
> For the same reasons, I can't apply the rest of your patch series, as it is
> not splitting the changes as one patch per functional changes.
>
> Regards,
> Mauro

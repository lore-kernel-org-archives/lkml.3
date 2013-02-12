Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932926Ab3BLAsp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 19:48:45 -0500
Received: from mail-la0-f42.google.com ([209.85.215.42]:39865 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932909Ab3BLAsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 19:48:42 -0500
MIME-Version: 1.0
In-Reply-To: <20130210121901.GA15546@nekote.pengutronix.de>
References: <1357927027-4857-2-git-send-email-dianders@chromium.org>
	<1358189602-24180-1-git-send-email-dianders@chromium.org>
	<1358189602-24180-2-git-send-email-dianders@chromium.org>
	<20130210121901.GA15546@nekote.pengutronix.de>
Date: Mon, 11 Feb 2013 16:48:40 -0800
X-Google-Sender-Auth: UYergnz1TIE9qWKUy09g_T6N004
Message-ID: <CAD=FV=V89FQPsZ46NF4v2--9dLLT6q4r=msqKbwNhZ57NXpVYA@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] i2c-core: dt: Pick i2c bus number from i2c alias
 if present
From: Doug Anderson <dianders@chromium.org>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Olof Johansson <olof@lixom.net>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Padmavathi Venna <padma.v@samsung.com>,
        Ben Dooks <ben-linux@fluff.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc@vger.kernel.org,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wolfram,

Thanks for the review.  New patch was just sent.  :)

On Sun, Feb 10, 2013 at 4:19 AM, Wolfram Sang <w.sang@pengutronix.de> wrote:
>> +static int i2c_get_number_from_dt(struct i2c_adapter *adap)
>
> i2c_get_id_from_dt()?

Done.


>> +     if (!dev->of_node)
>> +             return -1;
>
> -ESOMETHING?

Function has been removed, as per below.


>> +
>> +     id = of_alias_get_id(dev->of_node, "i2c");
>> +     if (id < 0)
>> +             return -1;
>> +     return id;
>
> Simply 'return of_alias_get_id(...)'? Even more, since this function
> boils down to calling of_alias_get_id only and is only used once, I'd
> think we can implement that directly and drop this function. That
> shouldn't hurt readability.

Good point.  Done.

>> +/**
>> + * _i2c_add_numbered_adapter - i2c_add_numbered_adapter where nr is never -1
>> + * @adap: the adapter to register (with adap->nr initialized)
>> + * Context: can sleep
>> + *
>> + * See i2c_add_numbered_adapter() for details.
>> + */
>> +static int _i2c_add_numbered_adapter(struct i2c_adapter *adap)
>
> All other internal functions are prefixed with '__'.

Done.


>> +{
>> +     int     id;
>> +     int     status;
>> +
>> +     /* Handled by wrappers */
>> +     BUG_ON(adap->nr == -1);
>
> Is that a reason to halt the kernel? WARN and bailing out would do IMO.

Done.


>> +
>> +     if (adap->nr & ~MAX_IDR_MASK)
>> +             return -EINVAL;
>
> Note the idr-cleanup series from Tejun Heo. Given that his series is
> scheduled for v3.9, I'd like to have your patches on top of his.

Done.

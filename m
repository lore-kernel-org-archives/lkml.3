Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719AbaDWIih (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 04:38:37 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:39860 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbaDWIie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 04:38:34 -0400
MIME-Version: 1.0
In-Reply-To: <20140417103018.GK28725@lee--X1>
References: <1397659455-13638-1-git-send-email-linus.walleij@linaro.org>
	<1397659455-13638-3-git-send-email-linus.walleij@linaro.org>
	<20140417103018.GK28725@lee--X1>
Date: Wed, 23 Apr 2014 10:38:33 +0200
Message-ID: <CACRpkdYKAZLybzsLorEU5Cye89qVtvd0GQNoWcUXeSdC_WogtQ@mail.gmail.com>
Subject: Re: [PATCH 2/6] mfd: stmpe: add optional regulators
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Silvio F <silvio.fricke@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Shawn Guo <shawn.guo@linaro.org>,
        Viresh Kumar <viresh.linux@gmail.com>,
        Shiraz Hashim <shiraz.hashim@st.com>,
        spear-devel <spear-devel@list.st.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2014 at 12:30 PM, Lee Jones <lee.jones@linaro.org> wrote:

>> The STMPE has VCC and VIO supply lines, and sometimes (as on
>> Ux500) this comes from a software-controlled regulator. Make
>> it possible to supply the STMPE with power from these
>> regulators.
>>
>> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
(...)
>>  int stmpe_remove(struct stmpe *stmpe)
>>  {
>> +     if (!IS_ERR(stmpe->vio))
>> +             regulator_disable(stmpe->vio);
>> +     if (!IS_ERR(stmpe->vcc))
>> +             regulator_disable(stmpe->vcc);
>> +
>
> Genuine question:
>   Doesn't the regulator core take care of this for you on removal?

No devm_regulator_release() that gets called when refcount goes to 0
just calls regulator_put().

regulator_put(), in turn, will just kfree the struct regulator *.

Thus we need to balance enable/disable.

Yours,
Linus Walleij

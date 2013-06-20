Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757618Ab3FTMi1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 08:38:27 -0400
Received: from multi.imgtec.com ([194.200.65.239]:33323 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754724Ab3FTMi0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 08:38:26 -0400
Message-ID: <51C2F7BE.2060805@imgtec.com>
Date: Thu, 20 Jun 2013 13:38:22 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Linus Walleij <linus.walleij@stericsson.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Stephen Warren <swarren@nvidia.com>,
        =?UTF-8?B?77+9?= <heiko@sntech.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Anmar Oueja <anmar.oueja@linaro.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH] pinctrl: establish pull-up/pull-down terminology
References: <1371379548-6482-1-git-send-email-linus.walleij@stericsson.com> <51C22A95.4050703@wwwdotorg.org>
In-Reply-To: <51C22A95.4050703@wwwdotorg.org>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01192__2013_06_20_13_38_23
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/06/13 23:03, Stephen Warren wrote:
> On 06/16/2013 04:45 AM, Linus Walleij wrote:
>> From: Linus Walleij <linus.walleij@linaro.org>
>>
>> It is counter-intuitive to have "0" mean disable in a boolean
>> manner for electronic properties of pins such as pull-up and
>> pull-down. Therefore, define that a pull-up/pull-down argument
>> of 0 to such a generic option means that the pin is
>> short-circuited to VDD or GROUND. Pull disablement shall be
>> done using PIN_CONFIG_BIAS_DISABLE.
>>
>> Cc: Heiko St�bner <heiko@sntech.de>
>> Cc: James Hogan <james.hogan@imgtec.com>
>> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
>> ---
>>  include/linux/pinctrl/pinconf-generic.h | 13 +++++++------
>>  1 file changed, 7 insertions(+), 6 deletions(-)
>>
>> diff --git a/include/linux/pinctrl/pinconf-generic.h b/include/linux/pinctrl/pinconf-generic.h
>> index d414a77..67780f5 100644
>> --- a/include/linux/pinctrl/pinconf-generic.h
>> +++ b/include/linux/pinctrl/pinconf-generic.h
>> @@ -36,14 +36,15 @@
>>   *	tristate. The argument is ignored.
>>   * @PIN_CONFIG_BIAS_PULL_UP: the pin will be pulled up (usually with high
>>   *	impedance to VDD). If the argument is != 0 pull-up is enabled,
>> - *	if it is 0, pull-up is disabled.
>> + *	if it is 0, pull-up it total, i.e. the pin is connected to VDD.
>>   * @PIN_CONFIG_BIAS_PULL_DOWN: the pin will be pulled down (usually with high
>>   *	impedance to GROUND). If the argument is != 0 pull-down is enabled,
>> - *	if it is 0, pull-down is disabled.
>> + *	if it is 0, pull-down is total, i.e. the pin is connected to GROUND.
>>   * @PIN_CONFIG_BIAS_PULL_PIN_DEFAULT: the pin will be pulled up or down based
>>   *	on embedded knowledge of the controller, like current mux function.
>> - *	If the argument is != 0 pull up/down is enabled, if it is 0,
>> - *	the pull is disabled.
>> + *	If the argument is != 0 pull up/down is enabled, if it is 0, the
>> + *	configuration is ignored. The proper way to disable it is to use
>> + *	@PIN_CONFIG_BIAS_DISABLE.
> 
> Why treat PULL_UP/PULL_DOWN differently from PULL_PIN_DEFAULT?
> PULL_PIN_DEFAULT is logically simply a macro that selects PULL_UP/DOWN
> based on what's "normal" for the pin's expected usage, so surely the
> value associated with that option should behave identically?

I'm not familiar with hardware that does this so I could be way wrong
here, but presumably if there's a default up/down, there's probably a
default resistance too. Does it really make sense to say
"pull up or down depending on whatever the pin is intended for... but
whichever it is must be XXX Ohm"?
If you know the resistance you want, you surely already know whether you
want it pull up or down with that resistence.

Cheers
James


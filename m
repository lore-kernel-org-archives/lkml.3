Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423712Ab3FUTGw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 15:06:52 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:34413 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423612Ab3FUTGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 15:06:51 -0400
Message-ID: <51C4A447.3090807@wwwdotorg.org>
Date: Fri, 21 Jun 2013 13:06:47 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: James Hogan <james.hogan@imgtec.com>
CC: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        =?UTF-8?B?77+9?= <heiko@sntech.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Anmar Oueja <anmar.oueja@linaro.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH] pinctrl: establish pull-up/pull-down terminology
References: <1371379548-6482-1-git-send-email-linus.walleij@stericsson.com> <51C22A95.4050703@wwwdotorg.org> <51C2F7BE.2060805@imgtec.com>
In-Reply-To: <51C2F7BE.2060805@imgtec.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2013 06:38 AM, James Hogan wrote:
> On 19/06/13 23:03, Stephen Warren wrote:
>> On 06/16/2013 04:45 AM, Linus Walleij wrote:
>>> From: Linus Walleij <linus.walleij@linaro.org>
>>>
>>> It is counter-intuitive to have "0" mean disable in a boolean
>>> manner for electronic properties of pins such as pull-up and
>>> pull-down. Therefore, define that a pull-up/pull-down argument
>>> of 0 to such a generic option means that the pin is
>>> short-circuited to VDD or GROUND. Pull disablement shall be
>>> done using PIN_CONFIG_BIAS_DISABLE.
>>>
>>> Cc: Heiko St�bner <heiko@sntech.de>
>>> Cc: James Hogan <james.hogan@imgtec.com>
>>> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>>> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
>>> ---
>>>  include/linux/pinctrl/pinconf-generic.h | 13 +++++++------
>>>  1 file changed, 7 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/include/linux/pinctrl/pinconf-generic.h b/include/linux/pinctrl/pinconf-generic.h
>>> index d414a77..67780f5 100644
>>> --- a/include/linux/pinctrl/pinconf-generic.h
>>> +++ b/include/linux/pinctrl/pinconf-generic.h
>>> @@ -36,14 +36,15 @@
>>>   *	tristate. The argument is ignored.
>>>   * @PIN_CONFIG_BIAS_PULL_UP: the pin will be pulled up (usually with high
>>>   *	impedance to VDD). If the argument is != 0 pull-up is enabled,
>>> - *	if it is 0, pull-up is disabled.
>>> + *	if it is 0, pull-up it total, i.e. the pin is connected to VDD.
>>>   * @PIN_CONFIG_BIAS_PULL_DOWN: the pin will be pulled down (usually with high
>>>   *	impedance to GROUND). If the argument is != 0 pull-down is enabled,
>>> - *	if it is 0, pull-down is disabled.
>>> + *	if it is 0, pull-down is total, i.e. the pin is connected to GROUND.
>>>   * @PIN_CONFIG_BIAS_PULL_PIN_DEFAULT: the pin will be pulled up or down based
>>>   *	on embedded knowledge of the controller, like current mux function.
>>> - *	If the argument is != 0 pull up/down is enabled, if it is 0,
>>> - *	the pull is disabled.
>>> + *	If the argument is != 0 pull up/down is enabled, if it is 0, the
>>> + *	configuration is ignored. The proper way to disable it is to use
>>> + *	@PIN_CONFIG_BIAS_DISABLE.
>>
>> Why treat PULL_UP/PULL_DOWN differently from PULL_PIN_DEFAULT?
>> PULL_PIN_DEFAULT is logically simply a macro that selects PULL_UP/DOWN
>> based on what's "normal" for the pin's expected usage, so surely the
>> value associated with that option should behave identically?
> 
> I'm not familiar with hardware that does this so I could be way wrong
> here, but presumably if there's a default up/down, there's probably a
> default resistance too. Does it really make sense to say
> "pull up or down depending on whatever the pin is intended for... but
> whichever it is must be XXX Ohm"?
> If you know the resistance you want, you surely already know whether you
> want it pull up or down with that resistence.

IIRC the idea of the PULL_PIN_DEFAULT was to avoid having to specify
UP/DOWN for each pin/group, but could just say "default", which would
then reduce the number of pinctrl mapping table entries or pinctrl DT
property entries. I don't think this would have any interaction with
setting the resistance; it's entirely plausible that you'd want the same
explicit, or same default, resistance, for all pins, irrespective of
pull-up vs. down.

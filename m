Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760194Ab3BHRGZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 12:06:25 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:46674 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758581Ab3BHRGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 12:06:24 -0500
Message-ID: <5115308C.5010400@wwwdotorg.org>
Date: Fri, 08 Feb 2013 10:06:20 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: Anmar Oueja <anmar.oueja@linaro.org>, linux-arm-kernel@lists.infradead.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@nvidia.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/14] pinctrl/abx500: use direct IRQ defines
References: <1360093715-6348-1-git-send-email-linus.walleij@stericsson.com> <1360093715-6348-10-git-send-email-linus.walleij@stericsson.com> <5112F1B9.6010700@wwwdotorg.org> <CAF2Aj3jHe+mP0dU_BHThBV-va_iJLcFQedmWQOTaYafAZM1Yxg@mail.gmail.com> <5113EB8B.4060002@wwwdotorg.org> <20130208082536.GF7519@gmail.com>
In-Reply-To: <20130208082536.GF7519@gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/08/2013 01:25 AM, Lee Jones wrote:
> On Thu, 07 Feb 2013, Stephen Warren wrote:
> 
>> On 02/07/2013 02:01 AM, Lee Jones wrote:
>>> I don't see myself on cc. Was that intentional?
>>
>> The original patch was that way; I assume git send-email only CC'd you
>> on patches written by you.
> 
> No, I didn't send this patch at all.
> 
> I was asking Linus if he ment to CC me, as I thought I should have been.
> 
>>> I quite like the idea of this.
>>>
>>> Stephen,
>>>
>>> It doesn't mean the other patch was wrong, it just transfers the math.
>>
>> Ah, I see. The issue is that the code below clearly calculates the hwirq
>> differently, and it wasn't immediately obvious that this part of the
>> patch for example:
>>
>>>  struct abx500_gpio_irq_cluster ab8500_gpio_irq_cluster[] = {
>>> -	GPIO_IRQ_CLUSTER(6,  13, 34),
>>> -	GPIO_IRQ_CLUSTER(24, 25, 24),
>>> -	GPIO_IRQ_CLUSTER(36, 41, 14),
>>> +	GPIO_IRQ_CLUSTER(6,  13, AB8500_INT_GPIO6R),
>>> +	GPIO_IRQ_CLUSTER(24, 25, AB8500_INT_GPIO24R),
>>> +	GPIO_IRQ_CLUSTER(36, 41, AB8500_INT_GPIO36R),
>>>  };
>>
>> ... actually changes the values in the table (AB8500_INT_GPIO6R is 40,
>> so when using that value, you need to subtract of the value 6 for the
>> base to get the original 34).
> 
> Yes, I see how that may of looked if you didn't see the other change.
> 
> So you're happy?

Yes.


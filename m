Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756835Ab3JJTuX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 15:50:23 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:44920 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755723Ab3JJTuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 15:50:22 -0400
Message-ID: <5257052C.4050206@metafoo.de>
Date: Thu, 10 Oct 2013 21:51:08 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130827 Icedove/17.0.8
MIME-Version: 1.0
To: Wolfram Sang <wsa@the-dreams.de>
CC: Ionut Nicu <ioan.nicu.ext@nsn.com>,
        Peter Korsgaard <peter.korsgaard@barco.com>,
        Alexander Sverdlin <alexander.sverdlin@nsn.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-gpio@vger.kernel.org
Subject: Re: [PATCH 1/2] i2c-mux-gpio: test if the gpio can sleep
References: <525667C4.3080309@nsn.com> <52566971.5020700@metafoo.de> <20131010194354.GC23512@katana>
In-Reply-To: <20131010194354.GC23512@katana>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10/2013 09:43 PM, Wolfram Sang wrote:
> On Thu, Oct 10, 2013 at 10:46:41AM +0200, Lars-Peter Clausen wrote:
>
>>> +		if (gpio_cansleep(gpio))
>>> +			gpio_set_value_cansleep(gpio, val & (1 << i));
>>> +		else
>>> +			gpio_set_value(gpio, val & (1 << i));
>>
>> The proper way to do this is just always use the _cansleep() version.
>> gpio_set_value() only works for chips which do not sleep,
>> gpio_set_value_cansleep() works for both those who do sleep and those who do
>> not.
>
> To the gpio-list: Has it been considered to have sth. like
> gpio_set_value and gpio_set_value_nosleep? I'd think it makes more sense
> to have the specific function have the specific name.

It has been a few times, but I think the conclusion has always been that it is 
now too late to invert the semantics of gpio_set_value(). If you want to look 
up the discussions the keyword is gpio_set_value_atomic().

- Lars


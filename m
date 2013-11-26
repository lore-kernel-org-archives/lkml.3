Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756515Ab3KZMHq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 07:07:46 -0500
Received: from mail.active-venture.com ([67.228.131.205]:50578 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755276Ab3KZMHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 07:07:45 -0500
X-Originating-IP: 108.223.40.66
Message-ID: <52948F0E.9080303@roeck-us.net>
Date: Tue, 26 Nov 2013 04:07:42 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>
CC: linux-kernel@vger.kernel.org, MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH] extcon: gpio: Request gpio pin before modifying its state
References: <1385141161-7785-1-git-send-email-linux@roeck-us.net> <52945409.5040502@samsung.com>
In-Reply-To: <52945409.5040502@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2013 11:55 PM, Chanwoo Choi wrote:
> Hi Guenter,
>
> On 11/23/2013 02:26 AM, Guenter Roeck wrote:
>> Commit 338de0ca (extcon: gpio: Use gpio driver/chip debounce if supported)
>> introduced a call to gpio_set_debounce() before actually requesting the
>> respective gpio pin from the gpio subsystem.
>>
>> The gpio subsystem expects that a gpio pin was requested before modifying its
>> state. Not doing so results in a warning from gpiolib, and the gpio pin is
>> auto-requested. This in turn causes the subsequent devm_gpio_request_one()
>> to fail. So devm_gpio_request_one() must be called prior to calling
>> gpio_set_debounce().
>>
>> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
>> ---
>>   drivers/extcon/extcon-gpio.c |   11 ++++++-----
>>   1 file changed, 6 insertions(+), 5 deletions(-)
>>
>
> Applid it on extcon-next branch.
>

As this is a bug fix, I think it would make sense to have this applied to the current
kernel and not wait for 3.14.

Thanks,
Guenter



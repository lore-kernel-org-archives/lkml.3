Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932946AbaCSIiH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 04:38:07 -0400
Received: from mail-ve0-f177.google.com ([209.85.128.177]:48905 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932595AbaCSIiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 04:38:03 -0400
MIME-Version: 1.0
In-Reply-To: <53295654.5080009@codethink.co.uk>
References: <1395139290-4207-1-git-send-email-ben.dooks@codethink.co.uk>
 <CAAVeFuLJOSikb3pXffbC7Y4LDKXd-PQ_cadtT1q=TLCyWVh=MA@mail.gmail.com> <53295654.5080009@codethink.co.uk>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Wed, 19 Mar 2014 17:37:42 +0900
Message-ID: <CAAVeFu+=D8PJwTUMmaA-PWR5SbBfzQPpdZhtychxZNft6SvmDA@mail.gmail.com>
Subject: Re: [PATCH] gpiolib: check if gpio_desc pointer is error or NULL
To: Ben Dooks <ben.dooks@codethink.co.uk>
Cc: linux-kernel@lists.codethink.co.uk,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 19, 2014 at 5:33 PM, Ben Dooks <ben.dooks@codethink.co.uk> wrote:
> On 19/03/14 02:48, Alexandre Courbot wrote:
>>
>> On Tue, Mar 18, 2014 at 7:41 PM, Ben Dooks <ben.dooks@codethink.co.uk>
>> wrote:
>>>
>>> Some of the gpiod_ calls take a pointer to a gpio_desc as their
>>> argument but only check to see if it is NULL to validate the
>>> input.
>>>
>>> Calls such as devm_gpiod_get() return an error-pointer if they
>>> fail, so doing the following will not work:
>>>
>>>          gpio = devm_gpiod_get(...);
>>>          gpiod_direction_output(gpio, 0);
>>>
>>> The sequence produces an OOPS like:
>>>
>>>          Unable to handle kernel paging request at virtual address
>>> fffffffe
>>>
>>> Change all calls that check for !desc to use IS_ERR_OR_NULL() to
>>> avoid these issues.
>>
>>
>> This change is certainly correct from a semantics point of view. Maybe
>> I'd argue that the burden is on the caller to check that gpiod_get()
>> returns a valid GPIO descriptor, but having extra security doesn't
>> hurt. However my problem with this change in its current form is that
>> it will hide such forgetfulnesses by making functions like
>> gpiod_get_value() fail silently instead of triggering a oops.
>
>
> On the other hand, it means that we do not have to keep checking
> the validity of the pointer in the caller.

A very scary perspective which I don't think we should support.
Especially since the pointer only needs to be checked once, after
gpiod_get() is called.

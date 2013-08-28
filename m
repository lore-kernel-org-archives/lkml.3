Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849Ab3H1LND (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 07:13:03 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:40651 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993Ab3H1LNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 07:13:01 -0400
MIME-Version: 1.0
In-Reply-To: <CAFRkauCc4jnsEhdX_MrS39xO4Nuh6m7eaaMPzYCf2OyZstNaOQ@mail.gmail.com>
References: <1376877989.10251.2.camel@phoenix>
	<1376878066.10251.4.camel@phoenix>
	<CACRpkdauvk4Gw_k6TaYSH32nA66M_MHHksx6ESrqYx1PetWdug@mail.gmail.com>
	<CAFRkauCc4jnsEhdX_MrS39xO4Nuh6m7eaaMPzYCf2OyZstNaOQ@mail.gmail.com>
Date: Wed, 28 Aug 2013 13:13:00 +0200
Message-ID: <CACRpkdY1RbRA49ZGnco6RG1E34t9i31fV83FePcC3JBPBOenmg@mail.gmail.com>
Subject: Re: [PATCH 2/2] pinctrl: core: Add proper mutex lock in pinctrl_request_gpio
From: Linus Walleij <linus.walleij@linaro.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Patrice Chotard <patrice.chotard@st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 22, 2013 at 5:41 AM, Axel Lin <axel.lin@ingics.com> wrote:
> 2013/8/22 Linus Walleij <linus.walleij@linaro.org>:

>>> +       mutex_lock(&pctldev->mutex);
>>> +
>>>         /* Convert to the pin controllers number space */
>>>         pin = gpio_to_pin(range, gpio);
>>>
>>>         ret = pinmux_request_gpio(pctldev, range, pin, gpio);
>>>
>>> +       mutex_unlock(&pctldev->mutex);
>>> +
>>>         return ret;
>>
>> What is this protecting against?
>>
>> I'm not sure I follow this so better ask.
>
> I think this fixes the race between pin_free() and pin_request() calls.
> (Well, I don't have a h/w to test at this moment.)
> It protects accessing the members of pctldev->desc.
> (e.g. update desc->mux_usecount, desc->gpio_owner, desc->mux_owner, etc)
> Current code grabs pctldev->mutex before calling pinmux_free_gpio(),
> but did not grab the mutex while calling pinmux_request_gpio().

OK you won me over, patch applied!

I also edited in some of the above text into the commit.

Yours,
Linus Walleij

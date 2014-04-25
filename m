Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752183AbaDYHif (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 03:38:35 -0400
Received: from mail-ve0-f175.google.com ([209.85.128.175]:38534 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529AbaDYHid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 03:38:33 -0400
MIME-Version: 1.0
In-Reply-To: <CAL_Jsq+DwCBLoNYsgHnoLQgSMnSBDM5XH_xoWS-RWdmx-JBeXg@mail.gmail.com>
References: <1398266889-17489-1-git-send-email-thierry.reding@gmail.com>
 <1398266889-17489-2-git-send-email-thierry.reding@gmail.com>
 <CACRpkdadAUXgC-K6be6SFFn2ZTvCqkTK7VRJEzpFdUbybKc3YA@mail.gmail.com> <CAL_Jsq+DwCBLoNYsgHnoLQgSMnSBDM5XH_xoWS-RWdmx-JBeXg@mail.gmail.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Fri, 25 Apr 2014 16:38:12 +0900
Message-ID: <CAAVeFuJuZQAhM9uz_ENY4vwvHMvdwz62+-AmNwuzgZH_=x7dow@mail.gmail.com>
Subject: Re: [PATCH 2/2] gpio: of: Allow -gpio suffix for property names
To: Rob Herring <robherring2@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2014 at 11:06 PM, Rob Herring <robherring2@gmail.com> wrote:
> On Thu, Apr 24, 2014 at 7:47 AM, Linus Walleij <linus.walleij@linaro.org> wrote:
>> On Wed, Apr 23, 2014 at 5:28 PM, Thierry Reding
>> <thierry.reding@gmail.com> wrote:
>>
>>> From: Thierry Reding <treding@nvidia.com>
>>>
>>> Many bindings use the -gpio suffix in property names. Support this in
>>> addition to the -gpios suffix when requesting GPIOs using the new
>>> descriptor-based API.
>>>
>>> Signed-off-by: Thierry Reding <treding@nvidia.com>
>>
>> Are the DT bindings really full of such ambiguity between
>> singular and plural? Examples?
>>
>> What happens in affected drivers today? It just doesn't work?
>
> They mostly seem to use of_get_named_gpio.

In an idea world of_get_named_gpio() would be gpiolib-private so
people cannot come with their own custom-named DT GPIO properties.
Given its broad usage this is not possible, but maybe we can at least
do it for of_get_named_gpiod().

>
>>
>> Does that mean these bindings are not actively used by any
>> drivers yet so we could augment the bindings instead, or are
>> they already deployed so we must implement this?
>>
>> Would like a word from the DT people here...
>
> Interestingly, there is not a single occurrence of '-gpio ' in
> powerpc, but a bunch in ARM. In hindsight, we should have perhaps
> enforced using -gpios only, but that doesn't really matter now. We
> have -gpio in use, so we need to support it. That doesn't necessarily
> mean this function has to support it. For example, this function could
> a legacy method and some other function should be used instead
> (of_get_named_gpio perhaps).

It seems like we have to support that use-case indeed (many instances
in arch/arm). The incentive for handling this in that function vs.
user code is that having support here would allow drivers to directly
use gpiod_get() and having it automatically handle GPIO properties
like active-low instead of requiring user code to handle it by itself
every time.

Without this many drivers for devices using "-gpio" properties could
not switch to the new gpiod interface.

So as far as I'm concerned this code makes GPIO user-code easier. This
is not to say that we should allow that "-gpio" suffix for new
bindings.

Acked-by: Alexandre Courbot <acourbot@nvidia.com>

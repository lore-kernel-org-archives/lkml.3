Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932369AbaJ3AcG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 20:32:06 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:62301 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756762AbaJ3AcD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 20:32:03 -0400
MIME-Version: 1.0
In-Reply-To: <2BA5D07E-B5EF-49E1-BFD2-310A6C5F3FE4@gmail.com>
References: <1413922198-29373-1-git-send-email-bparrot@ti.com>
 <3D00ADB3-00B3-40A8-8263-444BCADDAC33@gmail.com> <20141029163445.GB29965@ti.com>
 <2BA5D07E-B5EF-49E1-BFD2-310A6C5F3FE4@gmail.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Thu, 30 Oct 2014 09:31:42 +0900
Message-ID: <CAAVeFu+OxSntee5dkwW+Hq83BFiSpUY=ipruer8ySDLmRLWzBw@mail.gmail.com>
Subject: Re: [RFC Patch] gpio: add GPIO hogging mechanism
To: Pantelis Antoniou <pantelis.antoniou@gmail.com>
Cc: Benoit Parrot <bparrot@ti.com>, Linus Walleij <linus.walleij@linaro.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2014 at 1:42 AM, Pantelis Antoniou
<pantelis.antoniou@gmail.com> wrote:
> Hi Benoit,
>
>> On Oct 29, 2014, at 18:34 , Benoit Parrot <bparrot@ti.com> wrote:
>>
>> Pantelis,
>>
>> Thanks for the feedback.
>>
>> Pantelis Antoniou <pantelis.antoniou@gmail.com> wrote on Wed [2014-Oct-29 10:53:44 +0200]:
>>> Hi Benoit,
>>>
>>>> On Oct 21, 2014, at 23:09 , Benoit Parrot <bparrot@ti.com> wrote:
>>>>
>>>> Based on Boris Brezillion work this is a reworked patch
>>>> of his initial GPIO hogging mechanism.
>>>> This patch provides a way to initally configure specific GPIO
>>>> when the gpio controller is probe.
>>>>
>>>> The actual DT scanning to collect the GPIO specific data is performed
>>>> as part of the gpiochip_add().
>>>>
>>>> The purpose of this is to allows specific GPIOs to be configured
>>>> without any driver specific code.
>>>> This particularly usueful because board design are getting
>>>> increassingly complex and given SoC pins can now have upward
>>>> of 10 mux values a lot of connections are now dependent on
>>>> external IO muxes to switch various modes and combination.
>>>>
>>>> Specific drivers should not necessarily need to be aware of
>>>> what accounts to a specific board implementation. This board level
>>>> "description" should be best kept as part of the dts file.
>>>>
>>>
>>> This look like it’s going to the right direction. I have a few general
>>> comments at first.
>>>
>>> 1) It relies on dubious DT binding of having sub-nodes of the
>>> gpio device implicitly defining hogs.
>>
>> I think in this instance the nodes are explicitly defining hogs.
>> Please clarify. What would you like to see here?
>>>
>
> Any subnodes are implicitly taken as hog definitions. This is not right because
> gpio controllers might have subnodes that they use for another purpose.
>
>>> 2) There is no way for having hogs inserted dynamically as far as I can tell, and
>>> no way to remove a hog either.
>>
>> The original patch was allowing that but, Linus's review comment suggested this feature be
>> part of the gpio-controller's gpiochip_add() hook only.
>>
>
> If it’s not possible to remove a hog, then it’s no good for my use case in which
> the gpios get exported and then removed.

Why would you want to remove a GPIO hog at runtime, and what is the
point of having it set in the DT in that case?

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752569AbaH2Fyp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 01:54:45 -0400
Received: from mail.active-venture.com ([67.228.131.205]:59694 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559AbaH2Fyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 01:54:43 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <5400159F.4070608@roeck-us.net>
Date: Thu, 28 Aug 2014 22:54:39 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>
CC: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [RFC PATCH] gpiolib: Provide and export gpiod_export_name
References: <1406139132-5404-1-git-send-email-linux@roeck-us.net>	<CAAVeFuKsJpSYo2DMyTdYE2J5Cu_ZD=b9o-=S0DLDccyNmwniNg@mail.gmail.com>	<53D0A8B7.2010005@roeck-us.net>	<CAAVeFuK5uKhpkpEnoRFGKU4G4Fey0+giz5wwmtr+OCLJHPvnLQ@mail.gmail.com>	<53E32C09.5000704@roeck-us.net>	<CAAVeFuJohBznnjELvJj0OUCK+anbZ-j1xPc9gyKDGVq9X0MDSA@mail.gmail.com>	<53E8DE1D.9070503@roeck-us.net>	<CAAVeFuK8kb3kopVaM9qz+qOa4RT_oji8LNLQa_UHDxxxwyfZgw@mail.gmail.com> <CACRpkdZfRxNHGtZvzjn_vb2FGNPrvh1znWSGi0znN2_yHmz0Tw@mail.gmail.com>
In-Reply-To: <CACRpkdZfRxNHGtZvzjn_vb2FGNPrvh1znWSGi0znN2_yHmz0Tw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/28/2014 10:44 PM, Linus Walleij wrote:
> On Mon, Aug 11, 2014 at 5:20 PM, Alexandre Courbot <gnurou@gmail.com> wrote:
>> On Tue, Aug 12, 2014 at 12:15 AM, Guenter Roeck <linux@roeck-us.net> wrote:
>
>>> This is just one of many patches which would make it possible to submit
>>> the rest, which would make use of it. What you are saying is that it won't
>>> make sense to submit that series into the kernel, because one of the very
>>> first patches needed to enable that won't be accepted. Kind of a circular
>>> argument, but I guess I'll have to live with it.
>>
>> Well I have not seen the other patches you mention and cannot guess
>> their existence. If you send the full series it will of course be
>> considered as such, but right now this lone patch does not hint any
>> upstream user for this interface.
>>
>> Note that this doesn't change anything to the core of the argument ;
>> we have not heard what Linus thinks about named GPIOs in
>> /sys/class/gpio yet, maybe he will have a different opinion...
>
> The sysfs is sort of broken by design because of things like this and
> some other stuff.
>
> I think the sysfs is scary, for example since it's not hierarchical
> but flat and build on the assumption that there is one single
> GPIO numberspace. As pointed out in some other message
> in the thread it would be nicer to have:
>
> /dev/gpiochip0/gpio0
> /dev/gpiochip0/gpio1
> ....
>
> instead of the horrid sysfs ABI that will have to maintain forever.
>
Blocking any attempts to make it more useful doesn't help much, though.

> Still it is true that there is a precedent for named GPIOs in sysfs.
>
> And in the end, userspace needs a way to figure out how to
> get what it needs, a unique string is as good as anything.
> I would be feeling better if userspace got that name from an
> ioctl() on some /dev/* node than by plain filename search in
> sysfs. I somewhat feel a named gpio in sysfs is more
> helpful than just "gpio25".
>

That was the point. The code necessary to find out that a specific
function on a specific board is tied to gpiochip X pin Y is quite
complex. It seemed to be much easier to be able to rely on a well
defined pin name.

The argument of "there can be duplicate names" is, in my opinion,
quite bogus. Sure, there can be duplicate names. That is why one
has error codes. With such an argument you can block anything
you want.

Regarding ioctls, I thought sysfs was supposed to replace ioctls,
and that adding new ioctls was discouraged. Are we reverting on that ?

> But I'm not happy about merging the patch if Alexandre is
> hesitant.
>

Guess that's life. I'll just have to live with it.

Guenter


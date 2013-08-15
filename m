Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752343Ab3HOWSu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 18:18:50 -0400
Received: from mail.active-venture.com ([67.228.131.205]:55936 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481Ab3HOWSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 18:18:49 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <520D53CA.6040807@roeck-us.net>
Date: Thu, 15 Aug 2013 15:18:50 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Peter Maydell <peter.maydell@linaro.org>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        QEMU Developers <qemu-devel@nongnu.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>
Subject: Re: [Qemu-devel] SCSI bus failures with qemu-arm in kernel 3.8+
References: <5207B3C3.9080508@roeck-us.net> <20130811220450.GY23006@n2100.arm.linux.org.uk> <52082EF8.10005@roeck-us.net> <CAFEAcA94ygwRPSsfxs3DvOcTZbdafLiEHys94FG4aXUx+A1t=A@mail.gmail.com> <20130813034054.GA18218@roeck-us.net> <CAFEAcA_-S8z6ZMr8TMPvkcTyyCSMOj1DExVsY4JDQjRXDU5WGw@mail.gmail.com> <20130815175428.GA18580@roeck-us.net> <CAFEAcA_MyJPwo6Gd_dxeWM5q5-7MYqR6-rrePusFzYaGGckWJQ@mail.gmail.com> <20130815205044.GA21599@roeck-us.net> <CAFEAcA-ALD+dDWAB+Rd1V+TXQLYGe-qRKC0uFUP0Bt2SGfKDRg@mail.gmail.com>
In-Reply-To: <CAFEAcA-ALD+dDWAB+Rd1V+TXQLYGe-qRKC0uFUP0Bt2SGfKDRg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/15/2013 02:49 PM, Peter Maydell wrote:
> On 15 August 2013 21:50, Guenter Roeck <linux@roeck-us.net> wrote:
>> On Thu, Aug 15, 2013 at 07:05:22PM +0100, Peter Maydell wrote:
>>> It needs to go in the same patch, because a kernel with the fixed
>>> irq remapping must also tell QEMU it is fixed; if you split the
>>> two then at the point between the two patches the kernel is
>>> broken for bisection purposes.
>>>
>> Thinking about it - is that really true ? My image with the
>> patch applied works just fine under qemu 1.5.2, and unless
>> I am missing something it won't work with qemu 1.4 anyway.
>> So what exactly is broken ?
>
> You're OK unless the kernel happens to pick the same interrupt
> number to write to PCI_INTERRUPT_LINE as one of the previous
> broken kernel versions did (in which case QEMU will incorrectly
> assume you're a broken kernel). This can't happen with the way
> the kernel is currently picking interrupt numbers (ie with a
> straightforward relationship between h/w irqs and values written),
> but as I understand from Arnd there is a plan to move to a
> different approach ("sparse irqs") at which point this won't hold:
> http://lists.gnu.org/archive/html/qemu-devel/2013-03/msg04579.html
> So it's better for the kernel to make sure it gets the
> behaviour it wants rather than getting unpleasant surprises
> later.
>

But doesn't that mean that there is _currently_ no problem ? If so,
we can introduce the additional code when the problem really shows up.
Being Preemptive is good, but if it is not really needed today
I would rather have today's problems resolved and bother about tomorrow's
when they show up.

Guenter


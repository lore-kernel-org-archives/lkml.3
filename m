Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756790AbaJXRbP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 13:31:15 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:49839 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755894AbaJXRbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 13:31:13 -0400
MIME-Version: 1.0
In-Reply-To: <544628BF.8010809@arm.com>
References: <1408479811-26088-1-git-send-email-bjorn.andersson@sonymobile.com>
	<CAJAp7OgGPZZuCgC8iUiW2jrEVubK=KCATxd6eazdT1x1sSrffg@mail.gmail.com>
	<alpine.DEB.2.11.1410211120430.5308@nanos>
	<544628BF.8010809@arm.com>
Date: Fri, 24 Oct 2014 10:31:11 -0700
Message-ID: <CAJAp7OjpN-+S=OH1BW6Fcme9mp4qj8AsSNC3_41fhfpYzX-Shg@mail.gmail.com>
Subject: Re: [PATCH] genirq: Introduce irq_read_line()
From: Bjorn Andersson <bjorn@kryo.se>
To: Marc Zyngier <marc.zyngier@arm.com>, Stephen Boyd <sboyd@codeaurora.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Abhijeet Dharmapurikar <adharmap@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2014 at 2:34 AM, Marc Zyngier <marc.zyngier@arm.com> wrote:
> Hi all,
>
> On 21/10/14 10:22, Thomas Gleixner wrote:
>> On Thu, 4 Sep 2014, Bjorn Andersson wrote:
>>
>>> On Tue, Aug 19, 2014 at 1:23 PM, Bjorn Andersson
>>> <bjorn.andersson@sonymobile.com> wrote:
>>>> Introduce the irq_read_line() function to allow device drivers to read
>>>> the current logical state of an input when the hardware only exposes
>>>> this through status bits in the interrupt controller.
>>>>
>>>> The new function is backed by a new callback function in the irq_chip -
>>>> irq_read_line() - that can be implemented by irq_chips that owns such
>>>> status bits.
>>>>
>>>> Based on rfc patch from April 2011 by Abhijeet.
>>>>
>>>> Cc: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
>>>> Signed-off-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
>>>
>>> ping?
>>
>> Sorry, slipped through the cracks. I was talking about this to Marc
>> last week and he needs it for yet another reason. He had some thoughts
>> about the state representation, so I wait for him to comment.
>
> Thanks for putting me in the loop. For the record, here's the RFC I
> posted back in June:
>

Thanks for having a similar problem as me :)

> http://lists.infradead.org/pipermail/linux-arm-kernel/2014-June/266328.html
>
> and the patch implementing a similar concept:
> http://lists.infradead.org/pipermail/linux-arm-kernel/2014-June/266331.html
>

I would prefer to see that you had explicit functions for the various things
that you would like to set and get. It would in my eyes give cleaner client
code, at the cost of a few extra functions.

> Basic idea is that you can read (and possibly write back) various
> low-level attributes (pending, masked, active) that an interrupt
> controller may implement. Given your use case, we should loose the
> checks on the interrupt being forwarded, as this makes little sense
> outside of virtualization.
>

Relaxing the forwarding requirement seems to solve my use cases. May I ask why
your accessors would only be made available for forwarded IRQs - at a framework
level?

Stephen Boyd talked about the need to be able to mask/unmask interrupts from
client code in the Qualcomm platform as well - most likely to block wakeup
sources(?)

> I'm planning to respin the series this week, as I have a number of
> changes (there is hardly any need for the various states to be reported
> atomically, for example), and a number of bugs have been found.
>

Sounds good, for clarity I would like them to be explicit separate functions.
But as long as it's not limited to forwarded IRQs we should be able to use it.

Regards,
Bjorn

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932111AbaJVAOZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 20:14:25 -0400
Received: from exprod5og107.obsmtp.com ([64.18.0.184]:51394 "HELO
	exprod5og107.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751191AbaJVAOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 20:14:23 -0400
MIME-Version: 1.0
In-Reply-To: <1894914.TrPC3AEWES@wuerfel>
References: <1408479811-26088-1-git-send-email-bjorn.andersson@sonymobile.com>
	<CAJAp7OgGPZZuCgC8iUiW2jrEVubK=KCATxd6eazdT1x1sSrffg@mail.gmail.com>
	<alpine.DEB.2.11.1410211120430.5308@nanos>
	<1894914.TrPC3AEWES@wuerfel>
Date: Tue, 21 Oct 2014 17:14:21 -0700
Message-ID: <CAL85gmCLkAiyrVtQzyiOuXM8A1y97H7nYWj5BJy5ZsVn3eDBug@mail.gmail.com>
Subject: Re: [PATCH] genirq: Introduce irq_read_line()
From: Feng Kan <fkan@apm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Bjorn Andersson <bjorn@kryo.se>,
        Marc Zyngier <marc.zyngier@arm.com>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Abhijeet Dharmapurikar <adharmap@codeaurora.org>, Y Vo <yvo@apm.com>,
        Tin Huynh <tnhuynh@apm.com>, patches <patches@apm.com>,
        Toan Le <toanle@apm.com>, Phong Vo <pvo@apm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2014 at 2:30 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Tuesday 21 October 2014 11:22:40 Thomas Gleixner wrote:
>> On Thu, 4 Sep 2014, Bjorn Andersson wrote:
>>
>> > On Tue, Aug 19, 2014 at 1:23 PM, Bjorn Andersson
>> > <bjorn.andersson@sonymobile.com> wrote:
>> > > Introduce the irq_read_line() function to allow device drivers to read
>> > > the current logical state of an input when the hardware only exposes
>> > > this through status bits in the interrupt controller.
>> > >
>> > > The new function is backed by a new callback function in the irq_chip -
>> > > irq_read_line() - that can be implemented by irq_chips that owns such
>> > > status bits.
>> > >
>> > > Based on rfc patch from April 2011 by Abhijeet.
>> > >
>> > > Cc: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
>> > > Signed-off-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
>> >
>> > ping?
>>
>> Sorry, slipped through the cracks. I was talking about this to Marc
>> last week and he needs it for yet another reason. He had some thoughts
>> about the state representation, so I wait for him to comment.
>
> I looked up my older email as well and found which gpio driver had the
> requirement to get the irq status from the upstream controller. It was
> "gpio: Add APM X-Gene standby GPIO controller driver". I'm adding the
> APM developers on Cc here so they can participate in the discussion.
>
> As a brief summary: APM have a GPIO driver that needs to read the status
> from the ARM GIC in order to implement gpio_get_value.

Thanks, we will rebase our standby gpio patch on top of this change.

 The KVM hypervisor
> needs multiple bits from the GIC in order to implement suspend/resume,
> and Qualcomm MSM (as Bjorn wrote above) also needs to expose the status
> of the IRQ line like APM does.
>
> These should all use the same interface for the interrupt controller,
> but the interface still needs to be added.
>
>         Arnd
> CONFIDENTIALITY NOTICE: This e-mail message, including any attachments,
> is for the sole use of the intended recipient(s) and contains information
> that is confidential and proprietary to Applied Micro Circuits Corporation or its subsidiaries.
> It is to be used solely for the purpose of furthering the parties' business relationship.
> All unauthorized review, use, disclosure or distribution is prohibited.
> If you are not the intended recipient, please contact the sender by reply e-mail
> and destroy all copies of the original message.
>

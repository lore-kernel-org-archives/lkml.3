Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752873AbaJ1RNa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 13:13:30 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:38861 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029AbaJ1RN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 13:13:29 -0400
MIME-Version: 1.0
In-Reply-To: <544FBECB.3080608@arm.com>
References: <1408479811-26088-1-git-send-email-bjorn.andersson@sonymobile.com>
	<CAJAp7OgGPZZuCgC8iUiW2jrEVubK=KCATxd6eazdT1x1sSrffg@mail.gmail.com>
	<alpine.DEB.2.11.1410211120430.5308@nanos>
	<544628BF.8010809@arm.com>
	<CAJAp7OjpN-+S=OH1BW6Fcme9mp4qj8AsSNC3_41fhfpYzX-Shg@mail.gmail.com>
	<544A936D.5040409@arm.com>
	<CAJAp7OjQ8qRspy_ocUnp+es+HPiR1jULhKK6g4DBXXZcOsABug@mail.gmail.com>
	<874musjyfi.fsf@why.wild-wind.fr.eu.org>
	<CAJAp7OiXpksp_CPdpLYd2kwGXRNx2q+cq1a_hjc9fEBrcwXTiA@mail.gmail.com>
	<544FBECB.3080608@arm.com>
Date: Tue, 28 Oct 2014 10:13:26 -0700
Message-ID: <CAJAp7OigW_fyPYYz3FiVD=CEH32_fpazSd7z7Djh0eyop0pzLA@mail.gmail.com>
Subject: Re: [PATCH] genirq: Introduce irq_read_line()
From: Bjorn Andersson <bjorn@kryo.se>
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>, Thomas Gleixner <tglx@linutronix.de>,
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

On Tue, Oct 28, 2014 at 9:05 AM, Marc Zyngier <marc.zyngier@arm.com> wrote:
> On 28/10/14 15:41, Bjorn Andersson wrote:
>> On Sat, Oct 25, 2014 at 2:22 AM, Marc Zyngier <marc.zyngier@arm.com> wrote:
[..]
>> In the Qualcomm pmic we have two interrupt status registers
>> "interrupt" and "real-time". I think the "interrupt" status register
>> would be the one related to your defined constants. However what we
>> need to access in our use cases are the "real-time" status register,
>> which basically is a representation of the input to the interrupt
>> logic.
>
> Fancy. This really look like a i2c GPIO expander (not my best memories...).
>

It really is a kitchen sink, with among other things a set of gpios.

Due to limitations in address space many of the input bits are handled
through banked reads of the interrupt status bits. So that's where we
have access to gpio input, but also things like battery availability,
usb connected, charging status and so on.

>> As far as I can see the GIC does not offer anything like that, but I
>> hope we could add another constant to your enum list and utilise your
>> api for this.
>>
>> I'm not entirely sure what we should call it though,
>> IRQCHIP_STATE_LEVEL seems somewhat conflicting with level trigger and
>> the Qualcomm name IRQCHIP_STATE_REALTIME isn't very self describing.
>> Maybe IRQCHIP_STATE_LINE_LEVEL?
>
> Sure, that should be descriptive enough. I really we don't get too many
> of these though...
>
> Do you want me to wrap this into the next version?
>

Yes please.

Regards,
Bjorn

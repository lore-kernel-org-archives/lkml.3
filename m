Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755151AbaJ1QFl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 12:05:41 -0400
Received: from service87.mimecast.com ([91.220.42.44]:37309 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755075AbaJ1QFg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 12:05:36 -0400
Message-ID: <544FBECB.3080608@arm.com>
Date: Tue, 28 Oct 2014 16:05:31 +0000
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Bjorn Andersson <bjorn@kryo.se>
CC: Stephen Boyd <sboyd@codeaurora.org>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Abhijeet Dharmapurikar <adharmap@codeaurora.org>
Subject: Re: [PATCH] genirq: Introduce irq_read_line()
References: <1408479811-26088-1-git-send-email-bjorn.andersson@sonymobile.com> <CAJAp7OgGPZZuCgC8iUiW2jrEVubK=KCATxd6eazdT1x1sSrffg@mail.gmail.com> <alpine.DEB.2.11.1410211120430.5308@nanos>	<544628BF.8010809@arm.com> <CAJAp7OjpN-+S=OH1BW6Fcme9mp4qj8AsSNC3_41fhfpYzX-Shg@mail.gmail.com> <544A936D.5040409@arm.com> <CAJAp7OjQ8qRspy_ocUnp+es+HPiR1jULhKK6g4DBXXZcOsABug@mail.gmail.com> <874musjyfi.fsf@why.wild-wind.fr.eu.org> <CAJAp7OiXpksp_CPdpLYd2kwGXRNx2q+cq1a_hjc9fEBrcwXTiA@mail.gmail.com>
In-Reply-To: <CAJAp7OiXpksp_CPdpLYd2kwGXRNx2q+cq1a_hjc9fEBrcwXTiA@mail.gmail.com>
X-Enigmail-Version: 1.4.6
X-OriginalArrivalTime: 28 Oct 2014 16:05:32.0114 (UTC) FILETIME=[001AD320:01CFF2C9]
X-MC-Unique: 114102816053401201
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/10/14 15:41, Bjorn Andersson wrote:
> On Sat, Oct 25, 2014 at 2:22 AM, Marc Zyngier <marc.zyngier@arm.com> wrote:
>> On Sat, Oct 25 2014 at 12:12:55 am BST, Bjorn Andersson <bjorn@kryo.se> wrote:
>>> On Fri, Oct 24, 2014 at 10:59 AM, Marc Zyngier <marc.zyngier@arm.com> wrote:
>>>> I just pushed out a branch:
>>>> git://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git
>>>> irq/irqchip_state
>>>>
>>>> Please let me know if that's useful for you.
>>>>
>>>
>>> I think that my irq_read_line() would be equivalent of
>>> irq_get_irqchip_state(IRQCHIP_STATE_PENDING), i.e. the state of the
>>> interrupt ignoring masking. And the rest would be EINVAL.
>>> So I think this would work out just fine for us!
>>
>> Excellent.
>>
> 
> Hi Marc,
> 
> We gave this some more thought and read up on what "pending" and
> "active" means according to the ARM GIC - PENDING is not what we want
> :(
> 
> In the Qualcomm pmic we have two interrupt status registers
> "interrupt" and "real-time". I think the "interrupt" status register
> would be the one related to your defined constants. However what we
> need to access in our use cases are the "real-time" status register,
> which basically is a representation of the input to the interrupt
> logic.

Fancy. This really look like a i2c GPIO expander (not my best memories...).

> As far as I can see the GIC does not offer anything like that, but I
> hope we could add another constant to your enum list and utilise your
> api for this.
> 
> I'm not entirely sure what we should call it though,
> IRQCHIP_STATE_LEVEL seems somewhat conflicting with level trigger and
> the Qualcomm name IRQCHIP_STATE_REALTIME isn't very self describing.
> Maybe IRQCHIP_STATE_LINE_LEVEL?

Sure, that should be descriptive enough. I really we don't get too many
of these though...

Do you want me to wrap this into the next version?

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...


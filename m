Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126Ab3IPIQN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 04:16:13 -0400
Received: from service87.mimecast.com ([91.220.42.44]:45714 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565Ab3IPIQL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 04:16:11 -0400
Message-ID: <5236BE45.1090408@arm.com>
Date: Mon, 16 Sep 2013 09:16:05 +0100
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: "maxime.ripard@free-electrons.com" <maxime.ripard@free-electrons.com>
CC: cinifr <cinifr@gmail.com>, Mark Rutland <Mark.Rutland@arm.com>,
        "coosty@163.com" <coosty@163.com>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pawel.moll@arm.co" <pawel.moll@arm.co>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-sunxi@googlegroups.com" <linux-sunxi@googlegroups.com>
Subject: Re: [PATCH 3/4] Add physical count arch timer support for clocksource
 in ARMv7.
References: <1378968687-8200-1-git-send-email-cinifr@gmail.com> <1378968687-8200-4-git-send-email-cinifr@gmail.com> <20130912112452.GA22013@e106331-lin.cambridge.arm.com> <CAK3cCBwu4somtfc9J1ZDVcC-iYD1qDJwSWzWeOomTqY9tQA2kg@mail.gmail.com> <5231EE43.5090900@arm.com> <CAK3cCBzr8_LTYarZDgPYZY7_-5Qco_Qw+ACi=c2uOrn7MqwkBg@mail.gmail.com> <5232DB49.4050701@arm.com> <20130914120557.GB2746@lukather>
In-Reply-To: <20130914120557.GB2746@lukather>
X-Enigmail-Version: 1.4.6
X-OriginalArrivalTime: 16 Sep 2013 08:16:06.0628 (UTC) FILETIME=[FE0A7A40:01CEB2B4]
X-MC-Unique: 113091609160900501
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Maxime,

On 14/09/13 13:05, maxime.ripard@free-electrons.com wrote:
> Hi Marc, Fan,
> 
> On Fri, Sep 13, 2013 at 10:30:49AM +0100, Marc Zyngier wrote:
>> On 13/09/13 09:49, cinifr wrote:
>>> On 13 September 2013 00:39, Marc Zyngier <marc.zyngier@arm.com>
>>> wrote: I am   wondering   what is the principle between kernel
>>> and bootload? What should be done in bootloader and what should
>>> be done in kernel? As you said, If kernel boot from hyp,
>>> Kernel can set  CNTVOFF to zero directly, does we add the code
>>> to set CNTVOFF in kernel?  But, if kernel boot from PL1 NS=0,
>>> Does kernel  need to switch hyp mode to set  CNTVOFF and return
>>> PL1 NS=0 mode? Or,kernel dont care it because kernel   believe
>>> bootloader have set CNTVOFF  before?
>> 
>> In an ideal world, the bootloader should set CNTVOFF to zero. The
>> fact that the kernel does it too when booted in HYP mode is to
>> preserve itself from from broken bootloaders.
>> 
>> CNTVOFF can only be setup from either HYP or Secure Monitor mode
>> with SCR.NS == 1, so if you run your kernel in secure mode, it is
>> always best to do it in the bootloader.
> 
> What would happen exactly if a kernel expects CNTVOFF to be set to
> 0, and that your bootloader don't set it?

It doesn't really matter if it is set to 0. What actually matters is
that all the CPUs have the same value. Otherwise, you will have time
reported differently depending on the CPU you're looking from.

> From what you're saying, it's will be set by the kernel if it's
> booted in hypervisor mode, but what if it's not?
> 
> The ARM documentation says that the CNTVOFF register will hold an 
> undefined value, how would that affect the kernel?

See above. Without a consistent view of time across CPUs, you're in
deep trouble.

	M.
-- 
Jazz is not dead. It just smells funny...


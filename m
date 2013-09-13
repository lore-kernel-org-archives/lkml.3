Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758242Ab3IMNki (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 09:40:38 -0400
Received: from service87.mimecast.com ([91.220.42.44]:45800 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757514Ab3IMNkg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 09:40:36 -0400
Message-ID: <523315CD.8010704@arm.com>
Date: Fri, 13 Sep 2013 14:40:29 +0100
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: cinifr <cinifr@gmail.com>
CC: Mark Rutland <Mark.Rutland@arm.com>, "coosty@163.com" <coosty@163.com>,
        "maxime.ripard@free-electrons.com" <maxime.ripard@free-electrons.com>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-sunxi@googlegroups.com" <linux-sunxi@googlegroups.com>
Subject: Re: [PATCH 3/4] Add physical count arch timer support for clocksource
 in ARMv7.
References: <1378968687-8200-1-git-send-email-cinifr@gmail.com> <1378968687-8200-4-git-send-email-cinifr@gmail.com> <20130912112452.GA22013@e106331-lin.cambridge.arm.com> <CAK3cCBwu4somtfc9J1ZDVcC-iYD1qDJwSWzWeOomTqY9tQA2kg@mail.gmail.com> <5231EE43.5090900@arm.com> <CAK3cCBzr8_LTYarZDgPYZY7_-5Qco_Qw+ACi=c2uOrn7MqwkBg@mail.gmail.com> <5232DB49.4050701@arm.com> <CAK3cCBw4EKypLmhf4L5_P3d27QzsrB+ZxUTgF58YhmUhBa00xQ@mail.gmail.com>
In-Reply-To: <CAK3cCBw4EKypLmhf4L5_P3d27QzsrB+ZxUTgF58YhmUhBa00xQ@mail.gmail.com>
X-Enigmail-Version: 1.4.6
X-OriginalArrivalTime: 13 Sep 2013 13:40:28.0128 (UTC) FILETIME=[CEC27600:01CEB086]
X-MC-Unique: 113091314403304801
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/09/13 14:09, cinifr wrote:
>> I urge you to read the ARM ARM, and specifically the section dedicated
>> to trapping access to CP15 operations. If you do, you'll quickly notice
>> that you *cannot* trap accesses to the timer subsystem.
>>
> I read it again. The ARMv7 manual said "Is accessible from Non-secure
> PL1 modes only when CNTHCTL.PL1PCTEN is set to 1. When
> CNTHCTL.PL1PCTEN is set to 0, any attempt to access CNTPCT from a
> Non-secure PL1 mode ***generates a Hyp Trap exception***, see Hyp Trap
> exception on page B1-1206" in B8.1.2. but I dont find  a  special hyp
> trap control  for accessing CNTPCT in manual. As you said HSTR cannot
> trap accessing of CP15 c14. What happer when OS access CNTPCT from PL1
> NS=1 mode with CNTHCTL.PL1PCTEN=0 ???  AmI  wrong for understanding
> the manual?

That's interesting, as I never noticed this particular line in the ARM
ARM. I'll investigate this, thanks for bringing it up.

This doesn't change the fact that using the physical timer/counter in a
VM is (or can be) horribly expensive, and should be avoided at all cost.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932564Ab3IMNKE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 09:10:04 -0400
Received: from mail-bk0-f42.google.com ([209.85.214.42]:58852 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932073Ab3IMNJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 09:09:56 -0400
MIME-Version: 1.0
In-Reply-To: <5232DB49.4050701@arm.com>
References: <1378968687-8200-1-git-send-email-cinifr@gmail.com>
	<1378968687-8200-4-git-send-email-cinifr@gmail.com>
	<20130912112452.GA22013@e106331-lin.cambridge.arm.com>
	<CAK3cCBwu4somtfc9J1ZDVcC-iYD1qDJwSWzWeOomTqY9tQA2kg@mail.gmail.com>
	<5231EE43.5090900@arm.com>
	<CAK3cCBzr8_LTYarZDgPYZY7_-5Qco_Qw+ACi=c2uOrn7MqwkBg@mail.gmail.com>
	<5232DB49.4050701@arm.com>
Date: Fri, 13 Sep 2013 21:09:55 +0800
Message-ID: <CAK3cCBw4EKypLmhf4L5_P3d27QzsrB+ZxUTgF58YhmUhBa00xQ@mail.gmail.com>
Subject: Re: [PATCH 3/4] Add physical count arch timer support for clocksource
 in ARMv7.
From: cinifr <cinifr@gmail.com>
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Mark Rutland <Mark.Rutland@arm.com>, "coosty@163.com" <coosty@163.com>,
        "maxime.ripard@free-electrons.com" <maxime.ripard@free-electrons.com>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pawel.moll@arm.co" <pawel.moll@arm.co>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-sunxi@googlegroups.com" <linux-sunxi@googlegroups.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I urge you to read the ARM ARM, and specifically the section dedicated
> to trapping access to CP15 operations. If you do, you'll quickly notice
> that you *cannot* trap accesses to the timer subsystem.
>
I read it again. The ARMv7 manual said "Is accessible from Non-secure
PL1 modes only when CNTHCTL.PL1PCTEN is set to 1. When
CNTHCTL.PL1PCTEN is set to 0, any attempt to access CNTPCT from a
Non-secure PL1 mode ***generates a Hyp Trap exception***, see Hyp Trap
exception on page B1-1206" in B8.1.2. but I dont find  a  special hyp
trap control  for accessing CNTPCT in manual. As you said HSTR cannot
trap accessing of CP15 c14. What happer when OS access CNTPCT from PL1
NS=1 mode with CNTHCTL.PL1PCTEN=0 ???  AmI  wrong for understanding
the manual?
Thanks.
BTW: And I fond xen have support to trap accessing   CNTPCT by this
patch on http://lists.xen.org/archives/html/xen-devel/2012-08/msg00452.html.

> All you can do is disable access to the physical timer/counter,
> resulting in an UNDEF in the *guest*.
>
> Additionally, please realise the overhead of trapping is enormous, and
> that we do try very hard to minimise it. Why do you think we went out of
> our way to ensure that host and guest would use different timers, always?

>
> CNTVOFF can only be setup from either HYP or Secure Monitor mode with
> SCR.NS == 1, so if you run your kernel in secure mode, it is always best
> to do it in the bootloader.
I agree it, Bootloader do  it better.

         Fan

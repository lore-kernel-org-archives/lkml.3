Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838AbaJIL6B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 07:58:01 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:58963 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966AbaJIL5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 07:57:52 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ley Foon Tan <lftan@altera.com>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        lftan.linux@gmail.com, cltang@codesourcery.com
Subject: Re: [PATCH v4 21/29] nios2: Time keeping
Date: Thu, 09 Oct 2014 13:57:36 +0200
Message-ID: <8312001.XfVQ0Jf4Rn@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <alpine.DEB.2.11.1410081814380.4292@nanos>
References: <1412760595-3935-1-git-send-email-lftan@altera.com> <2785501.FjgXQVl8Ik@wuerfel> <alpine.DEB.2.11.1410081814380.4292@nanos>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:0H181Ssfh0uIP+umz7Q3woHkthG9rxCg2FvbbssaraB
 mrNowlTe6nYnJhKrFjQzKRhmrSJFirOL6LMIoXgWNbVLVfKQtb
 iGHee3iGcQ1OFirl18E9g2fGIXqqoc6h8bAFQrwWJkmblEd9S0
 wxP9kOMmzdm9DstCjh3PDbnRxk2yGGhDbA6//UhUHGB1y+CzjA
 YmK+vlWWzfoBjp2T7hORes1yXYXXAIOTg4wGH9uxzXwcKaq++9
 tSwtiPb1M4MB+zVm2jmC2o3kxE1CKp6pKeSubiHD2aRjZGawS6
 LHEM8sfLn8VkTVy8lb8GAANN9OSx7t/1I/Qmlmetd+qEiyXjsO
 saQwgRy8gHRZIxwZloVg=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 08 October 2014 18:19:52 Thomas Gleixner wrote:
> Ok, got it. It does not change the fact that the above function is
> butt ugly and completely non intuitive.

Agreed, it could at least use a comment to explain the logic behind it.

> I also do not agree, that the DT should not tell which of the timers
> should be used as a clockevent device and which one as a
> clocksource. If you have a better suited clockevent device in your
> FPGA, you cannot use a single instance of the timer thingy as it will
> be registered as a clockevent and not as a clocksource. So explicit
> match values for particular hardware instances would be more flexible,
> but I don't have strong feelings about it either.

Right, things can get arbitrarily complicated when this is combined
with other (optional) timer hardware, as we've seen on ARM before.
I think we have discussed the issue for some ARM timers in length
before and not found a good solution.

The clps711x driver has tried to work around this problem by using
aliases, and it has been discussed for other drivers before.

The main problem with encoding the use of the timer blocks in DT
is that it gets really ugly if we ever want to use a third timer
hardware block in the kernel, e.g. to separate the timer wheel
from the hrtimer, if we decide to expose a particular HW
timer to in-kernel or userland interfaces, or if someone wants
to run an OS on the same hardware that uses the timer hardware
in a completely different way.

	Arnd

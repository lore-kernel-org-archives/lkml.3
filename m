Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140AbbAEOWe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 09:22:34 -0500
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:60430 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbbAEOWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 09:22:33 -0500
Date: Mon, 5 Jan 2015 14:22:06 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>, Pavel Machek <pavel@ucw.cz>,
        Marc Zyngier <marc.zyngier@arm.com>,
        kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Revert 9fc2105aeaaf56b0cf75296a84702d0f9e64437b to fix
 pyaudio (and probably more)
Message-ID: <20150105142206.76ca2e18@lxorguk.ukuu.org.uk>
In-Reply-To: <20150104211555.GB12302@n2100.arm.linux.org.uk>
References: <20150104190123.GA20153@amd>
	<alpine.LFD.2.11.1501041438130.18844@knanqh.ubzr>
	<CA+55aFxMbicJZXzzHc8=vdwCzhz4kdrmZEKjLadZXr7aySZ4zg@mail.gmail.com>
	<alpine.LFD.2.11.1501041526390.18844@knanqh.ubzr>
	<CA+55aFxRRcSJ5i=EcQ-qqMrz0icn28JKjQuH3xGU65hjpVm9hw@mail.gmail.com>
	<20150104211555.GB12302@n2100.arm.linux.org.uk>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yes, x86 has the bogomips thing, and it switched to using a TSC.  I'm
> willing to bet that on x86, the reported bogomips value is pretty similar
> whether it's using the TSC or whether it's using a software timing loop.

Roughly yes. It's a completely dumb number anyway because any loop timing
based number is bogus on any modern x86. Utterly bogus. However its
armwavingly sufficient that software doesn't break (not that any x86
software I know of does anything but print the number for the user so
they can copy it to tweet about how neat their new PC is).

PC people do keep filing bugs about x86 CPU clock numbers being wrong, we
just close them all. Clock rate itself is a bit of a meaningless concept
nowdays.

> This is not the case on ARM.  Here's an example where we use a hardware
> timer for the delay loop:
> 
> Calibrating delay loop (skipped), value calculated using timer frequency.. 6.00 BogoMIPS (lpj=12000)
> 
> which is nowhere near the precision of the CPU clock rate.  So, when
> we have a hardware timer based delay implementation, the bogomips
> value which the kernel has access to (and thus the loops_per_jiffy
> value) is totally ... bogus.

So multiply it by a fudge factor so it looks similar and in proportion.

> If we want to take note of the "screenfulls of users reporting problems"
> then we need a much better solution than a simple revert, because right
> now, the simple revert makes machines with GHz clock frequencies look
> slower than the old 1990s 26-bit ARM technology.

That's a marketing problem not a technical one 8)

You actually have the reverse problem to consider. Who can quantify
how many modern ARM apps actually check for Bogomips and then set policy
according to its presence/absence. Reverting a 2013 change may actually
break a load of software that has been fixed or deals with the real world
properly. Pavel doing a random arbitrary long term revert without any
planning is at least as stupid as ignoring it.

What I don't understand here is why it was removed for platforms where it
was meaningful. Surely that's not needed and antiques running antique
userspace would continue to be happy with numbers valid for that era ?

Alan

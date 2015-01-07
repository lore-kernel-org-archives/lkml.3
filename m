Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755129AbbAGWmp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 17:42:45 -0500
Received: from mail-qa0-f50.google.com ([209.85.216.50]:51041 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600AbbAGWmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 17:42:44 -0500
Date: Wed, 7 Jan 2015 17:42:40 -0500 (EST)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Pavel Machek <pavel@ucw.cz>, Marc Zyngier <marc.zyngier@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        kernel list <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH] Revert 9fc2105aeaaf56b0cf75296a84702d0f9e64437b to fix
 pyaudio (and probably more)
In-Reply-To: <CA+55aFyrNE9qqBR9Khbj=TuAnjA+UzUhNxFz==SqKuiG5q3uMQ@mail.gmail.com>
Message-ID: <alpine.LFD.2.11.1501071700301.1322@knanqh.ubzr>
References: <20150104190123.GA20153@amd> <alpine.LFD.2.11.1501041438130.18844@knanqh.ubzr> <20150104201026.GA23427@amd> <alpine.LFD.2.11.1501041512440.18844@knanqh.ubzr> <20150104203724.GA16372@amd> <alpine.LFD.2.11.1501041547050.18844@knanqh.ubzr>
 <CA+55aFy5yB2d-1iXEUtU+puua4TAmV0kZF_7TBhXO1Y4Khqb9Q@mail.gmail.com> <alpine.LFD.2.11.1501041609290.18844@knanqh.ubzr> <20150104212659.GC12302@n2100.arm.linux.org.uk> <alpine.LFD.2.11.1501042343240.18844@knanqh.ubzr> <CAHkRjk6Vg_AR8rFNYzPcnPwfKZqaVuaCoG67CEVPRgp1-bDetA@mail.gmail.com>
 <CA+55aFypmZExpCvD699TQOs1NDK_mT-_rR3UWOdxdzkOKvbdoA@mail.gmail.com> <alpine.LFD.2.11.1501071354130.1322@knanqh.ubzr> <CA+55aFw70ZvHKH+8_aS7E7FZZuuWQA++zGQuSmuvDE3DWU+x3A@mail.gmail.com> <alpine.LFD.2.11.1501071446460.1322@knanqh.ubzr>
 <CA+55aFwuO2g1S-bY96V28crMWj+dKXWANzbP28JQjBdTg0rV0w@mail.gmail.com> <alpine.LFD.2.11.1501071618300.1322@knanqh.ubzr> <CA+55aFyrNE9qqBR9Khbj=TuAnjA+UzUhNxFz==SqKuiG5q3uMQ@mail.gmail.com>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Jan 2015, Linus Torvalds wrote:

> On Jan 7, 2015 1:29 PM, "Nicolas Pitre" <nicolas.pitre@linaro.org> wrote:
> > >
> > > Lying about it is *not* fine, for all the reasons I've already wasted
> too
> > > much time trying to explain.
> >
> > Lying to whom?  And for what purpose?
> 
> You guys are the ones suggesting various "scaling" things to make the delay
> loop look different from what it is. That's just dishonesty. It actively
> hides the resolution of the delay time source, and it is a bad bad idea.
> 
> Just educate people, don't lie to them. Tell them what bogomips means,
> instead of trying to make shit up.

What does it mean?  That's the actual question.  And I'm talking about 
the user visible value here.

Given the "kernel does not break user space" mantra, and given that user 
space has assumptions around the exported bogomips value that goes a 
long way back, I really question what the bogomips meaning is from a 
user space point of view.

According to the analysis Will Deacon performed on the user code that 
broke with the bogomips gone, whose breakage started this very thread, 
this user space instance appears to equate bogomips with CPU MHz.

You said yourself in this thread that one of the bogomips meanings is a 
value proportional to the number of loops the CPU can perform which is 
also in the same spirit as CPU MHz.

So far so good.

Since when does bogomips mean kernel low-level timer resolution? As 
Catalin pointed out, the bogomips value went from 800 down to 6 when 
timer based udelay was introduced on ARM for the same piece of hardware. 
Is that really what user space is expecting here?

That's where I don't understand anymore.

If the answer is: "user space should never care because bogomips is 
totally bogus" as some people are claiming then why all the fuss about 
"lying"?

I don't want stupid games here either, I want a sensible answer from a 
user space point of view because that's user space we don't want to lie 
to, right?


Nicolas

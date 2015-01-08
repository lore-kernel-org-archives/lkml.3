Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752389AbbAHApv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 19:45:51 -0500
Received: from mail-qc0-f170.google.com ([209.85.216.170]:32880 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075AbbAHApu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 19:45:50 -0500
Date: Wed, 7 Jan 2015 19:45:47 -0500 (EST)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Catalin Marinas <catalin.marinas@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Pavel Machek <pavel@ucw.cz>, Marc Zyngier <marc.zyngier@arm.com>,
        kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Revert 9fc2105aeaaf56b0cf75296a84702d0f9e64437b to fix
 pyaudio (and probably more)
In-Reply-To: <CA+55aFz0cjsS4BTwtBt9P1pKHmPjXPYnOvFuP07UVoek7jSYLw@mail.gmail.com>
Message-ID: <alpine.LFD.2.11.1501071914250.1322@knanqh.ubzr>
References: <alpine.LFD.2.11.1501041547050.18844@knanqh.ubzr> <CA+55aFy5yB2d-1iXEUtU+puua4TAmV0kZF_7TBhXO1Y4Khqb9Q@mail.gmail.com> <alpine.LFD.2.11.1501041609290.18844@knanqh.ubzr> <20150104212659.GC12302@n2100.arm.linux.org.uk> <alpine.LFD.2.11.1501042343240.18844@knanqh.ubzr>
 <CAHkRjk6Vg_AR8rFNYzPcnPwfKZqaVuaCoG67CEVPRgp1-bDetA@mail.gmail.com> <CA+55aFypmZExpCvD699TQOs1NDK_mT-_rR3UWOdxdzkOKvbdoA@mail.gmail.com> <alpine.LFD.2.11.1501071354130.1322@knanqh.ubzr> <CA+55aFw70ZvHKH+8_aS7E7FZZuuWQA++zGQuSmuvDE3DWU+x3A@mail.gmail.com>
 <alpine.LFD.2.11.1501071446460.1322@knanqh.ubzr> <20150107205346.GO12302@n2100.arm.linux.org.uk> <CAHkRjk6FT+WJ3u9qhfB-EMcqhOHGQSe4dW4MpZF6vE97B0vD0A@mail.gmail.com> <CA+55aFz0cjsS4BTwtBt9P1pKHmPjXPYnOvFuP07UVoek7jSYLw@mail.gmail.com>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Jan 2015, Linus Torvalds wrote:

> In this case, pretty much all of /proc/cpuinfo is mainly
> "informational". Maybe there are applications that show it, but more
> likely you have people who ssh in and just do
> 
>     cat /proc/cpuinfo
> 
> to see what kind of system they are running on. That's the main point
> of much of /proc, and things like /proc/cpuinfo in particular.

Would you mind if on ARM we used the bogomips line as an informative 
approximation for the CPU speed?  After all, this is the meaning it had 
for nearly 20 years.  And unlike on X86 we don't have the actual CPU 
clock in there.  And that's still the meaning it has on most ARM systems 
out there.

> Changing the bogomips value - even radically - or removing it entirely
> isn't a regression in itself.
> 
> And in this case, I do suspect that the *actual* value really almost
> doesn't matter. It looks more like some internal badly done hint for
> some buffer size or other. It is possible that wild fluctuations could
> be noticeable, but it's fairly unlikely.

In that case nobody would complain if on some systems we make it back to 
the traditional value.  It took over a year before problem report about 
its disappearance reached us.

On other systems it will remain the same because its meaning still 
hasn't changed.  But on the whole it'll have a coherent meaning.

> The other "good news" in this area is that I suspect that the random
> ARM platforms that actually changed 2.5 years ago are not very widely
> used any more.

I beg to differ.  My primary test platform is one of them and it has the 
latest incarnation of the ARM 32-bit CPU architecture.

Rather, the good news is that not that many user space things rely on 
the bogomips value.  Or maybe people don't upgrade their kernels that 
often e.g. the latest OpenWRT stable version from 3 months ago ships 
with a 3.10 kernel.  Oh and all the Ubuntu releases for ARM in the last 
year shipped with kernels that don't advertise the bogomips and passed 
QA.  So if we bring it back now, better make it usefully informative at 
least for humans.


Nicolas

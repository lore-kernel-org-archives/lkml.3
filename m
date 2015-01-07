Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755185AbbAGWOa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 17:14:30 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:52418 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753908AbbAGWO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 17:14:28 -0500
MIME-Version: 1.0
In-Reply-To: <20150107205346.GO12302@n2100.arm.linux.org.uk>
References: <alpine.LFD.2.11.1501041547050.18844@knanqh.ubzr>
 <CA+55aFy5yB2d-1iXEUtU+puua4TAmV0kZF_7TBhXO1Y4Khqb9Q@mail.gmail.com>
 <alpine.LFD.2.11.1501041609290.18844@knanqh.ubzr> <20150104212659.GC12302@n2100.arm.linux.org.uk>
 <alpine.LFD.2.11.1501042343240.18844@knanqh.ubzr> <CAHkRjk6Vg_AR8rFNYzPcnPwfKZqaVuaCoG67CEVPRgp1-bDetA@mail.gmail.com>
 <CA+55aFypmZExpCvD699TQOs1NDK_mT-_rR3UWOdxdzkOKvbdoA@mail.gmail.com>
 <alpine.LFD.2.11.1501071354130.1322@knanqh.ubzr> <CA+55aFw70ZvHKH+8_aS7E7FZZuuWQA++zGQuSmuvDE3DWU+x3A@mail.gmail.com>
 <alpine.LFD.2.11.1501071446460.1322@knanqh.ubzr> <20150107205346.GO12302@n2100.arm.linux.org.uk>
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Wed, 7 Jan 2015 22:14:07 +0000
X-Google-Sender-Auth: j9dZcJBVFHab3LDTYqM2a7mExeo
Message-ID: <CAHkRjk6FT+WJ3u9qhfB-EMcqhOHGQSe4dW4MpZF6vE97B0vD0A@mail.gmail.com>
Subject: Re: [PATCH] Revert 9fc2105aeaaf56b0cf75296a84702d0f9e64437b to fix
 pyaudio (and probably more)
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Pavel Machek <pavel@ucw.cz>, Marc Zyngier <marc.zyngier@arm.com>,
        kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7 January 2015 at 20:53, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> I think what Linus is trying to tell us is that:
>
> 1. Where the kernel uses a software loop for implementing delays,
>    the kernel bogomips gives us a calibration of that loop.

Fine.

> 2. Where the kernel uses a hardware timer for implementing delays,
>    the kernel bogomips gives us a calibration of that hardware timer.

Fine as well.

> And it doesn't matter whether or not that timer has anything to do with
> the raw CPU speed.

Indeed.

> In other words, bogomips is a statement about the accuracy of the
> internal kernel mechanism being used for delays, nothing more, nothing
> less.

And for whatever reason, some user space program thinks it can read
something meaningful out of this number and use it in user space. But
the consensus is that even if user space is badly implemented, we do
*not* break it. I agree.

> Now, if I understand Linus correctly, what irks him is when someone
> upgrades a kernel on a platform, and some userland breaks.  That's
> something which I've said multiple times I don't have a problem
> agreeing with, and I suspect no one in this thread would disagree
> that this is a serious failing, and one which needs fixing ASAP.

Agree. But I assume you refer to the fact that we removed the BogoMIPS
reporting. It's fine to have it reverted.

> However, if running userland on platform A works, and but it doesn't
> work on platform B.  The breakage may well be due to platform A reporting
> 300 bogomips because it's using the kernel software loop, and platform
> B reporting 6 bogomips because its using a hardware timer, but the CPU
> is actually faster.  However, this is not a kernel problem, and it
> certainly is not a regression.  It's a userspace bug which needs
> userspace to fix.

We need to look back at the point we added timer-based delay about 2.5
years ago. Prior to commit d0a533b18235d362, platform A reported
bogomips 300. After that commit, the *same* platform A (not B),
started reported 6.

Is the above considered user breakage? That's what Nico is trying to
solve. If we are fine with it, than we can close this thread, no
further changes needed.

We can document it as Linus suggests and say that prior to whatever
version we had 2.5 years ago, BogoMIPS was based on a busy loop. In
more recent kernels, it is based on a timer delay. User space should
make use of such information when interpreting BogoMIPS.

-- 
Catalin

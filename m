Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755595AbbAHA5f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 19:57:35 -0500
Received: from mail-qc0-f169.google.com ([209.85.216.169]:63429 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202AbbAHA5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 19:57:34 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.11.1501071914250.1322@knanqh.ubzr>
References: <alpine.LFD.2.11.1501041547050.18844@knanqh.ubzr>
	<CA+55aFy5yB2d-1iXEUtU+puua4TAmV0kZF_7TBhXO1Y4Khqb9Q@mail.gmail.com>
	<alpine.LFD.2.11.1501041609290.18844@knanqh.ubzr>
	<20150104212659.GC12302@n2100.arm.linux.org.uk>
	<alpine.LFD.2.11.1501042343240.18844@knanqh.ubzr>
	<CAHkRjk6Vg_AR8rFNYzPcnPwfKZqaVuaCoG67CEVPRgp1-bDetA@mail.gmail.com>
	<CA+55aFypmZExpCvD699TQOs1NDK_mT-_rR3UWOdxdzkOKvbdoA@mail.gmail.com>
	<alpine.LFD.2.11.1501071354130.1322@knanqh.ubzr>
	<CA+55aFw70ZvHKH+8_aS7E7FZZuuWQA++zGQuSmuvDE3DWU+x3A@mail.gmail.com>
	<alpine.LFD.2.11.1501071446460.1322@knanqh.ubzr>
	<20150107205346.GO12302@n2100.arm.linux.org.uk>
	<CAHkRjk6FT+WJ3u9qhfB-EMcqhOHGQSe4dW4MpZF6vE97B0vD0A@mail.gmail.com>
	<CA+55aFz0cjsS4BTwtBt9P1pKHmPjXPYnOvFuP07UVoek7jSYLw@mail.gmail.com>
	<alpine.LFD.2.11.1501071914250.1322@knanqh.ubzr>
Date: Wed, 7 Jan 2015 16:57:33 -0800
X-Google-Sender-Auth: kllHm-qlji7KaLmvfUHniAFete0
Message-ID: <CA+55aFyKz2tZDq6ANjKVmuvipKtjr+UP4c7ypNXtbXBcapOpKg@mail.gmail.com>
Subject: Re: [PATCH] Revert 9fc2105aeaaf56b0cf75296a84702d0f9e64437b to fix
 pyaudio (and probably more)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Pavel Machek <pavel@ucw.cz>, Marc Zyngier <marc.zyngier@arm.com>,
        kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 7, 2015 at 4:45 PM, Nicolas Pitre <nicolas.pitre@linaro.org> wrote:
>
> Would you mind if on ARM we used the bogomips line as an informative
> approximation for the CPU speed?  After all, this is the meaning it had
> for nearly 20 years.  And unlike on X86 we don't have the actual CPU
> clock in there.  And that's still the meaning it has on most ARM systems
> out there.

Yes, I actually would mind, unless you have a damn good reason for it.

On x86, we have bogomips, but we also have this line:

   cpu MHz : 2275.109

and I really don't see why you should lie in your /proc/cpuinfo.

Really.

Just give the real information. Don't lie.

Quite frankly, the *only* actual real reason I've heard from you for
not having the real bogomips there is "waste of time".

And this whole thread has been *nothing* but waste of time. But it has
been *you* wasting time, and that original commit. If you had just
left it alone, and had just let the revert do its job, none of this
waste of time would have happened.

So quite frankly, my patience for you arguing "wasting time" is pretty
damn low. I think your arguments are crap, I still think your NAK was
*way* out of line, and I think it's completely *insane* to lie about
bogomips. It's disasteful, it's dishonest, and there's no reason for
it.

If you want to give people a sense of the CPU frequency, then dammit,
just *do* that. Add that "cpu MHz" line that we already have on x86.

Seriously, what kind of *insane* argument can you really marshal for
lying to users?

And if you want users to know the CPU frequency, then why the f*ck
would you call it "bogomips" and confuse them?

Christ, this whole thing is annoying. I really find it *offensive* how
you want to basically lie to users.

Stop this idiocy. Really. There is no excuse.

                        Linus

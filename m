Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932295AbbAHAty (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 19:49:54 -0500
Received: from mail-qc0-f173.google.com ([209.85.216.173]:42367 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932249AbbAHAtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 19:49:50 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFxZ4YESQ0vr3qO_o_H8AvQPOv500qnbBXdq+4YNsnOPgA@mail.gmail.com>
References: <20150104190123.GA20153@amd>
	<alpine.LFD.2.11.1501041438130.18844@knanqh.ubzr>
	<20150104201026.GA23427@amd>
	<alpine.LFD.2.11.1501041512440.18844@knanqh.ubzr>
	<20150104203724.GA16372@amd>
	<alpine.LFD.2.11.1501041547050.18844@knanqh.ubzr>
	<CA+55aFy5yB2d-1iXEUtU+puua4TAmV0kZF_7TBhXO1Y4Khqb9Q@mail.gmail.com>
	<alpine.LFD.2.11.1501041609290.18844@knanqh.ubzr>
	<20150104212659.GC12302@n2100.arm.linux.org.uk>
	<alpine.LFD.2.11.1501042343240.18844@knanqh.ubzr>
	<CAHkRjk6Vg_AR8rFNYzPcnPwfKZqaVuaCoG67CEVPRgp1-bDetA@mail.gmail.com>
	<CA+55aFypmZExpCvD699TQOs1NDK_mT-_rR3UWOdxdzkOKvbdoA@mail.gmail.com>
	<alpine.LFD.2.11.1501071354130.1322@knanqh.ubzr>
	<CA+55aFw70ZvHKH+8_aS7E7FZZuuWQA++zGQuSmuvDE3DWU+x3A@mail.gmail.com>
	<alpine.LFD.2.11.1501071446460.1322@knanqh.ubzr>
	<CA+55aFwuO2g1S-bY96V28crMWj+dKXWANzbP28JQjBdTg0rV0w@mail.gmail.com>
	<alpine.LFD.2.11.1501071618300.1322@knanqh.ubzr>
	<CA+55aFyrNE9qqBR9Khbj=TuAnjA+UzUhNxFz==SqKuiG5q3uMQ@mail.gmail.com>
	<alpine.LFD.2.11.1501071700301.1322@knanqh.ubzr>
	<CA+55aFxZ4YESQ0vr3qO_o_H8AvQPOv500qnbBXdq+4YNsnOPgA@mail.gmail.com>
Date: Wed, 7 Jan 2015 16:49:48 -0800
X-Google-Sender-Auth: jkCjBRCyTt2mIWdUaqm5ewsPbv4
Message-ID: <CA+55aFwh-JKHRoa+wSM5iGJ2nPzDxCE6b8kHbE4Ei8we+ot5Gw@mail.gmail.com>
Subject: Re: [PATCH] Revert 9fc2105aeaaf56b0cf75296a84702d0f9e64437b to fix
 pyaudio (and probably more)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Pavel Machek <pavel@ucw.cz>, Marc Zyngier <marc.zyngier@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        kernel list <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 7, 2015 at 4:25 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Timing-related things can be similar. The whole "it used to work, now
> it doesn't" could be an actual race condition - in user space - that
> just was practically impossible to hit before on a particular machine,
> and then something changed, and now it's easy to hit. There's nothing
> we can really do about those kinds of things. It technically *is*
> still a regression, it's just not one we can fix.

Side note: this is not a theoretical argument. It has happened. And
while it's "unfixable", we've actually had situations where it
happened, and we explicitly tried to work around it.

The whole "sched_child_runs_first" sysctl isn't just a tunable (yes,
it can also help on some loads), it's at least partly a result of a
long-ago bash bug where bash had a race condition with its own
fork()'ed children finishing and sending a SIGCHLD before bash had
even had time to fill in the child pid information in its own data
structures.

So even the "fundamentally impossible to fix" regressions where some
scheduler detail changed, and it broke actively buggy user space
programs, we've spent effort to maintain compatibility with those
buggy applications.

Of course, at some point you do have to make a value judgment on how
important the app in question is, and how fatal the breakage is.

                             Linus

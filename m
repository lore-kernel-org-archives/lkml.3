Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610AbbAGTgf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 14:36:35 -0500
Received: from mail-qg0-f41.google.com ([209.85.192.41]:59573 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754450AbbAGTge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 14:36:34 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.11.1501071354130.1322@knanqh.ubzr>
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
Date: Wed, 7 Jan 2015 11:36:33 -0800
X-Google-Sender-Auth: dqu2hvE7e1O3RJEelurK6RwuRf4
Message-ID: <CA+55aFw70ZvHKH+8_aS7E7FZZuuWQA++zGQuSmuvDE3DWU+x3A@mail.gmail.com>
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

On Wed, Jan 7, 2015 at 11:00 AM, Nicolas Pitre <nicolas.pitre@linaro.org> wrote:
>
> We'll make sure it is scaled properly so not to have orders of magnitude
> discrepancy whether the timer based or the CPU based loop is used for
> the purpose of making people feel good.

Why?

You'd basically be lying.  And it might actually hide real problems.
If the scaling hides the fact that the timer source cannot do a good
job at microsecond resolution delays, then it's not just lying, it's
lying in ways that hide real issues. So why should that kind of
behavior be encouraged? The actual *real* unscaled resolution of the
timer is valid and real information.

Random scaling like that would be *bad*, in other words.

This whole thread has wasted more time than the whole original
argument for wasted time ever was. I still have no idea what the
original argument was, and why you guys want some made-up and
incorrect feel-good number rather than just document the fact that the
bogomips is simple dependent on the clocksource you use for delays.

That kind of documentation wouldn't be lying, wouldn't be misleading,
and wouldn't waste peoples time.

                           Linus

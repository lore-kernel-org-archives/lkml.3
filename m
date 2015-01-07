Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317AbbAGBUM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 20:20:12 -0500
Received: from mail-qa0-f52.google.com ([209.85.216.52]:40978 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719AbbAGBUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 20:20:07 -0500
MIME-Version: 1.0
In-Reply-To: <CAHkRjk4SLvjRtAv6+kP6uUgA7KWk=_PacqxbT1_7LB-QX4=AGQ@mail.gmail.com>
References: <20150104190123.GA20153@amd>
	<alpine.LFD.2.11.1501041438130.18844@knanqh.ubzr>
	<CA+55aFxMbicJZXzzHc8=vdwCzhz4kdrmZEKjLadZXr7aySZ4zg@mail.gmail.com>
	<alpine.LFD.2.11.1501041526390.18844@knanqh.ubzr>
	<CA+55aFxRRcSJ5i=EcQ-qqMrz0icn28JKjQuH3xGU65hjpVm9hw@mail.gmail.com>
	<20150104211555.GB12302@n2100.arm.linux.org.uk>
	<20150105142206.76ca2e18@lxorguk.ukuu.org.uk>
	<CAHkRjk5EAUvdR5ED_M=dB+5yu3RtZLgo_aighUrozovHKnOp=w@mail.gmail.com>
	<CA+55aFwfnT2M1OXzYiy74WCdoRHpKgMby20eqCBe-pEoS6ds-w@mail.gmail.com>
	<CAHkRjk4SLvjRtAv6+kP6uUgA7KWk=_PacqxbT1_7LB-QX4=AGQ@mail.gmail.com>
Date: Tue, 6 Jan 2015 17:20:06 -0800
X-Google-Sender-Auth: Z4fooZbHjrRpAuNkVtwrbKtusGU
Message-ID: <CA+55aFw8x01fBKczTSNkAZ06rwULVp0A=pASJACs8S1SB_Orew@mail.gmail.com>
Subject: Re: [PATCH] Revert 9fc2105aeaaf56b0cf75296a84702d0f9e64437b to fix
 pyaudio (and probably more)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Nicolas Pitre <nicolas.pitre@linaro.org>, Pavel Machek <pavel@ucw.cz>,
        Marc Zyngier <marc.zyngier@arm.com>,
        kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 6, 2015 at 3:42 PM, Catalin Marinas <catalin.marinas@arm.com> wrote:
>>
>> That's what bogomips *is*, for chrissake! It's a bogus measure of how
>> many times you go through the delay loop.
>
> I think that's where the misunderstanding is. We don't have any idea
> how many times we go through the delay loop. We just go through the
> delay loop until the counter (driven by an independent frequency)
> changes X times.

.. and that's exactly what we do on x86 too with the TSC. It's fine.

> With the current arm timer-based (and arm64) implementation, the
> reported BogoMIPS has nothing to do with the CPU benchmark. It just
> tells you that a X MHz counter needs X*1000000/HZ ticks per jiffy.

Yes. And that's a valid bogomips. We've done that for ages on x86.

Really, the "problem" that people wonder why some bogomips value is
lower or higher isn't a problem. Just explain it to them. Or ignore
them when they ask.

Bogomips is a delay value for the micro-second delay loop. Nothing
less, nothing more.

                     Linus

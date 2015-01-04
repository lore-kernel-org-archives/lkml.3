Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752970AbbADU5P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 15:57:15 -0500
Received: from mail-qc0-f170.google.com ([209.85.216.170]:62218 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752847AbbADU5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 15:57:10 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.11.1501041526390.18844@knanqh.ubzr>
References: <20150104190123.GA20153@amd>
	<alpine.LFD.2.11.1501041438130.18844@knanqh.ubzr>
	<CA+55aFxMbicJZXzzHc8=vdwCzhz4kdrmZEKjLadZXr7aySZ4zg@mail.gmail.com>
	<alpine.LFD.2.11.1501041526390.18844@knanqh.ubzr>
Date: Sun, 4 Jan 2015 12:57:09 -0800
X-Google-Sender-Auth: f78-aV_I50sPuSriNheJZhothlE
Message-ID: <CA+55aFxRRcSJ5i=EcQ-qqMrz0icn28JKjQuH3xGU65hjpVm9hw@mail.gmail.com>
Subject: Re: [PATCH] Revert 9fc2105aeaaf56b0cf75296a84702d0f9e64437b to fix
 pyaudio (and probably more)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Pavel Machek <pavel@ucw.cz>, Marc Zyngier <marc.zyngier@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 4, 2015 at 12:45 PM, Nicolas Pitre <nicolas.pitre@linaro.org> wrote:
>
> Because we're discussing a choice between two evils.

.. and Pavel pointed you to several screenfuls of google hits for
people complaining about this.

End of discussion. Seriously. Your whinging about "support costs" is
just crying over the fact that you have users. Deal with it.

I've reverted the change for now, since that's clearly better than
leaving things broken. And you should acknowledge that. In fact, you
should *more* than acknowledge that, you need to internalize it and
*understand* it, instead of arguing.

The fact is, we have bogomips on x86 too, and they've been around for
a hell of a lot longer than ARM has been. The number may not be
"meaningful" any more (since it's TSC cycles rather than anything
else), but it's there in /proc anyway.  We had it through the times
when it fluctuated, and your made-up arguments about how it's a bad
thing are just bogus. It wasn't a big deal, and having a reasonable
value is not a problem.

And no, we don't set it to some "obviously bogus value". That just
makes breakage even more subtle.

You could make it be something that is roughly on the order of the CPU
frequency. It doesn't have to be exact, but from a QoI standpoint, try
to do a reasonable job.

And dammit, I really never *ever* want to hear arguments against
fixing regressions ever again. It really is the #1 rule for the
kernel. There is *no* excuse for that NAK. There is only "sorry".

                            Linus

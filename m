Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933263Ab3DKSWb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 14:22:31 -0400
Received: from mail-vb0-f42.google.com ([209.85.212.42]:38518 "EHLO
	mail-vb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402Ab3DKSW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 14:22:29 -0400
MIME-Version: 1.0
In-Reply-To: <1365703670.10217.10.camel@laptop>
References: <tip-d9a3c9823a2e6a543eb7807fb3d15d8233817ec5@git.kernel.org>
	<20130326140147.GB2029@redhat.com>
	<1365687946.8824.3.camel@laptop>
	<CA+55aFway4C89fTewKvED4RvFLaNdM-BVtkJ2YChsvracLKiyA@mail.gmail.com>
	<1365703670.10217.10.camel@laptop>
Date: Thu, 11 Apr 2013 11:22:27 -0700
X-Google-Sender-Auth: Sb9zPisckR1yM5rsCyq-iHkeqis
Message-ID: <CA+55aFy5Gx1OS7jaWELrpfxtwyChs=jQmoM0=HcFCjXPjgP99A@mail.gmail.com>
Subject: Re: [tip:sched/core] sched: Lower chances of cputime scaling overflow
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 11, 2013 at 11:07 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>
> Oh, I (wrongly it appears) assumed that fls was something cheap :/

It often is. Particularly on modern machines, because all popcount and
leading zero counting ends up being interesting to some people.

On older machines, its often a bit-at-a-time thing. We don't even try
to support i386 any more, but on atom and P4 it's something like 16
cycles for bsrl, and older cores were worse. So doing three of them
when not needed seems a bit excessive..

In contrast, on a Core2, I think it's just a single cycle.

Non-x86 architectures end up being the same - some have fast
instructions for it, others don't do it at all and end up doing things
with bitmasking and shifting.

                     Linus

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753597AbaAALmx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jan 2014 06:42:53 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:57181 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753312AbaAALmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jan 2014 06:42:50 -0500
Date: Wed, 1 Jan 2014 12:42:44 +0100
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kees Cook <keescook@chromium.org>, David Rientjes <rientjes@google.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Ralf Baechle <ralf@linux-mips.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        James Hogan <james.hogan@imgtec.com>, Michal Marek <mmarek@suse.cz>,
        Paul Mundt <lethal@linux-sh.org>, Shawn Guo <shawn.guo@linaro.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Sam Ravnborg <sam@ravnborg.org>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: Re: [patch core/stackprotector] stackprotector: Fix build when
 compiler lacks support
Message-ID: <20140101114244.GB3372@free.fr>
References: <1387481759-14535-3-git-send-email-keescook@chromium.org>
 <tip-8779657d29c0ebcc0c94ede4df2f497baf1b563f@git.kernel.org>
 <alpine.DEB.2.02.1312301331520.10482@chino.kir.corp.google.com>
 <CAGXu5jJxkD7rS0gFAS3mAhwxP05UMW8KNW00C_e2v=Keqj7k3Q@mail.gmail.com>
 <CA+55aFy65HwuqjsZhhTDBy1GYyxig8De=3XZxn8ixnGN7xWMFQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+55aFy65HwuqjsZhhTDBy1GYyxig8De=3XZxn8ixnGN7xWMFQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, All,

On 2013-12-31 16:16 -0800, Linus Torvalds spake thusly:
> On Mon, Dec 30, 2013 at 4:45 PM, Kees Cook <keescook@chromium.org> wrote:
> >
> > NAK. If you have selected CONFIG_CC_STACKPROTECTOR_STRONG, the build
> > the fail hard. Without this, it means you'll end up with kernels that
> > build and show a stackprotector option in their config, which is
> > false.
> 
> What we really really want to do is to have some way to add config
> options based on shell scripts and compiler support. That would also
> get rid of a lot of Makefile trickery etc.
> 
> Then we could just make CC_STACKPROTECTOR_STRONG depend on
> CC_SUPPORTS_STACKPROTECTOR_STRONG or whatever.

Sam Ravnborg suggested somethink along those lines back in July:
    http://marc.info/?l=linux-kbuild&m=137399785206527&w=2
and a tentative implementation:
    http://marc.info/?l=linux-kbuild&m=137409581406434&w=2

Basically, that would give something like:

    config CC_SUPPORTS_STACKPROTECTOR_STRONG
        bool
        option exec="some/script/to/test-gcc -fstack-protector-strong"

    config CC_STACKPROTECTOR_STRONG
        bool "enable stack-protector strong"
        depends on CC_SUPPORTS_STACKPROTECTOR_STRONG

Would that be something that match what you suggested above?

Sam, there were some comments on that patch of yours. Do you want to
update it and resubmit it?

And, Happy New Year to All!

Regards,
Yann E. MORIN.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'

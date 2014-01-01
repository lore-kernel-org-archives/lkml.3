Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754634AbaAATdm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jan 2014 14:33:42 -0500
Received: from mail-ea0-f180.google.com ([209.85.215.180]:53031 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752993AbaAATdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jan 2014 14:33:40 -0500
MIME-Version: 1.0
In-Reply-To: <20140101114244.GB3372@free.fr>
References: <1387481759-14535-3-git-send-email-keescook@chromium.org>
	<tip-8779657d29c0ebcc0c94ede4df2f497baf1b563f@git.kernel.org>
	<alpine.DEB.2.02.1312301331520.10482@chino.kir.corp.google.com>
	<CAGXu5jJxkD7rS0gFAS3mAhwxP05UMW8KNW00C_e2v=Keqj7k3Q@mail.gmail.com>
	<CA+55aFy65HwuqjsZhhTDBy1GYyxig8De=3XZxn8ixnGN7xWMFQ@mail.gmail.com>
	<20140101114244.GB3372@free.fr>
Date: Wed, 1 Jan 2014 11:33:38 -0800
X-Google-Sender-Auth: KGBsK15o7NtsiLF5RwvXiahoqF0
Message-ID: <CA+55aFzS2bTXSDabNhsZXhpVWP9toqtubB3jrNVWF-FaQrmz-w@mail.gmail.com>
Subject: Re: [patch core/stackprotector] stackprotector: Fix build when
 compiler lacks support
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Yann E. MORIN" <yann.morin.1998@free.fr>
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 1, 2014 at 3:42 AM, Yann E. MORIN <yann.morin.1998@free.fr> wrote:
>
> On 2013-12-31 16:16 -0800, Linus Torvalds spake thusly:
>>
>> What we really really want to do is to have some way to add config
>> options based on shell scripts and compiler support. That would also
>> get rid of a lot of Makefile trickery etc.
>>
>> Then we could just make CC_STACKPROTECTOR_STRONG depend on
>> CC_SUPPORTS_STACKPROTECTOR_STRONG or whatever.
>
> Sam Ravnborg suggested somethink along those lines back in July:
>     http://marc.info/?l=linux-kbuild&m=137399785206527&w=2
> and a tentative implementation:
>     http://marc.info/?l=linux-kbuild&m=137409581406434&w=2

Ack. Looks good to me. I've wanted this for a long time for other
reasons, we should finally just do it.

That said, we should make sure that the shell execution thing gets
access to $(CC) etc variables that we have in

> Basically, that would give something like:
>
>     config CC_SUPPORTS_STACKPROTECTOR_STRONG
>         bool
>         option exec="some/script/to/test-gcc -fstack-protector-strong"

For the compiler options, it would hopefully be sufficient to just do
something like

  config CC_SUPPORTS_STACKPROTECTOR_STRONG
      bool
      option exec="$CC -fstack-protector-strong -c empty.c"

or something like that. No?

              Linus

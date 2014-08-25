Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061AbaHYQ1k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 12:27:40 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:47848 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240AbaHYQ1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 12:27:39 -0400
MIME-Version: 1.0
In-Reply-To: <20140825144111.GB31880@redhat.com>
References: <20140824194700.GA27281@redhat.com>
	<20140824194736.GA27441@redhat.com>
	<CA+55aFyQzvvmWUDA01x69vYkrwUG07q9P3Mv5KaT31pOFsBZGQ@mail.gmail.com>
	<20140825144111.GB31880@redhat.com>
Date: Mon, 25 Aug 2014 09:27:37 -0700
X-Google-Sender-Auth: Lv7h00liZ2VOMTQ8AEmRJxsXyS4
Message-ID: <CA+55aFwNUF+CLWKkDBe56xOtK_JTj9zHWip+_Ep41GJniN+sPw@mail.gmail.com>
Subject: Re: [PATCH 2/5] x86, fpu: don't drop_fpu() in __restore_xstate_sig()
 if use_eager_fpu()
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Fenghua Yu <fenghua.yu@intel.com>, Suresh Siddha <sbsiddha@gmail.com>,
        Bean Anderson <bean@azulsystems.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 25, 2014 at 7:41 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>
> I think this should be safe, because this thread and/or swapper/0 can
> do nothing with with fpu->state, and they should not use fpu.

.. but if that's the case, then what was wrong with the old code that
just copied the state over the unused space from the user space
buffer?

You can't have it both ways. Either the old code was fine (because it
doesn't use the buffer while it is in flux), or the new code is broken
(because it uses the shared buffer). Your choice.No?

                       Linus

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934527AbaLKVtT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 16:49:19 -0500
Received: from mail-qg0-f50.google.com ([209.85.192.50]:63454 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933134AbaLKVtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 16:49:18 -0500
MIME-Version: 1.0
In-Reply-To: <20141211145408.GB16800@redhat.com>
References: <20141201230339.GA20487@ret.masoncoding.com>
	<1417529606.3924.26.camel@maggy.simpson.net>
	<CA+55aFw8smHBw9HiCiYL_ohkULLeunWo6qfayM19zhF1hKAxXg@mail.gmail.com>
	<1417540493.21136.3@mail.thefacebook.com>
	<20141203184111.GA32005@redhat.com>
	<CA+55aFzLprvtdLGDXgRr=k3QqO824uQSzbxT-b4vu_4pryMtSA@mail.gmail.com>
	<20141205171501.GA1320@redhat.com>
	<CA+55aFxVeti8pU=Y_w54oGb8syGduOySAp-ag+KsCom-c12e-Q@mail.gmail.com>
	<1417806247.4845.1@mail.thefacebook.com>
	<CA+55aFz3iUyV9=_rVUdO0WPoOyOKOYkcHCxb3p=2fgSHtCTNgw@mail.gmail.com>
	<20141211145408.GB16800@redhat.com>
Date: Thu, 11 Dec 2014 13:49:17 -0800
X-Google-Sender-Auth: Nn6F0nW8hQAEfHSqqtzmMHTUs2A
Message-ID: <CA+55aFy1_w1NrkeopMXsxGftO5F03JzKgn-8uTQRnEAXuoiXgg@mail.gmail.com>
Subject: Re: frequent lockups in 3.18rc4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Chris Mason <clm@fb.com>, Mike Galbraith <umgwanakikbuti@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        =?UTF-8?Q?D=C3=A2niel_Fraga?= <fragabr@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11, 2014 at 6:54 AM, Dave Jones <davej@redhat.com> wrote:
>
> So either one of those 'good's actually wasn't, or I'm just cursed.

Even if there was a good that wasn't, that last "bad"  (6f929b4e5a02)
is already sufficient just on its own to say that likely v3.16 already
had the problem.

Just do

   gitk v3.16..6f929b4e5a02

and cry.

(or "git diff --stat -M v3.16...6f929b4e5a02" to see what that commit
brought in from the common ancestor).

So I'd call that bisect a failure, and your "v3.16 is fine" is
actually suspect after all. Which *might* mean that it's some hardware
issue after all. Or there are multiple different problems, and while
v3.16 was fine, the problem was introduced earlier (in the common
ancestor of that staging tree), then fixed for 3.16, and then
re-introduced later again.

Anyway, you might as well stop bisecting. Regardless of where it lands
in the remaining pile, it's not going to give us any useful
information, methinks.

I'm stumped.

Maybe it's worth it to concentrate on just testing current kernels,
and instead try to limit the triggering some other way. In particular,
you had a trinity run that was *only* testing lsetxattr(). Is that
really *all* that was going on? Obviously trinity will be using
timers, fork, and other things? Can you recreate that lsetxattr thing,
and just try to get as many problem reports as possible from one
particular kernel (say, 3.18, since that should be a reasonable modern
base with hopefully not a lot of other random issues)?

Together with perhaps config checks. You've done some those already.
Did it reproduce without preemption, for example?

Does anybody have any smart ideas?

                            Linus

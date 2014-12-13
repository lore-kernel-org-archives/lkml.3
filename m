Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668AbaLMXi7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2014 18:38:59 -0500
Received: from mail-qg0-f47.google.com ([209.85.192.47]:57466 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907AbaLMXi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2014 18:38:58 -0500
MIME-Version: 1.0
In-Reply-To: <20141213233508.GN22149@ZenIV.linux.org.uk>
References: <CA+55aFz3iUyV9=_rVUdO0WPoOyOKOYkcHCxb3p=2fgSHtCTNgw@mail.gmail.com>
	<20141211145408.GB16800@redhat.com>
	<CA+55aFy1_w1NrkeopMXsxGftO5F03JzKgn-8uTQRnEAXuoiXgg@mail.gmail.com>
	<20141212185454.GB4716@redhat.com>
	<CA+55aFw7vJkuJ9RtVS3yhPsqDos+ii1kdJBZEeoxhb9c2=rStQ@mail.gmail.com>
	<20141213165915.GA12756@redhat.com>
	<20141213223616.GA22559@redhat.com>
	<CA+55aFwCa1+cBGxt-v487K-QBvxGyB9bL4u34zgMep9uFW+Mgw@mail.gmail.com>
	<CA+55aFydeGFQs+HZkqC1ecyh=MxOow-hw817e1q4DUrAX7uqWw@mail.gmail.com>
	<CA+55aFzuRCJDWQcBBET6x1OHThLrtJmnn=hS40tE7hNXfmfm6g@mail.gmail.com>
	<20141213233508.GN22149@ZenIV.linux.org.uk>
Date: Sat, 13 Dec 2014 15:38:57 -0800
X-Google-Sender-Auth: ImamYpiAetMuikkMJFyoRU-WzMI
Message-ID: <CA+55aFw5pb7g+k1EOGj6t2xqibGGUBmZMuA_YAgtyejiv76omg@mail.gmail.com>
Subject: Re: frequent lockups in 3.18rc4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Dave Jones <davej@redhat.com>, Chris Mason <clm@fb.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        =?UTF-8?Q?D=C3=A2niel_Fraga?= <fragabr@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 13, 2014 at 3:35 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Er...  There's much more direct reason - suppose we get a timer interrupt
> right in the middle of mnt_drop_write().  And lost the timeslice.

So?

You didn't have preemption disabled in *between* the mnt_want_write()
and mnt_drop_write(), there's absolutely no reason to have it inside
of them.

Nobody cares if you get preempted and go away for a while. It's
exactly equivalent to sleeping while doing the write that the pair was
protecting.

Seriously, the preemption disable looks like just voodoo code. It
doesn't protect anything, it doesn't fix anything, it doesn't change
anything. All it does is disable preemption over a random sequence of
code.

                      Linus

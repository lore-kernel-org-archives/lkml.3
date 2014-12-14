Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752239AbaLNBfU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2014 20:35:20 -0500
Received: from mail-qg0-f48.google.com ([209.85.192.48]:54882 "EHLO
	mail-qg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381AbaLNBfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2014 20:35:19 -0500
MIME-Version: 1.0
In-Reply-To: <20141214003332.GQ22149@ZenIV.linux.org.uk>
References: <CA+55aFw7vJkuJ9RtVS3yhPsqDos+ii1kdJBZEeoxhb9c2=rStQ@mail.gmail.com>
	<20141213165915.GA12756@redhat.com>
	<20141213223616.GA22559@redhat.com>
	<CA+55aFwCa1+cBGxt-v487K-QBvxGyB9bL4u34zgMep9uFW+Mgw@mail.gmail.com>
	<CA+55aFydeGFQs+HZkqC1ecyh=MxOow-hw817e1q4DUrAX7uqWw@mail.gmail.com>
	<CA+55aFzuRCJDWQcBBET6x1OHThLrtJmnn=hS40tE7hNXfmfm6g@mail.gmail.com>
	<20141213233508.GN22149@ZenIV.linux.org.uk>
	<CA+55aFw5pb7g+k1EOGj6t2xqibGGUBmZMuA_YAgtyejiv76omg@mail.gmail.com>
	<20141213234730.GP22149@ZenIV.linux.org.uk>
	<CA+55aFxZWPP+wCDbwB-n=z5z_8isqdJ_4Ka6+P+KaBAY4ihw1Q@mail.gmail.com>
	<20141214003332.GQ22149@ZenIV.linux.org.uk>
Date: Sat, 13 Dec 2014 17:35:17 -0800
X-Google-Sender-Auth: ddRv0H_HfgRyRUlXeUSKHu1wW3c
Message-ID: <CA+55aFxdsYMuUzdEhGThdtDJA+f1jeKn-rEH+Zrxk5=-KnsSRw@mail.gmail.com>
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

On Sat, Dec 13, 2014 at 4:33 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> So does SMP - this_cpu_dec() relies on preemption being disabled.

No. really. It very much does not. Not on x86, not elsewhere. It's
part of the whole point of "this_cpu_p()". They are preemption and
interrupt safe.

It's the "__this_cpu_op()" ones that need external protection.

                     Linus

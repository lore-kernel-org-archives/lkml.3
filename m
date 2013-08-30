Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756858Ab3H3R3B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 13:29:01 -0400
Received: from mail-vb0-f43.google.com ([209.85.212.43]:47645 "EHLO
	mail-vb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755173Ab3H3R27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 13:28:59 -0400
MIME-Version: 1.0
In-Reply-To: <20130830171707.GV31370@twins.programming.kicks-ass.net>
References: <1375758759-29629-1-git-send-email-Waiman.Long@hp.com>
	<1375758759-29629-2-git-send-email-Waiman.Long@hp.com>
	<CA+55aFyMeK+bAvkqi_HpShqm7Des6uriVP_xp+BJqD0ASCVL0g@mail.gmail.com>
	<1377751465.4028.20.camel@pasglop>
	<20130829070012.GC27322@gmail.com>
	<CA+55aFwzY_1tD5vmaDgwAGLXNSGw4XS8vEp9vOpN6NPm5+Mxow@mail.gmail.com>
	<20130830171707.GV31370@twins.programming.kicks-ass.net>
Date: Fri, 30 Aug 2013 10:28:58 -0700
X-Google-Sender-Auth: _3jmBDatYaEDP1mtCot4z969MHU
Message-ID: <CA+55aFzYrCbJ78XVKk7Apkxa+F-gpE911zTpMnSoGsn4S+CdpA@mail.gmail.com>
Subject: Re: [PATCH v7 1/4] spinlock: A new lockref structure for lockless
 update of refcount
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Waiman Long <Waiman.Long@hp.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jeff Layton <jlayton@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 30, 2013 at 10:17 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>
> Yeah, silent basically limits you to i7 single socket systems and sadly
> Intel doesn't seem to want to make those with more than 4 cores on :/

Yup. And even if they had more cores in a single socket, the real
scalability issues won't happen until you start crossing sockets and
serialization slows down by a big amount due to cachelines moving
outside the die.

> I've got a i7-K part (SNB iirc) with a _huge_ scythe cooler and a high
> efficiency fanless PSU for a system that's near noiseless -- as in my
> Thinkpad actually makes more noise.

I've got a 4770S on order, it should arrive tomorrow. It's the 65W
part, and it has TSX. But no, I doubt I'll see any real scalability
issues with it, but at least I can test any TSX codepaths.

                  Linus

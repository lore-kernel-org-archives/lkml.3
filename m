Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756741Ab3H3P2g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 11:28:36 -0400
Received: from mail-ve0-f180.google.com ([209.85.128.180]:44095 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756121Ab3H3P2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 11:28:34 -0400
MIME-Version: 1.0
In-Reply-To: <20130830071612.GB14099@gmail.com>
References: <1375758759-29629-1-git-send-email-Waiman.Long@hp.com>
	<1375758759-29629-2-git-send-email-Waiman.Long@hp.com>
	<CA+55aFyMeK+bAvkqi_HpShqm7Des6uriVP_xp+BJqD0ASCVL0g@mail.gmail.com>
	<1377751465.4028.20.camel@pasglop>
	<20130829070012.GC27322@gmail.com>
	<CA+55aFwzY_1tD5vmaDgwAGLXNSGw4XS8vEp9vOpN6NPm5+Mxow@mail.gmail.com>
	<CA+55aFx1oq7+jce8vLWRitASVMugCojYe3gmhXwhLx4K9Au3XQ@mail.gmail.com>
	<CA+55aFyq7dJnm6tfn12hLOw5qKLW2RXRFERHgZO-sOOnUmjd3g@mail.gmail.com>
	<1377822408.4028.44.camel@pasglop>
	<CA+55aFz4rJAAWopcSEJct55jUgCHY_6ZD=GSkKFmWanvd0otuw@mail.gmail.com>
	<20130830071612.GB14099@gmail.com>
Date: Fri, 30 Aug 2013 08:28:33 -0700
X-Google-Sender-Auth: E682gSiyNEfpC_5e_LMgeK_GbG8
Message-ID: <CA+55aFzZyYee87-WiUxoQBXHnbjKWArBpix+bu8Yvi85=-DqeQ@mail.gmail.com>
Subject: Re: [PATCH v7 1/4] spinlock: A new lockref structure for lockless
 update of refcount
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Waiman Long <Waiman.Long@hp.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jeff Layton <jlayton@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>,
        Michael Neuling <michael.neuling@au1.ibm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 30, 2013 at 12:16 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
>> > BTW. Do you have your test case at hand ?
>>
>> My test-case is a joke. It's explicitly *trying* to get as much
>> contention as possible on a dentry, by just starting up a lot of threads
>> that look up one single pathname (the same one for everybody). It
>> defaults to using /tmp for this, but you can specify the filename.
>
> Waiman's tests seemed to use sufficiently generic and varied workloads
> (AIM7) and they showed pretty nice unconditional improvements with his
> variant of this scheme, so I think testing with your simple testcase that
> intentionally magnifies the scalability issue is 100% legit and may in
> fact help tune the changes more accurately, because it has less inherent
> noise.

Yes. However, what I am (not very) worried about is that people will
hit some particular codepath that ends up having bad behavior.

I think I covered all the normal hotpaths in pathname lookup, which is
why I'm not *that* worried, but it's still the case that my silly
test-case is very limited. It's limited for a good *reason* (to try to
show the worst-case scalability problem), but it's limited.

              Linus

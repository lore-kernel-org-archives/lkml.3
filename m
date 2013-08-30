Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755413Ab3H3Cfo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 22:35:44 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:63897 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962Ab3H3Cfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 22:35:42 -0400
MIME-Version: 1.0
In-Reply-To: <1377829857.4028.46.camel@pasglop>
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
	<29797.1377828380@ale.ozlabs.ibm.com>
	<1377829857.4028.46.camel@pasglop>
Date: Thu, 29 Aug 2013 19:35:41 -0700
X-Google-Sender-Auth: mqwHYWzJu5bUbwLpqIfTavQrcAk
Message-ID: <CA+55aFw8o3h+ydR7PQK2a0BpN62o-7MQ38TXZkhvv6hVpcwbxA@mail.gmail.com>
Subject: Re: [PATCH v7 1/4] spinlock: A new lockref structure for lockless
 update of refcount
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Michael Neuling <mikey@neuling.org>, Ingo Molnar <mingo@kernel.org>,
        Waiman Long <Waiman.Long@hp.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jeff Layton <jlayton@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 29, 2013 at 7:30 PM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
>
> Or we can keep both completely separate like Linus does on x86.

I did it that way mainly to minimize the patch.

I agree with you that it probably makes sense to layer them the other
way around from what Michael's patch did, iow implement
arch_spin_is_locked() in terms of arch_spin_value_unlocked().

That said, on power, you have that "ACCESS_ONCE()" implicit in the
*type*, not in the code, so an "arch_spinlock_t" is fundamentally
volatile in itself. It's one of the reasons I despise "volatile":
things like volatility are _not_ attributes of a variable or a type,
but of the code in question. Something can be volatile in one context,
but not in another (one context might be locked, for example).

              Linus

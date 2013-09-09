Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751416Ab3IIAit (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 20:38:49 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:36967 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885Ab3IIAir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 20:38:47 -0400
MIME-Version: 1.0
In-Reply-To: <20130909003517.GJ13318@ZenIV.linux.org.uk>
References: <1375758759-29629-2-git-send-email-Waiman.Long@hp.com>
	<CA+55aFyMeK+bAvkqi_HpShqm7Des6uriVP_xp+BJqD0ASCVL0g@mail.gmail.com>
	<1377751465.4028.20.camel@pasglop>
	<20130829070012.GC27322@gmail.com>
	<CA+55aFwzY_1tD5vmaDgwAGLXNSGw4XS8vEp9vOpN6NPm5+Mxow@mail.gmail.com>
	<CA+55aFx1oq7+jce8vLWRitASVMugCojYe3gmhXwhLx4K9Au3XQ@mail.gmail.com>
	<CA+55aFyq7dJnm6tfn12hLOw5qKLW2RXRFERHgZO-sOOnUmjd3g@mail.gmail.com>
	<CA+55aFxEjDYhY3i6B2okMWZXFiiq7hibTdeOD+OHAhNA7=XV1A@mail.gmail.com>
	<20130909000300.GH13318@ZenIV.linux.org.uk>
	<CA+55aFy6=CvNet+fjcYiFxbb_E1gDPzudaJ+hVotYuG5zuMb5Q@mail.gmail.com>
	<20130909003517.GJ13318@ZenIV.linux.org.uk>
Date: Sun, 8 Sep 2013 17:38:46 -0700
X-Google-Sender-Auth: dmw-hJz_rdfCDg0Cf-_p4e1-rnE
Message-ID: <CA+55aFwEs6epLkbp2L9+7jR9+AWB=fsB+dJMUeufxvPDF9hBgw@mail.gmail.com>
Subject: Re: [PATCH v7 1/4] spinlock: A new lockref structure for lockless
 update of refcount
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Ingo Molnar <mingo@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Waiman Long <Waiman.Long@hp.com>, Jeff Layton <jlayton@redhat.com>,
        Miklos Szeredi <mszeredi@suse.cz>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
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

On Sun, Sep 8, 2013 at 5:35 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> That should also work, replacing the current tip of #for-next.  Do you
> prefer to merge those two diffs of yours into a single commit?

If you're ok with my patch (it's now also tested, I'm running with it
and it looks fine), I'll commit that one as-is.

When you say "those two diffs of yours", which two are you talking
about? I already committed the "dead lockref" part separately - it may
be "preparatory", but it was preparatory cleanup that didn't change
semantics, so it's better to be separate anyway. The last patch I sent
out a few moments ago is the one that actually fixes things so that
"dput()" isn't done under the RCU lock etc.

           Linus

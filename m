Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932713Ab3IDVeJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 17:34:09 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:49755 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756570Ab3IDVeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 17:34:07 -0400
MIME-Version: 1.0
In-Reply-To: <5227892B.7030906@hp.com>
References: <5220F090.5050908@hp.com>
	<20130830194059.GC13318@ZenIV.linux.org.uk>
	<5220F811.9060902@hp.com>
	<20130830202608.GD13318@ZenIV.linux.org.uk>
	<52210225.60805@hp.com>
	<20130830204852.GE13318@ZenIV.linux.org.uk>
	<52214EBC.90100@hp.com>
	<20130831023516.GI13318@ZenIV.linux.org.uk>
	<20130831024233.GJ13318@ZenIV.linux.org.uk>
	<5224E647.80303@hp.com>
	<20130903060130.GD16261@gmail.com>
	<5225FCEE.7030901@hp.com>
	<CA+55aFyNmLt9GeR5XyxOs7aGLwH3EBCB+K9D6uGBef3FziP2-A@mail.gmail.com>
	<CA+55aFw0jme+qK5b_VJVqoVD6cZuSjVsm-Sgjf_YkPXgMToqUA@mail.gmail.com>
	<52274943.1040005@hp.com>
	<CA+55aFyY-KEvqYze56Vw4wiznEBaxjRqHFT6aVxbu_U3k66BdQ@mail.gmail.com>
	<5227892B.7030906@hp.com>
Date: Wed, 4 Sep 2013 14:34:05 -0700
X-Google-Sender-Auth: VIdpz7nlJhYG3gBUakXbwuc3pps
Message-ID: <CA+55aFy9hywXPhAu8JVSW=a4=2ctFTvQttf+x06mo3f6_4-g3w@mail.gmail.com>
Subject: Re: [PATCH v7 1/4] spinlock: A new lockref structure for lockless
 update of refcount
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Waiman Long <waiman.long@hp.com>
Cc: Ingo Molnar <mingo@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
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

On Wed, Sep 4, 2013 at 12:25 PM, Waiman Long <waiman.long@hp.com> wrote:
>
> Yes, the perf profile was taking from an 80-core machine. There isn't any
> scalability issue hiding for the short workload on an 80-core machine.
>
> However, I am certain that more may pop up when running in an even larger
> machine like the prototype 240-core machine that our team has been testing
> on.

Sure. Please let us know, I think it's going to be interesting to see
what that shows.

SGI certainly did much larger machines, but their primary target
tended to be all user space, so they had things like "tons of
concurrent page faults in the same process" rather than filename
lookup or the tty layer.

                Linus

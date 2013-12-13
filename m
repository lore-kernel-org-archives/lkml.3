Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751871Ab3LMFrB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 00:47:01 -0500
Received: from imap.thunk.org ([74.207.234.97]:39628 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750834Ab3LMFq7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 00:46:59 -0500
Date: Fri, 13 Dec 2013 00:46:40 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: James Morris <jmorris@namei.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dave Jones <davej@redhat.com>, Kees Cook <keescook@chromium.org>,
        vegard.nossum@oracle.com, LKML <linux-kernel@vger.kernel.org>,
        Tommi Rantala <tt.rantala@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Alan Cox <alan@linux.intel.com>, Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        James Morris <james.l.morris@oracle.com>
Subject: Re: [PATCH 1/9] Known exploit detection
Message-ID: <20131213054640.GI23888@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	James Morris <jmorris@namei.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Dave Jones <davej@redhat.com>, Kees Cook <keescook@chromium.org>,
	vegard.nossum@oracle.com, LKML <linux-kernel@vger.kernel.org>,
	Tommi Rantala <tt.rantala@gmail.com>,
	Ingo Molnar <mingo@kernel.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Andy Lutomirski <luto@amacapital.net>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Alan Cox <alan@linux.intel.com>, Jason Wang <jasowang@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	James Morris <james.l.morris@oracle.com>
References: <1386867152-24072-1-git-send-email-vegard.nossum@oracle.com>
 <20131212190659.GG13547@thunk.org>
 <CAGXu5jKmrtgH8tAGuYd9-gh5-EXqAsPy+XoRMc9DNLDngNH2ug@mail.gmail.com>
 <20131213002523.GA20706@redhat.com>
 <20131213014220.GB11068@kroah.com>
 <alpine.LRH.2.02.1312131557340.32454@tundra.namei.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1312131557340.32454@tundra.namei.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 13, 2013 at 04:09:06PM +1100, James Morris wrote:
> 
> I think we'd need to have someone commit to maintaining this long term 
> before seriously considering it as part of mainline.  Over time it will 
> become increasingly useless if new triggers aren't added.
> 
> What happens when code is refactored, who refactors the triggers?

We would definitely need to have test cases which deliberately trips
the triggers, which would be run regularly (which means they would
need to be included in the kernel tree), or else it's very likely as
the code gets refactor or even just modiied, the exploit() calls might
end up getting moved to the wrong place, or otherwise
deactivated/denatured.

> I suspect this kind of thing is better done in userspace anti-malware 
> scanning.

I was wondering if we could do something using syscall tracing, or via
some systemtap kind of thing.  The problem is that this would be
painful for certain system calls, especially those that are
multiplexed, such as futex, or decode complex data structures based
via a pointer, or are context-dependent, such as ioctl's.

If it could be kept to a single exploit() line added to a return path,
the impact on code complexity and maintainability should be minimal.

I'm still a little dubious about the size of benefit that trying to
maintain these exploit() markets would provide, and whether it would
ultimately be worth the cost.

						- Ted

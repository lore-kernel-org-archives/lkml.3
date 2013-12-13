Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752350Ab3LMNTd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 08:19:33 -0500
Received: from mail-ea0-f171.google.com ([209.85.215.171]:45379 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789Ab3LMNTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 08:19:31 -0500
Date: Fri, 13 Dec 2013 14:19:26 +0100
From: Ingo Molnar <mingo@kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>, James Morris <jmorris@namei.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dave Jones <davej@redhat.com>, Kees Cook <keescook@chromium.org>,
        vegard.nossum@oracle.com, LKML <linux-kernel@vger.kernel.org>,
        Tommi Rantala <tt.rantala@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Alan Cox <alan@linux.intel.com>, Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        James Morris <james.l.morris@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/9] Known exploit detection
Message-ID: <20131213131926.GA10981@gmail.com>
References: <1386867152-24072-1-git-send-email-vegard.nossum@oracle.com>
 <20131212190659.GG13547@thunk.org>
 <CAGXu5jKmrtgH8tAGuYd9-gh5-EXqAsPy+XoRMc9DNLDngNH2ug@mail.gmail.com>
 <20131213002523.GA20706@redhat.com>
 <20131213014220.GB11068@kroah.com>
 <alpine.LRH.2.02.1312131557340.32454@tundra.namei.org>
 <20131213054640.GI23888@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131213054640.GI23888@thunk.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Theodore Ts'o <tytso@mit.edu> wrote:

> On Fri, Dec 13, 2013 at 04:09:06PM +1100, James Morris wrote:
> > 
> > I think we'd need to have someone commit to maintaining this long 
> > term before seriously considering it as part of mainline.  Over 
> > time it will become increasingly useless if new triggers aren't 
> > added.
> > 
> > What happens when code is refactored, who refactors the triggers?
> 
> We would definitely need to have test cases which deliberately trips 
> the triggers, which would be run regularly (which means they would 
> need to be included in the kernel tree), or else it's very likely as 
> the code gets refactor or even just modiied, the exploit() calls 
> might end up getting moved to the wrong place, or otherwise 
> deactivated/denatured.

That looks useful for another reason as well: we had cases where the 
same exploit re-appeared because our fix against it regressed.

> [...]
> 
> I'm still a little dubious about the size of benefit that trying to 
> maintain these exploit() markers would provide, and whether it would 
> ultimately be worth the cost.

These items are very easy to remove if any of them breaks or gets out 
of sync. So the cost can be reduced to zero, if the experiment fails.

I'd definitely be willing to accept the x86 and perf bits, if all 
complaints are fixed and if Vegard (and Kees?) volunteers to maintain 
this thing.

I see no real downside - other than giving the security circus a 
foothold in the kernel.

OTOH, such defensive measures _do_ have tangible benefits:

 - They warn kernel developers about dangerous patterns and past
   incidents, in the code itself. There are 'hotspot' areas in the
   kernel that tend to attract more bugs than others.

 - They give actual real figures to people/organizations: do these
   checks ever trigger? Have they triggered in the past 5 years? A
   large enough organization might be able to quantify and guesstimate
   its attack surface that way.

 - We could actually insert such checks against known zero day
   exploits out in the wild. Those exploits will eventually be changed
   to be more careful, but there is going to be a delay with such
   updates: catching some attack attempts. Software update delays
   will finally work in favor of the good guys!

so maybe these effects reduce the security circus aspect. Or not :-)

Thanks,

	Ingo

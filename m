Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757569Ab3J1WKk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 18:10:40 -0400
Received: from psi.thgersdorf.net ([176.9.98.78]:55433 "EHLO mail.psioc.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753993Ab3J1WKi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 18:10:38 -0400
From: Thomas Rast <tr@thomasrast.ch>
To: Johan Herland <johan@herland.net>
Cc: Christian Couder <christian.couder@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Michael Haggerty <mhagger@alum.mit.edu>,
        Git mailing list <git@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>, Greg KH <greg@kroah.com>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        ksummit-attendees@lists.linuxfoundation.org,
        Linux Kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] commit: Add -f, --fixes <commit> option to add Fixes: line
References: <20131024122255.GI9378@mwanda> <20131024122512.GB9534@mwanda>
	<20131026181709.GB10488@kroah.com> <20131027013402.GA7146@leaf>
	<526CA7D4.1070904@alum.mit.edu> <20131027071407.GA11683@leaf>
	<874n83m8xv.fsf@linux-k42r.v.cablecom.net>
	<20131027092019.GB13149@leaf>
	<CALKQrgc7a+p5eebJErcGdA3QDyvdHEaef36RhZocQp9LjDUeeg@mail.gmail.com>
	<CAP8UFD3MZJKWUbdZqrSwoatpnx73MTpiwSkxPHYDagGjMSqJNw@mail.gmail.com>
	<CALKQrgcgfimZRJL7WyS-brqEZnHJkJjK_0cqe6-7HWkuCW6Dzw@mail.gmail.com>
Date: Mon, 28 Oct 2013 23:10:13 +0100
In-Reply-To: <CALKQrgcgfimZRJL7WyS-brqEZnHJkJjK_0cqe6-7HWkuCW6Dzw@mail.gmail.com>
	(Johan Herland's message of "Mon, 28 Oct 2013 03:46:15 +0100")
Message-ID: <87txg1hwsa.fsf@linux-k42r.v.cablecom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johan Herland <johan@herland.net> writes:

> But I still don't see exactly what this option should do (inside "git
> commit") that would end up being useful across most/all projects, and
> not just something that could more easily be implemented in the
> *commit-msg hooks for relevant projects.

[Ok, admittedly I don't really know what to quote from your message,
since I'm mostly responding to the overall concept.]

I like the idea of putting all that in hooks, but I have two
observations:

* Signed-off-by: is already such a case (and was probably also added for
  the kernel?) that _could_ have been dealt with using {prepare-,}commit-msg, 
  but has its own support in various git tools.

* In your list

>   Fixes:
>   Reported-by:
>   Suggested-by:
>   Improved-by:
>   Acked-by:
>   Reviewed-by:
>   Tested-by:
>   Signed-off-by:

  and I might add

    Cherry-picked-from:
    Reverts:

  if one were to phrase that as a footer/pseudoheader, observe that
  there are only two kinds of these: footers that contain identities,
  and footers that contain references to commits.

So why not support these use-cases?  We could have something like
footer.foo.* configuration, e.g.

[footer "fixes"]
        type = commit
        suggest = true
[footer "acked-by"]
        type = identity

where 'suggest' (please suggest a better name) means that git-commit
will put a blank one in the commit message template for you to fill in.
'commit' and 'identity' can have some elementary expansion and
validation tied to them.  Some easy extensiblity (hooks?) might not
hurt, but then as you point out, the existing hooks already cover that.

Perhaps we could also have, for Gerrit (cf. [1]):

[footer "change-id"]
        type = uuid

though admittedly I haven't investigated if it's okay to just put a
random string there, or it needs to have a specific value.


[1]  http://thread.gmane.org/gmane.comp.version-control.git/236429

-- 
Thomas Rast
tr@thomasrast.ch

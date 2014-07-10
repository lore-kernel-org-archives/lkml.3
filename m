Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752675AbaGJSyk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 14:54:40 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:44634 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443AbaGJSyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 14:54:37 -0400
Date: Thu, 10 Jul 2014 11:52:57 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Sasha Levin <sasha.levin@oracle.com>
cc: Hugh Dickins <hughd@google.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vlastimil Babka <vbabka@suse.cz>, akpm@linux-foundation.org,
        davej@redhat.com, koct9i@gmail.com, lczerner@redhat.com,
        stable@vger.kernel.org, "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: + shmem-fix-faulting-into-a-hole-while-its-punched-take-2.patch
 added to -mm tree
In-Reply-To: <53BED7F6.4090502@oracle.com>
Message-ID: <alpine.LSU.2.11.1407101131310.19154@eggly.anvils>
References: <53b45c9b.2rlA0uGYBLzlXEeS%akpm@linux-foundation.org> <53BCBF1F.1000506@oracle.com> <alpine.LSU.2.11.1407082309040.7374@eggly.anvils> <53BD1053.5020401@suse.cz> <53BD39FC.7040205@oracle.com> <53BD67DC.9040700@oracle.com>
 <alpine.LSU.2.11.1407092358090.18131@eggly.anvils> <53BE8B1B.3000808@oracle.com> <53BECBA4.3010508@oracle.com> <alpine.LSU.2.11.1407101033280.18934@eggly.anvils> <53BED7F6.4090502@oracle.com>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jul 2014, Sasha Levin wrote:
> On 07/10/2014 01:55 PM, Hugh Dickins wrote:
> >> And finally, (not) holding the i_mmap_mutex:
> > I don't understand what prompts you to show this particular task.
> > I imagine the dump shows lots of other tasks which are waiting to get an
> > i_mmap_mutex, and quite a lot of other tasks which are neither waiting
> > for nor holding an i_mmap_mutex.
> > 
> > Why are you showing this one in particular?  Because it looks like the
> > one you fingered yesterday?  But I didn't see a good reason to finger
> > that one either.
> 
> There are a few more tasks like this one, my criteria was tasks that lockdep
> claims were holding i_mmap_mutex, but are actually not.

You and Vlastimil enlightened me yesterday that lockdep shows tasks as
holding i_mmap_mutex when they are actually waiting to get i_mmap_mutex.
Hundreds of those in yesterday's log, hundreds of them in today's.

The full log you've sent (thanks) is for a different run from the one
you showed in today's mail.  No problem with that, except when I assert
that trinity-c190 in today's mail is just like trinity-c402 in yesterday's,
a task caught at one stage of exit_mmap in the stack dumps, then a later
stage of exit_mmap in the locks held dumps, I'm guessing rather than
confirming from the log.

There's nothing(?) interesting about those tasks, they're just tasks we
have been lucky to catch a moment before they reach the i_mmap_mutex
hang affecting the majority.

> 
> One new thing that I did notice is that since trinity spins a lot of new children
> to test out things like execve() which would kill said children, there tends to
> be a rather large amount of new tasks created and killed constantly.
> 
> So if you look at the bottom of the new log (attached), you'll see that there
> are quite a few "trinity-subchild" processes trying to die, unsuccessfully.

Lots of those in yesterday's log too: waiting to get i_mmap_mutex.

I'll pore over the new log.  It does help to know that its base kernel
is more stable: thanks so much.  But whether I can work out any more...

Hugh

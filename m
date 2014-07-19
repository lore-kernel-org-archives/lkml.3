Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753833AbaGSXp4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 19:45:56 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:60351 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064AbaGSXpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 19:45:53 -0400
Date: Sat, 19 Jul 2014 16:44:15 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Sasha Levin <sasha.levin@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>
cc: Vlastimil Babka <vbabka@suse.cz>, Hugh Dickins <hughd@google.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michel Lespinasse <walken@google.com>,
        Lukas Czerner <lczerner@redhat.com>, Dave Jones <davej@redhat.com>,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] shmem: fix faulting into a hole while it's punched,
 take 3
In-Reply-To: <53C8FAA6.9050908@oracle.com>
Message-ID: <alpine.LSU.2.11.1407191628450.24073@eggly.anvils>
References: <alpine.LSU.2.11.1407150247540.2584@eggly.anvils> <53C7F55B.8030307@suse.cz> <53C7F5FF.7010006@oracle.com> <53C8FAA6.9050908@oracle.com>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jul 2014, Sasha Levin wrote:
> On 07/17/2014 12:12 PM, Sasha Levin wrote:
> > On 07/17/2014 12:10 PM, Vlastimil Babka wrote:
> >> > On 07/15/2014 12:28 PM, Hugh Dickins wrote:
> >>> >> In the end I decided that we had better look at it as two problems,
> >>> >> the trinity faulting starvation, and the indefinite punching loop,
> >>> >> so 1/2 and 2/2 present both solutions: belt and braces.
> >> > 
> >> > I tested that with my reproducer and it was OK, but as I already said, it's not trinity so I didn't observe the new problems in the first place.
> > I've started seeing a new hang in the lru code, but I'm not sure if
> > it's related to this patch or not (the locks are the same ones, but
> > the location is very different).
> > 
> > I'm looking into that.
> 
> Hi Hugh,
> 
> The new hang I'm seeing is much simpler to analyse (compared to shmem_fallocate) and
> doesn't seem to be related. I'll send a separate mail and Cc you just in case, but
> I don't think that this patchset has anything to do with it.

Thanks for testing and following up, Sasha.  I agree, that one is
unrelated.  I've just sent a suggestion in your lru_add_drain_all thread.

> 
> Otherwise, I've been unable to reproduce the shmem_fallocate hang.

Great.  Andrew, I think we can say that it's now safe to send
1/2 shmem: fix faulting into a hole, not taking i_mutex
2/2 shmem: fix splicing from a hole while it's punched
on to Linus whenever suits you.

(You have some other patches in the mainline-later section of the
mmotm/series file: they're okay too, but not in doubt as these two were.)

Thanks,
Hugh

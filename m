Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754382Ab3I0Xkr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 19:40:47 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:1855 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754192Ab3I0Xke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 19:40:34 -0400
Message-ID: <1380325232.12518.3.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH 2/4] ipc,shm: prevent race with rmid in shmat(2)
From: Davidlohr Bueso <davidlohr@hp.com>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Mike Galbraith <efault@gmx.de>,
        sedat.dilek@gmail.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Fri, 27 Sep 2013 16:40:32 -0700
In-Reply-To: <52451B5D.4080908@colorfullife.com>
References: <1379300677-24188-1-git-send-email-davidlohr@hp.com>
	 <1379300677-24188-3-git-send-email-davidlohr@hp.com>
	 <52451B5D.4080908@colorfullife.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Manfred,

On Fri, 2013-09-27 at 07:45 +0200, Manfred Spraul wrote:
> Hi Davidlohr,
> 
> On 09/16/2013 05:04 AM, Davidlohr Bueso wrote:
> > This fixes a race in shmat() between finding the msq and
> > actually attaching the segment, as another thread can delete shmid
> > underneath us if we are preempted before acquiring the kern_ipc_perm.lock.
> According the the man page, Linux supports attaching to deleted shm 
> segments:
> 
> http://linux.die.net/man/2/shmat
> >
> > On Linux, it is possible to attach a shared memory segment even if it 
> > is already marked to be deleted. However, POSIX.1-2001 does not 
> > specify this behavior and many other implementations do not support it.
> >

Good catch!

> Does your patch change that?

Yes, it should and furthermore it affects the following property:

 shm_nattch is decremented by one.  If it becomes 0 and the segment is
marked for deletion, the segment is deleted.



> Unfortunately, I have neither any experience with ipc/shm nor any test 
> cases.
> 
> And:
> As far as I can see it's not a problem if we are attaching to a deleted 
> segment: shm_close cleans up everything.

Agreed, please disregard this patch.

Thanks,
Davidlohr


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755535AbaDLPkH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2014 11:40:07 -0400
Received: from g5t1626.atlanta.hp.com ([15.192.137.9]:18980 "EHLO
	g5t1626.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754631AbaDLPkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2014 11:40:05 -0400
Message-ID: <1397317199.2686.12.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH] ipc/shm: disable SHMALL, SHMMAX
From: Davidlohr Bueso <davidlohr@hp.com>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, gthelen@google.com,
        aswin@hp.com, linux-mm@kvack.org
Date: Sat, 12 Apr 2014 08:39:59 -0700
In-Reply-To: <1397303284-2216-1-git-send-email-manfred@colorfullife.com>
References: <1397303284-2216-1-git-send-email-manfred@colorfullife.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-04-12 at 13:48 +0200, Manfred Spraul wrote:
> Shared memory segment can be abused to trigger out-of-memory conditions and
> the standard measures against out-of-memory do not work:
> 
> - It is not possible to use setrlimit to limit the size of shm segments.
> 
> - Segments can exist without association with any processes, thus
>   the oom-killer is unable to free that memory.
> 
> Therefore Linux always limited the size of segments by default to 32 MB.
> As most systems do not need a protection against malicious user space apps,
> a default that forces most admins and distros to change it doesn't make
> sense.
> 
> The patch disables both limits by setting the limits to ULONG_MAX.
> 
> Admins who need a protection against out-of-memory conditions should
> reduce the limits again and/or enable shm_rmid_forced.
> 
> Davidlohr: What do you think?
> 
> I prefer this approach: No need to update the man pages, smaller change
> of the code, smaller risk of user space incompatibilities.

As I've mentioned before, both approaches are correct.

I still much prefer using 0 instead of ULONG_MAX, it's far easier to
understand. And considering the v2 which fixes the shmget(key, 0, flg)
usage, I _still_ don't see why it would cause legitimate user
incompatibilities.

Regarding the manpage, regardless the approach we end up taking, it
should still be updated. This is an important change for users, making
their life easier. We should inform them explicitly about them not
really needing to deal with the hassle of shm limits anymore.

Thanks,
Davidlohr


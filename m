Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260AbaDVSSS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 14:18:18 -0400
Received: from g2t2352.austin.hp.com ([15.217.128.51]:55240 "EHLO
	g2t2352.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222AbaDVSSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 14:18:16 -0400
Message-ID: <1398190693.2473.7.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH 0/4] ipc/shm.c: increase the limits for SHMMAX, SHMALL
From: Davidlohr Bueso <davidlohr@hp.com>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, gthelen@google.com,
        aswin@hp.com, linux-mm@kvack.org
Date: Tue, 22 Apr 2014 11:18:13 -0700
In-Reply-To: <5355EEC2.4010304@colorfullife.com>
References: <1398090397-2397-1-git-send-email-manfred@colorfullife.com>
	 <1398101106.2623.6.camel@buesod1.americas.hpqcorp.net>
	 <5355EEC2.4010304@colorfullife.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-04-22 at 06:23 +0200, Manfred Spraul wrote:
> On 04/21/2014 07:25 PM, Davidlohr Bueso wrote:
> > On Mon, 2014-04-21 at 16:26 +0200, Manfred Spraul wrote:
> >> Hi all,
> >>
> >> the increase of SHMMAX/SHMALL is now a 4 patch series.
> >> I don't have ideas how to improve it further.
> > Manfred, is there any difference between this set and the one you sent a
> > couple of days ago?
> a) I updated the comments.
> b) the initial set used TASK_SIZE, not I switch to ULONG_MAX-(1L<<24)
> 
> >>    - Using "0" as a magic value for infinity is even worse, because
> >>      right now 0 means 0, i.e. fail all allocations.
> > Sorry but I don't quite get this. Using 0 eliminates the need for all
> > these patches, no? I mean overflows have existed since forever, and
> > taking this route would naturally solve the problem. 0 allocations are a
> > no no anyways.
> No. The patches are required to handle e.g. shmget(,ULONG_MAX,):
> Right now, shmget(,ULONG_MAX,) results in a 0-byte segment.

Ok, I was mixing 'issues' then.

> The risk of using 0 is that it reverses the current behavior:
> Up to now,
>      # sysctl kernel.shmall=0
> disables allocations.
> If we define 0 a infinity, then the same configuration would allow 
> unlimited allocations.

Right, but as I mentioned, this also contradicts the fact that shmmin
cannot be 0. And again, I don't know who's correct here. Do any
standards mention this? I haven't found anything, and hard-codding
shmmin to 1 seems to be different among OSs, Linux choosing to do so.
This difference must also be commented in the manpage.

That said, I believe that violating this "feature" and forbidding
disabling shm would probably have a more severe penalty (security,
perhaps) for users who rely on this. So while I'm really annoyed that we
"cannot" use 0 because of this, I'm going to give up arguing. I believe
you approach is the safer way of going.

Thanks a lot for looking into this, Manfred.
Davidlohr


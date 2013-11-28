Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758706Ab3K1CwR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 21:52:17 -0500
Received: from mail-yh0-f41.google.com ([209.85.213.41]:46992 "EHLO
	mail-yh0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758254Ab3K1CwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 21:52:13 -0500
Date: Wed, 27 Nov 2013 18:52:10 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Johannes Weiner <hannes@cmpxchg.org>
cc: Michal Hocko <mhocko@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        cgroups@vger.kernel.org
Subject: Re: [patch 1/2] mm, memcg: avoid oom notification when current needs
 access to memory reserves
In-Reply-To: <20131128022804.GJ3556@cmpxchg.org>
Message-ID: <alpine.DEB.2.02.1311271839290.5120@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1311141447160.21413@chino.kir.corp.google.com> <alpine.DEB.2.02.1311141525440.30112@chino.kir.corp.google.com> <20131118154115.GA3556@cmpxchg.org> <20131118165110.GE32623@dhcp22.suse.cz> <20131122165100.GN3556@cmpxchg.org>
 <alpine.DEB.2.02.1311261648570.21003@chino.kir.corp.google.com> <20131127163435.GA3556@cmpxchg.org> <alpine.DEB.2.02.1311271343250.9222@chino.kir.corp.google.com> <20131127231931.GG3556@cmpxchg.org> <alpine.DEB.2.02.1311271613340.10617@chino.kir.corp.google.com>
 <20131128022804.GJ3556@cmpxchg.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Nov 2013, Johannes Weiner wrote:

> The long-standing, user-visible definition of the current line agrees
> with me.  You can't just redefine this, period.
> 
> I tried to explain to you how insane the motivation for this patch is,
> but it does not look like you are reading what I write.  But you don't
> get to change user-visible behavior just like that anyway, much less
> so without a sane reason, so this was a complete waste of time :-(
> 

If you would like to leave this to Andrew's decision, that's fine.  
Michal has already agreed with my patch and has acked it in -mm.

If userspace is going to handle oom conditions, which is possible today 
and will be extended in the future, then it should only wakeup as a last 
resort when there is no possibility of future memory freeing.  It would be 
stupid to have userspace wakeup to handle the oom condition and then 
require it determine if the kernel simply needed to give it access to 
memory reserves for the allocating task to exit and free memory so it 
doesn't actually need to do anything.

Section 10 of Documentation/cgroups/memory.txt defines the necessary 
actions for processes waiting on this notification to make forward 
progress, it doesn't expect a process is already going to exit and free 
memory on its own.  Waking up in such a condition would be absolutely 
ludicrous.

Furthermore, if you're looking for notification simply when the memcg oom 
limit has been reached, you can use memory thresholds.  If you're looking 
for notification simply when reclaim is suffering severe pressure, you can 
use VMPRESSURE_CRITICAL.

I've been patient in this thread, but at this point I think everything has 
been said and it's pointless to continue going in circles.  Thanks for 
your time.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753648AbaDCVob (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 17:44:31 -0400
Received: from g2t2353.austin.hp.com ([15.217.128.52]:3503 "EHLO
	g2t2353.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711AbaDCVoC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 17:44:02 -0400
Message-ID: <1396561440.4661.33.camel@buesod1.americas.hpqcorp.net>
Subject: [RFC] mm,tracing: improve current situation
From: Davidlohr Bueso <davidlohr@hp.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Dave Jones <davej@redhat.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 03 Apr 2014 14:44:00 -0700
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

During LSFMM Dave Jones discussed the current situation around
testing/trinity in the mm. One of the conclusions was that basically we
lack tools to gather the necessary information to make debugging a less
painful process, making it pretty much a black box for a lot of cases.

One of the suggested ways to do so was to improve our tracing. Currently
we have events for kmem, vmscan and oom (which really just traces the
tunable updates) -- In addition Dave Hansen also also been trying to add
tracing for TLB range flushing, hopefully that can make it in some time
soon. However, this lacks the more general data that governs all of the
core VM, such as vmas and of course the mm_struct.

To this end, I've started adding events to trace the vma lifecycle,
including: creating, removing, splitting, merging, copying and
adjusting. Currently it only prints out the start and end virtual
addresses, such as:

bash-3661   [000]  ....  222.964847: split_vma: [8a8000-9a6000] => new: [9a6000-9b6000]

Now, on a more general scenario, I basically would like to know, 1) is
this actually useful... I'm hoping that, if in fact something like this
gets merged, it won't just sit there. 2) What other general data would
be useful for debugging purposes? I'm happy to collect feedback and send
out something we can all benefit from.

Thanks,
Davidlohr


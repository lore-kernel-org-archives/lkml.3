Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753051AbbAMCrd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 21:47:33 -0500
Received: from mga01.intel.com ([192.55.52.88]:46332 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750856AbbAMCrc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 21:47:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="511297860"
Date: Tue, 13 Jan 2015 10:27:43 +0800
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Juri Lelli <juri.lelli@arm.com>, Peter Zijlstra <peterz@infradead.org>,
        juri.lelli@gmail.com
Cc: Ingo Molnar <mingo@redhat.com>, Kirill Tkhai <ktkhai@parallels.com>,
        linux-kernel@vger.kernel.org, Wanpeng Li <wanpeng.li@linux.intel.com>
Subject: Re: [PATCH v7 0/7] sched: support dl task migration during cpu
 hotplug and other fixes
Message-ID: <20150113022742.GA13774@kernel>
Reply-To: Wanpeng Li <wanpeng.li@linux.intel.com>
References: <1420338714-15624-1-git-send-email-wanpeng.li@linux.intel.com>
 <20150105232011.GA13200@kernel>
 <20150112020452.GA2343@kernel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150112020452.GA2343@kernel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc Juri's gmail
On Mon, Jan 12, 2015 at 10:04:52AM +0800, Wanpeng Li wrote:
>Ping,
>On Tue, Jan 06, 2015 at 07:20:11AM +0800, Wanpeng Li wrote:
>>Ping Juri, Peter, 1/7~6/7 can be reviewed/applied separately since patch 7/7 
>>is still need more work.
>>On Sun, Jan 04, 2015 at 10:31:47AM +0800, Wanpeng Li wrote:
>>>v6 -> v7:
>>> * rebase 
>>>
>>>I collect recent send out patches to one patchset in order to get review easily.
>>>
>>>For 7/7 I will remove rd->span related modification if Pang's effort merged.
>>>https://lkml.org/lkml/2014/11/17/443
>>>
>>>Wanpeng Li (7):
>>>  sched/deadline: fix start high-res preemption tick for a non-leftmost task
>>>  sched/deadline: fix rt runtime corrupt when dl refuse a smaller bandwidth
>>>  sched/deadline: fix dl entity is still mark yield after replenishing
>>>  sched/deadline: reduce overhead if there are no scheduling parameters changed
>>>  sched/fair: fix idle balance when remaining tasks are all non-CFS tasks
>>>  sched: fix start hrtick for short schedule slices on UP
>>>  sched/deadline: support dl task migration during cpu hotplug
>>>
>>> kernel/sched/core.c     | 27 +++++++++++++++++----
>>> kernel/sched/deadline.c | 62 +++++++++++++++++++++++++++++++++++++++++++++----
>>> kernel/sched/fair.c     |  2 +-
>>> kernel/sched/sched.h    |  3 ++-
>>> 4 files changed, 84 insertions(+), 10 deletions(-)
>>>
>>>-- 
>>>1.9.1

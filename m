Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757179Ab3JILLv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 07:11:51 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:57805 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955Ab3JILLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 07:11:50 -0400
Date: Wed, 9 Oct 2013 13:11:47 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/63] Basic scheduler support for automatic NUMA
 balancing V9
Message-ID: <20131009111146.GA19610@gmail.com>
References: <1381141781-10992-1-git-send-email-mgorman@suse.de>
 <20131009110353.GA19370@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131009110353.GA19370@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@kernel.org> wrote:

> 3)
> 
> Plus in addition to PeterZ's build fix I noticed this new build warning on 
> i386 UP kernels:
> 
>  kernel/sched/fair.c:819:22: warning: 'task_h_load' declared 'static' but never defined [-Wunused-function]
> 
> Introduced here I think:
> 
>     sched/numa: Use a system-wide search to find swap/migration candidates

4)

allyes builds fail on x86 32-bit:

   mm/mmzone.c:101:5: error: redefinition of ‘page_cpupid_xchg_last’

The reason is the mismatch in definitions:

 mm.h:

  #ifdef LAST_CPUPID_NOT_IN_PAGE_FLAGS

 mmzone.c:

  #if defined(CONFIG_NUMA_BALANCING) && !defined(LAST_CPUPID_IN_PAGE_FLAGS)

Note the missing 'NOT_' in the latter line. I've changed it to:

  #if defined(CONFIG_NUMA_BALANCING) && defined(LAST_CPUPID_NOT_IN_PAGE_FLAGS)

Thanks,

	Ingo

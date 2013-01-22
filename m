Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941Ab3AVWk1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 17:40:27 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46821 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753097Ab3AVWk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 17:40:26 -0500
Date: Tue, 22 Jan 2013 14:40:24 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Simon Jeons <simon.jeons@gmail.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Hugh Dickins <hughd@google.com>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/6] mm: numa: Handle side-effects in
 count_vm_numa_events() for !CONFIG_NUMA_BALANCING
Message-Id: <20130122144024.8ded0f53.akpm@linux-foundation.org>
In-Reply-To: <1358874762-19717-4-git-send-email-mgorman@suse.de>
References: <1358874762-19717-1-git-send-email-mgorman@suse.de>
	<1358874762-19717-4-git-send-email-mgorman@suse.de>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Jan 2013 17:12:39 +0000
Mel Gorman <mgorman@suse.de> wrote:

> The current definitions for count_vm_numa_events() is wrong for
> !CONFIG_NUMA_BALANCING as the following would miss the side-effect.
> 
> 	count_vm_numa_events(NUMA_FOO, bar++);

Stupid macros.

> There are no such users of count_vm_numa_events() but it is a potential
> pitfall. This patch fixes it and converts count_vm_numa_event() so that
> the definitions look similar.

Confused.  The patch doesn't alter count_vm_numa_event().  No matter.

> --- a/include/linux/vmstat.h
> +++ b/include/linux/vmstat.h
> @@ -85,7 +85,7 @@ static inline void vm_events_fold_cpu(int cpu)
>  #define count_vm_numa_events(x, y) count_vm_events(x, y)
>  #else
>  #define count_vm_numa_event(x) do {} while (0)
> -#define count_vm_numa_events(x, y) do {} while (0)
> +#define count_vm_numa_events(x, y) do { (void)(y); } while (0)
>  #endif /* CONFIG_NUMA_BALANCING */
>  
>  #define __count_zone_vm_events(item, zone, delta) \


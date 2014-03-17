Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932506AbaCQKmY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 06:42:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36138 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753967AbaCQKmX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 06:42:23 -0400
Date: Mon, 17 Mar 2014 11:42:20 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Vegard Nossum <vegard.nossum@oracle.com>
Cc: Xishi Qiu <qiuxishi@huawei.com>, Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        David Rientjes <rientjes@google.com>,
        Vegard Nossum <vegard.nossum@gmail.com>, Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizefan@huawei.com>
Subject: Re: kmemcheck: OS boot failed because NMI handlers access the memory
 tracked by kmemcheck
Message-ID: <20140317104220.GA7774@dhcp22.suse.cz>
References: <5326BE25.9090201@huawei.com>
 <20140317095141.GA4777@dhcp22.suse.cz>
 <5326C690.4090107@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5326C690.4090107@oracle.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 17-03-14 10:55:28, Vegard Nossum wrote:
> On 03/17/2014 10:51 AM, Michal Hocko wrote:
> >On Mon 17-03-14 17:19:33, Xishi Qiu wrote:
> >>OS boot failed when set cmdline kmemcheck=1. The reason is that
> >>NMI handlers will access the memory from kmalloc(), this will cause
> >>page fault, because memory from kmalloc() is tracked by kmemcheck.
> >>
> >>watchdog_nmi_enable()
> >>	perf_event_create_kernel_counter()
> >>		perf_event_alloc()
> >>			event = kzalloc(sizeof(*event), GFP_KERNEL);
> >
> >Where is this path called from an NMI context?
> >
> >Your trace bellow points at something else and it doesn't seem to
> >allocate any memory either. It looks more like x86_perf_event_update
> >sees an invalid perf_event or something like that...
> >
> 
> It's not important that the kzalloc() is called from NMI context, it's
> important that the memory that was allocated is touched (read/written) from
> NMI context.

OK, I see. I thought that kzalloc already touches that memory but my
knowledge of kmemcheck is basically zero...

Anyway, sorry for the noise.
 
> I'm currently looking into the possibility of handling recursive faults in
> kmemcheck (using the approach outlined by peterz; see
> https://lkml.org/lkml/2014/2/26/141).
> 
> 
> Vegard

-- 
Michal Hocko
SUSE Labs

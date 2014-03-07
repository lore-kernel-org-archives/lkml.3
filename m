Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753778AbaCGRVI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 12:21:08 -0500
Received: from mga09.intel.com ([134.134.136.24]:54880 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751647AbaCGRVE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 12:21:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,608,1389772800"; 
   d="scan'208";a="488039444"
From: Andi Kleen <andi@firstfloor.org>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Tejun Heo <tj@kernel.org>,
        Mel Gorman <mgorman@suse.de>, Oleg Nesterov <oleg@redhat.com>,
        Rik van Riel <riel@redhat.com>, Jianguo Wu <wujianguo@huawei.com>,
        Tim Hockin <thockin@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [patch 03/11] mm, mempolicy: remove per-process flag
References: <alpine.DEB.2.02.1403041952170.8067@chino.kir.corp.google.com>
	<alpine.DEB.2.02.1403041954420.8067@chino.kir.corp.google.com>
Date: Fri, 07 Mar 2014 09:20:39 -0800
In-Reply-To: <alpine.DEB.2.02.1403041954420.8067@chino.kir.corp.google.com>
	(David Rientjes's message of "Tue, 4 Mar 2014 19:59:16 -0800 (PST)")
Message-ID: <877g866i3c.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Rientjes <rientjes@google.com> writes:
>
> Per-process flags are a scarce resource so we should free them up
> whenever possible and make them available.  We'll be using it shortly for
> memcg oom reserves.

I'm not convinced TCP_RR is a meaningfull benchmark for slab.

The shortness seems like an artificial problem.

Just add another flag word to the task_struct? That would seem 
to be the obvious way. People will need it sooner or later anyways.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only

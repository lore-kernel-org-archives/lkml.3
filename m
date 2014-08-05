Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755360AbaHEPnE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 11:43:04 -0400
Received: from g4t3427.houston.hp.com ([15.201.208.55]:40436 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753894AbaHEPnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 11:43:03 -0400
Message-ID: <1407253377.2487.11.camel@j-VirtualBox>
Subject: Re: [PATCH] sched: Reduce contention in update_cfs_rq_blocked_load
From: Jason Low <jason.low2@hp.com>
To: Yuyang Du <yuyang.du@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, Ben Segall <bsegall@google.com>,
        Waiman Long <Waiman.Long@hp.com>, Mel Gorman <mgorman@suse.de>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Rik van Riel <riel@redhat.com>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Chegu Vinod <chegu_vinod@hp.com>, Scott J Norton <scott.norton@hp.com>
Date: Tue, 05 Aug 2014 08:42:57 -0700
In-Reply-To: <20140804191526.GA2480@intel.com>
References: <1407184118.11407.11.camel@j-VirtualBox>
	 <20140804191526.GA2480@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-08-05 at 03:15 +0800, Yuyang Du wrote:
> Hi Jason,
> 
> I am not sure whether you noticed my latest work: rewriting per entity load average
> 
> http://article.gmane.org/gmane.linux.kernel/1760754
> http://article.gmane.org/gmane.linux.kernel/1760755
> http://article.gmane.org/gmane.linux.kernel/1760757
> http://article.gmane.org/gmane.linux.kernel/1760756
> 
> which simply does not track blocked load average at all. Are you interested in
> testing the patchset with the workload you have?

Hi Yuyang, yes I can also test your latest patchset with some of the
AIM7 workloads. Not needing extra overhead for the blocked load should
also address this contention in update_cfs_rq_blocked_load().

>  The comparison can also help
> us understand the rewrite. Overall, per our tests, the overhead should be less,
> and perf should be better.



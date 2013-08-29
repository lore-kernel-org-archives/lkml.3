Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755802Ab3H2MLB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 08:11:01 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53749 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751715Ab3H2MLA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 08:11:00 -0400
Date: Thu, 29 Aug 2013 13:10:55 +0100
From: Mel Gorman <mgorman@suse.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Miao Xie <miaox@cn.fujitsu.com>,
        David Rientjes <rientjes@google.com>, Christoph Lameter <cl@linux.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org, riel@redhat.com
Subject: Re: [PATCH] cpuset: mm: Reduce large amounts of memory barrier
 related damage v3
Message-ID: <20130829121055.GE22421@suse.de>
References: <20120307180852.GE17697@suse.de>
 <20130823130332.GY31370@twins.programming.kicks-ass.net>
 <20130823181546.GA31370@twins.programming.kicks-ass.net>
 <20130829092828.GB22421@suse.de>
 <20130829094342.GX10002@twins.programming.kicks-ass.net>
 <20130829105656.GD22421@suse.de>
 <20130829111419.GA10002@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20130829111419.GA10002@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 29, 2013 at 01:14:19PM +0200, Peter Zijlstra wrote:
> > I intended to say nr_node_ids, the same size as buffers such as the
> > task_numa_buffers. If we ever return a nid > nr_node_ids here then
> > task_numa_fault would corrupt memory. However, it should be possible for
> > node_weight to exceed nr_node_ids except maybe during node hot-remove so
> > it's not the problem.
> 
> The nodemask situation seems somewhat more confused than the cpumask
> case; how would we ever return a nid > nr_node_ids? Corrupt nodemask?
> 

ARGH. I meant impossible. The exact bloody opposite of what I wrote.

-- 
Mel Gorman
SUSE Labs

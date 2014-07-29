Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753287AbaG2JQm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 05:16:42 -0400
Received: from mail-ig0-f180.google.com ([209.85.213.180]:60629 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753068AbaG2JQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 05:16:40 -0400
Date: Tue, 29 Jul 2014 02:16:37 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
cc: Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@vger.kernel.org,
        Minchan Kim <minchan@kernel.org>,
        Michal Nazarewicz <mina86@mina86.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: Re: [PATCH v5 07/14] mm, compaction: khugepaged should not give up
 due to need_resched()
In-Reply-To: <20140729082714.GD1610@js1304-P5Q-DELUXE>
Message-ID: <alpine.DEB.2.02.1407290213420.13227@chino.kir.corp.google.com>
References: <1406553101-29326-1-git-send-email-vbabka@suse.cz> <1406553101-29326-8-git-send-email-vbabka@suse.cz> <20140729065327.GB1610@js1304-P5Q-DELUXE> <alpine.DEB.2.02.1407290024550.7998@chino.kir.corp.google.com>
 <20140729082714.GD1610@js1304-P5Q-DELUXE>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jul 2014, Joonsoo Kim wrote:

> Hmm, if thp faults want to pay cost as least as possible, how about
> making thp faults skip async/sync compaction at all?
> 

You can certainly do that with /sys/kernel/mm/transparent_hugepage/defrag.

Without doing memory compaction, though, at least one of my customers will 
have their thp ratio drop significantly and for the vast majority of our 
machines minimal compaction is all that is needed to allocate a hugepage.  
I'm concerned primarily about the straggler that has very lengthy fault 
times for even single hugepages.

This patchset will address some of those concerns, but I agree with you 
that we should be terminating async compaction with another heuristic 
rather than need_resched().

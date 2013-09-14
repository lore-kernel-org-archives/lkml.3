Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756403Ab3INC6D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 22:58:03 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:50812 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756179Ab3INC6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 22:58:01 -0400
Message-ID: <5233D09F.6040307@oracle.com>
Date: Sat, 14 Sep 2013 10:57:35 +0800
From: Bob Liu <bob.liu@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/50] Basic scheduler support for automatic NUMA balancing
 V7
References: <1378805550-29949-1-git-send-email-mgorman@suse.de>
In-Reply-To: <1378805550-29949-1-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mel,

On 09/10/2013 05:31 PM, Mel Gorman wrote:
> It has been a long time since V6 of this series and time for an update. Much
> of this is now stabilised with the most important addition being the inclusion
> of Peter and Rik's work on grouping tasks that share pages together.
> 
> This series has a number of goals. It reduces overhead of automatic balancing
> through scan rate reduction and the avoidance of TLB flushes. It selects a
> preferred node and moves tasks towards their memory as well as moving memory
> toward their task. It handles shared pages and groups related tasks together.
> 

I found sometimes numa balancing will be broken after khugepaged
started, because khugepaged always allocate huge page from the node of
the first scanned normal page during collapsing.

A simple use case is when a user run his application interleaving all
nodes using "numactl --interleave=all xxxx".
But after khugepaged started most pages of his application will be
located to only one specific node.

I have a simple patch fix this issue in thread:
[PATCH 2/2] mm: thp: khugepaged: add policy for finding target node

I think this may related with this topic, I don't know whether this
series can also fix the issue I mentioned.

-- 
Regards,
-Bob

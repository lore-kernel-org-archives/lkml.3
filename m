Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752483AbaBCGlm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 01:41:42 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:58485 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836AbaBCGll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 01:41:41 -0500
X-Original-SENDERIP: 10.177.222.146
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Mon, 3 Feb 2014 15:41:38 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: akpm@linux-foundation.org, riel@redhat.com, mgorman@suse.de,
        mhocko@suse.cz, aneesh.kumar@linux.vnet.ibm.com,
        kamezawa.hiroyu@jp.fujitsu.com, hughd@google.com,
        david@gibson.dropbear.id.au, liwanp@linux.vnet.ibm.com,
        n-horiguchi@ah.jp.nec.com, dhillf@gmail.com, rientjes@google.com,
        aswin@hp.com, scott.norton@hp.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 6/6] mm, hugetlb: improve page-fault scalability
Message-ID: <20140203064138.GA2360@lge.com>
References: <1391189806-13319-1-git-send-email-davidlohr@hp.com>
 <1391189806-13319-7-git-send-email-davidlohr@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391189806-13319-7-git-send-email-davidlohr@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 31, 2014 at 09:36:46AM -0800, Davidlohr Bueso wrote:
> From: Davidlohr Bueso <davidlohr@hp.com>
> 
> The kernel can currently only handle a single hugetlb page fault at a time.
> This is due to a single mutex that serializes the entire path. This lock
> protects from spurious OOM errors under conditions of low of low availability
> of free hugepages. This problem is specific to hugepages, because it is
> normal to want to use every single hugepage in the system - with normal pages
> we simply assume there will always be a few spare pages which can be used
> temporarily until the race is resolved.
> 
> Address this problem by using a table of mutexes, allowing a better chance of
> parallelization, where each hugepage is individually serialized. The hash key
> is selected depending on the mapping type. For shared ones it consists of the
> address space and file offset being faulted; while for private ones the mm and
> virtual address are used. The size of the table is selected based on a compromise
> of collisions and memory footprint of a series of database workloads.

Hello,

Thanks for doing this patchset. :)
Just one question!
Why do we need a separate hash key depending on the mapping type?

Thanks.

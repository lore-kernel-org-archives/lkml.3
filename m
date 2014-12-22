Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753729AbaLVWVj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 17:21:39 -0500
Received: from mail-ie0-f178.google.com ([209.85.223.178]:42054 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751606AbaLVWVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 17:21:37 -0500
Date: Mon, 22 Dec 2014 14:21:35 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Dave Hansen <dave.hansen@linux.intel.com>
cc: Rafael Aquini <aquini@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        oleg@redhat.com, linux-mm@kvack.org, Mel Gorman <mel@csn.ul.ie>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH] proc: task_mmu: show page size in
 /proc/<pid>/numa_maps
In-Reply-To: <54985C08.8080608@linux.intel.com>
Message-ID: <alpine.DEB.2.10.1412221420170.11431@chino.kir.corp.google.com>
References: <c97f30472ec5fe79cb8fa8be66cc3d8509777990.1419079617.git.aquini@redhat.com> <20141220183613.GA19229@phnom.home.cmpxchg.org> <20141220194457.GA3166@x61.redhat.com> <54970B49.3070104@linux.intel.com> <20141221222850.GA2038@x61.redhat.com>
 <5498508A.4080108@linux.intel.com> <20141222172459.GA11396@t510.redhat.com> <54985C08.8080608@linux.intel.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Dec 2014, Dave Hansen wrote:

> > Remaining question here is: should we print out 'pagesize' deliberately 
> > or conditionally, only to disambiguate cases where page_size != PAGE_SIZE?
> 
> I say print it unconditionally.  Not to completely overdesign this, but
> I do think we should try to at least mirror the terminology that smaps uses:
> 
> 	KernelPageSize:        4 kB
> 	MMUPageSize:           4 kB
> 
> So definitely call this kernelpagesize.
> 

Feel free to add my acked-by if this patch prints it unconditionally and 
renames this to kernelpagesize per Dave.  I agree we need to leave "huge" 
for existing dependencies even though we have multiple possible hugepage 
sizes.

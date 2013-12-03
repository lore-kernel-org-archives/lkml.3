Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925Ab3LCXlr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 18:41:47 -0500
Received: from mail-yh0-f51.google.com ([209.85.213.51]:48126 "EHLO
	mail-yh0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753015Ab3LCXll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 18:41:41 -0500
Date: Tue, 3 Dec 2013 15:41:38 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Mel Gorman <mgorman@suse.de>
cc: Andrew Morton <akpm@linux-foundation.org>, Tony Luck <tony.luck@intel.com>,
        Russell King <linux@arm.linux.org.uk>,
        James Bottomley <jejb@parisc-linux.org>,
        linux-arm-kernel@lists.infradead.org, linux-ia64@vger.kernel.org,
        linux-parisc@vger.kernel.org, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm, show_mem: Remove SHOW_MEM_FILTER_PAGE_COUNT
In-Reply-To: <20131203145721.GQ11295@suse.de>
Message-ID: <alpine.DEB.2.02.1312031541240.5946@chino.kir.corp.google.com>
References: <20131016104228.GM11028@suse.de> <alpine.DEB.2.02.1310161809470.12062@chino.kir.corp.google.com> <20131203145721.GQ11295@suse.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Dec 2013, Mel Gorman wrote:

> Commit 4b59e6c4 (mm, show_mem: suppress page counts in non-blockable
> contexts) introduced SHOW_MEM_FILTER_PAGE_COUNT to suppress PFN walks
> on large memory machines. Commit c78e9363 (mm: do not walk all of system
> memory during show_mem) avoided a PFN walk in the generic show_mem helper
> which removes the requirement for SHOW_MEM_FILTER_PAGE_COUNT in that case.
> 
> This patch removes PFN walkers from the arch-specific implementations that
> report on a per-node or per-zone granularity. ARM and unicore32 still do
> a PFN walk as they report memory usage on each bank which is a much finer
> granularity where the debugging information may still be of use. As the
> remaining arches doing PFN walks have relatively small amounts of memory,
> this patch simply removes SHOW_MEM_FILTER_PAGE_COUNT.
> 
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Acked-by: David Rientjes <rientjes@google.com>

Thanks!

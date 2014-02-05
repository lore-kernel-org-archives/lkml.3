Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932773AbaBEAGo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 19:06:44 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58764 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754888AbaBEAGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 19:06:43 -0500
Date: Tue, 4 Feb 2014 16:06:41 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Rientjes <rientjes@google.com>
Cc: Holger Kiehl <Holger.Kiehl@dwd.de>, Christoph Lameter <cl@linux.com>,
        Rafael Aquini <aquini@redhat.com>, Vlastimil Babka <vbabka@suse.cz>,
        Michal Hocko <mhocko@suse.cz>, Mel Gorman <mgorman@suse.de>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch] mm, page_alloc: make first_page visible before PageTail
Message-Id: <20140204160641.8f5d369eeb2d0318618d6d5f@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.02.1402041557380.10140@chino.kir.corp.google.com>
References: <alpine.LRH.2.02.1401312037340.6630@diagnostix.dwd.de>
	<20140203122052.GC2495@dhcp22.suse.cz>
	<alpine.LRH.2.02.1402031426510.13382@diagnostix.dwd.de>
	<20140203162036.GJ2495@dhcp22.suse.cz>
	<52EFC93D.3030106@suse.cz>
	<alpine.DEB.2.02.1402031602060.10778@chino.kir.corp.google.com>
	<alpine.LRH.2.02.1402040713220.13901@diagnostix.dwd.de>
	<alpine.DEB.2.02.1402041557380.10140@chino.kir.corp.google.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Feb 2014 16:02:39 -0800 (PST) David Rientjes <rientjes@google.com> wrote:

> Commit bf6bddf1924e ("mm: introduce compaction and migration for ballooned 
> pages") introduces page_count(page) into memory compaction which 
> dereferences page->first_page if PageTail(page).
> 
> Introduce a store memory barrier to ensure page->first_page is properly 
> initialized so that code that does page_count(page) on pages off the lru 
> always have a valid p->first_page.

Could we have a code comment please?  Even checkpatch knows this rule!

> Reported-by: Holger Kiehl <Holger.Kiehl@dwd.de>

What did Holger report?


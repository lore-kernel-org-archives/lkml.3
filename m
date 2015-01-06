Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756219AbbAFRzF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 12:55:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33217 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755337AbbAFRzD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 12:55:03 -0500
Date: Tue, 6 Jan 2015 12:54:43 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Johannes Weiner <hannes@cmpxchg.org>
cc: Vlastimil Babka <vbabka@suse.cz>, Leon Romanovsky <leon@leon.nu>,
        Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: Dirty pages underflow on 3.14.23
In-Reply-To: <20150106150250.GA26895@phnom.home.cmpxchg.org>
Message-ID: <alpine.LRH.2.02.1501061246400.16437@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1501051744020.5119@file01.intranet.prod.int.rdu2.redhat.com> <20150106150250.GA26895@phnom.home.cmpxchg.org>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 6 Jan 2015, Johannes Weiner wrote:

> > The bug probably happened during git pull or apt-get update, though one 
> > can't be sure that these commands caused it.
> > 
> > I see that 3.14.24 containes some fix for underflow (commit 
> > 6619741f17f541113a02c30f22a9ca22e32c9546, upstream commit 
> > abe5f972912d086c080be4bde67750630b6fb38b), but it doesn't seem that that 
> > commit fixes this condition. If you have a commit that could fix this, say 
> > it.
> 
> That's an unrelated counter, but there is a known dirty underflow
> problem that was addressed in 87a7e00b206a ("mm: protect
> set_page_dirty() from ongoing truncation").  It should make it into
> the stable kernels in the near future.  Can you reproduce this issue?
> 
> Thanks,
> Johannes

I can't reprodce it. It happened just once.

That patch is supposed to fix an occasional underflow by a single page - 
while my meminfo showed underflow by 22952KiB (5738 pages).

Mikulas

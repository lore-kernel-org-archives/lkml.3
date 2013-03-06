Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756499Ab3CFWWt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 17:22:49 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48505 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753136Ab3CFWWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 17:22:48 -0500
Date: Wed, 6 Mar 2013 14:22:46 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Hillf Danton <dhillf@gmail.com>
Cc: Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Michal Hocko <mhocko@suse.cz>, Michel Lespinasse <walken@google.com>
Subject: Re: [PATCH resend] rmap: recompute pgoff for unmapping huge page
Message-Id: <20130306142246.b333f350f713dbbf3e931d93@linux-foundation.org>
In-Reply-To: <CAJd=RBD0UWxpMv7W78fH0U_zBAOozP1owaMePGaUEVitotRfBg@mail.gmail.com>
References: <CAJd=RBD0UWxpMv7W78fH0U_zBAOozP1owaMePGaUEVitotRfBg@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Mar 2013 20:47:31 +0800 Hillf Danton <dhillf@gmail.com> wrote:

> [Resend due to error in delivering to linux-kernel@vger.kernel.org,
> caused probably by the rich format provided by the mail agent by default.]
> 
> We have to recompute pgoff if the given page is huge, since result based on
> HPAGE_SIZE is not approapriate for scanning the vma interval tree, as shown
> by commit 36e4f20af833(hugetlb: do not use vma_hugecache_offset() for
> vma_prio_tree_foreach)
> 
> ...
>
> @@ -1513,6 +1513,9 @@ static int try_to_unmap_file(struct page
>  	unsigned long max_nl_size = 0;
>  	unsigned int mapcount;
> 
> +	if (PageHuge(page))
> +		pgoff = page->index << compound_order(page);
> +
>  	mutex_lock(&mapping->i_mmap_mutex);
>  	vma_interval_tree_foreach(vma, &mapping->i_mmap, pgoff, pgoff) {
>  		unsigned long address = vma_address(page, vma);

Also, what does this patch actually do?

I have a canned response nowadays:

When writing a changelog, please describe the end-user-visible effects
of that bug, so that others can more easily decide which kernel
version(s) should be fixed, and so that downstream kernel maintainers
can more easily work out whether this patch will fix a problem which
they or their customers are observing.


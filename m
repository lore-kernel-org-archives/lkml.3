Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288Ab3AWDM2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 22:12:28 -0500
Received: from talus.maths.usyd.edu.au ([129.78.68.1]:57904 "EHLO
	talus.maths.usyd.edu.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136Ab3AWDM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 22:12:27 -0500
X-smtpdoor-from: psz@maths.usyd.edu.au
X-smtpdoor-want-Message-ID: <201301230311.r0N3BPdE032604@como.maths.usyd.edu.au>
Date: Wed, 23 Jan 2013 14:11:25 +1100
From: paul.szabo@sydney.edu.au
Message-Id: <201301230311.r0N3BPdE032604@como.maths.usyd.edu.au>
To: minchan@kernel.org
Subject: Re: [PATCH] Subtract min_free_kbytes from dirtyable memory
Cc: 695182@bugs.debian.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20130123014959.GB2723@blaptop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Minchan,

> So what's the effect for user?

Sorry I have no idea.

The kernel seems to work well without this patch; or in fact not so
well, PAE crashing with spurious OOM. In my fruitless efforts of
avoiding OOM by sensible choices of sysctl tunables, I noticed that
maybe the treatment of min_free_kbytes was not right. Getting this
right did not help in avoiding OOM.

> It seems you saw old kernel.

Yes I have Debian on my machines. :-)

> Current kernel includes following logic.
> 
> static unsigned long global_dirtyable_memory(void)
> {
>         unsigned long x;
> 
>         x = global_page_state(NR_FREE_PAGES) + global_reclaimable_pages();
>         x -= min(x, dirty_balance_reserve);
> 
>         if (!vm_highmem_is_dirtyable)
>                 x -= highmem_dirtyable_memory(x);
> 
>         return x + 1;   /* Ensure that we never return 0 */
> }
> 
> And dirty_lanace_reserve already includes high_wmark_pages.
> Look at calculate_totalreserve_pages.
> 
> So I think we don't need this patch.
> Thanks.

Presumably, dirty_balance_reserve takes min_free_kbytes into account?
Then I agree that this patch is not needed on those newer kernels.

A question: what is the use or significance of vm_highmem_is_dirtyable?
It seems odd that it would be used in setting limits or threshholds, but
not used in decisions where to put dirty things. Is that so, is that as
should be? What is the recommended setting of highmem_is_dirtyable?

Thanks, Paul

Paul Szabo   psz@maths.usyd.edu.au   http://www.maths.usyd.edu.au/u/psz/
School of Mathematics and Statistics   University of Sydney    Australia

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752932AbbALXyo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 18:54:44 -0500
Received: from gum.cmpxchg.org ([85.214.110.215]:57213 "EHLO gum.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751332AbbALXyn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 18:54:43 -0500
Date: Mon, 12 Jan 2015 18:54:38 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, gthelen@google.com, mm-commits@vger.kernel.org
Subject: Re: +
 mm-memcontrol-default-hierarchy-interface-for-memory-checkpatch-fixes.patch
 added to -mm tree
Message-ID: <20150112235438.GA27349@phnom.home.cmpxchg.org>
References: <54b45b27.XjEauKOqAygxldaJ%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54b45b27.XjEauKOqAygxldaJ%akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2015 at 03:39:19PM -0800, akpm@linux-foundation.org wrote:
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: mm-memcontrol-default-hierarchy-interface-for-memory-checkpatch-fixes
> 
> Cc: Greg Thelen <gthelen@google.com>
> 
> WARNING: Prefer seq_puts to seq_printf
> #315: FILE: mm/memcontrol.c:5340:
> +		seq_printf(m, "none\n");
> 
> WARNING: Prefer seq_puts to seq_printf
> #349: FILE: mm/memcontrol.c:5374:
> +		seq_printf(m, "none\n");
> 
> WARNING: Prefer seq_puts to seq_printf
> #383: FILE: mm/memcontrol.c:5408:
> +		seq_printf(m, "none\n");
> 
> total: 0 errors, 3 warnings, 431 lines checked
> 
> ./patches/mm-memcontrol-default-hierarchy-interface-for-memory.patch has style problems, please review.
> 
> If any of these errors are false positives, please report
> them to the maintainer, see CHECKPATCH in MAINTAINERS.
> 
> Please run checkpatch prior to sending patches
> 
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  mm/memcontrol.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff -puN mm/memcontrol.c~mm-memcontrol-default-hierarchy-interface-for-memory-checkpatch-fixes mm/memcontrol.c
> --- a/mm/memcontrol.c~mm-memcontrol-default-hierarchy-interface-for-memory-checkpatch-fixes
> +++ a/mm/memcontrol.c
> @@ -5337,7 +5337,7 @@ static int memory_low_show(struct seq_fi
>  	unsigned long low = ACCESS_ONCE(memcg->low);
>  
>  	if (low == 0)
> -		seq_printf(m, "none\n");
> +		seq_puts(m, "none\n");
>  	else
>  		seq_printf(m, "%llu\n", (u64)low * PAGE_SIZE);

Hm, is that really an improvement to the code?  With seq_printf() the
calls in both branches align visually much nicer, IMO.

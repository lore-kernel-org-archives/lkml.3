Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751588AbaKCEWu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 23:22:50 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:42553 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839AbaKCEWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 23:22:48 -0500
Date: Sun, 02 Nov 2014 23:22:45 -0500 (EST)
Message-Id: <20141102.232245.1502900027200657150.davem@davemloft.net>
To: hannes@cmpxchg.org
Cc: akpm@linux-foundation.org, mhocko@suse.cz, vdavydov@parallels.com,
        tj@kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 1/3] mm: embed the memcg pointer directly into struct
 page
From: David Miller <davem@davemloft.net>
In-Reply-To: <1414898156-4741-1-git-send-email-hannes@cmpxchg.org>
References: <1414898156-4741-1-git-send-email-hannes@cmpxchg.org>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sun, 02 Nov 2014 20:22:47 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Weiner <hannes@cmpxchg.org>
Date: Sat,  1 Nov 2014 23:15:54 -0400

> Memory cgroups used to have 5 per-page pointers.  To allow users to
> disable that amount of overhead during runtime, those pointers were
> allocated in a separate array, with a translation layer between them
> and struct page.
> 
> There is now only one page pointer remaining: the memcg pointer, that
> indicates which cgroup the page is associated with when charged.  The
> complexity of runtime allocation and the runtime translation overhead
> is no longer justified to save that *potential* 0.19% of memory.  With
> CONFIG_SLUB, page->mem_cgroup actually sits in the doubleword padding
> after the page->private member and doesn't even increase struct page,
> and then this patch actually saves space.  Remaining users that care
> can still compile their kernels without CONFIG_MEMCG.
> 
>    text    data     bss     dec     hex     filename
> 8828345 1725264  983040 11536649 b00909  vmlinux.old
> 8827425 1725264  966656 11519345 afc571  vmlinux.new
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Looks great:

Acked-by: David S. Miller <davem@davemloft.net>

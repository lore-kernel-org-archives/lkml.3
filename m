Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751585AbaGGWH7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 18:07:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54410 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976AbaGGWH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 18:07:58 -0400
Date: Mon, 7 Jul 2014 15:07:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm,vmacache: inline vmacache_valid_mm()
Message-Id: <20140707150757.d8812f4243c9c5dccebc3e4f@linux-foundation.org>
In-Reply-To: <1404508083.2457.15.camel@buesod1.americas.hpqcorp.net>
References: <1404508083.2457.15.camel@buesod1.americas.hpqcorp.net>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 04 Jul 2014 14:08:03 -0700 Davidlohr Bueso <davidlohr@hp.com> wrote:

> From: Davidlohr Bueso <davidlohr@hp.com>
> 
> No brainer for this little function.
> 
> ...
>
> --- a/mm/vmacache.c
> +++ b/mm/vmacache.c
> @@ -50,7 +50,7 @@ void vmacache_flush_all(struct mm_struct *mm)
>   * Also handle the case where a kernel thread has adopted this mm via use_mm().
>   * That kernel thread's vmacache is not applicable to this mm.
>   */
> -static bool vmacache_valid_mm(struct mm_struct *mm)
> +static inline bool vmacache_valid_mm(struct mm_struct *mm)
>  {
>  	return current->mm == mm && !(current->flags & PF_KTHREAD);
>  }

The patch doesn't actually do anything.

- gcc ignores `inline'

- gcc will inline this function anwyay

- if we really really need a hammer, we use __always_inline, along
  with a comment explaining why.


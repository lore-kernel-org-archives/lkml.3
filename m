Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756814AbaFYWDV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 18:03:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48371 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755795AbaFYWDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 18:03:19 -0400
Date: Wed, 25 Jun 2014 15:03:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: linux-mm@kvack.org, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] mm: catch memory commitment underflow
Message-Id: <20140625150318.4355468ab59a5293e870605e@linux-foundation.org>
In-Reply-To: <20140624201614.18273.39034.stgit@zurg>
References: <20140624201606.18273.44270.stgit@zurg>
	<20140624201614.18273.39034.stgit@zurg>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jun 2014 00:16:14 +0400 Konstantin Khlebnikov <koct9i@gmail.com> wrote:

> This patch prints warning (if CONFIG_DEBUG_VM=y) when
> memory commitment becomes too negative.
> 
> ...
>
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -134,6 +134,12 @@ int __vm_enough_memory(struct mm_struct *mm, long pages, int cap_sys_admin)
>  {
>  	unsigned long free, allowed, reserve;
>  
> +#ifdef CONFIG_DEBUG_VM
> +	WARN_ONCE(percpu_counter_read(&vm_committed_as) <
> +			-(s64)vm_committed_as_batch * num_online_cpus(),
> +			"memory commitment underflow");
> +#endif
> +
>  	vm_acct_memory(pages);

The changelog doesn't describe the reasons for making the change.

I assume this warning will detect the situation which the previous two
patches just fixed?

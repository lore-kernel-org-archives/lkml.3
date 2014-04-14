Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575AbaDNW2C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 18:28:02 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52672 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755352AbaDNW2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 18:28:00 -0400
Date: Mon, 14 Apr 2014 15:27:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, hughd@google.com,
        xemul@parallels.com
Subject: Re: [patch 2/4] mm: Dont forget to set softdirty on file mapped
 fault
Message-Id: <20140414152758.a9a80782dbb94c74a27f683a@linux-foundation.org>
In-Reply-To: <20140324125926.013008345@openvz.org>
References: <20140324122838.490106581@openvz.org>
	<20140324125926.013008345@openvz.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Mar 2014 16:28:40 +0400 Cyrill Gorcunov <gorcunov@openvz.org> wrote:

> Otherwise we may not notice that pte was softdirty.
> 
> --- linux-2.6.git.orig/mm/memory.c
> +++ linux-2.6.git/mm/memory.c
> @@ -3422,7 +3422,7 @@ static int __do_fault(struct mm_struct *
>  		if (flags & FAULT_FLAG_WRITE)
>  			entry = maybe_mkwrite(pte_mkdirty(entry), vma);
>  		else if (pte_file(orig_pte) && pte_file_soft_dirty(orig_pte))
> -			pte_mksoft_dirty(entry);
> +			entry = pte_mksoft_dirty(entry);
>  		if (anon) {
>  			inc_mm_counter_fast(mm, MM_ANONPAGES);
>  			page_add_new_anon_rmap(page, vma, address);

This will need to be redone for current kernels, please.  New patch, new
title, new changelog, retest.

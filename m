Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264AbbAMVoA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 16:44:00 -0500
Received: from mail-la0-f41.google.com ([209.85.215.41]:52698 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752729AbbAMVn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 16:43:58 -0500
Date: Wed, 14 Jan 2015 00:43:55 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        linux-mm@kvack.org, Dave Hansen <dave.hansen@linux.intel.com>,
        Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm: rename mm->nr_ptes to mm->nr_pgtables
Message-ID: <20150113214355.GC2253@moon>
References: <1421176456-21796-1-git-send-email-kirill.shutemov@linux.intel.com>
 <1421176456-21796-2-git-send-email-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421176456-21796-2-git-send-email-kirill.shutemov@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2015 at 09:14:15PM +0200, Kirill A. Shutemov wrote:
> We're going to account pmd page tables too. Let's rename mm->nr_pgtables
> to something more generic.
> 
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -64,7 +64,7 @@ void task_mem(struct seq_file *m, struct mm_struct *mm)
>  		data << (PAGE_SHIFT-10),
>  		mm->stack_vm << (PAGE_SHIFT-10), text, lib,
>  		(PTRS_PER_PTE * sizeof(pte_t) *
> -		 atomic_long_read(&mm->nr_ptes)) >> 10,
> +		 atomic_long_read(&mm->nr_pgtables)) >> 10,

This implies that (PTRS_PER_PTE * sizeof(pte_t)) = (PTRS_PER_PMD * sizeof(pmd_t))
which might be true for all archs, right?

Other looks good to me.

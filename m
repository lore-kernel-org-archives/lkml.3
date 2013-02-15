Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935472Ab3BOIEK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 03:04:10 -0500
Received: from mail-qc0-f181.google.com ([209.85.216.181]:34023 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932900Ab3BOIEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 03:04:08 -0500
MIME-Version: 1.0
In-Reply-To: <1360757029-28868-4-git-send-email-james.hogan@imgtec.com>
References: <1360757029-28868-1-git-send-email-james.hogan@imgtec.com>
	<1360757029-28868-4-git-send-email-james.hogan@imgtec.com>
Date: Fri, 15 Feb 2013 00:04:07 -0800
Message-ID: <CANN689GgS+3z+BLr2JPQqe-_=wzibRLS=wkkEehteR-CQU0LTA@mail.gmail.com>
Subject: Re: [PATCH 3/5] metag: hugetlb: convert to vm_unmapped_area()
From: Michel Lespinasse <walken@google.com>
To: James Hogan <james.hogan@imgtec.com>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2013 at 4:03 AM, James Hogan <james.hogan@imgtec.com> wrote:
> Convert hugetlb_get_unmapped_area_new_pmd() to use vm_unmapped_area()
> rather than searching the virtual address space itself. This fixes the
> following errors in linux-next due to the specified members being
> removed after other architectures have already been converted:
>
> arch/metag/mm/hugetlbpage.c: In function 'hugetlb_get_unmapped_area_new_pmd':
> arch/metag/mm/hugetlbpage.c:199: error: 'struct mm_struct' has no member named 'cached_hole_size'
> arch/metag/mm/hugetlbpage.c:200: error: 'struct mm_struct' has no member named 'free_area_cache'
> arch/metag/mm/hugetlbpage.c:215: error: 'struct mm_struct' has no member named 'cached_hole_size'
>
> Signed-off-by: James Hogan <james.hogan@imgtec.com>
> Cc: Michel Lespinasse <walken@google.com>

Looks good. Just one thing, which I don't have full context to evaluate:

> +       info.align_mask = PAGE_MASK & HUGEPT_MASK;

This will work only if HUGEPT_MASK == HUGEPT_SIZE - 1, as opposed to
the PAGE_MASK definition which is ~(PAGE_SIZE - 1).
Not sure how HUGEPT_MASK is defined, so please double check that.

Acked-by: Michel Lespinasse <walken@google.com>

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.

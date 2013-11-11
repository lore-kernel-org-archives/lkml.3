Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752679Ab3KKHZn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 02:25:43 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:41257 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136Ab3KKHZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 02:25:36 -0500
Date: Mon, 11 Nov 2013 07:25:06 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: ????????? <gxt@pku.edu.cn>
Cc: Davidlohr Bueso <davidlohr@hp.com>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Michel Lespinasse <walken@google.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>, aswin@hp.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: converting unicore32 to gate_vma as done for arm (was Re:??
 [PATCH] mm: cache largest vma)
Message-ID: <20131111072506.GW13318@ZenIV.linux.org.uk>
References: <20131104044844.GN13318@ZenIV.linux.org.uk>
 <289468516.24288.1383619755331.JavaMail.root@bj-mail03.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <289468516.24288.1383619755331.JavaMail.root@bj-mail03.pku.edu.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 05, 2013 at 10:49:15AM +0800, ????????? wrote:
> The patch is ok for unicore32. Thanks Al.
> 
> While testing this patch, a bug is found in arch/unicore32/include/asm/pgtable.h:
> 
> @@ -96,7 +96,7 @@ extern pgprot_t pgprot_kernel;
>                                                                 | PTE_EXEC)
>  #define PAGE_READONLY          __pgprot(pgprot_val(pgprot_user | PTE_READ)
>  #define PAGE_READONLY_EXEC     __pgprot(pgprot_val(pgprot_user | PTE_READ \
> -                                                               | PTE_EXEC)
> +                                                               | PTE_EXEC))
> 
> In fact, all similar macros are wrong. I'll post an bug-fix patch for this obvious error.

BTW, another missing thing is an analog of commit 9b61a4 (ARM: prevent
VM_GROWSDOWN mmaps extending below FIRST_USER_ADDRESS); I'm not sure why
does unicore32 have FIRST_USER_ADDRESS set to PAGE_SIZE (some no-MMU
arm variants really need that, what with the vectors page living at
address 0 on those), but since you have it set that way, you'd probably
better not allow a mapping to grow down there...

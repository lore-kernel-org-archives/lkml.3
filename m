Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030709Ab3HIOmq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 10:42:46 -0400
Received: from mga02.intel.com ([134.134.136.20]:37214 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030282Ab3HIOmo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 10:42:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,846,1367996400"; 
   d="scan'208";a="384458981"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Ning Qu <quning@google.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Hillf Danton <dhillf@gmail.com>, Dave Hansen <dave@sr71.net>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <CACz4_2fv1g2dRLh72gtaCYkNC6+Pp4h=R0q-taR51tejpL1gnw@mail.gmail.com>
References: <1375582645-29274-1-git-send-email-kirill.shutemov@linux.intel.com>
 <1375582645-29274-21-git-send-email-kirill.shutemov@linux.intel.com>
 <CACz4_2f2frTktfUusWGcaqZtTmQS8FSY0HqwXCas44EW7Q5Xsw@mail.gmail.com>
 <CACz4_2de=zm2-VtE=dFTfYjrdma4QFX1S-ukQ_7J4DZ32q1JQQ@mail.gmail.com>
 <CACz4_2fv1g2dRLh72gtaCYkNC6+Pp4h=R0q-taR51tejpL1gnw@mail.gmail.com>
Subject: Re: [PATCH 20/23] thp: handle file pages in split_huge_page()
Content-Transfer-Encoding: 7bit
Message-Id: <20130809144601.159CAE0090@blue.fi.intel.com>
Date: Fri,  9 Aug 2013 17:46:01 +0300 (EEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ning Qu wrote:
> I just tried, and it seems working fine now without the deadlock anymore. I
> can run some big internal test with about 40GB files in sysv shm. Just move
> the line before the locking happens in vma_adjust, something as below, the
> line number is not accurate because my patch is based on another tree right
> now.

Looks okay to me. Could you prepare real patch (description, etc.). I'll
add it to my patchset.

> 
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -581,6 +581,8 @@ again:                      remove_next = 1 + (end >
> next->vm_end);
>                 }
>         }
> 
> +       vma_adjust_trans_huge(vma, start, end, adjust_next);
> +
>         if (file) {
>                 mapping = file->f_mapping;
>                 if (!(vma->vm_flags & VM_NONLINEAR))
> @@ -597,8 +599,6 @@ again:                      remove_next = 1 + (end >
> next->vm_end);
>                 }
>         }
> 
> -       vma_adjust_trans_huge(vma, start, end, adjust_next);
> -
>         anon_vma = vma->anon_vma;
>         if (!anon_vma && adjust_next)
>                 anon_vma = next->anon_vma;
> 
> 
> Best wishes,
> -- 
> Ning Qu (曲宁) | Software Engineer | quning@google.com | +1-408-418-6066

-- 
 Kirill A. Shutemov

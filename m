Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553Ab3BOJ1S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 04:27:18 -0500
Received: from multi.imgtec.com ([194.200.65.239]:25208 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754179Ab3BOJ1R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 04:27:17 -0500
Message-ID: <511DFF63.8080009@imgtec.com>
Date: Fri, 15 Feb 2013 09:26:59 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Michel Lespinasse <walken@google.com>
CC: <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 3/5] metag: hugetlb: convert to vm_unmapped_area()
References: <1360757029-28868-1-git-send-email-james.hogan@imgtec.com> <1360757029-28868-4-git-send-email-james.hogan@imgtec.com> <CANN689GgS+3z+BLr2JPQqe-_=wzibRLS=wkkEehteR-CQU0LTA@mail.gmail.com>
In-Reply-To: <CANN689GgS+3z+BLr2JPQqe-_=wzibRLS=wkkEehteR-CQU0LTA@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2013_02_15_09_27_01
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/02/13 08:04, Michel Lespinasse wrote:
> On Wed, Feb 13, 2013 at 4:03 AM, James Hogan <james.hogan@imgtec.com> wrote:
>> Convert hugetlb_get_unmapped_area_new_pmd() to use vm_unmapped_area()
>> rather than searching the virtual address space itself. This fixes the
>> following errors in linux-next due to the specified members being
>> removed after other architectures have already been converted:
>>
>> arch/metag/mm/hugetlbpage.c: In function 'hugetlb_get_unmapped_area_new_pmd':
>> arch/metag/mm/hugetlbpage.c:199: error: 'struct mm_struct' has no member named 'cached_hole_size'
>> arch/metag/mm/hugetlbpage.c:200: error: 'struct mm_struct' has no member named 'free_area_cache'
>> arch/metag/mm/hugetlbpage.c:215: error: 'struct mm_struct' has no member named 'cached_hole_size'
>>
>> Signed-off-by: James Hogan <james.hogan@imgtec.com>
>> Cc: Michel Lespinasse <walken@google.com>
> 
> Looks good. Just one thing, which I don't have full context to evaluate:
> 
>> +       info.align_mask = PAGE_MASK & HUGEPT_MASK;
> 
> This will work only if HUGEPT_MASK == HUGEPT_SIZE - 1, as opposed to
> the PAGE_MASK definition which is ~(PAGE_SIZE - 1).
> Not sure how HUGEPT_MASK is defined, so please double check that.
> 
> Acked-by: Michel Lespinasse <walken@google.com>
> 

Thanks Michel. HUGEPT_MASK is indeed equal to HUGEPT_SIZE - 1. I
originally did info.align_mask = PAGE_MASK & ~HUGEPT_MASK accidentally
and as you say it just didn't work :)

Cheers
James


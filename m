Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753914Ab3AKJ6k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 04:58:40 -0500
Received: from multi.imgtec.com ([194.200.65.239]:56754 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753217Ab3AKJ6h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 04:58:37 -0500
Message-ID: <50EFE24A.8070903@imgtec.com>
Date: Fri, 11 Jan 2013 09:58:34 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>
Subject: Re: [PATCH v3 15/44] metag: Huge TLB
References: <1357831872-29451-1-git-send-email-james.hogan@imgtec.com> <1357831872-29451-16-git-send-email-james.hogan@imgtec.com> <50EEF2E9.2080302@linux.vnet.ibm.com>
In-Reply-To: <50EEF2E9.2080302@linux.vnet.ibm.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2013_01_11_09_58_35
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/13 16:57, Dave Hansen wrote:
> On 01/10/2013 07:30 AM, James Hogan wrote:
>> +pte_t *huge_pte_alloc(struct mm_struct *mm,
>> +			unsigned long addr, unsigned long sz)
>> +{
>> +	pgd_t *pgd;
>> +	pud_t *pud;
>> +	pmd_t *pmd;
>> +	pte_t *pte;
>> +
>> +	pgd = pgd_offset(mm, addr);
>> +	pud = pud_offset(pgd, addr);
>> +	pmd = pmd_offset(pud, addr);
>> +	pte = pte_alloc_map(mm, NULL, pmd, addr);
>> +	pgd->pgd &= ~_PAGE_SZ_MASK;
>> +	pgd->pgd |= _PAGE_SZHUGE;
>> +
>> +	return pte;
>> +}
> 
> I'd be a bit surprised if you don't have to check for NULL during the
> walk down the page tables.  Is there a special reason on your
> architecture that this is unnecessary?
> 
> (There are several of these, not just this one).
> 

Meta only has 2 levels of page tables which map to the linux levels.
asm/pgtable.h includes asm-generic/pgtable-nopmd.h, which includes
asm-generic/pgtable-nopud.h, so the pmd and pud levels get folded into
the pgd.

Cheers
James


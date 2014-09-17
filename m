Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755514AbaIQORU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 10:17:20 -0400
Received: from mail.emea.novell.com ([130.57.118.101]:34557 "EHLO
	mail.emea.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754870AbaIQORT convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Wed, 17 Sep 2014 10:17:19 -0400
Message-Id: <5419B40B0200007800035B09@mail.emea.novell.com>
X-Mailer: Novell GroupWise Internet Agent 14.0.1 
Date: Wed, 17 Sep 2014 15:17:15 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "David Vrabel" <david.vrabel@citrix.com>
Cc: "xen-devel" <xen-devel@lists.xenproject.org>, <boris.ostrovsky@oracle.com>,
        <konrad.wilk@oracle.com>, "Juergen Gross" <JGross@suse.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH V2 3/3] xen: eliminate scalability
 issues from initial mapping setup
References: <1410927157-15069-1-git-send-email-jgross@suse.com>
 <1410927157-15069-4-git-send-email-jgross@suse.com>
 <54199589.9040703@citrix.com>
In-Reply-To: <54199589.9040703@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 17.09.14 at 16:07, <david.vrabel@citrix.com> wrote:
> On 17/09/14 05:12, Juergen Gross wrote:
>> +static void __init xen_cleanmfnmap(unsigned long vaddr)
>> +{
>> +	unsigned long va = vaddr & PMD_MASK;
>> +	unsigned long pa;
>> +	pgd_t *pgd = pgd_offset_k(va);
>> +	pud_t *pud_page = pud_offset(pgd, 0);
>> +	pud_t *pud;
>> +	pmd_t *pmd;
>> +	pte_t *pte;
>> +	unsigned int i;
>> +
>> +	set_pgd(pgd, __pgd(0));
>> +	do {
>> +		pud = pud_page + pud_index(va);
>> +		if (pud_none(*pud)) {
>> +			va += PUD_SIZE;
>> +		} else if (pud_large(*pud)) {
>> +			pa = pud_val(*pud) & PHYSICAL_PAGE_MASK;
>> +			xen_free_ro_pages(pa, PUD_SIZE);
>> +			va += PUD_SIZE;
> 
> Are you missing a ClearPagePinned(..) here?

No, this is a 1Gb data page, not a page table one.

Jan


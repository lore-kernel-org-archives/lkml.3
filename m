Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964AbaBSP2n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 10:28:43 -0500
Received: from mail-lb0-f171.google.com ([209.85.217.171]:48057 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753804AbaBSP2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 10:28:41 -0500
MIME-Version: 1.0
Date: Wed, 19 Feb 2014 10:28:40 -0500
Message-ID: <CAHqbYQtLG0yE98kCHkCaec+oHF7c2Pwiqrsi5C2eHnGfbsR+sQ@mail.gmail.com>
Subject: How pte_mkspecial makes zero-page COW on x86 ARCH
From: Hu Yaohui <loki2441@gmail.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,
I read the code in do_anonymous_page of the latest linux kernel.
I am pretty confused how pte_mkspecial to make the zero-page COW on
x86 architecture
<code>
static int do_anonymous_page(struct mm_struct *mm, struct vm_area_struct *vma,
                unsigned long address, pte_t *page_table, pmd_t *pmd,
                unsigned int flags)
{
.....
        /* Use the zero-page for reads */
        if (!(flags & FAULT_FLAG_WRITE)) {
                entry = pte_mkspecial(pfn_pte(my_zero_pfn(address),
                                                vma->vm_page_prot));
                page_table = pte_offset_map_lock(mm, pmd, address, &ptl);
                if (!pte_none(*page_table))
                        goto unlock;
                goto setpte;
        }
......
}
</code>
In the previous linux kernel, this is done by pte_wrprotect to make page COW.
Thanks for your time!

Best Wishes,
Yaohui

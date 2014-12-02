Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754441AbaLBHcB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 02:32:01 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:38786 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110AbaLBHb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 02:31:59 -0500
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Mel Gorman <mgorman@suse.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>,
        LinuxPPC-dev <linuxppc-dev@lists.ozlabs.org>,
        Hugh Dickins <hughd@google.com>, Dave Jones <davej@redhat.com>,
        Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Kirill Shutemov <kirill.shutemov@linux.intel.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        Paul Mackerras <paulus@samba.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 03/10] mm: Convert p[te|md]_numa users to p[te|md]_protnone_numa
In-Reply-To: <1417473849.7182.9.camel@kernel.crashing.org>
References: <1416578268-19597-1-git-send-email-mgorman@suse.de> <1416578268-19597-4-git-send-email-mgorman@suse.de> <1417473849.7182.9.camel@kernel.crashing.org>
User-Agent: Notmuch/0.19+2~g32855b9 (http://notmuchmail.org) Emacs/25.0.50.1 (x86_64-pc-linux-gnu)
Date: Tue, 02 Dec 2014 13:01:29 +0530
Message-ID: <87h9xeh5im.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120207-0033-0000-0000-000000A5C987
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt <benh@kernel.crashing.org> writes:

> On Fri, 2014-11-21 at 13:57 +0000, Mel Gorman wrote:
>> void set_pte_at(struct mm_struct *mm, unsigned long addr, pte_t *ptep,
>>                 pte_t pte)
>>  {
>> -#ifdef CONFIG_DEBUG_VM
>> -       WARN_ON(pte_val(*ptep) & _PAGE_PRESENT);
>> -#endif
>> +       /*
>> +        * When handling numa faults, we already have the pte marked
>> +        * _PAGE_PRESENT, but we can be sure that it is not in hpte.
>> +        * Hence we can use set_pte_at for them.
>> +        */
>> +       VM_WARN_ON((pte_val(*ptep) & (_PAGE_PRESENT | _PAGE_USER)) ==
>> +               (_PAGE_PRESENT | _PAGE_USER));
>> +
>
> His is that going to fare with set_pte_at() called for kernel pages ?
>

Yes, we won't capture those errors now. But is there any other debug
check i could use to capture the wrong usage of set_pte_at ?

-aneesh


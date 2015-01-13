Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754054AbbAMWzQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 17:55:16 -0500
Received: from mail-ie0-f176.google.com ([209.85.223.176]:58259 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646AbbAMWzO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 17:55:14 -0500
MIME-Version: 1.0
In-Reply-To: <54B3848A.7040002@suse.com>
References: <1421015741-25110-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	<54B3848A.7040002@suse.com>
Date: Tue, 13 Jan 2015 23:55:11 +0100
Message-ID: <CAKXHbyMqeVSQ2MSTdB3vztqCjgviMJ=pjmXuv3a-U2srh8Qekw@mail.gmail.com>
Subject: Re: [Xen-devel] [PATCH] x86: xen: mmu: Remove unused function
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>, x86@kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, David Vrabel <david.vrabel@citrix.com>,
        "H. Peter Anvin" <hpa@zytor.com>, xen-devel@lists.xenproject.org,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2015-01-12 9:23 GMT+01:00 Jürgen Groß <jgross@suse.com>:
> On 01/11/2015 11:35 PM, Rickard Strandqvist wrote:
>>
>> Remove the function set_pte_mfn() that is not used anywhere.
>>
>> This was partially found by using a static code analysis program called
>> cppcheck.
>
>
> Sorry, you seem not to have checked the newest kernel.
>
> Used by:
>
> xen_do_set_identity_and_remap_chunk()
> xen_remap_memory()
>
> So: Nak.
>
>
> Juergen
>
>
>>
>> Signed-off-by: Rickard Strandqvist
>> <rickard_strandqvist@spectrumdigital.se>
>> ---
>>   arch/x86/xen/mmu.c |    9 ---------
>>   arch/x86/xen/mmu.h |    2 --
>>   2 files changed, 11 deletions(-)
>>
>> diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
>> index a8a1a3d..6959550 100644
>> --- a/arch/x86/xen/mmu.c
>> +++ b/arch/x86/xen/mmu.c
>> @@ -281,15 +281,6 @@ static void xen_set_pmd(pmd_t *ptr, pmd_t val)
>>         xen_set_pmd_hyper(ptr, val);
>>   }
>>
>> -/*
>> - * Associate a virtual page frame with a given physical page frame
>> - * and protection flags for that frame.
>> - */
>> -void set_pte_mfn(unsigned long vaddr, unsigned long mfn, pgprot_t flags)
>> -{
>> -       set_pte_vaddr(vaddr, mfn_pte(mfn, flags));
>> -}
>> -
>>   static bool xen_batched_set_pte(pte_t *ptep, pte_t pteval)
>>   {
>>         struct mmu_update u;
>> diff --git a/arch/x86/xen/mmu.h b/arch/x86/xen/mmu.h
>> index 73809bb..f2dcf79 100644
>> --- a/arch/x86/xen/mmu.h
>> +++ b/arch/x86/xen/mmu.h
>> @@ -13,8 +13,6 @@ enum pt_level {
>>
>>   bool __set_phys_to_machine(unsigned long pfn, unsigned long mfn);
>>
>> -void set_pte_mfn(unsigned long vaddr, unsigned long pfn, pgprot_t flags);
>> -
>>   pte_t xen_ptep_modify_prot_start(struct mm_struct *mm, unsigned long
>> addr, pte_t *ptep);
>>   void  xen_ptep_modify_prot_commit(struct mm_struct *mm, unsigned long
>> addr,
>>                                   pte_t *ptep, pte_t pte);
>>


Hi

Sorry. I start this too long ago, too much has happened in some parts
of the code :(


Kind regards
Rickard Strandqvist

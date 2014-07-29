Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051AbaG2WFP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 18:05:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55679 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751712AbaG2WFO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 18:05:14 -0400
Message-ID: <53D81A90.5000906@redhat.com>
Date: Tue, 29 Jul 2014 18:05:04 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131028 Thunderbird/17.0.10
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: linux-kernel@vger.kernel.org, lszubowi@redhat.com,
        Matt Fleming <matt.fleming@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-efi@vger.kernel.org
Subject: Re: [PATCH] x86, efi: print debug values in Kib not MB
References: <1406653761-3884-1-git-send-email-prarit@redhat.com> <alpine.DEB.2.02.1407291327450.13073@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1407291327450.13073@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 07/29/2014 04:29 PM, David Rientjes wrote:
> On Tue, 29 Jul 2014, Prarit Bhargava wrote:
> 
>> diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
>> index 87fc96b..3875090 100644
>> --- a/arch/x86/platform/efi/efi.c
>> +++ b/arch/x86/platform/efi/efi.c
>> @@ -384,10 +384,10 @@ static void __init print_efi_memmap(void)
>>  	     p < memmap.map_end;
>>  	     p += memmap.desc_size, i++) {
>>  		md = p;
>> -		pr_info("mem%02u: type=%u, attr=0x%llx, range=[0x%016llx-0x%016llx) (%lluMB)\n",
>> +		pr_info("mem%02u: type=%u, attr=0x%llx, range=[0x%016llx-0x%016llx) (%lluKiB)\n",
>>  			i, md->type, md->attribute, md->phys_addr,
>>  			md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT),
>> -			(md->num_pages >> (20 - EFI_PAGE_SHIFT)));
>> +			(md->num_pages << 2));
>>  	}
>>  #endif  /*  EFI_DEBUG  */
>>  }
> 
> If EFI_PAGE_SHIFT were to ever change from its hard-coded 12, then this 
> would be wrong.  Any reason to not simply print EFI_PAGE_SIZE and 
> md->num_pages?

Hmm ... maybe it might be better to print out (md->num_pages * EFI_PAGE_SIZE) >>
10 ?  I'll just double check that in a kernel and repost.

Thanks for the suggestion David :)

P.
> 

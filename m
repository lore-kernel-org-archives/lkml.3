Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756303AbaJ2Jdz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 05:33:55 -0400
Received: from mail-bn1bon0138.outbound.protection.outlook.com ([157.56.111.138]:21424
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756214AbaJ2Jdt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 05:33:49 -0400
X-WSS-ID: 0NE7987-07-U1X-02
X-M-MSG: 
Message-ID: <5450B472.1020301@amd.com>
Date: Wed, 29 Oct 2014 11:33:38 +0200
From: Oded Gabbay <oded.gabbay@amd.com>
Organization: AMD
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Joerg Roedel <jroedel@suse.de>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] mm: export find_extend_vma and handle_mm_fault for
 driver use
References: <1414179271-7621-1-git-send-email-jbarnes@virtuousgeek.org>
	<20141027151327.GE9734@suse.de>	<544E61A1.7090400@amd.com>
 <20141027083552.4af5753f@jbarnes-hsw>
In-Reply-To: <20141027083552.4af5753f@jbarnes-hsw>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.20.0.84]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(479174003)(377454003)(51704005)(189002)(199003)(164054003)(24454002)(120916001)(83506001)(21056001)(36756003)(64126003)(68736004)(4396001)(23746002)(99396003)(20776003)(64706001)(84676001)(65956001)(47776003)(50466002)(65806001)(44976005)(80316001)(110136001)(85852003)(92726001)(46102003)(80022003)(59896002)(92566001)(93886004)(85306004)(31966008)(19580405001)(19580395003)(97736003)(105586002)(76482002)(86362001)(575784001)(87936001)(106466001)(33656002)(102836001)(107046002)(65816999)(101416001)(87266999)(50986999)(54356999)(76176999)(95666004);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR02MB199;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR02MB199;
X-Forefront-PRVS: 03793408BA
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joerg and Jesse,

I tested our amdkfd driver with your patches applied (kernel 3.17.1).
I run OpenCL tests, Aparapi/Sumatra (Java) and OpenMP

All tests passed and I didn't see any kernel error messages.

So:

Tested-by: Oded Gabbay <oded.gabbay@amd.com>

Oded

On 10/27/2014 05:35 PM, Jesse Barnes wrote:

Thanks, I have no way of testing this, but I'm hopeful. :)

Jesse

On Mon, 27 Oct 2014 17:15:45 +0200
Oded Gabbay <oded.gabbay@amd.com> wrote:

> Sure, no problem
>
>       Oded
>
> On 10/27/2014 05:13 PM, Joerg Roedel wrote:
>
> Hi Oded,
>
> can you please test these patches with the KFD driver and make sure
> nothing breaks for you? I really like this improvement and it would be
> great to send it upstream for v3.19.
>
> Thanks,
>
> 	Joerg
>
> On Fri, Oct 24, 2014 at 12:34:30PM -0700, Jesse Barnes wrote:
>
>> This lets drivers like the AMD IOMMUv2 driver handle faults a bit more
>> simply, rather than doing tricks with page refs and get_user_pages().
>>
>> Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
>> ---
>>    mm/memory.c | 1 +
>>    mm/mmap.c   | 2 ++
>>    2 files changed, 3 insertions(+)
>>
>> diff --git a/mm/memory.c b/mm/memory.c
>> index 1cc6bfb..969ff0c 100644
>> --- a/mm/memory.c
>> +++ b/mm/memory.c
>> @@ -3378,6 +3378,7 @@ int handle_mm_fault(struct mm_struct *mm, struct vm_area_struct *vma,
>>    
>>    	return ret;
>>    }
>> +EXPORT_SYMBOL_GPL(handle_mm_fault);
>>    
>>    #ifndef __PAGETABLE_PUD_FOLDED
>>    /*
>> diff --git a/mm/mmap.c b/mm/mmap.c
>> index 7f85520..2ee7971 100644
>> --- a/mm/mmap.c
>> +++ b/mm/mmap.c
>> @@ -2359,6 +2359,8 @@ find_extend_vma(struct mm_struct *mm, unsigned long addr)
>>    }
>>    #endif
>>    
>> +EXPORT_SYMBOL_GPL(find_extend_vma);
>> +
>>    /*
>>     * Ok - we have the memory areas we should free on the vma list,
>>     * so release them, and do the vma updates.
>> -- 
>> 1.9.1



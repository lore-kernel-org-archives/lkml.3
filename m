Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752142AbaJ0Phb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 11:37:31 -0400
Received: from mail-by2on0132.outbound.protection.outlook.com ([207.46.100.132]:26262
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750873AbaJ0Ph3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 11:37:29 -0400
X-WSS-ID: 0NE40QC-07-5Q3-02
X-M-MSG: 
Message-ID: <544E66B0.6030300@amd.com>
Date: Mon, 27 Oct 2014 17:37:20 +0200
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
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(164054003)(199003)(189002)(24454002)(377454003)(479174003)(51704005)(65956001)(87936001)(4396001)(20776003)(47776003)(76482002)(65806001)(68736004)(23746002)(36756003)(99396003)(95666004)(106466001)(120916001)(44976005)(107046002)(105586002)(19580405001)(64706001)(31966008)(85852003)(97736003)(92726001)(50466002)(93886004)(110136001)(54356999)(87266999)(76176999)(85306004)(50986999)(92566001)(101416001)(575784001)(33656002)(102836001)(19580395003)(86362001)(80316001)(84676001)(46102003)(21056001)(59896002)(80022003)(83506001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR02MB203;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR02MB203;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0377802854
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Buy Kaveri ;)

I'm sure Intel will be happy to contribute some $$$ to AMD ;)

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



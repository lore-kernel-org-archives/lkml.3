Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756288Ab3BFIbR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 03:31:17 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:27446 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751754Ab3BFIbO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 03:31:14 -0500
X-IronPort-AV: E=Sophos;i="4.84,614,1355068800"; 
   d="scan'208";a="6696050"
Message-ID: <511214A3.6060201@cn.fujitsu.com>
Date: Wed, 06 Feb 2013 16:30:27 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Shuah Khan <shuah.khan@hp.com>, Andrew Morton <akpm@linux-foundation.org>,
        tglx@linutronix.de, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, yinghai@kernel.org,
        wency@cn.fujitsu.com, linux-kernel@vger.kernel.org, x86@kernel.org,
        shuahkhan@gmail.com
Subject: Re: [PATCH linux-next] x86/mm: Fix compile warning in remove_pagetable()
References: <1360119136.8356.4.camel@lorien2> <alpine.DEB.2.02.1302060017410.6630@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1302060017410.6630@chino.kir.corp.google.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/06 16:29:52,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/06 16:29:53,
	Serialize complete at 2013/02/06 16:29:53
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06/2013 04:27 PM, David Rientjes wrote:
> On Tue, 5 Feb 2013, Shuah Khan wrote:
>
>> diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
>> index 67bad4b..ed78400 100644
>> --- a/arch/x86/mm/init_64.c
>> +++ b/arch/x86/mm/init_64.c
>> @@ -987,7 +987,7 @@ remove_pud_table(pud_t *pud_start, unsigned long addr, unsigned long end,
>>   static void __meminit
>>   remove_pagetable(unsigned long start, unsigned long end, bool direct)
>>   {
>> -	unsigned long next;
>> +	unsigned long next = pgd_addr_end(start, end);
>>   	pgd_t *pgd;
>>   	pud_t *pud;
>>   	bool pgd_changed = false;
>
> This isn't enough, there's a potential for an infinite loop if
> !pgd_present() is ever true in the iteration since "next" remains
> constant.  Theoretical, maybe.
>
> I think it's better to just set next before checking for !pgd_present() in
> the iteration so it's clear what's happening.

Yes, Andrew's patch just fixed it like this. :)

Thanks. :)

> Or, even better, change
> this into the standard do-while loop that everything else uses.
>


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751565AbaLOHEj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 02:04:39 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:37515 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792AbaLOHEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 02:04:37 -0500
Message-ID: <548E87CD.5040008@linux.vnet.ibm.com>
Date: Mon, 15 Dec 2014 12:33:41 +0530
From: Shreyas B Prabhu <shreyas@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Michael Ellerman <mpe@ellerman.id.au>
CC: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Paul Mackerras <paulus@samba.org>
Subject: Re: [v4,4/4] powernv: powerpc: Add winkle support for offline cpus
References: <20141214100600.3446B140119@ozlabs.org> <548D7A0E.2060107@linux.vnet.ibm.com> <1418601701.19970.4.camel@ellerman.id.au>
In-Reply-To: <1418601701.19970.4.camel@ellerman.id.au>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14121507-0029-0000-0000-000000D11E01
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Monday 15 December 2014 05:31 AM, Michael Ellerman wrote:
> On Sun, 2014-12-14 at 17:22 +0530, Shreyas B Prabhu wrote:
>> On Sunday 14 December 2014 03:35 PM, Michael Ellerman wrote:
>>>> diff --git a/arch/powerpc/platforms/powernv/subcore.h b/arch/powerpc/platforms/powernv/subcore.h
>>>> index 148abc9..604eb40 100644
>>>> --- a/arch/powerpc/platforms/powernv/subcore.h
>>>> +++ b/arch/powerpc/platforms/powernv/subcore.h
>>>> @@ -15,4 +15,5 @@
>>>>  
>>>>  #ifndef __ASSEMBLY__
>>>>  void split_core_secondary_loop(u8 *state);
>>>> +extern void update_subcore_sibling_mask(void);
>>>>  #endif
>>>
>>> subcore.c isn't built for CONFIG_SMP=n, resulting in:
>>>
>>>   setup.c:(.init.text+0x34b0): undefined reference to `.update_subcore_sibling_mask'
>>>
>>> I needed to add:
>>>
>>> +#else
>>> +static inline void update_subcore_sibling_mask(void) { };
>>> +#endif /* CONFIG_SMP */
> 
>> Sorry I missed that.
> 
> No worries.
> 
> Can you please do a quick test with a SMP=n kernel.
> 
> It looks like it should work, but it would be good to test.
> 
I successfully tested SMP=n kernel with your next branch.

Thanks,
Shreyas


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415AbaLNLwz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 06:52:55 -0500
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:40955 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752762AbaLNLwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 06:52:53 -0500
Message-ID: <548D7A0E.2060107@linux.vnet.ibm.com>
Date: Sun, 14 Dec 2014 17:22:46 +0530
From: Shreyas B Prabhu <shreyas@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Michael Ellerman <mpe@ellerman.id.au>, linux-kernel@vger.kernel.org
CC: linuxppc-dev@lists.ozlabs.org, Paul Mackerras <paulus@samba.org>
Subject: Re: [v4,4/4] powernv: powerpc: Add winkle support for offline cpus
References: <20141214100600.3446B140119@ozlabs.org>
In-Reply-To: <20141214100600.3446B140119@ozlabs.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14121411-0013-0000-0000-000002C769DF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sunday 14 December 2014 03:35 PM, Michael Ellerman wrote:
> On Tue, 2014-09-12 at 18:56:53 UTC, "Shreyas B. Prabhu" wrote:
>> Winkle is a deep idle state supported in power8 chips. A core enters
>> winkle when all the threads of the core enter winkle. In this state
>> power supply to the entire chiplet i.e core, private L2 and private L3
>> is turned off. As a result it gives higher powersavings compared to
>> sleep.
> ...
> 
>> diff --git a/arch/powerpc/platforms/powernv/subcore.h b/arch/powerpc/platforms/powernv/subcore.h
>> index 148abc9..604eb40 100644
>> --- a/arch/powerpc/platforms/powernv/subcore.h
>> +++ b/arch/powerpc/platforms/powernv/subcore.h
>> @@ -15,4 +15,5 @@
>>  
>>  #ifndef __ASSEMBLY__
>>  void split_core_secondary_loop(u8 *state);
>> +extern void update_subcore_sibling_mask(void);
>>  #endif
> 
> subcore.c isn't built for CONFIG_SMP=n, resulting in:
> 
>   setup.c:(.init.text+0x34b0): undefined reference to `.update_subcore_sibling_mask'
> 
> I needed to add:
> 
> +#else
> +static inline void update_subcore_sibling_mask(void) { };
> +#endif /* CONFIG_SMP */
> 
> 
Sorry I missed that.

> I also got quite a few conflicts, with this and the previous patch, mainly in
> the paca and asm-offsets. Please check I resolved them correctly:
> 
>   https://github.com/mpe/powerpc-merge/commits/test
>
This looks fine to me.

Thanks,
Shreyas
> cheers
> 


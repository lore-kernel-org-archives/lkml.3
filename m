Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965274AbaFRIrK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 04:47:10 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:39746 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965156AbaFRIrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 04:47:06 -0400
Message-ID: <53A15201.7060404@hitachi.com>
Date: Wed, 18 Jun 2014 17:46:57 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Michael Ellerman <michael@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "Suzuki K. Poulose" <suzuki@in.ibm.com>,
        Tony Luck <tony.luck@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>, linux-ia64@vger.kernel.org,
        sparse@chrisli.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-tip-commits@vger.kernel.org, anil.s.keshavamurthy@intel.com,
        Ingo Molnar <mingo@kernel.org>, Fenghua Yu <fenghua.yu@intel.com>,
        Arnd Bergmann <arnd@arndb.de>, Rusty Russell <rusty@rustcorp.com.au>,
        Chris Wright <chrisw@sous-sol.org>, yrl.pp-manager.tt@hitachi.com,
        akataria@vmware.com, Tony Luck <tony.luck@intel.com>,
        Kevin Hao <haokexin@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>, rdunlap@infradead.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, dl9pf@gmx.de,
        Andrew Morton <akpm@linux-foundation.org>,
        linuxppc-dev@lists.ozlabs.org, "David S. Miller" <davem@davemloft.net>
Subject: Re: Re: [RFT PATCH -next v3] [BUGFIX] kprobes: Fix "Failed to
 find blacklist" error on ia64 and ppc64
References: <5387F150.5000307@hitachi.com>  <20140530031838.17427.75896.stgit@ltc230.yrl.intra.hitachi.co.jp>  <539161D6.7020508@hitachi.com> <1403078179.32307.7.camel@concordia>
In-Reply-To: <1403078179.32307.7.camel@concordia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/06/18 16:56), Michael Ellerman wrote:
> On Fri, 2014-06-06 at 15:38 +0900, Masami Hiramatsu wrote:
>> Ping?
>>
>> I guess this should go to 3.16 branch, shouldn't it?
> 
>>> diff --git a/arch/powerpc/include/asm/types.h b/arch/powerpc/include/asm/types.h
>>> index bfb6ded..8b89d65 100644
>>> --- a/arch/powerpc/include/asm/types.h
>>> +++ b/arch/powerpc/include/asm/types.h
>>> @@ -25,6 +25,17 @@ typedef struct {
>>>  	unsigned long env;
>>>  } func_descr_t;
>>>  
>>> +#if defined(CONFIG_PPC64) && (!defined(_CALL_ELF) || _CALL_ELF == 1)
>>> +/*
>>> + * On PPC64 ABIv1 the function pointer actually points to the
>>> + * function's descriptor. The first entry in the descriptor is the
>>> + * address of the function text.
>>> + */
>>> +#define function_entry(fn)	(((func_descr_t *)(fn))->entry)
>>> +#else
>>> +#define function_entry(fn)	((unsigned long)(fn))
>>> +#endif
> 
> We already have ppc_function_entry(), can't you use that?

I'd like to ask you whether the address which ppc_function_entry() returns on
PPC ABIv2 is really same address in kallsyms or not.
As you can see, kprobes uses function_entry() to get the actual entry address
where kallsyms knows. I have not much information about that, but it seems that
the "global entry point" is the address which kallsyms knows, isn't it?

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com



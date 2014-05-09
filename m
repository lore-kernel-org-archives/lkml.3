Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754927AbaEIIG4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 04:06:56 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:54516 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062AbaEIIGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 04:06:50 -0400
X-Greylist: delayed 95201 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 May 2014 04:06:49 EDT
Message-ID: <536C8C90.2050601@hitachi.com>
Date: Fri, 09 May 2014 17:06:40 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: ananth@in.ibm.com
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Tony Luck <tony.luck@gmail.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>, linux-ia64@vger.kernel.org,
        sparse@chrisli.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-tip-commits@vger.kernel.org, anil.s.keshavamurthy@intel.com,
        Ingo Molnar <mingo@kernel.org>, Fenghua Yu <fenghua.yu@intel.com>,
        Arnd Bergmann <arnd@arndb.de>, Rusty Russell <rusty@rustcorp.com.au>,
        Chris Wright <chrisw@sous-sol.org>, yrl.pp-manager.tt@hitachi.com,
        akataria@vmware.com, Tony Luck <tony.luck@intel.com>,
        Kevin Hao <haokexin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        rdunlap@infradead.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, dl9pf@gmx.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [RFT PATCH -next ] [BUGFIX] kprobes: Fix "Failed to find blacklist"
 error on ia64 and ppc64
References: <536A16A6.5040709@hitachi.com> <20140507115551.22259.70581.stgit@ltc230.yrl.intra.hitachi.co.jp> <20140508044753.GA13413@in.ibm.com> <536B18B0.9060209@hitachi.com> <20140508061658.GA2384@in.ibm.com>
In-Reply-To: <20140508061658.GA2384@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/05/08 15:16), Ananth N Mavinakayanahalli wrote:
> On Thu, May 08, 2014 at 02:40:00PM +0900, Masami Hiramatsu wrote:
>> (2014/05/08 13:47), Ananth N Mavinakayanahalli wrote:
>>> On Wed, May 07, 2014 at 08:55:51PM +0900, Masami Hiramatsu wrote:
>>>
>>> ...
>>>
>>>> +#if defined(CONFIG_PPC64) && (!defined(_CALL_ELF) || _CALL_ELF == 1)
>>>> +/*
>>>> + * On PPC64 ABIv1 the function pointer actually points to the
>>>> + * function's descriptor. The first entry in the descriptor is the
>>>> + * address of the function text.
>>>> + */
>>>> +#define constant_function_entry(fn)	(((func_descr_t *)(fn))->entry)
>>>> +#else
>>>> +#define constant_function_entry(fn)	((unsigned long)(fn))
>>>> +#endif
>>>> +
>>>>  #endif /* __ASSEMBLY__ */
>>>
>>> Hi Masami,
>>>
>>> You could just use ppc_function_entry() instead.
>>
>> No, I think ppc_function_entry() has two problems (on the latest -next kernel)
>>
>> At first, that is an inlined functions which is not applied in build time.
>> Since the NOKPROBE_SYMBOL() is used outside of any functions as like as
>> EXPORT_SYMBOL(), we can only use preprocessed macros.
>> Next, on PPC64 ABI*v2*, ppc_function_entry() returns local function entry,
>> which seems global function entry + 2 insns. I'm not sure about implementation
>> of the kallsyms on PPC64 ABIv2, but I guess we need global function entry
>> for kallsyms.
> 
> ABIv2 does away with function descriptors and Anton fixed up that
> routine to handle the change (the +2 is an artefact of that).

Hmm, do you mean that the address +2 is the actual entry point?
I'd like to know which address is same as the address shown in /proc/kallsyms.

>> BTW, could you test this patch on the latest -next tree on PPC64 if possible?
> 
> I'll test it, but it may take a bit.

Thanks for your help!

> 
> Ananth
> 
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com



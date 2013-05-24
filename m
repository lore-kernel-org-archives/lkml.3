Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760109Ab3EXI3g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 04:29:36 -0400
Received: from www.meduna.org ([92.240.244.38]:53250 "EHLO meduna.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759437Ab3EXI3d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 04:29:33 -0400
Message-ID: <519F24DD.5060700@meduna.org>
Date: Fri, 24 May 2013 10:29:17 +0200
From: Stanislav Meduna <stano@meduna.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Hai Huang <hhuang@redhat.com>
Subject: Re: [PATCH] mm: fix up a spurious page fault whenever it happens
References: <5195ED8B.7060002@meduna.org>  <1369183168.6828.168.camel@gandalf.local.home>  <519CBB30.3060200@redhat.com>  <CA+55aFxMqvDvcVtLW-yD2PuU_CcjPOC30Zk07Kuk6S25WCzbHQ@mail.gmail.com>  <20130522134111.33a695c5@cuia.bos.redhat.com> <519D08B0.8050707@meduna.org> <1369246316.6828.176.camel@gandalf.local.home> <519D0CAB.7020800@meduna.org> <519D0FF8.5080200@redhat.com> <519D118B.6010306@zytor.com> <519D11BF.5000604@redhat.com> <519DCE2A.4010801@meduna.org> <519E095A.4000105@redhat.com>
In-Reply-To: <519E095A.4000105@redhat.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authenticated-User: stano@meduna.org
X-Authenticator: dovecot_plain
X-Spam-Score: -6.9
X-Spam-Score-Int: -68
X-Exim-Version: 4.72 (build at 25-Oct-2012 18:35:58)
X-Date: 2013-05-24 10:29:24
X-Connected-IP: 95.105.165.4:2502
X-Message-Linecount: 101
X-Body-Linecount: 79
X-Message-Size: 3484
X-Body-Size: 2099
X-Received-Count: 1
X-Recipient-Count: 10
X-Local-Recipient-Count: 10
X-Local-Recipient-Defer-Count: 0
X-Local-Recipient-Fail-Count: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23.05.2013 14:19, Rik van Riel wrote:

>>> static inline void __native_flush_tlb_single(unsigned long addr)
>>> {
>>>          __flush_tlb();
>>> }
> 
>> I will give it some more testing time.
> 
> That is a good idea.

Still no crash, so this one indeed seems to change things.

If I understand it correctly, these patches fix the problem
when it happens and we still don't know why the TLB is stale
in the first place - whether there is (also) a genuine bug
or whether we are hitting some chip errata, right?


For the record the cpuinfo for my present testsystem:

processor       : 0
vendor_id       : AuthenticAMD
cpu family      : 5
model           : 10
model name      : Geode(TM) Integrated Processor by AMD PCS
stepping        : 2
microcode       : 0x88a93d
cpu MHz         : 498.042
cache size      : 128 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu de pse tsc msr cx8 sep pge cmov clflush mmx
                  mmxext 3dnowext 3dnow
bogomips        : 996.08
clflush size    : 32
cache_alignment : 32
address sizes   : 32 bits physical, 32 bits virtual
power management:

and for the Celeron M where I can unfortunately reproduce
it much less often (days to weeks).

processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 13
model name      : Intel(R) Celeron(R) M processor         1.00GHz
stepping        : 8
cpu MHz         : 1000.011
cache size      : 512 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
                  mca cmov clflush dts acpi mmx fxsr sse sse2 ss tm
                  pbe nx bts
bogomips        : 2000.02
clflush size    : 64
cache_alignment : 64
address sizes   : 32 bits physical, 32 bits virtual
power management:


Thanks
-- 
                                           Stano


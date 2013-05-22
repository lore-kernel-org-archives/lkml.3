Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756810Ab3EVSms (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 14:42:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45741 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752265Ab3EVSmr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 14:42:47 -0400
Message-ID: <519D118B.6010306@zytor.com>
Date: Wed, 22 May 2013 11:42:19 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: Stanislav Meduna <stano@meduna.org>, Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Hai Huang <hhuang@redhat.com>
Subject: Re: [PATCH] mm: fix up a spurious page fault whenever it happens
References: <5195ED8B.7060002@meduna.org>  <1369183168.6828.168.camel@gandalf.local.home>  <519CBB30.3060200@redhat.com>  <CA+55aFxMqvDvcVtLW-yD2PuU_CcjPOC30Zk07Kuk6S25WCzbHQ@mail.gmail.com>  <20130522134111.33a695c5@cuia.bos.redhat.com> <519D08B0.8050707@meduna.org> <1369246316.6828.176.camel@gandalf.local.home> <519D0CAB.7020800@meduna.org> <519D0FF8.5080200@redhat.com>
In-Reply-To: <519D0FF8.5080200@redhat.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2013 11:35 AM, Rik van Riel wrote:
> On 05/22/2013 02:21 PM, Stanislav Meduna wrote:
>> On 22.05.2013 20:11, Steven Rostedt wrote:
>>
>>> Did you apply both patches? Without the first one, this one is
>>> meaningless.
>>
>> Sure.
>>
>> BTW, back when I tried to pinpoint it I also tried adding
>>    flush_tlb_page(vma, address)
>> at the beginning of handle_pte_fault, which as I read should
>> be basically the same. It did not not change anything.
> 
> I'm stumped.
> 
> If the Geode knows how to flush single TLB entries, it
> should do that when flush_tlb_page is called.
> 
> If it does not know, it should throw an invalid instruction
> exception, and not quietly complete the instruction without
> doing anything.
> 

Some CPUs have had errata when it comes to flushing large pages that
have been split into small pages by hardware, e.g. due to MTRR
conflicts.  In that case, fragments of the large page may have been left
in the TLB.

Could that explain what you are seeing?

	-hpa


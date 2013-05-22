Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755476Ab3EVSiP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 14:38:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32938 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751181Ab3EVSiN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 14:38:13 -0400
Message-ID: <519D0FF8.5080200@redhat.com>
Date: Wed, 22 May 2013 14:35:36 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Stanislav Meduna <stano@meduna.org>
CC: Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Hai Huang <hhuang@redhat.com>
Subject: Re: [PATCH] mm: fix up a spurious page fault whenever it happens
References: <5195ED8B.7060002@meduna.org>  <1369183168.6828.168.camel@gandalf.local.home>  <519CBB30.3060200@redhat.com>  <CA+55aFxMqvDvcVtLW-yD2PuU_CcjPOC30Zk07Kuk6S25WCzbHQ@mail.gmail.com>  <20130522134111.33a695c5@cuia.bos.redhat.com> <519D08B0.8050707@meduna.org> <1369246316.6828.176.camel@gandalf.local.home> <519D0CAB.7020800@meduna.org>
In-Reply-To: <519D0CAB.7020800@meduna.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2013 02:21 PM, Stanislav Meduna wrote:
> On 22.05.2013 20:11, Steven Rostedt wrote:
>
>> Did you apply both patches? Without the first one, this one is
>> meaningless.
>
> Sure.
>
> BTW, back when I tried to pinpoint it I also tried adding
>    flush_tlb_page(vma, address)
> at the beginning of handle_pte_fault, which as I read should
> be basically the same. It did not not change anything.

I'm stumped.

If the Geode knows how to flush single TLB entries, it
should do that when flush_tlb_page is called.

If it does not know, it should throw an invalid instruction
exception, and not quietly complete the instruction without
doing anything.


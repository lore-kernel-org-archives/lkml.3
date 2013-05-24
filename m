Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760365Ab3EXK2j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 06:28:39 -0400
Received: from www.meduna.org ([92.240.244.38]:47783 "EHLO meduna.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760156Ab3EXK2h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 06:28:37 -0400
Message-ID: <519F40BB.1050504@meduna.org>
Date: Fri, 24 May 2013 12:28:11 +0200
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
References: <5195ED8B.7060002@meduna.org>  <1369183168.6828.168.camel@gandalf.local.home>  <519CBB30.3060200@redhat.com>  <CA+55aFxMqvDvcVtLW-yD2PuU_CcjPOC30Zk07Kuk6S25WCzbHQ@mail.gmail.com>  <20130522134111.33a695c5@cuia.bos.redhat.com> <519D08B0.8050707@meduna.org> <1369246316.6828.176.camel@gandalf.local.home> <519D0CAB.7020800@meduna.org> <519D0FF8.5080200@redhat.com> <519D118B.6010306@zytor.com> <519D11BF.5000604@redhat.com> <519DCE2A.4010801@meduna.org> <519E095A.4000105@redhat.com> <519F24DD.5060700@meduna.org>
In-Reply-To: <519F24DD.5060700@meduna.org>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authenticated-User: stano@meduna.org
X-Authenticator: dovecot_plain
X-Spam-Score: -6.9
X-Spam-Score-Int: -68
X-Exim-Version: 4.72 (build at 25-Oct-2012 18:35:58)
X-Date: 2013-05-24 12:28:29
X-Connected-IP: 95.105.165.4:3590
X-Message-Linecount: 43
X-Body-Linecount: 21
X-Message-Size: 1965
X-Body-Size: 550
X-Received-Count: 1
X-Recipient-Count: 10
X-Local-Recipient-Count: 10
X-Local-Recipient-Defer-Count: 0
X-Local-Recipient-Fail-Count: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24.05.2013 10:29, Stanislav Meduna wrote:

>>>> static inline void __native_flush_tlb_single(unsigned long addr)
>>>> {
>>>>          __flush_tlb();
>>>> }
>>
>>> I will give it some more testing time.
>>
>> That is a good idea.
> 
> Still no crash, so this one indeed seems to change things.

Take that back, now crashed as well, it just took longer.
min_flt of two threads jumped from zero at 1848 (lower prio)
and 735993 (higher prio, preempted the first one) respectively,
1.7 seconds hang.

-- 
                                        Stano


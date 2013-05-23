Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754240Ab3EWIH2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 04:07:28 -0400
Received: from www.meduna.org ([92.240.244.38]:49231 "EHLO meduna.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751018Ab3EWIHW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 04:07:22 -0400
Message-ID: <519DCE2A.4010801@meduna.org>
Date: Thu, 23 May 2013 10:07:06 +0200
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
References: <5195ED8B.7060002@meduna.org>  <1369183168.6828.168.camel@gandalf.local.home>  <519CBB30.3060200@redhat.com>  <CA+55aFxMqvDvcVtLW-yD2PuU_CcjPOC30Zk07Kuk6S25WCzbHQ@mail.gmail.com>  <20130522134111.33a695c5@cuia.bos.redhat.com> <519D08B0.8050707@meduna.org> <1369246316.6828.176.camel@gandalf.local.home> <519D0CAB.7020800@meduna.org> <519D0FF8.5080200@redhat.com> <519D118B.6010306@zytor.com> <519D11BF.5000604@redhat.com>
In-Reply-To: <519D11BF.5000604@redhat.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authenticated-User: stano@meduna.org
X-Authenticator: dovecot_plain
X-Spam-Score: -6.9
X-Spam-Score-Int: -68
X-Exim-Version: 4.72 (build at 25-Oct-2012 18:35:58)
X-Date: 2013-05-23 10:07:12
X-Connected-IP: 95.105.165.4:1491
X-Message-Linecount: 56
X-Body-Linecount: 34
X-Message-Size: 2418
X-Body-Size: 1093
X-Received-Count: 1
X-Recipient-Count: 10
X-Local-Recipient-Count: 10
X-Local-Recipient-Defer-Count: 0
X-Local-Recipient-Fail-Count: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22.05.2013 20:43, Rik van Riel wrote:

>> Some CPUs have had errata when it comes to flushing large pages that
>> have been split into small pages by hardware, e.g. due to MTRR
>> conflicts.  In that case, fragments of the large page may have been left
>> in the TLB.

Can I somehow find if this is the case? The memory mapping
for the failing process has two regions slightly larger than
4 MB - code and heap.

The process also does not access any funny memory regions
from userspace - it is basically networking (both TCP/IP
and raw sockets) and crunching of the data received.
No mmapped devices or something like that.

> static inline void __native_flush_tlb_single(unsigned long addr)
> {
>         __flush_tlb();
> }
> 
> This on top of the other two patches.

It did not crash overnight, but it also does not show any
minor fault counted for the threads, so I'm afraid the situation
just did not happen - there should be at least one visible in
the ps -o min_flt output, right?

I will give it some more testing time.

Thanks
-- 
                                             Stano


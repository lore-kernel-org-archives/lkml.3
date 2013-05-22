Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756930Ab3EVSrO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 14:47:14 -0400
Received: from www.meduna.org ([92.240.244.38]:43027 "EHLO meduna.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756803Ab3EVSrL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 14:47:11 -0400
Message-ID: <519D12A5.6090804@meduna.org>
Date: Wed, 22 May 2013 20:47:01 +0200
From: Stanislav Meduna <stano@meduna.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Hai Huang <hhuang@redhat.com>
Subject: Re: [PATCH] mm: fix up a spurious page fault whenever it happens
References: <5195ED8B.7060002@meduna.org>  <1369183168.6828.168.camel@gandalf.local.home>  <519CBB30.3060200@redhat.com>  <CA+55aFxMqvDvcVtLW-yD2PuU_CcjPOC30Zk07Kuk6S25WCzbHQ@mail.gmail.com>  <20130522134111.33a695c5@cuia.bos.redhat.com> <519D08B0.8050707@meduna.org> <1369246316.6828.176.camel@gandalf.local.home> <519D0CAB.7020800@meduna.org> <519D0FF8.5080200@redhat.com>
In-Reply-To: <519D0FF8.5080200@redhat.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authenticated-User: stano@meduna.org
X-Authenticator: dovecot_plain
X-Spam-Score: -6.9
X-Spam-Score-Int: -68
X-Exim-Version: 4.72 (build at 25-Oct-2012 18:35:58)
X-Date: 2013-05-22 20:47:07
X-Connected-IP: 95.105.165.4:4815
X-Message-Linecount: 51
X-Body-Linecount: 31
X-Message-Size: 2075
X-Body-Size: 812
X-Received-Count: 1
X-Recipient-Count: 10
X-Local-Recipient-Count: 10
X-Local-Recipient-Defer-Count: 0
X-Local-Recipient-Fail-Count: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22.05.2013 20:35, Rik van Riel wrote:

> I'm stumped.
> 
> If the Geode knows how to flush single TLB entries, it
> should do that when flush_tlb_page is called.
> 
> If it does not know, it should throw an invalid instruction
> exception, and not quietly complete the instruction without
> doing anything.

Could it be that the problem is not stale TLB, but a page directory
that is somehow invalid, e.g. belonging to the previous modprobe
(or whatever) instead of the running process?

My patch does load_cr3(next->pgd); so it explicitely loads something
there.

> In other words, make the code look like this, for testing:
>
> static inline void __native_flush_tlb_single(unsigned long addr)
> {
>         __flush_tlb();
> }

Yup, will try it.

Thanks
-- 
                                           Stano


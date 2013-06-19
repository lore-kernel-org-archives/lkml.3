Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756571Ab3FSHgz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 03:36:55 -0400
Received: from www.meduna.org ([92.240.244.38]:44467 "EHLO meduna.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755576Ab3FSHgy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 03:36:54 -0400
Message-ID: <51C15F87.20100@meduna.org>
Date: Wed, 19 Jun 2013 09:36:39 +0200
From: Stanislav Meduna <stano@meduna.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Rik van Riel <riel@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Hai Huang <hhuang@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] mm: fix up a spurious page fault whenever it happens
References: <5195ED8B.7060002@meduna.org> <1369183168.6828.168.camel@gandalf.local.home> <519CBB30.3060200@redhat.com> <CA+55aFxMqvDvcVtLW-yD2PuU_CcjPOC30Zk07Kuk6S25WCzbHQ@mail.gmail.com> <20130522134111.33a695c5@cuia.bos.redhat.com> <519D08B0.8050707@meduna.org> <1369246316.6828.176.camel@gandalf.local.home> <519D0CAB.7020800@meduna.org> <519D0FF8.5080200@redhat.com> <519D118B.6010306@zytor.com> <519D11BF.5000604@redhat.com> <519DCE2A.4010801@meduna.org> <519E095A.4000105@redhat.com> <519F24DD.5060700@meduna.org> <519F65DB.2020305@redhat.com> <51BE2F5C.8070408@meduna.org> <51C0B177.2000006@meduna.org> <CA+55aFwm-a0O-jvznYpXM4Ctf_jex+gcgELq_pqXL38Y6X-JPg@mail.gmail.com>
In-Reply-To: <CA+55aFwm-a0O-jvznYpXM4Ctf_jex+gcgELq_pqXL38Y6X-JPg@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authenticated-User: stano@meduna.org
X-Authenticator: dovecot_plain
X-Spam-Score: -6.9
X-Spam-Score-Int: -68
X-Exim-Version: 4.72 (build at 25-Oct-2012 18:35:58)
X-Date: 2013-06-19 09:36:45
X-Connected-IP: 95.105.165.4:29573
X-Message-Linecount: 47
X-Body-Linecount: 27
X-Message-Size: 2499
X-Body-Size: 856
X-Received-Count: 1
X-Recipient-Count: 11
X-Local-Recipient-Count: 11
X-Local-Recipient-Defer-Count: 0
X-Local-Recipient-Fail-Count: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19.06.2013 07:20, Linus Torvalds wrote:

>> No crash in 2 days running with preempt none...
> 
> Is this UP?

Yes it is.

> There's the fast_tlb race that Peter fixed in commit 29eb77825cc7
> ("arch, mm: Remove tlb_fast_mode()"). I'm not seeing how it would
> cause infinite TLB faults, but it definitely causes potentially
> incoherent TLB contents. And afaik it only happens with
> CONFIG_PREEMPT, and on UP systems. Which sounds like it might match
> your setup...

Oh, thank you for the pointer, this indeed looks interesting.

Unfortunately the patch massively does not apply to 3.4 which
I am using and I know too little what all is involved here
to backport it. I will test it when (if) it gets to the 3.4(-rt)
(or when I find some spare time to play with the newer kernel
on that system).

Thanks
-- 
                                     Stano


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755867Ab3FSFUk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 01:20:40 -0400
Received: from mail-vb0-f44.google.com ([209.85.212.44]:39801 "EHLO
	mail-vb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089Ab3FSFUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 01:20:38 -0400
MIME-Version: 1.0
In-Reply-To: <51C0B177.2000006@meduna.org>
References: <5195ED8B.7060002@meduna.org>
	<1369183168.6828.168.camel@gandalf.local.home>
	<519CBB30.3060200@redhat.com>
	<CA+55aFxMqvDvcVtLW-yD2PuU_CcjPOC30Zk07Kuk6S25WCzbHQ@mail.gmail.com>
	<20130522134111.33a695c5@cuia.bos.redhat.com>
	<519D08B0.8050707@meduna.org>
	<1369246316.6828.176.camel@gandalf.local.home>
	<519D0CAB.7020800@meduna.org>
	<519D0FF8.5080200@redhat.com>
	<519D118B.6010306@zytor.com>
	<519D11BF.5000604@redhat.com>
	<519DCE2A.4010801@meduna.org>
	<519E095A.4000105@redhat.com>
	<519F24DD.5060700@meduna.org>
	<519F65DB.2020305@redhat.com>
	<51BE2F5C.8070408@meduna.org>
	<51C0B177.2000006@meduna.org>
Date: Tue, 18 Jun 2013 19:20:37 -1000
X-Google-Sender-Auth: uS3oz_euJYb0pk6mwQD9b58jonI
Message-ID: <CA+55aFwm-a0O-jvznYpXM4Ctf_jex+gcgELq_pqXL38Y6X-JPg@mail.gmail.com>
Subject: Re: [PATCH] mm: fix up a spurious page fault whenever it happens
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Stanislav Meduna <stano@meduna.org>
Cc: Rik van Riel <riel@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Hai Huang <hhuang@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 18, 2013 at 9:13 AM, Stanislav Meduna <stano@meduna.org> wrote:
>
> No crash in 2 days running with preempt none...

Is this UP?

There's the fast_tlb race that Peter fixed in commit 29eb77825cc7
("arch, mm: Remove tlb_fast_mode()"). I'm not seeing how it would
cause infinite TLB faults, but it definitely causes potentially
incoherent TLB contents. And afaik it only happens with
CONFIG_PREEMPT, and on UP systems. Which sounds like it might match
your setup...

                Linus

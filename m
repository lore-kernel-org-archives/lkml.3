Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426Ab3CXL4E (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 07:56:04 -0400
Received: from mail.skyhub.de ([78.46.96.112]:50729 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753379Ab3CXLz7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 07:55:59 -0400
Date: Sun, 24 Mar 2013 12:55:56 +0100
From: Borislav Petkov <bp@alien8.de>
To: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: BUG: using smp_processor_id() in preemptible [00000000] code:
 asm/8267
Message-ID: <20130324115556.GA4866@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Ingo Molnar <mingo@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@infradead.org>,
	lkml <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

so I was tracing a small .c program like so:

$ ./perf record ~/test/asm

and here's what got spewed in dmesg. Kernel is plain -rc4. Any pending
fixes in tip I should try?

[ 3700.194208] BUG: using smp_processor_id() in preemptible [00000000] code: asm/8333
[ 3700.194226] caller is perf_event_task_ctx+0x55/0x140
[ 3700.194235] Pid: 8333, comm: asm Not tainted 3.9.0-rc4 #1
[ 3700.194243] Call Trace:
[ 3700.194261]  [<ffffffff812b4182>] debug_smp_processor_id+0xd2/0xf0
[ 3700.194279]  [<ffffffff810e5155>] perf_event_task_ctx+0x55/0x140
[ 3700.194296]  [<ffffffff810e5412>] perf_event_task+0x1d2/0x3c0
[ 3700.194308]  [<ffffffff810e52ad>] ? perf_event_task+0x6d/0x3c0
[ 3700.194324]  [<ffffffff810e99a6>] perf_event_exit_task+0x166/0x250
[ 3700.194333]  [<ffffffff810414be>] do_exit+0x27e/0xb20
[ 3700.194340]  [<ffffffff8159ac63>] ? error_sti+0x5/0x6
[ 3700.194349]  [<ffffffff8159a80d>] ? retint_swapgs+0xe/0x13
[ 3700.194358]  [<ffffffff81041f1c>] do_group_exit+0x4c/0xc0
[ 3700.194365]  [<ffffffff81041fa7>] sys_exit_group+0x17/0x20
[ 3700.194373]  [<ffffffff8159b306>] system_call_fastpath+0x1a/0x1f

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760086Ab3CGX7W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 18:59:22 -0500
Received: from mail-la0-f43.google.com ([209.85.215.43]:51457 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758814Ab3CGX7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 18:59:20 -0500
MIME-Version: 1.0
In-Reply-To: <CABVzNXq=LB87+oSvMo=TLumS6M6qnaA+Wtg5TRO+banNbo9-iw@mail.gmail.com>
References: <1358901294-3269-1-git-send-email-fweisbec@gmail.com>
	<CABVzNXq=LB87+oSvMo=TLumS6M6qnaA+Wtg5TRO+banNbo9-iw@mail.gmail.com>
Date: Fri, 8 Mar 2013 00:59:18 +0100
Message-ID: <CAFTL4hyN6j5Ci4uRrNQd_A-c2o3dSHH4kA37SajirzeU3St1XA@mail.gmail.com>
Subject: Re: [ANNOUNCE] 3.8-rc4-nohz3
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Hakan Akkan <hakanakkan@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>, Ingo Molnar <mingo@kernel.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/1/23 Hakan Akkan <hakanakkan@gmail.com>:
> Hi,
>
> This WARN_ON is triggered for every full nohz CPU in the system during
> AP boot in a 16 core machine:

Yeah it happens because we are enqueuing a timer to an offline CPU.
I'm trying to fix it, tell me if you still see the warning on the next
version.

Thanks!

>
> [    0.336895] ------------[ cut here ]------------
> [    0.341508] WARNING: at arch/x86/kernel/smp.c:123
> native_smp_send_reschedule+0x4f/0x60()
> [    0.349578] Hardware name: X8DTG-D
> [    0.315066] smpboot: Booting Node   0, Processors  #1
> [    0.352978] Modules linked in:
> [    0.356233] Pid: 0, comm: swapper/1 Not tainted 3.8.0-rc4+ #3
> [    0.361959] Call Trace:
> [    0.364404]  [<ffffffff8103c4fa>] warn_slowpath_common+0x7a/0xb0
> [    0.370399]  [<ffffffff8103c545>] warn_slowpath_null+0x15/0x20
> [    0.376213]  [<ffffffff8102435f>] native_smp_send_reschedule+0x4f/0x60
> [    0.382723]  [<ffffffff8106b328>] wake_up_nohz_cpu+0x78/0x80
> [    0.388374]  [<ffffffff8104c33a>] add_timer_on+0x8a/0xf0
> [    0.393679]  [<ffffffff8101c6f4>] mce_start_timer+0x64/0x70
> [    0.399241]  [<ffffffff8101c752>] __mcheck_cpu_init_timer+0x52/0x60
> [    0.405490]  [<ffffffff817d804a>] mcheck_cpu_init+0x360/0x3d9
> [    0.411226]  [<ffffffff817d6160>] identify_cpu+0x39d/0x3ba
> [    0.416696]  [<ffffffff817d6193>] identify_secondary_cpu+0x16/0x1d
> [    0.422855]  [<ffffffff817d9730>] smp_store_cpu_info+0x38/0x3a
> [    0.428672]  [<ffffffff817d981a>] start_secondary+0xe8/0x192
> [    0.434317] ---[ end trace 17bfa0d8291c432e ]---

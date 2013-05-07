Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757711Ab3EGH0A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 03:26:00 -0400
Received: from mx4-phx2.redhat.com ([209.132.183.25]:38533 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756992Ab3EGHZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 03:25:58 -0400
Date: Tue, 7 May 2013 03:25:58 -0400 (EDT)
From: CAI Qian <caiqian@redhat.com>
To: LKML <linux-kernel@vger.kernel.org>
Message-ID: <1732336275.8141054.1367911558572.JavaMail.root@redhat.com>
In-Reply-To: <148688218.8139723.1367911491024.JavaMail.root@redhat.com>
Subject: 3.9.0: WARNING: at drivers/base/core.c:575
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.82.12]
X-Mailer: Zimbra 8.0.3_GA_5664 (ZimbraWebClient - FF20 (Linux)/8.0.3_GA_5664)
Thread-Topic: 3.9.0: WARNING: at drivers/base/core.c:575
Thread-Index: yaJVbnaITfbi0DUdIA/mtdAi+jaxtQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Never saw any of those messages were floating in any of the RC testing, but
now happened in 3.9 GA on Power 7 systems.

[    0.329753] EEH: devices created
[    0.340203] atomic64 test passed
[    0.340407] NET: Registered protocol family 16
[    0.340457] EEH: No capable adapters found
[    0.340609] IBM eBus Device Driver
[    0.358825] Write permission without 'store'
[    0.358852] ------------[ cut here ]------------
[    0.358859] WARNING: at drivers/base/core.c:575
[    0.358866] Modules linked in:
[    0.358877] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.9.0+ #1
[    0.358887] task: c0000003f8bc0000 ti: c0000003f8c00000 task.ti: c0000003f8c00000
[    0.358897] NIP: c0000000004a7f44 LR: c0000000004a7f40 CTR: 0000000001766760
[    0.358906] REGS: c0000003f8c03780 TRAP: 0700   Not tainted  (3.9.0+)
[    0.358914] MSR: 8000000000029032 <SF,EE,ME,IR,DR,RI>  CR: 28139d24  XER: 00000001
[    0.358939] SOFTE: 1
[    0.358944] CFAR: c00000000074427c
[    0.358950] 
GPR00: c0000000004a7f40 c0000003f8c03a00 c000000001117e50 0000000000000020 
GPR04: 0000000000000000 0000000000000000 00000000160c9615 0000000000000000 
GPR08: c000000001064af0 0000000000000000 0000000000000000 0000000000003fef 
GPR12: 0000000028139d22 c000000007f00000 c00000000000bb30 0000000000000000 
GPR16: 0000000000000000 0000000000000000 c000000000ff1c78 0000000000000001 
GPR20: 0000000000000000 0000000000000000 0000000000000000 c00000000117eb08 
GPR24: 00000000000000a6 c000000000af0028 0000000000000000 c000000000ff21a0 
GPR28: 0000000000000002 c000000001500030 c0000000011b8200 c000000001500030 
[    0.359070] NIP [c0000000004a7f44] .device_create_file+0xa4/0xe0
[    0.359080] LR [c0000000004a7f40] .device_create_file+0xa0/0xe0
[    0.359088] Call Trace:
[    0.359095] [c0000003f8c03a00] [c0000000004a7f40] .device_create_file+0xa0/0xe0 (unreliable)
[    0.359112] [c0000003f8c03a90] [c00000000074daf8] .register_cpu_online+0x21c/0x284
[    0.359126] [c0000003f8c03b30] [c000000000a78308] .topology_init+0x130/0x200
[    0.359138] [c0000003f8c03c10] [c00000000000b4d4] .do_one_initcall+0x144/0x1f0
[    0.359150] [c0000003f8c03cd0] [c000000000a746a8] .kernel_init_freeable+0x23c/0x32c
[    0.359163] [c0000003f8c03db0] [c00000000000bb4c] .kernel_init+0x1c/0x130
[    0.359175] [c0000003f8c03e30] [c00000000000a164] .ret_from_kernel_thread+0x64/0x80
[    0.359184] Instruction dump:
[    0.359190] 3863e610 4829c2f1 60000000 0fe00000 e8810070 4bffffb0 60000000 3c62ff8c 
[    0.359211] f8810070 3863e5e8 4829c2cd 60000000 <0fe00000> e8810070 a1240008 4bffff80 
[    0.359241] ---[ end trace c949de754c984735 ]---

CAI Qian

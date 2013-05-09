Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753762Ab3EIKgo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 06:36:44 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:42009 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753669Ab3EIKgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 06:36:43 -0400
Message-ID: <518B7B6A.1090407@linux.vnet.ibm.com>
Date: Thu, 09 May 2013 16:03:14 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: CAI Qian <caiqian@redhat.com>
CC: LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@alien8.de>,
        Greg KH <gregkh@linuxfoundation.org>, balbi@ti.com,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>, dyoung@redhat.com
Subject: Re: 3.9.0: WARNING: at drivers/base/core.c:575
References: <1732336275.8141054.1367911558572.JavaMail.root@redhat.com>
In-Reply-To: <1732336275.8141054.1367911558572.JavaMail.root@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13050910-9574-0000-0000-000007C6FE30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2013 12:55 PM, CAI Qian wrote:
> Never saw any of those messages were floating in any of the RC testing, but
> now happened in 3.9 GA on Power 7 systems.
>

Can you check if the patch posted here fixes it?

http://marc.info/?l=linux-kernel&m=136791823608013&w=2

Regards,
Srivatsa S. Bhat
 
> [    0.329753] EEH: devices created
> [    0.340203] atomic64 test passed
> [    0.340407] NET: Registered protocol family 16
> [    0.340457] EEH: No capable adapters found
> [    0.340609] IBM eBus Device Driver
> [    0.358825] Write permission without 'store'
> [    0.358852] ------------[ cut here ]------------
> [    0.358859] WARNING: at drivers/base/core.c:575
> [    0.358866] Modules linked in:
> [    0.358877] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.9.0+ #1
> [    0.358887] task: c0000003f8bc0000 ti: c0000003f8c00000 task.ti: c0000003f8c00000
> [    0.358897] NIP: c0000000004a7f44 LR: c0000000004a7f40 CTR: 0000000001766760
> [    0.358906] REGS: c0000003f8c03780 TRAP: 0700   Not tainted  (3.9.0+)
> [    0.358914] MSR: 8000000000029032 <SF,EE,ME,IR,DR,RI>  CR: 28139d24  XER: 00000001
> [    0.358939] SOFTE: 1
> [    0.358944] CFAR: c00000000074427c
> [    0.358950] 
> GPR00: c0000000004a7f40 c0000003f8c03a00 c000000001117e50 0000000000000020 
> GPR04: 0000000000000000 0000000000000000 00000000160c9615 0000000000000000 
> GPR08: c000000001064af0 0000000000000000 0000000000000000 0000000000003fef 
> GPR12: 0000000028139d22 c000000007f00000 c00000000000bb30 0000000000000000 
> GPR16: 0000000000000000 0000000000000000 c000000000ff1c78 0000000000000001 
> GPR20: 0000000000000000 0000000000000000 0000000000000000 c00000000117eb08 
> GPR24: 00000000000000a6 c000000000af0028 0000000000000000 c000000000ff21a0 
> GPR28: 0000000000000002 c000000001500030 c0000000011b8200 c000000001500030 
> [    0.359070] NIP [c0000000004a7f44] .device_create_file+0xa4/0xe0
> [    0.359080] LR [c0000000004a7f40] .device_create_file+0xa0/0xe0
> [    0.359088] Call Trace:
> [    0.359095] [c0000003f8c03a00] [c0000000004a7f40] .device_create_file+0xa0/0xe0 (unreliable)
> [    0.359112] [c0000003f8c03a90] [c00000000074daf8] .register_cpu_online+0x21c/0x284
> [    0.359126] [c0000003f8c03b30] [c000000000a78308] .topology_init+0x130/0x200
> [    0.359138] [c0000003f8c03c10] [c00000000000b4d4] .do_one_initcall+0x144/0x1f0
> [    0.359150] [c0000003f8c03cd0] [c000000000a746a8] .kernel_init_freeable+0x23c/0x32c
> [    0.359163] [c0000003f8c03db0] [c00000000000bb4c] .kernel_init+0x1c/0x130
> [    0.359175] [c0000003f8c03e30] [c00000000000a164] .ret_from_kernel_thread+0x64/0x80
> [    0.359184] Instruction dump:
> [    0.359190] 3863e610 4829c2f1 60000000 0fe00000 e8810070 4bffffb0 60000000 3c62ff8c 
> [    0.359211] f8810070 3863e5e8 4829c2cd 60000000 <0fe00000> e8810070 a1240008 4bffff80 
> [    0.359241] ---[ end trace c949de754c984735 ]---
> 


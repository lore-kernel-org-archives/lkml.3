Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719Ab3B1LNp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 06:13:45 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:39699 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271Ab3B1LNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 06:13:42 -0500
Message-ID: <512F3BDA.6000208@hitachi.com>
Date: Thu, 28 Feb 2013 20:13:30 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: heikki.krogerus@linux.intel.com, linux-arm-kernel@lists.infradead.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org,
        thomas.petazzoni@free-electrons.com, yrl.pp-manager.tt@hitachi.com,
        iwamatsu@nigauri.org
Subject: [BUG][arm-soc] kernel panic in boot on Openblocks with the latest
 kernel
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I tried the latest "fixes" branch of arm-soc.git on OpenBlocks
AX3 (Marvel Armada-XP) and got below kernel panic in boot sequence.
It seems that we have an exception while cpu is in idle.

----
Kernel panic - not syncing: Attempted to kill init! exitcode=0x00000200

Backtrace:
[<c00113d4>] (dump_backtrace+0x0/0x110) from [<c04a7324>] (dump_stack+0x18/0x1c)
 r6:ef2bcc00 r5:c06532b0 r4:ef2bcc00 r3:00000001
[<c04a730c>] (dump_stack+0x0/0x1c) from [<c04a7434>] (panic+0x90/0x1ec)
[<c04a73a4>] (panic+0x0/0x1ec) from [<c002613c>] (do_exit+0x500/0x960)
 r3:ef2c0dc0 r2:ef2bcc00 r1:00000200 r0:c0584be1
 r7:c063e040
[<c0025c3c>] (do_exit+0x0/0x960) from [<c0026790>] (do_group_exit+0xa4/0xd0)
 r7:000000f8
[<c00266ec>] (do_group_exit+0x0/0xd0) from [<c00267d4>] (__wake_up_parent+0x0/0x28)
 r7:000000f8 r6:0000003c r5:bee6bf14 r4:000703ae
[<c00267bc>] (sys_exit_group+0x0/0x18) from [<c000d8c0>] (ret_fast_syscall+0x0/0x30)
CPU0: stopping
Backtrace:
[<c00113d4>] (dump_backtrace+0x0/0x110) from [<c04a7324>] (dump_stack+0x18/0x1c)
 r6:c063df48 r5:00000000 r4:c0688e98 r3:c064def4
[<c04a730c>] (dump_stack+0x0/0x1c) from [<c00128f4>] (handle_IPI+0xc8/0x12c)
[<c001282c>] (handle_IPI+0x0/0x12c) from [<c00085a0>]
(armada_370_xp_handle_irq+0x98/0xb0)
 r5:c0689070 r4:00000005
[<c0008508>] (armada_370_xp_handle_irq+0x0/0xb0) from [<c04ae680>]
(__irq_svc+0x40/0x50)
Exception stack(0xc063df48 to 0xc063df90)
df40:                   ffffffed 00000000 027ac000 60000013 c063c000 c0688c88
df60: c04b5518 c2ddffc0 0000406a 562f5842 00000000 c063dfac c063df90 c063df90
df80: c000e588 c000e590 60000013 ffffffff
[<c000e4d8>] (cpu_idle+0x0/0x104) from [<c04a266c>] (rest_init+0x64/0x7c)
 r6:c0625a50 r5:00000000 r4:c06450e0 r3:00000000
[<c04a2608>] (rest_init+0x0/0x7c) from [<c05fb848>] (start_kernel+0x2d4/0x32c)
[<c05fb574>] (start_kernel+0x0/0x32c) from [<00008074>] (0x8074)
----

And I found that this panic also happened on the latest linus tree.
Git-bisect told me that the 8250 serial driver patch is the first bad
commit.

serial: 8250_dw: Don't use UPF_FIXED_TYPE

966c4e39b5f7f249d7bb4c409176c9e6c5d48025

https://patchwork.kernel.org/patch/1958931/


Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142AbbAFSTl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 13:19:41 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44282 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142AbbAFSTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 13:19:39 -0500
Date: Tue, 6 Jan 2015 19:19:36 +0100
From: Pavel Machek <pavel@ucw.cz>
To: pali.rohar@gmail.com, sre@debian.org, sre@ring0.de,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, ivo.g.dimitrov.75@gmail.com
Subject: v3.18: Audio recording, Nokia N900
Message-ID: <20150106181936.GA25319@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I tried to get "latency" example from ALSA to work (it basically
records audio, pauses for a while, then plays it back) on N900, and
all I'm getting is silence... plus now it oopsed.

Any idea?

Is there any version where audio recording works?

What do you use for testing?

Are there any mixer settings I should know about?

Thanks,
								Pavel

[ 4207.949096] omap_i2c 48072000.i2c: controller timed out
[ 4207.950836] power_supply bq24150a-0: driver failed to report
`status' property: -110
[ 4216.949035] omap_i2c 48070000.i2c: controller timed out
[ 4216.951354] twl: Write failed (mod 14, reg 0x06 count 2)
[ 4216.953613] twl4030_madc 48070000.i2c:twl@48:madc: unable to write
sel register 0x6
[ 4216.956207] rx51-battery n900-battery: Could not read ADC: -110
[ 4217.969085] omap_i2c 48070000.i2c: controller timed out
[ 4217.972259] twl: Write failed (mod 14, reg 0x06 count 2)
[ 4217.975372] twl4030_madc 48070000.i2c:twl@48:madc: unable to write
sel register 0x6
[ 4217.978790] rx51-battery n900-battery: Could not read ADC: -110
[ 4218.989135] omap_i2c 48070000.i2c: controller timed out
[ 4218.993164] twl: Write failed (mod 14, reg 0x06 count 2)
[ 4218.997100] twl4030_madc 48070000.i2c:twl@48:madc: unable to write
sel register 0x6
[ 4219.959686] rx51-battery n900-battery: Could not read ADC: -110
[ 4220.959136] omap_i2c 48070000.i2c: controller timed out
[ 4220.963989] twl: Write failed (mod 14, reg 0x06 count 2)
[ 4220.968749] twl4030_madc 48070000.i2c:twl@48:madc: unable to write
sel register 0x6
[ 4220.993530] rx51-battery n900-battery: Could not read ADC: -110
[ 4222.959136] omap_i2c 48072000.i2c: controller timed out
[ 4226.639495] Unhandled fault: external abort on non-linefetch
(0x1028) at 0xfa070004
[ 4226.645568] Internal error: : 1028 [#1] PREEMPT ARM
[ 4226.651519] Modules linked in:
[ 4226.657531] CPU: 0 PID: 737 Comm: irq/225-4807000 Tainted: G
W      3.18.0-omap3-69644-g0ed746d #837
[ 4226.670471] task: cf000c00 ti: cf094000 task.ti: cf094000
[ 4226.677307] PC is at omap_i2c_isr_thread+0x44/0x414
[ 4226.684295] LR is at walk_stackframe+0x24/0x40
[ 4226.691375] pc : [<c036dcdc>]    lr : [<c00113d8>]    psr: 60000093
[ 4226.691375] sp : cf095ee8  ip : cf095e80  fp : cf095f14
[ 4226.706146] r10: c0065744  r9 : cf000810  r8 : 20000013
[ 4226.713409] r7 : 00000002  r6 : 00000004  r5 : 00000000  r4 :
00000065
[ 4226.720611] r3 : cf000c00  r2 : fa070004  r1 : fa070000  r0 :
00000001
[ 4226.727600] Flags: nZCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM
Segment kernel
[ 4226.734741] Control: 10c5387d  Table: 8f058019  DAC: 00000015
[ 4226.741821] Process irq/225-4807000 (pid: 737, stack limit =
0xcf094238)
[ 4226.748870] Stack: (0xcf095ee8 to 0xcf096000)
[ 4226.755859] 5ee0:                   c036dc98 cf027bc0 cf094000
cf8e9240 cf8e9240 cf8e9294
[ 4226.763122] 5f00: 00000000 c0065744 cf095f34 cf095f18 c0065768
c036dca4 cf000c00 cf027bc0
[ 4226.770385] 5f20: cf094000 00000001 cf095f64 cf095f38 c0065508
c0065750 00000000 c0065684
[ 4226.777526] 5f40: 00000000 cf027c00 cf027bc0 c0065424 00000000
00000000 cf095fac cf095f68
[ 4226.784698] 5f60: c0050d2c c0065430 cf095f94 00000000 c0055854
cf027bc0 00000000 cf095f7c
[ 4226.791839] 5f80: cf095f7c 00000000 cf095f88 cf095f88 cf027c00
c0050c64 00000000 00000000
[ 4226.798950] 5fa0: 00000000 cf095fb0 c000ebd8 c0050c70 00000000
00000000 00000000 00000000
[ 4226.805969] 5fc0: 00000000 00000000 00000000 00000000 00000000
00000000 00000000 00000000
[ 4226.812896] 5fe0: 00000000 00000000 00000000 00000000 00000013
00000000 edff7fff fffbfffe
[ 4226.819702] Backtrace:
[ 4226.826324] [<c036dc98>] (omap_i2c_isr_thread) from [<c0065768>]
(irq_thread_fn+0x24/0x3c)
[ 4226.833221]  r10:c0065744 r9:00000000 r8:cf8e9294 r7:cf8e9240
r6:cf8e9240 r5:cf094000
[ 4226.840301]  r4:cf027bc0 r3:c036dc98
[ 4226.847106] [<c0065744>] (irq_thread_fn) from [<c0065508>]
(irq_thread+0xe4/0x12c)
[ 4226.854034]  r6:00000001 r5:cf094000 r4:cf027bc0 r3:cf000c00
[ 4226.861083] [<c0065424>] (irq_thread) from [<c0050d2c>]
(kthread+0xc8/0xe4)
[ 4226.868072]  r10:00000000 r8:00000000 r7:c0065424 r6:cf027bc0
r5:cf027c00 r4:00000000
[ 4226.875213] [<c0050c64>] (kthread) from [<c000ebd8>]
(ret_from_fork+0x14/0x3c)
[ 4226.882263]  r7:00000000 r6:00000000 r5:c0050c64 r4:cf027c00
[ 4226.889373] Code: e599200c e5991004 e5d00001 e0812210 (e1d210b0)
[ 4227.101501] ---[ end trace 43582f7728e0496b ]---
[ 4227.108642] note: irq/225-4807000[737] exited with preempt_count 1
[ 4227.115905] Unable to handle kernel paging request at virtual
address fffffff0
[ 4227.123321] pgd = c0004000
[ 4227.130584] [fffffff0] *pgd=8fefd821, *pte=00000000, *ppte=00000000
[ 4227.138214] Internal error: Oops: 17 [#2] PREEMPT ARM
[ 4227.145660] Modules linked in:
[ 4227.152954] CPU: 0 PID: 737 Comm: irq/225-4807000 Tainted: G      D
W      3.18.0-omap3-69644-g0ed746d #837
[ 4227.167785] task: cf000c00 ti: cf094000 task.ti: cf094000
[ 4227.175201] PC is at kthread_data+0x10/0x18
[ 4227.182525] LR is at irq_thread_dtor+0x30/0xc0
[ 4227.189819] pc : [<c00512a8>]    lr : [<c00656b4>]    psr: 20000013
[ 4227.189819] sp : cf095cd8  ip : cf095ce8  fp : cf095ce4
[ 4227.204406] r10: c036dcde  r9 : c07c2144  r8 : cf094000
[ 4227.211608] r7 : 00000000  r6 : c07c37f4  r5 : cf000c00  r4 :
cf000f60
[ 4227.218841] r3 : 00000000  r2 : cf095ce8  r1 : cf095f38  r0 :
cf000c00
[ 4227.226074] Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM
Segment user
[ 4227.233520] Control: 10c5387d  Table: 8c6ac019  DAC: 00000015
[ 4227.240844] Process irq/225-4807000 (pid: 737, stack limit =
0xcf094238)
[ 4227.248138] Stack: (0xcf095cd8 to 0xcf096000)
[ 4227.255218] 5cc0:
cf095cfc cf095ce8
[ 4227.262420] 5ce0: c00656b4 c00512a4 cf000f60 cf000c00 cf095d1c
cf095d00 c004f624 c0065690
[ 4227.269683] 5d00: 0000000b cf094000 cf000c00 00000000 cf095d54
cf095d20 c003ac28 c004f5a0
[ 4227.276794] 5d20: cf094000 00000001 c0782f90 cf095d38 c07c2144
c036dcde cf095d54 cf095d48
[ 4227.283874] 5d40: c003954c c0782f90 cf095ddc cf095d58 c0011aa8
c003a9b8 cf094238 0000000b
[ 4227.290863] 5d60: 00000000 00000000 cf095ea0 00000008 00000000
60000193 657c1d47 32393935
[ 4227.297790] 5d80: 20633030 39393565 34303031 64356520 30303030
30652031 32323138 28203031
[ 4227.304779] 5da0: 32643165 30623031 cf002029 c0065744 cf095ddc
00001028 00000007 c0783d44
[ 4227.311828] 5dc0: fa070004 cf095ea0 cf000810 c0065744 cf095dec
cf095de0 c0011b44 c00117dc
[ 4227.318847] 5de0: cf095e9c cf095df0 c0008594 c0011b30 00000000
0000ee6b 00000007 00000000
[ 4227.325836] 5e00: 00000000 fa070004 00007735 00000000 ffffffff
00000000 cf095e4c cf095e28
[ 4227.332824] 5e20: c0051a20 c00133b4 ffffffff c07c2054 ffffffff
cc7c2000 ffffffff 00000000
[ 4227.339782] 5e40: cf095e74 cf095e50 c0051d4c c006a7e0 00000000
c07995b0 cc7c201c cf000c00
[ 4227.346771] 5e60: cc41e000 00000000 cf000c00 c07995b0 cf095e9c
cf095e80 c00113d8 c036dcdc
[ 4227.353759] 5e80: 60000093 ffffffff cf095ed4 20000013 cf095f14
cf095ea0 c0012218 c0008510
[ 4227.360748] 5ea0: 00000001 fa070000 fa070004 cf000c00 00000065
00000000 00000004 00000002
[ 4227.367706] 5ec0: 20000013 cf000810 c0065744 cf095f14 cf095e80
cf095ee8 c00113d8 c036dcdc
[ 4227.374572] 5ee0: 60000093 ffffffff c036dc98 cf027bc0 cf094000
cf8e9240 cf8e9240 cf8e9294
[ 4227.381408] 5f00: 00000000 c0065744 cf095f34 cf095f18 c0065768
c036dca4 cf000c00 cf027bc0
[ 4227.388305] 5f20: cf094000 00000001 cf095f64 cf095f38 c0065508
c0065750 00000000 c0065684
[ 4227.395202] 5f40: 00000000 cf027c00 cf027bc0 c0065424 00000000
00000000 cf095fac cf095f68
[ 4227.402130] 5f60: c0050d2c c0065430 cf095f94 00000000 c0055854
cf027bc0 00000000 cf095f7c
[ 4227.409088] 5f80: cf095f7c 00000001 cf095f88 cf095f88 cf027c00
c0050c64 00000000 00000000
[ 4227.416107] 5fa0: 00000000 cf095fb0 c000ebd8 c0050c70 00000000
00000000 00000000 00000000
[ 4227.423156] 5fc0: 00000000 00000000 00000000 00000000 00000000
00000000 00000000 00000000
[ 4227.430206] 5fe0: 00000000 00000000 00000000 00000000 00000013
00000000 edff7fff fffbfffe
[ 4227.437072] Backtrace:
[ 4227.443786] [<c0051298>] (kthread_data) from [<c00656b4>]
(irq_thread_dtor+0x30/0xc0)
[ 4227.450775] [<c0065684>] (irq_thread_dtor) from [<c004f624>]
(task_work_run+0x90/0xc4)
[ 4227.457794]  r5:cf000c00 r4:cf000f60
[ 4227.464721] [<c004f594>] (task_work_run) from [<c003ac28>]
(do_exit+0x27c/0x8f8)
[ 4227.471771]  r7:00000000 r6:cf000c00 r5:cf094000 r4:0000000b
[ 4227.478973] [<c003a9ac>] (do_exit) from [<c0011aa8>]
(die+0x2d8/0x354)
[ 4227.486114]  r7:c0782f90
[ 4227.493103] [<c00117d0>] (die) from [<c0011b44>]
(arm_notify_die+0x20/0x58)
[ 4227.500244]  r10:c0065744 r9:cf000810 r8:cf095ea0 r7:fa070004
r6:c0783d44 r5:00000007
[ 4227.507598]  r4:00001028
[ 4227.514678] [<c0011b24>] (arm_notify_die) from [<c0008594>]
(do_DataAbort+0x90/0xa0)
[ 4227.522033] [<c0008504>] (do_DataAbort) from [<c0012218>]
(__dabt_svc+0x38/0x60)
[ 4227.529388] Exception stack(0xcf095ea0 to 0xcf095ee8)
[ 4227.536651] 5ea0: 00000001 fa070000 fa070004 cf000c00 00000065
00000000 00000004 00000002
[ 4227.544158] 5ec0: 20000013 cf000810 c0065744 cf095f14 cf095e80
cf095ee8 c00113d8 c036dcdc
[ 4227.551666] 5ee0: 60000093 ffffffff
[ 4227.558959]  r8:20000013 r7:cf095ed4 r6:ffffffff r5:60000093
r4:c036dcdc
[ 4227.566558] [<c036dc98>] (omap_i2c_isr_thread) from [<c0065768>]
(irq_thread_fn+0x24/0x3c)
[ 4227.574188]  r10:c0065744 r9:00000000 r8:cf8e9294 r7:cf8e9240
r6:cf8e9240 r5:cf094000
[ 4227.582000]  r4:cf027bc0 r3:c036dc98
[ 4227.589630] [<c0065744>] (irq_thread_fn) from [<c0065508>]
(irq_thread+0xe4/0x12c)
[ 4227.597442]  r6:00000001 r5:cf094000 r4:cf027bc0 r3:cf000c00
[ 4227.605346] [<c0065424>] (irq_thread) from [<c0050d2c>]
(kthread+0xc8/0xe4)
[ 4227.613281]  r10:00000000 r8:00000000 r7:c0065424 r6:cf027bc0
r5:cf027c00 r4:00000000
[ 4227.621459] [<c0050c64>] (kthread) from [<c000ebd8>]
(ret_from_fork+0x14/0x3c)
[ 4227.629547]  r7:00000000 r6:00000000 r5:c0050c64 r4:cf027c00
[ 4227.637756] Code: e1a0c00d e92dd800 e24cb004 e59031e8 (e5130010)
[ 4227.646057] ---[ end trace 43582f7728e0496c ]---
[ 4227.654388] Fixing recursive fault but reboot is needed!
[ 4229.004913] bq27x00-battery 2-0055: battery is not calibrated!
ignoring capacity values
[ 4232.909301] omap_i2c 48070000.i2c: controller timed out
[ 4232.917816] twl: Write failed (mod 10, reg 0x09 count 1)

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

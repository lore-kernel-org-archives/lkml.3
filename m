Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933270Ab3BLQPN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 11:15:13 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:45810 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758377Ab3BLQPL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 11:15:11 -0500
Message-ID: <511A6A8C.2020000@ti.com>
Date: Tue, 12 Feb 2013 10:15:08 -0600
From: Jon Hunter <jon-hunter@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
CC: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, Tero Kristo <t-kristo@ti.com>
Subject: Re: [PATCH v2 09/11] mfd: twl-core: Collect global variables behind
 one private structure (global)
References: <1358344439-23017-1-git-send-email-peter.ujfalusi@ti.com> <1358344439-23017-10-git-send-email-peter.ujfalusi@ti.com> <51154A7A.2010709@ti.com> <5115E3B9.6090100@ti.com> <51195301.8000606@ti.com> <5119EEB4.70508@ti.com>
In-Reply-To: <5119EEB4.70508@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.157.144.139]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 02/12/2013 01:26 AM, Peter Ujfalusi wrote:
> On 02/11/2013 09:22 PM, Jon Hunter wrote:
>> Good point. I just noticed that none of my omap2+ board were booting and
>> on omap3/4 I was the panic in the twl code. I can't say that I checked
>> the panic on omap2, so may be that was another problem?
> 
> Do you have insights on the code path leading to a crash on OMAP3/4? I have
> been running this code on several boards (BeagleBoard, Zoom2, PandaBoard,
> Blaze) and have not seen a crash.

Here is the panic log ...

[    2.286132] Unable to handle kernel NULL pointer dereference at virtual address 00000000
[    2.294738] pgd = c0004000
[    2.297576] [00000000] *pgd=00000000
[    2.301361] Internal error: Oops: 5 [#1] SMP ARM
[    2.306243] Modules linked in:
[    2.309448] CPU: 0    Not tainted  (3.8.0-rc6-next-20130207-00016-g735c237 #35)
[    2.317169] PC is at twl_i2c_read+0x3c/0xec
[    2.321563] LR is at twl_i2c_read+0x1c/0xec
[    2.325988] pc : [<c0333950>]    lr : [<c0333930>]    psr: 80000153
[    2.325988] sp : c702fed0  ip : 00000000  fp : 00000000
[    2.338043] r10: c702e000  r9 : c06e84e8  r8 : c06e51c8
[    2.343536] r7 : 00000001  r6 : 00000006  r5 : c702fef6  r4 : 00000004
[    2.350402] r3 : c129508c  r2 : 00000006  r1 : c702fef6  r0 : 0000000e
[    2.357269] Flags: Nzcv  IRQs on  FIQs off  Mode SVC_32  ISA ARM  Segment kernel
[    2.365051] Control: 10c5387d  Table: 80004019  DAC: 00000017
[    2.371093] Process swapper/0 (pid: 1, stack limit = 0xc702e240)
[    2.377410] Stack: (0xc702fed0 to 0xc7030000)
[    2.382019] fec0:                                     c0d42180 c0d429d0 c70a7640 c07354c4
[    2.390624] fee0: 00000001 c0719798 c0d42180 c06f2cc0 c04e76cc c06ee1ac 00000000 c07354c4
[    2.399230] ff00: 00000007 c06f2d64 00000017 c06fb308 00000000 c06f07a4 c0cb8580 c06edee0
[    2.407836] ff20: c06eded4 c06e8504 c0d42180 c0008768 0000009e c00611b4 00000001 00000000
[    2.416442] ff40: c061994c c06b7548 00000007 00000007 00000000 c07354c4 00000007 c0719798
[    2.425048] ff60: c0d42180 c06e51c8 c07197a0 0000009e 00000000 c06e590c 00000007 00000007
[    2.433654] ff80: c06e51c8 00000000 00000000 c04d26ec 00000000 00000000 00000000 00000000
[    2.442260] ffa0: 00000000 c04d26f4 00000000 c00137b0 00000000 00000000 00000000 00000000
[    2.450866] ffc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[    2.459472] ffe0: 00000000 00000000 00000000 00000000 00000013 00000000 80fb6c10 71bbcd20
[    2.468078] [<c0333950>] (twl_i2c_read+0x3c/0xec) from [<c06f2cc0>] (omap3_twl_set_sr_bit+0x3c/0xb4)
[    2.477722] [<c06f2cc0>] (omap3_twl_set_sr_bit+0x3c/0xb4) from [<c06f2d64>] (omap3_twl_init+0x2c/0x70)
[    2.487518] [<c06f2d64>] (omap3_twl_init+0x2c/0x70) from [<c06fb308>] (omap_pmic_late_init+0x18/0x24)
[    2.497222] [<c06fb308>] (omap_pmic_late_init+0x18/0x24) from [<c06f07a4>] (omap2_common_pm_late_init+0x18/0xd0)
[    2.507934] [<c06f07a4>] (omap2_common_pm_late_init+0x18/0xd0) from [<c06edee0>] (omap3_init_late+0xc/0x18)
[    2.518188] [<c06edee0>] (omap3_init_late+0xc/0x18) from [<c06e8504>] (init_machine_late+0x1c/0x28)
[    2.527740] [<c06e8504>] (init_machine_late+0x1c/0x28) from [<c0008768>] (do_one_initcall+0x100/0x16c)
[    2.537536] [<c0008768>] (do_one_initcall+0x100/0x16c) from [<c06e590c>] (kernel_init_freeable+0xfc/0x1c8)
[    2.547698] [<c06e590c>] (kernel_init_freeable+0xfc/0x1c8) from [<c04d26f4>] (kernel_init+0x8/0xe4)
[    2.557250] [<c04d26f4>] (kernel_init+0x8/0xe4) from [<c00137b0>] (ret_from_fork+0x14/0x24)

> But the fix is valid.
 
Thanks. I saw this on linux-next earlier this week, but now I am not seeing it and the fix
I posted is not there. So I am not sure what changed to cause this to occur earlier this
week but the problem appears to be gone again. However, at least the fix will prevent such
panics if someone is calling twl_i2c_read/write too early.

Cheers
Jon

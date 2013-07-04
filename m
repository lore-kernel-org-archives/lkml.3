Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910Ab3GDKoR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 06:44:17 -0400
Received: from co1ehsobe001.messaging.microsoft.com ([216.32.180.184]:45533
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750769Ab3GDKoP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 06:44:15 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(zzzz1f42h1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzzz2dh2a8h668h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e1dhbe9i1155h)
From: Stehle Vincent-B46079 <B46079@freescale.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
CC: "festevam@gmail.com" <festevam@gmail.com>,
        Shawn Guo <shawn.guo@linaro.org>
Subject: Mainline crashes in wm8962_probe() on i.MX6
Thread-Topic: Mainline crashes in wm8962_probe() on i.MX6
Thread-Index: Ac54o2gbdlNidAQESmG0hRwqYXenaw==
Date: Thu, 4 Jul 2013 10:44:11 +0000
Message-ID: <F7C43F8B2814514CA05F3436BC68046EF3A272@039-SN2MPN1-011.039d.mgd.msft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.214.137.192]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Mainline of today* will not boot anymore on i.MX6 with ARM config imx_v6_v7_defconfig. It crashes in wm8962_probe() (see log below).

Bisecting points at merge commit 1286da8bc009cb2aee7f285e94623fc974c0c983, but its two "parents" commits do not crash.

Best regards,

V.

*: commit ddcf6600b133697adbafd96e080818bdc0dfd028

---

wm8962 0-001a: customer id 0 revision D
Unable to handle kernel NULL pointer dereference at virtual address 00000004
pgd = 80004000
[00000004] *pgd=00000000
Internal error: Oops: 5 [#1] SMP ARM
Modules linked in:
CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.10.0+ #1
task: bf870000 ti: bf874000 task.ti: bf874000
PC is at wm8962_probe+0x134/0x6c8
LR is at regmap_unlock_mutex+0x10/0x14
pc : [<80452100>]    lr : [<80304cf4>]    psr: a0000113
sp : bf875c98  ip : 00000000  fp : bf875cd4
r10: 00000000  r9 : bfb1830c  r8 : 80779bc4
r7 : 00000000  r6 : 00000001  r5 : bfbac010  r4 : bfb33e00
r3 : 80304ce4  r2 : 00000000  r1 : 00000001  r0 : fffffffb
Flags: NzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
Control: 10c53c7d  Table: 1000404a  DAC: 00000017
Process swapper/0 (pid: 1, stack limit = 0xbf874238)
Stack: (0xbf875c98 to 0xbf876000)
5c80:                                                       00000000 00000000
5ca0: 00000000 00000000 00000000 bfb33e00 80778a00 80778ab0 bfba8c60 80779bc4
5cc0: bfb1830c bfb33eb0 bf875d04 bf875cd8 80440c30 80451fd8 8058c9c8 bf875ce8
5ce0: bfaf5000 00000000 80778a88 bfba8c60 00000000 00000000 bf875d84 bf875d08
5d00: 80442ae4 80440ac4 bfba8c70 80fed848 bf875d44 bf875d20 bfba8d38 bfba8d30
5d20: bfba8d40 bfba8d58 bfba8c80 80778aa8 bfb1830c bfb1833c bfb33e00 80778ab8
5d40: 80778aa8 bfb33e30 bfaf52f0 bfaf5240 bfba8c60 bfba8d68 bf875d84 00000000
5d60: bf983810 80fe5984 bfba8c60 bf9b9020 bf827000 bfba8c10 bf875dc4 bf875d88
5d80: 804563f0 804420a4 00000000 bf91a400 00000001 00000002 bf875db4 807d3ed8
5da0: bf983810 00000000 8077d1b4 807207dc bf874000 000000ac bf875dd4 bf875dc8
5dc0: 802f6388 8045613c bf875df4 bf875dd8 802f4fe4 802f6374 bf983810 8077d1b4
5de0: bf983844 00000000 bf875e14 bf875df8 802f5190 802f4ee4 bf83c85c 00000000
5e00: 8077d1b4 802f50fc bf875e3c bf875e18 802f34f0 802f5108 bf83c85c bf928bb4
5e20: bf83c870 8077d1b4 bfb2c080 807662d0 bf875e4c bf875e40 802f4ad8 802f34a0
5e40: bf875e7c bf875e50 802f4650 802f4ac4 806b7204 80783bc0 bf875e7c 8077d1b4
5e60: 00000006 80783bc0 806f220c 807207dc bf875ea4 bf875e80 802f56b4 802f4580
5e80: 8073dcdc 00000006 80783bc0 806f220c 807207dc 000000ac bf875eb4 bf875ea8
5ea0: 802f65ac 802f5640 bf875ec4 bf875eb8 807207f4 802f6568 bf875f54 bf875ec8
5ec0: 80008794 807207e8 bf875f0c bf875ed8 8054b368 00000000 00100100 80755408
5ee0: bf875f0c bf875ef0 bf875f00 bf875ef8 806f220c 80fedb1b 80564964 000000ac
5f00: bf875f54 bf875f10 800419b0 806f2218 00000000 00000006 00000006 806f017c
5f20: 00000000 806a41fc bf875f54 8073dcdc 00000006 80783bc0 806f220c 807324a4
5f40: 80732498 000000ac bf875f94 bf875f58 806f29b8 800086ac 00000006 00000006
5f60: 806f220c 80000084 38070000 00000000 8053fbe8 00000000 00000000 00000000
5f80: 00000000 00000000 bf875fac bf875f98 8053fbf8 806f28c4 ffffffff 00000000
5fa0: 00000000 bf875fb0 8000e2b8 8053fbf4 00000000 00000000 00000000 00000000
5fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
5fe0: 00000000 00000000 00000000 00000000 00000013 00000000 00000000 00000000
Backtrace:
[<80451fcc>] (wm8962_probe+0x0/0x6c8) from [<80440c30>] (soc_probe_codec+0x178/0x308)
[<80440ab8>] (soc_probe_codec+0x0/0x308) from [<80442ae4>] (snd_soc_register_card+0xa4c/0x162c)
[<80442098>] (snd_soc_register_card+0x0/0x162c) from [<804563f0>] (imx_wm8962_probe+0x2c0/0x378)
[<80456130>] (imx_wm8962_probe+0x0/0x378) from [<802f6388>] (platform_drv_probe+0x20/0x24)
[<802f6368>] (platform_drv_probe+0x0/0x24) from [<802f4fe4>] (driver_probe_device+0x10c/0x224)
[<802f4ed8>] (driver_probe_device+0x0/0x224) from [<802f5190>] (__driver_attach+0x94/0x98)
 r7:00000000 r6:bf983844 r5:8077d1b4 r4:bf983810
[<802f50fc>] (__driver_attach+0x0/0x98) from [<802f34f0>] (bus_for_each_dev+0x5c/0x90)
 r6:802f50fc r5:8077d1b4 r4:00000000 r3:bf83c85c
[<802f3494>] (bus_for_each_dev+0x0/0x90) from [<802f4ad8>] (driver_attach+0x20/0x28)
 r6:807662d0 r5:bfb2c080 r4:8077d1b4
[<802f4ab8>] (driver_attach+0x0/0x28) from [<802f4650>] (bus_add_driver+0xdc/0x238)
[<802f4574>] (bus_add_driver+0x0/0x238) from [<802f56b4>] (driver_register+0x80/0x154)
 r8:807207dc r7:806f220c r6:80783bc0 r5:00000006 r4:8077d1b4
[<802f5634>] (driver_register+0x0/0x154) from [<802f65ac>] (__platform_driver_register+0x50/0x64)
[<802f655c>] (__platform_driver_register+0x0/0x64) from [<807207f4>] (imx_wm8962_driver_init+0x18/0x20)
[<807207dc>] (imx_wm8962_driver_init+0x0/0x20) from [<80008794>] (do_one_initcall+0xf4/0x154)
[<800086a0>] (do_one_initcall+0x0/0x154) from [<806f29b8>] (kernel_init_freeable+0x100/0x1cc)
[<806f28b8>] (kernel_init_freeable+0x0/0x1cc) from [<8053fbf8>] (kernel_init+0x10/0xec)
[<8053fbe8>] (kernel_init+0x0/0xec) from [<8000e2b8>] (ret_from_fork+0x14/0x3c)
 r4:00000000 r3:ffffffff
Code: ea000002 e2866001 e3560007 0a00000d (e5b73004)



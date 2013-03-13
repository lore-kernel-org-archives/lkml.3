Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932893Ab3CML2Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 07:28:24 -0400
Received: from mga02.intel.com ([134.134.136.20]:3599 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754570Ab3CML2X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 07:28:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,836,1355126400"; 
   d="scan'208";a="278173330"
Message-ID: <1363174155.11441.25.camel@sauron.fi.intel.com>
Subject: Re: MTD: UBIFS: Kernel oops when fixing up free space
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Mark Jackson <mpfj-list@mimc.co.uk>
Cc: "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        lkml <linux-kernel@vger.kernel.org>, adrian.hunter@intel.com
Date: Wed, 13 Mar 2013 13:29:15 +0200
In-Reply-To: <5140610A.1040205@mimc.co.uk>
References: <5140610A.1040205@mimc.co.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3 (3.6.3-2.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-03-13 at 11:20 +0000, Mark Jackson wrote:
> [    2.474665] Internal error: Oops: 5 [#1] ARM
> [    2.479178] CPU: 0    Not tainted  (3.8.0-next-20130225-00001-g2d0ce24-dirty #37)
> [    2.487089] PC is at crc32_le+0xf4/0x168
> [    2.491232] LR is at ubi_eba_atomic_leb_change+0x1b4/0x410
> [    2.497020] pc : [<c01e7228>]    lr : [<c026dcdc>]    psr: 20000013
> [    2.497020] sp : cf373db0  ip : 180a7e81  fp : c054f840
> [    2.509133] r10: 90e28e08  r9 : c054fc40  r8 : 180a9e87
> [    2.514645] r7 : 1596e25d  r6 : 9324fd72  r5 : 90e28e08  r4 : 39f54975
> [    2.521533] r3 : c054e040  r2 : 00000004  r1 : 90e28e0b  r0 : 160aeca3
> [    2.528421] Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
> [    2.535952] Control: 10c5387d  Table: 8f374019  DAC: 00000015
> [    2.542013] Process mount (pid: 602, stack limit = 0xcf372238)
> [    2.548168] Stack: (0xcf373db0 to 0xcf374000)
> [    2.552767] 3da0:                                     c06702fc 00000004 90e28e08 180a9e87
> [    2.561400] 3dc0: ca146285 98246676 91960e97 ae4b29df 5ced41d1 c054fc40 c054f040 c054f840
> [    2.570031] 3de0: cf2f8554 00000000 d08d1ecc 180a9e88 0a1a0712 90b34fd7 00000000 0592803f
> [    2.578665] 3e00: 4f7a25ff c054fc40 c054f040 c054f840 cf2f8000 00000000 d08caffc 00003c00
> [    2.587296] 3e20: cf2f8000 cf32de00 00000000 0000000c cf2ec000 00000000 0000000c cf2f8554
> [    2.595928] 3e40: d08cb000 0001e000 00000000 d08cb000 00008000 00000000 00000000 0001e000
> [    2.604559] 3e60: 00000000 0000000c d08cb000 00000080 0000000c cf373f48 00000000 00000020
> [    2.613195] 3e80: 00008000 c026c35c 0001e000 cf32e000 cf32e000 d08cb000 0001e000 c0179a58
> [    2.621826] 3ea0: 0000000d c0177a48 0001e000 cf32e000 00000000 cf32eb20 0000000d c0179494
> [    2.630458] 3ec0: 00000000 cf32e000 00000000 cf32ea9c 00000000 c0175170 00000001 60000013
> [    2.639090] 3ee0: cf326800 00000000 00000000 00000000 cf373f48 00000000 00000020 c00c9e24
> [    2.647726] 3f00: 00100100 00200200 cf32ac40 00008000 cf372000 00208020 00000000 cf01a200
> [    2.656359] 3f20: cf326800 c00e3d6c 00000000 0000000c cf326840 00000000 c0013968 cf367e40
> [    2.664995] 3f40: 0000000c 00000000 cf01a210 ce828858 0000000c cf053000 000a18b4 00000000
> [    2.673632] 3f60: 00208020 c0013968 cf372000 00000000 00000003 c00e3e40 00000000 c0071e24
> [    2.682266] 3f80: 00000000 00000000 cf367e40 cf367ec0 a0000010 00000000 beb9bc58 b6fcb48c
> [    2.690898] 3fa0: 00000015 c00137c0 00000000 beb9bc58 000a18b4 000a18c0 000a18c2 00208020
> [    2.699531] 3fc0: 00000000 beb9bc58 b6fcb48c 00000015 00000000 00000000 00000000 00000003
> [    2.708166] 3fe0: b6f7df48 beb9bb54 00042994 b6f7df58 a0000010 000a18b4 00000000 00000000
> [    2.716814] [<c01e7228>] (crc32_le+0xf4/0x168) from [<cf2f8554>] (0xcf2f8554)
> [    2.724350] Code: e3520000 0a000008 e59da008 e28a1003 (e5f1c001)
> [    2.730825] ---[ end trace 9593089b6ffc6663 ]---

Can you probably enable kallsyms so that we'd see the stackdump?

-- 
Best Regards,
Artem Bityutskiy


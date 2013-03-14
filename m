Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756864Ab3CNLW3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 07:22:29 -0400
Received: from mga01.intel.com ([192.55.52.88]:31006 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756688Ab3CNLW2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 07:22:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,844,1355126400"; 
   d="scan'208";a="306435559"
Message-ID: <1363260202.11441.108.camel@sauron.fi.intel.com>
Subject: Re: MTD : Kernel oops when remounting ubifs as read/write
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Mark Jackson <mpfj-list@mimc.co.uk>
Cc: "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, adrian.hunter@intel.com
Date: Thu, 14 Mar 2013 13:23:22 +0200
In-Reply-To: <5141B154.6050504@mimc.co.uk>
References: <5134CEF9.5070502@mimc.co.uk>
	   <1363087506.3348.62.camel@sauron.fi.intel.com>
	   <51405F3A.3090901@mimc.co.uk>
	  <1363252425.11441.94.camel@sauron.fi.intel.com>
	  <51419E3A.8030007@mimc.co.uk>
	 <1363257009.11441.97.camel@sauron.fi.intel.com>
	 <5141B154.6050504@mimc.co.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3 (3.6.3-2.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-03-14 at 11:15 +0000, Mark Jackson wrote:
> [   28.538525] [d08ea004] *pgd=8f045811, *pte=00000000, *ppte=00000000
> [   28.545173] Internal error: Oops: 7 [#1] ARM
> [   28.549685] CPU: 0    Not tainted  (3.8.0-next-20130225-00002-g678576f-dirty #40)
> [   28.557595] PC is at crc32_le+0x50/0x168
> [   28.561735] LR is at ubi_eba_atomic_leb_change+0x1b4/0x410
> [   28.567523] pc : [<c01e7244>]    lr : [<c026dd9c>]    psr: 20000013
> [   28.567523] sp : cf385de0  ip : 180a985a  fp : c054f840
> [   28.579632] r10: c054f040  r9 : c054fc40  r8 : 158a1232
> [   28.585141] r7 : 4d506705  r6 : 9324fd72  r5 : 4dc8a10b  r4 : 4c162691
> [   28.592025] r3 : c054e040  r2 : c054f440  r1 : d08ea000  r0 : 4c8ee09f
> [   28.598912] Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
> [   28.606439] Control: 10c5387d  Table: 8f3b8019  DAC: 00000015
> [   28.612501] Process mount (pid: 659, stack limit = 0xcf384238)
> [   28.618652] Stack: (0xcf385de0 to 0xcf386000)
> [   28.623254] 5de0: cf2f8554 00000000 d08e6e8c 180a9e88 5a257c4f 58399ee9 c8d98a08 bb0ee864
> [   28.631886] 5e00: eae10678 c054fc40 c054f040 c054f840 cf2f8000 00000000 d08caffc 00003c00
> [   28.640517] 5e20: cf2f8000 cf357c00 00000000 0000000c cf2ec000 00000000 0000000c cf2f8554
> [   28.649148] 5e40: d08cb000 0001e000 00000000 d08cb000 00008000 00000000 00000000 0001e000
> [   28.657779] 5e60: 00000000 0000000c d08cb000 00000080 0000000c 0000000c 00000000 00000020
> [   28.666409] 5e80: 00008000 c026c41c 0001e000 cf330000 cf330000 d08cb000 0001e000 c0179b14
> [   28.675042] 5ea0: 0000000d c0177a68 0001e000 cf330000 00000000 cf330b20 0000000d c0179698
> [   28.683672] 5ec0: cf330000 00000000 cf330a9c 00000000 cf385f48 c0175170 00000001 60000013
> [   28.692303] 5ee0: cf32c800 00000000 00000000 00000000 cf385f48 00000000 00000020 c00c9e24
> [   28.700934] 5f00: 00100100 00200200 cf3a6c80 00008000 cf384000 00208020 00000000 cf01a200
> [   28.709564] 5f20: cf32c800 c00e3d6c 00000000 0000000c cf32c840 00000000 c0013968 cf31fb80
> [   28.718195] 5f40: 0000000c 00000000 cf01a210 ce828858 0000000c cf3ac000 000a18b4 00000000
> [   28.726827] 5f60: 00208020 c0013968 cf384000 00000000 00000003 c00e3e40 00000000 c0071e24
> [   28.735459] 5f80: 00000000 00000000 cf31fb80 cf31fbc0 a0000010 00000000 bed87b68 b6ff148c
> [   28.744091] 5fa0: 00000015 c00137c0 00000000 bed87b68 000a18b4 000a18c0 000a18c2 00208020
> [   28.752720] 5fc0: 00000000 bed87b68 b6ff148c 00000015 00000000 00000000 00000000 00000003
> [   28.761350] 5fe0: b6fa3f48 bed87a64 00042994 b6fa3f58 a0000010 000a18b4 00000000 00000000
> [   28.769989] [<c01e7244>] (crc32_le+0x50/0x168) from [<cf2f8000>] (0xcf2f8000)
> [   28.777522] Code: e58d8008 0a000026 e1a0c005 e58d2004 (e5916004)
> [   28.784029] ---[ end trace f50f53afffe647f1 ]---

OK, this is an independent problem which, as I think, has nothing to do
with the first one.

I do not know why crc32 oopses on your system. You need to investigate
this. I believe this is not UBI/UBIFS's fault.

One theory could be that UBI uses vmalloc'ed buffers for the atomic
update operation, and submits the buffer to the MTD layer for the I/O.
If your NAND driver is trying to DMA this memory, you may be in trouble,
because vmalloced memory is often not DMA-able on many systems,
especially ARM systems which do not have coherent cache support.

-- 
Best Regards,
Artem Bityutskiy


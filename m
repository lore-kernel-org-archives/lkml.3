Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757300Ab3CNMCr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 08:02:47 -0400
Received: from mercuryimc.plus.com ([80.229.200.144]:49538 "EHLO
	centos1.newflow.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750989Ab3CNMCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 08:02:45 -0400
Message-ID: <5141BC63.6060501@mimc.co.uk>
Date: Thu, 14 Mar 2013 12:02:43 +0000
From: Mark Jackson <mpfj-list@mimc.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: dedekind1@gmail.com
CC: "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, adrian.hunter@intel.com
Subject: Re: MTD : Kernel oops when remounting ubifs as read/write
References: <5134CEF9.5070502@mimc.co.uk>    <1363087506.3348.62.camel@sauron.fi.intel.com>    <51405F3A.3090901@mimc.co.uk>   <1363252425.11441.94.camel@sauron.fi.intel.com>   <51419E3A.8030007@mimc.co.uk>  <1363257009.11441.97.camel@sauron.fi.intel.com>  <5141B154.6050504@mimc.co.uk> <1363260202.11441.108.camel@sauron.fi.intel.com>
In-Reply-To: <1363260202.11441.108.camel@sauron.fi.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/03/13 11:23, Artem Bityutskiy wrote:
> On Thu, 2013-03-14 at 11:15 +0000, Mark Jackson wrote:
>> [   28.538525] [d08ea004] *pgd=8f045811, *pte=00000000, *ppte=00000000
>> [   28.545173] Internal error: Oops: 7 [#1] ARM
>> [   28.549685] CPU: 0    Not tainted  (3.8.0-next-20130225-00002-g678576f-dirty #40)
>> [   28.557595] PC is at crc32_le+0x50/0x168
>> [   28.561735] LR is at ubi_eba_atomic_leb_change+0x1b4/0x410
>> [   28.567523] pc : [<c01e7244>]    lr : [<c026dd9c>]    psr: 20000013
>> [   28.567523] sp : cf385de0  ip : 180a985a  fp : c054f840
>> [   28.579632] r10: c054f040  r9 : c054fc40  r8 : 158a1232
>> [   28.585141] r7 : 4d506705  r6 : 9324fd72  r5 : 4dc8a10b  r4 : 4c162691
>> [   28.592025] r3 : c054e040  r2 : c054f440  r1 : d08ea000  r0 : 4c8ee09f
>> [   28.598912] Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
>> [   28.606439] Control: 10c5387d  Table: 8f3b8019  DAC: 00000015
>> [   28.612501] Process mount (pid: 659, stack limit = 0xcf384238)
>> [   28.618652] Stack: (0xcf385de0 to 0xcf386000)
>> [   28.623254] 5de0: cf2f8554 00000000 d08e6e8c 180a9e88 5a257c4f 58399ee9 c8d98a08 bb0ee864
>> [   28.631886] 5e00: eae10678 c054fc40 c054f040 c054f840 cf2f8000 00000000 d08caffc 00003c00
>> [   28.640517] 5e20: cf2f8000 cf357c00 00000000 0000000c cf2ec000 00000000 0000000c cf2f8554
>> [   28.649148] 5e40: d08cb000 0001e000 00000000 d08cb000 00008000 00000000 00000000 0001e000
>> [   28.657779] 5e60: 00000000 0000000c d08cb000 00000080 0000000c 0000000c 00000000 00000020
>> [   28.666409] 5e80: 00008000 c026c41c 0001e000 cf330000 cf330000 d08cb000 0001e000 c0179b14
>> [   28.675042] 5ea0: 0000000d c0177a68 0001e000 cf330000 00000000 cf330b20 0000000d c0179698
>> [   28.683672] 5ec0: cf330000 00000000 cf330a9c 00000000 cf385f48 c0175170 00000001 60000013
>> [   28.692303] 5ee0: cf32c800 00000000 00000000 00000000 cf385f48 00000000 00000020 c00c9e24
>> [   28.700934] 5f00: 00100100 00200200 cf3a6c80 00008000 cf384000 00208020 00000000 cf01a200
>> [   28.709564] 5f20: cf32c800 c00e3d6c 00000000 0000000c cf32c840 00000000 c0013968 cf31fb80
>> [   28.718195] 5f40: 0000000c 00000000 cf01a210 ce828858 0000000c cf3ac000 000a18b4 00000000
>> [   28.726827] 5f60: 00208020 c0013968 cf384000 00000000 00000003 c00e3e40 00000000 c0071e24
>> [   28.735459] 5f80: 00000000 00000000 cf31fb80 cf31fbc0 a0000010 00000000 bed87b68 b6ff148c
>> [   28.744091] 5fa0: 00000015 c00137c0 00000000 bed87b68 000a18b4 000a18c0 000a18c2 00208020
>> [   28.752720] 5fc0: 00000000 bed87b68 b6ff148c 00000015 00000000 00000000 00000000 00000003
>> [   28.761350] 5fe0: b6fa3f48 bed87a64 00042994 b6fa3f58 a0000010 000a18b4 00000000 00000000
>> [   28.769989] [<c01e7244>] (crc32_le+0x50/0x168) from [<cf2f8000>] (0xcf2f8000)
>> [   28.777522] Code: e58d8008 0a000026 e1a0c005 e58d2004 (e5916004)
>> [   28.784029] ---[ end trace f50f53afffe647f1 ]---
> 
> OK, this is an independent problem which, as I think, has nothing to do
> with the first one.
> 
> I do not know why crc32 oopses on your system. You need to investigate
> this. I believe this is not UBI/UBIFS's fault.
> 
> One theory could be that UBI uses vmalloc'ed buffers for the atomic
> update operation, and submits the buffer to the MTD layer for the I/O.
> If your NAND driver is trying to DMA this memory, you may be in trouble,
> because vmalloced memory is often not DMA-able on many systems,
> especially ARM systems which do not have coherent cache support.

Hmmm ... bit stuck then !?!

I've added some debug in ubi_eba_atomic_leb_change(), to simply show the values being passed to
crc32(), and the crc is being called several times with the same buff memory pointer and a size
of 2048 bytes.

But there's also a call to crc with a size of 122880 bytes, and that's when the oops occurs.

Is this size larger than the allocated buffer ?

Regards
Mark J.
---
# mount -o remount,rw /
[   24.609350] UBIFS: start fixing up free space
[   24.613979] uffs 1
[   24.616098] ffs 1
[   24.618138] ffs 2
[   24.620250] fl 1 : lnum = 1, len = 2048
[   24.624740] fl 2
[   24.627010] uealc crc32 : d08cb000 2048
[   24.631153] uealc crc_x
[   24.636597] fl 1 : lnum = 2, len = 2048
[   24.641048] fl 2
[   24.643019] uealc crc32 : d08cb000 2048
[   24.647088] uealc crc_x
[   24.650789] ffs 3
[   24.652881] ffs 4
[   24.654911] fl 1 : lnum = 3, len = 2048
[   24.659316] fl 2
[   24.661278] uealc crc32 : d08cb000 2048
[   24.665336] uealc crc_x
[   24.672101] ffs 5
[   24.674146] fl 1 : lnum = 7, len = 2048
[   24.678543] fl 2
[   24.680505] uealc crc32 : d08cb000 2048
[   24.684574] uealc crc_x
[   24.688744] ffs 6
[   24.690801] ffs 7
[   24.692831] ffs 7a : lnum = 10
[   24.696386] ffs 7b
[   24.698560] ffs 7c
[   24.700682] ffs 7a : lnum = 11
[   24.703901] ffs 7b
[   24.706019] ffs 7c
[   24.708137] ffs 7a : lnum = 12
[   24.711384] ffs 7b
[   24.713503] ffs 7c
[   24.715622] ffs 7d : c->leb_size = 126976, lprops->free = 4096
[   24.721802] fl 1 : lnum = 12, len = 122880
[   24.741216] fl 2
[   24.743176] uealc crc32 : d08cb000 122880
[   24.747581] Unable to handle kernel paging request at virtual address e7938204
[   24.755199] pgd = cf408000
[   24.758052] [e7938204] *pgd=00000000
[   24.761833] Internal error: Oops: 5 [#1] ARM
[   24.766342] CPU: 0    Not tainted  (3.8.0-next-20130225-00002-g678576f-dirty #45)
[   24.774248] PC is at crc32_le+0xf8/0x168
[   24.778389] LR is at ubi_eba_atomic_leb_change+0x1d8/0x460
[   24.784177] pc : [<c01e734c>]    lr : [<c026de20>]    psr: 20000013
[   24.784177] sp : cf359e10  ip : 00003145  fp : c054f840
[   24.796285] r10: e7938104  r9 : c054fc40  r8 : af5e2a9e
[   24.801796] r7 : e59f3038  r6 : e59f0040  r5 : 00000040  r4 : 000000e5
[   24.808682] r3 : c054e040  r2 : 00000000  r1 : d08d05d0  r0 : 3e5ed77d
[   24.815570] Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
[   24.823097] Control: 10c5387d  Table: 8f408019  DAC: 00000015
[   24.829160] Process mount (pid: 659, stack limit = 0xcf358238)
[   24.835313] Stack: (0xcf359e10 to 0xcf35a000)
[   24.839912] 9e00:                                     d08cb000 00000000 d08caffc 00003c00
[   24.848543] 9e20: cf2f8000 00000000 cf2ec000 cf32da00 cf2f8554 00000000 0000000c d08cb000
[   24.857173] 9e40: d08cb000 c059f1f6 cf32da00 00000000 00000000 00000000 00000000 0001e000
[   24.865803] 9e60: cf32e000 0000000c d08cb000 00000080 0000000c cf3c8f88 00000000 00000020
[   24.874435] 9e80: 00008000 c026c47c 0001e000 cf359e9c cf32e000 d08cb000 0001e000 c0179b80
[   24.883066] 9ea0: cf390c80 00000001 0001e000 cf32e000 00000000 cf32eb20 0000000c c01796f0
[   24.891698] 9ec0: cf32e000 00000000 cf32ea9c 00000000 cf359f48 c0175170 00000001 60000013
[   24.900329] 9ee0: cf326800 00000000 00000000 00000000 cf359f48 00000000 00000020 c00c9e24
[   24.908963] 9f00: 00100100 00200200 cf390c80 00008000 cf358000 00208020 00000000 cf01a200
[   24.917595] 9f20: cf326800 c00e3d6c 00000000 0000000c cf326840 00000000 c0013968 cf3c4680
[   24.926227] 9f40: 0000000c 00000000 cf01a210 ce828858 0000000c cf3a4000 000a18b4 00000000
[   24.934859] 9f60: 00208020 c0013968 cf358000 00000000 00000003 c00e3e40 00000000 c0071e24
[   24.943491] 9f80: 00000000 00000000 cf3c4680 cf314540 a0000010 00000000 be984b68 b6fbc48c
[   24.952124] 9fa0: 00000015 c00137c0 00000000 be984b68 000a18b4 000a18c0 000a18c2 00208020
[   24.960757] 9fc0: 00000000 be984b68 b6fbc48c 00000015 00000000 00000000 00000000 00000003
[   24.969391] 9fe0: b6f6ef48 be984a64 00042994 b6f6ef58 a0000010 000a18b4 ebfecd47 00095348
[   24.978033] [<c01e734c>] (crc32_le+0xf8/0x168) from [<d08cb000>] (0xd08cb000)
[   24.985570] Code: 0a000008 e59da008 e28a1003 e5f1c001 (e2522001)
[   24.992006] ---[ end trace 1496ae984fb21f1a ]---
Segmentation fault


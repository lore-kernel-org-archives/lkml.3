Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932649Ab3CNOFJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 10:05:09 -0400
Received: from mercuryimc.plus.com ([80.229.200.144]:50179 "EHLO
	centos1.newflow.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757123Ab3CNOFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 10:05:07 -0400
Message-ID: <5141D351.8060901@mimc.co.uk>
Date: Thu, 14 Mar 2013 13:40:33 +0000
From: Mark Jackson <mpfj-list@mimc.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: dedekind1@gmail.com
CC: "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, adrian.hunter@intel.com
Subject: Re: MTD : Kernel oops when remounting ubifs as read/write
References: <5134CEF9.5070502@mimc.co.uk>  <1363087506.3348.62.camel@sauron.fi.intel.com>  <51405F3A.3090901@mimc.co.uk>  <1363252425.11441.94.camel@sauron.fi.intel.com>  <51419E3A.8030007@mimc.co.uk>  <1363257009.11441.97.camel@sauron.fi.intel.com>  <5141B154.6050504@mimc.co.uk>  <1363260202.11441.108.camel@sauron.fi.intel.com>  <5141BC63.6060501@mimc.co.uk>  <1363263529.11441.109.camel@sauron.fi.intel.com> <1363263812.11441.112.camel@sauron.fi.intel.com>
In-Reply-To: <1363263812.11441.112.camel@sauron.fi.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/03/13 12:23, Artem Bityutskiy wrote:
> On Thu, 2013-03-14 at 14:18 +0200, Artem Bityutskiy wrote:
>>> Is this size larger than the allocated buffer ?
>>
>> I believe so.
> 
> Err, I mean, the buffer is large enough. I do not believe there is a
> stupid bug like too small buffer. This code has worked for years and I
> do not think it was changes much.
> 
> The oops may be cause by memory corruption - some of your drivers may
> corrupt memory. You need to spend more time debugging this carefully.

It can handle 64k, but not 122880 bytes ...

# mount -o remount,rw /
[   19.208302] UBIFS: start fixing up free space
[   19.235881] uealc crc32 : d08cb000 2048
[   19.240015] uealc crc32 : d08cb000 4096
[   19.244091] uealc crc32 : d08cb000 8192
[   19.248184] uealc crc32 : d08cb000 16384
[   19.252448] uealc crc32 : d08cb000 32768
[   19.256772] uealc crc32 : d08cb000 65536
[   19.260133] uealc crc32 : d08cb000 122880
[   19.261117] Unable to handle kernel paging request at virtual address e79381bc
[   19.268741] pgd = cf40c000
[   19.271598] [e79381bc] *pgd=00000000
[   19.275387] Internal error: Oops: 5 [#1] ARM
[   19.279902] CPU: 0    Not tainted  (3.8.0-next-20130225-00002-g678576f-dirty #47)
[   19.287819] PC is at crc32_le+0xf8/0x168
[   19.291965] LR is at ubi_eba_atomic_leb_change+0x3ac/0x4f8
[   19.297760] pc : [<c01e724c>]    lr : [<c026def4>]    psr: 20000013
[   19.297760] sp : cf3bbe08  ip : 00000e4e  fp : c054f840
[   19.309882] r10: e7938104  r9 : c054fc40  r8 : 65e95c1c
[   19.315396] r7 : 322e315f  r6 : 352e332e  r5 : 0000002e  r4 : 00000035
[   19.322288] r3 : c054e040  r2 : 00000033  r1 : d08d3d90  r0 : 63c3884e
[   19.329180] Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
[   19.336713] Control: 10c5387d  Table: 8f40c019  DAC: 00000015
[   19.342781] Process mount (pid: 659, stack limit = 0xcf3ba238)
[   19.348939] Stack: (0xcf3bbe08 to 0xcf3bc000)
[   19.353542] be00:                   cf2f8554 00000000 d08caffc 00002000 cf2f8000 cf357a00
[   19.362183] be20: 00000000 0000000c cf2ec000 00000000 0000000c cf2f8554 00000000 00000000
[   19.370823] be40: d08cb000 d08cb000 00000000 07000000 00008000 c026c168 00000000 0001e000
[   19.379463] be60: 00000000 0000000c d08cb000 00000080 0000000c cf3bbf48 00000000 00000020
[   19.388101] be80: 00008000 c026c37c 0001e000 cf330000 cf330000 d08cb000 0001e000 c0179a78
[   19.396738] bea0: 0000000d c0177a68 0001e000 cf330000 00000000 cf330b20 0000000d c01794b4
[   19.405376] bec0: 00000000 cf330000 00000000 cf330a9c 00000000 c0175170 00000001 60000013
[   19.414012] bee0: cf32c800 00000000 00000000 00000000 cf3bbf48 00000000 00000020 c00c9e24
[   19.422648] bf00: 00100100 00200200 cf390300 00008000 cf3ba000 00208020 00000000 cf01a200
[   19.431284] bf20: cf32c800 c00e3d6c 00000000 0000000c cf32c840 00000000 c0013968 cf325800
[   19.439921] bf40: 0000000c 00000000 cf01a210 ce828858 0000000c cf053000 000a18b4 00000000
[   19.448559] bf60: 00208020 c0013968 cf3ba000 00000000 00000003 c00e3e40 00000000 c0071e24
[   19.457197] bf80: 00000000 00000000 cf325800 cf328380 a0000010 00000000 beb83b68 b6f8348c
[   19.465838] bfa0: 00000015 c00137c0 00000000 beb83b68 000a18b4 000a18c0 000a18c2 00208020
[   19.474475] bfc0: 00000000 beb83b68 b6f8348c 00000015 00000000 00000000 00000000 00000003
[   19.483108] bfe0: b6f35f48 beb83a64 00042994 b6f35f58 a0000010 000a18b4 00000000 00000000
[   19.491758] [<c01e724c>] (crc32_le+0xf8/0x168) from [<00000000>] (  (null))
[   19.499115] Code: 0a000008 e59da008 e28a1003 e5f1c001 (e2522001)
[   19.505555] ---[ end trace 84a04423f0bc8388 ]---

> Do you have fastmap UBI feature enabled?

No ...

#
# LPDDR flash memory drivers
#
# CONFIG_MTD_LPDDR is not set
CONFIG_MTD_UBI=y
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_LIMIT=20
# CONFIG_MTD_UBI_FASTMAP is not set
# CONFIG_MTD_UBI_GLUEBI is not set
CONFIG_DTC=y
CONFIG_OF=y


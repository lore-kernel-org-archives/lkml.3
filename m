Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151AbaAUJoh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 04:44:37 -0500
Received: from cnbjrel02.sonyericsson.com ([219.141.167.166]:1678 "EHLO
	cnbjrel02.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751613AbaAUJob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 04:44:31 -0500
X-Greylist: delayed 604 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 Jan 2014 04:44:29 EST
From: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
CC: "Duan, Yongjian" <Yongjian.Duan@sonymobile.com>,
        "Hang, Xuliang (EXT)" <Xuliang.Hang@sonymobile.com>,
        "Zhang, Bojie" <Bojie.Zhang@sonymobile.com>
Date: Tue, 21 Jan 2014 17:34:21 +0800
Subject: bug fix for mmc  queue.c
Thread-Topic: bug fix for mmc  queue.c
Thread-Index: Ac75iZoxlUJlRd/8Tyi2WPv/8Vfo+Ac/329w
Message-ID: <35FD53F367049845BC99AC72306C23D1023A478B1AEC@CNBJMBX05.corpusers.net>
References: <1386718996-3733-1-git-send-email-sboyd@codeaurora.org>
 <1386718996-3733-3-git-send-email-sboyd@codeaurora.org>
 <20131215113337.GB14818@core.coreip.homeip.net>
In-Reply-To: <20131215113337.GB14818@core.coreip.homeip.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: multipart/mixed;
	boundary="_002_35FD53F367049845BC99AC72306C23D1023A478B1AECCNBJMBX05co_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_35FD53F367049845BC99AC72306C23D1023A478B1AECCNBJMBX05co_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi =20

We encounter a problem when use sdcard ,
The driver probe will failed like this :

<6>[  121.644102] mmc0: mmc_start_bkops: Starting bkops
<6>[  133.039845] mmc0: mmc_start_bkops: raw_bkops_status=3D0x2, from_excep=
tion=3D0
<6>[  133.039888] mmc0: mmc_start_bkops: Starting bkops
<6>[  147.931642] mmc0: mmc_start_bkops: raw_bkops_status=3D0x2, from_excep=
tion=3D1
<6>[  148.634009] mmc0: mmc_start_bkops: Starting bkops
<6>[  164.279748] mmc1: slot status change detected (0 -> 1), GPIO_ACTIVE_L=
OW
<6>[  164.612904] mmc1: new high speed SD card at address 1234
<4>[  164.620819] kworker/u:29: page allocation failure: order:5, mode:0x40=
d0
<6>[  164.629745] [<c010c514>] (unwind_backtrace+0x0/0x11c) from [<c0217e78=
>] (warn_alloc_failed+0x104/0x130)
<6>[  164.629789] [<c0217e78>] (warn_alloc_failed+0x104/0x130) from [<c021b=
39c>] (__alloc_pages_nodemask+0x7d4/0x8f4)
<6>[  164.629828] [<c021b39c>] (__alloc_pages_nodemask+0x7d4/0x8f4) from [<=
c021b510>] (__get_free_pages+0x10/0x24)
<6>[  164.629867] [<c021b510>] (__get_free_pages+0x10/0x24) from [<c0246630=
>] (kmalloc_order_trace+0x20/0xe0)
<6>[  164.629904] [<c0246630>] (kmalloc_order_trace+0x20/0xe0) from [<c0249=
550>] (__kmalloc+0x30/0x270)
<6>[  164.629939] [<c0249550>] (__kmalloc+0x30/0x270) from [<c061cdbc>] (mm=
c_alloc_sg+0x18/0x40)
<6>[  164.629974] [<c061cdbc>] (mmc_alloc_sg+0x18/0x40) from [<c061d524>] (=
mmc_init_queue+0x418/0x4fc)
<6>[  164.630008] [<c061d524>] (mmc_init_queue+0x418/0x4fc) from [<c06195a0=
>] (mmc_blk_alloc_req+0x18c/0x3d0)
<6>[  164.630043] [<c06195a0>] (mmc_blk_alloc_req+0x18c/0x3d0) from [<c061b=
2a8>] (mmc_blk_probe+0x74/0x2c0)
<6>[  164.630078] [<c061b2a8>] (mmc_blk_probe+0x74/0x2c0) from [<c060d68c>]=
 (mmc_bus_probe+0x14/0x18)
<6>[  164.630115] [<c060d68c>] (mmc_bus_probe+0x14/0x18) from [<c045a928>] =
(driver_probe_device+0x134/0x334)
<6>[  164.630154] [<c045a928>] (driver_probe_device+0x134/0x334) from [<c04=
58e0c>] (bus_for_each_drv+0x48/0x8c)
<6>[  164.630190] [<c0458e0c>] (bus_for_each_drv+0x48/0x8c) from [<c045a77c=
>] (device_attach+0x7c/0xa0)
<6>[  164.630222] [<c045a77c>] (device_attach+0x7c/0xa0) from [<c0459ca0>] =
(bus_probe_device+0x28/0x98)
<6>[  164.630257] [<c0459ca0>] (bus_probe_device+0x28/0x98) from [<c04583f0=
>] (device_add+0x3f4/0x5a8)
<6>[  164.630292] [<c04583f0>] (device_add+0x3f4/0x5a8) from [<c060dd7c>] (=
mmc_add_card+0x1f0/0x2e8)
<6>[  164.630329] [<c060dd7c>] (mmc_add_card+0x1f0/0x2e8) from [<c0613990>]=
 (mmc_attach_sd+0x234/0x278)
<6>[  164.630364] [<c0613990>] (mmc_attach_sd+0x234/0x278) from [<c060cab8>=
] (mmc_rescan+0x24c/0x2cc)
<6>[  164.630400] [<c060cab8>] (mmc_rescan+0x24c/0x2cc) from [<c01a2a40>] (=
process_one_work+0x200/0x400)
<6>[  164.630438] [<c01a2a40>] (process_one_work+0x200/0x400) from [<c01a2d=
f0>] (worker_thread+0x184/0x2a4)
<6>[  164.630474] [<c01a2df0>] (worker_thread+0x184/0x2a4) from [<c01a74ac>=
] (kthread+0x80/0x90)
<6>[  164.630510] [<c01a74ac>] (kthread+0x80/0x90) from [<c0106aec>] (kerne=
l_thread_exit+0x0/0x8)
<6>[  164.630529] Mem-info:
<6>[  164.630542] Normal per-cpu:
<6>[  164.630559] CPU    0: hi:  186, btch:  31 usd:   0
<6>[  164.630573] HighMem per-cpu:
<6>[  164.630588] CPU    0: hi:   90, btch:  15 usd:   0
<6>[  164.630624] active_anon:96301 inactive_anon:586 isolated_anon:4
<6>[  164.630633]  active_file:26021 inactive_file:25748 isolated_file:0
<6>[  164.630641]  unevictable:694 dirty:4 writeback:0 unstable:0
<6>[  164.630649]  free:5131 slab_reclaimable:3282 slab_unreclaimable:5632
<6>[  164.630658]  mapped:36273 shmem:649 pagetables:3794 bounce:0
<6>[  164.630666]  free_cma:139
<6>[  164.630716] Normal free:18660kB min:3136kB low:3920kB high:4704kB act=
ive_anon:183052kB inactive_anon:1980kB active_file:98188kB inactive_file:98=
364kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:616020k=
B mlocked:0kB dirty:8kB writeback:0kB mapped:134632kB shmem:1992kB slab_rec=
laimable:13128kB slab_unreclaimable:22528kB kernel_stack:10528kB pagetables=
:15176kB unstable:0kB bounce:0kB free_cma:112kB writeback_tmp:0kB pages_sca=
nned:0 all_unreclaimable? no
<6>[  164.630769] lowmem_reserve[]: 0 1691 1691
<6>[  164.630831] HighMem free:1864kB min:208kB low:480kB high:756kB active=
_anon:202152kB inactive_anon:364kB active_file:5896kB inactive_file:4628kB =
unevictable:2776kB isolated(anon):16kB isolated(file):0kB present:216488kB =
mlocked:0kB dirty:8kB writeback:0kB mapped:10460kB shmem:604kB slab_reclaim=
able:0kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0k=
B bounce:0kB free_cma:444kB writeback_tmp:0kB pages_scanned:0 all_unreclaim=
able? no
<6>[  164.630883] lowmem_reserve[]: 0 0 0
<6>[  164.630913] Normal: 1215*4kB (UEMC) 421*8kB (UEMC) 396*16kB (UM) 114*=
32kB (UM) 7*64kB (UM) 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB =
=3D 18660kB
<6>[  164.631034] HighMem: 190*4kB (UMRC) 26*8kB (UMRC) 9*16kB (UMC) 1*32kB=
 (C) 0*64kB 1*128kB (C) 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB =3D 1272=
kB
<6>[  164.631154] 53112 total pagecache pages
<6>[  164.631167] 0 pages in swap cache
<6>[  164.631183] Swap cache stats: add 0, delete 0, find 0/0
<6>[  164.631197] Free swap  =3D 0kB
<6>[  164.631209] Total swap =3D 0kB
<6>[  164.648069] 230912 pages of RAM
<6>[  164.648087] 12304 free pages
<6>[  164.648099] 30954 reserved pages
<6>[  164.648111] 5947 slab pages
<6>[  164.648123] 358720 pages shared
<6>[  164.648135] 0 pages swap cached
<4>[  164.648468] mmcblk: probe of mmc1:1234 failed with error -12



The reason is that mmc_alloc_sg() function will use kmalloc to init=20
Scatterlist , in this issue, it is 32KB memory , the kmalloc will fail if t=
here is
Not enough low memory ,  instead, we can use vmalloc if the request memory =
is larger than
A PAGE_SIZE , we make a patch for this problems  (see attachment patch.diff=
) ,
Hope can  be merged into mainline .


Thanks=20





--_002_35FD53F367049845BC99AC72306C23D1023A478B1AECCNBJMBX05co_
Content-Type: application/octet-stream; name="patch.diff"
Content-Description: patch.diff
Content-Disposition: attachment; filename="patch.diff"; size=2508;
	creation-date="Tue, 21 Jan 2014 09:33:45 GMT";
	modification-date="Tue, 21 Jan 2014 09:33:16 GMT"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbW1jL2NhcmQvcXVldWUuYyBiL2RyaXZlcnMvbW1jL2NhcmQv
cXVldWUuYwppbmRleCBjZWYxYTQxLi44MzliNTA2IDEwMDY0NAotLS0gYS9kcml2ZXJzL21tYy9j
YXJkL3F1ZXVlLmMKKysrIGIvZHJpdmVycy9tbWMvY2FyZC9xdWV1ZS5jCkBAIC0xNSw2ICsxNSw3
IEBACiAjaW5jbHVkZSA8bGludXgvZnJlZXplci5oPgogI2luY2x1ZGUgPGxpbnV4L2t0aHJlYWQu
aD4KICNpbmNsdWRlIDxsaW51eC9zY2F0dGVybGlzdC5oPgorI2luY2x1ZGUgPGxpbnV4L3ZtYWxs
b2MuaD4KIAogI2luY2x1ZGUgPGxpbnV4L21tYy9jYXJkLmg+CiAjaW5jbHVkZSA8bGludXgvbW1j
L2hvc3QuaD4KQEAgLTE5OCw4ICsxOTksMTMgQEAgc3RhdGljIHZvaWQgbW1jX3VyZ2VudF9yZXF1
ZXN0KHN0cnVjdCByZXF1ZXN0X3F1ZXVlICpxKQogc3RhdGljIHN0cnVjdCBzY2F0dGVybGlzdCAq
bW1jX2FsbG9jX3NnKGludCBzZ19sZW4sIGludCAqZXJyKQogewogCXN0cnVjdCBzY2F0dGVybGlz
dCAqc2c7CisJc2l6ZV90IHNpemUgPSBzaXplb2Yoc3RydWN0IHNjYXR0ZXJsaXN0KSpzZ19sZW47
CisKKwlpZiAoc2l6ZSA+IFBBR0VfU0laRSkKKwkJc2cgPSB2bWFsbG9jKHNpemUpOworCWVsc2UK
KwkJc2cgPSBrbWFsbG9jKHNpemUsIEdGUF9LRVJORUwpOwogCi0Jc2cgPSBrbWFsbG9jKHNpemVv
ZihzdHJ1Y3Qgc2NhdHRlcmxpc3QpKnNnX2xlbiwgR0ZQX0tFUk5FTCk7CiAJaWYgKCFzZykKIAkJ
KmVyciA9IC1FTk9NRU07CiAJZWxzZSB7CkBAIC0yMTAsNiArMjE2LDE0IEBAIHN0YXRpYyBzdHJ1
Y3Qgc2NhdHRlcmxpc3QgKm1tY19hbGxvY19zZyhpbnQgc2dfbGVuLCBpbnQgKmVycikKIAlyZXR1
cm4gc2c7CiB9CiAKK3N0YXRpYyB2b2lkIG1tY19hbGxvY19mcmVlKGNvbnN0IHZvaWQgKmFkZHIp
Cit7CisJaWYgKGlzX3ZtYWxsb2NfYWRkcihhZGRyKSkKKwkJdmZyZWUoYWRkcik7CisJZWxzZQor
CQlrZnJlZShhZGRyKTsKK30KKwogc3RhdGljIHZvaWQgbW1jX3F1ZXVlX3NldHVwX2Rpc2NhcmQo
c3RydWN0IHJlcXVlc3RfcXVldWUgKnEsCiAJCQkJICAgIHN0cnVjdCBtbWNfY2FyZCAqY2FyZCkK
IHsKQEAgLTM5NywyMCArNDExLDIwIEBAIHN1Y2Nlc3M6CiAKIAlyZXR1cm4gMDsKICBmcmVlX2Jv
dW5jZV9zZzoKLQlrZnJlZShtcXJxX2N1ci0+Ym91bmNlX3NnKTsKKwltbWNfYWxsb2NfZnJlZSht
cXJxX2N1ci0+Ym91bmNlX3NnKTsKIAltcXJxX2N1ci0+Ym91bmNlX3NnID0gTlVMTDsKLQlrZnJl
ZShtcXJxX3ByZXYtPmJvdW5jZV9zZyk7CisJbW1jX2FsbG9jX2ZyZWUobXFycV9wcmV2LT5ib3Vu
Y2Vfc2cpOwogCW1xcnFfcHJldi0+Ym91bmNlX3NnID0gTlVMTDsKIAogIGNsZWFudXBfcXVldWU6
Ci0Ja2ZyZWUobXFycV9jdXItPnNnKTsKKwltbWNfYWxsb2NfZnJlZShtcXJxX2N1ci0+c2cpOwog
CW1xcnFfY3VyLT5zZyA9IE5VTEw7Ci0Ja2ZyZWUobXFycV9jdXItPmJvdW5jZV9idWYpOworCW1t
Y19hbGxvY19mcmVlKG1xcnFfY3VyLT5ib3VuY2VfYnVmKTsKIAltcXJxX2N1ci0+Ym91bmNlX2J1
ZiA9IE5VTEw7CiAKLQlrZnJlZShtcXJxX3ByZXYtPnNnKTsKKwltbWNfYWxsb2NfZnJlZShtcXJx
X3ByZXYtPnNnKTsKIAltcXJxX3ByZXYtPnNnID0gTlVMTDsKLQlrZnJlZShtcXJxX3ByZXYtPmJv
dW5jZV9idWYpOworCW1tY19hbGxvY19mcmVlKG1xcnFfcHJldi0+Ym91bmNlX2J1Zik7CiAJbXFy
cV9wcmV2LT5ib3VuY2VfYnVmID0gTlVMTDsKIAogCWJsa19jbGVhbnVwX3F1ZXVlKG1xLT5xdWV1
ZSk7CkBAIC00MzYsMjIgKzQ1MCwyMiBAQCB2b2lkIG1tY19jbGVhbnVwX3F1ZXVlKHN0cnVjdCBt
bWNfcXVldWUgKm1xKQogCWJsa19zdGFydF9xdWV1ZShxKTsKIAlzcGluX3VubG9ja19pcnFyZXN0
b3JlKHEtPnF1ZXVlX2xvY2ssIGZsYWdzKTsKIAotCWtmcmVlKG1xcnFfY3VyLT5ib3VuY2Vfc2cp
OworCW1tY19hbGxvY19mcmVlKG1xcnFfY3VyLT5ib3VuY2Vfc2cpOwogCW1xcnFfY3VyLT5ib3Vu
Y2Vfc2cgPSBOVUxMOwogCi0Ja2ZyZWUobXFycV9jdXItPnNnKTsKKwltbWNfYWxsb2NfZnJlZSht
cXJxX2N1ci0+c2cpOwogCW1xcnFfY3VyLT5zZyA9IE5VTEw7CiAKLQlrZnJlZShtcXJxX2N1ci0+
Ym91bmNlX2J1Zik7CisJbW1jX2FsbG9jX2ZyZWUobXFycV9jdXItPmJvdW5jZV9idWYpOwogCW1x
cnFfY3VyLT5ib3VuY2VfYnVmID0gTlVMTDsKIAotCWtmcmVlKG1xcnFfcHJldi0+Ym91bmNlX3Nn
KTsKKwltbWNfYWxsb2NfZnJlZShtcXJxX3ByZXYtPmJvdW5jZV9zZyk7CiAJbXFycV9wcmV2LT5i
b3VuY2Vfc2cgPSBOVUxMOwogCi0Ja2ZyZWUobXFycV9wcmV2LT5zZyk7CisJbW1jX2FsbG9jX2Zy
ZWUobXFycV9wcmV2LT5zZyk7CiAJbXFycV9wcmV2LT5zZyA9IE5VTEw7CiAKLQlrZnJlZShtcXJx
X3ByZXYtPmJvdW5jZV9idWYpOworCW1tY19hbGxvY19mcmVlKG1xcnFfcHJldi0+Ym91bmNlX2J1
Zik7CiAJbXFycV9wcmV2LT5ib3VuY2VfYnVmID0gTlVMTDsKIAogCW1xLT5jYXJkID0gTlVMTDsK

--_002_35FD53F367049845BC99AC72306C23D1023A478B1AECCNBJMBX05co_--

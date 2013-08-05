Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754927Ab3HEU11 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 16:27:27 -0400
Received: from mail-gh0-f175.google.com ([209.85.160.175]:34692 "EHLO
	mail-gh0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754694Ab3HEU1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 16:27:25 -0400
X-Greylist: delayed 376 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Aug 2013 16:27:25 EDT
Date: Mon, 5 Aug 2013 16:27:20 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: linux-kernel@vger.kernel.org
cc: Will Deacon <will.deacon@arm.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: perf,arm -- oops in validate_event
Message-ID: <alpine.DEB.2.10.1308051622270.28589@vincent-weaver-1.um.maine.edu>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-1286696140-1375734447=:28589"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1286696140-1375734447=:28589
Content-Type: TEXT/PLAIN; charset=US-ASCII


My perf_fuzzer quickly triggers this oops on my ARM Cortex A9 pandaboard
running Linux 3.11-rc4.

Below is the oops, I've attached a simple C test case that triggers the 
bug.

Vince


[ 8110.698669] Unable to handle kernel paging request at virtual address fffffffe
[ 8110.706390] pgd = ecd88000
[ 8110.708251] [fffffffe] *pgd=ae7f6821, *pte=00000000, *ppte=00000000
[ 8110.715820] Internal error: Oops: 80000007 [#2] SMP ARM
[ 8110.716033] Modules linked in: bluetooth snd_soc_omap_hdmi omapdss snd_soc_omap_abe_twl6040 snd_soc_twl6040 snd_soc_omap_hdmi_card snd_soc_omap snd_soc_omap_mcpdm snd_soc_omap_mcbsp snd_soc_core snd_compress regmap_spi snd_pcm snd_page_alloc snd_timer snd soundcore
[ 8110.743133] CPU: 1 PID: 28431 Comm: perf_fuzzer Tainted: G      D      3.11.0-rc4 #4
[ 8110.743133] task: edab8100 ti: ece5c000 task.ti: ece5c000
[ 8110.760681] PC is at 0xfffffffe
[ 8110.760681] LR is at validate_event+0x3c/0x50
[ 8110.766906] pc : [<fffffffe>]    lr : [<c001bf9c>]    psr: 20000033
[ 8110.766906] sp : ece5de40  ip : edfbd960  fp : edfbd800
[ 8110.775238] r10: 00000000  r9 : 00000000  r8 : ed8c3ec0
[ 8110.781066] r7 : ed8c3f5c  r6 : edfbd800  r5 : ecaed000  r4 : ece5de4c
[ 8110.791107] r3 : ffffffff  r2 : 000000d9  r1 : ecaed000  r0 : ece5de50
[ 8110.791107] Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA Thumb  Segment user
[ 8110.803924] Control: 10c5387d  Table: acd8804a  DAC: 00000015
[ 8110.814239] Process perf_fuzzer (pid: 28431, stack limit = 0xece5c240)
[ 8110.821197] Stack: (0xece5de40 to 0xece5e000)
[ 8110.821197] de40: 00000000 c001c280 00000002 00000000 00000001 ece5de4c 00000000 c00bf058
[ 8110.831085] de60: 00000000 c008626c 00000000 00000000 00000000 edfbd800 ed8c3ec0 edfbd800
[ 8110.831085] de80: 00000000 c073ffac ece5df20 c00bf160 00000001 00000000 c00bf058 ece5df20
[ 8110.851959] dea0: 00000000 ed8c3ec0 00000000 00000000 00000000 c0cb0818 edab8100 c00bf420
[ 8110.860656] dec0: ece5df20 00000000 edab8100 ecaed000 00000000 00000000 00000000 00000000
[ 8110.862182] dee0: 00000000 ecad5680 edab8100 c00bfe48 00000000 00000000 00000000 c073e7c0
[ 8110.862182] df00: 00000000 ece5c000 c15036e8 ece5c030 00000005 c06eb5c0 6b139c44 00000000
[ 8110.879913] df20: 00000004 00000050 8dfff7d3 00000000 00000000 00000000 00000000 00000000
[ 8110.895507] df40: 00000000 00000000 001d4a0b 00000000 00000000 00000000 00000000 00000000
[ 8110.901062] df60: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[ 8110.911102] df80: 00000000 00000000 00090990 000103a4 0000016c c00128e8 ece5c000 00000000
[ 8110.921112] dfa0: 000107a0 c0012700 00000000 00090990 00090bd0 00000000 00000000 00000004
[ 8110.921112] dfc0: 00000000 00090990 000103a4 0000016c 00090bd0 00090bc8 00090998 000107a0
[ 8110.931060] dfe0: beab7be0 beab7bd0 0000b6c9 b6f016d0 40000010 00090bd0 00000000 00000000
[ 8110.941009] [<c001bf9c>] (validate_event+0x3c/0x50) from [<c001c280>] (armpmu_event_init+0x16c/0x280)
[ 8110.953247] [<c001c280>] (armpmu_event_init+0x16c/0x280) from [<c00bf160>] (perf_init_event+0x108/0x180)
[ 8110.967712] [<c00bf160>] (perf_init_event+0x108/0x180) from [<c00bf420>] (perf_event_alloc+0x248/0x40c)
[ 8110.971069] [<c00bf420>] (perf_event_alloc+0x248/0x40c) from [<c00bfe48>] (SyS_perf_event_open+0x4f4/0x8fc)
[ 8110.981048] [<c00bfe48>] (SyS_perf_event_open+0x4f4/0x8fc) from [<c0012700>] (ret_fast_syscall+0x0/0x48)
[ 8110.998199] Code: bad PC value
[ 8111.001495] ---[ end trace 0e6c892fae28bee4 ]---
--8323329-1286696140-1375734447=:28589
Content-Type: TEXT/x-csrc; name=arm_perf_oops.c
Content-Transfer-Encoding: BASE64
Content-ID: <alpine.DEB.2.10.1308051627200.28589@vincent-weaver-1.um.maine.edu>
Content-Description: 
Content-Disposition: attachment; filename=arm_perf_oops.c

LyogbG9nX3RvX2NvZGUgb3V0cHV0IGZyb20gb3V0NCAqLw0KLyogYnkgVmlu
Y2UgV2VhdmVyIDx2aW5jZW50LndlYXZlciBfYXRfIG1haW5lLmVkdSAqLw0K
DQojaW5jbHVkZSA8c3RkaW8uaD4NCiNpbmNsdWRlIDx1bmlzdGQuaD4NCiNp
bmNsdWRlIDxzdHJpbmcuaD4NCiNpbmNsdWRlIDxzaWduYWwuaD4NCiNpbmNs
dWRlIDxzeXMvbW1hbi5oPg0KI2luY2x1ZGUgPHN5cy9zeXNjYWxsLmg+DQoj
aW5jbHVkZSA8c3lzL2lvY3RsLmg+DQojaW5jbHVkZSA8c3lzL3ByY3RsLmg+
DQojaW5jbHVkZSA8bGludXgvaHdfYnJlYWtwb2ludC5oPg0KI2luY2x1ZGUg
PGxpbnV4L3BlcmZfZXZlbnQuaD4NCg0KaW50IGZkWzEwMjRdOw0Kc3RydWN0
IHBlcmZfZXZlbnRfYXR0ciBwZVsxMDI0XTsNCmNoYXIgKm1tYXBfcmVzdWx0
WzEwMjRdOw0KI2RlZmluZSBNQVhfUkVBRF9TSVpFIDY1NTM2DQpzdGF0aWMg
bG9uZyBsb25nIGRhdGFbTUFYX1JFQURfU0laRV07DQoNCmludCBmb3JrZWRf
cGlkOw0KDQppbnQgcGVyZl9ldmVudF9vcGVuKHN0cnVjdCBwZXJmX2V2ZW50
X2F0dHIgKmh3X2V2ZW50X3VwdHIsDQoJcGlkX3QgcGlkLCBpbnQgY3B1LCBp
bnQgZ3JvdXBfZmQsIHVuc2lnbmVkIGxvbmcgZmxhZ3MpIHsNCg0KCXJldHVy
biBzeXNjYWxsKF9fTlJfcGVyZl9ldmVudF9vcGVuLGh3X2V2ZW50X3VwdHIs
IHBpZCwgY3B1LA0KCQlncm91cF9mZCwgZmxhZ3MpOw0KfQ0KDQppbnQgbWFp
bihpbnQgYXJnYywgY2hhciAqKmFyZ3YpIHsNCg0KICAgICAgICBtZW1zZXQo
JnBlWzVdLDAsc2l6ZW9mKHN0cnVjdCBwZXJmX2V2ZW50X2F0dHIpKTsNCiAg
ICAgICAgcGVbNV0udHlwZT1QRVJGX1RZUEVfU09GVFdBUkU7DQogICAgICAg
IHBlWzVdLnNpemU9ODA7DQogICAgICAgIHBlWzVdLmNvbmZpZz1QRVJGX0NP
VU5UX1NXX1RBU0tfQ0xPQ0s7DQogICAgICAgIHBlWzVdLnNhbXBsZV90eXBl
PTA7IC8qIDAgKi8NCiAgICAgICAgcGVbNV0ucmVhZF9mb3JtYXQ9UEVSRl9G
T1JNQVRfVE9UQUxfVElNRV9SVU5OSU5HfFBFUkZfRk9STUFUX0dST1VQOyAv
KiBcDQphICovDQogICAgICAgIHBlWzVdLmRpc2FibGVkPTE7DQoJcGVbNV0u
ZXhjbHVzaXZlPTE7DQogICAgICAgIHBlWzVdLmV4Y2x1ZGVfdXNlcj0xOw0K
CXBlWzVdLmV4Y2x1ZGVfa2VybmVsPTE7DQogICAgICAgIHBlWzVdLm1tYXA9
MTsNCiAgICAgICAgcGVbNV0uaW5oZXJpdF9zdGF0PTE7DQogICAgICAgIHBl
WzVdLmVuYWJsZV9vbl9leGVjPTE7DQogICAgICAgIHBlWzVdLndhdGVybWFy
az0xOw0KICAgICAgICBwZVs1XS5wcmVjaXNlX2lwPTE7IC8qIGNvbnN0YW50
IHNraWQgKi8NCglwZVs1XS5tbWFwX2RhdGE9MTsNCiAgICAgICAgcGVbNV0u
c2FtcGxlX2lkX2FsbD0xOw0KICAgICAgICBwZVs1XS5leGNsdWRlX2d1ZXN0
PTE7DQoJcGVbNV0ud2FrZXVwX3dhdGVybWFyaz0wOw0KICAgICAgICBwZVs1
XS5icF90eXBlPUhXX0JSRUFLUE9JTlRfRU1QVFk7DQoNCiAgICAgICAgZmRb
NV09cGVyZl9ldmVudF9vcGVuKCZwZVs1XSwwLDAsLTEsMCAvKjAqLyApOw0K
DQoJbWVtc2V0KCZwZVswXSwwLHNpemVvZihzdHJ1Y3QgcGVyZl9ldmVudF9h
dHRyKSk7DQoJcGVbMF0udHlwZT1QRVJGX1RZUEVfUkFXOw0KCXBlWzBdLnNp
emU9ODA7DQoJcGVbMF0uY29uZmlnPTB4OGRmZmY3ZDM7DQoJcGVbMF0uc2Ft
cGxlX3R5cGU9MDsgLyogMCAqLw0KCXBlWzBdLnJlYWRfZm9ybWF0PTB4MFVM
TDsgLyogMCAqLw0KCXBlWzBdLmRpc2FibGVkPTE7DQoJcGVbMF0uaW5oZXJp
dD0xOw0KCXBlWzBdLmV4Y2x1c2l2ZT0xOw0KCXBlWzBdLmNvbW09MTsNCglw
ZVswXS5pbmhlcml0X3N0YXQ9MTsNCglwZVswXS53YXRlcm1hcms9MTsNCglw
ZVswXS5wcmVjaXNlX2lwPTI7IC8qIHJlcXVlc3QgemVybyBza2lkICovDQoJ
cGVbMF0uc2FtcGxlX2lkX2FsbD0xOw0KCXBlWzBdLmV4Y2x1ZGVfaG9zdD0x
Ow0KCXBlWzBdLmV4Y2x1ZGVfZ3Vlc3Q9MTsNCglwZVswXS53YWtldXBfd2F0
ZXJtYXJrPTA7DQoJcGVbMF0uYnBfdHlwZT1IV19CUkVBS1BPSU5UX0VNUFRZ
Ow0KDQoJZmRbMF09cGVyZl9ldmVudF9vcGVuKCZwZVswXSwwLDAsZmRbNV0s
MCAvKjAqLyApOw0KDQoJLyogUmVwbGF5ZWQgMTAgc3lzY2FsbHMgKi8NCgly
ZXR1cm4gMDsNCn0NCg==

--8323329-1286696140-1375734447=:28589--

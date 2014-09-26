Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635AbaIZL1W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 07:27:22 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:15200 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753763AbaIZL1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 07:27:12 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-d5-54254d8db90c
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Anton Vorontsov <anton@enomsg.org>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>, stable@vger.kernel.org
Subject: [PATCH] power: charger-manager: Fix NULL pointer exception with
 missing cm-fuel-gauge
Date: Fri, 26 Sep 2014 13:27:03 +0200
Message-id: <1411730823-9667-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphluLIzCtJLcpLzFFi42I5/e/4Zd1eX9UQg+uXFS0ObtW02DhjPavF
	9S/PWS0mPXnPbDFx5WRmi86zT5gtXr8wtDjb9Ibd4vKuOWwWn3uPMFqsPXKX3eJ24wo2i9O7
	SywWbHzE6MDnMaH/E6PHzll32T02r9Dy2LSqk82jb8sqRo/Pm+QC2KK4bFJSczLLUov07RK4
	Mqbf3cpSMF+jYt29n2wNjLcVuxg5OSQETCQWnWlmhbDFJC7cW8/WxcjFISSwlFFi6tYFrBBO
	H5PEk28PwarYBIwlNi9fAlYlInCLSWLloSZmEIdZ4C6jRPPd94wgVcICCRLX/n5lB7FZBFQl
	djz7C9bNK+Am8XzTPxaIfXISJ49NZp3AyL2AkWEVo2hqaXJBcVJ6rpFecWJucWleul5yfu4m
	RkjIfd3BuPSY1SFGAQ5GJR7eG+tUQoRYE8uKK3MPMUpwMCuJ8F7yVg0R4k1JrKxKLcqPLyrN
	SS0+xMjEwSnVwJi4pvcCY50qX0/i2w59L52DS3m7rprdq/vwZ+kKn6S/B/5P2qjMEfWefd+P
	KkYZcbuwaWXP/z6Z7hK7l2nL0/uGX40YHZNdT/TcOHc/+nnhyWavgJaP5xSnvKhydrD+sWBW
	H8sUV+bjRoy8gRr3GI7UGfl0uzqF75vm0mdRfjS94NDuKgV/GSWW4oxEQy3mouJEAPOj7AAX	AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NULL pointer exception happens during charger-manager probe if
'cm-fuel-gauge' property is not present.

[    2.448536] Unable to handle kernel NULL pointer dereference at virtual address 00000000
[    2.456572] pgd = c0004000
[    2.459217] [00000000] *pgd=00000000
[    2.462759] Internal error: Oops: 5 [#1] PREEMPT SMP ARM
[    2.468047] Modules linked in:
[    2.471089] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.17.0-rc6-00251-ge44cf96cd525-dirty #969
[    2.479765] task: ea890000 ti: ea87a000 task.ti: ea87a000
[    2.485161] PC is at strcmp+0x4/0x30
[    2.488719] LR is at power_supply_match_device_by_name+0x10/0x1c
[    2.494695] pc : [<c01f4220>]    lr : [<c030fe38>]    psr: a0000113
[    2.494695] sp : ea87bde0  ip : 00000000  fp : eaa97010
[    2.506150] r10: 00000004  r9 : ea97269c  r8 : ea3bbfd0
[    2.511360] r7 : eaa97000  r6 : c030fe28  r5 : 00000000  r4 : ea3b0000
[    2.517869] r3 : 0000006d  r2 : 00000000  r1 : 00000000  r0 : c057c195
[    2.524381] Flags: NzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
[    2.531671] Control: 10c5387d  Table: 4000404a  DAC: 00000015
[    2.537399] Process swapper/0 (pid: 1, stack limit = 0xea87a240)
[    2.543388] Stack: (0xea87bde0 to 0xea87c000)
[    2.547733] bde0: ea3b0210 c026b1c8 eaa97010 eaa97000 eaa97010 eabb60a8 ea3b0210 00000000
[    2.555891] be00: 00000008 ea2db210 ea1a3410 c030fee0 ea3bbf90 c03138fc c068969c c013526c
[    2.564050] be20: eaa040c0 00000000 c068969c 00000000 eaa040c0 ea2da300 00000002 00000000
[    2.572208] be40: 00000001 ea2da3c0 00000000 00000001 00000000 eaa97010 c068969c 00000000
[    2.580367] be60: 00000000 c068969c 00000000 00000002 00000000 c026b71c c026b6f0 eaa97010
[    2.588527] be80: c0e82530 c026a330 00000000 eaa97010 c068969c eaa97044 00000000 c061df50
[    2.596686] bea0: ea87a000 c026a4dc 00000000 c068969c c026a448 c0268b5c ea8054a8 eaa8fd50
[    2.604845] bec0: c068969c ea2db180 c06801f8 c0269b18 c0590f68 c068969c c0656c98 c068969c
[    2.613004] bee0: c0656c98 ea3bbe40 c06988c0 c026aaf0 00000000 c0656c98 c0656c98 c00088a4
[    2.621163] bf00: 00000000 c0055f48 00000000 00000004 00000000 ea890000 c05dbc54 c062c178
[    2.629323] bf20: c0603518 c005f674 00000001 ea87a000 eb7ff83b c0476440 00000091 c003d41c
[    2.637482] bf40: c05db344 00000007 eb7ff858 00000007 c065a76c c0647d24 00000007 c062c170
[    2.645642] bf60: c06988c0 00000091 c062c178 c0603518 00000000 c0603cc4 00000007 00000007
[    2.653801] bf80: c0603518 c0c0c0c0 00000000 c0453948 00000000 00000000 00000000 00000000
[    2.661959] bfa0: 00000000 c0453950 00000000 c000e728 00000000 00000000 00000000 00000000
[    2.670118] bfc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[    2.678277] bfe0: 00000000 00000000 00000000 00000000 00000013 00000000 c0c0c0c0 c0c0c0c0
[    2.686454] [<c01f4220>] (strcmp) from [<c030fe38>] (power_supply_match_device_by_name+0x10/0x1c)
[    2.695303] [<c030fe38>] (power_supply_match_device_by_name) from [<c026b1c8>] (class_find_device+0x54/0xac)
[    2.705106] [<c026b1c8>] (class_find_device) from [<c030fee0>] (power_supply_get_by_name+0x1c/0x30)
[    2.714137] [<c030fee0>] (power_supply_get_by_name) from [<c03138fc>] (charger_manager_probe+0x3d8/0xe58)
[    2.723683] [<c03138fc>] (charger_manager_probe) from [<c026b71c>] (platform_drv_probe+0x2c/0x5c)
[    2.732532] [<c026b71c>] (platform_drv_probe) from [<c026a330>] (driver_probe_device+0x10c/0x224)
[    2.741384] [<c026a330>] (driver_probe_device) from [<c026a4dc>] (__driver_attach+0x94/0x98)
[    2.749813] [<c026a4dc>] (__driver_attach) from [<c0268b5c>] (bus_for_each_dev+0x54/0x88)
[    2.757969] [<c0268b5c>] (bus_for_each_dev) from [<c0269b18>] (bus_add_driver+0xd4/0x1d0)
[    2.766123] [<c0269b18>] (bus_add_driver) from [<c026aaf0>] (driver_register+0x78/0xf4)
[    2.774110] [<c026aaf0>] (driver_register) from [<c00088a4>] (do_one_initcall+0x80/0x1bc)
[    2.782276] [<c00088a4>] (do_one_initcall) from [<c0603cc4>] (kernel_init_freeable+0x100/0x1cc)
[    2.790952] [<c0603cc4>] (kernel_init_freeable) from [<c0453950>] (kernel_init+0x8/0xec)
[    2.799029] [<c0453950>] (kernel_init) from [<c000e728>] (ret_from_fork+0x14/0x2c)
[    2.806572] Code: e12fff1e e1a03000 eafffff7 e4d03001 (e4d12001)
[    2.812832] ---[ end trace 7f12556111b9e7ef ]---

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: <stable@vger.kernel.org>
Fixes: 856ee6115e2d ("charger-manager: Support deivce tree in charger manager driver")
---
 drivers/power/charger-manager.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/power/charger-manager.c b/drivers/power/charger-manager.c
index c1ed3c99c059..7098a1ce2d3c 100644
--- a/drivers/power/charger-manager.c
+++ b/drivers/power/charger-manager.c
@@ -1720,6 +1720,11 @@ static int charger_manager_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
+	if (!desc->psy_fuel_gauge) {
+		dev_err(&pdev->dev, "No fuel gauge power supply defined\n");
+		return -EINVAL;
+	}
+
 	/* Counting index only */
 	while (desc->psy_charger_stat[i])
 		i++;
-- 
1.9.1


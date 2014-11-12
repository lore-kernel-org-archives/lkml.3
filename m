Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845AbaKLLC3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 06:02:29 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:56762 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954AbaKLLC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 06:02:27 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-5c-54633e417dbf
From: Chanwoo Choi <cw00.choi@samsung.com>
To: dan.j.williams@intel.com, vinod.koul@intel.com
Cc: geunsik.lim@samsung.com, inki.dae@samsung.com, chanho61.park@samsung.com,
        cw00.choi@samsung.com, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] dma: pl330: Fix bug to allocate resources on ARM 64bit SoC
Date: Wed, 12 Nov 2014 20:02:13 +0900
Message-id: <1415790133-4206-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHLMWRmVeSWpSXmKPExsWyRsSkSNfRLjnEYPFDdovL+7Utrn95zmox
	feoFRovVU/+yWvyZ0MpmMen+BBaLy7vmsFm87NvP4sDhsXjPSyaPvi2rGD0+b5ILYI7isklJ
	zcksSy3St0vgyvjz5zhzwTSRim8v1rM1MPYKdjFyckgImEgcWdHNBGGLSVy4t56ti5GLQ0hg
	KaPE1uVnWWCKHn3ZyQ6RmM4o0fXoFiOE08Qk0bJrCztIFZuAlsT+FzfYQGwRASOJWY3TwMYy
	C8xjlHi6xwnEFhbwlpi3/AYriM0ioCqxdP8aRhCbV8BFYva/hWwQ2xQkli2fyQqyQELgO5vE
	1D+NjBANAhLfJh8COokDKCErsekAM0S9pMTBFTdYJjAKLmBkWMUomlqQXFCclF5kolecmFtc
	mpeul5yfu4kRGKyn/z2bsIPx3gHrQ4wCHIxKPLwJa5JChFgTy4orcw8xmgJtmMgsJZqcD4yJ
	vJJ4Q2MzIwtTE1NjI3NLMyVx3tdSP4OFBNITS1KzU1MLUovii0pzUosPMTJxcEo1MK6NWBjy
	UMO3ZtH6Jyv9VsVGTNk/Zc6sG0u2Rs5Z8MpBr8f4Q+7VUueUTp99dYUhm/XnnjpWZ8bReNcu
	piBMIDpqY4vX2dWZe9fxdq6LaXlow5Z1Q8OtPVroodvyif/vLDm7KEHgevd0HZNDucfbGLT2
	7nJam8S26uvXtfeXnjpZ/crrbr+dnZcSS3FGoqEWc1FxIgDbZca1UQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgkeLIzCtJLcpLzFFi42I5/e+xoK6DXXKIwYsvNhaX92tbXP/ynNVi
	+tQLjBarp/5ltfgzoZXNYtL9CSwWl3fNYbN42befxYHDY/Gel0wefVtWMXp83iQXwBzVwGiT
	kZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA3SBkkJZYk4p
	UCggsbhYSd8O04TQEDddC5jGCF3fkCC4HiMDNJCwhjHjz5/jzAXTRCq+vVjP1sDYK9jFyMkh
	IWAi8ejLTnYIW0ziwr31bF2MXBxCAtMZJboe3WKEcJqYJFp2bQGrYhPQktj/4gYbiC0iYCQx
	q3EaE4jNLDCPUeLpHicQW1jAW2Le8husIDaLgKrE0v1rGEFsXgEXidn/FrJBbFOQWLZ8JusE
	Ru4FjAyrGEVTC5ILipPSc430ihNzi0vz0vWS83M3MYJj4Zn0DsZVDRaHGAU4GJV4eDM2J4UI
	sSaWFVfmHmKU4GBWEuHlNk4OEeJNSaysSi3Kjy8qzUktPsRoCrR9IrOUaHI+ME7zSuINjU3M
	jCyNzA0tjIzNlcR5D7ZaBwoJpCeWpGanphakFsH0MXFwSjUwTs9/PH+dSsNi7XdsDAk8jNVB
	sx2W11jpHPoQ97an6cmlb4dOsc+Z7737pBFnzM1f+l2dttvFO481hU9hqa2Q27Gs5V388q4p
	/B9ur+jJ+ScSuio490t+gpPXrI49s1gKbD806AvF/naNu1mo4Rd6Nk4/ecukb79bYxlX17Kk
	3VzWltQa5B+jxFKckWioxVxUnAgAKilEXZsCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix following bug to allocate resources on ARM 64bit SoC.
The patch[1] adds to check wheter dev is NULL or not.

 [1] arm64: Warn on NULL device structure for dma APIs)
 - http://lists.infradead.org/pipermail/linux-arm-kernel/2013-December/218650.html

[    0.488475] ------------[ cut here ]------------
[    0.493008] WARNING: CPU: 0 PID: 1 at arch/arm64/mm/dma-mapping.c:95 __dma_alloc_coherent+0x104/0x114()
[    0.503038] Use an actual device structure for DMA allocation
[    0.509123] Modules linked in:
[    0.512093] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.18.0-rc3+ #54
[    0.518548] Call trace:
[    0.520949] [<ffffffc000087eb8>] dump_backtrace+0x0/0x124
[    0.526345] [<ffffffc000087fec>] show_stack+0x10/0x1c
[    0.531359] [<ffffffc0005101cc>] dump_stack+0x74/0xb8
[    0.536412] [<ffffffc0000ac698>] warn_slowpath_common+0x8c/0xb4
[    0.542295] [<ffffffc0000ac70c>] warn_slowpath_fmt+0x4c/0x58
[    0.547958] [<ffffffc000093860>] __dma_alloc_coherent+0x100/0x114
[    0.554012] [<ffffffc0000938d8>] __dma_alloc_noncoherent+0x64/0x180
[    0.560281] [<ffffffc00032c034>] pl330_probe+0x650/0x8f8
[    0.565574] [<ffffffc000325f10>] amba_probe+0x90/0xe0
[    0.570595] [<ffffffc00036c1c4>] really_probe+0x7c/0x220
[    0.575902] [<ffffffc00036c474>] __driver_attach+0xa0/0xa8
[    0.581355] [<ffffffc00036a5c8>] bus_for_each_dev+0x54/0x98
[    0.586925] [<ffffffc00036bd58>] driver_attach+0x1c/0x28
[    0.592205] [<ffffffc00036b9d4>] bus_add_driver+0x14c/0x204
[    0.597776] [<ffffffc00036cb50>] driver_register+0x64/0x130
[    0.603315] [<ffffffc000325a38>] amba_driver_register+0x50/0x5c
[    0.609234] [<ffffffc0006f2de0>] pl330_driver_init+0x10/0x1c
[    0.614859] [<ffffffc0000814bc>] do_one_initcall+0x88/0x1ac
[    0.620432] [<ffffffc0006d9acc>] kernel_init_freeable+0x148/0x1e8
[    0.626508] [<ffffffc00050d41c>] kernel_init+0x10/0xd4
[    0.632028] ---[ end trace d75c52ba9660e12a ]---

Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 drivers/dma/pl330.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
index 4839bfa..8c7d4e1 100644
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -2611,6 +2611,7 @@ pl330_probe(struct amba_device *adev, const struct amba_id *id)
 	}
 
 	pl330->mcbufsz = pdat ? pdat->mcbuf_sz : 0;
+	pl330->ddma.dev = &adev->dev;
 
 	res = &adev->res;
 	pl330->base = devm_ioremap_resource(&adev->dev, res);
-- 
1.8.5.5


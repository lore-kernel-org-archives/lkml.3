Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753095AbaJFQBW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 12:01:22 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:51411 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179AbaJFQBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 12:01:19 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-d2-5432bccc69a2
From: Andrey Ryabinin <a.ryabinin@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Andrey Ryabinin <a.ryabinin@samsung.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Konstantin Serebryany <kcc@google.com>,
        Dmitry Chernenkov <dmitryc@google.com>,
        Andrey Konovalov <adech.fo@gmail.com>,
        Yuri Gribov <tetra2005@gmail.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>, Christoph Lameter <cl@linux.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>, Andi Kleen <andi@firstfloor.org>,
        Vegard Nossum <vegard.nossum@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Dave Jones <davej@redhat.com>,
        x86@kernel.org, linux-mm@kvack.org
Subject: [PATCH v4 02/13] efi: libstub: disable KASAN for efistub
Date: Mon, 06 Oct 2014 19:53:56 +0400
Message-id: <1412610847-27671-3-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 2.1.2
In-reply-to: <1412610847-27671-1-git-send-email-a.ryabinin@samsung.com>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1412610847-27671-1-git-send-email-a.ryabinin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPLMWRmVeSWpSXmKPExsVy+t/xy7pn9hiFGFz/Kmex7dcjNovfe2ey
	WsxZv4bN4si17+wW17+9YbT49PIBo8WW601MFs8fPmS3mPCwjd1i2kZxi5XdzWwW25+9ZbJY
	2fmA1eLyrjlsFvfW/Ge1WHzkNrPFu2eTmS2urjrIbvFjw2NWB2GP+Ts/MnrsnHWX3WPBplKP
	xXteMnlsWtXJ5rHp0yR2j663V5g8Tsz4zeLx5Mp0Jo+PT2+xeLzfd5XNo2/LKkaPz5vkPE60
	fGEN4IvisklJzcksSy3St0vgyrjcMYG9YBtrxbuVz1kaGA+wdDFyckgImEh8O9jJDmGLSVy4
	t56ti5GLQ0hgKaNE88eFLBBOH5NE38YlzCBVbAJ6Ev9mbWcDsUUEFCQ29z5jBSliFpjCKvFu
	+S5GkISwgKPEmR+LwIpYBFQllp5+CWbzCrhJ7D+/lw1inZzE9L13wc7gFHCXmHZlJjvEtiZG
	iUNfdrBNYORdwMiwilE0tTS5oDgpPddIrzgxt7g0L10vOT93EyMkUr7uYFx6zOoQowAHoxIP
	b+QOwxAh1sSy4srcQ4wSHMxKIrzm84xChHhTEiurUovy44tKc1KLDzEycXBKNTB2rVpsO2Fz
	8uI5QfmV7Wx8B8snt9+rPbJHcGlG622Buee97hvcv9kh4PXconfBZp6kGV+ubBD2eX5916a/
	Cz6pH/nYVPt1hcdJTy7PdyfdzvtsvZz2d471xshTQmkc7VynkupWGlxc1fSnq1ujX1C2ls9q
	cqGMSnlWkYZO//+DXVk2Ty2vn2hQYinOSDTUYi4qTgQAcqicz3ICAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KASan as many other options should be disabled for this stub
to prevent build failures.

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
---
 drivers/firmware/efi/libstub/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
index b14bc2b..c5533c7 100644
--- a/drivers/firmware/efi/libstub/Makefile
+++ b/drivers/firmware/efi/libstub/Makefile
@@ -19,6 +19,7 @@ KBUILD_CFLAGS			:= $(cflags-y) \
 				   $(call cc-option,-fno-stack-protector)
 
 GCOV_PROFILE			:= n
+KASAN_SANITIZE			:= n
 
 lib-y				:= efi-stub-helper.o
 lib-$(CONFIG_EFI_ARMSTUB)	+= arm-stub.o fdt.o
-- 
2.1.2


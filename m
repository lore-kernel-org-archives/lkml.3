Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751875AbaIXMvb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 08:51:31 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:25757 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209AbaIXMvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 08:51:16 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-c8-5422be4262f8
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
Subject: [PATCH v3 02/13] efi: libstub: disable KASAN for efistub
Date: Wed, 24 Sep 2014 16:43:58 +0400
Message-id: <1411562649-28231-3-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 2.1.1
In-reply-to: <1411562649-28231-1-git-send-email-a.ryabinin@samsung.com>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1411562649-28231-1-git-send-email-a.ryabinin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPLMWRmVeSWpSXmKPExsVy+t/xy7pO+5RCDJYu4rbY9usRm8XvvTNZ
	LeasX8NmceTad3aL69/eMFp8evmA0WLL9SYmi+cPH7JbTHjYxm4xbaO4xcruZjaL7c/eMlms
	7HzAanF51xw2i3tr/rNaLD5ym9ni3bPJzBZXVx1kt/ix4TGrg7DH/J0fGT12zrrL7rFgU6nH
	4j0vmTw2repk89j0aRK7R9fbK0weJ2b8ZvF4cmU6k8fHp7dYPN7vu8rm0bdlFaPH501yHida
	vrAG8EVx2aSk5mSWpRbp2yVwZVy438lWsI21oqethaWB8QBLFyMnh4SAicSvXa/YIGwxiQv3
	1gPZXBxCAksZJSZ2LYNy+pgktsy5zA5SxSagJ/Fv1nawDhEBBYnNvc9YQYqYBaawSrxbvosR
	JCEs4Chx/8VesBUsAqoSnQcus4LYvAJuEnu6pzBBrJOT2Dt5NVgNp4C7xIEfL9ghtjUxSizb
	+5tpAiPvAkaGVYyiqaXJBcVJ6blGesWJucWleel6yfm5mxghkfJ1B+PSY1aHGAU4GJV4eCeK
	K4UIsSaWFVfmHmKU4GBWEuEN2wMU4k1JrKxKLcqPLyrNSS0+xMjEwSnVwJj5sGBFcFzoO+PA
	lFWnNDqCzQ48PM+8yuaObda/2lfJLnd3Kec1J2ftT16Y+PEX5yqDHZVO+d3Cf4/8rL3MvP8B
	/6GQTd215Zu8L9z/uO7WHrEd8747K2k9msUdI7tTdd682qZ5Tra3dm1ntGM/Ye2o2Nzi6HTu
	V4Cg1s4ys3Pvarltnb6tt1ViKc5INNRiLipOBACCcQ5qcgIAAA==
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
2.1.1


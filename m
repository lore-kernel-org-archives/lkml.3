Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934124AbaEGNfi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 09:35:38 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:12160 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933475AbaEGNfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 09:35:33 -0400
From: Liu Hua <sdu.liu@huawei.com>
To: <linux@arm.linux.org.uk>, <kumagai-atsushi@mxc.nes.nec.co.jp>
CC: <will.deacon@arm.com>, <kexec@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <wangnan0@huawei.com>,
        <peifeiyue@huawei.com>, <sdu.liu@huawei.com>, <liusdu@126.com>
Subject: [RFC PATCH 1/2] kdump: add sparse memory related values to vmcore
Date: Wed, 7 May 2014 21:27:13 +0800
Message-ID: <1399469234-54925-2-git-send-email-sdu.liu@huawei.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1399469234-54925-1-git-send-email-sdu.liu@huawei.com>
References: <1399469234-54925-1-git-send-email-sdu.liu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now different platforms may have different sparse memory
related values, such as MAX_PHYSMEM_SIZE and SECTION_SIZE_BITS.

And user tools such as makedumpfile can not get these values
from the vmcore. It defines these value as macros. If we use
 makedumpfile to treate with vmcores with different SECTION
size. We must recompile it. It is awaste of time.

So this patch add related values to vmcore to notify the
user space tools to deal with this situation.

Signed-off-by: Liu Hua <sdu.liu@huawei.com>
---
 kernel/kexec.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/kexec.c b/kernel/kexec.c
index bf0b929e..96f7c5b 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -1577,6 +1577,9 @@ static int __init crash_save_vmcoreinfo_init(void)
 	VMCOREINFO_LENGTH(mem_section, NR_SECTION_ROOTS);
 	VMCOREINFO_STRUCT_SIZE(mem_section);
 	VMCOREINFO_OFFSET(mem_section, section_mem_map);
+	VMCOREINFO_NUMBER(MAX_PHYSMEM_BITS);
+	VMCOREINFO_NUMBER(SECTION_SIZE_BITS);
+
 #endif
 	VMCOREINFO_STRUCT_SIZE(page);
 	VMCOREINFO_STRUCT_SIZE(pglist_data);
-- 
1.9.0


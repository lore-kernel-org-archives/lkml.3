Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758100Ab3DXKVV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 06:21:21 -0400
Received: from intranet.asianux.com ([58.214.24.6]:28923 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757566Ab3DXKVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 06:21:20 -0400
X-Spam-Score: -100.8
Message-ID: <5177B1F0.10106@asianux.com>
Date: Wed, 24 Apr 2013 18:20:32 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Will Deacon <Will.Deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] arm64: compiling issue, need add include/asm/vga.h file
References: <5177551D.8090007@asianux.com> <20130424082237.GA23397@arm.com>
In-Reply-To: <20130424082237.GA23397@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


For compiling with allmodconfig, need vga.h file, so generate it which
just only include the asm-generic one.

It is firstly used by drivers/gpu/drm/drm_irq.c.

The related error:
include/video/vga.h:22:21: fatal error: asm/vga.h: No such file or directory

Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 arch/arm64/include/asm/vga.h |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm64/include/asm/vga.h

diff --git a/arch/arm64/include/asm/vga.h b/arch/arm64/include/asm/vga.h
new file mode 100644
index 0000000..1c49d51
--- /dev/null
+++ b/arch/arm64/include/asm/vga.h
@@ -0,0 +1,21 @@
+/*
+ * Copyright (C) 2012 ARM Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+#ifndef ASMARM_VGA_H
+#define ASMARM_VGA_H
+
+#include <asm-generic/vga.h>
+
+#endif /* ASMARM_VGA_H */
-- 
1.7.7.6

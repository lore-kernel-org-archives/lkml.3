Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753257Ab3K0F0i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 00:26:38 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:38117 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186Ab3K0F0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 00:26:34 -0500
Message-ID: <52958304.4050707@gmail.com>
Date: Wed, 27 Nov 2013 13:28:36 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: rkuo <rkuo@codeaurora.org>
CC: linux-hexagon@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] arch: hexagon: include: uapi: asm: setup.h add swith macro
 __KERNEL__
References: <528AEFB7.4060301@gmail.com> <20131125011938.GB18921@codeaurora.org> <5292B845.3010404@gmail.com> <5292B8A0.7020409@gmail.com> <5294255E.7040105@gmail.com>
In-Reply-To: <5294255E.7040105@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define dummy '__init' instead of include "linux/init.h" if !__KERNEL__,
or can not pass checking. The related error (with allmodconfig under
hexagon):

    CHECK   include/asm (34 files)
  usr/include/asm/setup.h:22: included file 'linux/init.h' is not exported


Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 arch/hexagon/include/uapi/asm/setup.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/hexagon/include/uapi/asm/setup.h b/arch/hexagon/include/uapi/asm/setup.h
index e48285e4a..7e3952d 100644
--- a/arch/hexagon/include/uapi/asm/setup.h
+++ b/arch/hexagon/include/uapi/asm/setup.h
@@ -19,7 +19,12 @@
 #ifndef _ASM_SETUP_H
 #define _ASM_SETUP_H
 
+#ifdef __KERNEL__
 #include <linux/init.h>
+#else
+#define __init
+#endif
+
 #include <asm-generic/setup.h>
 
 extern char external_cmdline_buffer;
-- 
1.7.7.6

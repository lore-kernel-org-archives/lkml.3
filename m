Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934705AbaE2FiB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 01:38:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57640 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756218AbaE2Eey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 00:34:54 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        John David Anglin <dave.anglin@bell.net>,
        Carlos ODonell <carlos@systemhalted.org>, Helge Deller <deller@gmx.de>
Subject: [PATCH 3.14 022/140] parisc: remove _STK_LIM_MAX override
Date: Wed, 28 May 2014 21:32:41 -0700
Message-Id: <20140529043052.216126583@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.rc3.2.g998f840
In-Reply-To: <20140529043049.661315084@linuxfoundation.org>
References: <20140529043049.661315084@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John David Anglin <dave.anglin@bell.net>

commit e0d8898d76a785453bfaf6cd08b830a7d5189f78 upstream.

There are only a couple of architectures that override _STK_LIM_MAX to
a non-infinity value. This changes the stack allocation semantics in
subtle ways. For example, GNU make changes its stack allocation to the
hard maximum defined by _STK_LIM_MAX. As a results, threads executed
by processes running under make are allocated a stack size of
_STK_LIM_MAX rather than a sensible default value. This causes various
thread stress tests to fail when they can't muster more than about 50
threads.

The attached change implements the default behavior used by the
majority of architectures.

Signed-off-by: John David Anglin <dave.anglin@bell.net>
Reviewed-by: Carlos O'Donell <carlos@systemhalted.org>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/parisc/include/uapi/asm/resource.h |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/parisc/include/uapi/asm/resource.h
+++ b/arch/parisc/include/uapi/asm/resource.h
@@ -1,7 +1,6 @@
 #ifndef _ASM_PARISC_RESOURCE_H
 #define _ASM_PARISC_RESOURCE_H
 
-#define _STK_LIM_MAX	10 * _STK_LIM
 #include <asm-generic/resource.h>
 
 #endif



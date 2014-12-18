Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751216AbaLRR5T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 12:57:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51252 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751033AbaLRR5S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 12:57:18 -0500
Date: Thu, 18 Dec 2014 12:57:14 -0500
From: Kyle McMartin <kyle@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: agrover@redhat.com, nab@linux-iscsi.org, jbastian@redhat.com
Subject: [PATCH] uapi/linux/target_core_user.h: fix headers_install.sh badness
Message-ID: <20141218175714.GF5157@redacted.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

scripts/headers_install.sh will transform __packed to
__attribute__((packed)), so the #ifndef is not necessary.
(and, in fact, it's problematic, because we'll end up with the header
 containing:
#ifndef __attribute__((packed))
#define __attribu...
and so forth.)

Cc: stable@vger.kernel.org # 3.18
Signed-off-by: Kyle McMartin <kyle@redhat.com>

---
cc-ing stable@ so this headers fix gets picked up by distros.

--- a/include/uapi/linux/target_core_user.h
+++ b/include/uapi/linux/target_core_user.h
@@ -6,10 +6,6 @@
 #include <linux/types.h>
 #include <linux/uio.h>
 
-#ifndef __packed
-#define __packed                        __attribute__((packed))
-#endif
-
 #define TCMU_VERSION "1.0"
 
 /*

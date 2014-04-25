Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752160AbaDYRqd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 13:46:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49807 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751102AbaDYRqb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 13:46:31 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, hpa@zytor.com
Cc: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH 1/2] x86/boot: Do not include boot.h in string.c
Date: Fri, 25 Apr 2014 13:46:11 -0400
Message-Id: <1398447972-27896-2-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1398447972-27896-1-git-send-email-vgoyal@redhat.com>
References: <1398447972-27896-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

string.c does not require whole of boot.h. Just inclusion of linux/types.h
and ctypes.h seems to be sufficient.

Keep list of stuff being included in string.c to bare minimal so that
string.c can be included in other places easily.

For example, Currently boot/compressed/string.c includes boot/string.c
but looks like it does not want boot/boot.h. Hence there is a define
in boot/compressed/misc.h "define BOOT_BOOT_H" which prevents inclusion
of boot.h in compressed/string.c. And compressed/string.c is forced to
include misc.h just for that reason.

So by removing inclusion of boot.h, we can also get rid of inclusion of
misch.h in compressed/misc.c.

This also enables including of boot/string.c in purgatory/ code relatively
easily.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 arch/x86/boot/string.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/boot/string.c b/arch/x86/boot/string.c
index 5339040..aca52b8 100644
--- a/arch/x86/boot/string.c
+++ b/arch/x86/boot/string.c
@@ -12,7 +12,8 @@
  * Very basic string functions
  */
 
-#include "boot.h"
+#include <linux/types.h>
+#include "ctype.h"
 
 /*
  * This file gets included in compressed/string.c which might pull in
-- 
1.9.0


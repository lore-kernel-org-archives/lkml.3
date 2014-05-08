Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754474AbaEHPJx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 11:09:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36113 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945AbaEHPJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 11:09:52 -0400
Date: Thu, 8 May 2014 08:09:35 -0700
From: tip-bot for Vivek Goyal <tipbot@zytor.com>
Message-ID: <tip-3d379225c458097d41d104b4f78f40ee97719333@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, vgoyal@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, vgoyal@redhat.com
In-Reply-To: <1398447972-27896-2-git-send-email-vgoyal@redhat.com>
References: <1398447972-27896-2-git-send-email-vgoyal@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/boot] x86, boot: Do not include boot.h in string.c
Git-Commit-ID: 3d379225c458097d41d104b4f78f40ee97719333
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3d379225c458097d41d104b4f78f40ee97719333
Gitweb:     http://git.kernel.org/tip/3d379225c458097d41d104b4f78f40ee97719333
Author:     Vivek Goyal <vgoyal@redhat.com>
AuthorDate: Fri, 25 Apr 2014 13:46:11 -0400
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Thu, 8 May 2014 08:00:01 -0700

x86, boot: Do not include boot.h in string.c

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
Link: http://lkml.kernel.org/r/1398447972-27896-2-git-send-email-vgoyal@redhat.com
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
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

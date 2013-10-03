Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752915Ab3JCKVa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 06:21:30 -0400
Received: from forward7.mail.yandex.net ([77.88.61.37]:45922 "EHLO
	forward7.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740Ab3JCKV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 06:21:28 -0400
X-Greylist: delayed 473 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Oct 2013 06:21:28 EDT
From: Kirill Tkhai <tkhai@yandex.ru>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Michal Marek <mmarek@suse.cz>, akpm@linux-foundation.org
Subject: [PATCH][resend]scripts/tags.sh: Increase identifier list 
MIME-Version: 1.0
Message-Id: <47921380795212@web26m.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Thu, 03 Oct 2013 14:13:32 +0400
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add		__maybe_unused
		__always_unused
		__cacheline_aligned
		__cacheline_aligned_in_smp
		ACPI_EXPORT_SYMBOL
to the list.

Signed-off-by: Kirill Tkhai <tkhai@yandex.ru>
CC: Michal Marek <mmarek@suse.cz>
CC: Andrew Morton <akpm@linux-foundation.org>
---
 scripts/tags.sh |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)
diff --git a/scripts/tags.sh b/scripts/tags.sh
index 74f02e4..f1bcfc1 100755
--- a/scripts/tags.sh
+++ b/scripts/tags.sh
@@ -151,13 +151,14 @@ exuberant()
 	all_target_sources | xargs $1 -a                        \
 	-I __initdata,__exitdata,__initconst,__devinitdata	\
 	-I __devinitconst,__cpuinitdata,__initdata_memblock	\
-	-I __refdata,__attribute				\
+	-I __refdata,__attribute,__maybe_unused,__always_unused \
 	-I __acquires,__releases,__deprecated			\
 	-I __read_mostly,__aligned,____cacheline_aligned        \
 	-I ____cacheline_aligned_in_smp                         \
+	-I __cacheline_aligned,__cacheline_aligned_in_smp	\
 	-I ____cacheline_internodealigned_in_smp                \
 	-I __used,__packed,__packed2__,__must_check,__must_hold	\
-	-I EXPORT_SYMBOL,EXPORT_SYMBOL_GPL                      \
+	-I EXPORT_SYMBOL,EXPORT_SYMBOL_GPL,ACPI_EXPORT_SYMBOL   \
 	-I DEFINE_TRACE,EXPORT_TRACEPOINT_SYMBOL,EXPORT_TRACEPOINT_SYMBOL_GPL \
 	-I static,const						\
 	--extra=+f --c-kinds=+px                                \

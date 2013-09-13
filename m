Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752939Ab3IMRJI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 13:09:08 -0400
Received: from mail-ea0-f178.google.com ([209.85.215.178]:58017 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751839Ab3IMRJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 13:09:06 -0400
From: Jean Pihet <jean.pihet@linaro.org>
To: Will Deacon <will.deacon@arm.com>, Jiri Olsa <jolsa@redhat.com>,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        linux-arm-kernel@lists.infradead.org, Ingo Molnar <mingo@kernel.org>
Cc: patches@linaro.org, Jean Pihet <jean.pihet@linaro.org>
Subject: [PATCH] perf tools: Check libunwind for availability of dwarf parsing feature
Date: Fri, 13 Sep 2013 19:08:41 +0200
Message-Id: <1379092121-5981-1-git-send-email-jean.pihet@linaro.org>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The newly added dwarf unwinding feature [1] requires:
. a recent version (>= 1.1) of libunwind,
. libunwind to be configured with --enable-debug-frame.

[1] http://www.spinics.net/lists/kernel/msg1598951.html

Add the corresponding API test in the feature check list.

Signed-off-by: Jean Pihet <jean.pihet@linaro.org>
---
 tools/perf/config/feature-tests.mak | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/tools/perf/config/feature-tests.mak b/tools/perf/config/feature-tests.mak
index 708fb8e..87124d0 100644
--- a/tools/perf/config/feature-tests.mak
+++ b/tools/perf/config/feature-tests.mak
@@ -176,14 +176,23 @@ extern int UNW_OBJ(dwarf_search_unwind_table) (unw_addr_space_t as,
                                       unw_proc_info_t *pi,
                                       int need_unwind_info, void *arg);
 
-
 #define dwarf_search_unwind_table UNW_OBJ(dwarf_search_unwind_table)
 
+extern int
+UNW_OBJ(dwarf_find_debug_frame) (int found, unw_dyn_info_t *di_debug,
+				 unw_word_t ip,
+				 unw_word_t segbase,
+				 const char *obj_name, unw_word_t start,
+				 unw_word_t end);
+
+#define dwarf_find_debug_frame UNW_OBJ(dwarf_find_debug_frame)
+
 int main(void)
 {
 	unw_addr_space_t addr_space;
 	addr_space = unw_create_addr_space(NULL, 0);
 	unw_init_remote(NULL, addr_space, NULL);
+	dwarf_find_debug_frame(0, NULL, 0, 0, NULL, 0, 0);
 	dwarf_search_unwind_table(addr_space, 0, NULL, NULL, 0, NULL);
 	return 0;
 }
-- 
1.8.1.2


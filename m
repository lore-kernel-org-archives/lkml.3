Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756652Ab3AXUaw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 15:30:52 -0500
Received: from merlin.infradead.org ([205.233.59.134]:50158 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755865Ab3AXUIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 15:08:42 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Hyeoncheol Lee <hyc.lee@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 41/74] perf probe: Allow of casting an array of char to string
Date: Thu, 24 Jan 2013 17:07:50 -0300
Message-Id: <1359058103-31645-42-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1359058103-31645-1-git-send-email-acme@infradead.org>
References: <1359058103-31645-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hyeoncheol Lee <hyc.lee@gmail.com>

Before casting a type of a variable to string, convert_variable_type()
confirms that the type is a pointer or an array. then if it is a pointer
to char, it is casted to string.  but in case of an array of char, it
isn't

Signed-off-by: H.C. Lee <hyc.lee@gmail.com>
Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/CANFS6bb75e8a_UtyAD9yF73hfXDy0N8tSjDz=a+Vna=Y8ORMHg@mail.gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/probe-finder.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 1daf5c1..be03293 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -413,12 +413,12 @@ static int convert_variable_type(Dwarf_Die *vr_die,
 				   dwarf_diename(vr_die), dwarf_diename(&type));
 			return -EINVAL;
 		}
+		if (die_get_real_type(&type, &type) == NULL) {
+			pr_warning("Failed to get a type"
+				   " information.\n");
+			return -ENOENT;
+		}
 		if (ret == DW_TAG_pointer_type) {
-			if (die_get_real_type(&type, &type) == NULL) {
-				pr_warning("Failed to get a type"
-					   " information.\n");
-				return -ENOENT;
-			}
 			while (*ref_ptr)
 				ref_ptr = &(*ref_ptr)->next;
 			/* Add new reference with offset +0 */
-- 
1.8.1.1.361.gec3ae6e


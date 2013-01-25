Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757146Ab3AYLg4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 06:36:56 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41806 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755517Ab3AYLgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 06:36:54 -0500
Date: Fri, 25 Jan 2013 03:36:28 -0800
From: tip-bot for Hyeoncheol Lee <hyc.lee@gmail.com>
Message-ID: <tip-7ce28b5b5b320e26ac6a0e352d5005bce3530e05@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org, hyc.lee@gmail.com,
        a.p.zijlstra@chello.nl, masami.hiramatsu.pt@hitachi.com,
        srikar@linux.vnet.ibm.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, hyc.lee@gmail.com,
        a.p.zijlstra@chello.nl, masami.hiramatsu.pt@hitachi.com,
        srikar@linux.vnet.ibm.com, tglx@linutronix.de
In-Reply-To: <CANFS6bb75e8a_UtyAD9yF73hfXDy0N8tSjDz=a+Vna=Y8ORMHg@mail.gmail.com>
References: <CANFS6bb75e8a_UtyAD9yF73hfXDy0N8tSjDz=a+Vna=Y8ORMHg@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf probe:
  Allow of casting an array of char to string
Git-Commit-ID: 7ce28b5b5b320e26ac6a0e352d5005bce3530e05
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 25 Jan 2013 03:36:34 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7ce28b5b5b320e26ac6a0e352d5005bce3530e05
Gitweb:     http://git.kernel.org/tip/7ce28b5b5b320e26ac6a0e352d5005bce3530e05
Author:     Hyeoncheol Lee <hyc.lee@gmail.com>
AuthorDate: Tue, 11 Sep 2012 16:57:28 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 24 Jan 2013 16:40:20 -0300

perf probe: Allow of casting an array of char to string

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

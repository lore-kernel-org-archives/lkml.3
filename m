Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755824AbaCFEmu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 23:42:50 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:41915 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752109AbaCFEmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 23:42:19 -0500
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
        Stephane Eranian <eranian@google.com>,
        Michael Ellerman <michaele@au1.ibm.com>,
        Paul Mackerras <paulus@samba.org>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 3/3] perf: Use 64-bit value when comparing sample_regs
Date: Wed,  5 Mar 2014 20:41:59 -0800
Message-Id: <1394080919-17957-4-git-send-email-sukadev@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1394080919-17957-1-git-send-email-sukadev@linux.vnet.ibm.com>
References: <1394080919-17957-1-git-send-email-sukadev@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14030604-9332-0000-0000-0000000771D7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When checking whether a bit representing a register is set in
sample_regs, a 64-bit mask, use 64-bit value (1LL).

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
---
 tools/perf/util/unwind.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/unwind.c b/tools/perf/util/unwind.c
index 742f23b..2b888c6 100644
--- a/tools/perf/util/unwind.c
+++ b/tools/perf/util/unwind.c
@@ -396,11 +396,11 @@ static int reg_value(unw_word_t *valp, struct regs_dump *regs, int id,
 {
 	int i, idx = 0;
 
-	if (!(sample_regs & (1 << id)))
+	if (!(sample_regs & (1LL << id)))
 		return -EINVAL;
 
 	for (i = 0; i < id; i++) {
-		if (sample_regs & (1 << i))
+		if (sample_regs & (1LL << i))
 			idx++;
 	}
 
-- 
1.7.9.5


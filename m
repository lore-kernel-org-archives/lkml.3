Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932411AbbA0Bo3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 20:44:29 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:34776 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932295AbbA0Bne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 20:43:34 -0500
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Michael Ellerman <mpe@ellerman.id.au>, Jiri Olsa <jolsa@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: dev@codyps.com, peterz@infradead.org, hbabu@us.ibm.com,
        <linux-kernel@vger.kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v7 3/7] perf: define EVENT_DEFINE_RANGE_FORMAT_LITE helper
Date: Mon, 26 Jan 2015 17:43:06 -0800
Message-Id: <1422322990-9030-4-git-send-email-sukadev@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1422322990-9030-1-git-send-email-sukadev@linux.vnet.ibm.com>
References: <1422322990-9030-1-git-send-email-sukadev@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15012701-0033-0000-0000-0000037746A7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define a lite version of the EVENT_DEFINE_RANGE_FORMAT() that avoids
defining helper functions for the bit-field ranges.

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
---
 arch/powerpc/perf/hv-common.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/powerpc/perf/hv-common.h b/arch/powerpc/perf/hv-common.h
index 5d79cec..349aaba 100644
--- a/arch/powerpc/perf/hv-common.h
+++ b/arch/powerpc/perf/hv-common.h
@@ -20,6 +20,16 @@ unsigned long hv_perf_caps_get(struct hv_perf_caps *caps);
 PMU_FORMAT_ATTR(name, #attr_var ":" #bit_start "-" #bit_end);		\
 EVENT_DEFINE_RANGE(name, attr_var, bit_start, bit_end)
 
+/*
+ * The EVENT_DEFINE_RANGE_FORMAT() macro above includes helper functions
+ * for the fields (eg: event_get_starting_index()). For some fields we
+ * need the bit-range definition, but no the helper functions. Define a
+ * lite version of the above macro without the helpers and silence
+ * compiler warnings unused static functions.
+ */
+#define EVENT_DEFINE_RANGE_FORMAT_LITE(name, attr_var, bit_start, bit_end) \
+PMU_FORMAT_ATTR(name, #attr_var ":" #bit_start "-" #bit_end);
+
 #define EVENT_DEFINE_RANGE(name, attr_var, bit_start, bit_end)	\
 static u64 event_get_##name##_max(void)					\
 {									\
-- 
1.8.3.1


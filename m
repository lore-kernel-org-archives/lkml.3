Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751956AbaLRQxD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 11:53:03 -0500
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:41562 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751710AbaLRQvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 11:51:48 -0500
From: Julian Brost <linux-kernel@0x4a42.net>
To: Julian Brost <linux-kernel@0x4a42.net>,
        Fabian Hofmann <fabian.hofmann@fau.de>
Cc: linux-kernel@i4.cs.fau.de, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/5] perf/x86/intel/uncore: checkpatch: Replace kzalloc with kcalloc
Date: Thu, 18 Dec 2014 17:51:37 +0100
Message-Id: <1418921500-5630-3-git-send-email-linux-kernel@0x4a42.net>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1418921500-5630-1-git-send-email-linux-kernel@0x4a42.net>
References: <1418751050-11725-1-git-send-email-linux-kernel@0x4a42.net>
 <1418921500-5630-1-git-send-email-linux-kernel@0x4a42.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kzalloc was used for an array allocation where kcalloc should be used.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Julian Brost <linux-kernel@0x4a42.net>
Signed-off-by: Fabian Hofmann <fabian.hofmann@fau.de>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index 9762dbd..161655f 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -725,7 +725,7 @@ static int __init uncore_type_init(struct intel_uncore_type *type)
 	struct attribute **attrs;
 	int i, j;
 
-	pmus = kzalloc(sizeof(*pmus) * type->num_boxes, GFP_KERNEL);
+	pmus = kcalloc(type->num_boxes, sizeof(*pmus), GFP_KERNEL);
 	if (!pmus)
 		return -ENOMEM;
 
-- 
1.9.1


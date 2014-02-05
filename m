Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170AbaBEIHz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 03:07:55 -0500
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:53661 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754016AbaBEIHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 03:07:50 -0500
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
To: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Cc: michael@ellerman.id.au, mikey@neuling.org, ak@linux.intel.com,
        eranian@google.com, acme@ghostprotocols.net,
        sukadev@linux.vnet.ibm.com, mingo@kernel.org
Subject: [V5 02/11] perf: Add PERF_SAMPLE_BRANCH_COND
Date: Wed,  5 Feb 2014 13:36:13 +0530
Message-Id: <1391587582-32028-3-git-send-email-khandual@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1391587582-32028-1-git-send-email-khandual@linux.vnet.ibm.com>
References: <1391587582-32028-1-git-send-email-khandual@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14020508-6102-0000-0000-000004E3B4CA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces new branch filter PERF_SAMPLE_BRANCH_COND which
will extend the existing perf ABI. Various architectures can provide
this functionality with either with HW filtering support (if present)
or with SW filtering of captured branch instructions.

Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Reviewed-by: Stephane Eranian <eranian@google.com>
---
 include/uapi/linux/perf_event.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index 853bc1c..696f69b4 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -163,8 +163,9 @@ enum perf_branch_sample_type {
 	PERF_SAMPLE_BRANCH_ABORT_TX	= 1U << 7, /* transaction aborts */
 	PERF_SAMPLE_BRANCH_IN_TX	= 1U << 8, /* in transaction */
 	PERF_SAMPLE_BRANCH_NO_TX	= 1U << 9, /* not in transaction */
+	PERF_SAMPLE_BRANCH_COND		= 1U << 10, /* conditional branches */
 
-	PERF_SAMPLE_BRANCH_MAX		= 1U << 10, /* non-ABI */
+	PERF_SAMPLE_BRANCH_MAX		= 1U << 11, /* non-ABI */
 };
 
 #define PERF_SAMPLE_BRANCH_PLM_ALL \
-- 
1.7.11.7


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933593AbaDIOW4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 10:22:56 -0400
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:55086 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933429AbaDIOWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 10:22:16 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, KVM <kvm@vger.kernel.org>,
        Alexander Yarygin <yarygin@linux.vnet.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PULL 1/2] perf/tool: Fix usage of trace events with '-' in trace system name.
Date: Wed,  9 Apr 2014 16:21:58 +0200
Message-Id: <1397053319-2130-2-git-send-email-borntraeger@de.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1397053319-2130-1-git-send-email-borntraeger@de.ibm.com>
References: <1397053319-2130-1-git-send-email-borntraeger@de.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14040914-0342-0000-0000-0000086231D9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Yarygin <yarygin@linux.vnet.ibm.com>

Trace events potentially can have a '-' in their trace system name,
e.g. kvm on s390 defines kvm-s390:* tracepoints.
tools/perf could not parse them, because there was no rule for this:
$ sudo ./perf top -e "kvm-s390:*"
invalid or unsupported event: 'kvm-s390:*'

This patch allows '-' to be a part of PE_NAME token, so tracepoints
with '-' can be parsed by the event_legacy_tracepoint rule.
Without the patch, perf will not accept such tracepoints in the -e
option.

Signed-off-by: Alexander Yarygin <yarygin@linux.vnet.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 tools/perf/util/parse-events.l |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/parse-events.l b/tools/perf/util/parse-events.l
index 3432995..ca20da7 100644
--- a/tools/perf/util/parse-events.l
+++ b/tools/perf/util/parse-events.l
@@ -199,7 +199,7 @@ r{num_raw_hex}		{ return raw(yyscanner); }
 {num_hex}		{ return value(yyscanner, 16); }
 
 {modifier_event}	{ return str(yyscanner, PE_MODIFIER_EVENT); }
-{name}			{ return str(yyscanner, PE_NAME); }
+{name_minus}			{ return str(yyscanner, PE_NAME); }
 "/"			{ BEGIN(config); return '/'; }
 -			{ return '-'; }
 ,			{ BEGIN(event); return ','; }
-- 
1.7.9.5


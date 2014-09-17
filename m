Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932075AbaIQVYx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 17:24:53 -0400
Received: from mail.kernel.org ([198.145.19.201]:57936 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757141AbaIQVYw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 17:24:52 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Alexander Yarygin <yarygin@linux.vnet.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 04/20] perf kvm stat report: Enable the target.system_wide flag
Date: Wed, 17 Sep 2014 18:24:07 -0300
Message-Id: <1410989063-14207-5-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1410989063-14207-1-git-send-email-acme@kernel.org>
References: <1410989063-14207-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Yarygin <yarygin@linux.vnet.ibm.com>

The 'perf kvm stat report' command can be used to analyze events either
for system wide or for specific pids.

Let's enable kvm->opts.target.system_wide flag when 'report' command is
running for system-wide analyzing. This helps to sync kvm->opts.target
values in 'report' and 'live' commands.

Signed-off-by: Alexander Yarygin <yarygin@linux.vnet.ibm.com>
Acked-by: David Ahern <dsahern@gmail.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1409579095-12963-3-git-send-email-yarygin@linux.vnet.ibm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-kvm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index 646ec5d5de80..84295ab6c4e1 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -1207,6 +1207,9 @@ kvm_events_report(struct perf_kvm_stat *kvm, int argc, const char **argv)
 					   kvm_events_report_options);
 	}
 
+	if (!kvm->opts.target.pid)
+		kvm->opts.target.system_wide = true;
+
 	return kvm_events_report_vcpu(kvm);
 }
 
-- 
1.9.3


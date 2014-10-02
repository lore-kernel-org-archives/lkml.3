Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752265AbaJBDJB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 23:09:01 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:35266 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341AbaJBDI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 23:08:58 -0400
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 4/5] perf kvm: Use thread_{,_set}_priv helpers
Date: Thu,  2 Oct 2014 12:08:54 +0900
Message-Id: <1412219335-17417-5-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1412219335-17417-1-git-send-email-namhyung@kernel.org>
References: <1412219335-17417-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is mechanical changes only for accounting access to thread->priv
properly in the source level.

Cc: David Ahern <dsahern@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-kvm.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index d8bf2271f4ea..d9b0743180db 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -376,7 +376,7 @@ struct vcpu_event_record *per_vcpu_record(struct thread *thread,
 					  struct perf_sample *sample)
 {
 	/* Only kvm_entry records vcpu id. */
-	if (!thread->priv && kvm_entry_event(evsel)) {
+	if (!thread__priv(thread) && kvm_entry_event(evsel)) {
 		struct vcpu_event_record *vcpu_record;
 
 		vcpu_record = zalloc(sizeof(*vcpu_record));
@@ -386,10 +386,10 @@ struct vcpu_event_record *per_vcpu_record(struct thread *thread,
 		}
 
 		vcpu_record->vcpu_id = perf_evsel__intval(evsel, sample, VCPU_ID);
-		thread->priv = vcpu_record;
+		thread__set_priv(thread, vcpu_record);
 	}
 
-	return thread->priv;
+	return thread__priv(thread);
 }
 
 static bool handle_kvm_event(struct perf_kvm_stat *kvm,
-- 
2.1.0


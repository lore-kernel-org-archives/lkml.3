Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751624AbaJPFYd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 01:24:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33557 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597AbaJPFY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 01:24:29 -0400
Date: Wed, 15 Oct 2014 22:24:11 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-69e865c353b226dbedf319ae6d1ab8fb3510fa25@git.kernel.org>
Cc: namhyung.kim@lge.com, tglx@linutronix.de, paulus@samba.org,
        jolsa@redhat.com, mingo@kernel.org, fweisbec@gmail.com, hpa@zytor.com,
        namhyung@kernel.org, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, acme@redhat.com, jolsa@kernel.org,
        dsahern@gmail.com
Reply-To: namhyung@kernel.org, linux-kernel@vger.kernel.org, acme@redhat.com,
        a.p.zijlstra@chello.nl, dsahern@gmail.com, jolsa@kernel.org,
        namhyung.kim@lge.com, tglx@linutronix.de, paulus@samba.org,
        jolsa@redhat.com, mingo@kernel.org, fweisbec@gmail.com, hpa@zytor.com
In-Reply-To: <1412556363-26229-5-git-send-email-namhyung@kernel.org>
References: <1412556363-26229-5-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf kvm: Use thread_{,_set}_priv helpers
Git-Commit-ID: 69e865c353b226dbedf319ae6d1ab8fb3510fa25
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  69e865c353b226dbedf319ae6d1ab8fb3510fa25
Gitweb:     http://git.kernel.org/tip/69e865c353b226dbedf319ae6d1ab8fb3510fa25
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Mon, 6 Oct 2014 09:46:02 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 15 Oct 2014 17:39:01 -0300

perf kvm: Use thread_{,_set}_priv helpers

This is mechanical changes only for accounting access to thread->priv
properly in the source level.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1412556363-26229-5-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-kvm.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index 460a4ce..ef9fc15 100644
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

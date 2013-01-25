Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757110Ab3AYLfu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 06:35:50 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41790 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755517Ab3AYLfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 06:35:47 -0500
Date: Fri, 25 Jan 2013 03:35:18 -0800
From: tip-bot for Vince Weaver <vincent.weaver@maine.edu>
Message-ID: <tip-b878e7fb22ea48b0585bbbbef249f7efc6d42748@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, vincent.weaver@maine.edu, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com,
        vincent.weaver@maine.edu, a.p.zijlstra@chello.nl, tglx@linutronix.de
In-Reply-To: <alpine.DEB.2.02.1301081439300.24507@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.02.1301081439300.24507@vincent-weaver-1.um.maine.edu>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf:
  Missing field in PERF_RECORD_SAMPLE documentation
Git-Commit-ID: b878e7fb22ea48b0585bbbbef249f7efc6d42748
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 25 Jan 2013 03:35:24 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b878e7fb22ea48b0585bbbbef249f7efc6d42748
Gitweb:     http://git.kernel.org/tip/b878e7fb22ea48b0585bbbbef249f7efc6d42748
Author:     Vince Weaver <vincent.weaver@maine.edu>
AuthorDate: Tue, 8 Jan 2013 14:44:25 -0500
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 24 Jan 2013 16:40:19 -0300

perf: Missing field in PERF_RECORD_SAMPLE documentation

While trying to write a perf_event/mmap test for my perf_event
test-suite I came across a missing field description in the
PERF_RECORD_SAMPLE documentation in perf_event.h

Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/alpine.DEB.2.02.1301081439300.24507@vincent-weaver-1.um.maine.edu
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 include/uapi/linux/perf_event.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index 4f63c05..9fa9c62 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -579,7 +579,8 @@ enum perf_event_type {
 	 *	{ u32			size;
 	 *	  char                  data[size];}&& PERF_SAMPLE_RAW
 	 *
-	 *	{ u64 from, to, flags } lbr[nr];} && PERF_SAMPLE_BRANCH_STACK
+	 *	{ u64                   nr;
+	 *        { u64 from, to, flags } lbr[nr];} && PERF_SAMPLE_BRANCH_STACK
 	 *
 	 * 	{ u64			abi; # enum perf_sample_regs_abi
 	 * 	  u64			regs[weight(mask)]; } && PERF_SAMPLE_REGS_USER

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965660AbaLLITJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 03:19:09 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43194 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934076AbaLLITF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 03:19:05 -0500
Date: Fri, 12 Dec 2014 00:18:49 -0800
From: tip-bot for Alexander Yarygin <tipbot@zytor.com>
Message-ID: <tip-99d348a84c2118ed04c9b72168787f55e2fe33a5@git.kernel.org>
Cc: tglx@linutronix.de, borntraeger@de.ibm.com, hpa@zytor.com,
        yarygin@linux.vnet.ibm.com, jolsa@kernel.org, dsahern@gmail.com,
        mingo@kernel.org, acme@redhat.com, linux-kernel@vger.kernel.org
Reply-To: mingo@kernel.org, acme@redhat.com, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, tglx@linutronix.de, hpa@zytor.com,
        dsahern@gmail.com, jolsa@kernel.org, yarygin@linux.vnet.ibm.com
In-Reply-To: <1418218090-20718-1-git-send-email-borntraeger@de.ibm.com>
References: <1418218090-20718-1-git-send-email-borntraeger@de.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf kvm stat live: Mark events as (x86 only)
  in help output
Git-Commit-ID: 99d348a84c2118ed04c9b72168787f55e2fe33a5
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

Commit-ID:  99d348a84c2118ed04c9b72168787f55e2fe33a5
Gitweb:     http://git.kernel.org/tip/99d348a84c2118ed04c9b72168787f55e2fe33a5
Author:     Alexander Yarygin <yarygin@linux.vnet.ibm.com>
AuthorDate: Wed, 10 Dec 2014 14:28:10 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 10 Dec 2014 12:08:59 -0300

perf kvm stat live: Mark events as (x86 only) in help output

The mmio and ioport events are useful only on x86.

Signed-off-by: Alexander Yarygin <yarygin@linux.vnet.ibm.com>
Acked-by: David Ahern <dsahern@gmail.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Link: http://lkml.kernel.org/r/1418218090-20718-1-git-send-email-borntraeger@de.ibm.com
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-kvm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index 3c0f3d4..0894a81 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -1293,7 +1293,8 @@ static int kvm_events_live(struct perf_kvm_stat *kvm,
 		OPT_UINTEGER('d', "display", &kvm->display_time,
 			"time in seconds between display updates"),
 		OPT_STRING(0, "event", &kvm->report_event, "report event",
-			"event for reporting: vmexit, mmio, ioport"),
+			"event for reporting: "
+			"vmexit, mmio (x86 only), ioport (x86 only)"),
 		OPT_INTEGER(0, "vcpu", &kvm->trace_vcpu,
 			"vcpu id to report"),
 		OPT_STRING('k', "key", &kvm->sort_key, "sort-key",

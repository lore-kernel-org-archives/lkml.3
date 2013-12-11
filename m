Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752326Ab3LKLGP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 06:06:15 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60238 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752280Ab3LKLGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 06:06:08 -0500
Date: Wed, 11 Dec 2013 03:05:47 -0800
From: tip-bot for Dongsheng Yang <tipbot@zytor.com>
Message-ID: <tip-d8d9608fdd19f85a524db0a41bc2def5c88cbdd0@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de, yangds.fnst@cn.fujitsu.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, tglx@linutronix.de, yangds.fnst@cn.fujitsu.com
In-Reply-To: <72857ed89642e0633f5e88f7e7abbc9645359e8e.1386368672.git.yangds.fnst@cn.fujitsu.com>
References: <72857ed89642e0633f5e88f7e7abbc9645359e8e.1386368672.git.yangds.fnst@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf kvm:
  Make perf kvm diff support --guestmount.
Git-Commit-ID: d8d9608fdd19f85a524db0a41bc2def5c88cbdd0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 11 Dec 2013 03:05:53 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d8d9608fdd19f85a524db0a41bc2def5c88cbdd0
Gitweb:     http://git.kernel.org/tip/d8d9608fdd19f85a524db0a41bc2def5c88cbdd0
Author:     Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
AuthorDate: Fri, 6 Dec 2013 17:25:52 -0500
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 9 Dec 2013 15:24:25 -0300

perf kvm: Make perf kvm diff support --guestmount.

In manpage of perf-kvm, --guestmount is supported by diff command, but
it does not work well.

This patch change the extend the checking in buildid-diff from
guestkallsyms or guestmodules to perf_guest. Then this checking can
cover the all cases perf kvm is used for.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Link: http://lkml.kernel.org/r/72857ed89642e0633f5e88f7e7abbc9645359e8e.1386368672.git.yangds.fnst@cn.fujitsu.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-diff.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 3b67ea2..2a85cc9 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -1000,8 +1000,7 @@ static int data_init(int argc, const char **argv)
 			data__files_cnt = argc;
 			use_default = false;
 		}
-	} else if (symbol_conf.default_guest_vmlinux_name ||
-		   symbol_conf.default_guest_kallsyms) {
+	} else if (perf_guest) {
 		defaults[0] = "perf.data.host";
 		defaults[1] = "perf.data.guest";
 	}

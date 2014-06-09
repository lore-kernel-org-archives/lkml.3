Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936034AbaFIXEL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 19:04:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56895 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933836AbaFIWpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 18:45:43 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        xiakaixu <xiakaixu@huawei.com>
Subject: [PATCH 3.10 06/40] perf evsel: Fix printing of perf_event_paranoid message
Date: Mon,  9 Jun 2014 15:48:37 -0700
Message-Id: <20140609224839.412657241@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140609224839.127615063@linuxfoundation.org>
References: <20140609224839.127615063@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Ahern <dsahern@gmail.com>

commit b69e63a45f2d96a0dfe930ed20385058d4574d2f upstream.

message is currently shown as:

  Error:
  You may not have permission to collect %sstats.
  Consider tweaking /proc/sys/kernel/perf_event_paranoid:

Note the %sstats. With patch this becomes:

  Error:
  You may not have permission to collect stats.
  Consider tweaking /proc/sys/kernel/perf_event_paranoid:

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/r/1369526040-1368-1-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: xiakaixu <xiakaixu@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/perf/util/evsel.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -1514,7 +1514,7 @@ int perf_evsel__open_strerror(struct per
 	switch (err) {
 	case EPERM:
 	case EACCES:
-		return scnprintf(msg, size, "%s",
+		return scnprintf(msg, size,
 		 "You may not have permission to collect %sstats.\n"
 		 "Consider tweaking /proc/sys/kernel/perf_event_paranoid:\n"
 		 " -1 - Not paranoid at all\n"



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759986Ab3BZX5L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 18:57:11 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41708 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755666Ab3BZX5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 18:57:02 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Josh Boyer <jwboyer@redhat.com>
Subject: [ 005/150] perf hists: Fix period symbol_conf.field_sep display
Date: Tue, 26 Feb 2013 15:54:22 -0800
Message-Id: <20130226235524.580303704@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130226235523.930663721@linuxfoundation.org>
References: <20130226235523.930663721@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Olsa <jolsa@redhat.com>

commit c0d246b85fc7d42688d7a5d999ea671777caf65b upstream.

Currently we don't properly display hist data with symbol_conf.field_sep
separator. We need to display either space or separator.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/n/tip-cyggwys0bz5kqdowwvfd8h72@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Josh Boyer <jwboyer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/perf/ui/hist.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -463,11 +463,15 @@ int hist_entry__period_snprintf(struct p
 		if (!perf_hpp__format[i].cond)
 			continue;
 
+		/*
+		 * If there's no field_sep, we still need
+		 * to display initial '  '.
+		 */
 		if (!sep || !first) {
 			ret = scnprintf(hpp->buf, hpp->size, "%s", sep ?: "  ");
 			advance_hpp(hpp, ret);
+		} else
 			first = false;
-		}
 
 		if (color && perf_hpp__format[i].color)
 			ret = perf_hpp__format[i].color(hpp, he);



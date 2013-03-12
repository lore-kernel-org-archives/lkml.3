Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932329Ab3CLJCZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 05:02:25 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:32809 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755176Ab3CLJCY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 05:02:24 -0400
Date: Tue, 12 Mar 2013 14:32:17 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: acme@redhat.com
Cc: lkml <linux-kernel@vger.kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Subject: [PATCH] Fix segfault in perf probe
Message-ID: <20130312090217.GC4668@in.ibm.com>
Reply-To: ananth@in.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13031209-7182-0000-0000-000005BFC46B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>

Fix segfault in perf probe due to a bug introduced by commit d8639f068
(perf tools: Stop using 'self' in strlist).


Signed-off-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>

---
Index: linus/tools/perf/util/strlist.c
===================================================================
--- linus.orig/tools/perf/util/strlist.c
+++ linus/tools/perf/util/strlist.c
@@ -143,7 +143,7 @@ struct strlist *strlist__new(bool dupstr
 		slist->rblist.node_delete = strlist__node_delete;
 
 		slist->dupstr	 = dupstr;
-		if (slist && strlist__parse_list(slist, list) != 0)
+		if (list && strlist__parse_list(slist, list) != 0)
 			goto out_error;
 	}
 


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751412Ab3CUSei (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 14:34:38 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62788 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879Ab3CUSeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 14:34:37 -0400
Subject: [PATCH] Adding an error message to indicate perf_event cgroup
 subsys not mounted.
From: Will Auld <will.auld.intel@gmail.com>
Reply-To: will.auld@intel.com
To: linux-kernel@vger.kernel.org
Cc: acme@redhat.com, eranian@google.com, andi.kleen@intel.com,
        will.auld@intel.com
Content-Type: text/plain; charset="UTF-8"
Organization: Intel
Date: Thu, 21 Mar 2013 11:29:20 -0700
Message-ID: <1363890560.21957.4.camel@WGA-RHEL6.3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-24.el6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding an error message to indicate that there is no mounted perf_event
cgroup while using -G or --cgroup options with perf.

Signed-off-by: Will Auld <will.auld@intel.com>
---
 tools/perf/util/cgroup.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/cgroup.c b/tools/perf/util/cgroup.c
index 96bbda1..4126beb 100644
--- a/tools/perf/util/cgroup.c
+++ b/tools/perf/util/cgroup.c
@@ -44,8 +44,10 @@ cgroupfs_find_mountpoint(char *buf, size_t maxlen)
 			break;
 	}
 	fclose(fp);
-	if (!found)
+	if (!found) {
+		error("No cgroup mounted with \'perf_event\' type");
 		return -1;
+	}
 
 	if (strlen(mountpoint) < maxlen) {
 		strcpy(buf, mountpoint);
-- 
1.7.1




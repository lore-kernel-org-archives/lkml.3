Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757474Ab3I2UDc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 16:03:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59230 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755372Ab3I2T1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 15:27:33 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Vinson Lee <vlee@freedesktop.org>
Subject: [ 20/22] perf tools: Handle JITed code in shared memory
Date: Sun, 29 Sep 2013 12:27:06 -0700
Message-Id: <20130929191200.270647524@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20130929191158.889693326@linuxfoundation.org>
References: <20130929191158.889693326@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andi Kleen <ak@linux.intel.com>

commit 89365e6c9ad4c0e090e4c6a4b67a3ce319381d89 upstream.

Need to check for /dev/zero.

Most likely more strings are missing too.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Link: http://lkml.kernel.org/r/1366848182-30449-1-git-send-email-andi@firstfloor.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Vinson Lee <vlee@freedesktop.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/perf/util/map.c |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -16,6 +16,7 @@ const char *map_type__name[MAP__NR_TYPES
 static inline int is_anon_memory(const char *filename)
 {
 	return !strcmp(filename, "//anon") ||
+	       !strcmp(filename, "/dev/zero (deleted)") ||
 	       !strcmp(filename, "/anon_hugepage (deleted)");
 }
 



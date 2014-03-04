Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758291AbaCDU47 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 15:56:59 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41271 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755216AbaCDUEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:04:13 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ben Hutchings <ben@decadent.org.uk>, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 3.13 141/172] perf trace: Add fallback definition of EFD_SEMAPHORE
Date: Tue,  4 Mar 2014 12:03:45 -0800
Message-Id: <20140304200304.221590961@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140304200259.626667112@linuxfoundation.org>
References: <20140304200259.626667112@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

commit 79d26a6a19ace19faabf8d8d27d3430be2e26d34 upstream.

glibc 2.17 is missing this on sparc, despite the fact that it's not
architecture-specific.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Fixes: 49af9e93adfa ('perf trace: Beautify eventfd2 'flags' arg')
Cc: <stable@vger.kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1391648435.3003.100.camel@deadeye.wl.decadent.org.uk
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/perf/builtin-trace.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -35,6 +35,10 @@
 # define MADV_UNMERGEABLE	13
 #endif
 
+#ifndef EFD_SEMAPHORE
+# define EFD_SEMAPHORE		1
+#endif
+
 struct tp_field {
 	int offset;
 	union {



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932160Ab3GBFhE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 01:37:04 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:43984 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932097Ab3GBFhC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 01:37:02 -0400
Subject: [PATCH] Add hsize argument in write_buf call of pstore_ftrace_call
To: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
        benh@kernel.crashing.org
From: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
Cc: fengguang.wu@intel.com, kbuild-all@01.org, rostedt@goodmis.org
Date: Tue, 02 Jul 2013 11:06:54 +0530
Message-ID: <20130702053611.11466.71343.stgit@aruna-ThinkPad-T420>
User-Agent: StGit/0.16-41-gd1dd
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13070205-7014-0000-0000-0000034296FD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Incorporate the addition of hsize argument in write_buf callback
of pstore.

Signed-off-by: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
---

 fs/pstore/ftrace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/pstore/ftrace.c b/fs/pstore/ftrace.c
index 43b1280..76a4eeb 100644
--- a/fs/pstore/ftrace.c
+++ b/fs/pstore/ftrace.c
@@ -44,7 +44,7 @@ static void notrace pstore_ftrace_call(unsigned long ip,
 	rec.parent_ip = parent_ip;
 	pstore_ftrace_encode_cpu(&rec, raw_smp_processor_id());
 	psinfo->write_buf(PSTORE_TYPE_FTRACE, 0, NULL, 0, (void *)&rec,
-			  sizeof(rec), psinfo);
+			  0, sizeof(rec), psinfo);
 
 	local_irq_restore(flags);
 }


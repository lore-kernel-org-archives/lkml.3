Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752622Ab3IKMHz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 08:07:55 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:49322 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752395Ab3IKMHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 08:07:53 -0400
Subject: [PATCH 3/3] pstore: Remove the messages related to compression
 failure
To: linuxppc-dev@ozlabs.org, tony.luck@intel.com, seiji.aguchi@hds.com,
        linux-kernel@vger.kernel.org, keescook@chromium.org
From: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
Cc: jkenisto@linux.vnet.ibm.com, mahesh@linux.vnet.ibm.com,
        cbouatmailru@gmail.com, ananth@in.ibm.com, ccross@android.com
Date: Wed, 11 Sep 2013 17:37:43 +0530
Message-ID: <20130911120729.27730.7479.stgit@aruna-ThinkPad-T420>
In-Reply-To: <20130911120639.27730.8671.stgit@aruna-ThinkPad-T420>
References: <20130911120639.27730.8671.stgit@aruna-ThinkPad-T420>
User-Agent: StGit/0.16-41-gd1dd
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13091111-4790-0000-0000-00000A427D2D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the messages indicating compression failure as it will
add to the space during panic path.

Reported-by: Seiji Aguchi <seiji.aguchi@hds.com>
Signed-off-by: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
---
 fs/pstore/platform.c |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c
index 18924c7..4ad8c93 100644
--- a/fs/pstore/platform.c
+++ b/fs/pstore/platform.c
@@ -316,10 +316,6 @@ static void pstore_dump(struct kmsg_dumper *dumper,
 				compressed = true;
 				total_len = zipped_len;
 			} else {
-				pr_err("pstore: compression failed for Part %d"
-					" returned %d\n", part, zipped_len);
-				pr_err("pstore: Capture uncompressed"
-					" oops/panic report of Part %d\n", part);
 				compressed = false;
 				total_len = copy_kmsg_to_buffer(hsize, len);
 			}


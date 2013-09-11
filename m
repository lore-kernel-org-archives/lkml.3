Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752312Ab3IKMHd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 08:07:33 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:49205 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146Ab3IKMHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 08:07:32 -0400
Subject: [PATCH 2/3] pstore: Use zlib_inflateInit2 instead of
 zlib_inflateInit
To: linuxppc-dev@ozlabs.org, tony.luck@intel.com, seiji.aguchi@hds.com,
        linux-kernel@vger.kernel.org, keescook@chromium.org
From: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
Cc: jkenisto@linux.vnet.ibm.com, mahesh@linux.vnet.ibm.com,
        cbouatmailru@gmail.com, ananth@in.ibm.com, ccross@android.com
Date: Wed, 11 Sep 2013 17:37:16 +0530
Message-ID: <20130911120710.27730.30968.stgit@aruna-ThinkPad-T420>
In-Reply-To: <20130911120639.27730.8671.stgit@aruna-ThinkPad-T420>
References: <20130911120639.27730.8671.stgit@aruna-ThinkPad-T420>
User-Agent: StGit/0.16-41-gd1dd
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13091111-4790-0000-0000-00000A427CD1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since zlib_deflateInit2() is used for specifying window bit during compression,
zlib_inflateInit2() is appropriate for decompression.

Reported-by: Seiji Aguchi <seiji.aguchi@hds.com>
Signed-off-by: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
---
 fs/pstore/platform.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c
index 4efaa75..18924c7 100644
--- a/fs/pstore/platform.c
+++ b/fs/pstore/platform.c
@@ -168,7 +168,7 @@ static int pstore_decompress(void *in, void *out, size_t inlen, size_t outlen)
 	int err, ret;
 
 	ret = -EIO;
-	err = zlib_inflateInit(&stream);
+	err = zlib_inflateInit2(&stream, WINDOW_BITS);
 	if (err != Z_OK)
 		goto error;
 


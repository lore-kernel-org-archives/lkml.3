Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754211AbaCLNeO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 09:34:14 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:35155 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475AbaCLNeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 09:34:13 -0400
Date: Wed, 12 Mar 2014 21:34:06 +0800
From: Liu Shuo <shuox.liu@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Kees Cook <keescook@chromium.org>, Anton Vorontsov <anton@enomsg.org>,
        Colin Cross <ccross@android.com>, Tony Luck <tony.luck@intel.com>,
        Zhang Yanmin <yanmin_zhang@linux.intel.com>
Subject: [PATCH 2/2] pstore: fix memory leak when decompress using
 big_oops_buf
Message-ID: <20140312133403.GB29079@shuo-gentoo>
References: <20140312132441.GA29079@shuo-gentoo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20140312132441.GA29079@shuo-gentoo>
X-Mailer: Mutt 1.5.x/OS X 10.7.x
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Liu ShuoX <shuox.liu@intel.com>

After sucessful decompressing, the buffer which pointed by 'buf' will be
lost as 'buf' is overwrite by 'big_oops_buf' and will never be freed. 

Signed-off-by: Liu ShuoX <shuox.liu@intel.com>
---
 fs/pstore/platform.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c
index 78c3c20..46d269e 100644
--- a/fs/pstore/platform.c
+++ b/fs/pstore/platform.c
@@ -497,6 +497,7 @@ void pstore_get_records(int quiet)
 							big_oops_buf_sz);
 
 			if (unzipped_len > 0) {
+				kfree(buf);
 				buf = big_oops_buf;
 				size = unzipped_len;
 				compressed = false;
-- 
1.8.3.2


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753579AbaCKGPc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 02:15:32 -0400
Received: from mga02.intel.com ([134.134.136.20]:23155 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751945AbaCKGPa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 02:15:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,629,1389772800"; 
   d="scan'208";a="470000336"
Date: Tue, 11 Mar 2014 14:15:19 +0800
From: Liu ShuoX <shuox.liu@intel.com>
To: linux-kernel@vger.kernel.org
Cc: anton@enomsg.org, ccross@android.com, keescook@chromium.org,
        tony.luck@intel.com, yanmin_zhang@linux.intel.com
Subject: [PATCH 1/2] pstore: fix NULL pointer fault if get NULL prz in
 ramoops_get_next_prz
Message-ID: <20140311061519.GA11552@lskakaxi-intel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These two patches are applied on top of patches:
https://lkml.org/lkml/2014/3/3/368
It has been added in -mm tree. Below is the first patch, and i will
send the second by replying this one.

From: Liu ShuoX <shuox.liu@intel.com>

ramoops_get_next_prz get the prz according the paramters. If it get a
uninitialized prz, access its members by following persistent_ram_old_size(prz)
will cause a NULL pointer crash.
Ex: if ftrace_size is 0, fprz will be NULL.

Fix it by return NULL in advance.

Signed-off-by: Liu ShuoX <shuox.liu@intel.com>
---
  fs/pstore/ram.c | 2 ++
  1 file changed, 2 insertions(+)

diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
index 1daed28..6f96d8c 100644
--- a/fs/pstore/ram.c
+++ b/fs/pstore/ram.c
@@ -119,6 +119,8 @@ ramoops_get_next_prz(struct persistent_ram_zone *przs[], uint *c, uint max,
  		return NULL;
  
  	prz = przs[i];
+	if (!prz)
+		return NULL;
  
  	/* Update old/shadowed buffer. */
  	if (update)
-- 
1.8.3.2

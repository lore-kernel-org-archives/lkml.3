Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932350AbbAPCHU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 21:07:20 -0500
Received: from mga11.intel.com ([192.55.52.93]:30151 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754941AbbAPCHS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 21:07:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,407,1418112000"; 
   d="scan'208";a="670790892"
Date: Fri, 16 Jan 2015 10:07:13 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Michael Halcrow <mhalcrow@google.com>
Cc: kbuild-all@01.org, "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH ext4] ext4 crypto: ext4_xattr_encryption_context_set() can be
 static
Message-ID: <20150116020713.GA50649@snb>
References: <201501161001.0s7ByimN%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201501161001.0s7ByimN%fengguang.wu@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: fengguang.wu@intel.com
X-SA-Exim-Scanned: No (on bee); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fs/ext4/xattr_encryption.c:80:5: sparse: symbol 'ext4_xattr_encryption_context_set' was not declared. Should it be static?

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 xattr_encryption.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/xattr_encryption.c b/fs/ext4/xattr_encryption.c
index d03697a..851064a 100644
--- a/fs/ext4/xattr_encryption.c
+++ b/fs/ext4/xattr_encryption.c
@@ -77,7 +77,7 @@ static int ext4_xattr_encryption_set(struct dentry *dentry, const char *name,
  * Made as a separate function on purpose, so that setting this value from user
  * space tools is not available through generic set attribute path.
  */
-int ext4_xattr_encryption_context_set(struct dentry *dentry, const void *value,
+static int ext4_xattr_encryption_context_set(struct dentry *dentry, const void *value,
 				      size_t size, int flags, int type)
 {
 	return ext4_xattr_set(dentry->d_inode,

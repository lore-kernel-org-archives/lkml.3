Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408Ab3ETIRY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 04:17:24 -0400
Received: from intranet.asianux.com ([58.214.24.6]:53897 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755141Ab3ETIRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 04:17:23 -0400
X-Spam-Score: -100.8
Message-ID: <5199DBE2.5080707@asianux.com>
Date: Mon, 20 May 2013 16:16:34 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: [PATCH] include/linux/posix_acl.h: need 'return NULL' when BUG(),
 if neither CONFIG_BUG nor HAVE_ARCH_BUG is defined.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


If neither CONFIG_BUG nor HAVE_ARCH_BUG is defined, the BUG() will
defined as empty (e.g. randconfig with MMU for arm s5pv210)

In this case, need 'return NULL' to let upper caller knows the failure.


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 include/linux/posix_acl.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/posix_acl.h b/include/linux/posix_acl.h
index 7931efe..2c48d06 100644
--- a/include/linux/posix_acl.h
+++ b/include/linux/posix_acl.h
@@ -104,6 +104,7 @@ static inline struct posix_acl **acl_by_type(struct inode *inode, int type)
 		return &inode->i_default_acl;
 	default:
 		BUG();
+		return NULL;
 	}
 }
 
-- 
1.7.7.6

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751304Ab3I0DcB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 23:32:01 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61672 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750722Ab3I0Db6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 23:31:58 -0400
X-IronPort-AV: E=Sophos;i="4.90,990,1371052800"; 
   d="scan'208";a="8636246"
Message-ID: <5244FBE4.5040400@cn.fujitsu.com>
Date: Fri, 27 Sep 2013 11:30:44 +0800
From: Duan Jiong <duanj.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130612 Thunderbird/17.0.6
MIME-Version: 1.0
To: Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        James Morris <james.l.morris@oracle.com>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] digsig: use ERR_CAST inlined function instead of ERR_PTR(PTR_ERR(...))
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/09/27 11:30:09,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/09/27 11:30:10,
	Serialize complete at 2013/09/27 11:30:10
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=GB2312
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Signed-off-by: Duan Jiong <duanj.fnst@cn.fujitsu.com>
---
 lib/digsig.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/digsig.c b/lib/digsig.c
index 2f31e6a..8793aed 100644
--- a/lib/digsig.c
+++ b/lib/digsig.c
@@ -209,7 +209,7 @@ int digsig_verify(struct key *keyring, const char *sig, int siglen,
 		kref = keyring_search(make_key_ref(keyring, 1UL),
 						&key_type_user, name);
 		if (IS_ERR(kref))
-			key = ERR_PTR(PTR_ERR(kref));
+			key = ERR_CAST(kref);
 		else
 			key = key_ref_to_ptr(kref);
 	} else {
-- 
1.8.3.1

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752913AbbAUWpP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 17:45:15 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:32962 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707AbbAUWpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 17:45:08 -0500
From: Guenter Roeck <linux@roeck-us.net>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Sabrina Dubroca <sd@queasysnail.net>, Paul Moore <pmoore@redhat.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH RESEND] fs: namei: Use memcpy instead of strlcpy
Date: Wed, 21 Jan 2015 14:44:25 -0800
Message-Id: <1421880265-26647-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 2.1.0
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020203.54C02BF4.0003,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 5
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the string length is known, there is no need to use strlcpy.
Use memcpy instead.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
Nitpick, but still a bit faster. Applies on top of -next.

Resending with correct cc:. Sorry for the noise.

 fs/namei.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/namei.c b/fs/namei.c
index 323957f..2e09219 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -233,7 +233,7 @@ getname_kernel(const char * filename)
 		__putname(result);
 		return ERR_PTR(-ENAMETOOLONG);
 	}
-	strlcpy((char *)result->name, filename, len);
+	memcpy((char *)result->name, filename, len);
 	result->uptr = NULL;
 	result->aname = NULL;
 	result->refcnt = 1;
-- 
2.1.0


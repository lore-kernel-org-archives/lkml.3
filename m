Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932380AbaKRVEG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 16:04:06 -0500
Received: from mout.web.de ([212.227.15.14]:52584 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754508AbaKRVEE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 16:04:04 -0500
Message-ID: <546BB427.2050101@users.sourceforge.net>
Date: Tue, 18 Nov 2014 22:03:35 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>,
        James Morris <james.l.morris@oracle.com>,
        "Serge E. Hallyn" <serge@hallyn.com>, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Coccinelle <cocci@systeme.lip6.fr>
Subject: [PATCH 1/1] keys: Deletion of an unnecessary check before the function
 call "key_put"
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:YKAN0lZMMAf5Bt7WOyYJ6U8kxU79abntwbklvaOIWxJYWm7ehkA
 eHLSfAldVC9vqtBeQICAjocy52cduD1xKf9nU11lRs5d1L+JIsNQcNa8CSJ3rWbPcVB6pUF
 BltLxUsE5T1ZmsvQ5vjZchDwEcT7ou1jGVRdFY0knnX5c8JYFB1RHCQtHe6PUDKZXA0J508
 WoCX8cGgqOcWnRPuEPK5Q==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 18 Nov 2014 21:57:14 +0100

The key_put() function tests whether its argument is NULL and then
returns immediately. Thus the test around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 security/keys/process_keys.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/security/keys/process_keys.c b/security/keys/process_keys.c
index 0cf8a13..ce00e11 100644
--- a/security/keys/process_keys.c
+++ b/security/keys/process_keys.c
@@ -242,8 +242,7 @@ int install_session_keyring_to_cred(struct cred *cred, struct key *keyring)
 	old = cred->session_keyring;
 	rcu_assign_pointer(cred->session_keyring, keyring);
 
-	if (old)
-		key_put(old);
+	key_put(old);
 
 	return 0;
 }
-- 
2.1.3


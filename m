Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751289AbaGZXJD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 19:09:03 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:33281 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbaGZXJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 19:09:01 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Monam Agarwal <monamagarwal123@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: ced1401: userspace: use1401.c:  Cleaning up missing null-terminate in conjunction with strncpy
Date: Sun, 27 Jul 2014 01:10:25 +0200
Message-Id: <1406416225-8795-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replacing strncpy with strlcpy to avoid strings that lacks null terminate.
And replacing strncat with strlcat because of incorrect use.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/staging/ced1401/userspace/use1401.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/ced1401/userspace/use1401.c b/drivers/staging/ced1401/userspace/use1401.c
index 7b8a222..2d15df8 100644
--- a/drivers/staging/ced1401/userspace/use1401.c
+++ b/drivers/staging/ced1401/userspace/use1401.c
@@ -693,7 +693,7 @@ U14API(short) U14DriverName(short hand, char* pBuf, unsigned short wMax)
     case 3:  pName = "HSS"; break;
     default: pName = "???"; break;
     }
-    strncpy(pBuf, pName, wMax);            // Copy the correct name to return
+    strlcpy(pBuf, pName, wMax);            /* Copy the correct name to return */
 
     return U14ERR_NOERROR;
 }
@@ -1079,7 +1079,7 @@ U14API(short) U14NameOf1401(short hand, char* pBuf, unsigned short wMax)
     case U14TYPEPOWER3:pName = "Power1401-3"; break;
     default:           pName = "Unknown";
     }
-        strncpy(pBuf, pName, wMax);
+    strlcpy(pBuf, pName, wMax);
     }
     return sErr;
 }
@@ -2891,10 +2891,10 @@ U14API(unsigned int) U14Ld(short hand, const char* vl, const char* str)
                 ++dwIndex;                      // Keep count of command number, first is 1
                 szFName[iLoop2]=(char)0;        // null terminate name of command
 
-                strncpy(szLastName, szFName, sizeof(szLastName));    // Save for error info
-                szLastName[sizeof(szLastName)-1] = 0;
-                strncat(szLastName, szFExt, sizeof(szLastName));     // with extension included
-                szLastName[sizeof(szLastName)-1] = 0;
+                /* Save for error info */
+                strlcpy(szLastName, szFName, sizeof(szLastName));
+                /* with extension included */
+                strlcat(szLastName, szFExt, sizeof(szLastName));
 
                 U14SendString(hand, szFName);   // ask if loaded
                 U14SendString(hand, ";ERR;");   // add err return
-- 
1.7.10.4


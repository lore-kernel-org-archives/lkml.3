Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751209AbaFNWzl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 18:55:41 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:58113 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852AbaFNWzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 18:55:37 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Monam Agarwal <monamagarwal123@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: ced1401: userspace: use1401.c:  Cleaning up if statement that always evaluates to true
Date: Sun, 15 Jun 2014 00:56:32 +0200
Message-Id: <1402786592-13308-2-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1402786592-13308-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1402786592-13308-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unsigned variable can't be negative so it is unnecessary to test it.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/staging/ced1401/userspace/use1401.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/ced1401/userspace/use1401.c b/drivers/staging/ced1401/userspace/use1401.c
index 7b8a222..9ebddbd 100644
--- a/drivers/staging/ced1401/userspace/use1401.c
+++ b/drivers/staging/ced1401/userspace/use1401.c
@@ -1744,13 +1744,8 @@ U14API(short) U14GetString(short hand, char* pBuffer, unsigned short wMaxLen)
                                     &dwBytes, NULL);
                     if (iOK)                        /* Device IO control OK ? */
                     {
-                        if (dwBytes >= 0)           /* If driver OK */
-                        {
-                            strcpy(pBuffer, tstr);
-                            sErr = U14ERR_NOERROR;
-                        }
-                        else
-                            sErr = U14ERR_DRIVCOMMS;
+                        strcpy(pBuffer, tstr);
+                        sErr = U14ERR_NOERROR;
                     }
                     else
                     {
-- 
1.7.10.4


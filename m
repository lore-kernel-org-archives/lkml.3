Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751355AbaLNWdw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 17:33:52 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:63269 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952AbaLNWdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 17:33:43 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Oleg Drokin <oleg.drokin@intel.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Julia Lawall <Julia.Lawall@lip6.fr>, Greg Donald <gdonald@gmail.com>,
        "John L. Hammond" <john.hammond@intel.com>,
        Andriy Skulysh <Andriy_Skulysh@xyratex.com>,
        Fabian Frederick <fabf@skynet.be>, James Simmons <uja.ornl@gmail.com>,
        HPDD-discuss@ml01.01.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: lustre: lustre: obdclass: lprocfs_status.c:  Fix for possible null pointer dereference
Date: Sun, 14 Dec 2014 23:36:22 +0100
Message-Id: <1418596582-24557-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is otherwise a risk of a possible null pointer dereference.

Was largely found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 .../lustre/lustre/obdclass/lprocfs_status.c        |   20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c b/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c
index 61e04af..4a7891a 100644
--- a/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c
+++ b/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c
@@ -1897,17 +1897,15 @@ int lprocfs_write_frac_u64_helper(const char *buffer, unsigned long count,
 	}
 
 	units = 1;
-	switch (*end) {
-	case 'p': case 'P':
-		units <<= 10;
-	case 't': case 'T':
-		units <<= 10;
-	case 'g': case 'G':
-		units <<= 10;
-	case 'm': case 'M':
-		units <<= 10;
-	case 'k': case 'K':
-		units <<= 10;
+	if (end) {
+		switch (*end) {
+		case 'p': case 'P':
+		case 't': case 'T':
+		case 'g': case 'G':
+		case 'm': case 'M':
+		case 'k': case 'K':
+			units <<= 10;
+		}
 	}
 	/* Specified units override the multiplier */
 	if (units)
-- 
1.7.10.4


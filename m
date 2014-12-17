Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751598AbaLQWCR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 17:02:17 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:60681 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbaLQWCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 17:02:16 -0500
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
Subject: [PATCH] staging: lustre: lustre: obdclass: lprocfs_status.c:  Removed an unnecessary NULL check
Date: Wed, 17 Dec 2014 23:05:00 +0100
Message-Id: <1418853900-6887-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed an unnecessary NULL check. And clarified a switch statement.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/staging/lustre/lustre/obdclass/lprocfs_status.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c b/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c
index 61e04af..bf3353f 100644
--- a/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c
+++ b/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c
@@ -45,6 +45,7 @@
 #include "../include/lprocfs_status.h"
 #include "../include/lustre/lustre_idl.h"
 #include <linux/seq_file.h>
+#include <linux/ctype.h>
 
 static const char * const obd_connect_names[] = {
 	"read_only",
@@ -1882,7 +1883,7 @@ int lprocfs_write_frac_u64_helper(const char *buffer, unsigned long count,
 	if (pbuf == end)
 		return -EINVAL;
 
-	if (end != NULL && *end == '.') {
+	if (*end == '.') {
 		int i;
 		pbuf = end + 1;
 
@@ -1897,16 +1898,16 @@ int lprocfs_write_frac_u64_helper(const char *buffer, unsigned long count,
 	}
 
 	units = 1;
-	switch (*end) {
-	case 'p': case 'P':
+	switch (tolower(*end)) {
+	case 'p':
 		units <<= 10;
-	case 't': case 'T':
+	case 't':
 		units <<= 10;
-	case 'g': case 'G':
+	case 'g':
 		units <<= 10;
-	case 'm': case 'M':
+	case 'm':
 		units <<= 10;
-	case 'k': case 'K':
+	case 'k':
 		units <<= 10;
 	}
 	/* Specified units override the multiplier */
-- 
1.7.10.4


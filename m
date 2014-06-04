Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751848AbaFDVYJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 17:24:09 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:44371 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339AbaFDVYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 17:24:07 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Randy Dunlap <rdunlap@infradead.org>,
        Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Documentation: accounting: getdelays.c:  Cleaning up missing null-terminate after strncpy call
Date: Wed,  4 Jun 2014 23:25:00 +0200
Message-Id: <1401917100-2584-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added a guaranteed null-terminate after call to strncpy.

This was partly found using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 Documentation/accounting/getdelays.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/accounting/getdelays.c b/Documentation/accounting/getdelays.c
index c6a06b7..f405780 100644
--- a/Documentation/accounting/getdelays.c
+++ b/Documentation/accounting/getdelays.c
@@ -314,6 +314,7 @@ int main(int argc, char *argv[])
 			break;
 		case 'm':
 			strncpy(cpumask, optarg, sizeof(cpumask));
+			cpumask[sizeof(cpumask) - 1] = '\0';
 			maskset = 1;
 			printf("cpumask %s maskset %d\n", cpumask, maskset);
 			break;
-- 
1.7.10.4


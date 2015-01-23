Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754938AbbAWLr2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 06:47:28 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:39839 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754497AbbAWLrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 06:47:15 -0500
Date: Fri, 23 Jan 2015 20:44:28 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: lidza.louina@gmail.com, markh@compro.net
Cc: markh@compro.net, daeseok.youn@gmail.com, gregkh@linuxfoundation.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, dan.carpenter@oracle.com,
        dcb314@hotmail.com
Subject: [PATCH] staging: dgap: fix "if" statement that always evaluates to
 true
Message-ID: <20150123114428.GA5450@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cppcheck warning:
(warnning) Logical disjunction always evaluates to true

Reported-by: David Binderman <dcb314@hotmail.com>
Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/dgap/dgap.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/dgap/dgap.c b/drivers/staging/dgap/dgap.c
index 518ab56..7184747 100644
--- a/drivers/staging/dgap/dgap.c
+++ b/drivers/staging/dgap/dgap.c
@@ -978,8 +978,8 @@ static int dgap_parsefile(char **in)
 				brd->u.board.conc1++;
 
 			conc_type = dgap_gettok(in);
-			if (conc_type == 0 || conc_type != CX ||
-			    conc_type != EPC) {
+			if (conc_type == 0 || (conc_type != CX &&
+			    conc_type != EPC)) {
 				pr_err("failed to set a type of concentratros");
 				return -1;
 			}
@@ -1019,8 +1019,8 @@ static int dgap_parsefile(char **in)
 				brd->u.board.module1++;
 
 			module_type = dgap_gettok(in);
-			if (module_type == 0 || module_type != PORTS ||
-			    module_type != MODEM) {
+			if (module_type == 0 || (module_type != PORTS &&
+			    module_type != MODEM)) {
 				pr_err("failed to set a type of module");
 				return -1;
 			}
-- 
1.7.1


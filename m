Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754937AbbAJTu2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 14:50:28 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:53849 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685AbbAJTu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 14:50:26 -0500
From: Lorenzo Stoakes <lstoakes@gmail.com>
To: gregkh@linuxfoundation.org
Cc: anarey@gmail.com, mcgrof@do-not-panic.com, tapaswenipathak@gmail.com,
        joe@perches.com, rmfrfs@gmail.com, yejiayily@gmail.com,
        gdonald@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Lorenzo Stoakes <lstoakes@gmail.com>
Subject: [PATCH RESEND 4/4] staging: rtl8192u: Refactor heavy nesting
Date: Sat, 10 Jan 2015 14:19:14 +0000
Message-Id: <1420899554-14120-4-git-send-email-lstoakes@gmail.com>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <1420899554-14120-1-git-send-email-lstoakes@gmail.com>
References: <1420899554-14120-1-git-send-email-lstoakes@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes warnings raised by checkpatch.pl relating to heavily indented
lines in r8192U_dm.c by refactoring code to achieve the same outcome indented by
one less tab.

Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
---
 drivers/staging/rtl8192u/r8192U_dm.c | 27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/rtl8192u/r8192U_dm.c b/drivers/staging/rtl8192u/r8192U_dm.c
index ed566bb..bae8511 100644
--- a/drivers/staging/rtl8192u/r8192U_dm.c
+++ b/drivers/staging/rtl8192u/r8192U_dm.c
@@ -2581,28 +2581,25 @@ static void dm_rxpath_sel_byrssi(struct net_device *dev)
 						cck_rx_ver2_sec_index = cck_rx_ver2_max_index;
 						tmp_cck_max_pwdb = cur_cck_pwdb;
 						cck_rx_ver2_max_index = i;
-					} else if (cur_cck_pwdb == tmp_cck_max_pwdb) { /* let sec and min point to the different index */
+					} else if (cur_cck_pwdb == tmp_cck_max_pwdb) {
+						/* let sec and min point to the different index */
 						tmp_cck_sec_pwdb = cur_cck_pwdb;
 						cck_rx_ver2_sec_index = i;
 					} else if ((cur_cck_pwdb < tmp_cck_max_pwdb) && (cur_cck_pwdb > tmp_cck_sec_pwdb)) {
 						tmp_cck_sec_pwdb = cur_cck_pwdb;
 						cck_rx_ver2_sec_index = i;
-					} else if (cur_cck_pwdb == tmp_cck_sec_pwdb) {
-						if (tmp_cck_sec_pwdb == tmp_cck_min_pwdb) { /* let sec and min point to the different index */
-							tmp_cck_sec_pwdb = cur_cck_pwdb;
-							cck_rx_ver2_sec_index = i;
-						} else {
-							/*  This case we don't need to set any index */
-						}
+					} else if (cur_cck_pwdb == tmp_cck_sec_pwdb && tmp_cck_sec_pwdb == tmp_cck_min_pwdb) {
+						/* let sec and min point to the different index */
+						tmp_cck_sec_pwdb = cur_cck_pwdb;
+						cck_rx_ver2_sec_index = i;
+						/* otherwise we don't need to set any index */
 					} else if ((cur_cck_pwdb < tmp_cck_sec_pwdb) && (cur_cck_pwdb > tmp_cck_min_pwdb)) {
 						/*  This case we don't need to set any index */
-					} else if (cur_cck_pwdb == tmp_cck_min_pwdb) {
-						if (tmp_cck_sec_pwdb == tmp_cck_min_pwdb) { /*  let sec and min point to the different index */
-							tmp_cck_min_pwdb = cur_cck_pwdb;
-							cck_rx_ver2_min_index = i;
-						} else {
-							/*  This case we don't need to set any index */
-						}
+					} else if (cur_cck_pwdb == tmp_cck_min_pwdb && tmp_cck_sec_pwdb == tmp_cck_min_pwdb) {
+						/*  let sec and min point to the different index */
+						tmp_cck_min_pwdb = cur_cck_pwdb;
+						cck_rx_ver2_min_index = i;
+						/* otherwise we don't need to set any index */
 					} else if (cur_cck_pwdb < tmp_cck_min_pwdb) {
 						tmp_cck_min_pwdb = cur_cck_pwdb;
 						cck_rx_ver2_min_index = i;
--
2.2.1

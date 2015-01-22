Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752230AbbAVGvN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 01:51:13 -0500
Received: from smtp1.cypress.com ([157.95.67.100]:52678 "EHLO
	smtp1.cypress.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199AbbAVGvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 01:51:00 -0500
From: Dudley Du <dudl@cypress.com>
To: dmitry.torokhov@gmail.com, jmmahler@gmail.com, rydberg@euromail.se
Cc: Dudley Du <dudl@cypress.com>, bleung@google.com, dan.carpenter@oracle.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] input: cyapa: fix variable dereferenced before check 'gen5_pip->resp_len' issue
Date: Thu, 22 Jan 2015 14:50:06 +0800
Message-Id: <1421909406-1240-2-git-send-email-dudl@cypress.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421909406-1240-1-git-send-email-dudl@cypress.com>
References: <1421909406-1240-1-git-send-email-dudl@cypress.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes the warning issue of the variable dereferenced before check
'gen5_pip->resp_len' report by dan Carpenter.

Signed-off-by: Dudley Du <dudl@cypress.com>
---
 drivers/input/mouse/cyapa_gen5.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/input/mouse/cyapa_gen5.c b/drivers/input/mouse/cyapa_gen5.c
index 69d9059..ed1af74 100644
--- a/drivers/input/mouse/cyapa_gen5.c
+++ b/drivers/input/mouse/cyapa_gen5.c
@@ -2558,7 +2558,9 @@ static bool cyapa_gen5_irq_cmd_handler(struct cyapa *cyapa)
 			 * trackpad device when booting/rebooting
 			 * their chrome book.
 			 */
-			length = *gen5_pip->resp_len;
+			length = 0;
+			if (gen5_pip->resp_len)
+				length = *gen5_pip->resp_len;
 			cyapa_empty_pip_output_data(cyapa,
 					gen5_pip->resp_data,
 					&length,
-- 
1.9.1


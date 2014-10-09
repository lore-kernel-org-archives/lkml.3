Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932584AbaJIVJW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:09:22 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59345 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757586AbaJIVJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:09:12 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 089/163] Input: atkbd - do not try 'deactivate' keyboard on any LG laptops
Date: Thu,  9 Oct 2014 14:01:54 -0700
Message-Id: <1412888588-26755-90-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412888588-26755-1-git-send-email-kamal@canonical.com>
References: <1412888588-26755-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit c01206796139e2b1feb7539bc72174fef1c6dc6e upstream.

We are getting more and more reports about LG laptops not having
functioning keyboard if we try to deactivate keyboard during probe.
Given that having keyboard deactivated is merely "nice to have"
instead of a hard requirement for probing, let's disable it on all
LG boxes instead of trying to hunt down particular models.

This change is prompted by patches trying to add "LG Electronics"/"ROCKY"
and "LG Electronics"/"LW60-F27B" to the DMI list.

https://bugzilla.kernel.org/show_bug.cgi?id=77051

Reported-by: Jaime Velasco Juan <jsagarribay@gmail.com>
Reported-by: Georgios Tsalikis <georgios@tsalikis.net>
Tested-by: Jaime Velasco Juan <jsagarribay@gmail.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/input/keyboard/atkbd.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/input/keyboard/atkbd.c b/drivers/input/keyboard/atkbd.c
index 2dd1d0d..6f5d795 100644
--- a/drivers/input/keyboard/atkbd.c
+++ b/drivers/input/keyboard/atkbd.c
@@ -1791,14 +1791,6 @@ static const struct dmi_system_id atkbd_dmi_quirk_table[] __initconst = {
 	{
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "LG Electronics"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "LW25-B7HV"),
-		},
-		.callback = atkbd_deactivate_fixup,
-	},
-	{
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "LG Electronics"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "P1-J273B"),
 		},
 		.callback = atkbd_deactivate_fixup,
 	},
-- 
1.9.1


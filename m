Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293AbaJCWep (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 18:34:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47847 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753301AbaJCWeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:34:19 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jaime Velasco Juan <jsagarribay@gmail.com>,
        Georgios Tsalikis <georgios@tsalikis.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 3.10 099/143] Input: atkbd - do not try deactivate keyboard on any LG laptops
Date: Fri,  3 Oct 2014 14:34:54 -0700
Message-Id: <20141003213317.460963543@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003213314.470709810@linuxfoundation.org>
References: <20141003213314.470709810@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/keyboard/atkbd.c |    8 --------
 1 file changed, 8 deletions(-)

--- a/drivers/input/keyboard/atkbd.c
+++ b/drivers/input/keyboard/atkbd.c
@@ -1791,14 +1791,6 @@ static const struct dmi_system_id atkbd_
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



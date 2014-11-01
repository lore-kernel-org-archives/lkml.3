Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968AbaKAWpq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 18:45:46 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60269 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751759AbaKAWjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 18:39:31 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Dmitry Torokhov" <dmitry.torokhov@gmail.com>,
        "Hans de Goede" <hdegoede@redhat.com>
Date: Sat, 01 Nov 2014 22:28:03 +0000
Message-ID: <lsq.1414880883.724735935@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 030/102] Input: elantech - fix detection of touchpad
 on ASUS s301l
In-Reply-To: <lsq.1414880882.522510247@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.64-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit 271329b3c798b2102120f5df829071c211ef00ed upstream.

Adjust Elantech signature validation to account fo rnewer models of
touchpads.

Reported-and-tested-by: Màrius Monton <marius.monton@gmail.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/input/mouse/elantech.c | 7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/input/mouse/elantech.c
+++ b/drivers/input/mouse/elantech.c
@@ -1130,6 +1130,13 @@ static bool elantech_is_signature_valid(
 	if (param[1] == 0)
 		return true;
 
+	/*
+	 * Some models have a revision higher then 20. Meaning param[2] may
+	 * be 10 or 20, skip the rates check for these.
+	 */
+	if (param[0] == 0x46 && (param[1] & 0xef) == 0x0f && param[2] < 40)
+		return true;
+
 	for (i = 0; i < ARRAY_SIZE(rates); i++)
 		if (param[2] == rates[i])
 			return false;


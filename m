Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932465AbaJIVHR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:07:17 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59092 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932400AbaJIVHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:07:12 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Hans de Goede <hdegoede@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 041/163] Input: elantech - fix detection of touchpad on ASUS s301l
Date: Thu,  9 Oct 2014 14:01:06 -0700
Message-Id: <1412888588-26755-42-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412888588-26755-1-git-send-email-kamal@canonical.com>
References: <1412888588-26755-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit 271329b3c798b2102120f5df829071c211ef00ed upstream.

Adjust Elantech signature validation to account fo rnewer models of
touchpads.

Reported-and-tested-by: Màrius Monton <marius.monton@gmail.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/input/mouse/elantech.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/input/mouse/elantech.c b/drivers/input/mouse/elantech.c
index 233516a..0b75b57 100644
--- a/drivers/input/mouse/elantech.c
+++ b/drivers/input/mouse/elantech.c
@@ -1253,6 +1253,13 @@ static bool elantech_is_signature_valid(const unsigned char *param)
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
-- 
1.9.1


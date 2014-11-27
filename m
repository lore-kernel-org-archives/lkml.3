Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932110AbaK0JQ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 04:16:29 -0500
Received: from mail.kernel.org ([198.145.19.201]:41497 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754692AbaK0Iq7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 03:46:59 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 25/91] Input: elantech - fix detection of touchpad on ASUS s301l
Date: Thu, 27 Nov 2014 16:42:08 +0800
Message-Id: <1417077794-9299-25-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417077368-9217-1-git-send-email-lizf@kernel.org>
References: <1417077368-9217-1-git-send-email-lizf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

3.4.105-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit 271329b3c798b2102120f5df829071c211ef00ed upstream.

Adjust Elantech signature validation to account fo rnewer models of
touchpads.

Reported-and-tested-by: Màrius Monton <marius.monton@gmail.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 drivers/input/mouse/elantech.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/input/mouse/elantech.c b/drivers/input/mouse/elantech.c
index d93ea64..f2c2ffe 100644
--- a/drivers/input/mouse/elantech.c
+++ b/drivers/input/mouse/elantech.c
@@ -1218,6 +1218,13 @@ static bool elantech_is_signature_valid(const unsigned char *param)
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


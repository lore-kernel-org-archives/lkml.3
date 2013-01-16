Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758085Ab3APQwm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:52:42 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36053 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757984Ab3APQCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:02:51 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 084/222] pnpacpi: fix incorrect TEST_ALPHA() test
Date: Wed, 16 Jan 2013 13:54:44 -0200
Message-Id: <1358351822-7675-85-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Cox <alan@lxorguk.ukuu.org.uk>

commit cdc87c5a30f407ed1ce43d8a22261116873d5ef1 upstream.

TEST_ALPHA() is broken and always returns 0.

[akpm@linux-foundation.org: return false for '@' as well, per Bjorn]
Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/pnp/pnpacpi/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pnp/pnpacpi/core.c b/drivers/pnp/pnpacpi/core.c
index e353788..291906e 100644
--- a/drivers/pnp/pnpacpi/core.c
+++ b/drivers/pnp/pnpacpi/core.c
@@ -58,7 +58,7 @@ static inline int __init is_exclusive_device(struct acpi_device *dev)
 	if (!(('0' <= (c) && (c) <= '9') || ('A' <= (c) && (c) <= 'F'))) \
 		return 0
 #define TEST_ALPHA(c) \
-	if (!('@' <= (c) || (c) <= 'Z')) \
+	if (!('A' <= (c) && (c) <= 'Z')) \
 		return 0
 static int __init ispnpidacpi(const char *id)
 {
-- 
1.7.9.5


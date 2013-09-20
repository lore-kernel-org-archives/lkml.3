Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292Ab3ITUPh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 16:15:37 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41780 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755186Ab3ITUPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 16:15:30 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Kees Cook <keescook@chromium.org>, Jiri Kosina <jkosina@suse.cz>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 74/93] HID: picolcd_core: validate output report details
Date: Fri, 20 Sep 2013 13:09:09 -0700
Message-Id: <1379707768-1804-75-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379707768-1804-1-git-send-email-kamal@canonical.com>
References: <1379707768-1804-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

commit 1e87a2456b0227ca4ab881e19a11bb99d164e792 upstream.

A HID device could send a malicious output report that would cause the
picolcd HID driver to trigger a NULL dereference during attr file writing.

[jkosina@suse.cz: changed

	report->maxfield < 1

to

	report->maxfield != 1

as suggested by Bruno].

CVE-2013-2899

Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Bruno Prémont <bonbons@linux-vserver.org>
Acked-by: Bruno Prémont <bonbons@linux-vserver.org>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/hid/hid-picolcd_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/hid-picolcd_core.c b/drivers/hid/hid-picolcd_core.c
index 86df26e..775252d 100644
--- a/drivers/hid/hid-picolcd_core.c
+++ b/drivers/hid/hid-picolcd_core.c
@@ -292,7 +292,7 @@ static ssize_t picolcd_operation_mode_store(struct device *dev,
 		buf += 10;
 		cnt -= 10;
 	}
-	if (!report)
+	if (!report || report->maxfield != 1)
 		return -EINVAL;
 
 	while (cnt > 0 && (buf[cnt-1] == '\n' || buf[cnt-1] == '\r'))
-- 
1.8.1.2


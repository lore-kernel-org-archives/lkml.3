Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240Ab3ITUP0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 16:15:26 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41731 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755186Ab3ITUPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 16:15:13 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Kees Cook <keescook@chromium.org>, Jiri Kosina <jkosina@suse.cz>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 75/93] HID: check for NULL field when setting values
Date: Fri, 20 Sep 2013 13:09:10 -0700
Message-Id: <1379707768-1804-76-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379707768-1804-1-git-send-email-kamal@canonical.com>
References: <1379707768-1804-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

commit be67b68d52fa28b9b721c47bb42068f0c1214855 upstream.

Defensively check that the field to be worked on is not NULL.

Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/hid/hid-core.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 194597f..869ead1 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1157,7 +1157,12 @@ EXPORT_SYMBOL_GPL(hid_output_report);
 
 int hid_set_field(struct hid_field *field, unsigned offset, __s32 value)
 {
-	unsigned size = field->report_size;
+	unsigned size;
+
+	if (!field)
+		return -1;
+
+	size = field->report_size;
 
 	hid_dump_input(field->report->device, field->usage + offset, value);
 
-- 
1.8.1.2


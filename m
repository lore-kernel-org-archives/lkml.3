Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148Ab3I3KSo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 06:18:44 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43779 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755777Ab3I3KN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 06:13:27 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Kees Cook <keescook@chromium.org>, Jiri Kosina <jkosina@suse.cz>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 087/104] HID: check for NULL field when setting values
Date: Mon, 30 Sep 2013 11:11:04 +0100
Message-Id: <1380535881-9239-88-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
References: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.22 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

commit be67b68d52fa28b9b721c47bb42068f0c1214855 upstream.

Defensively check that the field to be worked on is not NULL.

Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/hid/hid-core.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 104792d..0d76d3f 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1133,7 +1133,12 @@ EXPORT_SYMBOL_GPL(hid_output_report);
 
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
1.8.3.2


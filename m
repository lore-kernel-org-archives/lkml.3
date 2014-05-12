Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139AbaELBne (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 21:43:34 -0400
Received: from 1wt.eu ([62.212.114.60]:34734 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753990AbaELBnb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 21:43:31 -0400
Message-Id: <20140512003201.590584448@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 May 2014 02:32:23 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, stable@kernel.org,
        Jiri Kosina <jkosina@suse.cz>, Willy Tarreau <w@1wt.eu>
Subject: [ 023/143] HID: check for NULL field when setting values
In-Reply-To: <f07e5fe6d87f172fc73580b9c86ba9a2@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

commit be67b68d52fa28b9b721c47bb42068f0c1214855 upstream

Defensively check that the field to be worked on is not NULL.

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: stable@kernel.org
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/hid/hid-core.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index e40e3c4..a222cbb 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -983,7 +983,12 @@ EXPORT_SYMBOL_GPL(hid_output_report);
 
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
1.7.12.2.21.g234cd45.dirty




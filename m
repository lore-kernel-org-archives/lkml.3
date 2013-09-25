Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932564Ab3IYBZ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 21:25:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38638 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755476Ab3IYAMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 20:12:37 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Kees Cook <keescook@chromium.org>, Jiri Kosina <jkosina@suse.cz>
Subject: [ 27/40] HID: check for NULL field when setting values
Date: Tue, 24 Sep 2013 17:11:59 -0700
Message-Id: <20130925001044.898155335@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130925001041.939335518@linuxfoundation.org>
References: <20130925001041.939335518@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

commit be67b68d52fa28b9b721c47bb42068f0c1214855 upstream.

Defensively check that the field to be worked on is not NULL.

Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/hid-core.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -999,7 +999,12 @@ EXPORT_SYMBOL_GPL(hid_output_report);
 
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
 



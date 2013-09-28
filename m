Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856Ab3I1D5v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 23:57:51 -0400
Received: from mail-in-05.arcor-online.net ([151.189.21.45]:57972 "EHLO
	mail-in-05.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754578Ab3I1D5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 23:57:49 -0400
X-Greylist: Passed host: 188.110.82.81
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-14.arcor-online.net 6E4749BE15
X-Greylist: Passed host: 188.110.82.81
X-Greylist: Passed host: 188.110.82.81
X-Greylist: Passed host: 188.110.82.81
Subject: [PATCH] HID: roccat: Fix "cannot create duplicate filename"
 problems
From: Stefan Achatz <erazor_de@users.sourceforge.net>
Reply-To: erazor_de@users.sourceforge.net
To: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 28 Sep 2013 05:57:46 +0200
Message-ID: <1380340666.2451.4.camel@neuromancer.tessier-ashpool>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixing some wrong macro stringification/concatenation.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Stefan Achatz <erazor_de@users.sourceforge.net>
---
 drivers/hid/hid-roccat-kone.c     |    2 +-
 drivers/hid/hid-roccat-koneplus.c |    4 ++--
 drivers/hid/hid-roccat-kovaplus.c |    4 ++--
 drivers/hid/hid-roccat-pyra.c     |    4 ++--
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/hid/hid-roccat-kone.c b/drivers/hid/hid-roccat-kone.c
index 602c188..6101816 100644
--- a/drivers/hid/hid-roccat-kone.c
+++ b/drivers/hid/hid-roccat-kone.c
@@ -382,7 +382,7 @@ static ssize_t kone_sysfs_write_profilex(struct file *fp,
 }
 #define PROFILE_ATTR(number)					\
 static struct bin_attribute bin_attr_profile##number = {	\
-	.attr = { .name = "profile##number", .mode = 0660 },	\
+	.attr = { .name = "profile" #number, .mode = 0660 },	\
 	.size = sizeof(struct kone_profile),			\
 	.read = kone_sysfs_read_profilex,			\
 	.write = kone_sysfs_write_profilex,			\
diff --git a/drivers/hid/hid-roccat-koneplus.c b/drivers/hid/hid-roccat-koneplus.c
index 5ddf605..5e99fcd 100644
--- a/drivers/hid/hid-roccat-koneplus.c
+++ b/drivers/hid/hid-roccat-koneplus.c
@@ -229,13 +229,13 @@ static ssize_t koneplus_sysfs_read_profilex_buttons(struct file *fp,
 
 #define PROFILE_ATTR(number)						\
 static struct bin_attribute bin_attr_profile##number##_settings = {	\
-	.attr = { .name = "profile##number##_settings", .mode = 0440 },	\
+	.attr = { .name = "profile" #number "_settings", .mode = 0440 },	\
 	.size = KONEPLUS_SIZE_PROFILE_SETTINGS,				\
 	.read = koneplus_sysfs_read_profilex_settings,			\
 	.private = &profile_numbers[number-1],				\
 };									\
 static struct bin_attribute bin_attr_profile##number##_buttons = {	\
-	.attr = { .name = "profile##number##_buttons", .mode = 0440 },	\
+	.attr = { .name = "profile" #number "_buttons", .mode = 0440 },	\
 	.size = KONEPLUS_SIZE_PROFILE_BUTTONS,				\
 	.read = koneplus_sysfs_read_profilex_buttons,			\
 	.private = &profile_numbers[number-1],				\
diff --git a/drivers/hid/hid-roccat-kovaplus.c b/drivers/hid/hid-roccat-kovaplus.c
index 515bc03..0c8e1ef 100644
--- a/drivers/hid/hid-roccat-kovaplus.c
+++ b/drivers/hid/hid-roccat-kovaplus.c
@@ -257,13 +257,13 @@ static ssize_t kovaplus_sysfs_read_profilex_buttons(struct file *fp,
 
 #define PROFILE_ATTR(number)						\
 static struct bin_attribute bin_attr_profile##number##_settings = {	\
-	.attr = { .name = "profile##number##_settings", .mode = 0440 },	\
+	.attr = { .name = "profile" #number "_settings", .mode = 0440 },	\
 	.size = KOVAPLUS_SIZE_PROFILE_SETTINGS,				\
 	.read = kovaplus_sysfs_read_profilex_settings,			\
 	.private = &profile_numbers[number-1],				\
 };									\
 static struct bin_attribute bin_attr_profile##number##_buttons = {	\
-	.attr = { .name = "profile##number##_buttons", .mode = 0440 },	\
+	.attr = { .name = "profile" #number "_buttons", .mode = 0440 },	\
 	.size = KOVAPLUS_SIZE_PROFILE_BUTTONS,				\
 	.read = kovaplus_sysfs_read_profilex_buttons,			\
 	.private = &profile_numbers[number-1],				\
diff --git a/drivers/hid/hid-roccat-pyra.c b/drivers/hid/hid-roccat-pyra.c
index 5a6dbbe..1a07e07 100644
--- a/drivers/hid/hid-roccat-pyra.c
+++ b/drivers/hid/hid-roccat-pyra.c
@@ -225,13 +225,13 @@ static ssize_t pyra_sysfs_read_profilex_buttons(struct file *fp,
 
 #define PROFILE_ATTR(number)						\
 static struct bin_attribute bin_attr_profile##number##_settings = {	\
-	.attr = { .name = "profile##number##_settings", .mode = 0440 },	\
+	.attr = { .name = "profile" #number "_settings", .mode = 0440 },	\
 	.size = PYRA_SIZE_PROFILE_SETTINGS,				\
 	.read = pyra_sysfs_read_profilex_settings,			\
 	.private = &profile_numbers[number-1],				\
 };									\
 static struct bin_attribute bin_attr_profile##number##_buttons = {	\
-	.attr = { .name = "profile##number##_buttons", .mode = 0440 },	\
+	.attr = { .name = "profile" #number "_buttons", .mode = 0440 },	\
 	.size = PYRA_SIZE_PROFILE_BUTTONS,				\
 	.read = pyra_sysfs_read_profilex_buttons,			\
 	.private = &profile_numbers[number-1],				\
-- 
1.7.3.4




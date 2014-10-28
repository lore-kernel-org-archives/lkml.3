Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754368AbaJ1P11 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 11:27:27 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:63173 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754061AbaJ1P10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 11:27:26 -0400
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
To: linux-kernel@vger.kernel.org
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 1/2] kobject: Add kobject_initialized() function
Date: Tue, 28 Oct 2014 16:26:47 +0100
Message-Id: <1414510008-7262-1-git-send-email-tomeu.vizoso@collabora.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To be used by users of kobject to tell when one hasn't been initialized yet.

Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
---
 include/linux/kobject.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/kobject.h b/include/linux/kobject.h
index 2d61b90..6bb5a92 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -88,6 +88,11 @@ static inline const char *kobject_name(const struct kobject *kobj)
 	return kobj->name;
 }
 
+static inline bool kobject_initialized(const struct kobject *kobj)
+{
+	return kobj->state_initialized;
+}
+
 extern void kobject_init(struct kobject *kobj, struct kobj_type *ktype);
 extern __printf(3, 4) __must_check
 int kobject_add(struct kobject *kobj, struct kobject *parent,
-- 
1.9.3


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935009AbaDJDWq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 23:22:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40894 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934652AbaDJDVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 23:21:44 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>, Jiri Kosina <jkosina@suse.cz>,
        Ben Hutchings <ben@decadent.org.uk>,
        Yijing Wang <wangyijing@huawei.com>
Subject: [PATCH 3.4 020/134] HID: fix return value of hidraw_report_event() when !CONFIG_HIDRAW
Date: Wed,  9 Apr 2014 20:22:16 -0700
Message-Id: <20140410032302.487857885@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140410032259.587501440@linuxfoundation.org>
References: <20140410032259.587501440@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Kosina <jkosina@suse.cz>

commit d6d7c873529abd622897cad5e36f1fd7d82f5110 upstream.

Commit b6787242f327 ("HID: hidraw: add proper error handling to raw event
reporting") forgot to update the static inline version of
hidraw_report_event() for the case when CONFIG_HIDRAW is unset. Fix that
up.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Yijing Wang <wangyijing@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/hidraw.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/hidraw.h
+++ b/include/linux/hidraw.h
@@ -82,7 +82,7 @@ void hidraw_disconnect(struct hid_device
 #else
 static inline int hidraw_init(void) { return 0; }
 static inline void hidraw_exit(void) { }
-static inline int hidraw_report_event(struct hid_device *hid, u8 *data, int len) { }
+static inline int hidraw_report_event(struct hid_device *hid, u8 *data, int len) { return 0; }
 static inline int hidraw_connect(struct hid_device *hid) { return -1; }
 static inline void hidraw_disconnect(struct hid_device *hid) { }
 #endif



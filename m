Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722Ab3JKUtG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 16:49:06 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45479 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758710Ab3JKTjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 15:39:37 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        kbuild test robot <fengguang.wu@intel.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [ 005/110] HID: fix unused rsize usage
Date: Fri, 11 Oct 2013 12:37:45 -0700
Message-Id: <20131011193808.190315249@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131011193807.584188672@linuxfoundation.org>
References: <20131011193807.584188672@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Kosina <jkosina@suse.cz>

commit bc197eedef1ae082ec662c64c3f4aa302821fb7a upstream.

27ce4050 ("HID: fix data access in implement()") by mistake removed
a setting of buffer size in hidp. Fix that by putting it back.

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/bluetooth/hidp/core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/bluetooth/hidp/core.c
+++ b/net/bluetooth/hidp/core.c
@@ -242,6 +242,7 @@ static int hidp_send_report(struct hidp_
 	hid_output_report(report, buf);
 	hdr = HIDP_TRANS_DATA | HIDP_DATA_RTYPE_OUPUT;
 
+	rsize = ((report->size - 1) >> 3) + 1 + (report->id > 0);
 	ret = hidp_send_intr_message(session, hdr, buf, rsize);
 
 	kfree(buf);



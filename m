Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757289AbaICWRI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 18:17:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45848 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757245AbaICWQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 18:16:08 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ben Hawkes <hawkes@google.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 3.16 003/125] HID: logitech: fix bounds checking on LED report size
Date: Wed,  3 Sep 2014 15:06:00 -0700
Message-Id: <20140903220623.753016873@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140903220623.649748296@linuxfoundation.org>
References: <20140903220623.649748296@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Kosina <jkosina@suse.cz>

commit 51217e69697fba92a06e07e16f55c9a52d8e8945 upstream.

The check on report size for REPORT_TYPE_LEDS in logi_dj_ll_raw_request()
is wrong; the current check doesn't make any sense -- the report allocated
by HID core in hid_hw_raw_request() can be much larger than
DJREPORT_SHORT_LENGTH, and currently logi_dj_ll_raw_request() doesn't
handle this properly at all.

Fix the check by actually trimming down the report size properly if it is
too large.

Reported-by: Ben Hawkes <hawkes@google.com>
Reviewed-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/hid-logitech-dj.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hid/hid-logitech-dj.c
+++ b/drivers/hid/hid-logitech-dj.c
@@ -557,7 +557,7 @@ static int logi_dj_ll_raw_request(struct
 	if (!out_buf)
 		return -ENOMEM;
 
-	if (count < DJREPORT_SHORT_LENGTH - 2)
+	if (count > DJREPORT_SHORT_LENGTH - 2)
 		count = DJREPORT_SHORT_LENGTH - 2;
 
 	out_buf[0] = REPORT_ID_DJ_SHORT;



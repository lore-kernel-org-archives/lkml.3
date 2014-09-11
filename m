Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755991AbaIKNAh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 09:00:37 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51539 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755075AbaIKMeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:34:05 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Jiri Kosina" <jkosina@suse.cz>,
        "Steven Vittitoe" <scvitti@google.com>
Date: Thu, 11 Sep 2014 13:32:13 +0100
Message-ID: <lsq.1410438733.795812983@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 090/131] HID: picolcd: sanity check report size in
 raw_event() callback
In-Reply-To: <lsq.1410438733.176537304@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.63-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Kosina <jkosina@suse.cz>

commit 844817e47eef14141cf59b8d5ac08dd11c0a9189 upstream.

The report passed to us from transport driver could potentially be
arbitrarily large, therefore we better sanity-check it so that raw_data
that we hold in picolcd_pending structure are always kept within proper
bounds.

Reported-by: Steven Vittitoe <scvitti@google.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
[bwh: Backported to 3.2: adjust filename]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/hid/hid-picolcd.c | 6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/hid/hid-picolcd.c
+++ b/drivers/hid/hid-picolcd.c
@@ -2382,6 +2382,12 @@ static int picolcd_raw_event(struct hid_
 	if (!data)
 		return 1;
 
+	if (size > 64) {
+		hid_warn(hdev, "invalid size value (%d) for picolcd raw event\n",
+				size);
+		return 0;
+	}
+
 	if (report->id == REPORT_KEY_STATE) {
 		if (data->input_keys)
 			ret = picolcd_raw_keypad(data, report, raw_data+1, size-1);


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755874Ab3LQSPN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 13:15:13 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:32768 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755830Ab3LQSPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 13:15:05 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Stefan Achatz <erazor_de@users.sourceforge.net>,
        Jiri Kosina <jkosina@suse.cz>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 059/103] HID: roccat: fix Coverity CID 141438
Date: Tue, 17 Dec 2013 18:12:48 +0000
Message-Id: <1387304012-23805-60-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387304012-23805-1-git-send-email-luis.henriques@canonical.com>
References: <1387304012-23805-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.28 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Achatz <erazor_de@users.sourceforge.net>

commit 7be63f20b00840a6f1c718dcee00855688d64acd upstream.

Add missing switch breaks.

Signed-off-by: Stefan Achatz <erazor_de@users.sourceforge.net>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/hid/hid-roccat-kovaplus.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/hid/hid-roccat-kovaplus.c b/drivers/hid/hid-roccat-kovaplus.c
index 112d934..1973cff 100644
--- a/drivers/hid/hid-roccat-kovaplus.c
+++ b/drivers/hid/hid-roccat-kovaplus.c
@@ -623,9 +623,13 @@ static void kovaplus_keep_values_up_to_date(struct kovaplus_device *kovaplus,
 		break;
 	case KOVAPLUS_MOUSE_REPORT_BUTTON_TYPE_CPI:
 		kovaplus->actual_cpi = kovaplus_convert_event_cpi(button_report->data1);
+		break;
 	case KOVAPLUS_MOUSE_REPORT_BUTTON_TYPE_SENSITIVITY:
 		kovaplus->actual_x_sensitivity = button_report->data1;
 		kovaplus->actual_y_sensitivity = button_report->data2;
+		break;
+	default:
+		break;
 	}
 }
 
-- 
1.8.3.2


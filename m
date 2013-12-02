Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755164Ab3LBTTa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 14:19:30 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39769 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754066Ab3LBTTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:19:17 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Stefan Achatz <erazor_de@users.sourceforge.net>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 3.12 208/212] HID: roccat: fix Coverity CID 141438
Date: Mon,  2 Dec 2013 11:16:39 -0800
Message-Id: <20131202191312.634225688@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191248.517975703@linuxfoundation.org>
References: <20131202191248.517975703@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Achatz <erazor_de@users.sourceforge.net>

commit 7be63f20b00840a6f1c718dcee00855688d64acd upstream.

Add missing switch breaks.

Signed-off-by: Stefan Achatz <erazor_de@users.sourceforge.net>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/hid-roccat-kovaplus.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/hid/hid-roccat-kovaplus.c
+++ b/drivers/hid/hid-roccat-kovaplus.c
@@ -554,9 +554,13 @@ static void kovaplus_keep_values_up_to_d
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
 



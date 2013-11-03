Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751653Ab3KCFZi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 01:25:38 -0400
Received: from mail-in-09.arcor-online.net ([151.189.21.49]:55385 "EHLO
	mail-in-09.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750885Ab3KCFZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 01:25:36 -0400
X-Greylist: Passed host: 188.104.13.64
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-09.arcor-online.net 78C6B197937
X-Greylist: Passed host: 188.104.13.64
X-Greylist: Passed host: 188.104.13.64
X-Greylist: Passed host: 188.104.13.64
Subject: [PATCH] HID: roccat: Fixed Coverity CID 141438
From: Stefan Achatz <erazor_de@users.sourceforge.net>
Reply-To: erazor_de@users.sourceforge.net
To: Stefan Achatz <erazor_de@users.sourceforge.net>,
        Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 03 Nov 2013 06:25:33 +0100
Message-ID: <1383456333.4017.2.camel@neuromancer.tessier-ashpool>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Stefan Achatz <erazor_de@users.sourceforge.net>
---
 drivers/hid/hid-roccat-kovaplus.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/hid/hid-roccat-kovaplus.c b/drivers/hid/hid-roccat-kovaplus.c
index 0c8e1ef..9660477 100644
--- a/drivers/hid/hid-roccat-kovaplus.c
+++ b/drivers/hid/hid-roccat-kovaplus.c
@@ -554,9 +554,13 @@ static void kovaplus_keep_values_up_to_date(struct kovaplus_device *kovaplus,
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
1.7.3.4




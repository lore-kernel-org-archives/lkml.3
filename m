Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754644Ab3LBUbz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 15:31:55 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38944 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754440Ab3LBTOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:14:36 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 3.10 165/173] drm/radeon: fix N/CTS clock matching for audio
Date: Mon,  2 Dec 2013 11:12:28 -0800
Message-Id: <20131202191202.057659322@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191142.873808297@linuxfoundation.org>
References: <20131202191142.873808297@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit e7d12c2f98ae1e68c7298e5028048d150fa553a1 upstream.

The drm code that calculates the 1001 clocks rounds up
rather than truncating.  This allows the table to match
properly on those modes.

See bug:
https://bugs.freedesktop.org/show_bug.cgi?id=69675

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/r600_hdmi.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/radeon/r600_hdmi.c
+++ b/drivers/gpu/drm/radeon/r600_hdmi.c
@@ -57,15 +57,15 @@ enum r600_hdmi_iec_status_bits {
 static const struct radeon_hdmi_acr r600_hdmi_predefined_acr[] = {
     /*	     32kHz	  44.1kHz	48kHz    */
     /* Clock      N     CTS      N     CTS      N     CTS */
-    {  25174,  4576,  28125,  7007,  31250,  6864,  28125 }, /*  25,20/1.001 MHz */
+    {  25175,  4576,  28125,  7007,  31250,  6864,  28125 }, /*  25,20/1.001 MHz */
     {  25200,  4096,  25200,  6272,  28000,  6144,  25200 }, /*  25.20       MHz */
     {  27000,  4096,  27000,  6272,  30000,  6144,  27000 }, /*  27.00       MHz */
     {  27027,  4096,  27027,  6272,  30030,  6144,  27027 }, /*  27.00*1.001 MHz */
     {  54000,  4096,  54000,  6272,  60000,  6144,  54000 }, /*  54.00       MHz */
     {  54054,  4096,  54054,  6272,  60060,  6144,  54054 }, /*  54.00*1.001 MHz */
-    {  74175, 11648, 210937, 17836, 234375, 11648, 140625 }, /*  74.25/1.001 MHz */
+    {  74176, 11648, 210937, 17836, 234375, 11648, 140625 }, /*  74.25/1.001 MHz */
     {  74250,  4096,  74250,  6272,  82500,  6144,  74250 }, /*  74.25       MHz */
-    { 148351, 11648, 421875,  8918, 234375,  5824, 140625 }, /* 148.50/1.001 MHz */
+    { 148352, 11648, 421875,  8918, 234375,  5824, 140625 }, /* 148.50/1.001 MHz */
     { 148500,  4096, 148500,  6272, 165000,  6144, 148500 }, /* 148.50       MHz */
     {      0,  4096,      0,  6272,      0,  6144,      0 }  /* Other */
 };



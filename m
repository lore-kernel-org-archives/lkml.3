Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759760Ab3LFWG6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 17:06:58 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:32788 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759457Ab3LFVxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 16:53:54 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Pierre Ossman <pierre@ossman.eu>,
        Alex Deucher <alexander.deucher@amd.com>,
        Josh Boyer <jwboyer@fedoraproject.org>
Subject: [PATCH 3.10 58/58] drm/radeon/audio: correct ACR table
Date: Fri,  6 Dec 2013 13:52:29 -0800
Message-Id: <20131206214850.256981071@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.67.gb00d244
In-Reply-To: <20131206214844.906193530@linuxfoundation.org>
References: <20131206214844.906193530@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pierre Ossman <pierre@ossman.eu>

commit 3e71985f2439d8c4090dc2820e497e6f3d72dcff upstream.

The values were taken from the HDMI spec, but they assumed
exact x/1.001 clocks. Since we round the clocks, we also need
to calculate different N and CTS values.

Note that the N for 25.2/1.001 MHz at 44.1 kHz audio is out of
spec. Hopefully this mode is rarely used and/or HDMI sinks
tolerate overly large values of N.

bug:
https://bugs.freedesktop.org/show_bug.cgi?id=69675

Signed-off-by: Pierre Ossman <pierre@ossman.eu>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: Josh Boyer <jwboyer@fedoraproject.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/r600_hdmi.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/radeon/r600_hdmi.c
+++ b/drivers/gpu/drm/radeon/r600_hdmi.c
@@ -58,15 +58,15 @@ enum r600_hdmi_iec_status_bits {
 static const struct radeon_hdmi_acr r600_hdmi_predefined_acr[] = {
     /*	     32kHz	  44.1kHz	48kHz    */
     /* Clock      N     CTS      N     CTS      N     CTS */
-    {  25175,  4576,  28125,  7007,  31250,  6864,  28125 }, /*  25,20/1.001 MHz */
+    {  25175,  4096,  25175, 28224, 125875,  6144,  25175 }, /*  25,20/1.001 MHz */
     {  25200,  4096,  25200,  6272,  28000,  6144,  25200 }, /*  25.20       MHz */
     {  27000,  4096,  27000,  6272,  30000,  6144,  27000 }, /*  27.00       MHz */
     {  27027,  4096,  27027,  6272,  30030,  6144,  27027 }, /*  27.00*1.001 MHz */
     {  54000,  4096,  54000,  6272,  60000,  6144,  54000 }, /*  54.00       MHz */
     {  54054,  4096,  54054,  6272,  60060,  6144,  54054 }, /*  54.00*1.001 MHz */
-    {  74176, 11648, 210937, 17836, 234375, 11648, 140625 }, /*  74.25/1.001 MHz */
+    {  74176,  4096,  74176,  5733,  75335,  6144,  74176 }, /*  74.25/1.001 MHz */
     {  74250,  4096,  74250,  6272,  82500,  6144,  74250 }, /*  74.25       MHz */
-    { 148352, 11648, 421875,  8918, 234375,  5824, 140625 }, /* 148.50/1.001 MHz */
+    { 148352,  4096, 148352,  5733, 150670,  6144, 148352 }, /* 148.50/1.001 MHz */
     { 148500,  4096, 148500,  6272, 165000,  6144, 148500 }, /* 148.50       MHz */
 };
 



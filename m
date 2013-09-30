Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756017Ab3I3KYt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 06:24:49 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43663 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755600Ab3I3KM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 06:12:56 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 064/104] drm/edid: add quirk for Medion MD30217PG
Date: Mon, 30 Sep 2013 11:10:41 +0100
Message-Id: <1380535881-9239-65-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
References: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.22 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 118bdbd86b39dbb843155054021d2c59058f1e05 upstream.

This LCD monitor (1280x1024 native) has a completely
bogus detailed timing (640x350@70hz).  User reports that
1280x1024@60 has waves so prefer 1280x1024@75.

Manufacturer: MED  Model: 7b8  Serial#: 99188
Year: 2005  Week: 5
EDID Version: 1.3
Analog Display Input,  Input Voltage Level: 0.700/0.700 V
Sync:  Separate
Max Image Size [cm]: horiz.: 34  vert.: 27
Gamma: 2.50
DPMS capabilities: Off; RGB/Color Display
First detailed timing is preferred mode
redX: 0.645 redY: 0.348   greenX: 0.280 greenY: 0.605
blueX: 0.142 blueY: 0.071   whiteX: 0.313 whiteY: 0.329
Supported established timings:
720x400@70Hz
640x480@60Hz
640x480@72Hz
640x480@75Hz
800x600@56Hz
800x600@60Hz
800x600@72Hz
800x600@75Hz
1024x768@60Hz
1024x768@70Hz
1024x768@75Hz
1280x1024@75Hz
Manufacturer's mask: 0
Supported standard timings:
Supported detailed timing:
clock: 25.2 MHz   Image Size:  337 x 270 mm
h_active: 640  h_sync: 688  h_sync_end 784 h_blank_end 800 h_border: 0
v_active: 350  v_sync: 350  v_sync_end 352 v_blanking: 449 v_border: 0
Monitor name: MD30217PG
Ranges: V min: 56 V max: 76 Hz, H min: 30 H max: 83 kHz, PixClock max 145 MHz
Serial No: 501099188
EDID (in hex):
          00ffffffffffff0034a4b80774830100
          050f010368221b962a0c55a559479b24
          125054afcf00310a0101010101018180
          000000000000d60980a0205e63103060
          0200510e1100001e000000fc004d4433
          3032313750470a202020000000fd0038
          4c1e530e000a202020202020000000ff
          003530313039393138380a2020200078

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Reported-by: friedrich@mailstation.de
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/drm_edid.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
index c674823..bdbc6a2 100644
--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -125,6 +125,9 @@ static struct edid_quirk {
 
 	/* ViewSonic VA2026w */
 	{ "VSC", 5020, EDID_QUIRK_FORCE_REDUCED_BLANKING },
+
+	/* Medion MD 30217 PG */
+	{ "MED", 0x7b8, EDID_QUIRK_PREFER_LARGE_75 },
 };
 
 /*** DDC fetch and block validation ***/
-- 
1.8.3.2


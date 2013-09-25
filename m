Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756935Ab3IYAyy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 20:54:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39291 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932132Ab3IYARF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 20:17:05 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 097/110] drm/edid: add quirk for Medion MD30217PG
Date: Tue, 24 Sep 2013 17:15:35 -0700
Message-Id: <20130925001333.918713136@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130925001323.387158698@linuxfoundation.org>
References: <20130925001323.387158698@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/drm_edid.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -125,6 +125,9 @@ static struct edid_quirk {
 
 	/* ViewSonic VA2026w */
 	{ "VSC", 5020, EDID_QUIRK_FORCE_REDUCED_BLANKING },
+
+	/* Medion MD 30217 PG */
+	{ "MED", 0x7b8, EDID_QUIRK_PREFER_LARGE_75 },
 };
 
 /*



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756298Ab3CERHs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 12:07:48 -0500
Received: from casper.infradead.org ([85.118.1.10]:48702 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809Ab3CERHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 12:07:47 -0500
Message-ID: <51362680.3030203@infradead.org>
Date: Tue, 05 Mar 2013 09:08:16 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: dri-devel@lists.freedesktop.org,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: David Airlie <airlied@linux.ie>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] drm: fix new kernel-doc warnings
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Fix new kernel-doc warnings in drm_edid.c: convert doxygen(?) to
kernel-doc to match the rest of the file's documentation.

Warning(drivers/gpu/drm/drm_edid.c:997): No description found for parameter 'adapter'
Warning(drivers/gpu/drm/drm_edid.c:997): No description found for parameter 'buf'
Warning(drivers/gpu/drm/drm_edid.c:997): No description found for parameter 'block'
Warning(drivers/gpu/drm/drm_edid.c:997): No description found for parameter 'len'
Warning(drivers/gpu/drm/drm_edid.c:1138): No description found for parameter 'adapter'
Warning(drivers/gpu/drm/drm_edid.c:1467): No description found for parameter 'connector'
Warning(drivers/gpu/drm/drm_edid.c:1467): No description found for parameter 'edid'
Warning(drivers/gpu/drm/drm_edid.c:1467): No description found for parameter 'revision'
Warning(drivers/gpu/drm/drm_edid.c:1467): Excess function parameter 'timing_level' description in 'drm_mode_std'
Warning(drivers/gpu/drm/drm_edid.c:2010): No description found for parameter 'connector'
Warning(drivers/gpu/drm/drm_edid.c:2072): No description found for parameter 'connector'
Warning(drivers/gpu/drm/drm_edid.c:2237): No description found for parameter 'edid'
Warning(drivers/gpu/drm/drm_edid.c:2616): No description found for parameter 'edid'
Warning(drivers/gpu/drm/drm_edid.c:2658): No description found for parameter 'edid'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org

---
 drivers/gpu/drm/drm_edid.c |   30 +++++++++++++++++++-----------
 1 file changed, 19 insertions(+), 11 deletions(-)

--- lnx-39-rc1.orig/drivers/gpu/drm/drm_edid.c
+++ lnx-39-rc1/drivers/gpu/drm/drm_edid.c
@@ -982,12 +982,13 @@ EXPORT_SYMBOL(drm_edid_is_valid);
 
 #define DDC_SEGMENT_ADDR 0x30
 /**
- * Get EDID information via I2C.
+ * drm_do_probe_ddc_edid - Get EDID information via I2C.
  *
- * \param adapter : i2c device adaptor
- * \param buf     : EDID data buffer to be filled
- * \param len     : EDID data buffer length
- * \return 0 on success or -1 on failure.
+ * @adapter : i2c device adaptor
+ * @buf     : EDID data buffer to be filled
+ * @block   : block number
+ * @len     : EDID data buffer length
+ * return   : 0 on success or -1 on failure.
  *
  * Try to fetch EDID information by calling i2c driver function.
  */
@@ -1128,10 +1129,10 @@ out:
 }
 
 /**
- * Probe DDC presence.
+ * drm_probe_ddc - Probe DDC presence.
  *
- * \param adapter : i2c device adaptor
- * \return 1 on success
+ * @adapter : i2c device adaptor
+ * return   : 1 on success
  */
 bool
 drm_probe_ddc(struct i2c_adapter *adapter)
@@ -1455,8 +1456,10 @@ bad_std_timing(u8 a, u8 b)
 
 /**
  * drm_mode_std - convert standard mode info (width, height, refresh) into mode
+ * @connector: attached connector
+ * @edid: EDID block
  * @t: standard timing params
- * @timing_level: standard timing level
+ * @revision: EDID revision
  *
  * Take the standard timing params (in this case width, aspect, and refresh)
  * and convert them into a real mode using CVT/GTF/DMT.
@@ -1999,7 +2002,8 @@ do_established_modes(struct detailed_tim
 }
 
 /**
- * add_established_modes - get est. modes from EDID and add them
+ * add_established_modes - get established modes from EDID and add them
+ * @connector: attached connector
  * @edid: EDID block to scan
  *
  * Each EDID block contains a bitmap of the supported "established modes" list
@@ -2062,6 +2066,7 @@ do_standard_modes(struct detailed_timing
 
 /**
  * add_standard_modes - get std. modes from EDID and add them
+ * @connector: attached connector
  * @edid: EDID block to scan
  *
  * Standard modes can be calculated using the appropriate standard (DMT,
@@ -2231,7 +2236,8 @@ add_detailed_modes(struct drm_connector
 #define EDID_CEA_VCDB_QS	(1 << 6)
 
 /**
- * Search EDID for CEA extension block.
+ * drm_find_cea_extension - Search EDID for CEA extension block.
+ * @edid: EDID block to search
  */
 u8 *drm_find_cea_extension(struct edid *edid)
 {
@@ -2604,6 +2610,7 @@ EXPORT_SYMBOL(drm_detect_hdmi_monitor);
 
 /**
  * drm_detect_monitor_audio - check monitor audio capability
+ * @edid: EDID block
  *
  * Monitor should have CEA extension block.
  * If monitor has 'basic audio', but no CEA audio blocks, it's 'basic
@@ -2649,6 +2656,7 @@ EXPORT_SYMBOL(drm_detect_monitor_audio);
 
 /**
  * drm_rgb_quant_range_selectable - is RGB quantization range selectable?
+ * @edid: EDID block
  *
  * Check whether the monitor reports the RGB quantization range selection
  * as supported. The AVI infoframe can then be used to inform the monitor

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753688AbbAVSLc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 13:11:32 -0500
Received: from box2.japko.eu ([91.121.152.53]:43052 "EHLO box2.japko.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752473AbbAVSL2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 13:11:28 -0500
Date: Thu, 22 Jan 2015 19:08:58 +0100
From: Krzysztof Adamski <k@japko.eu>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Noralf Tronnes <notro@tronnes.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: fbtft: fbtft-core mark functions static
Message-ID: <20150122180857.GA11988@box2.japko.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes sparse warnings like:
     warning: symbol XXX was not declared. Should it be static?

by declaring all local functions static.

Signed-off-by: Krzysztof Adamski <k@japko.eu>
---
 drivers/staging/fbtft/fbtft-core.c |   47 ++++++++++++++++++++----------------
 1 file changed, 26 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/fbtft/fbtft-core.c b/drivers/staging/fbtft/fbtft-core.c
index 873e2c7..37dcf7e 100644
--- a/drivers/staging/fbtft/fbtft-core.c
+++ b/drivers/staging/fbtft/fbtft-core.c
@@ -79,7 +79,7 @@ void fbtft_dbg_hex(const struct device *dev, int groupsize,
 }
 EXPORT_SYMBOL(fbtft_dbg_hex);
 
-unsigned long fbtft_request_gpios_match(struct fbtft_par *par,
+static unsigned long fbtft_request_gpios_match(struct fbtft_par *par,
 					const struct fbtft_gpio *gpio)
 {
 	int ret;
@@ -123,7 +123,7 @@ unsigned long fbtft_request_gpios_match(struct fbtft_par *par,
 	return FBTFT_GPIO_NO_MATCH;
 }
 
-int fbtft_request_gpios(struct fbtft_par *par)
+static int fbtft_request_gpios(struct fbtft_par *par)
 {
 	struct fbtft_platform_data *pdata = par->pdata;
 	const struct fbtft_gpio *gpio;
@@ -249,7 +249,7 @@ static int fbtft_request_gpios_dt(struct fbtft_par *par)
 #endif
 
 #ifdef CONFIG_FB_BACKLIGHT
-int fbtft_backlight_update_status(struct backlight_device *bd)
+static int fbtft_backlight_update_status(struct backlight_device *bd)
 {
 	struct fbtft_par *par = bl_get_data(bd);
 	bool polarity = !!(bd->props.state & BL_CORE_DRIVER1);
@@ -266,7 +266,7 @@ int fbtft_backlight_update_status(struct backlight_device *bd)
 	return 0;
 }
 
-int fbtft_backlight_get_brightness(struct backlight_device *bd)
+static int fbtft_backlight_get_brightness(struct backlight_device *bd)
 {
 	return bd->props.brightness;
 }
@@ -337,7 +337,8 @@ void fbtft_unregister_backlight(struct fbtft_par *par) { };
 EXPORT_SYMBOL(fbtft_register_backlight);
 EXPORT_SYMBOL(fbtft_unregister_backlight);
 
-void fbtft_set_addr_win(struct fbtft_par *par, int xs, int ys, int xe, int ye)
+static void fbtft_set_addr_win(struct fbtft_par *par, int xs, int ys, int xe,
+			       int ye)
 {
 	fbtft_par_dbg(DEBUG_SET_ADDR_WIN, par,
 		"%s(xs=%d, ys=%d, xe=%d, ye=%d)\n", __func__, xs, ys, xe, ye);
@@ -355,7 +356,7 @@ void fbtft_set_addr_win(struct fbtft_par *par, int xs, int ys, int xe, int ye)
 }
 
 
-void fbtft_reset(struct fbtft_par *par)
+static void fbtft_reset(struct fbtft_par *par)
 {
 	if (par->gpio.reset == -1)
 		return;
@@ -367,7 +368,8 @@ void fbtft_reset(struct fbtft_par *par)
 }
 
 
-void fbtft_update_display(struct fbtft_par *par, unsigned start_line, unsigned end_line)
+static void fbtft_update_display(struct fbtft_par *par, unsigned start_line,
+				 unsigned end_line)
 {
 	size_t offset, len;
 	struct timespec ts_start, ts_end, ts_fps, ts_duration;
@@ -445,7 +447,7 @@ void fbtft_update_display(struct fbtft_par *par, unsigned start_line, unsigned e
 }
 
 
-void fbtft_mkdirty(struct fb_info *info, int y, int height)
+static void fbtft_mkdirty(struct fb_info *info, int y, int height)
 {
 	struct fbtft_par *par = info->par;
 	struct fb_deferred_io *fbdefio = info->fbdefio;
@@ -468,7 +470,7 @@ void fbtft_mkdirty(struct fb_info *info, int y, int height)
 	schedule_delayed_work(&info->deferred_work, fbdefio->delay);
 }
 
-void fbtft_deferred_io(struct fb_info *info, struct list_head *pagelist)
+static void fbtft_deferred_io(struct fb_info *info, struct list_head *pagelist)
 {
 	struct fbtft_par *par = info->par;
 	unsigned dirty_lines_start, dirty_lines_end;
@@ -507,7 +509,8 @@ void fbtft_deferred_io(struct fb_info *info, struct list_head *pagelist)
 }
 
 
-void fbtft_fb_fillrect(struct fb_info *info, const struct fb_fillrect *rect)
+static void fbtft_fb_fillrect(struct fb_info *info,
+			      const struct fb_fillrect *rect)
 {
 	struct fbtft_par *par = info->par;
 
@@ -519,7 +522,8 @@ void fbtft_fb_fillrect(struct fb_info *info, const struct fb_fillrect *rect)
 	par->fbtftops.mkdirty(info, rect->dy, rect->height);
 }
 
-void fbtft_fb_copyarea(struct fb_info *info, const struct fb_copyarea *area)
+static void fbtft_fb_copyarea(struct fb_info *info,
+			      const struct fb_copyarea *area)
 {
 	struct fbtft_par *par = info->par;
 
@@ -531,7 +535,8 @@ void fbtft_fb_copyarea(struct fb_info *info, const struct fb_copyarea *area)
 	par->fbtftops.mkdirty(info, area->dy, area->height);
 }
 
-void fbtft_fb_imageblit(struct fb_info *info, const struct fb_image *image)
+static void fbtft_fb_imageblit(struct fb_info *info,
+			       const struct fb_image *image)
 {
 	struct fbtft_par *par = info->par;
 
@@ -543,8 +548,8 @@ void fbtft_fb_imageblit(struct fb_info *info, const struct fb_image *image)
 	par->fbtftops.mkdirty(info, image->dy, image->height);
 }
 
-ssize_t fbtft_fb_write(struct fb_info *info,
-			const char __user *buf, size_t count, loff_t *ppos)
+static ssize_t fbtft_fb_write(struct fb_info *info, const char __user *buf,
+			      size_t count, loff_t *ppos)
 {
 	struct fbtft_par *par = info->par;
 	ssize_t res;
@@ -561,16 +566,16 @@ ssize_t fbtft_fb_write(struct fb_info *info,
 }
 
 /* from pxafb.c */
-unsigned int chan_to_field(unsigned chan, struct fb_bitfield *bf)
+static unsigned int chan_to_field(unsigned chan, struct fb_bitfield *bf)
 {
 	chan &= 0xffff;
 	chan >>= 16 - bf->length;
 	return chan << bf->offset;
 }
 
-int fbtft_fb_setcolreg(unsigned regno,
-			       unsigned red, unsigned green, unsigned blue,
-			       unsigned transp, struct fb_info *info)
+static int fbtft_fb_setcolreg(unsigned regno, unsigned red, unsigned green,
+			      unsigned blue, unsigned transp,
+			      struct fb_info *info)
 {
 	struct fbtft_par *par = info->par;
 	unsigned val;
@@ -598,7 +603,7 @@ int fbtft_fb_setcolreg(unsigned regno,
 	return ret;
 }
 
-int fbtft_fb_blank(int blank, struct fb_info *info)
+static int fbtft_fb_blank(int blank, struct fb_info *info)
 {
 	struct fbtft_par *par = info->par;
 	int ret = -EINVAL;
@@ -623,7 +628,7 @@ int fbtft_fb_blank(int blank, struct fb_info *info)
 	return ret;
 }
 
-void fbtft_merge_fbtftops(struct fbtft_ops *dst, struct fbtft_ops *src)
+static void fbtft_merge_fbtftops(struct fbtft_ops *dst, struct fbtft_ops *src)
 {
 	if (src->write)
 		dst->write = src->write;
@@ -1265,7 +1270,7 @@ EXPORT_SYMBOL(fbtft_init_display);
  *
  * Return: 0 if successful, negative if error
  */
-int fbtft_verify_gpios(struct fbtft_par *par)
+static int fbtft_verify_gpios(struct fbtft_par *par)
 {
 	struct fbtft_platform_data *pdata;
 	int i;
-- 
1.7.10.4


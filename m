Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161001AbaDSDKy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 23:10:54 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:33404 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550AbaDSDKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 23:10:50 -0400
From: Jinqiang Zeng <jinqiangzeng@gmail.com>
To: Luca Risolia <luca.risolia@studio.unibo.it>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Jinqiang Zeng <jinqiangzeng@gmail.com>
Subject: [PATCH] fix the code style errors in sn9c102
Date: Sat, 19 Apr 2014 11:09:47 +0800
Message-Id: <1397876987-11254-1-git-send-email-jinqiangzeng@gmail.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 drivers/staging/media/sn9c102/sn9c102.h            |   30 +-
 drivers/staging/media/sn9c102/sn9c102_core.c       |  342 ++++++++++----------
 drivers/staging/media/sn9c102/sn9c102_devtable.h   |   22 +-
 drivers/staging/media/sn9c102/sn9c102_hv7131d.c    |   22 +-
 drivers/staging/media/sn9c102/sn9c102_hv7131r.c    |   22 +-
 drivers/staging/media/sn9c102/sn9c102_mi0343.c     |   30 +-
 drivers/staging/media/sn9c102/sn9c102_mi0360.c     |   30 +-
 drivers/staging/media/sn9c102/sn9c102_ov7630.c     |   22 +-
 drivers/staging/media/sn9c102/sn9c102_ov7660.c     |   22 +-
 drivers/staging/media/sn9c102/sn9c102_pas106b.c    |   22 +-
 drivers/staging/media/sn9c102/sn9c102_pas202bcb.c  |   22 +-
 drivers/staging/media/sn9c102/sn9c102_sensor.h     |   34 +-
 drivers/staging/media/sn9c102/sn9c102_tas5110c1b.c |   18 +-
 drivers/staging/media/sn9c102/sn9c102_tas5110d.c   |   14 +-
 drivers/staging/media/sn9c102/sn9c102_tas5130d1b.c |   18 +-
 15 files changed, 337 insertions(+), 333 deletions(-)

diff --git a/drivers/staging/media/sn9c102/sn9c102.h b/drivers/staging/media/sn9c102/sn9c102.h
index 8a917f06..37ca722 100644
--- a/drivers/staging/media/sn9c102/sn9c102.h
+++ b/drivers/staging/media/sn9c102/sn9c102.h
@@ -53,7 +53,7 @@ enum sn9c102_frame_state {
 };
 
 struct sn9c102_frame_t {
-	void* bufmem;
+	void *bufmem;
 	struct v4l2_buffer buf;
 	enum sn9c102_frame_state state;
 	struct list_head frame;
@@ -99,17 +99,17 @@ static DEFINE_MUTEX(sn9c102_sysfs_lock);
 static DECLARE_RWSEM(sn9c102_dev_lock);
 
 struct sn9c102_device {
-	struct video_device* v4ldev;
+	struct video_device *v4ldev;
 
 	struct v4l2_device v4l2_dev;
 
 	enum sn9c102_bridge bridge;
 	struct sn9c102_sensor sensor;
 
-	struct usb_device* usbdev;
-	struct urb* urb[SN9C102_URBS];
-	void* transfer_buffer[SN9C102_URBS];
-	u8* control_buffer;
+	struct usb_device *usbdev;
+	struct urb *urb[SN9C102_URBS];
+	void *transfer_buffer[SN9C102_URBS];
+	u8 *control_buffer;
 
 	struct sn9c102_frame_t *frame_current, frame[SN9C102_MAX_FRAMES];
 	struct list_head inqueue, outqueue;
@@ -139,28 +139,28 @@ struct sn9c102_device {
 /*****************************************************************************/
 
 struct sn9c102_device*
-sn9c102_match_id(struct sn9c102_device* cam, const struct usb_device_id *id)
+sn9c102_match_id(struct sn9c102_device *cam, const struct usb_device_id *id)
 {
 	return usb_match_id(usb_ifnum_to_if(cam->usbdev, 0), id) ? cam : NULL;
 }
 
 
 void
-sn9c102_attach_sensor(struct sn9c102_device* cam,
-		      const struct sn9c102_sensor* sensor)
+sn9c102_attach_sensor(struct sn9c102_device *cam,
+		      const struct sn9c102_sensor *sensor)
 {
 	memcpy(&cam->sensor, sensor, sizeof(struct sn9c102_sensor));
 }
 
 
 enum sn9c102_bridge
-sn9c102_get_bridge(struct sn9c102_device* cam)
+sn9c102_get_bridge(struct sn9c102_device *cam)
 {
 	return cam->bridge;
 }
 
 
-struct sn9c102_sensor* sn9c102_get_sensor(struct sn9c102_device* cam)
+struct sn9c102_sensor *sn9c102_get_sensor(struct sn9c102_device *cam)
 {
 	return &cam->sensor;
 }
@@ -198,9 +198,9 @@ do {                                                                          \
 	}                                                                     \
 } while (0)
 #else
-#	define DBG(level, fmt, args...) do {;} while(0)
-#	define V4LDBG(level, name, cmd) do {;} while(0)
-#	define KDBG(level, fmt, args...) do {;} while(0)
+#	define DBG(level, fmt, args...) do { ; } while (0)
+#	define V4LDBG(level, name, cmd) do { ; } while (0)
+#	define KDBG(level, fmt, args...) do { ; } while (0)
 #endif
 
 #undef PDBG
@@ -209,6 +209,6 @@ dev_info(&cam->usbdev->dev, "[%s:%s:%d] " fmt "\n", __FILE__, __func__,   \
 	 __LINE__ , ## args)
 
 #undef PDBGG
-#define PDBGG(fmt, args...) do {;} while(0) /* placeholder */
+#define PDBGG(fmt, args...) do { ; } while (0) /* placeholder */
 
 #endif /* _SN9C102_H_ */
diff --git a/drivers/staging/media/sn9c102/sn9c102_core.c b/drivers/staging/media/sn9c102/sn9c102_core.c
index 71f594f..f83dcba 100644
--- a/drivers/staging/media/sn9c102/sn9c102_core.c
+++ b/drivers/staging/media/sn9c102/sn9c102_core.c
@@ -139,15 +139,15 @@ static int (*sn9c102_sensor_table[])(struct sn9c102_device *) = {
 /*****************************************************************************/
 
 static u32
-sn9c102_request_buffers(struct sn9c102_device* cam, u32 count,
+sn9c102_request_buffers(struct sn9c102_device *cam, u32 count,
 			enum sn9c102_io_method io)
 {
-	struct v4l2_pix_format* p = &(cam->sensor.pix_format);
-	struct v4l2_rect* r = &(cam->sensor.cropcap.bounds);
+	struct v4l2_pix_format *p = &(cam->sensor.pix_format);
+	struct v4l2_rect *r = &(cam->sensor.cropcap.bounds);
 	size_t imagesize = cam->module_param.force_munmap || io == IO_READ ?
 			   (p->width * p->height * p->priv) / 8 :
 			   (r->width * r->height * p->priv) / 8;
-	void* buff = NULL;
+	void *buff = NULL;
 	u32 i;
 
 	if (count > SN9C102_MAX_FRAMES)
@@ -180,7 +180,7 @@ sn9c102_request_buffers(struct sn9c102_device* cam, u32 count,
 }
 
 
-static void sn9c102_release_buffers(struct sn9c102_device* cam)
+static void sn9c102_release_buffers(struct sn9c102_device *cam)
 {
 	if (cam->nbuffers) {
 		vfree(cam->frame[0].bufmem);
@@ -190,7 +190,7 @@ static void sn9c102_release_buffers(struct sn9c102_device* cam)
 }
 
 
-static void sn9c102_empty_framequeues(struct sn9c102_device* cam)
+static void sn9c102_empty_framequeues(struct sn9c102_device *cam)
 {
 	u32 i;
 
@@ -204,7 +204,7 @@ static void sn9c102_empty_framequeues(struct sn9c102_device* cam)
 }
 
 
-static void sn9c102_requeue_outqueue(struct sn9c102_device* cam)
+static void sn9c102_requeue_outqueue(struct sn9c102_device *cam)
 {
 	struct sn9c102_frame_t *i;
 
@@ -217,7 +217,7 @@ static void sn9c102_requeue_outqueue(struct sn9c102_device* cam)
 }
 
 
-static void sn9c102_queue_unusedframes(struct sn9c102_device* cam)
+static void sn9c102_queue_unusedframes(struct sn9c102_device *cam)
 {
 	unsigned long lock_flags;
 	u32 i;
@@ -237,11 +237,11 @@ static void sn9c102_queue_unusedframes(struct sn9c102_device* cam)
    Write a sequence of count value/register pairs. Returns -1 after the first
    failed write, or 0 for no errors.
 */
-int sn9c102_write_regs(struct sn9c102_device* cam, const u8 valreg[][2],
+int sn9c102_write_regs(struct sn9c102_device *cam, const u8 valreg[][2],
 		       int count)
 {
-	struct usb_device* udev = cam->usbdev;
-	u8* buff = cam->control_buffer;
+	struct usb_device *udev = cam->usbdev;
+	u8 *buff = cam->control_buffer;
 	int i, res;
 
 	for (i = 0; i < count; i++) {
@@ -273,10 +273,10 @@ int sn9c102_write_regs(struct sn9c102_device* cam, const u8 valreg[][2],
 }
 
 
-int sn9c102_write_reg(struct sn9c102_device* cam, u8 value, u16 index)
+int sn9c102_write_reg(struct sn9c102_device *cam, u8 value, u16 index)
 {
-	struct usb_device* udev = cam->usbdev;
-	u8* buff = cam->control_buffer;
+	struct usb_device *udev = cam->usbdev;
+	u8 *buff = cam->control_buffer;
 	int res;
 
 	if (index >= ARRAY_SIZE(cam->reg))
@@ -299,10 +299,10 @@ int sn9c102_write_reg(struct sn9c102_device* cam, u8 value, u16 index)
 
 
 /* NOTE: with the SN9C10[123] reading some registers always returns 0 */
-int sn9c102_read_reg(struct sn9c102_device* cam, u16 index)
+int sn9c102_read_reg(struct sn9c102_device *cam, u16 index)
 {
-	struct usb_device* udev = cam->usbdev;
-	u8* buff = cam->control_buffer;
+	struct usb_device *udev = cam->usbdev;
+	u8 *buff = cam->control_buffer;
 	int res;
 
 	res = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0), 0x00, 0xc1,
@@ -315,7 +315,7 @@ int sn9c102_read_reg(struct sn9c102_device* cam, u16 index)
 }
 
 
-int sn9c102_pread_reg(struct sn9c102_device* cam, u16 index)
+int sn9c102_pread_reg(struct sn9c102_device *cam, u16 index)
 {
 	if (index >= ARRAY_SIZE(cam->reg))
 		return -1;
@@ -325,8 +325,8 @@ int sn9c102_pread_reg(struct sn9c102_device* cam, u16 index)
 
 
 static int
-sn9c102_i2c_wait(struct sn9c102_device* cam,
-		 const struct sn9c102_sensor* sensor)
+sn9c102_i2c_wait(struct sn9c102_device *cam,
+		 const struct sn9c102_sensor *sensor)
 {
 	int i, r;
 
@@ -346,8 +346,8 @@ sn9c102_i2c_wait(struct sn9c102_device* cam,
 
 
 static int
-sn9c102_i2c_detect_read_error(struct sn9c102_device* cam,
-			      const struct sn9c102_sensor* sensor)
+sn9c102_i2c_detect_read_error(struct sn9c102_device *cam,
+			      const struct sn9c102_sensor *sensor)
 {
 	int r , err = 0;
 
@@ -368,22 +368,23 @@ sn9c102_i2c_detect_read_error(struct sn9c102_device* cam,
 
 
 static int
-sn9c102_i2c_detect_write_error(struct sn9c102_device* cam,
-			       const struct sn9c102_sensor* sensor)
+sn9c102_i2c_detect_write_error(struct sn9c102_device *cam,
+			       const struct sn9c102_sensor *sensor)
 {
 	int r;
+
 	r = sn9c102_read_reg(cam, 0x08);
 	return (r < 0 || (r >= 0 && (r & 0x08))) ? -EIO : 0;
 }
 
 
 int
-sn9c102_i2c_try_raw_read(struct sn9c102_device* cam,
-			 const struct sn9c102_sensor* sensor, u8 data0,
+sn9c102_i2c_try_raw_read(struct sn9c102_device *cam,
+			 const struct sn9c102_sensor *sensor, u8 data0,
 			 u8 data1, u8 n, u8 buffer[])
 {
-	struct usb_device* udev = cam->usbdev;
-	u8* data = cam->control_buffer;
+	struct usb_device *udev = cam->usbdev;
+	u8 *data = cam->control_buffer;
 	int i = 0, err = 0, res;
 
 	/* Write cycle */
@@ -437,12 +438,12 @@ sn9c102_i2c_try_raw_read(struct sn9c102_device* cam,
 
 
 int
-sn9c102_i2c_try_raw_write(struct sn9c102_device* cam,
-			  const struct sn9c102_sensor* sensor, u8 n, u8 data0,
+sn9c102_i2c_try_raw_write(struct sn9c102_device *cam,
+			  const struct sn9c102_sensor *sensor, u8 n, u8 data0,
 			  u8 data1, u8 data2, u8 data3, u8 data4, u8 data5)
 {
-	struct usb_device* udev = cam->usbdev;
-	u8* data = cam->control_buffer;
+	struct usb_device *udev = cam->usbdev;
+	u8 *data = cam->control_buffer;
 	int err = 0, res;
 
 	/* Write cycle. It usually is address + value */
@@ -476,16 +477,16 @@ sn9c102_i2c_try_raw_write(struct sn9c102_device* cam,
 
 
 int
-sn9c102_i2c_try_read(struct sn9c102_device* cam,
-		     const struct sn9c102_sensor* sensor, u8 address)
+sn9c102_i2c_try_read(struct sn9c102_device *cam,
+		     const struct sn9c102_sensor *sensor, u8 address)
 {
 	return sn9c102_i2c_try_raw_read(cam, sensor, sensor->i2c_slave_id,
 					address, 1, NULL);
 }
 
 
-static int sn9c102_i2c_try_write(struct sn9c102_device* cam,
-				 const struct sn9c102_sensor* sensor,
+static int sn9c102_i2c_try_write(struct sn9c102_device *cam,
+				 const struct sn9c102_sensor *sensor,
 				 u8 address, u8 value)
 {
 	return sn9c102_i2c_try_raw_write(cam, sensor, 3,
@@ -494,20 +495,20 @@ static int sn9c102_i2c_try_write(struct sn9c102_device* cam,
 }
 
 
-int sn9c102_i2c_read(struct sn9c102_device* cam, u8 address)
+int sn9c102_i2c_read(struct sn9c102_device *cam, u8 address)
 {
 	return sn9c102_i2c_try_read(cam, &cam->sensor, address);
 }
 
 
-int sn9c102_i2c_write(struct sn9c102_device* cam, u8 address, u8 value)
+int sn9c102_i2c_write(struct sn9c102_device *cam, u8 address, u8 value)
 {
 	return sn9c102_i2c_try_write(cam, &cam->sensor, address, value);
 }
 
 /*****************************************************************************/
 
-static size_t sn9c102_sof_length(struct sn9c102_device* cam)
+static size_t sn9c102_sof_length(struct sn9c102_device *cam)
 {
 	switch (cam->bridge) {
 	case BRIDGE_SN9C101:
@@ -525,7 +526,7 @@ static size_t sn9c102_sof_length(struct sn9c102_device* cam)
 
 
 static void*
-sn9c102_find_sof_header(struct sn9c102_device* cam, void* mem, size_t len)
+sn9c102_find_sof_header(struct sn9c102_device *cam, void *mem, size_t len)
 {
 	static const char marker[6] = {0xff, 0xff, 0x00, 0xc4, 0xc4, 0x96};
 	const char *m = mem;
@@ -547,7 +548,7 @@ sn9c102_find_sof_header(struct sn9c102_device* cam, void* mem, size_t len)
 		}
 
 		/* Search for the SOF marker (fixed part) in the header */
-		for (j = 0, b=cam->sof.bytesread; j+b < sizeof(marker); j++) {
+		for (j = 0, b = cam->sof.bytesread; j+b < sizeof(marker); j++) {
 			if (unlikely(i+j == len))
 				return NULL;
 			if (*(m+i+j) == marker[cam->sof.bytesread]) {
@@ -570,7 +571,7 @@ sn9c102_find_sof_header(struct sn9c102_device* cam, void* mem, size_t len)
 
 
 static void*
-sn9c102_find_eof_header(struct sn9c102_device* cam, void* mem, size_t len)
+sn9c102_find_eof_header(struct sn9c102_device *cam, void *mem, size_t len)
 {
 	static const u8 eof_header[4][4] = {
 		{0x00, 0x00, 0x00, 0x00},
@@ -600,7 +601,7 @@ sn9c102_find_eof_header(struct sn9c102_device* cam, void* mem, size_t len)
 
 
 static void
-sn9c102_write_jpegheader(struct sn9c102_device* cam, struct sn9c102_frame_t* f)
+sn9c102_write_jpegheader(struct sn9c102_device *cam, struct sn9c102_frame_t *f)
 {
 	static const u8 jpeg_header[589] = {
 		0xff, 0xd8, 0xff, 0xdb, 0x00, 0x84, 0x00, 0x06, 0x04, 0x05,
@@ -687,8 +688,8 @@ sn9c102_write_jpegheader(struct sn9c102_device* cam, struct sn9c102_frame_t* f)
 
 static void sn9c102_urb_complete(struct urb *urb)
 {
-	struct sn9c102_device* cam = urb->context;
-	struct sn9c102_frame_t** f;
+	struct sn9c102_device *cam = urb->context;
+	struct sn9c102_frame_t **f;
 	size_t imagesize, soflen;
 	u8 i;
 	int err = 0;
@@ -787,7 +788,7 @@ end_of_frame:
 
 					b = (*f)->buf.bytesused;
 					(*f)->state = F_DONE;
-					(*f)->buf.sequence= ++cam->frame_count;
+					(*f)->buf.sequence = ++cam->frame_count;
 
 					spin_lock(&cam->queue_lock);
 					list_move_tail(&(*f)->frame,
@@ -796,7 +797,7 @@ end_of_frame:
 						(*f) = list_entry(
 							cam->inqueue.next,
 							struct sn9c102_frame_t,
-							frame );
+							frame);
 					else
 						(*f) = NULL;
 					spin_unlock(&cam->queue_lock);
@@ -883,11 +884,11 @@ resubmit_urb:
 }
 
 
-static int sn9c102_start_transfer(struct sn9c102_device* cam)
+static int sn9c102_start_transfer(struct sn9c102_device *cam)
 {
 	struct usb_device *udev = cam->usbdev;
-	struct urb* urb;
-	struct usb_host_interface* altsetting = usb_altnum_to_altsetting(
+	struct urb *urb;
+	struct usb_host_interface *altsetting = usb_altnum_to_altsetting(
 						    usb_ifnum_to_if(udev, 0),
 						    SN9C102_ALTERNATE_SETTING);
 	const unsigned int psz = le16_to_cpu(altsetting->
@@ -971,7 +972,7 @@ free_buffers:
 }
 
 
-static int sn9c102_stop_transfer(struct sn9c102_device* cam)
+static int sn9c102_stop_transfer(struct sn9c102_device *cam)
 {
 	struct usb_device *udev = cam->usbdev;
 	s8 i;
@@ -994,7 +995,7 @@ static int sn9c102_stop_transfer(struct sn9c102_device* cam)
 }
 
 
-static int sn9c102_stream_interrupt(struct sn9c102_device* cam)
+static int sn9c102_stream_interrupt(struct sn9c102_device *cam)
 {
 	cam->stream = STREAM_INTERRUPT;
 	wait_event_timeout(cam->wait_stream,
@@ -1017,10 +1018,10 @@ static int sn9c102_stream_interrupt(struct sn9c102_device* cam)
 /*****************************************************************************/
 
 #ifdef CONFIG_VIDEO_ADV_DEBUG
-static u16 sn9c102_strtou16(const char* buff, size_t len, ssize_t* count)
+static u16 sn9c102_strtou16(const char *buff, size_t len, ssize_t *count)
 {
 	char str[7];
-	char* endp;
+	char *endp;
 	unsigned long val;
 
 	if (len < 6) {
@@ -1048,10 +1049,10 @@ static u16 sn9c102_strtou16(const char* buff, size_t len, ssize_t* count)
    NOTE 2: buffers are PAGE_SIZE long
 */
 
-static ssize_t sn9c102_show_reg(struct device* cd,
-				struct device_attribute *attr, char* buf)
+static ssize_t sn9c102_show_reg(struct device *cd,
+				struct device_attribute *attr, char *buf)
 {
-	struct sn9c102_device* cam;
+	struct sn9c102_device *cam;
 	ssize_t count;
 
 	if (mutex_lock_interruptible(&sn9c102_sysfs_lock))
@@ -1072,10 +1073,10 @@ static ssize_t sn9c102_show_reg(struct device* cd,
 
 
 static ssize_t
-sn9c102_store_reg(struct device* cd, struct device_attribute *attr,
-		  const char* buf, size_t len)
+sn9c102_store_reg(struct device *cd, struct device_attribute *attr,
+		  const char *buf, size_t len)
 {
-	struct sn9c102_device* cam;
+	struct sn9c102_device *cam;
 	u16 index;
 	ssize_t count;
 
@@ -1105,10 +1106,10 @@ sn9c102_store_reg(struct device* cd, struct device_attribute *attr,
 }
 
 
-static ssize_t sn9c102_show_val(struct device* cd,
-				struct device_attribute *attr, char* buf)
+static ssize_t sn9c102_show_val(struct device *cd,
+				struct device_attribute *attr, char *buf)
 {
-	struct sn9c102_device* cam;
+	struct sn9c102_device *cam;
 	ssize_t count;
 	int val;
 
@@ -1138,10 +1139,10 @@ static ssize_t sn9c102_show_val(struct device* cd,
 
 
 static ssize_t
-sn9c102_store_val(struct device* cd, struct device_attribute *attr,
-		  const char* buf, size_t len)
+sn9c102_store_val(struct device *cd, struct device_attribute *attr,
+		  const char *buf, size_t len)
 {
-	struct sn9c102_device* cam;
+	struct sn9c102_device *cam;
 	u16 value;
 	ssize_t count;
 	int err;
@@ -1177,10 +1178,10 @@ sn9c102_store_val(struct device* cd, struct device_attribute *attr,
 }
 
 
-static ssize_t sn9c102_show_i2c_reg(struct device* cd,
-				    struct device_attribute *attr, char* buf)
+static ssize_t sn9c102_show_i2c_reg(struct device *cd,
+				    struct device_attribute *attr, char *buf)
 {
-	struct sn9c102_device* cam;
+	struct sn9c102_device *cam;
 	ssize_t count;
 
 	if (mutex_lock_interruptible(&sn9c102_sysfs_lock))
@@ -1203,10 +1204,10 @@ static ssize_t sn9c102_show_i2c_reg(struct device* cd,
 
 
 static ssize_t
-sn9c102_store_i2c_reg(struct device* cd, struct device_attribute *attr,
-		      const char* buf, size_t len)
+sn9c102_store_i2c_reg(struct device *cd, struct device_attribute *attr,
+		      const char *buf, size_t len)
 {
-	struct sn9c102_device* cam;
+	struct sn9c102_device *cam;
 	u16 index;
 	ssize_t count;
 
@@ -1236,10 +1237,10 @@ sn9c102_store_i2c_reg(struct device* cd, struct device_attribute *attr,
 }
 
 
-static ssize_t sn9c102_show_i2c_val(struct device* cd,
-				    struct device_attribute *attr, char* buf)
+static ssize_t sn9c102_show_i2c_val(struct device *cd,
+				    struct device_attribute *attr, char *buf)
 {
-	struct sn9c102_device* cam;
+	struct sn9c102_device *cam;
 	ssize_t count;
 	int val;
 
@@ -1274,10 +1275,10 @@ static ssize_t sn9c102_show_i2c_val(struct device* cd,
 
 
 static ssize_t
-sn9c102_store_i2c_val(struct device* cd, struct device_attribute *attr,
-		      const char* buf, size_t len)
+sn9c102_store_i2c_val(struct device *cd, struct device_attribute *attr,
+		      const char *buf, size_t len)
 {
-	struct sn9c102_device* cam;
+	struct sn9c102_device *cam;
 	u16 value;
 	ssize_t count;
 	int err;
@@ -1319,10 +1320,10 @@ sn9c102_store_i2c_val(struct device* cd, struct device_attribute *attr,
 
 
 static ssize_t
-sn9c102_store_green(struct device* cd, struct device_attribute *attr,
-		    const char* buf, size_t len)
+sn9c102_store_green(struct device *cd, struct device_attribute *attr,
+		    const char *buf, size_t len)
 {
-	struct sn9c102_device* cam;
+	struct sn9c102_device *cam;
 	enum sn9c102_bridge bridge;
 	ssize_t res = 0;
 	u16 value;
@@ -1350,7 +1351,8 @@ sn9c102_store_green(struct device* cd, struct device_attribute *attr,
 	case BRIDGE_SN9C102:
 		if (value > 0x0f)
 			return -EINVAL;
-		if ((res = sn9c102_store_reg(cd, attr, "0x11", 4)) >= 0)
+		res = sn9c102_store_reg(cd, attr, "0x11", 4);
+		if (res >= 0)
 			res = sn9c102_store_val(cd, attr, buf, len);
 		break;
 	case BRIDGE_SN9C103:
@@ -1358,7 +1360,8 @@ sn9c102_store_green(struct device* cd, struct device_attribute *attr,
 	case BRIDGE_SN9C120:
 		if (value > 0x7f)
 			return -EINVAL;
-		if ((res = sn9c102_store_reg(cd, attr, "0x07", 4)) >= 0)
+		res = sn9c102_store_reg(cd, attr, "0x07", 4);
+		if (res >= 0)
 			res = sn9c102_store_val(cd, attr, buf, len);
 		break;
 	}
@@ -1368,8 +1371,8 @@ sn9c102_store_green(struct device* cd, struct device_attribute *attr,
 
 
 static ssize_t
-sn9c102_store_blue(struct device* cd, struct device_attribute *attr,
-		   const char* buf, size_t len)
+sn9c102_store_blue(struct device *cd, struct device_attribute *attr,
+		   const char *buf, size_t len)
 {
 	ssize_t res = 0;
 	u16 value;
@@ -1379,7 +1382,8 @@ sn9c102_store_blue(struct device* cd, struct device_attribute *attr,
 	if (!count || value > 0x7f)
 		return -EINVAL;
 
-	if ((res = sn9c102_store_reg(cd, attr, "0x06", 4)) >= 0)
+	res = sn9c102_store_reg(cd, attr, "0x06", 4);
+	if (res  >= 0)
 		res = sn9c102_store_val(cd, attr, buf, len);
 
 	return res;
@@ -1387,8 +1391,8 @@ sn9c102_store_blue(struct device* cd, struct device_attribute *attr,
 
 
 static ssize_t
-sn9c102_store_red(struct device* cd, struct device_attribute *attr,
-		  const char* buf, size_t len)
+sn9c102_store_red(struct device *cd, struct device_attribute *attr,
+		  const char *buf, size_t len)
 {
 	ssize_t res = 0;
 	u16 value;
@@ -1397,19 +1401,19 @@ sn9c102_store_red(struct device* cd, struct device_attribute *attr,
 	value = sn9c102_strtou16(buf, len, &count);
 	if (!count || value > 0x7f)
 		return -EINVAL;
-
-	if ((res = sn9c102_store_reg(cd, attr, "0x05", 4)) >= 0)
+	res = sn9c102_store_reg(cd, attr, "0x05", 4);
+	if (res  >= 0)
 		res = sn9c102_store_val(cd, attr, buf, len);
 
 	return res;
 }
 
 
-static ssize_t sn9c102_show_frame_header(struct device* cd,
+static ssize_t sn9c102_show_frame_header(struct device *cd,
 					 struct device_attribute *attr,
-					 char* buf)
+					 char *buf)
 {
-	struct sn9c102_device* cam;
+	struct sn9c102_device *cam;
 	ssize_t count;
 
 	cam = video_get_drvdata(container_of(cd, struct video_device, dev));
@@ -1437,7 +1441,7 @@ static DEVICE_ATTR(red, S_IWUSR, NULL, sn9c102_store_red);
 static DEVICE_ATTR(frame_header, S_IRUGO, sn9c102_show_frame_header, NULL);
 
 
-static int sn9c102_create_sysfs(struct sn9c102_device* cam)
+static int sn9c102_create_sysfs(struct sn9c102_device *cam)
 {
 	struct device *dev = &(cam->v4ldev->dev);
 	int err = 0;
@@ -1498,7 +1502,7 @@ err_out:
 /*****************************************************************************/
 
 static int
-sn9c102_set_pix_format(struct sn9c102_device* cam, struct v4l2_pix_format* pix)
+sn9c102_set_pix_format(struct sn9c102_device *cam, struct v4l2_pix_format *pix)
 {
 	int err = 0;
 
@@ -1538,8 +1542,8 @@ sn9c102_set_pix_format(struct sn9c102_device* cam, struct v4l2_pix_format* pix)
 
 
 static int
-sn9c102_set_compression(struct sn9c102_device* cam,
-			struct v4l2_jpegcompression* compression)
+sn9c102_set_compression(struct sn9c102_device *cam,
+			struct v4l2_jpegcompression *compression)
 {
 	int i, err = 0;
 
@@ -1586,7 +1590,7 @@ sn9c102_set_compression(struct sn9c102_device* cam,
 }
 
 
-static int sn9c102_set_scale(struct sn9c102_device* cam, u8 scale)
+static int sn9c102_set_scale(struct sn9c102_device *cam, u8 scale)
 {
 	u8 r = 0;
 	int err = 0;
@@ -1609,9 +1613,9 @@ static int sn9c102_set_scale(struct sn9c102_device* cam, u8 scale)
 }
 
 
-static int sn9c102_set_crop(struct sn9c102_device* cam, struct v4l2_rect* rect)
+static int sn9c102_set_crop(struct sn9c102_device *cam, struct v4l2_rect *rect)
 {
-	struct sn9c102_sensor* s = &cam->sensor;
+	struct sn9c102_sensor *s = &cam->sensor;
 	u8 h_start = (u8)(rect->left - s->cropcap.bounds.left),
 	   v_start = (u8)(rect->top - s->cropcap.bounds.top),
 	   h_size = (u8)(rect->width / 16),
@@ -1632,12 +1636,12 @@ static int sn9c102_set_crop(struct sn9c102_device* cam, struct v4l2_rect* rect)
 }
 
 
-static int sn9c102_init(struct sn9c102_device* cam)
+static int sn9c102_init(struct sn9c102_device *cam)
 {
-	struct sn9c102_sensor* s = &cam->sensor;
+	struct sn9c102_sensor *s = &cam->sensor;
 	struct v4l2_control ctrl;
 	struct v4l2_queryctrl *qctrl;
-	struct v4l2_rect* rect;
+	struct v4l2_rect *rect;
 	u8 i = 0;
 	int err = 0;
 
@@ -1669,7 +1673,7 @@ static int sn9c102_init(struct sn9c102_device* cam)
 		    cam->bridge == BRIDGE_SN9C102 ||
 		    cam->bridge == BRIDGE_SN9C103) {
 			if (s->pix_format.pixelformat == V4L2_PIX_FMT_JPEG)
-				s->pix_format.pixelformat= V4L2_PIX_FMT_SBGGR8;
+				s->pix_format.pixelformat = V4L2_PIX_FMT_SBGGR8;
 			cam->compression.quality =  cam->reg[0x17] & 0x01 ?
 						    0 : 1;
 		} else {
@@ -1761,7 +1765,7 @@ static void sn9c102_release_resources(struct kref *kref)
 
 static int sn9c102_open(struct file *filp)
 {
-	struct sn9c102_device* cam;
+	struct sn9c102_device *cam;
 	int err = 0;
 
 	/*
@@ -1873,7 +1877,7 @@ out:
 
 static int sn9c102_release(struct file *filp)
 {
-	struct sn9c102_device* cam;
+	struct sn9c102_device *cam;
 
 	down_write(&sn9c102_dev_lock);
 
@@ -1895,10 +1899,10 @@ static int sn9c102_release(struct file *filp)
 
 
 static ssize_t
-sn9c102_read(struct file* filp, char __user * buf, size_t count, loff_t* f_pos)
+sn9c102_read(struct file *filp, char __user *buf, size_t count, loff_t *f_pos)
 {
 	struct sn9c102_device *cam = video_drvdata(filp);
-	struct sn9c102_frame_t* f, * i;
+	struct sn9c102_frame_t *f, *i
 	unsigned long lock_flags;
 	long timeout;
 	int err = 0;
@@ -1927,7 +1931,7 @@ sn9c102_read(struct file* filp, char __user * buf, size_t count, loff_t* f_pos)
 	}
 
 	if (cam->io == IO_NONE) {
-		if (!sn9c102_request_buffers(cam,cam->nreadbuffers, IO_READ)) {
+		if (!sn9c102_request_buffers(cam, cam->nreadbuffers, IO_READ)) {
 			DBG(1, "read() failed, not enough memory");
 			mutex_unlock(&cam->fileop_mutex);
 			return -ENOMEM;
@@ -1954,17 +1958,17 @@ sn9c102_read(struct file* filp, char __user * buf, size_t count, loff_t* f_pos)
 		}
 		if (!cam->module_param.frame_timeout) {
 			err = wait_event_interruptible
-			      ( cam->wait_frame,
+			      (cam->wait_frame,
 				(!list_empty(&cam->outqueue)) ||
 				(cam->state & DEV_DISCONNECTED) ||
-				(cam->state & DEV_MISCONFIGURED) );
+				(cam->state & DEV_MISCONFIGURED));
 			if (err) {
 				mutex_unlock(&cam->fileop_mutex);
 				return err;
 			}
 		} else {
 			timeout = wait_event_interruptible_timeout
-				  ( cam->wait_frame,
+				  (cam->wait_frame,
 				    (!list_empty(&cam->outqueue)) ||
 				    (cam->state & DEV_DISCONNECTED) ||
 				    (cam->state & DEV_MISCONFIGURED),
@@ -2024,7 +2028,7 @@ exit:
 static unsigned int sn9c102_poll(struct file *filp, poll_table *wait)
 {
 	struct sn9c102_device *cam = video_drvdata(filp);
-	struct sn9c102_frame_t* f;
+	struct sn9c102_frame_t *f;
 	unsigned long lock_flags;
 	unsigned int mask = 0;
 
@@ -2076,17 +2080,17 @@ error:
 }
 
 
-static void sn9c102_vm_open(struct vm_area_struct* vma)
+static void sn9c102_vm_open(struct vm_area_struct *vma)
 {
-	struct sn9c102_frame_t* f = vma->vm_private_data;
+	struct sn9c102_frame_t *f = vma->vm_private_data;
 	f->vma_use_count++;
 }
 
 
-static void sn9c102_vm_close(struct vm_area_struct* vma)
+static void sn9c102_vm_close(struct vm_area_struct *vma)
 {
 	/* NOTE: buffers are not freed here */
-	struct sn9c102_frame_t* f = vma->vm_private_data;
+	struct sn9c102_frame_t *f = vma->vm_private_data;
 	f->vma_use_count--;
 }
 
@@ -2097,7 +2101,7 @@ static const struct vm_operations_struct sn9c102_vm_ops = {
 };
 
 
-static int sn9c102_mmap(struct file* filp, struct vm_area_struct *vma)
+static int sn9c102_mmap(struct file *filp, struct vm_area_struct *vma)
 {
 	struct sn9c102_device *cam = video_drvdata(filp);
 	unsigned long size = vma->vm_end - vma->vm_start,
@@ -2166,7 +2170,7 @@ static int sn9c102_mmap(struct file* filp, struct vm_area_struct *vma)
 /*****************************************************************************/
 
 static int
-sn9c102_vidioc_querycap(struct sn9c102_device* cam, void __user * arg)
+sn9c102_vidioc_querycap(struct sn9c102_device *cam, void __user *arg)
 {
 	struct v4l2_capability cap = {
 		.driver = "sn9c102",
@@ -2188,7 +2192,7 @@ sn9c102_vidioc_querycap(struct sn9c102_device* cam, void __user * arg)
 
 
 static int
-sn9c102_vidioc_enuminput(struct sn9c102_device* cam, void __user * arg)
+sn9c102_vidioc_enuminput(struct sn9c102_device *cam, void __user *arg)
 {
 	struct v4l2_input i;
 
@@ -2211,7 +2215,7 @@ sn9c102_vidioc_enuminput(struct sn9c102_device* cam, void __user * arg)
 
 
 static int
-sn9c102_vidioc_g_input(struct sn9c102_device* cam, void __user * arg)
+sn9c102_vidioc_g_input(struct sn9c102_device *cam, void __user *arg)
 {
 	int index = 0;
 
@@ -2223,7 +2227,7 @@ sn9c102_vidioc_g_input(struct sn9c102_device* cam, void __user * arg)
 
 
 static int
-sn9c102_vidioc_s_input(struct sn9c102_device* cam, void __user * arg)
+sn9c102_vidioc_s_input(struct sn9c102_device *cam, void __user *arg)
 {
 	int index;
 
@@ -2238,9 +2242,9 @@ sn9c102_vidioc_s_input(struct sn9c102_device* cam, void __user * arg)
 
 
 static int
-sn9c102_vidioc_query_ctrl(struct sn9c102_device* cam, void __user * arg)
+sn9c102_vidioc_query_ctrl(struct sn9c102_device *cam, void __user *arg)
 {
-	struct sn9c102_sensor* s = &cam->sensor;
+	struct sn9c102_sensor *s = &cam->sensor;
 	struct v4l2_queryctrl qc;
 	u8 i;
 
@@ -2260,9 +2264,9 @@ sn9c102_vidioc_query_ctrl(struct sn9c102_device* cam, void __user * arg)
 
 
 static int
-sn9c102_vidioc_g_ctrl(struct sn9c102_device* cam, void __user * arg)
+sn9c102_vidioc_g_ctrl(struct sn9c102_device *cam, void __user *arg)
 {
-	struct sn9c102_sensor* s = &cam->sensor;
+	struct sn9c102_sensor *s = &cam->sensor;
 	struct v4l2_control ctrl;
 	int err = 0;
 	u8 i;
@@ -2295,9 +2299,9 @@ exit:
 
 
 static int
-sn9c102_vidioc_s_ctrl(struct sn9c102_device* cam, void __user * arg)
+sn9c102_vidioc_s_ctrl(struct sn9c102_device *cam, void __user *arg)
 {
-	struct sn9c102_sensor* s = &cam->sensor;
+	struct sn9c102_sensor *s = &cam->sensor;
 	struct v4l2_control ctrl;
 	u8 i;
 	int err = 0;
@@ -2335,9 +2339,9 @@ sn9c102_vidioc_s_ctrl(struct sn9c102_device* cam, void __user * arg)
 
 
 static int
-sn9c102_vidioc_cropcap(struct sn9c102_device* cam, void __user * arg)
+sn9c102_vidioc_cropcap(struct sn9c102_device *cam, void __user *arg)
 {
-	struct v4l2_cropcap* cc = &(cam->sensor.cropcap);
+	struct v4l2_cropcap *cc = &(cam->sensor.cropcap);
 
 	cc->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 	cc->pixelaspect.numerator = 1;
@@ -2351,9 +2355,9 @@ sn9c102_vidioc_cropcap(struct sn9c102_device* cam, void __user * arg)
 
 
 static int
-sn9c102_vidioc_g_crop(struct sn9c102_device* cam, void __user * arg)
+sn9c102_vidioc_g_crop(struct sn9c102_device *cam, void __user *arg)
 {
-	struct sn9c102_sensor* s = &cam->sensor;
+	struct sn9c102_sensor *s = &cam->sensor;
 	struct v4l2_crop crop = {
 		.type = V4L2_BUF_TYPE_VIDEO_CAPTURE,
 	};
@@ -2368,13 +2372,13 @@ sn9c102_vidioc_g_crop(struct sn9c102_device* cam, void __user * arg)
 
 
 static int
-sn9c102_vidioc_s_crop(struct sn9c102_device* cam, void __user * arg)
+sn9c102_vidioc_s_crop(struct sn9c102_device *cam, void __user *arg)
 {
-	struct sn9c102_sensor* s = &cam->sensor;
+	struct sn9c102_sensor *s = &cam->sensor;
 	struct v4l2_crop crop;
-	struct v4l2_rect* rect;
-	struct v4l2_rect* bounds = &(s->cropcap.bounds);
-	struct v4l2_pix_format* pix_format = &(s->pix_format);
+	struct v4l2_rect *rect;
+	struct v4l2_rect *bounds = &(s->cropcap.bounds);
+	struct v4l2_pix_format *pix_format = &(s->pix_format);
 	u8 scale;
 	const enum sn9c102_stream_state stream = cam->stream;
 	const u32 nbuffers = cam->nbuffers;
@@ -2482,7 +2486,7 @@ sn9c102_vidioc_s_crop(struct sn9c102_device* cam, void __user * arg)
 
 
 static int
-sn9c102_vidioc_enum_framesizes(struct sn9c102_device* cam, void __user * arg)
+sn9c102_vidioc_enum_framesizes(struct sn9c102_device *cam, void __user *arg)
 {
 	struct v4l2_frmsizeenum frmsize;
 
@@ -2523,7 +2527,7 @@ sn9c102_vidioc_enum_framesizes(struct sn9c102_device* cam, void __user * arg)
 
 
 static int
-sn9c102_vidioc_enum_fmt(struct sn9c102_device* cam, void __user * arg)
+sn9c102_vidioc_enum_fmt(struct sn9c102_device *cam, void __user *arg)
 {
 	struct v4l2_fmtdesc fmtd;
 
@@ -2565,10 +2569,10 @@ sn9c102_vidioc_enum_fmt(struct sn9c102_device* cam, void __user * arg)
 
 
 static int
-sn9c102_vidioc_g_fmt(struct sn9c102_device* cam, void __user * arg)
+sn9c102_vidioc_g_fmt(struct sn9c102_device *cam, void __user *arg)
 {
 	struct v4l2_format format;
-	struct v4l2_pix_format* pfmt = &(cam->sensor.pix_format);
+	struct v4l2_pix_format *pfmt = &(cam->sensor.pix_format);
 
 	if (copy_from_user(&format, arg, sizeof(format)))
 		return -EFAULT;
@@ -2593,14 +2597,14 @@ sn9c102_vidioc_g_fmt(struct sn9c102_device* cam, void __user * arg)
 
 
 static int
-sn9c102_vidioc_try_s_fmt(struct sn9c102_device* cam, unsigned int cmd,
-			 void __user * arg)
+sn9c102_vidioc_try_s_fmt(struct sn9c102_device *cam, unsigned int cmd,
+			 void __user *arg)
 {
-	struct sn9c102_sensor* s = &cam->sensor;
+	struct sn9c102_sensor *s = &cam->sensor;
 	struct v4l2_format format;
-	struct v4l2_pix_format* pix;
-	struct v4l2_pix_format* pfmt = &(s->pix_format);
-	struct v4l2_rect* bounds = &(s->cropcap.bounds);
+	struct v4l2_pix_format *pix;
+	struct v4l2_pix_format *pfmt = &(s->pix_format);
+	struct v4l2_rect *bounds = &(s->cropcap.bounds);
 	struct v4l2_rect rect;
 	u8 scale;
 	const enum sn9c102_stream_state stream = cam->stream;
@@ -2742,7 +2746,7 @@ sn9c102_vidioc_try_s_fmt(struct sn9c102_device* cam, unsigned int cmd,
 
 
 static int
-sn9c102_vidioc_g_jpegcomp(struct sn9c102_device* cam, void __user * arg)
+sn9c102_vidioc_g_jpegcomp(struct sn9c102_device *cam, void __user *arg)
 {
 	if (copy_to_user(arg, &cam->compression, sizeof(cam->compression)))
 		return -EFAULT;
@@ -2752,7 +2756,7 @@ sn9c102_vidioc_g_jpegcomp(struct sn9c102_device* cam, void __user * arg)
 
 
 static int
-sn9c102_vidioc_s_jpegcomp(struct sn9c102_device* cam, void __user * arg)
+sn9c102_vidioc_s_jpegcomp(struct sn9c102_device *cam, void __user *arg)
 {
 	struct v4l2_jpegcompression jc;
 	const enum sn9c102_stream_state stream = cam->stream;
@@ -2788,7 +2792,7 @@ sn9c102_vidioc_s_jpegcomp(struct sn9c102_device* cam, void __user * arg)
 
 
 static int
-sn9c102_vidioc_reqbufs(struct sn9c102_device* cam, void __user * arg)
+sn9c102_vidioc_reqbufs(struct sn9c102_device *cam, void __user *arg)
 {
 	struct v4l2_requestbuffers rb;
 	u32 i;
@@ -2839,7 +2843,7 @@ sn9c102_vidioc_reqbufs(struct sn9c102_device* cam, void __user * arg)
 
 
 static int
-sn9c102_vidioc_querybuf(struct sn9c102_device* cam, void __user * arg)
+sn9c102_vidioc_querybuf(struct sn9c102_device *cam, void __user *arg)
 {
 	struct v4l2_buffer b;
 
@@ -2868,7 +2872,7 @@ sn9c102_vidioc_querybuf(struct sn9c102_device* cam, void __user * arg)
 
 
 static int
-sn9c102_vidioc_qbuf(struct sn9c102_device* cam, void __user * arg)
+sn9c102_vidioc_qbuf(struct sn9c102_device *cam, void __user *arg)
 {
 	struct v4l2_buffer b;
 	unsigned long lock_flags;
@@ -2896,8 +2900,8 @@ sn9c102_vidioc_qbuf(struct sn9c102_device* cam, void __user * arg)
 
 
 static int
-sn9c102_vidioc_dqbuf(struct sn9c102_device* cam, struct file* filp,
-		     void __user * arg)
+sn9c102_vidioc_dqbuf(struct sn9c102_device *cam, struct file *filp,
+		     void __user *arg)
 {
 	struct v4l2_buffer b;
 	struct sn9c102_frame_t *f;
@@ -2918,20 +2922,20 @@ sn9c102_vidioc_dqbuf(struct sn9c102_device* cam, struct file* filp,
 			return -EAGAIN;
 		if (!cam->module_param.frame_timeout) {
 			err = wait_event_interruptible
-			      ( cam->wait_frame,
+			      (cam->wait_frame,
 				(!list_empty(&cam->outqueue)) ||
 				(cam->state & DEV_DISCONNECTED) ||
-				(cam->state & DEV_MISCONFIGURED) );
+				(cam->state & DEV_MISCONFIGURED));
 			if (err)
 				return err;
 		} else {
 			timeout = wait_event_interruptible_timeout
-				  ( cam->wait_frame,
+				  (cam->wait_frame,
 				    (!list_empty(&cam->outqueue)) ||
 				    (cam->state & DEV_DISCONNECTED) ||
 				    (cam->state & DEV_MISCONFIGURED),
 				    cam->module_param.frame_timeout *
-				    1000 * msecs_to_jiffies(1) );
+				    1000 * msecs_to_jiffies(1));
 			if (timeout < 0)
 				return timeout;
 			else if (timeout == 0 &&
@@ -2967,7 +2971,7 @@ sn9c102_vidioc_dqbuf(struct sn9c102_device* cam, struct file* filp,
 
 
 static int
-sn9c102_vidioc_streamon(struct sn9c102_device* cam, void __user * arg)
+sn9c102_vidioc_streamon(struct sn9c102_device *cam, void __user *arg)
 {
 	int type;
 
@@ -2986,7 +2990,7 @@ sn9c102_vidioc_streamon(struct sn9c102_device* cam, void __user * arg)
 
 
 static int
-sn9c102_vidioc_streamoff(struct sn9c102_device* cam, void __user * arg)
+sn9c102_vidioc_streamoff(struct sn9c102_device *cam, void __user *arg)
 {
 	int type, err;
 
@@ -3011,7 +3015,7 @@ sn9c102_vidioc_streamoff(struct sn9c102_device* cam, void __user * arg)
 
 
 static int
-sn9c102_vidioc_g_parm(struct sn9c102_device* cam, void __user * arg)
+sn9c102_vidioc_g_parm(struct sn9c102_device *cam, void __user *arg)
 {
 	struct v4l2_streamparm sp;
 
@@ -3032,7 +3036,7 @@ sn9c102_vidioc_g_parm(struct sn9c102_device* cam, void __user * arg)
 
 
 static int
-sn9c102_vidioc_s_parm(struct sn9c102_device* cam, void __user * arg)
+sn9c102_vidioc_s_parm(struct sn9c102_device *cam, void __user *arg)
 {
 	struct v4l2_streamparm sp;
 
@@ -3060,7 +3064,7 @@ sn9c102_vidioc_s_parm(struct sn9c102_device* cam, void __user * arg)
 
 
 static int
-sn9c102_vidioc_enumaudio(struct sn9c102_device* cam, void __user * arg)
+sn9c102_vidioc_enumaudio(struct sn9c102_device *cam, void __user *arg)
 {
 	struct v4l2_audio audio;
 
@@ -3085,7 +3089,7 @@ sn9c102_vidioc_enumaudio(struct sn9c102_device* cam, void __user * arg)
 
 
 static int
-sn9c102_vidioc_g_audio(struct sn9c102_device* cam, void __user * arg)
+sn9c102_vidioc_g_audio(struct sn9c102_device *cam, void __user *arg)
 {
 	struct v4l2_audio audio;
 
@@ -3106,7 +3110,7 @@ sn9c102_vidioc_g_audio(struct sn9c102_device* cam, void __user * arg)
 
 
 static int
-sn9c102_vidioc_s_audio(struct sn9c102_device* cam, void __user * arg)
+sn9c102_vidioc_s_audio(struct sn9c102_device *cam, void __user *arg)
 {
 	struct v4l2_audio audio;
 
@@ -3266,10 +3270,10 @@ static const struct v4l2_file_operations sn9c102_fops = {
 
 /* It exists a single interface only. We do not need to validate anything. */
 static int
-sn9c102_usb_probe(struct usb_interface* intf, const struct usb_device_id* id)
+sn9c102_usb_probe(struct usb_interface *intf, const struct usb_device_id *id)
 {
 	struct usb_device *udev = interface_to_usbdev(intf);
-	struct sn9c102_device* cam;
+	struct sn9c102_device *cam;
 	static unsigned int dev_nr;
 	unsigned int i;
 	int err = 0, r;
@@ -3419,9 +3423,9 @@ fail:
 }
 
 
-static void sn9c102_usb_disconnect(struct usb_interface* intf)
+static void sn9c102_usb_disconnect(struct usb_interface *intf)
 {
-	struct sn9c102_device* cam;
+	struct sn9c102_device *cam;
 
 	down_write(&sn9c102_dev_lock);
 
diff --git a/drivers/staging/media/sn9c102/sn9c102_devtable.h b/drivers/staging/media/sn9c102/sn9c102_devtable.h
index 4ba5692..b187a8a 100644
--- a/drivers/staging/media/sn9c102/sn9c102_devtable.h
+++ b/drivers/staging/media/sn9c102/sn9c102_devtable.h
@@ -129,17 +129,17 @@ static const struct usb_device_id sn9c102_id_table[] = {
    initialization of the SN9C1XX chip.
    Functions must return 0 on success, the appropriate error otherwise.
 */
-extern int sn9c102_probe_hv7131d(struct sn9c102_device* cam);
-extern int sn9c102_probe_hv7131r(struct sn9c102_device* cam);
-extern int sn9c102_probe_mi0343(struct sn9c102_device* cam);
-extern int sn9c102_probe_mi0360(struct sn9c102_device* cam);
+extern int sn9c102_probe_hv7131d(struct sn9c102_device *cam);
+extern int sn9c102_probe_hv7131r(struct sn9c102_device *cam);
+extern int sn9c102_probe_mi0343(struct sn9c102_device *cam);
+extern int sn9c102_probe_mi0360(struct sn9c102_device *cam);
 extern int sn9c102_probe_mt9v111(struct sn9c102_device *cam);
-extern int sn9c102_probe_ov7630(struct sn9c102_device* cam);
-extern int sn9c102_probe_ov7660(struct sn9c102_device* cam);
-extern int sn9c102_probe_pas106b(struct sn9c102_device* cam);
-extern int sn9c102_probe_pas202bcb(struct sn9c102_device* cam);
-extern int sn9c102_probe_tas5110c1b(struct sn9c102_device* cam);
-extern int sn9c102_probe_tas5110d(struct sn9c102_device* cam);
-extern int sn9c102_probe_tas5130d1b(struct sn9c102_device* cam);
+extern int sn9c102_probe_ov7630(struct sn9c102_device *cam);
+extern int sn9c102_probe_ov7660(struct sn9c102_device *cam);
+extern int sn9c102_probe_pas106b(struct sn9c102_device *cam);
+extern int sn9c102_probe_pas202bcb(struct sn9c102_device *cam);
+extern int sn9c102_probe_tas5110c1b(struct sn9c102_device *cam);
+extern int sn9c102_probe_tas5110d(struct sn9c102_device *cam);
+extern int sn9c102_probe_tas5130d1b(struct sn9c102_device *cam);
 
 #endif /* _SN9C102_DEVTABLE_H_ */
diff --git a/drivers/staging/media/sn9c102/sn9c102_hv7131d.c b/drivers/staging/media/sn9c102/sn9c102_hv7131d.c
index 4680721..f1d94f0 100644
--- a/drivers/staging/media/sn9c102/sn9c102_hv7131d.c
+++ b/drivers/staging/media/sn9c102/sn9c102_hv7131d.c
@@ -23,7 +23,7 @@
 #include "sn9c102_devtable.h"
 
 
-static int hv7131d_init(struct sn9c102_device* cam)
+static int hv7131d_init(struct sn9c102_device *cam)
 {
 	int err;
 
@@ -39,8 +39,8 @@ static int hv7131d_init(struct sn9c102_device* cam)
 }
 
 
-static int hv7131d_get_ctrl(struct sn9c102_device* cam,
-			    struct v4l2_control* ctrl)
+static int hv7131d_get_ctrl(struct sn9c102_device *cam,
+			    struct v4l2_control *ctrl)
 {
 	switch (ctrl->id) {
 	case V4L2_CID_EXPOSURE:
@@ -88,8 +88,8 @@ static int hv7131d_get_ctrl(struct sn9c102_device* cam,
 }
 
 
-static int hv7131d_set_ctrl(struct sn9c102_device* cam,
-			    const struct v4l2_control* ctrl)
+static int hv7131d_set_ctrl(struct sn9c102_device *cam,
+			    const struct v4l2_control *ctrl)
 {
 	int err = 0;
 
@@ -121,10 +121,10 @@ static int hv7131d_set_ctrl(struct sn9c102_device* cam,
 }
 
 
-static int hv7131d_set_crop(struct sn9c102_device* cam,
-			    const struct v4l2_rect* rect)
+static int hv7131d_set_crop(struct sn9c102_device *cam,
+			    const struct v4l2_rect *rect)
 {
-	struct sn9c102_sensor* s = sn9c102_get_sensor(cam);
+	struct sn9c102_sensor *s = sn9c102_get_sensor(cam);
 	int err = 0;
 	u8 h_start = (u8)(rect->left - s->cropcap.bounds.left) + 2,
 	   v_start = (u8)(rect->top - s->cropcap.bounds.top) + 2;
@@ -136,8 +136,8 @@ static int hv7131d_set_crop(struct sn9c102_device* cam,
 }
 
 
-static int hv7131d_set_pix_format(struct sn9c102_device* cam,
-				  const struct v4l2_pix_format* pix)
+static int hv7131d_set_pix_format(struct sn9c102_device *cam,
+				  const struct v4l2_pix_format *pix)
 {
 	int err = 0;
 
@@ -248,7 +248,7 @@ static const struct sn9c102_sensor hv7131d = {
 };
 
 
-int sn9c102_probe_hv7131d(struct sn9c102_device* cam)
+int sn9c102_probe_hv7131d(struct sn9c102_device *cam)
 {
 	int r0 = 0, r1 = 0, err;
 
diff --git a/drivers/staging/media/sn9c102/sn9c102_hv7131r.c b/drivers/staging/media/sn9c102/sn9c102_hv7131r.c
index 26a9111..f31236c 100644
--- a/drivers/staging/media/sn9c102/sn9c102_hv7131r.c
+++ b/drivers/staging/media/sn9c102/sn9c102_hv7131r.c
@@ -23,7 +23,7 @@
 #include "sn9c102_devtable.h"
 
 
-static int hv7131r_init(struct sn9c102_device* cam)
+static int hv7131r_init(struct sn9c102_device *cam)
 {
 	int err = 0;
 
@@ -137,8 +137,8 @@ static int hv7131r_init(struct sn9c102_device* cam)
 }
 
 
-static int hv7131r_get_ctrl(struct sn9c102_device* cam,
-			    struct v4l2_control* ctrl)
+static int hv7131r_get_ctrl(struct sn9c102_device *cam,
+			    struct v4l2_control *ctrl)
 {
 	switch (ctrl->id) {
 	case V4L2_CID_GAIN:
@@ -176,8 +176,8 @@ static int hv7131r_get_ctrl(struct sn9c102_device* cam,
 }
 
 
-static int hv7131r_set_ctrl(struct sn9c102_device* cam,
-			    const struct v4l2_control* ctrl)
+static int hv7131r_set_ctrl(struct sn9c102_device *cam,
+			    const struct v4l2_control *ctrl)
 {
 	int err = 0;
 
@@ -211,10 +211,10 @@ static int hv7131r_set_ctrl(struct sn9c102_device* cam,
 }
 
 
-static int hv7131r_set_crop(struct sn9c102_device* cam,
-			    const struct v4l2_rect* rect)
+static int hv7131r_set_crop(struct sn9c102_device *cam,
+			    const struct v4l2_rect *rect)
 {
-	struct sn9c102_sensor* s = sn9c102_get_sensor(cam);
+	struct sn9c102_sensor *s = sn9c102_get_sensor(cam);
 	int err = 0;
 	u8 h_start = (u8)(rect->left - s->cropcap.bounds.left) + 1,
 	   v_start = (u8)(rect->top - s->cropcap.bounds.top) + 1;
@@ -226,8 +226,8 @@ static int hv7131r_set_crop(struct sn9c102_device* cam,
 }
 
 
-static int hv7131r_set_pix_format(struct sn9c102_device* cam,
-				  const struct v4l2_pix_format* pix)
+static int hv7131r_set_pix_format(struct sn9c102_device *cam,
+				  const struct v4l2_pix_format *pix)
 {
 	int err = 0;
 
@@ -347,7 +347,7 @@ static const struct sn9c102_sensor hv7131r = {
 };
 
 
-int sn9c102_probe_hv7131r(struct sn9c102_device* cam)
+int sn9c102_probe_hv7131r(struct sn9c102_device *cam)
 {
 	int devid, err;
 
diff --git a/drivers/staging/media/sn9c102/sn9c102_mi0343.c b/drivers/staging/media/sn9c102/sn9c102_mi0343.c
index 1f5b09b..b20fdb6 100644
--- a/drivers/staging/media/sn9c102/sn9c102_mi0343.c
+++ b/drivers/staging/media/sn9c102/sn9c102_mi0343.c
@@ -23,9 +23,9 @@
 #include "sn9c102_devtable.h"
 
 
-static int mi0343_init(struct sn9c102_device* cam)
+static int mi0343_init(struct sn9c102_device *cam)
 {
-	struct sn9c102_sensor* s = sn9c102_get_sensor(cam);
+	struct sn9c102_sensor *s = sn9c102_get_sensor(cam);
 	int err = 0;
 
 	err = sn9c102_write_const_regs(cam, {0x00, 0x10}, {0x00, 0x11},
@@ -52,10 +52,10 @@ static int mi0343_init(struct sn9c102_device* cam)
 }
 
 
-static int mi0343_get_ctrl(struct sn9c102_device* cam,
-			   struct v4l2_control* ctrl)
+static int mi0343_get_ctrl(struct sn9c102_device *cam,
+			   struct v4l2_control *ctrl)
 {
-	struct sn9c102_sensor* s = sn9c102_get_sensor(cam);
+	struct sn9c102_sensor *s = sn9c102_get_sensor(cam);
 	u8 data[2];
 
 	switch (ctrl->id) {
@@ -119,10 +119,10 @@ static int mi0343_get_ctrl(struct sn9c102_device* cam,
 }
 
 
-static int mi0343_set_ctrl(struct sn9c102_device* cam,
-			   const struct v4l2_control* ctrl)
+static int mi0343_set_ctrl(struct sn9c102_device *cam,
+			   const struct v4l2_control *ctrl)
 {
-	struct sn9c102_sensor* s = sn9c102_get_sensor(cam);
+	struct sn9c102_sensor *s = sn9c102_get_sensor(cam);
 	u16 reg = 0;
 	int err = 0;
 
@@ -189,10 +189,10 @@ static int mi0343_set_ctrl(struct sn9c102_device* cam,
 }
 
 
-static int mi0343_set_crop(struct sn9c102_device* cam,
-			    const struct v4l2_rect* rect)
+static int mi0343_set_crop(struct sn9c102_device *cam,
+			    const struct v4l2_rect *rect)
 {
-	struct sn9c102_sensor* s = sn9c102_get_sensor(cam);
+	struct sn9c102_sensor *s = sn9c102_get_sensor(cam);
 	int err = 0;
 	u8 h_start = (u8)(rect->left - s->cropcap.bounds.left) + 0,
 	   v_start = (u8)(rect->top - s->cropcap.bounds.top) + 2;
@@ -204,10 +204,10 @@ static int mi0343_set_crop(struct sn9c102_device* cam,
 }
 
 
-static int mi0343_set_pix_format(struct sn9c102_device* cam,
-				 const struct v4l2_pix_format* pix)
+static int mi0343_set_pix_format(struct sn9c102_device *cam,
+				 const struct v4l2_pix_format *pix)
 {
-	struct sn9c102_sensor* s = sn9c102_get_sensor(cam);
+	struct sn9c102_sensor *s = sn9c102_get_sensor(cam);
 	int err = 0;
 
 	if (pix->pixelformat == V4L2_PIX_FMT_SN9C10X) {
@@ -331,7 +331,7 @@ static const struct sn9c102_sensor mi0343 = {
 };
 
 
-int sn9c102_probe_mi0343(struct sn9c102_device* cam)
+int sn9c102_probe_mi0343(struct sn9c102_device *cam)
 {
 	u8 data[2];
 
diff --git a/drivers/staging/media/sn9c102/sn9c102_mi0360.c b/drivers/staging/media/sn9c102/sn9c102_mi0360.c
index d973fc1..5f21d1b 100644
--- a/drivers/staging/media/sn9c102/sn9c102_mi0360.c
+++ b/drivers/staging/media/sn9c102/sn9c102_mi0360.c
@@ -23,9 +23,9 @@
 #include "sn9c102_devtable.h"
 
 
-static int mi0360_init(struct sn9c102_device* cam)
+static int mi0360_init(struct sn9c102_device *cam)
 {
-	struct sn9c102_sensor* s = sn9c102_get_sensor(cam);
+	struct sn9c102_sensor *s = sn9c102_get_sensor(cam);
 	int err = 0;
 
 	switch (sn9c102_get_bridge(cam)) {
@@ -147,10 +147,10 @@ static int mi0360_init(struct sn9c102_device* cam)
 }
 
 
-static int mi0360_get_ctrl(struct sn9c102_device* cam,
-			   struct v4l2_control* ctrl)
+static int mi0360_get_ctrl(struct sn9c102_device *cam,
+			   struct v4l2_control *ctrl)
 {
-	struct sn9c102_sensor* s = sn9c102_get_sensor(cam);
+	struct sn9c102_sensor *s = sn9c102_get_sensor(cam);
 	u8 data[2];
 
 	switch (ctrl->id) {
@@ -204,10 +204,10 @@ static int mi0360_get_ctrl(struct sn9c102_device* cam,
 }
 
 
-static int mi0360_set_ctrl(struct sn9c102_device* cam,
-			   const struct v4l2_control* ctrl)
+static int mi0360_set_ctrl(struct sn9c102_device *cam,
+			   const struct v4l2_control *ctrl)
 {
-	struct sn9c102_sensor* s = sn9c102_get_sensor(cam);
+	struct sn9c102_sensor *s = sn9c102_get_sensor(cam);
 	int err = 0;
 
 	switch (ctrl->id) {
@@ -259,10 +259,10 @@ static int mi0360_set_ctrl(struct sn9c102_device* cam,
 }
 
 
-static int mi0360_set_crop(struct sn9c102_device* cam,
-			    const struct v4l2_rect* rect)
+static int mi0360_set_crop(struct sn9c102_device *cam,
+			    const struct v4l2_rect *rect)
 {
-	struct sn9c102_sensor* s = sn9c102_get_sensor(cam);
+	struct sn9c102_sensor *s = sn9c102_get_sensor(cam);
 	int err = 0;
 	u8 h_start = 0, v_start = (u8)(rect->top - s->cropcap.bounds.top) + 1;
 
@@ -285,10 +285,10 @@ static int mi0360_set_crop(struct sn9c102_device* cam,
 }
 
 
-static int mi0360_set_pix_format(struct sn9c102_device* cam,
-				 const struct v4l2_pix_format* pix)
+static int mi0360_set_pix_format(struct sn9c102_device *cam,
+				 const struct v4l2_pix_format *pix)
 {
-	struct sn9c102_sensor* s = sn9c102_get_sensor(cam);
+	struct sn9c102_sensor *s = sn9c102_get_sensor(cam);
 	int err = 0;
 
 	if (pix->pixelformat == V4L2_PIX_FMT_SBGGR8) {
@@ -418,7 +418,7 @@ static const struct sn9c102_sensor mi0360 = {
 };
 
 
-int sn9c102_probe_mi0360(struct sn9c102_device* cam)
+int sn9c102_probe_mi0360(struct sn9c102_device *cam)
 {
 
 	u8 data[2];
diff --git a/drivers/staging/media/sn9c102/sn9c102_ov7630.c b/drivers/staging/media/sn9c102/sn9c102_ov7630.c
index d3a1bd8..9ec304d 100644
--- a/drivers/staging/media/sn9c102/sn9c102_ov7630.c
+++ b/drivers/staging/media/sn9c102/sn9c102_ov7630.c
@@ -23,7 +23,7 @@
 #include "sn9c102_devtable.h"
 
 
-static int ov7630_init(struct sn9c102_device* cam)
+static int ov7630_init(struct sn9c102_device *cam)
 {
 	int err = 0;
 
@@ -252,8 +252,8 @@ static int ov7630_init(struct sn9c102_device* cam)
 }
 
 
-static int ov7630_get_ctrl(struct sn9c102_device* cam,
-			   struct v4l2_control* ctrl)
+static int ov7630_get_ctrl(struct sn9c102_device *cam,
+			   struct v4l2_control *ctrl)
 {
 	enum sn9c102_bridge bridge = sn9c102_get_bridge(cam);
 	int err = 0;
@@ -330,8 +330,8 @@ static int ov7630_get_ctrl(struct sn9c102_device* cam,
 }
 
 
-static int ov7630_set_ctrl(struct sn9c102_device* cam,
-			   const struct v4l2_control* ctrl)
+static int ov7630_set_ctrl(struct sn9c102_device *cam,
+			   const struct v4l2_control *ctrl)
 {
 	enum sn9c102_bridge bridge = sn9c102_get_bridge(cam);
 	int err = 0;
@@ -385,10 +385,10 @@ static int ov7630_set_ctrl(struct sn9c102_device* cam,
 }
 
 
-static int ov7630_set_crop(struct sn9c102_device* cam,
-			   const struct v4l2_rect* rect)
+static int ov7630_set_crop(struct sn9c102_device *cam,
+			   const struct v4l2_rect *rect)
 {
-	struct sn9c102_sensor* s = sn9c102_get_sensor(cam);
+	struct sn9c102_sensor *s = sn9c102_get_sensor(cam);
 	int err = 0;
 	u8 h_start = 0, v_start = (u8)(rect->top - s->cropcap.bounds.top) + 1;
 
@@ -413,8 +413,8 @@ static int ov7630_set_crop(struct sn9c102_device* cam,
 }
 
 
-static int ov7630_set_pix_format(struct sn9c102_device* cam,
-				 const struct v4l2_pix_format* pix)
+static int ov7630_set_pix_format(struct sn9c102_device *cam,
+				 const struct v4l2_pix_format *pix)
 {
 	int err = 0;
 
@@ -594,7 +594,7 @@ static const struct sn9c102_sensor ov7630 = {
 };
 
 
-int sn9c102_probe_ov7630(struct sn9c102_device* cam)
+int sn9c102_probe_ov7630(struct sn9c102_device *cam)
 {
 	int pid, ver, err = 0;
 
diff --git a/drivers/staging/media/sn9c102/sn9c102_ov7660.c b/drivers/staging/media/sn9c102/sn9c102_ov7660.c
index 530157a..ac07805 100644
--- a/drivers/staging/media/sn9c102/sn9c102_ov7660.c
+++ b/drivers/staging/media/sn9c102/sn9c102_ov7660.c
@@ -23,7 +23,7 @@
 #include "sn9c102_devtable.h"
 
 
-static int ov7660_init(struct sn9c102_device* cam)
+static int ov7660_init(struct sn9c102_device *cam)
 {
 	int err = 0;
 
@@ -271,8 +271,8 @@ static int ov7660_init(struct sn9c102_device* cam)
 }
 
 
-static int ov7660_get_ctrl(struct sn9c102_device* cam,
-			   struct v4l2_control* ctrl)
+static int ov7660_get_ctrl(struct sn9c102_device *cam,
+			   struct v4l2_control *ctrl)
 {
 	int err = 0;
 
@@ -332,8 +332,8 @@ static int ov7660_get_ctrl(struct sn9c102_device* cam,
 }
 
 
-static int ov7660_set_ctrl(struct sn9c102_device* cam,
-			   const struct v4l2_control* ctrl)
+static int ov7660_set_ctrl(struct sn9c102_device *cam,
+			   const struct v4l2_control *ctrl)
 {
 	int err = 0;
 
@@ -371,10 +371,10 @@ static int ov7660_set_ctrl(struct sn9c102_device* cam,
 }
 
 
-static int ov7660_set_crop(struct sn9c102_device* cam,
-			   const struct v4l2_rect* rect)
+static int ov7660_set_crop(struct sn9c102_device *cam,
+			   const struct v4l2_rect *rect)
 {
-	struct sn9c102_sensor* s = sn9c102_get_sensor(cam);
+	struct sn9c102_sensor *s = sn9c102_get_sensor(cam);
 	int err = 0;
 	u8 h_start = (u8)(rect->left - s->cropcap.bounds.left) + 1,
 	   v_start = (u8)(rect->top - s->cropcap.bounds.top) + 1;
@@ -386,8 +386,8 @@ static int ov7660_set_crop(struct sn9c102_device* cam,
 }
 
 
-static int ov7660_set_pix_format(struct sn9c102_device* cam,
-				 const struct v4l2_pix_format* pix)
+static int ov7660_set_pix_format(struct sn9c102_device *cam,
+				 const struct v4l2_pix_format *pix)
 {
 	int r0, err = 0;
 
@@ -525,7 +525,7 @@ static const struct sn9c102_sensor ov7660 = {
 };
 
 
-int sn9c102_probe_ov7660(struct sn9c102_device* cam)
+int sn9c102_probe_ov7660(struct sn9c102_device *cam)
 {
 	int pid, ver, err;
 
diff --git a/drivers/staging/media/sn9c102/sn9c102_pas106b.c b/drivers/staging/media/sn9c102/sn9c102_pas106b.c
index 47bd82d..895931e 100644
--- a/drivers/staging/media/sn9c102/sn9c102_pas106b.c
+++ b/drivers/staging/media/sn9c102/sn9c102_pas106b.c
@@ -24,7 +24,7 @@
 #include "sn9c102_devtable.h"
 
 
-static int pas106b_init(struct sn9c102_device* cam)
+static int pas106b_init(struct sn9c102_device *cam)
 {
 	int err = 0;
 
@@ -48,8 +48,8 @@ static int pas106b_init(struct sn9c102_device* cam)
 }
 
 
-static int pas106b_get_ctrl(struct sn9c102_device* cam,
-			    struct v4l2_control* ctrl)
+static int pas106b_get_ctrl(struct sn9c102_device *cam,
+			    struct v4l2_control *ctrl)
 {
 	switch (ctrl->id) {
 	case V4L2_CID_EXPOSURE:
@@ -103,8 +103,8 @@ static int pas106b_get_ctrl(struct sn9c102_device* cam,
 }
 
 
-static int pas106b_set_ctrl(struct sn9c102_device* cam,
-			    const struct v4l2_control* ctrl)
+static int pas106b_set_ctrl(struct sn9c102_device *cam,
+			    const struct v4l2_control *ctrl)
 {
 	int err = 0;
 
@@ -141,10 +141,10 @@ static int pas106b_set_ctrl(struct sn9c102_device* cam,
 }
 
 
-static int pas106b_set_crop(struct sn9c102_device* cam,
-			    const struct v4l2_rect* rect)
+static int pas106b_set_crop(struct sn9c102_device *cam,
+			    const struct v4l2_rect *rect)
 {
-	struct sn9c102_sensor* s = sn9c102_get_sensor(cam);
+	struct sn9c102_sensor *s = sn9c102_get_sensor(cam);
 	int err = 0;
 	u8 h_start = (u8)(rect->left - s->cropcap.bounds.left) + 4,
 	   v_start = (u8)(rect->top - s->cropcap.bounds.top) + 3;
@@ -156,8 +156,8 @@ static int pas106b_set_crop(struct sn9c102_device* cam,
 }
 
 
-static int pas106b_set_pix_format(struct sn9c102_device* cam,
-				  const struct v4l2_pix_format* pix)
+static int pas106b_set_pix_format(struct sn9c102_device *cam,
+				  const struct v4l2_pix_format *pix)
 {
 	int err = 0;
 
@@ -278,7 +278,7 @@ static const struct sn9c102_sensor pas106b = {
 };
 
 
-int sn9c102_probe_pas106b(struct sn9c102_device* cam)
+int sn9c102_probe_pas106b(struct sn9c102_device *cam)
 {
 	int r0 = 0, r1 = 0;
 	unsigned int pid = 0;
diff --git a/drivers/staging/media/sn9c102/sn9c102_pas202bcb.c b/drivers/staging/media/sn9c102/sn9c102_pas202bcb.c
index cbfacc2..f9e31ae 100644
--- a/drivers/staging/media/sn9c102/sn9c102_pas202bcb.c
+++ b/drivers/staging/media/sn9c102/sn9c102_pas202bcb.c
@@ -28,7 +28,7 @@
 #include "sn9c102_devtable.h"
 
 
-static int pas202bcb_init(struct sn9c102_device* cam)
+static int pas202bcb_init(struct sn9c102_device *cam)
 {
 	int err = 0;
 
@@ -78,8 +78,8 @@ static int pas202bcb_init(struct sn9c102_device* cam)
 }
 
 
-static int pas202bcb_get_ctrl(struct sn9c102_device* cam,
-			      struct v4l2_control* ctrl)
+static int pas202bcb_get_ctrl(struct sn9c102_device *cam,
+			      struct v4l2_control *ctrl)
 {
 	switch (ctrl->id) {
 	case V4L2_CID_EXPOSURE:
@@ -126,8 +126,8 @@ static int pas202bcb_get_ctrl(struct sn9c102_device* cam,
 }
 
 
-static int pas202bcb_set_pix_format(struct sn9c102_device* cam,
-				    const struct v4l2_pix_format* pix)
+static int pas202bcb_set_pix_format(struct sn9c102_device *cam,
+				    const struct v4l2_pix_format *pix)
 {
 	int err = 0;
 
@@ -140,8 +140,8 @@ static int pas202bcb_set_pix_format(struct sn9c102_device* cam,
 }
 
 
-static int pas202bcb_set_ctrl(struct sn9c102_device* cam,
-			      const struct v4l2_control* ctrl)
+static int pas202bcb_set_ctrl(struct sn9c102_device *cam,
+			      const struct v4l2_control *ctrl)
 {
 	int err = 0;
 
@@ -174,10 +174,10 @@ static int pas202bcb_set_ctrl(struct sn9c102_device* cam,
 }
 
 
-static int pas202bcb_set_crop(struct sn9c102_device* cam,
-			      const struct v4l2_rect* rect)
+static int pas202bcb_set_crop(struct sn9c102_device *cam,
+			      const struct v4l2_rect *rect)
 {
-	struct sn9c102_sensor* s = sn9c102_get_sensor(cam);
+	struct sn9c102_sensor *s = sn9c102_get_sensor(cam);
 	int err = 0;
 	u8 h_start = 0,
 	   v_start = (u8)(rect->top - s->cropcap.bounds.top) + 3;
@@ -299,7 +299,7 @@ static const struct sn9c102_sensor pas202bcb = {
 };
 
 
-int sn9c102_probe_pas202bcb(struct sn9c102_device* cam)
+int sn9c102_probe_pas202bcb(struct sn9c102_device *cam)
 {
 	int r0 = 0, r1 = 0, err = 0;
 	unsigned int pid = 0;
diff --git a/drivers/staging/media/sn9c102/sn9c102_sensor.h b/drivers/staging/media/sn9c102/sn9c102_sensor.h
index 3679970..9f59c81 100644
--- a/drivers/staging/media/sn9c102/sn9c102_sensor.h
+++ b/drivers/staging/media/sn9c102/sn9c102_sensor.h
@@ -62,19 +62,19 @@ enum sn9c102_bridge {
 };
 
 /* Return the bridge name */
-enum sn9c102_bridge sn9c102_get_bridge(struct sn9c102_device* cam);
+enum sn9c102_bridge sn9c102_get_bridge(struct sn9c102_device *cam);
 
 /* Return a pointer the sensor struct attached to the camera */
-struct sn9c102_sensor* sn9c102_get_sensor(struct sn9c102_device* cam);
+struct sn9c102_sensor *sn9c102_get_sensor(struct sn9c102_device *cam);
 
 /* Identify a device */
 extern struct sn9c102_device*
-sn9c102_match_id(struct sn9c102_device* cam, const struct usb_device_id *id);
+sn9c102_match_id(struct sn9c102_device *cam, const struct usb_device_id *id);
 
 /* Attach a probed sensor to the camera. */
 extern void
-sn9c102_attach_sensor(struct sn9c102_device* cam,
-		      const struct sn9c102_sensor* sensor);
+sn9c102_attach_sensor(struct sn9c102_device *cam,
+		      const struct sn9c102_sensor *sensor);
 
 /*
    Read/write routines: they always return -1 on error, 0 or the read value
@@ -99,12 +99,12 @@ extern int sn9c102_i2c_try_read(struct sn9c102_device*,
    version returns 0 on success, while the read version returns the first read
    byte.
 */
-extern int sn9c102_i2c_try_raw_write(struct sn9c102_device* cam,
-				     const struct sn9c102_sensor* sensor, u8 n,
+extern int sn9c102_i2c_try_raw_write(struct sn9c102_device *cam,
+				     const struct sn9c102_sensor *sensor, u8 n,
 				     u8 data0, u8 data1, u8 data2, u8 data3,
 				     u8 data4, u8 data5);
-extern int sn9c102_i2c_try_raw_read(struct sn9c102_device* cam,
-				    const struct sn9c102_sensor* sensor,
+extern int sn9c102_i2c_try_raw_read(struct sn9c102_device *cam,
+				    const struct sn9c102_sensor *sensor,
 				    u8 data0, u8 data1, u8 n, u8 buffer[]);
 
 /* To be used after the sensor struct has been attached to the camera struct */
@@ -174,7 +174,7 @@ struct sn9c102_sensor {
 		 they must return 0 on success, the proper error otherwise.
 	*/
 
-	int (*init)(struct sn9c102_device* cam);
+	int (*init)(struct sn9c102_device *cam);
 	/*
 	   This function will be called after the sensor has been attached.
 	   It should be used to initialize the sensor only, but may also
@@ -195,9 +195,9 @@ struct sn9c102_sensor {
 	   V4L2 API. Menu type controls are not handled by this interface.
 	*/
 
-	int (*get_ctrl)(struct sn9c102_device* cam, struct v4l2_control* ctrl);
-	int (*set_ctrl)(struct sn9c102_device* cam,
-			const struct v4l2_control* ctrl);
+	int (*get_ctrl)(struct sn9c102_device *cam, struct v4l2_control *ctrl);
+	int (*set_ctrl)(struct sn9c102_device *cam,
+			const struct v4l2_control *ctrl);
 	/*
 	   You must implement at least the set_ctrl method if you have defined
 	   the list above. The returned value must follow the V4L2
@@ -240,8 +240,8 @@ struct sn9c102_sensor {
 	   will be ignored.
 	*/
 
-	int (*set_crop)(struct sn9c102_device* cam,
-			const struct v4l2_rect* rect);
+	int (*set_crop)(struct sn9c102_device *cam,
+			const struct v4l2_rect *rect);
 	/*
 	   To be called on VIDIOC_C_SETCROP. The core module always calls a
 	   default routine which configures the appropriate SN9C1XX regs (also
@@ -276,8 +276,8 @@ struct sn9c102_sensor {
 		   matches the RGB bayer sequence (i.e. BGBGBG...GRGRGR).
 	*/
 
-	int (*set_pix_format)(struct sn9c102_device* cam,
-			      const struct v4l2_pix_format* pix);
+	int (*set_pix_format)(struct sn9c102_device *cam,
+			      const struct v4l2_pix_format *pix);
 	/*
 	   To be called on VIDIOC_S_FMT, when switching from the SBGGR8 to
 	   SN9C10X pixel format or viceversa. On error return the corresponding
diff --git a/drivers/staging/media/sn9c102/sn9c102_tas5110c1b.c b/drivers/staging/media/sn9c102/sn9c102_tas5110c1b.c
index 04cdfdd..6a00b62 100644
--- a/drivers/staging/media/sn9c102/sn9c102_tas5110c1b.c
+++ b/drivers/staging/media/sn9c102/sn9c102_tas5110c1b.c
@@ -23,7 +23,7 @@
 #include "sn9c102_devtable.h"
 
 
-static int tas5110c1b_init(struct sn9c102_device* cam)
+static int tas5110c1b_init(struct sn9c102_device *cam)
 {
 	int err = 0;
 
@@ -38,8 +38,8 @@ static int tas5110c1b_init(struct sn9c102_device* cam)
 }
 
 
-static int tas5110c1b_set_ctrl(struct sn9c102_device* cam,
-			       const struct v4l2_control* ctrl)
+static int tas5110c1b_set_ctrl(struct sn9c102_device *cam,
+			       const struct v4l2_control *ctrl)
 {
 	int err = 0;
 
@@ -55,10 +55,10 @@ static int tas5110c1b_set_ctrl(struct sn9c102_device* cam,
 }
 
 
-static int tas5110c1b_set_crop(struct sn9c102_device* cam,
-			       const struct v4l2_rect* rect)
+static int tas5110c1b_set_crop(struct sn9c102_device *cam,
+			       const struct v4l2_rect *rect)
 {
-	struct sn9c102_sensor* s = sn9c102_get_sensor(cam);
+	struct sn9c102_sensor *s = sn9c102_get_sensor(cam);
 	int err = 0;
 	u8 h_start = (u8)(rect->left - s->cropcap.bounds.left) + 69,
 	   v_start = (u8)(rect->top - s->cropcap.bounds.top) + 9;
@@ -75,8 +75,8 @@ static int tas5110c1b_set_crop(struct sn9c102_device* cam,
 }
 
 
-static int tas5110c1b_set_pix_format(struct sn9c102_device* cam,
-				     const struct v4l2_pix_format* pix)
+static int tas5110c1b_set_pix_format(struct sn9c102_device *cam,
+				     const struct v4l2_pix_format *pix)
 {
 	int err = 0;
 
@@ -135,7 +135,7 @@ static const struct sn9c102_sensor tas5110c1b = {
 };
 
 
-int sn9c102_probe_tas5110c1b(struct sn9c102_device* cam)
+int sn9c102_probe_tas5110c1b(struct sn9c102_device *cam)
 {
 	const struct usb_device_id tas5110c1b_id_table[] = {
 		{ USB_DEVICE(0x0c45, 0x6001), },
diff --git a/drivers/staging/media/sn9c102/sn9c102_tas5110d.c b/drivers/staging/media/sn9c102/sn9c102_tas5110d.c
index 9372e6f..eefbf86 100644
--- a/drivers/staging/media/sn9c102/sn9c102_tas5110d.c
+++ b/drivers/staging/media/sn9c102/sn9c102_tas5110d.c
@@ -23,7 +23,7 @@
 #include "sn9c102_devtable.h"
 
 
-static int tas5110d_init(struct sn9c102_device* cam)
+static int tas5110d_init(struct sn9c102_device *cam)
 {
 	int err;
 
@@ -37,10 +37,10 @@ static int tas5110d_init(struct sn9c102_device* cam)
 }
 
 
-static int tas5110d_set_crop(struct sn9c102_device* cam,
-			     const struct v4l2_rect* rect)
+static int tas5110d_set_crop(struct sn9c102_device *cam,
+			     const struct v4l2_rect *rect)
 {
-	struct sn9c102_sensor* s = sn9c102_get_sensor(cam);
+	struct sn9c102_sensor *s = sn9c102_get_sensor(cam);
 	int err = 0;
 	u8 h_start = (u8)(rect->left - s->cropcap.bounds.left) + 69,
 	   v_start = (u8)(rect->top - s->cropcap.bounds.top) + 9;
@@ -55,8 +55,8 @@ static int tas5110d_set_crop(struct sn9c102_device* cam,
 }
 
 
-static int tas5110d_set_pix_format(struct sn9c102_device* cam,
-				     const struct v4l2_pix_format* pix)
+static int tas5110d_set_pix_format(struct sn9c102_device *cam,
+				     const struct v4l2_pix_format *pix)
 {
 	int err = 0;
 
@@ -103,7 +103,7 @@ static const struct sn9c102_sensor tas5110d = {
 };
 
 
-int sn9c102_probe_tas5110d(struct sn9c102_device* cam)
+int sn9c102_probe_tas5110d(struct sn9c102_device *cam)
 {
 	const struct usb_device_id tas5110d_id_table[] = {
 		{ USB_DEVICE(0x0c45, 0x6007), },
diff --git a/drivers/staging/media/sn9c102/sn9c102_tas5130d1b.c b/drivers/staging/media/sn9c102/sn9c102_tas5130d1b.c
index a30bbc4..725de85 100644
--- a/drivers/staging/media/sn9c102/sn9c102_tas5130d1b.c
+++ b/drivers/staging/media/sn9c102/sn9c102_tas5130d1b.c
@@ -23,7 +23,7 @@
 #include "sn9c102_devtable.h"
 
 
-static int tas5130d1b_init(struct sn9c102_device* cam)
+static int tas5130d1b_init(struct sn9c102_device *cam)
 {
 	int err;
 
@@ -36,8 +36,8 @@ static int tas5130d1b_init(struct sn9c102_device* cam)
 }
 
 
-static int tas5130d1b_set_ctrl(struct sn9c102_device* cam,
-			       const struct v4l2_control* ctrl)
+static int tas5130d1b_set_ctrl(struct sn9c102_device *cam,
+			       const struct v4l2_control *ctrl)
 {
 	int err = 0;
 
@@ -56,10 +56,10 @@ static int tas5130d1b_set_ctrl(struct sn9c102_device* cam,
 }
 
 
-static int tas5130d1b_set_crop(struct sn9c102_device* cam,
-			       const struct v4l2_rect* rect)
+static int tas5130d1b_set_crop(struct sn9c102_device *cam,
+			       const struct v4l2_rect *rect)
 {
-	struct sn9c102_sensor* s = sn9c102_get_sensor(cam);
+	struct sn9c102_sensor *s = sn9c102_get_sensor(cam);
 	u8 h_start = (u8)(rect->left - s->cropcap.bounds.left) + 104,
 	   v_start = (u8)(rect->top - s->cropcap.bounds.top) + 12;
 	int err = 0;
@@ -76,8 +76,8 @@ static int tas5130d1b_set_crop(struct sn9c102_device* cam,
 }
 
 
-static int tas5130d1b_set_pix_format(struct sn9c102_device* cam,
-				     const struct v4l2_pix_format* pix)
+static int tas5130d1b_set_pix_format(struct sn9c102_device *cam,
+				     const struct v4l2_pix_format *pix)
 {
 	int err = 0;
 
@@ -146,7 +146,7 @@ static const struct sn9c102_sensor tas5130d1b = {
 };
 
 
-int sn9c102_probe_tas5130d1b(struct sn9c102_device* cam)
+int sn9c102_probe_tas5130d1b(struct sn9c102_device *cam)
 {
 	const struct usb_device_id tas5130d1b_id_table[] = {
 		{ USB_DEVICE(0x0c45, 0x6024), },
-- 
1.7.7.6


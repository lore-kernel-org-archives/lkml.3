Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758339Ab3BKRle (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 12:41:34 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:38005 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757872Ab3BKRlb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 12:41:31 -0500
Message-ID: <1360604489.2028.25.camel@joe-AO722>
Subject: [PATCH] staging: Remove unnecessary OOM messages
From: Joe Perches <joe@perches.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: devel <devel@driverdev.osuosl.org>, LKML <linux-kernel@vger.kernel.org>
Date: Mon, 11 Feb 2013 09:41:29 -0800
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

alloc failures already get standardized OOM
messages and a dump_stack.

For the affected mallocs around these OOM messages:

Converted kzallocs with multiplies to kcalloc.
Converted kmallocs with multiplies to kmalloc_array.
Converted a kmalloc/strlen/strncpy to kstrdup.
Moved a spin_lock below a removed OOM message and
removed a now unnecessary spin_unlock.
Neatened alignment and whitespace.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/staging/asus_oled/asus_oled.c              | 15 ++-----
 drivers/staging/bcm/InterfaceInit.c                | 14 ++----
 drivers/staging/ced1401/usb1401.c                  |  4 +-
 drivers/staging/comedi/drivers.c                   |  5 +--
 drivers/staging/comedi/drivers/amplc_dio200.c      |  9 ++--
 drivers/staging/comedi/drivers/comedi_bond.c       |  5 +--
 drivers/staging/comedi/drivers/dt9812.c            |  5 +--
 drivers/staging/comedi/drivers/ni_labpc.c          | 10 ++---
 drivers/staging/comedi/drivers/pcmuio.c            | 11 ++---
 drivers/staging/comedi/drivers/unioxx5.c           |  6 +--
 drivers/staging/comedi/drivers/usbdux.c            | 27 ++----------
 drivers/staging/comedi/drivers/usbduxfast.c        |  6 ---
 drivers/staging/comedi/drivers/usbduxsigma.c       | 31 +++----------
 drivers/staging/cptm1217/clearpad_tm1217.c         |  5 +--
 drivers/staging/et131x/et131x.c                    | 20 +++------
 drivers/staging/frontier/alphatrack.c              | 51 +++++++++-------------
 drivers/staging/frontier/tranzport.c               | 26 +++++------
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.c     |  5 +--
 drivers/staging/gdm72xx/gdm_sdio.c                 |  8 +---
 drivers/staging/gdm72xx/sdio_boot.c                |  9 +---
 drivers/staging/gdm72xx/usb_boot.c                 |  8 +---
 drivers/staging/iio/accel/lis3l02dq_ring.c         |  5 +--
 drivers/staging/keucr/usb.c                        |  5 +--
 drivers/staging/line6/driver.c                     | 25 ++---------
 drivers/staging/line6/pcm.c                        |  6 ---
 drivers/staging/media/as102/as102_usb_drv.c        |  4 +-
 drivers/staging/media/go7007/go7007-fw.c           | 24 +++-------
 drivers/staging/media/go7007/s2250-loader.c        |  5 +--
 drivers/staging/media/lirc/lirc_imon.c             |  3 --
 drivers/staging/media/lirc/lirc_sasem.c            |  6 ---
 drivers/staging/omapdrm/omap_connector.c           |  4 +-
 drivers/staging/omapdrm/omap_crtc.c                |  5 +--
 drivers/staging/omapdrm/omap_dmm_tiler.c           | 13 ++----
 drivers/staging/omapdrm/omap_drv.c                 |  4 +-
 drivers/staging/omapdrm/omap_encoder.c             |  4 +-
 drivers/staging/omapdrm/omap_fb.c                  |  1 -
 drivers/staging/omapdrm/omap_fbdev.c               |  4 +-
 drivers/staging/omapdrm/omap_gem.c                 | 10 ++---
 drivers/staging/omapdrm/omap_plane.c               |  4 +-
 .../staging/rtl8187se/ieee80211/ieee80211_module.c |  4 +-
 drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c |  6 +--
 drivers/staging/sbe-2t3e3/dc.c                     |  9 ++--
 drivers/staging/sbe-2t3e3/module.c                 |  7 ++-
 drivers/staging/sep/sep_crypto.c                   |  6 +--
 drivers/staging/sep/sep_main.c                     | 44 +++++--------------
 drivers/staging/speakup/selection.c                |  1 -
 drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c      | 18 +++-----
 drivers/staging/tidspbridge/pmgr/dspapi.c          |  2 +-
 drivers/staging/tidspbridge/rmgr/proc.c            | 17 +++-----
 drivers/staging/usbip/stub_dev.c                   |  4 +-
 drivers/staging/usbip/stub_rx.c                    |  1 -
 drivers/staging/usbip/stub_tx.c                    |  1 -
 drivers/staging/usbip/vhci_hcd.c                   |  8 +---
 drivers/staging/vme/devices/vme_pio2_core.c        |  1 -
 drivers/staging/vme/devices/vme_pio2_gpio.c        |  4 +-
 drivers/staging/vme/devices/vme_user.c             |  2 -
 drivers/staging/zcache/zcache-main.c               |  9 ++--
 drivers/staging/zram/zram_drv.c                    |  5 +--
 58 files changed, 153 insertions(+), 408 deletions(-)

diff --git a/drivers/staging/asus_oled/asus_oled.c b/drivers/staging/asus_oled/asus_oled.c
index 0018547..d0a5a28 100644
--- a/drivers/staging/asus_oled/asus_oled.c
+++ b/drivers/staging/asus_oled/asus_oled.c
@@ -164,11 +164,8 @@ static void enable_oled(struct asus_oled_dev *odev, uint8_t enabl)
 	struct asus_oled_packet *packet;
 
 	packet = kzalloc(sizeof(struct asus_oled_packet), GFP_KERNEL);
-
-	if (!packet) {
-		dev_err(&odev->udev->dev, "out of memory\n");
+	if (!packet)
 		return;
-	}
 
 	setup_packet_header(packet, 0x20, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00);
 
@@ -323,11 +320,8 @@ static void send_data(struct asus_oled_dev *odev)
 	struct asus_oled_packet *packet;
 
 	packet = kzalloc(sizeof(struct asus_oled_packet), GFP_KERNEL);
-
-	if (!packet) {
-		dev_err(&odev->udev->dev, "out of memory\n");
+	if (!packet)
 		return;
-	}
 
 	if (odev->pack_mode == PACK_MODE_G1) {
 		/* When sending roll-mode data the display updated only
@@ -665,11 +659,8 @@ static int asus_oled_probe(struct usb_interface *interface,
 	}
 
 	odev = kzalloc(sizeof(struct asus_oled_dev), GFP_KERNEL);
-
-	if (odev == NULL) {
-		dev_err(&interface->dev, "Out of memory\n");
+	if (odev == NULL)
 		return -ENOMEM;
-	}
 
 	odev->udev = usb_get_dev(udev);
 	odev->pic_mode = ASUS_OLED_STATIC;
diff --git a/drivers/staging/bcm/InterfaceInit.c b/drivers/staging/bcm/InterfaceInit.c
index eb24643..79058ce 100644
--- a/drivers/staging/bcm/InterfaceInit.c
+++ b/drivers/staging/bcm/InterfaceInit.c
@@ -190,9 +190,9 @@ static int usbbcm_device_probe(struct usb_interface *intf, const struct usb_devi
 	}
 
 	/* Allocate interface adapter structure */
-	psIntfAdapter = kzalloc(sizeof(struct bcm_interface_adapter), GFP_KERNEL);
+	psIntfAdapter = kzalloc(sizeof(struct bcm_interface_adapter),
+				GFP_KERNEL);
 	if (psIntfAdapter == NULL) {
-		dev_err(&udev->dev, DRV_NAME ": no memory for Interface adapter\n");
 		AdapterFree(psAdapter);
 		return -ENOMEM;
 	}
@@ -564,11 +564,8 @@ static int InterfaceAdapterInit(struct bcm_interface_adapter *psIntfAdapter)
 			psIntfAdapter->sIntrIn.int_in_interval = endpoint->bInterval;
 			psIntfAdapter->sIntrIn.int_in_buffer =
 						kmalloc(buffer_size, GFP_KERNEL);
-			if (!psIntfAdapter->sIntrIn.int_in_buffer) {
-				dev_err(&psIntfAdapter->udev->dev,
-					"could not allocate interrupt_in_buffer\n");
+			if (!psIntfAdapter->sIntrIn.int_in_buffer)
 				return -EINVAL;
-			}
 		}
 
 		if (!psIntfAdapter->sIntrOut.int_out_endpointAddr && bcm_usb_endpoint_is_int_out(endpoint)) {
@@ -587,11 +584,8 @@ static int InterfaceAdapterInit(struct bcm_interface_adapter *psIntfAdapter)
 				psIntfAdapter->sIntrOut.int_out_endpointAddr = endpoint->bEndpointAddress;
 				psIntfAdapter->sIntrOut.int_out_interval = endpoint->bInterval;
 				psIntfAdapter->sIntrOut.int_out_buffer = kmalloc(buffer_size, GFP_KERNEL);
-				if (!psIntfAdapter->sIntrOut.int_out_buffer) {
-					dev_err(&psIntfAdapter->udev->dev,
-						"could not allocate interrupt_out_buffer\n");
+				if (!psIntfAdapter->sIntrOut.int_out_buffer)
 					return -EINVAL;
-				}
 			}
 		}
 	}
diff --git a/drivers/staging/ced1401/usb1401.c b/drivers/staging/ced1401/usb1401.c
index 60bed3e..254131d 100644
--- a/drivers/staging/ced1401/usb1401.c
+++ b/drivers/staging/ced1401/usb1401.c
@@ -1391,10 +1391,8 @@ static int ced_probe(struct usb_interface *interface,
 
 	// allocate memory for our device extension and initialize it
 	pdx = kzalloc(sizeof(*pdx), GFP_KERNEL);
-	if (!pdx) {
-		dev_err(&interface->dev, "Out of memory\n");
+	if (!pdx)
 		goto error;
-	}
 
 	for (i = 0; i < MAX_TRANSAREAS; ++i)	// Initialise the wait queues
 	{
diff --git a/drivers/staging/comedi/drivers.c b/drivers/staging/comedi/drivers.c
index e57e661..64be7c5 100644
--- a/drivers/staging/comedi/drivers.c
+++ b/drivers/staging/comedi/drivers.c
@@ -203,10 +203,9 @@ static int __comedi_device_postconfig_async(struct comedi_device *dev,
 	}
 
 	async = kzalloc(sizeof(*async), GFP_KERNEL);
-	if (!async) {
-		dev_warn(dev->class_dev, "failed to allocate async struct\n");
+	if (!async)
 		return -ENOMEM;
-	}
+
 	init_waitqueue_head(&async->wait_head);
 	async->subdevice = s;
 	s->async = async;
diff --git a/drivers/staging/comedi/drivers/amplc_dio200.c b/drivers/staging/comedi/drivers/amplc_dio200.c
index b30d1a0..7c53dea 100644
--- a/drivers/staging/comedi/drivers/amplc_dio200.c
+++ b/drivers/staging/comedi/drivers/amplc_dio200.c
@@ -1105,10 +1105,9 @@ dio200_subdev_intr_init(struct comedi_device *dev, struct comedi_subdevice *s,
 	struct dio200_subdev_intr *subpriv;
 
 	subpriv = kzalloc(sizeof(*subpriv), GFP_KERNEL);
-	if (!subpriv) {
-		dev_err(dev->class_dev, "error! out of memory!\n");
+	if (!subpriv)
 		return -ENOMEM;
-	}
+
 	subpriv->ofs = offset;
 	subpriv->valid_isns = valid_isns;
 	spin_lock_init(&subpriv->spinlock);
@@ -1444,10 +1443,8 @@ dio200_subdev_8254_init(struct comedi_device *dev, struct comedi_subdevice *s,
 	unsigned int chan;
 
 	subpriv = kzalloc(sizeof(*subpriv), GFP_KERNEL);
-	if (!subpriv) {
-		dev_err(dev->class_dev, "error! out of memory!\n");
+	if (!subpriv)
 		return -ENOMEM;
-	}
 
 	s->private = subpriv;
 	s->type = COMEDI_SUBD_COUNTER;
diff --git a/drivers/staging/comedi/drivers/comedi_bond.c b/drivers/staging/comedi/drivers/comedi_bond.c
index 3151599..1bb5381 100644
--- a/drivers/staging/comedi/drivers/comedi_bond.c
+++ b/drivers/staging/comedi/drivers/comedi_bond.c
@@ -245,10 +245,9 @@ static int doDevConfig(struct comedi_device *dev, struct comedi_devconfig *it)
 				return 0;
 			}
 			bdev = kmalloc(sizeof(*bdev), GFP_KERNEL);
-			if (!bdev) {
-				dev_err(dev->class_dev, "Out of memory\n");
+			if (!bdev)
 				return 0;
-			}
+
 			bdev->dev = d;
 			bdev->minor = minor;
 			bdev->subdev = sdev;
diff --git a/drivers/staging/comedi/drivers/dt9812.c b/drivers/staging/comedi/drivers/dt9812.c
index fc5b30c..192cf08 100644
--- a/drivers/staging/comedi/drivers/dt9812.c
+++ b/drivers/staging/comedi/drivers/dt9812.c
@@ -702,10 +702,9 @@ static int dt9812_probe(struct usb_interface *interface,
 
 	/* allocate memory for our device state and initialize it */
 	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
-	if (dev == NULL) {
-		dev_err(&interface->dev, "Out of memory\n");
+	if (dev == NULL)
 		goto error;
-	}
+
 	kref_init(&dev->kref);
 
 	dev->udev = usb_get_dev(interface_to_usbdev(interface));
diff --git a/drivers/staging/comedi/drivers/ni_labpc.c b/drivers/staging/comedi/drivers/ni_labpc.c
index f851c54..f957b88 100644
--- a/drivers/staging/comedi/drivers/ni_labpc.c
+++ b/drivers/staging/comedi/drivers/ni_labpc.c
@@ -570,13 +570,11 @@ int labpc_common_attach(struct comedi_device *dev, unsigned long iobase,
 		return -EINVAL;
 	} else if (dma_chan) {
 		/* allocate dma buffer */
-		devpriv->dma_buffer =
-		    kmalloc(dma_buffer_size, GFP_KERNEL | GFP_DMA);
-		if (devpriv->dma_buffer == NULL) {
-			dev_err(dev->class_dev,
-				"failed to allocate dma buffer\n");
+		devpriv->dma_buffer = kmalloc(dma_buffer_size,
+					      GFP_KERNEL | GFP_DMA);
+		if (devpriv->dma_buffer == NULL)
 			return -ENOMEM;
-		}
+
 		if (request_dma(dma_chan, DRV_NAME)) {
 			dev_err(dev->class_dev,
 				"failed to allocate dma channel %u\n",
diff --git a/drivers/staging/comedi/drivers/pcmuio.c b/drivers/staging/comedi/drivers/pcmuio.c
index 71ef3f9..433270c 100644
--- a/drivers/staging/comedi/drivers/pcmuio.c
+++ b/drivers/staging/comedi/drivers/pcmuio.c
@@ -838,14 +838,11 @@ static int pcmuio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	chans_left = CHANS_PER_ASIC * board->num_asics;
 	n_subdevs = CALC_N_SUBDEVS(chans_left);
-	devpriv->sprivs =
-	    kcalloc(n_subdevs, sizeof(struct pcmuio_subdev_private),
-		    GFP_KERNEL);
-	if (!devpriv->sprivs) {
-		dev_warn(dev->class_dev,
-			 "cannot allocate subdevice private data structures\n");
+	devpriv->sprivs = kcalloc(n_subdevs,
+				  sizeof(struct pcmuio_subdev_private),
+				  GFP_KERNEL);
+	if (!devpriv->sprivs)
 		return -ENOMEM;
-	}
 
 	ret = comedi_alloc_subdevices(dev, n_subdevs);
 	if (ret)
diff --git a/drivers/staging/comedi/drivers/unioxx5.c b/drivers/staging/comedi/drivers/unioxx5.c
index c9ded93..74b974b 100644
--- a/drivers/staging/comedi/drivers/unioxx5.c
+++ b/drivers/staging/comedi/drivers/unioxx5.c
@@ -380,12 +380,8 @@ static int __unioxx5_subdev_init(struct comedi_subdevice *subdev,
 	}
 
 	usp = kzalloc(sizeof(*usp), GFP_KERNEL);
-
-	if (usp == NULL) {
-		dev_err(subdev->class_dev,
-			"comedi%d: error! --> out of memory!\n", minor);
+	if (usp == NULL)
 		return -1;
-	}
 
 	usp->usp_iobase = subdev_iobase;
 	dev_info(subdev->class_dev, "comedi%d: |", minor);
diff --git a/drivers/staging/comedi/drivers/usbdux.c b/drivers/staging/comedi/drivers/usbdux.c
index 7c2f856..1a0062a 100644
--- a/drivers/staging/comedi/drivers/usbdux.c
+++ b/drivers/staging/comedi/drivers/usbdux.c
@@ -2445,8 +2445,6 @@ static int usbdux_usb_probe(struct usb_interface *uinterf,
 	/* create space for the commands of the DA converter */
 	usbduxsub[index].dac_commands = kzalloc(NUMOUTCHANNELS, GFP_KERNEL);
 	if (!usbduxsub[index].dac_commands) {
-		dev_err(dev, "comedi_: usbdux: "
-			"error alloc space for dac commands\n");
 		tidy_up(&(usbduxsub[index]));
 		up(&start_stop_sem);
 		return -ENOMEM;
@@ -2454,8 +2452,6 @@ static int usbdux_usb_probe(struct usb_interface *uinterf,
 	/* create space for the commands going to the usb device */
 	usbduxsub[index].dux_commands = kzalloc(SIZEOFDUXBUFFER, GFP_KERNEL);
 	if (!usbduxsub[index].dux_commands) {
-		dev_err(dev, "comedi_: usbdux: "
-			"error alloc space for dux commands\n");
 		tidy_up(&(usbduxsub[index]));
 		up(&start_stop_sem);
 		return -ENOMEM;
@@ -2463,8 +2459,6 @@ static int usbdux_usb_probe(struct usb_interface *uinterf,
 	/* create space for the in buffer and set it to zero */
 	usbduxsub[index].inBuffer = kzalloc(SIZEINBUF, GFP_KERNEL);
 	if (!(usbduxsub[index].inBuffer)) {
-		dev_err(dev, "comedi_: usbdux: "
-			"could not alloc space for inBuffer\n");
 		tidy_up(&(usbduxsub[index]));
 		up(&start_stop_sem);
 		return -ENOMEM;
@@ -2472,8 +2466,6 @@ static int usbdux_usb_probe(struct usb_interface *uinterf,
 	/* create space of the instruction buffer */
 	usbduxsub[index].insnBuffer = kzalloc(SIZEINSNBUF, GFP_KERNEL);
 	if (!(usbduxsub[index].insnBuffer)) {
-		dev_err(dev, "comedi_: usbdux: "
-			"could not alloc space for insnBuffer\n");
 		tidy_up(&(usbduxsub[index]));
 		up(&start_stop_sem);
 		return -ENOMEM;
@@ -2481,8 +2473,6 @@ static int usbdux_usb_probe(struct usb_interface *uinterf,
 	/* create space for the outbuffer */
 	usbduxsub[index].outBuffer = kzalloc(SIZEOUTBUF, GFP_KERNEL);
 	if (!(usbduxsub[index].outBuffer)) {
-		dev_err(dev, "comedi_: usbdux: "
-			"could not alloc space for outBuffer\n");
 		tidy_up(&(usbduxsub[index]));
 		up(&start_stop_sem);
 		return -ENOMEM;
@@ -2504,10 +2494,9 @@ static int usbdux_usb_probe(struct usb_interface *uinterf,
 		usbduxsub[index].numOfInBuffers = NUMOFINBUFFERSFULL;
 
 	usbduxsub[index].urbIn =
-	    kzalloc(sizeof(struct urb *) * usbduxsub[index].numOfInBuffers,
-		    GFP_KERNEL);
+		kcalloc(usbduxsub[index].numOfInBuffers, sizeof(struct urb *),
+			GFP_KERNEL);
 	if (!(usbduxsub[index].urbIn)) {
-		dev_err(dev, "comedi_: usbdux: Could not alloc. urbIn array\n");
 		tidy_up(&(usbduxsub[index]));
 		up(&start_stop_sem);
 		return -ENOMEM;
@@ -2532,8 +2521,6 @@ static int usbdux_usb_probe(struct usb_interface *uinterf,
 		usbduxsub[index].urbIn[i]->transfer_buffer =
 		    kzalloc(SIZEINBUF, GFP_KERNEL);
 		if (!(usbduxsub[index].urbIn[i]->transfer_buffer)) {
-			dev_err(dev, "comedi_: usbdux%d: "
-				"could not alloc. transb.\n", index);
 			tidy_up(&(usbduxsub[index]));
 			up(&start_stop_sem);
 			return -ENOMEM;
@@ -2552,11 +2539,9 @@ static int usbdux_usb_probe(struct usb_interface *uinterf,
 		usbduxsub[index].numOfOutBuffers = NUMOFOUTBUFFERSFULL;
 
 	usbduxsub[index].urbOut =
-	    kzalloc(sizeof(struct urb *) * usbduxsub[index].numOfOutBuffers,
-		    GFP_KERNEL);
+		kcalloc(usbduxsub[index].numOfOutBuffers, sizeof(struct urb *),
+			GFP_KERNEL);
 	if (!(usbduxsub[index].urbOut)) {
-		dev_err(dev, "comedi_: usbdux: "
-			"Could not alloc. urbOut array\n");
 		tidy_up(&(usbduxsub[index]));
 		up(&start_stop_sem);
 		return -ENOMEM;
@@ -2581,8 +2566,6 @@ static int usbdux_usb_probe(struct usb_interface *uinterf,
 		usbduxsub[index].urbOut[i]->transfer_buffer =
 		    kzalloc(SIZEOUTBUF, GFP_KERNEL);
 		if (!(usbduxsub[index].urbOut[i]->transfer_buffer)) {
-			dev_err(dev, "comedi_: usbdux%d: "
-				"could not alloc. transb.\n", index);
 			tidy_up(&(usbduxsub[index]));
 			up(&start_stop_sem);
 			return -ENOMEM;
@@ -2617,8 +2600,6 @@ static int usbdux_usb_probe(struct usb_interface *uinterf,
 		usbduxsub[index].urbPwm->transfer_buffer =
 		    kzalloc(usbduxsub[index].sizePwmBuf, GFP_KERNEL);
 		if (!(usbduxsub[index].urbPwm->transfer_buffer)) {
-			dev_err(dev, "comedi_: usbdux%d: "
-				"could not alloc. transb. for pwm\n", index);
 			tidy_up(&(usbduxsub[index]));
 			up(&start_stop_sem);
 			return -ENOMEM;
diff --git a/drivers/staging/comedi/drivers/usbduxfast.c b/drivers/staging/comedi/drivers/usbduxfast.c
index 0f6187f..4bf5dd0 100644
--- a/drivers/staging/comedi/drivers/usbduxfast.c
+++ b/drivers/staging/comedi/drivers/usbduxfast.c
@@ -1556,8 +1556,6 @@ static int usbduxfast_usb_probe(struct usb_interface *uinterf,
 	usbduxfastsub[index].dux_commands = kmalloc(SIZEOFDUXBUFFER,
 						    GFP_KERNEL);
 	if (!usbduxfastsub[index].dux_commands) {
-		dev_err(&uinterf->dev,
-			"error alloc space for dac commands\n");
 		tidy_up(&(usbduxfastsub[index]));
 		up(&start_stop_sem);
 		return -ENOMEM;
@@ -1565,8 +1563,6 @@ static int usbduxfast_usb_probe(struct usb_interface *uinterf,
 	/* create space of the instruction buffer */
 	usbduxfastsub[index].insnBuffer = kmalloc(SIZEINSNBUF, GFP_KERNEL);
 	if (!usbduxfastsub[index].insnBuffer) {
-		dev_err(&uinterf->dev,
-			"could not alloc space for insnBuffer\n");
 		tidy_up(&(usbduxfastsub[index]));
 		up(&start_stop_sem);
 		return -ENOMEM;
@@ -1592,8 +1588,6 @@ static int usbduxfast_usb_probe(struct usb_interface *uinterf,
 	}
 	usbduxfastsub[index].transfer_buffer = kmalloc(SIZEINBUF, GFP_KERNEL);
 	if (!usbduxfastsub[index].transfer_buffer) {
-		dev_err(&uinterf->dev,
-			"usbduxfast%d: could not alloc. transb.\n", index);
 		tidy_up(&(usbduxfastsub[index]));
 		up(&start_stop_sem);
 		return -ENOMEM;
diff --git a/drivers/staging/comedi/drivers/usbduxsigma.c b/drivers/staging/comedi/drivers/usbduxsigma.c
index dc6b017..d066351 100644
--- a/drivers/staging/comedi/drivers/usbduxsigma.c
+++ b/drivers/staging/comedi/drivers/usbduxsigma.c
@@ -2431,8 +2431,6 @@ static int usbduxsigma_usb_probe(struct usb_interface *uinterf,
 	/* create space for the commands of the DA converter */
 	usbduxsub[index].dac_commands = kzalloc(NUMOUTCHANNELS, GFP_KERNEL);
 	if (!usbduxsub[index].dac_commands) {
-		dev_err(dev, "comedi_: usbduxsigma: "
-			"error alloc space for dac commands\n");
 		tidy_up(&(usbduxsub[index]));
 		up(&start_stop_sem);
 		return -ENOMEM;
@@ -2440,8 +2438,6 @@ static int usbduxsigma_usb_probe(struct usb_interface *uinterf,
 	/* create space for the commands going to the usb device */
 	usbduxsub[index].dux_commands = kzalloc(SIZEOFDUXBUFFER, GFP_KERNEL);
 	if (!usbduxsub[index].dux_commands) {
-		dev_err(dev, "comedi_: usbduxsigma: "
-			"error alloc space for dux commands\n");
 		tidy_up(&(usbduxsub[index]));
 		up(&start_stop_sem);
 		return -ENOMEM;
@@ -2449,8 +2445,6 @@ static int usbduxsigma_usb_probe(struct usb_interface *uinterf,
 	/* create space for the in buffer and set it to zero */
 	usbduxsub[index].inBuffer = kzalloc(SIZEINBUF, GFP_KERNEL);
 	if (!(usbduxsub[index].inBuffer)) {
-		dev_err(dev, "comedi_: usbduxsigma: "
-			"could not alloc space for inBuffer\n");
 		tidy_up(&(usbduxsub[index]));
 		up(&start_stop_sem);
 		return -ENOMEM;
@@ -2458,8 +2452,6 @@ static int usbduxsigma_usb_probe(struct usb_interface *uinterf,
 	/* create space of the instruction buffer */
 	usbduxsub[index].insnBuffer = kzalloc(SIZEINSNBUF, GFP_KERNEL);
 	if (!(usbduxsub[index].insnBuffer)) {
-		dev_err(dev, "comedi_: usbduxsigma: "
-			"could not alloc space for insnBuffer\n");
 		tidy_up(&(usbduxsub[index]));
 		up(&start_stop_sem);
 		return -ENOMEM;
@@ -2467,8 +2459,6 @@ static int usbduxsigma_usb_probe(struct usb_interface *uinterf,
 	/* create space for the outbuffer */
 	usbduxsub[index].outBuffer = kzalloc(SIZEOUTBUF, GFP_KERNEL);
 	if (!(usbduxsub[index].outBuffer)) {
-		dev_err(dev, "comedi_: usbduxsigma: "
-			"could not alloc space for outBuffer\n");
 		tidy_up(&(usbduxsub[index]));
 		up(&start_stop_sem);
 		return -ENOMEM;
@@ -2489,12 +2479,10 @@ static int usbduxsigma_usb_probe(struct usb_interface *uinterf,
 	else
 		usbduxsub[index].numOfInBuffers = NUMOFINBUFFERSFULL;
 
-	usbduxsub[index].urbIn =
-	    kzalloc(sizeof(struct urb *) * usbduxsub[index].numOfInBuffers,
-		    GFP_KERNEL);
+	usbduxsub[index].urbIn = kcalloc(usbduxsub[index].numOfInBuffers,
+					 sizeof(struct urb *),
+					 GFP_KERNEL);
 	if (!(usbduxsub[index].urbIn)) {
-		dev_err(dev, "comedi_: usbduxsigma: "
-			"Could not alloc. urbIn array\n");
 		tidy_up(&(usbduxsub[index]));
 		up(&start_stop_sem);
 		return -ENOMEM;
@@ -2519,8 +2507,6 @@ static int usbduxsigma_usb_probe(struct usb_interface *uinterf,
 		usbduxsub[index].urbIn[i]->transfer_buffer =
 		    kzalloc(SIZEINBUF, GFP_KERNEL);
 		if (!(usbduxsub[index].urbIn[i]->transfer_buffer)) {
-			dev_err(dev, "comedi_: usbduxsigma%d: "
-				"could not alloc. transb.\n", index);
 			tidy_up(&(usbduxsub[index]));
 			up(&start_stop_sem);
 			return -ENOMEM;
@@ -2539,12 +2525,9 @@ static int usbduxsigma_usb_probe(struct usb_interface *uinterf,
 	else
 		usbduxsub[index].numOfOutBuffers = NUMOFOUTBUFFERSFULL;
 
-	usbduxsub[index].urbOut =
-	    kzalloc(sizeof(struct urb *) * usbduxsub[index].numOfOutBuffers,
-		    GFP_KERNEL);
+	usbduxsub[index].urbOut = kcalloc(usbduxsub[index].numOfOutBuffers,
+					  sizeof(struct urb *), GFP_KERNEL);
 	if (!(usbduxsub[index].urbOut)) {
-		dev_err(dev, "comedi_: usbduxsigma: "
-			"Could not alloc. urbOut array\n");
 		tidy_up(&(usbduxsub[index]));
 		up(&start_stop_sem);
 		return -ENOMEM;
@@ -2569,8 +2552,6 @@ static int usbduxsigma_usb_probe(struct usb_interface *uinterf,
 		usbduxsub[index].urbOut[i]->transfer_buffer =
 		    kzalloc(SIZEOUTBUF, GFP_KERNEL);
 		if (!(usbduxsub[index].urbOut[i]->transfer_buffer)) {
-			dev_err(dev, "comedi_: usbduxsigma%d: "
-				"could not alloc. transb.\n", index);
 			tidy_up(&(usbduxsub[index]));
 			up(&start_stop_sem);
 			return -ENOMEM;
@@ -2606,8 +2587,6 @@ static int usbduxsigma_usb_probe(struct usb_interface *uinterf,
 		usbduxsub[index].urbPwm->transfer_buffer =
 		    kzalloc(usbduxsub[index].sizePwmBuf, GFP_KERNEL);
 		if (!(usbduxsub[index].urbPwm->transfer_buffer)) {
-			dev_err(dev, "comedi_: usbduxsigma%d: "
-				"could not alloc. transb. for pwm\n", index);
 			tidy_up(&(usbduxsub[index]));
 			up(&start_stop_sem);
 			return -ENOMEM;
diff --git a/drivers/staging/cptm1217/clearpad_tm1217.c b/drivers/staging/cptm1217/clearpad_tm1217.c
index a49b0da..31fb5d3 100644
--- a/drivers/staging/cptm1217/clearpad_tm1217.c
+++ b/drivers/staging/cptm1217/clearpad_tm1217.c
@@ -421,11 +421,8 @@ static int cp_tm1217_probe(struct i2c_client *client,
 	pdata = client->dev.platform_data;
 
 	ts = kzalloc(sizeof(struct cp_tm1217_device), GFP_KERNEL);
-	if (!ts) {
-		dev_err(&client->dev,
-			"cp_tm1217: Private Device Struct alloc failed\n");
+	if (!ts)
 		return -ENOMEM;
-	}
 
 	ts->client = client;
 	ts->dev = &client->dev;
diff --git a/drivers/staging/et131x/et131x.c b/drivers/staging/et131x/et131x.c
index 73dc639..3f58482 100644
--- a/drivers/staging/et131x/et131x.c
+++ b/drivers/staging/et131x/et131x.c
@@ -2462,11 +2462,8 @@ static int et131x_init_recv(struct et131x_adapter *adapter)
 	/* Setup each RFD */
 	for (rfdct = 0; rfdct < rx_ring->num_rfd; rfdct++) {
 		rfd = kzalloc(sizeof(struct rfd), GFP_ATOMIC | GFP_DMA);
-
-		if (!rfd) {
-			dev_err(&adapter->pdev->dev, "Couldn't alloc RFD\n");
+		if (!rfd)
 			return -ENOMEM;
-		}
 
 		rfd->skb = NULL;
 
@@ -2814,12 +2811,10 @@ static int et131x_tx_dma_memory_alloc(struct et131x_adapter *adapter)
 	struct tx_ring *tx_ring = &adapter->tx_ring;
 
 	/* Allocate memory for the TCB's (Transmit Control Block) */
-	adapter->tx_ring.tcb_ring =
-		kcalloc(NUM_TCB, sizeof(struct tcb), GFP_ATOMIC | GFP_DMA);
-	if (!adapter->tx_ring.tcb_ring) {
-		dev_err(&adapter->pdev->dev, "Cannot alloc memory for TCBs\n");
+	adapter->tx_ring.tcb_ring = kcalloc(NUM_TCB, sizeof(struct tcb),
+					    GFP_ATOMIC | GFP_DMA);
+	if (!adapter->tx_ring.tcb_ring)
 		return -ENOMEM;
-	}
 
 	desc_size = (sizeof(struct tx_desc) * NUM_DESC_PER_RING_TX);
 	tx_ring->tx_desc_ring =
@@ -4895,11 +4890,10 @@ static int et131x_pci_setup(struct pci_dev *pdev,
 	adapter->mii_bus->read = et131x_mdio_read;
 	adapter->mii_bus->write = et131x_mdio_write;
 	adapter->mii_bus->reset = et131x_mdio_reset;
-	adapter->mii_bus->irq = kmalloc(sizeof(int)*PHY_MAX_ADDR, GFP_KERNEL);
-	if (!adapter->mii_bus->irq) {
-		dev_err(&pdev->dev, "mii_bus irq allocation failed\n");
+	adapter->mii_bus->irq = kmalloc_array(PHY_MAX_ADDR, sizeof(int),
+					      GFP_KERNEL);
+	if (!adapter->mii_bus->irq)
 		goto err_mdio_free;
-	}
 
 	for (ii = 0; ii < PHY_MAX_ADDR; ii++)
 		adapter->mii_bus->irq[ii] = PHY_POLL;
diff --git a/drivers/staging/frontier/alphatrack.c b/drivers/staging/frontier/alphatrack.c
index 33085782..ea9362d 100644
--- a/drivers/staging/frontier/alphatrack.c
+++ b/drivers/staging/frontier/alphatrack.c
@@ -678,10 +678,9 @@ static int usb_alphatrack_probe(struct usb_interface *intf,
 	/* allocate memory for our device state and initialize it */
 
 	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
-	if (dev == NULL) {
-		dev_err(&intf->dev, "Out of memory\n");
+	if (dev == NULL)
 		goto exit;
-	}
+
 	mutex_init(&dev->mtx);
 	dev->intf = intf;
 	init_waitqueue_head(&dev->read_wait);
@@ -721,28 +720,21 @@ static int usb_alphatrack_probe(struct usb_interface *intf,
 
 	/* FIXME - there are more usb_alloc routines for dma correctness.
 	   Needed? */
-	dev->ring_buffer =
-	    kmalloc((true_size * sizeof(struct alphatrack_icmd)), GFP_KERNEL);
-
-	if (!dev->ring_buffer) {
-		dev_err(&intf->dev,
-			"Couldn't allocate input ring_buffer of size %d\n",
-			true_size);
+	dev->ring_buffer = kmalloc_array(true_size,
+					 sizeof(struct alphatrack_icmd),
+					 GFP_KERNEL);
+	if (!dev->ring_buffer)
 		goto error;
-	}
 
-	dev->interrupt_in_buffer =
-	    kmalloc(dev->interrupt_in_endpoint_size, GFP_KERNEL);
-
-	if (!dev->interrupt_in_buffer) {
-		dev_err(&intf->dev, "Couldn't allocate interrupt_in_buffer\n");
+	dev->interrupt_in_buffer = kmalloc(dev->interrupt_in_endpoint_size,
+					   GFP_KERNEL);
+	if (!dev->interrupt_in_buffer)
 		goto error;
-	}
+
 	dev->oldi_buffer = kmalloc(dev->interrupt_in_endpoint_size, GFP_KERNEL);
-	if (!dev->oldi_buffer) {
-		dev_err(&intf->dev, "Couldn't allocate old buffer\n");
+	if (!dev->oldi_buffer)
 		goto error;
-	}
+
 	dev->interrupt_in_urb = usb_alloc_urb(0, GFP_KERNEL);
 	if (!dev->interrupt_in_urb) {
 		dev_err(&intf->dev, "Couldn't allocate interrupt_in_urb\n");
@@ -764,20 +756,17 @@ static int usb_alphatrack_probe(struct usb_interface *intf,
 	true_size = min(write_buffer_size, WRITE_BUFFER_SIZE);
 
 	dev->interrupt_out_buffer =
-	    kmalloc(true_size * dev->interrupt_out_endpoint_size, GFP_KERNEL);
-
-	if (!dev->interrupt_out_buffer) {
-		dev_err(&intf->dev, "Couldn't allocate interrupt_out_buffer\n");
+		kmalloc_array(true_size,
+			      dev->interrupt_out_endpoint_size,
+			      GFP_KERNEL);
+	if (!dev->interrupt_out_buffer)
 		goto error;
-	}
-
-	dev->write_buffer =
-	    kmalloc(true_size * sizeof(struct alphatrack_ocmd), GFP_KERNEL);
 
-	if (!dev->write_buffer) {
-		dev_err(&intf->dev, "Couldn't allocate write_buffer\n");
+	dev->write_buffer = kmalloc_array(true_size,
+					  sizeof(struct alphatrack_ocmd),
+					  GFP_KERNEL);
+	if (!dev->write_buffer)
 		goto error;
-	}
 
 	dev->interrupt_out_urb = usb_alloc_urb(0, GFP_KERNEL);
 	if (!dev->interrupt_out_urb) {
diff --git a/drivers/staging/frontier/tranzport.c b/drivers/staging/frontier/tranzport.c
index 5196a4e..04b5e66 100644
--- a/drivers/staging/frontier/tranzport.c
+++ b/drivers/staging/frontier/tranzport.c
@@ -803,10 +803,9 @@ static int usb_tranzport_probe(struct usb_interface *intf,
 	/* allocate memory for our device state and initialize it */
 
 	 dev = kzalloc(sizeof(*dev), GFP_KERNEL);
-	if (dev == NULL) {
-		dev_err(&intf->dev, "Out of memory\n");
+	if (dev == NULL)
 		goto exit;
-	}
+
 	mutex_init(&dev->mtx);
 	dev->intf = intf;
 	init_waitqueue_head(&dev->read_wait);
@@ -848,18 +847,14 @@ static int usb_tranzport_probe(struct usb_interface *intf,
 
 	dev->ring_buffer =
 	    kmalloc((true_size * sizeof(struct tranzport_cmd)) + 8, GFP_KERNEL);
-
-	if (!dev->ring_buffer) {
-		dev_err(&intf->dev,
-			"Couldn't allocate ring_buffer size %d\n", true_size);
+	if (!dev->ring_buffer)
 		goto error;
-	}
+
 	dev->interrupt_in_buffer =
 	    kmalloc(dev->interrupt_in_endpoint_size, GFP_KERNEL);
-	if (!dev->interrupt_in_buffer) {
-		dev_err(&intf->dev, "Couldn't allocate interrupt_in_buffer\n");
+	if (!dev->interrupt_in_buffer)
 		goto error;
-	}
+
 	dev->interrupt_in_urb = usb_alloc_urb(0, GFP_KERNEL);
 	if (!dev->interrupt_in_urb) {
 		dev_err(&intf->dev, "Couldn't allocate interrupt_in_urb\n");
@@ -875,12 +870,11 @@ static int usb_tranzport_probe(struct usb_interface *intf,
 			 "Interrupt out endpoint size is not 8!)\n");
 
 	dev->interrupt_out_buffer =
-	    kmalloc(write_buffer_size * dev->interrupt_out_endpoint_size,
-		    GFP_KERNEL);
-	if (!dev->interrupt_out_buffer) {
-		dev_err(&intf->dev, "Couldn't allocate interrupt_out_buffer\n");
+		kmalloc_array(write_buffer_size,
+			      dev->interrupt_out_endpoint_size, GFP_KERNEL);
+	if (!dev->interrupt_out_buffer)
 		goto error;
-	}
+
 	dev->interrupt_out_urb = usb_alloc_urb(0, GFP_KERNEL);
 	if (!dev->interrupt_out_urb) {
 		dev_err(&intf->dev, "Couldn't allocate interrupt_out_urb\n");
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
index 1bf3792..614db55 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
@@ -68,11 +68,8 @@ static int ft1000_probe(struct usb_interface *interface,
 	const struct firmware *dsp_fw;
 
 	ft1000dev = kzalloc(sizeof(struct ft1000_usb), GFP_KERNEL);
-
-	if (!ft1000dev) {
-		pr_err("out of memory allocating device structure\n");
+	if (!ft1000dev)
 		return -ENOMEM;
-	}
 
 	dev = interface_to_usbdev(interface);
 	DEBUG("ft1000_probe: usb device descriptor info:\n");
diff --git a/drivers/staging/gdm72xx/gdm_sdio.c b/drivers/staging/gdm72xx/gdm_sdio.c
index 8b8ed98..695762b 100644
--- a/drivers/staging/gdm72xx/gdm_sdio.c
+++ b/drivers/staging/gdm72xx/gdm_sdio.c
@@ -156,10 +156,8 @@ static int init_sdio(struct sdiowm_dev *sdev)
 	spin_lock_init(&tx->lock);
 
 	tx->sdu_buf = kmalloc(SDU_TX_BUF_SIZE, GFP_KERNEL);
-	if (tx->sdu_buf == NULL) {
-		dev_err(&sdev->func->dev, "Failed to allocate SDU tx buffer.\n");
+	if (tx->sdu_buf == NULL)
 		goto fail;
-	}
 
 	for (i = 0; i < MAX_NR_SDU_BUF; i++) {
 		t = alloc_tx_struct(tx);
@@ -185,10 +183,8 @@ static int init_sdio(struct sdiowm_dev *sdev)
 	}
 
 	rx->rx_buf = kmalloc(RX_BUF_SIZE, GFP_KERNEL);
-	if (rx->rx_buf == NULL) {
-		dev_err(&sdev->func->dev, "Failed to allocate rx buffer.\n");
+	if (rx->rx_buf == NULL)
 		goto fail;
-	}
 
 	return 0;
 
diff --git a/drivers/staging/gdm72xx/sdio_boot.c b/drivers/staging/gdm72xx/sdio_boot.c
index 6291829..93046dd 100644
--- a/drivers/staging/gdm72xx/sdio_boot.c
+++ b/drivers/staging/gdm72xx/sdio_boot.c
@@ -72,10 +72,8 @@ static int download_image(struct sdio_func *func, const char *img_name)
 	}
 
 	buf = kmalloc(DOWNLOAD_SIZE + TYPE_A_HEADER_SIZE, GFP_KERNEL);
-	if (buf == NULL) {
-		dev_err(&func->dev, "Error: kmalloc\n");
+	if (buf == NULL)
 		return -ENOMEM;
-	}
 
 	img_len = firm->size;
 
@@ -141,11 +139,8 @@ int sdio_boot(struct sdio_func *func)
 	const char *rfs_name = FW_DIR FW_RFS;
 
 	tx_buf = kmalloc(YMEM0_SIZE, GFP_KERNEL);
-	if (tx_buf == NULL) {
-		dev_err(&func->dev, "Error: kmalloc: %s %d\n",
-			__func__, __LINE__);
+	if (tx_buf == NULL)
 		return -ENOMEM;
-	}
 
 	ret = download_image(func, krn_name);
 	if (ret)
diff --git a/drivers/staging/gdm72xx/usb_boot.c b/drivers/staging/gdm72xx/usb_boot.c
index 3e2103a..0d45eb6 100644
--- a/drivers/staging/gdm72xx/usb_boot.c
+++ b/drivers/staging/gdm72xx/usb_boot.c
@@ -158,10 +158,8 @@ int usb_boot(struct usb_device *usbdev, u16 pid)
 	}
 
 	tx_buf = kmalloc(DOWNLOAD_SIZE, GFP_KERNEL);
-	if (tx_buf == NULL) {
-		dev_err(&usbdev->dev, "Error: kmalloc\n");
+	if (tx_buf == NULL)
 		return -ENOMEM;
-	}
 
 	if (firm->size < sizeof(hdr)) {
 		dev_err(&usbdev->dev, "Cannot read the image info.\n");
@@ -301,10 +299,8 @@ static int em_download_image(struct usb_device *usbdev, const char *img_name,
 	}
 
 	buf = kmalloc(DOWNLOAD_CHUCK + pad_size, GFP_KERNEL);
-	if (buf == NULL) {
-		dev_err(&usbdev->dev, "Error: kmalloc\n");
+	if (buf == NULL)
 		return -ENOMEM;
-	}
 
 	strcpy(buf+pad_size, type_string);
 	ret = gdm_wibro_send(usbdev, buf, strlen(type_string)+pad_size);
diff --git a/drivers/staging/iio/accel/lis3l02dq_ring.c b/drivers/staging/iio/accel/lis3l02dq_ring.c
index 6861877..e676403 100644
--- a/drivers/staging/iio/accel/lis3l02dq_ring.c
+++ b/drivers/staging/iio/accel/lis3l02dq_ring.c
@@ -140,11 +140,8 @@ static irqreturn_t lis3l02dq_trigger_handler(int irq, void *p)
 	char *data;
 
 	data = kmalloc(indio_dev->scan_bytes, GFP_KERNEL);
-	if (data == NULL) {
-		dev_err(indio_dev->dev.parent,
-			"memory alloc failed in buffer bh");
+	if (data == NULL)
 		goto done;
-	}
 
 	if (!bitmap_empty(indio_dev->active_scan_mask, indio_dev->masklength))
 		len = lis3l02dq_get_buffer_element(indio_dev, data);
diff --git a/drivers/staging/keucr/usb.c b/drivers/staging/keucr/usb.c
index 4dec93d..f656f8a 100644
--- a/drivers/staging/keucr/usb.c
+++ b/drivers/staging/keucr/usb.c
@@ -266,10 +266,9 @@ static int associate_dev(struct us_data *us, struct usb_interface *intf)
 	}
 
 	us->sensebuf = kmalloc(US_SENSE_SIZE, GFP_KERNEL);
-	if (!us->sensebuf) {
-		pr_info("Sense buffer allocation failed\n");
+	if (!us->sensebuf)
 		return -ENOMEM;
-	}
+
 	return 0;
 }
 
diff --git a/drivers/staging/line6/driver.c b/drivers/staging/line6/driver.c
index 9f9a21a..6252aca 100644
--- a/drivers/staging/line6/driver.c
+++ b/drivers/staging/line6/driver.c
@@ -233,11 +233,8 @@ int line6_send_raw_message_async(struct usb_line6 *line6, const char *buffer,
 
 	/* create message: */
 	msg = kmalloc(sizeof(struct message), GFP_ATOMIC);
-
-	if (msg == NULL) {
-		dev_err(line6->ifcdev, "Out of memory\n");
+	if (msg == NULL)
 		return -ENOMEM;
-	}
 
 	/* create URB: */
 	urb = usb_alloc_urb(0, GFP_ATOMIC);
@@ -300,10 +297,8 @@ char *line6_alloc_sysex_buffer(struct usb_line6 *line6, int code1, int code2,
 {
 	char *buffer = kmalloc(size + SYSEX_EXTRA_SIZE, GFP_ATOMIC);
 
-	if (!buffer) {
-		dev_err(line6->ifcdev, "out of memory\n");
+	if (!buffer)
 		return NULL;
-	}
 
 	buffer[0] = LINE6_SYSEX_BEGIN;
 	memcpy(buffer + 1, line6_midi_id, sizeof(line6_midi_id));
@@ -403,11 +398,8 @@ int line6_send_program(struct usb_line6 *line6, u8 value)
 	int partial;
 
 	buffer = kmalloc(2, GFP_KERNEL);
-
-	if (!buffer) {
-		dev_err(line6->ifcdev, "out of memory\n");
+	if (!buffer)
 		return -ENOMEM;
-	}
 
 	buffer[0] = LINE6_PROGRAM_CHANGE | LINE6_CHANNEL_HOST;
 	buffer[1] = value;
@@ -435,11 +427,8 @@ int line6_transmit_parameter(struct usb_line6 *line6, int param, u8 value)
 	int partial;
 
 	buffer = kmalloc(3, GFP_KERNEL);
-
-	if (!buffer) {
-		dev_err(line6->ifcdev, "out of memory\n");
+	if (!buffer)
 		return -ENOMEM;
-	}
 
 	buffer[0] = LINE6_PARAM_CHANGE | LINE6_CHANNEL_HOST;
 	buffer[1] = param;
@@ -834,9 +823,7 @@ static int line6_probe(struct usb_interface *interface,
 	}
 
 	line6 = kzalloc(size, GFP_KERNEL);
-
 	if (line6 == NULL) {
-		dev_err(&interface->dev, "Out of memory\n");
 		ret = -ENODEV;
 		goto err_put;
 	}
@@ -875,18 +862,14 @@ static int line6_probe(struct usb_interface *interface,
 		/* initialize USB buffers: */
 		line6->buffer_listen =
 		    kmalloc(LINE6_BUFSIZE_LISTEN, GFP_KERNEL);
-
 		if (line6->buffer_listen == NULL) {
-			dev_err(&interface->dev, "Out of memory\n");
 			ret = -ENOMEM;
 			goto err_destruct;
 		}
 
 		line6->buffer_message =
 		    kmalloc(LINE6_MESSAGE_MAXLEN, GFP_KERNEL);
-
 		if (line6->buffer_message == NULL) {
-			dev_err(&interface->dev, "Out of memory\n");
 			ret = -ENOMEM;
 			goto err_destruct;
 		}
diff --git a/drivers/staging/line6/pcm.c b/drivers/staging/line6/pcm.c
index 17969c6..02f77d7 100644
--- a/drivers/staging/line6/pcm.c
+++ b/drivers/staging/line6/pcm.c
@@ -121,10 +121,7 @@ int line6_pcm_acquire(struct snd_line6_pcm *line6pcm, int channels)
 			line6pcm->buffer_in =
 				kmalloc(LINE6_ISO_BUFFERS * LINE6_ISO_PACKETS *
 					line6pcm->max_packet_size, GFP_KERNEL);
-
 			if (!line6pcm->buffer_in) {
-				dev_err(line6pcm->line6->ifcdev,
-					"cannot malloc capture buffer\n");
 				err = -ENOMEM;
 				goto pcm_acquire_error;
 			}
@@ -160,10 +157,7 @@ int line6_pcm_acquire(struct snd_line6_pcm *line6pcm, int channels)
 			line6pcm->buffer_out =
 				kmalloc(LINE6_ISO_BUFFERS * LINE6_ISO_PACKETS *
 					line6pcm->max_packet_size, GFP_KERNEL);
-
 			if (!line6pcm->buffer_out) {
-				dev_err(line6pcm->line6->ifcdev,
-					"cannot malloc playback buffer\n");
 				err = -ENOMEM;
 				goto pcm_acquire_error;
 			}
diff --git a/drivers/staging/media/as102/as102_usb_drv.c b/drivers/staging/media/as102/as102_usb_drv.c
index aaf1bc2..9f275f0 100644
--- a/drivers/staging/media/as102/as102_usb_drv.c
+++ b/drivers/staging/media/as102/as102_usb_drv.c
@@ -374,10 +374,8 @@ static int as102_usb_probe(struct usb_interface *intf,
 	}
 
 	as102_dev = kzalloc(sizeof(struct as102_dev_t), GFP_KERNEL);
-	if (as102_dev == NULL) {
-		dev_err(&intf->dev, "%s: kzalloc failed\n", __func__);
+	if (as102_dev == NULL)
 		return -ENOMEM;
-	}
 
 	/* Assign the user-friendly device name */
 	for (i = 0; i < ARRAY_SIZE(as102_usb_id_table); i++) {
diff --git a/drivers/staging/media/go7007/go7007-fw.c b/drivers/staging/media/go7007/go7007-fw.c
index f99c05b..a5ede1c 100644
--- a/drivers/staging/media/go7007/go7007-fw.c
+++ b/drivers/staging/media/go7007/go7007-fw.c
@@ -381,11 +381,8 @@ static int gen_mjpeghdr_to_package(struct go7007 *go, __le16 *code, int space)
 	int size = 0, i, off = 0, chunk;
 
 	buf = kzalloc(4096, GFP_KERNEL);
-	if (buf == NULL) {
-		dev_err(go->dev,
-			"unable to allocate 4096 bytes for firmware construction\n");
+	if (buf == NULL)
 		return -1;
-	}
 
 	for (i = 1; i < 32; ++i) {
 		mjpeg_frame_header(go, buf + size, i);
@@ -651,11 +648,9 @@ static int gen_mpeg1hdr_to_package(struct go7007 *go,
 	int i, off = 0, chunk;
 
 	buf = kzalloc(5120, GFP_KERNEL);
-	if (buf == NULL) {
-		dev_err(go->dev,
-			"unable to allocate 5120 bytes for firmware construction\n");
+	if (buf == NULL)
 		return -1;
-	}
+
 	framelen[0] = mpeg1_frame_header(go, buf, 0, 1, PFRAME);
 	if (go->interlace_coding)
 		framelen[0] += mpeg1_frame_header(go, buf + framelen[0] / 8,
@@ -838,11 +833,9 @@ static int gen_mpeg4hdr_to_package(struct go7007 *go,
 	int i, off = 0, chunk;
 
 	buf = kzalloc(5120, GFP_KERNEL);
-	if (buf == NULL) {
-		dev_err(go->dev,
-			"unable to allocate 5120 bytes for firmware construction\n");
+	if (buf == NULL)
 		return -1;
-	}
+
 	framelen[0] = mpeg4_frame_header(go, buf, 0, PFRAME);
 	i = 368;
 	framelen[1] = mpeg4_frame_header(go, buf + i, 0, BFRAME_PRE);
@@ -1582,12 +1575,9 @@ int go7007_construct_fw_image(struct go7007 *go, u8 **fw, int *fwlen)
 		return -1;
 	}
 	code = kzalloc(codespace * 2, GFP_KERNEL);
-	if (code == NULL) {
-		dev_err(go->dev,
-			"unable to allocate %d bytes for firmware construction\n",
-			codespace * 2);
+	if (code == NULL)
 		goto fw_failed;
-	}
+
 	src = (__le16 *)fw_entry->data;
 	srclen = fw_entry->size / 2;
 	while (srclen >= 2) {
diff --git a/drivers/staging/media/go7007/s2250-loader.c b/drivers/staging/media/go7007/s2250-loader.c
index f57eb3b..72e5175 100644
--- a/drivers/staging/media/go7007/s2250-loader.c
+++ b/drivers/staging/media/go7007/s2250-loader.c
@@ -81,10 +81,9 @@ static int s2250loader_probe(struct usb_interface *interface,
 
 	/* Allocate dev data structure */
 	s = kmalloc(sizeof(device_extension_t), GFP_KERNEL);
-	if (s == NULL) {
-		dev_err(&interface->dev, "Out of memory\n");
+	if (s == NULL)
 		goto failed;
-	}
+
 	s2250_dev_table[minor] = s;
 
 	dev_info(&interface->dev,
diff --git a/drivers/staging/media/lirc/lirc_imon.c b/drivers/staging/media/lirc/lirc_imon.c
index 343c622..0a2c45d 100644
--- a/drivers/staging/media/lirc/lirc_imon.c
+++ b/drivers/staging/media/lirc/lirc_imon.c
@@ -744,7 +744,6 @@ static int imon_probe(struct usb_interface *interface,
 
 	context = kzalloc(sizeof(struct imon_context), GFP_KERNEL);
 	if (!context) {
-		dev_err(dev, "%s: kzalloc failed for context\n", __func__);
 		alloc_status = 1;
 		goto alloc_status_switch;
 	}
@@ -826,13 +825,11 @@ static int imon_probe(struct usb_interface *interface,
 
 	driver = kzalloc(sizeof(struct lirc_driver), GFP_KERNEL);
 	if (!driver) {
-		dev_err(dev, "%s: kzalloc failed for lirc_driver\n", __func__);
 		alloc_status = 2;
 		goto alloc_status_switch;
 	}
 	rbuf = kmalloc(sizeof(struct lirc_buffer), GFP_KERNEL);
 	if (!rbuf) {
-		dev_err(dev, "%s: kmalloc failed for lirc_buffer\n", __func__);
 		alloc_status = 3;
 		goto alloc_status_switch;
 	}
diff --git a/drivers/staging/media/lirc/lirc_sasem.c b/drivers/staging/media/lirc/lirc_sasem.c
index b3fe21e..68acca7 100644
--- a/drivers/staging/media/lirc/lirc_sasem.c
+++ b/drivers/staging/media/lirc/lirc_sasem.c
@@ -759,22 +759,16 @@ static int sasem_probe(struct usb_interface *interface,
 
 	context = kzalloc(sizeof(struct sasem_context), GFP_KERNEL);
 	if (!context) {
-		dev_err(&interface->dev,
-			"%s: kzalloc failed for context\n", __func__);
 		alloc_status = 1;
 		goto alloc_status_switch;
 	}
 	driver = kzalloc(sizeof(struct lirc_driver), GFP_KERNEL);
 	if (!driver) {
-		dev_err(&interface->dev,
-			"%s: kzalloc failed for lirc_driver\n", __func__);
 		alloc_status = 2;
 		goto alloc_status_switch;
 	}
 	rbuf = kmalloc(sizeof(struct lirc_buffer), GFP_KERNEL);
 	if (!rbuf) {
-		dev_err(&interface->dev,
-			"%s: kmalloc failed for lirc_buffer\n", __func__);
 		alloc_status = 3;
 		goto alloc_status_switch;
 	}
diff --git a/drivers/staging/omapdrm/omap_connector.c b/drivers/staging/omapdrm/omap_connector.c
index 4cc9ee7..8979c80 100644
--- a/drivers/staging/omapdrm/omap_connector.c
+++ b/drivers/staging/omapdrm/omap_connector.c
@@ -261,10 +261,8 @@ struct drm_connector *omap_connector_init(struct drm_device *dev,
 	omap_dss_get_device(dssdev);
 
 	omap_connector = kzalloc(sizeof(struct omap_connector), GFP_KERNEL);
-	if (!omap_connector) {
-		dev_err(dev->dev, "could not allocate connector\n");
+	if (!omap_connector)
 		goto fail;
-	}
 
 	omap_connector->dssdev = dssdev;
 	omap_connector->encoder = encoder;
diff --git a/drivers/staging/omapdrm/omap_crtc.c b/drivers/staging/omapdrm/omap_crtc.c
index 510942e..18a6c1a 100644
--- a/drivers/staging/omapdrm/omap_crtc.c
+++ b/drivers/staging/omapdrm/omap_crtc.c
@@ -601,11 +601,8 @@ struct drm_crtc *omap_crtc_init(struct drm_device *dev,
 	DBG("%s", channel_names[channel]);
 
 	omap_crtc = kzalloc(sizeof(*omap_crtc), GFP_KERNEL);
-
-	if (!omap_crtc) {
-		dev_err(dev->dev, "could not allocate CRTC\n");
+	if (!omap_crtc)
 		goto fail;
-	}
 
 	crtc = &omap_crtc->base;
 
diff --git a/drivers/staging/omapdrm/omap_dmm_tiler.c b/drivers/staging/omapdrm/omap_dmm_tiler.c
index 3910215..9b794c9 100644
--- a/drivers/staging/omapdrm/omap_dmm_tiler.c
+++ b/drivers/staging/omapdrm/omap_dmm_tiler.c
@@ -581,10 +581,8 @@ static int omap_dmm_probe(struct platform_device *dev)
 	struct resource *mem;
 
 	omap_dmm = kzalloc(sizeof(*omap_dmm), GFP_KERNEL);
-	if (!omap_dmm) {
-		dev_err(&dev->dev, "failed to allocate driver data section\n");
+	if (!omap_dmm)
 		goto fail;
-	}
 
 	/* initialize lists */
 	INIT_LIST_HEAD(&omap_dmm->alloc_head);
@@ -681,11 +679,9 @@ static int omap_dmm_probe(struct platform_device *dev)
 	}
 
 	/* alloc engines */
-	omap_dmm->engines = kzalloc(
-			omap_dmm->num_engines * sizeof(struct refill_engine),
-			GFP_KERNEL);
+	omap_dmm->engines = kcalloc(omap_dmm->num_engines,
+				    sizeof(struct refill_engine), GFP_KERNEL);
 	if (!omap_dmm->engines) {
-		dev_err(&dev->dev, "could not allocate engines\n");
 		ret = -ENOMEM;
 		goto fail;
 	}
@@ -702,10 +698,9 @@ static int omap_dmm_probe(struct platform_device *dev)
 		list_add(&omap_dmm->engines[i].idle_node, &omap_dmm->idle_head);
 	}
 
-	omap_dmm->tcm = kzalloc(omap_dmm->num_lut * sizeof(*omap_dmm->tcm),
+	omap_dmm->tcm = kcalloc(omap_dmm->num_lut, sizeof(*omap_dmm->tcm),
 				GFP_KERNEL);
 	if (!omap_dmm->tcm) {
-		dev_err(&dev->dev, "failed to allocate lut ptrs\n");
 		ret = -ENOMEM;
 		goto fail;
 	}
diff --git a/drivers/staging/omapdrm/omap_drv.c b/drivers/staging/omapdrm/omap_drv.c
index 9d6a584..706644d 100644
--- a/drivers/staging/omapdrm/omap_drv.c
+++ b/drivers/staging/omapdrm/omap_drv.c
@@ -335,10 +335,8 @@ static int dev_load(struct drm_device *dev, unsigned long flags)
 	DBG("load: dev=%p", dev);
 
 	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
-	if (!priv) {
-		dev_err(dev->dev, "could not allocate priv\n");
+	if (!priv)
 		return -ENOMEM;
-	}
 
 	priv->omaprev = pdata->omaprev;
 
diff --git a/drivers/staging/omapdrm/omap_encoder.c b/drivers/staging/omapdrm/omap_encoder.c
index e053160..25fc0c7 100644
--- a/drivers/staging/omapdrm/omap_encoder.c
+++ b/drivers/staging/omapdrm/omap_encoder.c
@@ -147,10 +147,8 @@ struct drm_encoder *omap_encoder_init(struct drm_device *dev,
 	struct omap_encoder *omap_encoder;
 
 	omap_encoder = kzalloc(sizeof(*omap_encoder), GFP_KERNEL);
-	if (!omap_encoder) {
-		dev_err(dev->dev, "could not allocate encoder\n");
+	if (!omap_encoder)
 		goto fail;
-	}
 
 	omap_encoder->dssdev = dssdev;
 
diff --git a/drivers/staging/omapdrm/omap_fb.c b/drivers/staging/omapdrm/omap_fb.c
index bf6421f..1a1bdd6 100644
--- a/drivers/staging/omapdrm/omap_fb.c
+++ b/drivers/staging/omapdrm/omap_fb.c
@@ -418,7 +418,6 @@ struct drm_framebuffer *omap_framebuffer_init(struct drm_device *dev,
 
 	omap_fb = kzalloc(sizeof(*omap_fb), GFP_KERNEL);
 	if (!omap_fb) {
-		dev_err(dev->dev, "could not allocate fb\n");
 		ret = -ENOMEM;
 		goto fail;
 	}
diff --git a/drivers/staging/omapdrm/omap_fbdev.c b/drivers/staging/omapdrm/omap_fbdev.c
index 2728e37..50ac4af 100644
--- a/drivers/staging/omapdrm/omap_fbdev.c
+++ b/drivers/staging/omapdrm/omap_fbdev.c
@@ -350,10 +350,8 @@ struct drm_fb_helper *omap_fbdev_init(struct drm_device *dev)
 	int ret = 0;
 
 	fbdev = kzalloc(sizeof(*fbdev), GFP_KERNEL);
-	if (!fbdev) {
-		dev_err(dev->dev, "could not allocate fbdev\n");
+	if (!fbdev)
 		goto fail;
-	}
 
 	INIT_WORK(&fbdev->work, pan_worker);
 
diff --git a/drivers/staging/omapdrm/omap_gem.c b/drivers/staging/omapdrm/omap_gem.c
index f9297eb..518d03d 100644
--- a/drivers/staging/omapdrm/omap_gem.c
+++ b/drivers/staging/omapdrm/omap_gem.c
@@ -1402,10 +1402,8 @@ struct drm_gem_object *omap_gem_new(struct drm_device *dev,
 	}
 
 	omap_obj = kzalloc(sizeof(*omap_obj), GFP_KERNEL);
-	if (!omap_obj) {
-		dev_err(dev->dev, "could not allocate GEM object\n");
+	if (!omap_obj)
 		goto fail;
-	}
 
 	list_add(&omap_obj->mm_list, &priv->obj_list);
 
@@ -1461,11 +1459,9 @@ void omap_gem_init(struct drm_device *dev)
 		return;
 	}
 
-	usergart = kzalloc(3 * sizeof(*usergart), GFP_KERNEL);
-	if (!usergart) {
-		dev_warn(dev->dev, "could not allocate usergart\n");
+	usergart = kcalloc(3, sizeof(*usergart), GFP_KERNEL);
+	if (!usergart)
 		return;
-	}
 
 	/* reserve 4k aligned/wide regions for userspace mappings: */
 	for (i = 0; i < ARRAY_SIZE(fmts); i++) {
diff --git a/drivers/staging/omapdrm/omap_plane.c b/drivers/staging/omapdrm/omap_plane.c
index bb989d7..c063476 100644
--- a/drivers/staging/omapdrm/omap_plane.c
+++ b/drivers/staging/omapdrm/omap_plane.c
@@ -390,10 +390,8 @@ struct drm_plane *omap_plane_init(struct drm_device *dev,
 	DBG("%s: priv=%d", plane_names[id], private_plane);
 
 	omap_plane = kzalloc(sizeof(*omap_plane), GFP_KERNEL);
-	if (!omap_plane) {
-		dev_err(dev->dev, "could not allocate plane\n");
+	if (!omap_plane)
 		goto fail;
-	}
 
 	ret = kfifo_alloc(&omap_plane->unpin_fifo, 16, GFP_KERNEL);
 	if (ret) {
diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211_module.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_module.c
index 4358c4b..07a1fbb 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_module.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_module.c
@@ -68,10 +68,8 @@ static inline int ieee80211_networks_allocate(struct ieee80211_device *ieee)
 	ieee->networks = kcalloc(
 		MAX_NETWORK_COUNT, sizeof(struct ieee80211_network),
 		GFP_KERNEL);
-	if (!ieee->networks) {
-		netdev_warn(ieee->dev,  "Out of memory allocating beacons\n");
+	if (!ieee->networks)
 		return -ENOMEM;
-	}
 
 	return 0;
 }
diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c
index 446f15e..e303159 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c
@@ -408,11 +408,9 @@ static int is_duplicate_packet(struct ieee80211_device *ieee,
 	//	if (memcmp(entry->mac, mac, ETH_ALEN)){
 		if (p == &ieee->ibss_mac_hash[index]) {
 			entry = kmalloc(sizeof(struct ieee_ibss_seq), GFP_ATOMIC);
-			if (!entry) {
-				netdev_warn(ieee->dev,
-					    "Cannot malloc new mac entry\n");
+			if (!entry)
 				return 0;
-			}
+
 			memcpy(entry->mac, mac, ETH_ALEN);
 			entry->seq_num[tid] = seq;
 			entry->frag_num[tid] = frag;
diff --git a/drivers/staging/sbe-2t3e3/dc.c b/drivers/staging/sbe-2t3e3/dc.c
index daadd6e..f207b9e 100644
--- a/drivers/staging/sbe-2t3e3/dc.c
+++ b/drivers/staging/sbe-2t3e3/dc.c
@@ -315,20 +315,17 @@ static int dc_init_descriptor_list(struct channel *sc)
 	struct sk_buff *m;
 
 	if (sc->ether.rx_ring == NULL)
-		sc->ether.rx_ring = kzalloc(SBE_2T3E3_RX_DESC_RING_SIZE *
+		sc->ether.rx_ring = kcalloc(SBE_2T3E3_RX_DESC_RING_SIZE,
 					    sizeof(t3e3_rx_desc_t), GFP_KERNEL);
-	if (sc->ether.rx_ring == NULL) {
-		dev_err(&sc->pdev->dev, "SBE 2T3E3: no buffer space for RX ring\n");
+	if (sc->ether.rx_ring == NULL)
 		return -ENOMEM;
-	}
 
 	if (sc->ether.tx_ring == NULL)
-		sc->ether.tx_ring = kzalloc(SBE_2T3E3_TX_DESC_RING_SIZE *
+		sc->ether.tx_ring = kcalloc(SBE_2T3E3_TX_DESC_RING_SIZE,
 					    sizeof(t3e3_tx_desc_t), GFP_KERNEL);
 	if (sc->ether.tx_ring == NULL) {
 		kfree(sc->ether.rx_ring);
 		sc->ether.rx_ring = NULL;
-		dev_err(&sc->pdev->dev, "SBE 2T3E3: no buffer space for RX ring\n");
 		return -ENOMEM;
 	}
 
diff --git a/drivers/staging/sbe-2t3e3/module.c b/drivers/staging/sbe-2t3e3/module.c
index ae7af39..0e32be5 100644
--- a/drivers/staging/sbe-2t3e3/module.c
+++ b/drivers/staging/sbe-2t3e3/module.c
@@ -154,11 +154,10 @@ static int t3e3_init_card(struct pci_dev *pdev, const struct pci_device_id *ent)
 		/* holds the reference for pdev1 */
 	}
 
-	card = kzalloc(sizeof(struct card) + channels * sizeof(struct channel), GFP_KERNEL);
-	if (!card) {
-		dev_err(&pdev->dev, "Out of memory\n");
+	card = kzalloc(sizeof(struct card) + channels * sizeof(struct channel),
+		       GFP_KERNEL);
+	if (!card)
 		return -ENOBUFS;
-	}
 
 	spin_lock_init(&card->bootrom_lock);
 	card->bootrom_addr = pci_resource_start(pdev, 0);
diff --git a/drivers/staging/sep/sep_crypto.c b/drivers/staging/sep/sep_crypto.c
index 861588f..cd3bb39 100644
--- a/drivers/staging/sep/sep_crypto.c
+++ b/drivers/staging/sep/sep_crypto.c
@@ -178,11 +178,9 @@ static struct scatterlist *sep_alloc_sg_buf(
 		nbr_pages += 1;
 	}
 
-	sg = kmalloc((sizeof(struct scatterlist) * nbr_pages), GFP_ATOMIC);
-	if (!sg) {
-		dev_warn(&sep->pdev->dev, "Cannot allocate page for new sg\n");
+	sg = kmalloc_array(nbr_pages, sizeof(struct scatterlist), GFP_ATOMIC);
+	if (!sg)
 		return NULL;
-	}
 
 	sg_init_table(sg, nbr_pages);
 
diff --git a/drivers/staging/sep/sep_main.c b/drivers/staging/sep/sep_main.c
index 15c6e3d..30e8d25 100644
--- a/drivers/staging/sep/sep_main.c
+++ b/drivers/staging/sep/sep_main.c
@@ -219,12 +219,8 @@ static int sep_allocate_dmatables_region(struct sep_device *sep,
 	dev_dbg(&sep->pdev->dev, "[PID%d] oldlen = 0x%08X\n", current->pid,
 				dma_ctx->dmatables_len);
 	tmp_region = kzalloc(new_len + dma_ctx->dmatables_len, GFP_KERNEL);
-	if (!tmp_region) {
-		dev_warn(&sep->pdev->dev,
-			 "[PID%d] no mem for dma tables region\n",
-				current->pid);
+	if (!tmp_region)
 		return -ENOMEM;
-	}
 
 	/* Were there any previous tables that need to be preserved ? */
 	if (*dmatables_region) {
@@ -1245,27 +1241,23 @@ static int sep_lock_user_pages(struct sep_device *sep,
 					current->pid, num_pages);
 
 	/* Allocate array of pages structure pointers */
-	page_array = kmalloc(sizeof(struct page *) * num_pages, GFP_ATOMIC);
+	page_array = kmalloc_array(num_pages, sizeof(struct page *),
+				   GFP_ATOMIC);
 	if (!page_array) {
 		error = -ENOMEM;
 		goto end_function;
 	}
-	map_array = kmalloc(sizeof(struct sep_dma_map) * num_pages, GFP_ATOMIC);
+
+	map_array = kmalloc_array(num_pages, sizeof(struct sep_dma_map),
+				  GFP_ATOMIC);
 	if (!map_array) {
-		dev_warn(&sep->pdev->dev,
-			 "[PID%d] kmalloc for map_array failed\n",
-				current->pid);
 		error = -ENOMEM;
 		goto end_function_with_error1;
 	}
 
-	lli_array = kmalloc(sizeof(struct sep_lli_entry) * num_pages,
-		GFP_ATOMIC);
-
+	lli_array = kmalloc_array(num_pages, sizeof(struct sep_lli_entry),
+				  GFP_ATOMIC);
 	if (!lli_array) {
-		dev_warn(&sep->pdev->dev,
-			 "[PID%d] kmalloc for lli_array failed\n",
-				current->pid);
 		error = -ENOMEM;
 		goto end_function_with_error2;
 	}
@@ -1448,15 +1440,10 @@ static int sep_lli_table_secure_dma(struct sep_device *sep,
 	dev_dbg(&sep->pdev->dev, "[PID%d] num_pages is (hex) %x\n",
 		current->pid, num_pages);
 
-	lli_array = kmalloc(sizeof(struct sep_lli_entry) * num_pages,
-		GFP_ATOMIC);
-
-	if (!lli_array) {
-		dev_warn(&sep->pdev->dev,
-			"[PID%d] kmalloc for lli_array failed\n",
-			current->pid);
+	lli_array = kmalloc_array(num_pages, sizeof(struct sep_lli_entry),
+				  GFP_ATOMIC);
+	if (!lli_array)
 		return -ENOMEM;
-	}
 
 	/*
 	 * Fill the lli_array
@@ -3419,11 +3406,9 @@ static ssize_t sep_create_dcb_dmatables_context(struct sep_device *sep,
 		goto end_function;
 	}
 
-	dcb_args = kzalloc(num_dcbs * sizeof(struct build_dcb_struct),
+	dcb_args = kcalloc(num_dcbs, sizeof(struct build_dcb_struct),
 			   GFP_KERNEL);
 	if (!dcb_args) {
-		dev_warn(&sep->pdev->dev, "[PID%d] no memory for dcb args\n",
-			 current->pid);
 		error = -ENOMEM;
 		goto end_function;
 	}
@@ -3610,9 +3595,6 @@ static ssize_t sep_create_msgarea_context(struct sep_device *sep,
 	/* Allocate thread-specific memory for message buffer */
 	*msg_region = kzalloc(msg_len, GFP_KERNEL);
 	if (!(*msg_region)) {
-		dev_warn(&sep->pdev->dev,
-			 "[PID%d] no mem for msgarea context\n",
-			 current->pid);
 		error = -ENOMEM;
 		goto end_function;
 	}
@@ -4133,8 +4115,6 @@ static int sep_probe(struct pci_dev *pdev,
 	/* Allocate the sep_device structure for this device */
 	sep_dev = kzalloc(sizeof(struct sep_device), GFP_ATOMIC);
 	if (sep_dev == NULL) {
-		dev_warn(&pdev->dev,
-			"can't kmalloc the sep_device structure\n");
 		error = -ENOMEM;
 		goto end_function_disable_device;
 	}
diff --git a/drivers/staging/speakup/selection.c b/drivers/staging/speakup/selection.c
index d6558fa..822ac3d 100644
--- a/drivers/staging/speakup/selection.c
+++ b/drivers/staging/speakup/selection.c
@@ -95,7 +95,6 @@ int speakup_set_selection(struct tty_struct *tty)
 	/* Allocate a new buffer before freeing the old one ... */
 	bp = kmalloc((sel_end-sel_start)/2+1, GFP_ATOMIC);
 	if (!bp) {
-		dev_warn(tty->dev, "selection: kmalloc() failed\n");
 		speakup_clear_selection();
 		return -ENOMEM;
 	}
diff --git a/drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c b/drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c
index 299f518..6a21f67 100644
--- a/drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c
+++ b/drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c
@@ -742,13 +742,9 @@ static int synaptics_rmi4_i2c_query_device(struct synaptics_rmi4_data *pdata)
 			case SYNAPTICS_RMI4_TOUCHPAD_FUNC_NUM:
 				if (rmi_fd.intr_src_count) {
 					rfi = kmalloc(sizeof(*rfi),
-								GFP_KERNEL);
-					if (!rfi) {
-						dev_err(&client->dev,
-							"%s:kmalloc failed\n",
-								__func__);
-							return -ENOMEM;
-					}
+						      GFP_KERNEL);
+					if (!rfi)
+						return -ENOMEM;
 					retval = synpatics_rmi4_touchpad_detect
 								(pdata,	rfi,
 								&rmi_fd,
@@ -900,12 +896,10 @@ static int synaptics_rmi4_probe
 	}
 
 	/* Allocate and initialize the instance data for this client */
-	rmi4_data = kzalloc(sizeof(struct synaptics_rmi4_data) * 2,
-							GFP_KERNEL);
-	if (!rmi4_data) {
-		dev_err(&client->dev, "%s: no memory allocated\n", __func__);
+	rmi4_data = kcalloc(2, sizeof(struct synaptics_rmi4_data),
+			    GFP_KERNEL);
+	if (!rmi4_data)
 		return -ENOMEM;
-	}
 
 	rmi4_data->input_dev = input_allocate_device();
 	if (rmi4_data->input_dev == NULL) {
diff --git a/drivers/staging/tidspbridge/pmgr/dspapi.c b/drivers/staging/tidspbridge/pmgr/dspapi.c
index 5a18a94..70db4ff 100644
--- a/drivers/staging/tidspbridge/pmgr/dspapi.c
+++ b/drivers/staging/tidspbridge/pmgr/dspapi.c
@@ -1543,7 +1543,7 @@ u32 strmwrap_free_buffer(union trapped_args *args, void *pr_ctxt)
 	if (num_bufs > MAX_BUFS)
 		return -EINVAL;
 
-	ap_buffer = kmalloc((num_bufs * sizeof(u8 *)), GFP_KERNEL);
+	ap_buffer = kmalloc_array(num_bufs, sizeof(u8 *), GFP_KERNEL);
 	if (ap_buffer == NULL)
 		return -ENOMEM;
 
diff --git a/drivers/staging/tidspbridge/rmgr/proc.c b/drivers/staging/tidspbridge/rmgr/proc.c
index e1bdf6e..0df55bd 100644
--- a/drivers/staging/tidspbridge/rmgr/proc.c
+++ b/drivers/staging/tidspbridge/rmgr/proc.c
@@ -119,16 +119,14 @@ static struct dmm_map_object *add_mapping_info(struct process_context *pr_ctxt,
 						dsp_addr, size);
 
 	map_obj = kzalloc(sizeof(struct dmm_map_object), GFP_KERNEL);
-	if (!map_obj) {
-		pr_err("%s: kzalloc failed\n", __func__);
+	if (!map_obj)
 		return NULL;
-	}
+
 	INIT_LIST_HEAD(&map_obj->link);
 
 	map_obj->pages = kcalloc(num_usr_pgs, sizeof(struct page *),
-							GFP_KERNEL);
+				 GFP_KERNEL);
 	if (!map_obj->pages) {
-		pr_err("%s: kzalloc failed\n", __func__);
 		kfree(map_obj);
 		return NULL;
 	}
@@ -693,7 +691,6 @@ static int memory_give_ownership(struct dmm_map_object *map_obj,
 
 	sg = kcalloc(num_pages, sizeof(*sg), GFP_KERNEL);
 	if (!sg) {
-		pr_err("%s: kcalloc failed\n", __func__);
 		ret = -ENOMEM;
 		goto out;
 	}
@@ -1227,12 +1224,8 @@ int proc_load(void *hprocessor, const s32 argc_index,
 				(p_proc_object->bridge_context, &brd_state))) {
 			pr_info("%s: Processor Loaded %s\n", __func__, pargv0);
 			kfree(drv_datap->base_img);
-			drv_datap->base_img = kmalloc(strlen(pargv0) + 1,
-								GFP_KERNEL);
-			if (drv_datap->base_img)
-				strncpy(drv_datap->base_img, pargv0,
-							strlen(pargv0) + 1);
-			else
+			drv_datap->base_img = kstrdup(pargv0, GFP_KERNEL);
+			if (!drv_datap->base_img)
 				status = -ENOMEM;
 		}
 	}
diff --git a/drivers/staging/usbip/stub_dev.c b/drivers/staging/usbip/stub_dev.c
index d36c69e..ca5de9d 100644
--- a/drivers/staging/usbip/stub_dev.c
+++ b/drivers/staging/usbip/stub_dev.c
@@ -286,10 +286,8 @@ static struct stub_device *stub_device_alloc(struct usb_device *udev,
 
 	/* yes, it's a new device */
 	sdev = kzalloc(sizeof(struct stub_device), GFP_KERNEL);
-	if (!sdev) {
-		dev_err(&interface->dev, "no memory for stub_device\n");
+	if (!sdev)
 		return NULL;
-	}
 
 	sdev->interface = usb_get_intf(interface);
 	sdev->udev = usb_get_dev(udev);
diff --git a/drivers/staging/usbip/stub_rx.c b/drivers/staging/usbip/stub_rx.c
index e7458e1..715e8a7 100644
--- a/drivers/staging/usbip/stub_rx.c
+++ b/drivers/staging/usbip/stub_rx.c
@@ -485,7 +485,6 @@ static void stub_recv_cmd_submit(struct stub_device *sdev,
 			kzalloc(pdu->u.cmd_submit.transfer_buffer_length,
 				GFP_KERNEL);
 		if (!priv->urb->transfer_buffer) {
-			dev_err(&sdev->interface->dev, "malloc x_buff\n");
 			usbip_event_add(ud, SDEV_EVENT_ERROR_MALLOC);
 			return;
 		}
diff --git a/drivers/staging/usbip/stub_tx.c b/drivers/staging/usbip/stub_tx.c
index 513961f..cd5326a 100644
--- a/drivers/staging/usbip/stub_tx.c
+++ b/drivers/staging/usbip/stub_tx.c
@@ -42,7 +42,6 @@ void stub_enqueue_ret_unlink(struct stub_device *sdev, __u32 seqnum,
 
 	unlink = kzalloc(sizeof(struct stub_unlink), GFP_ATOMIC);
 	if (!unlink) {
-		dev_err(&sdev->interface->dev, "alloc stub_unlink\n");
 		usbip_event_add(&sdev->ud, VDEV_EVENT_ERROR_MALLOC);
 		return;
 	}
diff --git a/drivers/staging/usbip/vhci_hcd.c b/drivers/staging/usbip/vhci_hcd.c
index 216648d..f1ca084 100644
--- a/drivers/staging/usbip/vhci_hcd.c
+++ b/drivers/staging/usbip/vhci_hcd.c
@@ -434,16 +434,13 @@ static void vhci_tx_urb(struct urb *urb)
 	}
 
 	priv = kzalloc(sizeof(struct vhci_priv), GFP_ATOMIC);
-
-	spin_lock(&vdev->priv_lock);
-
 	if (!priv) {
-		dev_err(&urb->dev->dev, "malloc vhci_priv\n");
-		spin_unlock(&vdev->priv_lock);
 		usbip_event_add(&vdev->ud, VDEV_EVENT_ERROR_MALLOC);
 		return;
 	}
 
+	spin_lock(&vdev->priv_lock);
+
 	priv->seqnum = atomic_inc_return(&the_controller->seqnum);
 	if (priv->seqnum == 0xffff)
 		dev_info(&urb->dev->dev, "seqnum max\n");
@@ -684,7 +681,6 @@ static int vhci_urb_dequeue(struct usb_hcd *hcd, struct urb *urb, int status)
 		/* setup CMD_UNLINK pdu */
 		unlink = kzalloc(sizeof(struct vhci_unlink), GFP_ATOMIC);
 		if (!unlink) {
-			pr_err("malloc vhci_unlink\n");
 			spin_unlock(&vdev->priv_lock);
 			spin_unlock(&the_controller->lock);
 			usbip_event_add(&vdev->ud, VDEV_EVENT_ERROR_MALLOC);
diff --git a/drivers/staging/vme/devices/vme_pio2_core.c b/drivers/staging/vme/devices/vme_pio2_core.c
index bf73ba2..fd19c25 100644
--- a/drivers/staging/vme/devices/vme_pio2_core.c
+++ b/drivers/staging/vme/devices/vme_pio2_core.c
@@ -222,7 +222,6 @@ static int pio2_probe(struct vme_dev *vdev)
 
 	card = kzalloc(sizeof(struct pio2_card), GFP_KERNEL);
 	if (card == NULL) {
-		dev_err(&vdev->dev, "Unable to allocate card structure\n");
 		retval = -ENOMEM;
 		goto err_struct;
 	}
diff --git a/drivers/staging/vme/devices/vme_pio2_gpio.c b/drivers/staging/vme/devices/vme_pio2_gpio.c
index 69d8805..2a2d920 100644
--- a/drivers/staging/vme/devices/vme_pio2_gpio.c
+++ b/drivers/staging/vme/devices/vme_pio2_gpio.c
@@ -192,10 +192,8 @@ int pio2_gpio_init(struct pio2_card *card)
 	char *label;
 
 	label = kmalloc(PIO2_NUM_CHANNELS, GFP_KERNEL);
-	if (label == NULL) {
-		dev_err(&card->vdev->dev, "Unable to allocate GPIO label\n");
+	if (label == NULL)
 		return -ENOMEM;
-	}
 
 	sprintf(label, "%s@%s", driver_name, dev_name(&card->vdev->dev));
 	card->gc.label = label;
diff --git a/drivers/staging/vme/devices/vme_user.c b/drivers/staging/vme/devices/vme_user.c
index 4ef852c..57474cf 100644
--- a/drivers/staging/vme/devices/vme_user.c
+++ b/drivers/staging/vme/devices/vme_user.c
@@ -761,8 +761,6 @@ static int vme_user_probe(struct vme_dev *vdev)
 		image[i].size_buf = PCI_BUF_SIZE;
 		image[i].kern_buf = kmalloc(image[i].size_buf, GFP_KERNEL);
 		if (image[i].kern_buf == NULL) {
-			dev_warn(&vdev->dev,
-				 "Unable to allocate memory for master window buffers\n");
 			err = -ENOMEM;
 			goto err_master_buf;
 		}
diff --git a/drivers/staging/zcache/zcache-main.c b/drivers/staging/zcache/zcache-main.c
index c1ac905..f3204ac 100644
--- a/drivers/staging/zcache/zcache-main.c
+++ b/drivers/staging/zcache/zcache-main.c
@@ -1304,10 +1304,8 @@ int zcache_new_pool(uint16_t cli_id, uint32_t flags)
 		goto out;
 	atomic_inc(&cli->refcount);
 	pool = kmalloc(sizeof(struct tmem_pool), GFP_ATOMIC);
-	if (pool == NULL) {
-		pr_info("%s: pool creation failed: out of memory\n", namestr);
+	if (pool == NULL)
 		goto out;
-	}
 
 	for (poolid = 0; poolid < MAX_POOLS_PER_CLIENT; poolid++)
 		if (cli->tmem_pools[poolid] == NULL)
@@ -1380,10 +1378,9 @@ int zcache_autocreate_pool(unsigned int cli_id, unsigned int pool_id, bool eph)
 		goto out;
 	}
 	pool = kmalloc(sizeof(struct tmem_pool), GFP_KERNEL);
-	if (pool == NULL) {
-		pr_info("%s: pool creation failed: out of memory\n", namestr);
+	if (pool == NULL)
 		goto out;
-	}
+
 	atomic_set(&pool->refcount, 0);
 	pool->client = cli;
 	pool->pool_id = pool_id;
diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index 6094e80..5918fd7 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -246,7 +246,6 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
 		 */
 		uncmem = kmalloc(PAGE_SIZE, GFP_NOIO);
 		if (!uncmem) {
-			pr_info("Error allocating temp memory!\n");
 			ret = -ENOMEM;
 			goto out;
 		}
@@ -517,10 +516,8 @@ struct zram_meta *zram_meta_alloc(u64 disksize)
 		goto out;
 
 	meta->compress_workmem = kzalloc(LZO1X_MEM_COMPRESS, GFP_KERNEL);
-	if (!meta->compress_workmem) {
-		pr_err("Error allocating compressor working memory!\n");
+	if (!meta->compress_workmem)
 		goto free_meta;
-	}
 
 	meta->compress_buffer =
 		(void *)__get_free_pages(GFP_KERNEL | __GFP_ZERO, 1);



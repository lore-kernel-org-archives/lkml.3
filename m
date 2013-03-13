Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933866Ab3CMQT2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 12:19:28 -0400
Received: from mail-ia0-f172.google.com ([209.85.210.172]:60365 "EHLO
	mail-ia0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932610Ab3CMQT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 12:19:26 -0400
From: Jacob Garber <ajtgarber@gmail.com>
To: greg@kroah.com
Cc: abbotti@mev.co.uk, fmhess@users.sourceforge.net,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Jacob Garber <ajtgarber@gmail.com>
Subject: [PATCH] Staging: comedi: Fixed camel case style issue in usbdux.c
Date: Wed, 13 Mar 2013 12:19:20 -0400
Message-Id: <1363191560-4410-1-git-send-email-ajtgarber@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to usbdux.c that fixes the camel case warnings found
by the checkpatch.pl tool

Signed-off-by: Jacob Garber <ajtgarber@gmail.com>
---
 drivers/staging/comedi/drivers/usbdux.c |  404 +++++++++++++++----------------
 1 file changed, 202 insertions(+), 202 deletions(-)

diff --git a/drivers/staging/comedi/drivers/usbdux.c b/drivers/staging/comedi/drivers/usbdux.c
index 1a0062a..a155ef0 100644
--- a/drivers/staging/comedi/drivers/usbdux.c
+++ b/drivers/staging/comedi/drivers/usbdux.c
@@ -250,26 +250,26 @@ struct usbduxsub {
 	/* pointer to the usb-device */
 	struct usb_device *usbdev;
 	/* actual number of in-buffers */
-	int numOfInBuffers;
+	int num_in_buffers;
 	/* actual number of out-buffers */
-	int numOfOutBuffers;
+	int num_out_buffers;
 	/* ISO-transfer handling: buffers */
-	struct urb **urbIn;
-	struct urb **urbOut;
+	struct urb **urb_in;
+	struct urb **urb_out;
 	/* pwm-transfer handling */
-	struct urb *urbPwm;
+	struct urb *urb_pwm;
 	/* PWM period */
-	unsigned int pwmPeriod;
+	unsigned int pwm_period;
 	/* PWM internal delay for the GPIF in the FX2 */
-	int8_t pwmDelay;
+	int8_t pwn_delay;
 	/* size of the PWM buffer which holds the bit pattern */
-	int sizePwmBuf;
+	int size_pwm_buf;
 	/* input buffer for the ISO-transfer */
-	int16_t *inBuffer;
+	int16_t *in_buffer;
 	/* input buffer for single insn */
-	int16_t *insnBuffer;
+	int16_t *insn_buffer;
 	/* output buffer for single DA outputs */
-	int16_t *outBuffer;
+	int16_t *out_buffer;
 	/* interface number */
 	int ifnum;
 	/* interface structure in 2.6 */
@@ -319,17 +319,17 @@ static DEFINE_SEMAPHORE(start_stop_sem);
  * Stops the data acquision
  * It should be safe to call this function from any context
  */
-static int usbduxsub_unlink_InURBs(struct usbduxsub *usbduxsub_tmp)
+static int usbduxsub_unlink_inurbs(struct usbduxsub *usbduxsub_tmp)
 {
 	int i = 0;
 	int err = 0;
 
-	if (usbduxsub_tmp && usbduxsub_tmp->urbIn) {
-		for (i = 0; i < usbduxsub_tmp->numOfInBuffers; i++) {
-			if (usbduxsub_tmp->urbIn[i]) {
+	if (usbduxsub_tmp && usbduxsub_tmp->urb_in) {
+		for (i = 0; i < usbduxsub_tmp->num_in_buffers; i++) {
+			if (usbduxsub_tmp->urb_in[i]) {
 				/* We wait here until all transfers have been
 				 * cancelled. */
-				usb_kill_urb(usbduxsub_tmp->urbIn[i]);
+				usb_kill_urb(usbduxsub_tmp->urb_in[i]);
 			}
 			dev_dbg(&usbduxsub_tmp->interface->dev,
 				"comedi: usbdux: unlinked InURB %d, err=%d\n",
@@ -356,7 +356,7 @@ static int usbdux_ai_stop(struct usbduxsub *this_usbduxsub, int do_unlink)
 
 	if (do_unlink) {
 		/* stop aquistion */
-		ret = usbduxsub_unlink_InURBs(this_usbduxsub);
+		ret = usbduxsub_unlink_inurbs(this_usbduxsub);
 	}
 
 	this_usbduxsub->ai_cmd_running = 0;
@@ -394,7 +394,7 @@ static int usbdux_ai_cancel(struct comedi_device *dev,
 }
 
 /* analogue IN - interrupt service routine */
-static void usbduxsub_ai_IsocIrq(struct urb *urb)
+static void usbduxsub_ai_isoc_irq(struct urb *urb)
 {
 	int i, err, n;
 	struct usbduxsub *this_usbduxsub;
@@ -412,7 +412,7 @@ static void usbduxsub_ai_IsocIrq(struct urb *urb)
 	switch (urb->status) {
 	case 0:
 		/* copy the result in the transfer buffer */
-		memcpy(this_usbduxsub->inBuffer,
+		memcpy(this_usbduxsub->in_buffer,
 		       urb->transfer_buffer, SIZEINBUF);
 		break;
 	case -EILSEQ:
@@ -517,11 +517,11 @@ static void usbduxsub_ai_IsocIrq(struct urb *urb)
 		if (CR_RANGE(s->async->cmd.chanlist[i]) <= 1) {
 			err = comedi_buf_put
 			    (s->async,
-			     le16_to_cpu(this_usbduxsub->inBuffer[i]) ^ 0x800);
+			     le16_to_cpu(this_usbduxsub->in_buffer[i]) ^ 0x800);
 		} else {
 			err = comedi_buf_put
 			    (s->async,
-			     le16_to_cpu(this_usbduxsub->inBuffer[i]));
+			     le16_to_cpu(this_usbduxsub->in_buffer[i]));
 		}
 		if (unlikely(err == 0)) {
 			/* buffer overflow */
@@ -534,15 +534,15 @@ static void usbduxsub_ai_IsocIrq(struct urb *urb)
 	comedi_event(this_usbduxsub->comedidev, s);
 }
 
-static int usbduxsub_unlink_OutURBs(struct usbduxsub *usbduxsub_tmp)
+static int usbduxsub_unlink_outurbs(struct usbduxsub *usbduxsub_tmp)
 {
 	int i = 0;
 	int err = 0;
 
-	if (usbduxsub_tmp && usbduxsub_tmp->urbOut) {
-		for (i = 0; i < usbduxsub_tmp->numOfOutBuffers; i++) {
-			if (usbduxsub_tmp->urbOut[i])
-				usb_kill_urb(usbduxsub_tmp->urbOut[i]);
+	if (usbduxsub_tmp && usbduxsub_tmp->urb_out) {
+		for (i = 0; i < usbduxsub_tmp->num_out_buffers; i++) {
+			if (usbduxsub_tmp->urb_out[i])
+				usb_kill_urb(usbduxsub_tmp->urb_out[i]);
 
 			dev_dbg(&usbduxsub_tmp->interface->dev,
 				"comedi: usbdux: unlinked OutURB %d: res=%d\n",
@@ -564,7 +564,7 @@ static int usbdux_ao_stop(struct usbduxsub *this_usbduxsub, int do_unlink)
 	dev_dbg(&this_usbduxsub->interface->dev, "comedi: usbdux_ao_cancel\n");
 
 	if (do_unlink)
-		ret = usbduxsub_unlink_OutURBs(this_usbduxsub);
+		ret = usbduxsub_unlink_outurbs(this_usbduxsub);
 
 	this_usbduxsub->ao_cmd_running = 0;
 
@@ -593,7 +593,7 @@ static int usbdux_ao_cancel(struct comedi_device *dev,
 	return res;
 }
 
-static void usbduxsub_ao_IsocIrq(struct urb *urb)
+static void usbduxsub_ao_isoc_irq(struct urb *urb)
 {
 	int i, ret;
 	int8_t *datap;
@@ -791,7 +791,7 @@ static int usbduxsub_stop(struct usbduxsub *usbduxsub)
 
 static int usbduxsub_upload(struct usbduxsub *usbduxsub,
 			    uint8_t *local_transfer_buffer,
-			    unsigned int startAddr, unsigned int len)
+			    unsigned int start_addr, unsigned int len)
 {
 	int errcode;
 
@@ -802,7 +802,7 @@ static int usbduxsub_upload(struct usbduxsub *usbduxsub,
 				  /* bmRequestType */
 				  VENDOR_DIR_OUT,
 				  /* value */
-				  startAddr,
+				  start_addr,
 				  /* index */
 				  0x0000,
 				  /* our local safe buffer */
@@ -821,24 +821,24 @@ static int usbduxsub_upload(struct usbduxsub *usbduxsub,
 
 #define FIRMWARE_MAX_LEN 0x2000
 
-static int firmwareUpload(struct usbduxsub *usbduxsub,
-			  const u8 *firmwareBinary, int sizeFirmware)
+static int firmware_upload(struct usbduxsub *usbduxsub,
+			  const u8 *firmware_binary, int size_firmware)
 {
 	int ret;
-	uint8_t *fwBuf;
+	uint8_t *fw_buf;
 
-	if (!firmwareBinary)
+	if (!firmware_binary)
 		return 0;
 
-	if (sizeFirmware > FIRMWARE_MAX_LEN) {
+	if (size_firmware > FIRMWARE_MAX_LEN) {
 		dev_err(&usbduxsub->interface->dev,
 			"usbdux firmware binary it too large for FX2.\n");
 		return -ENOMEM;
 	}
 
 	/* we generate a local buffer for the firmware */
-	fwBuf = kmemdup(firmwareBinary, sizeFirmware, GFP_KERNEL);
-	if (!fwBuf) {
+	fw_buf = kmemdup(firmware_binary, size_firmware, GFP_KERNEL);
+	if (!fw_buf) {
 		dev_err(&usbduxsub->interface->dev,
 			"comedi_: mem alloc for firmware failed\n");
 		return -ENOMEM;
@@ -848,81 +848,81 @@ static int firmwareUpload(struct usbduxsub *usbduxsub,
 	if (ret < 0) {
 		dev_err(&usbduxsub->interface->dev,
 			"comedi_: can not stop firmware\n");
-		kfree(fwBuf);
+		kfree(fw_buf);
 		return ret;
 	}
 
-	ret = usbduxsub_upload(usbduxsub, fwBuf, 0, sizeFirmware);
+	ret = usbduxsub_upload(usbduxsub, fw_buf, 0, size_firmware);
 	if (ret < 0) {
 		dev_err(&usbduxsub->interface->dev,
 			"comedi_: firmware upload failed\n");
-		kfree(fwBuf);
+		kfree(fw_buf);
 		return ret;
 	}
 	ret = usbduxsub_start(usbduxsub);
 	if (ret < 0) {
 		dev_err(&usbduxsub->interface->dev,
 			"comedi_: can not start firmware\n");
-		kfree(fwBuf);
+		kfree(fw_buf);
 		return ret;
 	}
-	kfree(fwBuf);
+	kfree(fw_buf);
 	return 0;
 }
 
-static int usbduxsub_submit_InURBs(struct usbduxsub *usbduxsub)
+static int usbduxsub_submit_inurbs(struct usbduxsub *usbduxsub)
 {
-	int i, errFlag;
+	int i, err_flag;
 
 	if (!usbduxsub)
 		return -EFAULT;
 
 	/* Submit all URBs and start the transfer on the bus */
-	for (i = 0; i < usbduxsub->numOfInBuffers; i++) {
+	for (i = 0; i < usbduxsub->num_in_buffers; i++) {
 		/* in case of a resubmission after an unlink... */
-		usbduxsub->urbIn[i]->interval = usbduxsub->ai_interval;
-		usbduxsub->urbIn[i]->context = usbduxsub->comedidev;
-		usbduxsub->urbIn[i]->dev = usbduxsub->usbdev;
-		usbduxsub->urbIn[i]->status = 0;
-		usbduxsub->urbIn[i]->transfer_flags = URB_ISO_ASAP;
+		usbduxsub->urb_in[i]->interval = usbduxsub->ai_interval;
+		usbduxsub->urb_in[i]->context = usbduxsub->comedidev;
+		usbduxsub->urb_in[i]->dev = usbduxsub->usbdev;
+		usbduxsub->urb_in[i]->status = 0;
+		usbduxsub->urb_in[i]->transfer_flags = URB_ISO_ASAP;
 		dev_dbg(&usbduxsub->interface->dev,
 			"comedi%d: submitting in-urb[%d]: %p,%p intv=%d\n",
 			usbduxsub->comedidev->minor, i,
-			(usbduxsub->urbIn[i]->context),
-			(usbduxsub->urbIn[i]->dev),
-			(usbduxsub->urbIn[i]->interval));
-		errFlag = usb_submit_urb(usbduxsub->urbIn[i], GFP_ATOMIC);
-		if (errFlag) {
+			(usbduxsub->urb_in[i]->context),
+			(usbduxsub->urb_in[i]->dev),
+			(usbduxsub->urb_in[i]->interval));
+		err_flag = usb_submit_urb(usbduxsub->urb_in[i], GFP_ATOMIC);
+		if (err_flag) {
 			dev_err(&usbduxsub->interface->dev,
 				"comedi_: ai: usb_submit_urb(%d) error %d\n",
-				i, errFlag);
-			return errFlag;
+				i, err_flag);
+			return err_flag;
 		}
 	}
 	return 0;
 }
 
-static int usbduxsub_submit_OutURBs(struct usbduxsub *usbduxsub)
+static int usbduxsub_submit_outurbs(struct usbduxsub *usbduxsub)
 {
-	int i, errFlag;
+	int i, err_flag;
 
 	if (!usbduxsub)
 		return -EFAULT;
 
-	for (i = 0; i < usbduxsub->numOfOutBuffers; i++) {
+	for (i = 0; i < usbduxsub->num_out_buffers; i++) {
 		dev_dbg(&usbduxsub->interface->dev,
 			"comedi_: submitting out-urb[%d]\n", i);
 		/* in case of a resubmission after an unlink... */
-		usbduxsub->urbOut[i]->context = usbduxsub->comedidev;
-		usbduxsub->urbOut[i]->dev = usbduxsub->usbdev;
-		usbduxsub->urbOut[i]->status = 0;
-		usbduxsub->urbOut[i]->transfer_flags = URB_ISO_ASAP;
-		errFlag = usb_submit_urb(usbduxsub->urbOut[i], GFP_ATOMIC);
-		if (errFlag) {
+		usbduxsub->urb_out[i]->context = usbduxsub->comedidev;
+		usbduxsub->urb_out[i]->dev = usbduxsub->usbdev;
+		usbduxsub->urb_out[i]->status = 0;
+		usbduxsub->urb_out[i]->transfer_flags = URB_ISO_ASAP;
+		err_flag = usb_submit_urb(usbduxsub->urb_out[i], GFP_ATOMIC);
+		if (err_flag) {
 			dev_err(&usbduxsub->interface->dev,
 				"comedi_: ao: usb_submit_urb(%d) error %d\n",
-				i, errFlag);
-			return errFlag;
+				i, err_flag);
+			return err_flag;
 		}
 	}
 	return 0;
@@ -933,7 +933,7 @@ static int usbdux_ai_cmdtest(struct comedi_device *dev,
 {
 	struct usbduxsub *this_usbduxsub = dev->private;
 	int err = 0, i;
-	unsigned int tmpTimer;
+	unsigned int tmp_timer;
 
 	if (!(this_usbduxsub->probed))
 		return -ENODEV;
@@ -983,7 +983,7 @@ static int usbdux_ai_cmdtest(struct comedi_device *dev,
 							 1000000 / 8 * i);
 			/* now calc the real sampling rate with all the
 			 * rounding errors */
-			tmpTimer =
+			tmp_timer =
 			    ((unsigned int)(cmd->scan_begin_arg / 125000)) *
 			    125000;
 		} else {
@@ -994,11 +994,11 @@ static int usbdux_ai_cmdtest(struct comedi_device *dev,
 			/*
 			 * calc the real sampling rate with the rounding errors
 			 */
-			tmpTimer = ((unsigned int)(cmd->scan_begin_arg /
+			tmp_timer = ((unsigned int)(cmd->scan_begin_arg /
 						   1000000)) * 1000000;
 		}
 		err |= cfc_check_trigger_arg_is(&cmd->scan_begin_arg,
-						tmpTimer);
+						tmp_timer);
 	}
 
 	err |= cfc_check_trigger_arg_is(&cmd->scan_end_arg, cmd->chanlist_len);
@@ -1074,7 +1074,7 @@ static int receive_dux_commands(struct usbduxsub *this_usbduxsub, int command)
 		result = usb_bulk_msg(this_usbduxsub->usbdev,
 				      usb_rcvbulkpipe(this_usbduxsub->usbdev,
 						      COMMAND_IN_EP),
-				      this_usbduxsub->insnBuffer, SIZEINSNBUF,
+				      this_usbduxsub->insn_buffer, SIZEINSNBUF,
 				      &nrec, BULK_TIMEOUT);
 		if (result < 0) {
 			dev_err(&this_usbduxsub->interface->dev, "comedi%d: "
@@ -1082,7 +1082,7 @@ static int receive_dux_commands(struct usbduxsub *this_usbduxsub, int command)
 				"\n", this_usbduxsub->comedidev->minor, result);
 			return result;
 		}
-		if (le16_to_cpu(this_usbduxsub->insnBuffer[0]) == command)
+		if (le16_to_cpu(this_usbduxsub->insn_buffer[0]) == command)
 			return result;
 	}
 	/* this is only reached if the data has been requested a couple of
@@ -1090,7 +1090,7 @@ static int receive_dux_commands(struct usbduxsub *this_usbduxsub, int command)
 	dev_err(&this_usbduxsub->interface->dev, "comedi%d: insn: "
 		"wrong data returned from firmware: want cmd %d, got cmd %d.\n",
 		this_usbduxsub->comedidev->minor, command,
-		le16_to_cpu(this_usbduxsub->insnBuffer[0]));
+		le16_to_cpu(this_usbduxsub->insn_buffer[0]));
 	return -EFAULT;
 }
 
@@ -1119,7 +1119,7 @@ static int usbdux_ai_inttrig(struct comedi_device *dev,
 	}
 	if (!(this_usbduxsub->ai_cmd_running)) {
 		this_usbduxsub->ai_cmd_running = 1;
-		ret = usbduxsub_submit_InURBs(this_usbduxsub);
+		ret = usbduxsub_submit_inurbs(this_usbduxsub);
 		if (ret < 0) {
 			dev_err(&this_usbduxsub->interface->dev,
 				"comedi%d: usbdux_ai_inttrig: "
@@ -1236,7 +1236,7 @@ static int usbdux_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 	if (cmd->start_src == TRIG_NOW) {
 		/* enable this acquisition operation */
 		this_usbduxsub->ai_cmd_running = 1;
-		ret = usbduxsub_submit_InURBs(this_usbduxsub);
+		ret = usbduxsub_submit_inurbs(this_usbduxsub);
 		if (ret < 0) {
 			this_usbduxsub->ai_cmd_running = 0;
 			/* fixme: unlink here?? */
@@ -1304,7 +1304,7 @@ static int usbdux_ai_insn_read(struct comedi_device *dev,
 			up(&this_usbduxsub->sem);
 			return 0;
 		}
-		one = le16_to_cpu(this_usbduxsub->insnBuffer[1]);
+		one = le16_to_cpu(this_usbduxsub->insn_buffer[1]);
 		if (CR_RANGE(insn->chanspec) <= 1)
 			one = one ^ 0x800;
 
@@ -1334,7 +1334,7 @@ static int usbdux_ao_insn_read(struct comedi_device *dev,
 		return -ENODEV;
 	}
 	for (i = 0; i < insn->n; i++)
-		data[i] = this_usbduxsub->outBuffer[chan];
+		data[i] = this_usbduxsub->out_buffer[chan];
 
 	up(&this_usbduxsub->sem);
 	return i;
@@ -1377,7 +1377,7 @@ static int usbdux_ao_insn_write(struct comedi_device *dev,
 		/* one 16 bit value */
 		*((int16_t *) (this_usbduxsub->dux_commands + 2)) =
 		    cpu_to_le16(data[i]);
-		this_usbduxsub->outBuffer[chan] = data[i];
+		this_usbduxsub->out_buffer[chan] = data[i];
 		/* channel number */
 		this_usbduxsub->dux_commands[4] = (chan << 6);
 		err = send_dux_commands(this_usbduxsub, SENDDACOMMANDS);
@@ -1414,7 +1414,7 @@ static int usbdux_ao_inttrig(struct comedi_device *dev,
 	}
 	if (!(this_usbduxsub->ao_cmd_running)) {
 		this_usbduxsub->ao_cmd_running = 1;
-		ret = usbduxsub_submit_OutURBs(this_usbduxsub);
+		ret = usbduxsub_submit_outurbs(this_usbduxsub);
 		if (ret < 0) {
 			dev_err(&this_usbduxsub->interface->dev,
 				"comedi%d: usbdux_ao_inttrig: submitURB: "
@@ -1609,7 +1609,7 @@ static int usbdux_ao_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 	if (cmd->start_src == TRIG_NOW) {
 		/* enable this acquisition operation */
 		this_usbduxsub->ao_cmd_running = 1;
-		ret = usbduxsub_submit_OutURBs(this_usbduxsub);
+		ret = usbduxsub_submit_outurbs(this_usbduxsub);
 		if (ret < 0) {
 			this_usbduxsub->ao_cmd_running = 0;
 			/* fixme: unlink here?? */
@@ -1697,7 +1697,7 @@ static int usbdux_dio_insn_bits(struct comedi_device *dev,
 		return err;
 	}
 
-	data[1] = le16_to_cpu(this_usbduxsub->insnBuffer[1]);
+	data[1] = le16_to_cpu(this_usbduxsub->insn_buffer[1]);
 	up(&this_usbduxsub->sem);
 	return insn->n;
 }
@@ -1733,7 +1733,7 @@ static int usbdux_counter_read(struct comedi_device *dev,
 		return err;
 	}
 
-	data[0] = le16_to_cpu(this_usbduxsub->insnBuffer[chan + 1]);
+	data[0] = le16_to_cpu(this_usbduxsub->insn_buffer[chan + 1]);
 	up(&this_usbduxsub->sem);
 	return 1;
 }
@@ -1780,13 +1780,13 @@ static int usbdux_counter_config(struct comedi_device *dev,
 /***********************************/
 /* PWM */
 
-static int usbduxsub_unlink_PwmURBs(struct usbduxsub *usbduxsub_tmp)
+static int usbduxsub_unlink_pwm_urbs(struct usbduxsub *usbduxsub_tmp)
 {
 	int err = 0;
 
-	if (usbduxsub_tmp && usbduxsub_tmp->urbPwm) {
-		if (usbduxsub_tmp->urbPwm)
-			usb_kill_urb(usbduxsub_tmp->urbPwm);
+	if (usbduxsub_tmp && usbduxsub_tmp->urb_pwm) {
+		if (usbduxsub_tmp->urb_pwm)
+			usb_kill_urb(usbduxsub_tmp->urb_pwm);
 		dev_dbg(&usbduxsub_tmp->interface->dev,
 			"comedi: unlinked PwmURB: res=%d\n", err);
 	}
@@ -1805,7 +1805,7 @@ static int usbdux_pwm_stop(struct usbduxsub *this_usbduxsub, int do_unlink)
 
 	dev_dbg(&this_usbduxsub->interface->dev, "comedi: %s\n", __func__);
 	if (do_unlink)
-		ret = usbduxsub_unlink_PwmURBs(this_usbduxsub);
+		ret = usbduxsub_unlink_pwm_urbs(this_usbduxsub);
 
 	this_usbduxsub->pwm_cmd_running = 0;
 
@@ -1878,7 +1878,7 @@ static void usbduxsub_pwm_irq(struct urb *urb)
 	if (!(this_usbduxsub->pwm_cmd_running))
 		return;
 
-	urb->transfer_buffer_length = this_usbduxsub->sizePwmBuf;
+	urb->transfer_buffer_length = this_usbduxsub->size_pwm_buf;
 	urb->dev = this_usbduxsub->usbdev;
 	urb->status = 0;
 	if (this_usbduxsub->pwm_cmd_running) {
@@ -1898,9 +1898,9 @@ static void usbduxsub_pwm_irq(struct urb *urb)
 	}
 }
 
-static int usbduxsub_submit_PwmURBs(struct usbduxsub *usbduxsub)
+static int usbduxsub_submit_pwm_urbs(struct usbduxsub *usbduxsub)
 {
-	int errFlag;
+	int err_flag;
 
 	if (!usbduxsub)
 		return -EFAULT;
@@ -1908,19 +1908,19 @@ static int usbduxsub_submit_PwmURBs(struct usbduxsub *usbduxsub)
 	dev_dbg(&usbduxsub->interface->dev, "comedi_: submitting pwm-urb\n");
 
 	/* in case of a resubmission after an unlink... */
-	usb_fill_bulk_urb(usbduxsub->urbPwm,
+	usb_fill_bulk_urb(usbduxsub->urb_pwm,
 			  usbduxsub->usbdev,
 			  usb_sndbulkpipe(usbduxsub->usbdev, PWM_EP),
-			  usbduxsub->urbPwm->transfer_buffer,
-			  usbduxsub->sizePwmBuf, usbduxsub_pwm_irq,
+			  usbduxsub->urb_pwm->transfer_buffer,
+			  usbduxsub->size_pwm_buf, usbduxsub_pwm_irq,
 			  usbduxsub->comedidev);
 
-	errFlag = usb_submit_urb(usbduxsub->urbPwm, GFP_ATOMIC);
-	if (errFlag) {
+	err_flag = usb_submit_urb(usbduxsub->urb_pwm, GFP_ATOMIC);
+	if (err_flag) {
 		dev_err(&usbduxsub->interface->dev,
 			"comedi_: usbdux: pwm: usb_submit_urb error %d\n",
-			errFlag);
-		return errFlag;
+			err_flag);
+		return err_flag;
 	}
 	return 0;
 }
@@ -1945,8 +1945,8 @@ static int usbdux_pwm_period(struct comedi_device *dev,
 			return -EAGAIN;
 		}
 	}
-	this_usbduxsub->pwmDelay = fx2delay;
-	this_usbduxsub->pwmPeriod = period;
+	this_usbduxsub->pwn_delay = fx2delay;
+	this_usbduxsub->pwm_period = period;
 	dev_dbg(&this_usbduxsub->interface->dev, "%s: frequ=%d, period=%d\n",
 		__func__, period, fx2delay);
 	return 0;
@@ -1967,17 +1967,17 @@ static int usbdux_pwm_start(struct comedi_device *dev,
 		return 0;
 	}
 
-	this_usbduxsub->dux_commands[1] = ((int8_t) this_usbduxsub->pwmDelay);
+	this_usbduxsub->dux_commands[1] = ((int8_t) this_usbduxsub->pwn_delay);
 	ret = send_dux_commands(this_usbduxsub, SENDPWMON);
 	if (ret < 0)
 		return ret;
 
 	/* initialise the buffer */
-	for (i = 0; i < this_usbduxsub->sizePwmBuf; i++)
-		((char *)(this_usbduxsub->urbPwm->transfer_buffer))[i] = 0;
+	for (i = 0; i < this_usbduxsub->size_pwm_buf; i++)
+		((char *)(this_usbduxsub->urb_pwm->transfer_buffer))[i] = 0;
 
 	this_usbduxsub->pwm_cmd_running = 1;
-	ret = usbduxsub_submit_PwmURBs(this_usbduxsub);
+	ret = usbduxsub_submit_pwm_urbs(this_usbduxsub);
 	if (ret < 0) {
 		this_usbduxsub->pwm_cmd_running = 0;
 		return ret;
@@ -1992,7 +1992,7 @@ static int usbdux_pwm_pattern(struct comedi_device *dev,
 {
 	struct usbduxsub *this_usbduxsub = dev->private;
 	int i, szbuf;
-	char *pBuf;
+	char *p_buf;
 	char pwm_mask;
 	char sgn_mask;
 	char c;
@@ -2006,10 +2006,10 @@ static int usbdux_pwm_pattern(struct comedi_device *dev,
 	sgn_mask = (16 << channel);
 	/* this is the buffer which will be filled with the with bit */
 	/* pattern for one period */
-	szbuf = this_usbduxsub->sizePwmBuf;
-	pBuf = (char *)(this_usbduxsub->urbPwm->transfer_buffer);
+	szbuf = this_usbduxsub->size_pwm_buf;
+	p_buf = (char *)(this_usbduxsub->urb_pwm->transfer_buffer);
 	for (i = 0; i < szbuf; i++) {
-		c = *pBuf;
+		c = *p_buf;
 		/* reset bits */
 		c = c & (~pwm_mask);
 		/* set the bit as long as the index is lower than the value */
@@ -2023,7 +2023,7 @@ static int usbdux_pwm_pattern(struct comedi_device *dev,
 			/* negative value */
 			c = c | sgn_mask;
 		}
-		*(pBuf++) = c;
+		*(p_buf++) = c;
 	}
 	return 1;
 }
@@ -2095,7 +2095,7 @@ static int usbdux_pwm_config(struct comedi_device *dev,
 			"comedi%d: %s: setting period\n", dev->minor, __func__);
 		return usbdux_pwm_period(dev, s, data[1]);
 	case INSN_CONFIG_PWM_GET_PERIOD:
-		data[1] = this_usbduxsub->pwmPeriod;
+		data[1] = this_usbduxsub->pwm_period;
 		return 0;
 	case INSN_CONFIG_PWM_SET_H_BRIDGE:
 		/* value in the first byte and the sign in the second for a
@@ -2131,55 +2131,55 @@ static void tidy_up(struct usbduxsub *usbduxsub_tmp)
 
 	usbduxsub_tmp->probed = 0;
 
-	if (usbduxsub_tmp->urbIn) {
+	if (usbduxsub_tmp->urb_in) {
 		if (usbduxsub_tmp->ai_cmd_running) {
 			usbduxsub_tmp->ai_cmd_running = 0;
-			usbduxsub_unlink_InURBs(usbduxsub_tmp);
+			usbduxsub_unlink_inurbs(usbduxsub_tmp);
 		}
-		for (i = 0; i < usbduxsub_tmp->numOfInBuffers; i++) {
-			kfree(usbduxsub_tmp->urbIn[i]->transfer_buffer);
-			usbduxsub_tmp->urbIn[i]->transfer_buffer = NULL;
-			usb_kill_urb(usbduxsub_tmp->urbIn[i]);
-			usb_free_urb(usbduxsub_tmp->urbIn[i]);
-			usbduxsub_tmp->urbIn[i] = NULL;
+		for (i = 0; i < usbduxsub_tmp->num_in_buffers; i++) {
+			kfree(usbduxsub_tmp->urb_in[i]->transfer_buffer);
+			usbduxsub_tmp->urb_in[i]->transfer_buffer = NULL;
+			usb_kill_urb(usbduxsub_tmp->urb_in[i]);
+			usb_free_urb(usbduxsub_tmp->urb_in[i]);
+			usbduxsub_tmp->urb_in[i] = NULL;
 		}
-		kfree(usbduxsub_tmp->urbIn);
-		usbduxsub_tmp->urbIn = NULL;
+		kfree(usbduxsub_tmp->urb_in);
+		usbduxsub_tmp->urb_in = NULL;
 	}
-	if (usbduxsub_tmp->urbOut) {
+	if (usbduxsub_tmp->urb_out) {
 		if (usbduxsub_tmp->ao_cmd_running) {
 			usbduxsub_tmp->ao_cmd_running = 0;
-			usbduxsub_unlink_OutURBs(usbduxsub_tmp);
+			usbduxsub_unlink_outurbs(usbduxsub_tmp);
 		}
-		for (i = 0; i < usbduxsub_tmp->numOfOutBuffers; i++) {
-			kfree(usbduxsub_tmp->urbOut[i]->transfer_buffer);
-			usbduxsub_tmp->urbOut[i]->transfer_buffer = NULL;
-			if (usbduxsub_tmp->urbOut[i]) {
-				usb_kill_urb(usbduxsub_tmp->urbOut[i]);
-				usb_free_urb(usbduxsub_tmp->urbOut[i]);
-				usbduxsub_tmp->urbOut[i] = NULL;
+		for (i = 0; i < usbduxsub_tmp->num_out_buffers; i++) {
+			kfree(usbduxsub_tmp->urb_out[i]->transfer_buffer);
+			usbduxsub_tmp->urb_out[i]->transfer_buffer = NULL;
+			if (usbduxsub_tmp->urb_out[i]) {
+				usb_kill_urb(usbduxsub_tmp->urb_out[i]);
+				usb_free_urb(usbduxsub_tmp->urb_out[i]);
+				usbduxsub_tmp->urb_out[i] = NULL;
 			}
 		}
-		kfree(usbduxsub_tmp->urbOut);
-		usbduxsub_tmp->urbOut = NULL;
+		kfree(usbduxsub_tmp->urb_out);
+		usbduxsub_tmp->urb_out = NULL;
 	}
-	if (usbduxsub_tmp->urbPwm) {
+	if (usbduxsub_tmp->urb_pwm) {
 		if (usbduxsub_tmp->pwm_cmd_running) {
 			usbduxsub_tmp->pwm_cmd_running = 0;
-			usbduxsub_unlink_PwmURBs(usbduxsub_tmp);
+			usbduxsub_unlink_pwm_urbs(usbduxsub_tmp);
 		}
-		kfree(usbduxsub_tmp->urbPwm->transfer_buffer);
-		usbduxsub_tmp->urbPwm->transfer_buffer = NULL;
-		usb_kill_urb(usbduxsub_tmp->urbPwm);
-		usb_free_urb(usbduxsub_tmp->urbPwm);
-		usbduxsub_tmp->urbPwm = NULL;
-	}
-	kfree(usbduxsub_tmp->inBuffer);
-	usbduxsub_tmp->inBuffer = NULL;
-	kfree(usbduxsub_tmp->insnBuffer);
-	usbduxsub_tmp->insnBuffer = NULL;
-	kfree(usbduxsub_tmp->outBuffer);
-	usbduxsub_tmp->outBuffer = NULL;
+		kfree(usbduxsub_tmp->urb_pwm->transfer_buffer);
+		usbduxsub_tmp->urb_pwm->transfer_buffer = NULL;
+		usb_kill_urb(usbduxsub_tmp->urb_pwm);
+		usb_free_urb(usbduxsub_tmp->urb_pwm);
+		usbduxsub_tmp->urb_pwm = NULL;
+	}
+	kfree(usbduxsub_tmp->in_buffer);
+	usbduxsub_tmp->in_buffer = NULL;
+	kfree(usbduxsub_tmp->insn_buffer);
+	usbduxsub_tmp->insn_buffer = NULL;
+	kfree(usbduxsub_tmp->out_buffer);
+	usbduxsub_tmp->out_buffer = NULL;
 	kfree(usbduxsub_tmp->dac_commands);
 	usbduxsub_tmp->dac_commands = NULL;
 	kfree(usbduxsub_tmp->dux_commands);
@@ -2302,7 +2302,7 @@ static int usbdux_attach_common(struct comedi_device *dev,
 		s->subdev_flags = SDF_WRITABLE | SDF_PWM_HBRIDGE;
 		s->n_chan = 8;
 		/* this defines the max duty cycle resolution */
-		s->maxdata = udev->sizePwmBuf;
+		s->maxdata = udev->size_pwm_buf;
 		s->insn_write = usbdux_pwm_write;
 		s->insn_read = usbdux_pwm_read;
 		s->insn_config = usbdux_pwm_config;
@@ -2381,7 +2381,7 @@ static void usbdux_firmware_request_complete_handler(const struct firmware *fw,
 	 * we need to upload the firmware here because fw will be
 	 * freed once we've left this function
 	 */
-	ret = firmwareUpload(usbduxsub_tmp, fw->data, fw->size);
+	ret = firmware_upload(usbduxsub_tmp, fw->data, fw->size);
 
 	if (ret) {
 		dev_err(&uinterf->dev,
@@ -2457,22 +2457,22 @@ static int usbdux_usb_probe(struct usb_interface *uinterf,
 		return -ENOMEM;
 	}
 	/* create space for the in buffer and set it to zero */
-	usbduxsub[index].inBuffer = kzalloc(SIZEINBUF, GFP_KERNEL);
-	if (!(usbduxsub[index].inBuffer)) {
+	usbduxsub[index].in_buffer = kzalloc(SIZEINBUF, GFP_KERNEL);
+	if (!(usbduxsub[index].in_buffer)) {
 		tidy_up(&(usbduxsub[index]));
 		up(&start_stop_sem);
 		return -ENOMEM;
 	}
 	/* create space of the instruction buffer */
-	usbduxsub[index].insnBuffer = kzalloc(SIZEINSNBUF, GFP_KERNEL);
-	if (!(usbduxsub[index].insnBuffer)) {
+	usbduxsub[index].insn_buffer = kzalloc(SIZEINSNBUF, GFP_KERNEL);
+	if (!(usbduxsub[index].insn_buffer)) {
 		tidy_up(&(usbduxsub[index]));
 		up(&start_stop_sem);
 		return -ENOMEM;
 	}
 	/* create space for the outbuffer */
-	usbduxsub[index].outBuffer = kzalloc(SIZEOUTBUF, GFP_KERNEL);
-	if (!(usbduxsub[index].outBuffer)) {
+	usbduxsub[index].out_buffer = kzalloc(SIZEOUTBUF, GFP_KERNEL);
+	if (!(usbduxsub[index].out_buffer)) {
 		tidy_up(&(usbduxsub[index]));
 		up(&start_stop_sem);
 		return -ENOMEM;
@@ -2489,124 +2489,124 @@ static int usbdux_usb_probe(struct usb_interface *uinterf,
 		return -ENODEV;
 	}
 	if (usbduxsub[index].high_speed)
-		usbduxsub[index].numOfInBuffers = NUMOFINBUFFERSHIGH;
+		usbduxsub[index].num_in_buffers = NUMOFINBUFFERSHIGH;
 	else
-		usbduxsub[index].numOfInBuffers = NUMOFINBUFFERSFULL;
+		usbduxsub[index].num_in_buffers = NUMOFINBUFFERSFULL;
 
-	usbduxsub[index].urbIn =
-		kcalloc(usbduxsub[index].numOfInBuffers, sizeof(struct urb *),
+	usbduxsub[index].urb_in =
+		kcalloc(usbduxsub[index].num_in_buffers, sizeof(struct urb *),
 			GFP_KERNEL);
-	if (!(usbduxsub[index].urbIn)) {
+	if (!(usbduxsub[index].urb_in)) {
 		tidy_up(&(usbduxsub[index]));
 		up(&start_stop_sem);
 		return -ENOMEM;
 	}
-	for (i = 0; i < usbduxsub[index].numOfInBuffers; i++) {
+	for (i = 0; i < usbduxsub[index].num_in_buffers; i++) {
 		/* one frame: 1ms */
-		usbduxsub[index].urbIn[i] = usb_alloc_urb(1, GFP_KERNEL);
-		if (usbduxsub[index].urbIn[i] == NULL) {
+		usbduxsub[index].urb_in[i] = usb_alloc_urb(1, GFP_KERNEL);
+		if (usbduxsub[index].urb_in[i] == NULL) {
 			dev_err(dev, "comedi_: usbdux%d: "
 				"Could not alloc. urb(%d)\n", index, i);
 			tidy_up(&(usbduxsub[index]));
 			up(&start_stop_sem);
 			return -ENOMEM;
 		}
-		usbduxsub[index].urbIn[i]->dev = usbduxsub[index].usbdev;
+		usbduxsub[index].urb_in[i]->dev = usbduxsub[index].usbdev;
 		/* will be filled later with a pointer to the comedi-device */
 		/* and ONLY then the urb should be submitted */
-		usbduxsub[index].urbIn[i]->context = NULL;
-		usbduxsub[index].urbIn[i]->pipe =
+		usbduxsub[index].urb_in[i]->context = NULL;
+		usbduxsub[index].urb_in[i]->pipe =
 		    usb_rcvisocpipe(usbduxsub[index].usbdev, ISOINEP);
-		usbduxsub[index].urbIn[i]->transfer_flags = URB_ISO_ASAP;
-		usbduxsub[index].urbIn[i]->transfer_buffer =
+		usbduxsub[index].urb_in[i]->transfer_flags = URB_ISO_ASAP;
+		usbduxsub[index].urb_in[i]->transfer_buffer =
 		    kzalloc(SIZEINBUF, GFP_KERNEL);
-		if (!(usbduxsub[index].urbIn[i]->transfer_buffer)) {
+		if (!(usbduxsub[index].urb_in[i]->transfer_buffer)) {
 			tidy_up(&(usbduxsub[index]));
 			up(&start_stop_sem);
 			return -ENOMEM;
 		}
-		usbduxsub[index].urbIn[i]->complete = usbduxsub_ai_IsocIrq;
-		usbduxsub[index].urbIn[i]->number_of_packets = 1;
-		usbduxsub[index].urbIn[i]->transfer_buffer_length = SIZEINBUF;
-		usbduxsub[index].urbIn[i]->iso_frame_desc[0].offset = 0;
-		usbduxsub[index].urbIn[i]->iso_frame_desc[0].length = SIZEINBUF;
+		usbduxsub[index].urb_in[i]->complete = usbduxsub_ai_isoc_irq;
+		usbduxsub[index].urb_in[i]->number_of_packets = 1;
+		usbduxsub[index].urb_in[i]->transfer_buffer_length = SIZEINBUF;
+		usbduxsub[index].urb_in[i]->iso_frame_desc[0].offset = 0;
+		usbduxsub[index].urb_in[i]->iso_frame_desc[0].length = SIZEINBUF;
 	}
 
 	/* out */
 	if (usbduxsub[index].high_speed)
-		usbduxsub[index].numOfOutBuffers = NUMOFOUTBUFFERSHIGH;
+		usbduxsub[index].num_out_buffers = NUMOFOUTBUFFERSHIGH;
 	else
-		usbduxsub[index].numOfOutBuffers = NUMOFOUTBUFFERSFULL;
+		usbduxsub[index].num_out_buffers = NUMOFOUTBUFFERSFULL;
 
-	usbduxsub[index].urbOut =
-		kcalloc(usbduxsub[index].numOfOutBuffers, sizeof(struct urb *),
+	usbduxsub[index].urb_out =
+		kcalloc(usbduxsub[index].num_out_buffers, sizeof(struct urb *),
 			GFP_KERNEL);
-	if (!(usbduxsub[index].urbOut)) {
+	if (!(usbduxsub[index].urb_out)) {
 		tidy_up(&(usbduxsub[index]));
 		up(&start_stop_sem);
 		return -ENOMEM;
 	}
-	for (i = 0; i < usbduxsub[index].numOfOutBuffers; i++) {
+	for (i = 0; i < usbduxsub[index].num_out_buffers; i++) {
 		/* one frame: 1ms */
-		usbduxsub[index].urbOut[i] = usb_alloc_urb(1, GFP_KERNEL);
-		if (usbduxsub[index].urbOut[i] == NULL) {
+		usbduxsub[index].urb_out[i] = usb_alloc_urb(1, GFP_KERNEL);
+		if (usbduxsub[index].urb_out[i] == NULL) {
 			dev_err(dev, "comedi_: usbdux%d: "
 				"Could not alloc. urb(%d)\n", index, i);
 			tidy_up(&(usbduxsub[index]));
 			up(&start_stop_sem);
 			return -ENOMEM;
 		}
-		usbduxsub[index].urbOut[i]->dev = usbduxsub[index].usbdev;
+		usbduxsub[index].urb_out[i]->dev = usbduxsub[index].usbdev;
 		/* will be filled later with a pointer to the comedi-device */
 		/* and ONLY then the urb should be submitted */
-		usbduxsub[index].urbOut[i]->context = NULL;
-		usbduxsub[index].urbOut[i]->pipe =
+		usbduxsub[index].urb_out[i]->context = NULL;
+		usbduxsub[index].urb_out[i]->pipe =
 		    usb_sndisocpipe(usbduxsub[index].usbdev, ISOOUTEP);
-		usbduxsub[index].urbOut[i]->transfer_flags = URB_ISO_ASAP;
-		usbduxsub[index].urbOut[i]->transfer_buffer =
+		usbduxsub[index].urb_out[i]->transfer_flags = URB_ISO_ASAP;
+		usbduxsub[index].urb_out[i]->transfer_buffer =
 		    kzalloc(SIZEOUTBUF, GFP_KERNEL);
-		if (!(usbduxsub[index].urbOut[i]->transfer_buffer)) {
+		if (!(usbduxsub[index].urb_out[i]->transfer_buffer)) {
 			tidy_up(&(usbduxsub[index]));
 			up(&start_stop_sem);
 			return -ENOMEM;
 		}
-		usbduxsub[index].urbOut[i]->complete = usbduxsub_ao_IsocIrq;
-		usbduxsub[index].urbOut[i]->number_of_packets = 1;
-		usbduxsub[index].urbOut[i]->transfer_buffer_length = SIZEOUTBUF;
-		usbduxsub[index].urbOut[i]->iso_frame_desc[0].offset = 0;
-		usbduxsub[index].urbOut[i]->iso_frame_desc[0].length =
+		usbduxsub[index].urb_out[i]->complete = usbduxsub_ao_isoc_irq;
+		usbduxsub[index].urb_out[i]->number_of_packets = 1;
+		usbduxsub[index].urb_out[i]->transfer_buffer_length = SIZEOUTBUF;
+		usbduxsub[index].urb_out[i]->iso_frame_desc[0].offset = 0;
+		usbduxsub[index].urb_out[i]->iso_frame_desc[0].length =
 		    SIZEOUTBUF;
 		if (usbduxsub[index].high_speed) {
 			/* uframes */
-			usbduxsub[index].urbOut[i]->interval = 8;
+			usbduxsub[index].urb_out[i]->interval = 8;
 		} else {
 			/* frames */
-			usbduxsub[index].urbOut[i]->interval = 1;
+			usbduxsub[index].urb_out[i]->interval = 1;
 		}
 	}
 
 	/* pwm */
 	if (usbduxsub[index].high_speed) {
 		/* max bulk ep size in high speed */
-		usbduxsub[index].sizePwmBuf = 512;
-		usbduxsub[index].urbPwm = usb_alloc_urb(0, GFP_KERNEL);
-		if (usbduxsub[index].urbPwm == NULL) {
+		usbduxsub[index].size_pwm_buf = 512;
+		usbduxsub[index].urb_pwm = usb_alloc_urb(0, GFP_KERNEL);
+		if (usbduxsub[index].urb_pwm == NULL) {
 			dev_err(dev, "comedi_: usbdux%d: "
 				"Could not alloc. pwm urb\n", index);
 			tidy_up(&(usbduxsub[index]));
 			up(&start_stop_sem);
 			return -ENOMEM;
 		}
-		usbduxsub[index].urbPwm->transfer_buffer =
-		    kzalloc(usbduxsub[index].sizePwmBuf, GFP_KERNEL);
-		if (!(usbduxsub[index].urbPwm->transfer_buffer)) {
+		usbduxsub[index].urb_pwm->transfer_buffer =
+		    kzalloc(usbduxsub[index].size_pwm_buf, GFP_KERNEL);
+		if (!(usbduxsub[index].urb_pwm->transfer_buffer)) {
 			tidy_up(&(usbduxsub[index]));
 			up(&start_stop_sem);
 			return -ENOMEM;
 		}
 	} else {
-		usbduxsub[index].urbPwm = NULL;
-		usbduxsub[index].sizePwmBuf = 0;
+		usbduxsub[index].urb_pwm = NULL;
+		usbduxsub[index].size_pwm_buf = 0;
 	}
 
 	usbduxsub[index].ai_cmd_running = 0;
-- 
1.7.9.5


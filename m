Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753707AbaDDWQb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 18:16:31 -0400
Received: from smtprelay0239.hostedemail.com ([216.40.44.239]:57924 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753061AbaDDWQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 18:16:21 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:4:41:69:355:379:541:800:960:966:968:973:988:989:1260:1345:1359:1437:1605:1730:1747:1777:1792:2196:2199:2393:2559:2562:2898:3138:3139:3140:3141:3142:3865:3866:3867:3868:3870:3872:4250:4321:4384:4385:4395:5007:6119:6261:7875:8957:9040:10004:10026:10226:10394:10848:11026:11473:11658:11914:12043:12294:12296:12438:12517:12519:12555:12681:12683:13972:14110,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: jelly96_715eb1b17f547
X-Filterd-Recvd-Size: 17535
From: Joe Perches <joe@perches.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] usb: ftdi-elan: Coalesce formats
Date: Fri,  4 Apr 2014 15:16:05 -0700
Message-Id: <0981d9f225c8d04741f0fb4b0129acea72858185.1396649386.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1396649386.git.joe@perches.com>
References: <cover.1396649386.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make it easier to find formats.

Realign arguments around these changes.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/usb/misc/ftdi-elan.c | 151 ++++++++++++++++---------------------------
 1 file changed, 56 insertions(+), 95 deletions(-)

diff --git a/drivers/usb/misc/ftdi-elan.c b/drivers/usb/misc/ftdi-elan.c
index 0487f8e..8cda881 100644
--- a/drivers/usb/misc/ftdi-elan.c
+++ b/drivers/usb/misc/ftdi-elan.c
@@ -545,11 +545,10 @@ static void ftdi_elan_status_work(struct work_struct *work)
 			ftdi->stuck_status = 0;
 			ftdi->synchronized = 0;
 		} else if ((ftdi->stuck_status++ % 60) == 1) {
-			dev_err(&ftdi->udev->dev, "WRONG type of card inserted "
-				"- please remove\n");
+			dev_err(&ftdi->udev->dev, "WRONG type of card inserted - please remove\n");
 		} else
-			dev_err(&ftdi->udev->dev, "WRONG type of card inserted "
-				"- checked %d times\n", ftdi->stuck_status);
+			dev_err(&ftdi->udev->dev, "WRONG type of card inserted - checked %d times\n",
+				ftdi->stuck_status);
 		work_delay_in_msec = 100;
 	} else if (ftdi->enumerated == 0) {
 		if (ftdi_elan_enumeratePCI(ftdi) == 0) {
@@ -562,8 +561,7 @@ static void ftdi_elan_status_work(struct work_struct *work)
 			ftdi->initialized = 1;
 			work_delay_in_msec = 500;
 		} else {
-			dev_err(&ftdi->udev->dev, "initialized failed - trying "
-				"again in 10 seconds\n");
+			dev_err(&ftdi->udev->dev, "initialized failed - trying again in 10 seconds\n");
 			work_delay_in_msec = 1 *1000;
 		}
 	} else if (ftdi->registered == 0) {
@@ -578,9 +576,7 @@ static void ftdi_elan_status_work(struct work_struct *work)
 			work_delay_in_msec = 250;
 		} else if (ftdi->controlreg & 0x00400000) {
 			if (ftdi->gone_away > 0) {
-				dev_err(&ftdi->udev->dev, "PCI device eject con"
-					"firmed platform_dev.dev.parent=%p plat"
-					"form_dev.dev=%p\n",
+				dev_err(&ftdi->udev->dev, "PCI device eject confirmed platform_dev.dev.parent=%p platform_dev.dev=%p\n",
 					ftdi->platform_dev.dev.parent,
 					&ftdi->platform_dev.dev);
 				platform_device_unregister(&ftdi->platform_dev);
@@ -788,17 +784,15 @@ static int ftdi_elan_command_engine(struct usb_ftdi *ftdi)
 	total_size = ftdi_elan_total_command_size(ftdi, command_size);
 	urb = usb_alloc_urb(0, GFP_KERNEL);
 	if (!urb) {
-		dev_err(&ftdi->udev->dev, "could not get a urb to write %d comm"
-			"ands totaling %d bytes to the Uxxx\n", command_size,
-			total_size);
+		dev_err(&ftdi->udev->dev, "could not get a urb to write %d commands totaling %d bytes to the Uxxx\n",
+			command_size, total_size);
 		return -ENOMEM;
 	}
 	buf = usb_alloc_coherent(ftdi->udev, total_size, GFP_KERNEL,
 				 &urb->transfer_dma);
 	if (!buf) {
-		dev_err(&ftdi->udev->dev, "could not get a buffer to write %d c"
-			"ommands totaling %d bytes to the Uxxx\n", command_size,
-			total_size);
+		dev_err(&ftdi->udev->dev, "could not get a buffer to write %d commands totaling %d bytes to the Uxxx\n",
+			command_size, total_size);
 		usb_free_urb(urb);
 		return -ENOMEM;
 	}
@@ -824,9 +818,8 @@ static int ftdi_elan_command_engine(struct usb_ftdi *ftdi)
 	}
 	retval = usb_submit_urb(urb, GFP_KERNEL);
 	if (retval) {
-		dev_err(&ftdi->udev->dev, "failed %d to submit urb %p to write "
-			"%d commands totaling %d bytes to the Uxxx\n", retval,
-			urb, command_size, total_size);
+		dev_err(&ftdi->udev->dev, "failed %d to submit urb %p to write %d commands totaling %d bytes to the Uxxx\n",
+			retval, urb, command_size, total_size);
 		usb_free_coherent(ftdi->udev, total_size, buf, urb->transfer_dma);
 		usb_free_urb(urb);
 		return retval;
@@ -980,8 +973,7 @@ read:{
 			goto have;
 		} else if (retval == -ETIMEDOUT) {
 			if (retry_on_timeout-- > 0) {
-				dev_err(&ftdi->udev->dev, "TIMED OUT with packe"
-					"t_bytes = %d with total %d bytes%s\n",
+				dev_err(&ftdi->udev->dev, "TIMED OUT with packet_bytes = %d with total %d bytes%s\n",
 					packet_bytes, bytes_read, diag);
 				goto more;
 			} else if (bytes_read > 0) {
@@ -989,20 +981,17 @@ read:{
 					bytes_read, diag);
 				return -ENOMEM;
 			} else {
-				dev_err(&ftdi->udev->dev, "TIMED OUT with packe"
-					"t_bytes = %d with total %d bytes%s\n",
+				dev_err(&ftdi->udev->dev, "TIMED OUT with packet_bytes = %d with total %d bytes%s\n",
 					packet_bytes, bytes_read, diag);
 				return -ENOMEM;
 			}
 		} else if (retval == -EILSEQ) {
-			dev_err(&ftdi->udev->dev, "error = %d with packet_bytes"
-				" = %d with total %d bytes%s\n", retval,
-				packet_bytes, bytes_read, diag);
+			dev_err(&ftdi->udev->dev, "error = %d with packet_bytes = %d with total %d bytes%s\n",
+				retval, packet_bytes, bytes_read, diag);
 			return retval;
 		} else if (retval) {
-			dev_err(&ftdi->udev->dev, "error = %d with packet_bytes"
-				" = %d with total %d bytes%s\n", retval,
-				packet_bytes, bytes_read, diag);
+			dev_err(&ftdi->udev->dev, "error = %d with packet_bytes = %d with total %d bytes%s\n",
+				retval, packet_bytes, bytes_read, diag);
 			return retval;
 		} else if (packet_bytes == 2) {
 			unsigned char s0 = ftdi->bulk_in_buffer[0];
@@ -1099,8 +1088,8 @@ have:if (ftdi->bulk_in_left > 0) {
 			} else if (buscmd == 0x06) {
 			} else if (buscmd == 0x0A) {
 			} else
-				dev_err(&ftdi->udev->dev, "Uxxx unknown(%0X) va"
-					"lue = %08X\n", buscmd, data);
+				dev_err(&ftdi->udev->dev, "Uxxx unknown(%0X) value = %08X\n",
+					buscmd, data);
 			goto have;
 		} else {
 			if ((ftdi->response[0] & 0x80) == 0x00) {
@@ -1909,35 +1898,31 @@ more:{
 			} else if (retry_on_status-- > 0) {
 				goto more;
 			} else {
-				dev_err(&ftdi->udev->dev, "STATUS ERROR retry l"
-					"imit reached\n");
+				dev_err(&ftdi->udev->dev, "STATUS ERROR retry limit reached\n");
 				return -EFAULT;
 			}
 		} else if (packet_bytes > 0) {
 			char b1 = ftdi->bulk_in_buffer[0];
-			dev_err(&ftdi->udev->dev, "only one byte flushed from F"
-				"TDI = %02X\n", b1);
+			dev_err(&ftdi->udev->dev, "only one byte flushed from FTDI = %02X\n",
+				b1);
 			if (retry_on_status-- > 0) {
 				goto more;
 			} else {
-				dev_err(&ftdi->udev->dev, "STATUS ERROR retry l"
-					"imit reached\n");
+				dev_err(&ftdi->udev->dev, "STATUS ERROR retry limit reached\n");
 				return -EFAULT;
 			}
 		} else if (retval == -ETIMEDOUT) {
 			if (retry_on_timeout-- > 0) {
 				goto more;
 			} else {
-				dev_err(&ftdi->udev->dev, "TIMED OUT retry limi"
-					"t reached\n");
+				dev_err(&ftdi->udev->dev, "TIMED OUT retry limit reached\n");
 				return -ENOMEM;
 			}
 		} else if (retval == 0) {
 			if (retry_on_empty-- > 0) {
 				goto more;
 			} else {
-				dev_err(&ftdi->udev->dev, "empty packet retry l"
-					"imit reached\n");
+				dev_err(&ftdi->udev->dev, "empty packet retry limit reached\n");
 				return -ENOMEM;
 			}
 		} else {
@@ -1962,14 +1947,12 @@ static int ftdi_elan_synchronize_flush(struct usb_ftdi *ftdi)
 	int i = 0;
 	urb = usb_alloc_urb(0, GFP_KERNEL);
 	if (!urb) {
-		dev_err(&ftdi->udev->dev, "could not alloc a urb for flush sequ"
-			"ence\n");
+		dev_err(&ftdi->udev->dev, "could not alloc a urb for flush sequence\n");
 		return -ENOMEM;
 	}
 	buf = usb_alloc_coherent(ftdi->udev, I, GFP_KERNEL, &urb->transfer_dma);
 	if (!buf) {
-		dev_err(&ftdi->udev->dev, "could not get a buffer for flush seq"
-			"uence\n");
+		dev_err(&ftdi->udev->dev, "could not get a buffer for flush sequence\n");
 		usb_free_urb(urb);
 		return -ENOMEM;
 	}
@@ -1981,8 +1964,7 @@ static int ftdi_elan_synchronize_flush(struct usb_ftdi *ftdi)
 	urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
 	retval = usb_submit_urb(urb, GFP_KERNEL);
 	if (retval) {
-		dev_err(&ftdi->udev->dev, "failed to submit urb containing the "
-			"flush sequence\n");
+		dev_err(&ftdi->udev->dev, "failed to submit urb containing the flush sequence\n");
 		usb_free_coherent(ftdi->udev, i, buf, urb->transfer_dma);
 		usb_free_urb(urb);
 		return -ENOMEM;
@@ -2005,14 +1987,12 @@ static int ftdi_elan_synchronize_reset(struct usb_ftdi *ftdi)
 	int i = 0;
 	urb = usb_alloc_urb(0, GFP_KERNEL);
 	if (!urb) {
-		dev_err(&ftdi->udev->dev, "could not get a urb for the reset se"
-			"quence\n");
+		dev_err(&ftdi->udev->dev, "could not get a urb for the reset sequence\n");
 		return -ENOMEM;
 	}
 	buf = usb_alloc_coherent(ftdi->udev, I, GFP_KERNEL, &urb->transfer_dma);
 	if (!buf) {
-		dev_err(&ftdi->udev->dev, "could not get a buffer for the reset"
-			" sequence\n");
+		dev_err(&ftdi->udev->dev, "could not get a buffer for the reset sequence\n");
 		usb_free_urb(urb);
 		return -ENOMEM;
 	}
@@ -2026,8 +2006,7 @@ static int ftdi_elan_synchronize_reset(struct usb_ftdi *ftdi)
 	urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
 	retval = usb_submit_urb(urb, GFP_KERNEL);
 	if (retval) {
-		dev_err(&ftdi->udev->dev, "failed to submit urb containing the "
-			"reset sequence\n");
+		dev_err(&ftdi->udev->dev, "failed to submit urb containing the reset sequence\n");
 		usb_free_coherent(ftdi->udev, i, buf, urb->transfer_dma);
 		usb_free_urb(urb);
 		return -ENOMEM;
@@ -2095,8 +2074,7 @@ static int ftdi_elan_synchronize(struct usb_ftdi *ftdi)
 					} else if (read_stop-- > 0) {
 						goto read;
 					} else {
-						dev_err(&ftdi->udev->dev, "retr"
-							"y limit reached\n");
+						dev_err(&ftdi->udev->dev, "retry limit reached\n");
 						continue;
 					}
 				}
@@ -2112,16 +2090,14 @@ static int ftdi_elan_synchronize(struct usb_ftdi *ftdi)
 					if (read_stop-- > 0) {
 						goto read;
 					} else {
-						dev_err(&ftdi->udev->dev, "retr"
-							"y limit reached\n");
+						dev_err(&ftdi->udev->dev, "retry limit reached\n");
 						continue;
 					}
 				} else {
 					if (read_stop-- > 0) {
 						goto read;
 					} else {
-						dev_err(&ftdi->udev->dev, "retr"
-							"y limit reached\n");
+						dev_err(&ftdi->udev->dev, "retry limit reached\n");
 						continue;
 					}
 				}
@@ -2129,24 +2105,21 @@ static int ftdi_elan_synchronize(struct usb_ftdi *ftdi)
 				if (read_stop-- > 0) {
 					goto read;
 				} else {
-					dev_err(&ftdi->udev->dev, "retry limit "
-						"reached\n");
+					dev_err(&ftdi->udev->dev, "retry limit reached\n");
 					continue;
 				}
 			} else if (retval == -ETIMEDOUT) {
 				if (retry_on_timeout-- > 0) {
 					goto read;
 				} else {
-					dev_err(&ftdi->udev->dev, "TIMED OUT re"
-						"try limit reached\n");
+					dev_err(&ftdi->udev->dev, "TIMED OUT retry limit reached\n");
 					continue;
 				}
 			} else if (retval == 0) {
 				if (retry_on_empty-- > 0) {
 					goto read;
 				} else {
-					dev_err(&ftdi->udev->dev, "empty packet"
-						" retry limit reached\n");
+					dev_err(&ftdi->udev->dev, "empty packet retry limit reached\n");
 					continue;
 				}
 			} else {
@@ -2156,8 +2129,7 @@ static int ftdi_elan_synchronize(struct usb_ftdi *ftdi)
 				if (read_stop-- > 0) {
 					goto read;
 				} else {
-					dev_err(&ftdi->udev->dev, "retry limit "
-						"reached\n");
+					dev_err(&ftdi->udev->dev, "retry limit reached\n");
 					continue;
 				}
 			}
@@ -2209,30 +2181,26 @@ more:{
 				return -EFAULT;
 		} else if (packet_bytes > 0) {
 			char b1 = ftdi->bulk_in_buffer[0];
-			dev_err(&ftdi->udev->dev, "only one byte flushed from F"
-				"TDI = %02X\n", b1);
+			dev_err(&ftdi->udev->dev, "only one byte flushed from FTDI = %02X\n", b1);
 			if (retry_on_status-- > 0) {
 				msleep(5);
 				goto more;
 			} else {
-				dev_err(&ftdi->udev->dev, "STATUS ERROR retry l"
-					"imit reached\n");
+				dev_err(&ftdi->udev->dev, "STATUS ERROR retry limit reached\n");
 				return -EFAULT;
 			}
 		} else if (retval == -ETIMEDOUT) {
 			if (retry_on_timeout-- > 0) {
 				goto more;
 			} else {
-				dev_err(&ftdi->udev->dev, "TIMED OUT retry limi"
-					"t reached\n");
+				dev_err(&ftdi->udev->dev, "TIMED OUT retry limit reached\n");
 				return -ENOMEM;
 			}
 		} else if (retval == 0) {
 			if (retry_on_empty-- > 0) {
 				goto more;
 			} else {
-				dev_err(&ftdi->udev->dev, "empty packet retry l"
-					"imit reached\n");
+				dev_err(&ftdi->udev->dev, "empty packet retry limit reached\n");
 				return -ENOMEM;
 			}
 		} else {
@@ -2252,8 +2220,8 @@ static int ftdi_elan_checkingPCI(struct usb_ftdi *ftdi)
 		if (ftdi->card_ejected) {
 		} else {
 			ftdi->card_ejected = 1;
-			dev_err(&ftdi->udev->dev, "CARD EJECTED - controlreg = "
-				"%08X\n", ftdi->controlreg);
+			dev_err(&ftdi->udev->dev, "CARD EJECTED - controlreg = %08X\n",
+				ftdi->controlreg);
 		}
 		return -ENODEV;
 	} else {
@@ -2273,8 +2241,7 @@ static int ftdi_elan_checkingPCI(struct usb_ftdi *ftdi)
 		    ftdi->platform_data.device) {
 			return 0;
 		} else {
-			dev_err(&ftdi->udev->dev, "vendor=%04X pciVID=%04X devi"
-				"ce=%04X pciPID=%04X\n",
+			dev_err(&ftdi->udev->dev, "vendor=%04X pciVID=%04X device=%04X pciPID=%04X\n",
 				ftdi->platform_data.vendor, pciVID,
 				ftdi->platform_data.device, pciPID);
 			return -ENODEV;
@@ -2378,8 +2345,7 @@ extra:{
 			return retval;
 		if (0 != (status & OHCI_HCR)) {
 			if (--reset_timeout == 0) {
-				dev_err(&ftdi->udev->dev, "USB HC reset timed o"
-					"ut!\n");
+				dev_err(&ftdi->udev->dev, "USB HC reset timed out!\n");
 				return -ENODEV;
 			} else {
 				msleep(5);
@@ -2782,8 +2748,7 @@ static int ftdi_elan_probe(struct usb_interface *interface,
 			ftdi->bulk_in_endpointAddr = endpoint->bEndpointAddress;
 			ftdi->bulk_in_buffer = kmalloc(buffer_size, GFP_KERNEL);
 			if (!ftdi->bulk_in_buffer) {
-				dev_err(&ftdi->udev->dev, "Could not allocate b"
-					"ulk_in_buffer\n");
+				dev_err(&ftdi->udev->dev, "Could not allocate bulk_in_buffer\n");
 				retval = -ENOMEM;
 				goto error;
 			}
@@ -2795,8 +2760,7 @@ static int ftdi_elan_probe(struct usb_interface *interface,
 		}
 	}
 	if (!(ftdi->bulk_in_endpointAddr && ftdi->bulk_out_endpointAddr)) {
-		dev_err(&ftdi->udev->dev, "Could not find both bulk-in and bulk"
-			"-out endpoints\n");
+		dev_err(&ftdi->udev->dev, "Could not find both bulk-in and bulk-out endpoints\n");
 		retval = -ENODEV;
 		goto error;
 	}
@@ -2809,16 +2773,14 @@ static int ftdi_elan_probe(struct usb_interface *interface,
 	    ftdi->bulk_out_endpointAddr == 0x02) {
 		retval = usb_register_dev(interface, &ftdi_elan_jtag_class);
 		if (retval) {
-			dev_err(&ftdi->udev->dev, "Not able to get a minor for "
-				"this device.\n");
+			dev_err(&ftdi->udev->dev, "Not able to get a minor for this device\n");
 			usb_set_intfdata(interface, NULL);
 			retval = -ENOMEM;
 			goto error;
 		} else {
 			ftdi->class = &ftdi_elan_jtag_class;
-			dev_info(&ftdi->udev->dev, "USB FDTI=%p JTAG interface "
-				 "%d now attached to ftdi%d\n", ftdi,
-				 iface_desc->desc.bInterfaceNumber,
+			dev_info(&ftdi->udev->dev, "USB FDTI=%p JTAG interface %d now attached to ftdi%d\n",
+				 ftdi, iface_desc->desc.bInterfaceNumber,
 				 interface->minor);
 			return 0;
 		}
@@ -2826,8 +2788,8 @@ static int ftdi_elan_probe(struct usb_interface *interface,
 		   ftdi->bulk_in_endpointAddr == 0x83 &&
 		   ftdi->bulk_out_endpointAddr == 0x04) {
 		ftdi->class = NULL;
-		dev_info(&ftdi->udev->dev, "USB FDTI=%p ELAN interface %d now a"
-			 "ctivated\n", ftdi, iface_desc->desc.bInterfaceNumber);
+		dev_info(&ftdi->udev->dev, "USB FDTI=%p ELAN interface %d now activated\n",
+			 ftdi, iface_desc->desc.bInterfaceNumber);
 		INIT_DELAYED_WORK(&ftdi->status_work, ftdi_elan_status_work);
 		INIT_DELAYED_WORK(&ftdi->command_work, ftdi_elan_command_work);
 		INIT_DELAYED_WORK(&ftdi->respond_work, ftdi_elan_respond_work);
@@ -2854,8 +2816,8 @@ static void ftdi_elan_disconnect(struct usb_interface *interface)
 		struct usb_class_driver *class = ftdi->class;
 		usb_set_intfdata(interface, NULL);
 		usb_deregister_dev(interface, class);
-		dev_info(&ftdi->udev->dev, "USB FTDI U132 jtag interface on min"
-			 "or %d now disconnected\n", minor);
+		dev_info(&ftdi->udev->dev, "USB FTDI U132 jtag interface on minor %d now disconnected\n",
+			 minor);
 	} else {
 		ftdi_status_cancel_work(ftdi);
 		ftdi_command_cancel_work(ftdi);
@@ -2874,8 +2836,7 @@ static void ftdi_elan_disconnect(struct usb_interface *interface)
 		flush_workqueue(respond_queue);
 		ftdi->disconnected += 1;
 		usb_set_intfdata(interface, NULL);
-		dev_info(&ftdi->udev->dev, "USB FTDI U132 host controller inter"
-			 "face now disconnected\n");
+		dev_info(&ftdi->udev->dev, "USB FTDI U132 host controller interface now disconnected\n");
 	}
 	ftdi_elan_put_kref(ftdi);
 }
-- 
1.8.1.2.459.gbcd45b4.dirty


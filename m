Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757853AbaEJTzw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 15:55:52 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:50125 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757805AbaEJTzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 15:55:48 -0400
From: Artem Fetishev <wwctrsrx@gmail.com>
To: joe@perches.com, marek.belisko@gmail.com, gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, Artem Fetishev <wwctrsrx@gmail.com>
Subject: [PATCH v2 5/5] drivers: staging: ft1000: Fix lines over 80 characters
Date: Sun, 11 May 2014 10:54:24 +0300
Message-Id: <1399794864-28705-6-git-send-email-wwctrsrx@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1399794864-28705-1-git-send-email-wwctrsrx@gmail.com>
References: <1399794864-28705-1-git-send-email-wwctrsrx@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

...plus some function arg indentation which I haven't noticed at first.

Signed-off-by: Artem Fetishev <wwctrsrx@gmail.com>
---
 drivers/staging/ft1000/ft1000-pcmcia/ft1000.h    |   15 +++++---
 drivers/staging/ft1000/ft1000-usb/ft1000_ioctl.h |   40 ++++++++++++++++------
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.h   |   35 +++++++++++--------
 drivers/staging/ft1000/ft1000.h                  |    7 ++--
 4 files changed, 64 insertions(+), 33 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-pcmcia/ft1000.h b/drivers/staging/ft1000/ft1000-pcmcia/ft1000.h
index 65f7ab6..0c21ac6 100644
--- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000.h
+++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000.h
@@ -25,7 +25,10 @@
 
 #define FT1000_DPRAM_BASE	0x0000	/* Dual Port RAM starting offset */
 
-/* Maximum number of occurrence of pseudo header errors before resetting PC Card. */
+/*
+ * Maximum number of occurrence of pseudo header errors before resetting PC
+ * Card.
+ */
 #define MAX_PH_ERR	300
 
 #define SUCCESS	0x00
@@ -40,16 +43,17 @@ struct ft1000_pcmcia {
 struct pcmcia_device;
 struct net_device;
 extern struct net_device *init_ft1000_card(struct pcmcia_device *link,
-						void *ft1000_reset);
+					   void *ft1000_reset);
 extern void stop_ft1000_card(struct net_device *dev);
 extern int card_download(struct net_device *dev, const u8 *pFileStart,
-			size_t FileLength);
+			 size_t FileLength);
 extern void ft1000InitProc(struct net_device *dev);
 extern void ft1000CleanupProc(struct net_device *dev);
 
 extern u16 ft1000_read_dpram(struct net_device *dev, int offset);
 extern void card_bootload(struct net_device *dev);
-extern u16 ft1000_read_dpram_mag_16(struct net_device *dev, int offset, int Index);
+extern u16 ft1000_read_dpram_mag_16(struct net_device *dev, int offset,
+				    int Index);
 extern u32 ft1000_read_dpram_mag_32(struct net_device *dev, int offset);
 void ft1000_write_dpram_mag_32(struct net_device *dev, int offset, u32 value);
 
@@ -60,7 +64,8 @@ static inline u16 ft1000_read_reg(struct net_device *dev, u16 offset)
 }
 
 /* Set the value of a given ASIC register. */
-static inline void ft1000_write_reg(struct net_device *dev, u16 offset, u16 value)
+static inline void ft1000_write_reg(struct net_device *dev, u16 offset,
+				    u16 value)
 {
 	outw(value, dev->base_addr + offset);
 }
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_ioctl.h b/drivers/staging/ft1000/ft1000-usb/ft1000_ioctl.h
index 43209a1..b151323 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_ioctl.h
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_ioctl.h
@@ -60,12 +60,24 @@ struct IOCTL_GET_DSP_STAT {
 	/*                 0111 = 15dB to 22dB */
 	/*                 1111 = >22dB */
 	/*    Bits 12-15 = Reserved */
-	unsigned long nTxPkts;                /* Number of packets transmitted from host to dsp */
-	unsigned long nRxPkts;                /* Number of packets received from dsp to host */
-	unsigned long nTxBytes;               /* Number of bytes transmitted from host to dsp */
-	unsigned long nRxBytes;               /* Number of bytes received from dsp to host */
-	unsigned long ConTm;                  /* Current session connection time in seconds */
-	unsigned char CalVer[CALVERSZ];       /* Proprietary Calibration Version */
+	unsigned long nTxPkts;                /* Number of packets transmitted
+					       * from host to dsp
+					       */
+	unsigned long nRxPkts;                /* Number of packets received from
+					       * dsp to host
+					       */
+	unsigned long nTxBytes;               /* Number of bytes transmitted
+					       * from host to dsp
+					       */
+	unsigned long nRxBytes;               /* Number of bytes received from
+					       * dsp to host
+					       */
+	unsigned long ConTm;                  /* Current session connection time
+					       * in seconds
+					       */
+	unsigned char CalVer[CALVERSZ];       /* Proprietary Calibration
+					       * Version
+					       */
 	unsigned char CalDate[CALDATESZ];     /* Proprietary Calibration Date */
 } __packed;
 
@@ -94,12 +106,18 @@ struct IOCTL_DPRAM_COMMAND {
 #define IOCTL_CONNECT		10
 #define IOCTL_DISCONNECT	11
 
-#define IOCTL_FT1000_GET_DSP_STAT _IOR(FT1000_MAGIC_CODE, IOCTL_GET_DSP_STAT_CMD, IOCTL_GET_DSP_STAT)
-#define IOCTL_FT1000_GET_VER _IOR(FT1000_MAGIC_CODE, IOCTL_GET_VER_CMD, IOCTL_GET_VER)
+#define IOCTL_FT1000_GET_DSP_STAT _IOR(FT1000_MAGIC_CODE,      \
+				       IOCTL_GET_DSP_STAT_CMD, \
+				       IOCTL_GET_DSP_STAT)
+#define IOCTL_FT1000_GET_VER _IOR(FT1000_MAGIC_CODE, IOCTL_GET_VER_CMD, \
+				  IOCTL_GET_VER)
 #define IOCTL_FT1000_CONNECT _IO(FT1000_MAGIC_CODE, IOCTL_CONNECT)
 #define IOCTL_FT1000_DISCONNECT _IO(FT1000_MAGIC_CODE, IOCTL_DISCONNECT)
-#define IOCTL_FT1000_SET_DPRAM _IOW(FT1000_MAGIC_CODE, IOCTL_SET_DPRAM_CMD, IOCTL_DPRAM_BLK)
-#define IOCTL_FT1000_GET_DPRAM _IOR(FT1000_MAGIC_CODE, IOCTL_GET_DPRAM_CMD, IOCTL_DPRAM_BLK)
-#define IOCTL_FT1000_REGISTER  _IOW(FT1000_MAGIC_CODE, IOCTL_REGISTER_CMD, unsigned short *)
+#define IOCTL_FT1000_SET_DPRAM _IOW(FT1000_MAGIC_CODE, IOCTL_SET_DPRAM_CMD, \
+				    IOCTL_DPRAM_BLK)
+#define IOCTL_FT1000_GET_DPRAM _IOR(FT1000_MAGIC_CODE, IOCTL_GET_DPRAM_CMD, \
+				    IOCTL_DPRAM_BLK)
+#define IOCTL_FT1000_REGISTER  _IOW(FT1000_MAGIC_CODE, IOCTL_REGISTER_CMD, \
+				    unsigned short *)
 
 #endif /* _FT1000IOCTLH_ */
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
index fd3e1a9..2d4b02e 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
@@ -14,14 +14,18 @@
 struct app_info_block {
 	u32 nTxMsg;                    /* DPRAM msg sent to DSP with app_id */
 	u32 nRxMsg;                    /* DPRAM msg rcv from dsp with app_id */
-	u32 nTxMsgReject;              /* DPRAM msg rejected due to DSP doorbell set */
+	u32 nTxMsgReject;              /* DPRAM msg rejected due to DSP doorbell
+					* set
+					*/
 	u32 nRxMsgMiss;                /* DPRAM msg dropped due to overflow */
 	struct fown_struct *fileobject;/* Application's file object */
 	u16 app_id;                    /* Application id */
 	int DspBCMsgFlag;
 	int NumOfMsg;                   /* number of messages queued up */
 	wait_queue_head_t wait_dpram_msg;
-	struct list_head app_sqlist;   /* link list of msgs for applicaton on slow queue */
+	struct list_head app_sqlist;   /* link list of msgs for applicaton on
+					* slow queue
+					*/
 } __packed;
 
 #define DEBUG(args...) pr_info(args)
@@ -41,7 +45,9 @@ struct app_info_block {
 /* MEMORY MAP FOR MAGNEMITE */
 /* the indexes are swapped comparing to PCMCIA - is it OK or a bug? */
 #undef FT1000_MAG_DSP_LED_INDX
-#define FT1000_MAG_DSP_LED_INDX		0x1	/* dsp led status for PAD device */
+#define FT1000_MAG_DSP_LED_INDX		0x1	/* dsp led status for PAD
+						 * device
+						 */
 #undef FT1000_MAG_DSP_CON_STATE_INDX
 #define FT1000_MAG_DSP_CON_STATE_INDX	0x0	/* DSP Connection Status Info */
 
@@ -99,21 +105,21 @@ struct dpram_blk {
 } __packed;
 
 int ft1000_read_register(struct ft1000_usb *ft1000dev,
-			u16 *Data, u16 nRegIndx);
+			 u16 *Data, u16 nRegIndx);
 int ft1000_write_register(struct ft1000_usb *ft1000dev,
-			u16 value, u16 nRegIndx);
+			  u16 value, u16 nRegIndx);
 int ft1000_read_dpram32(struct ft1000_usb *ft1000dev,
 			u16 indx, u8 *buffer, u16 cnt);
 int ft1000_write_dpram32(struct ft1000_usb *ft1000dev,
-			u16 indx, u8 *buffer, u16 cnt);
+			 u16 indx, u8 *buffer, u16 cnt);
 int ft1000_read_dpram16(struct ft1000_usb *ft1000dev,
 			u16 indx, u8 *buffer, u8 highlow);
 int ft1000_write_dpram16(struct ft1000_usb *ft1000dev,
-			u16 indx, u16 value, u8 highlow);
+			 u16 indx, u16 value, u8 highlow);
 int fix_ft1000_read_dpram32(struct ft1000_usb *ft1000dev,
-			u16 indx, u8 *buffer);
+			    u16 indx, u8 *buffer);
 int fix_ft1000_write_dpram32(struct ft1000_usb *ft1000dev,
-			u16 indx, u8 *buffer);
+			     u16 indx, u8 *buffer);
 
 extern void *pFileStart;
 extern size_t FileLength;
@@ -125,12 +131,13 @@ int scram_dnldr(struct ft1000_usb *ft1000dev, void *pFileStart,
 
 extern struct list_head freercvpool;
 
-extern spinlock_t free_buff_lock;   /* lock to arbitrate free buffer list for receive command data */
+/* lock to arbitrate free buffer list for receive command data */
+extern spinlock_t free_buff_lock;
 
 int ft1000_create_dev(struct ft1000_usb *dev);
 void ft1000_destroy_dev(struct net_device *dev);
 extern void card_send_command(struct ft1000_usb *ft1000dev,
-				void *ptempbuffer, int size);
+			      void *ptempbuffer, int size);
 
 struct dpram_blk *ft1000_get_buffer(struct list_head *bufflist);
 void ft1000_free_buffer(struct dpram_blk *pdpram_blk, struct list_head *plist);
@@ -139,12 +146,10 @@ int dsp_reload(struct ft1000_usb *ft1000dev);
 int init_ft1000_netdev(struct ft1000_usb *ft1000dev);
 struct usb_interface;
 int reg_ft1000_netdev(struct ft1000_usb *ft1000dev,
-			struct usb_interface *intf);
+		      struct usb_interface *intf);
 int ft1000_poll(void *dev_id);
 
 int ft1000_init_proc(struct net_device *dev);
 void ft1000_cleanup_proc(struct ft1000_info *info);
 
-
-
-#endif
+#endif  /* _FT1000_USB_H_ */
diff --git a/drivers/staging/ft1000/ft1000.h b/drivers/staging/ft1000/ft1000.h
index ccb821a..db57430 100644
--- a/drivers/staging/ft1000/ft1000.h
+++ b/drivers/staging/ft1000/ft1000.h
@@ -1,5 +1,6 @@
 /*
- * Common structures and definitions for FT1000 Flarion Flash OFDM PCMCIA and USB devices
+ * Common structures and definitions for FT1000 Flarion Flash OFDM PCMCIA and
+ * USB devices.
  *
  * Originally copyright (c) 2002 Flarion Technologies
  *
@@ -17,7 +18,9 @@
 #define MAGNEMITE_ID	0x1a01	/* ASIC ID for Magnemite */
 
 /* MEMORY MAP common to both ELECTRABUZZ and MAGNEMITE */
-#define	FT1000_REG_DPRAM_ADDR	0x000E	/* DPADR - Dual Port Ram Indirect Address Register */
+#define	FT1000_REG_DPRAM_ADDR	0x000E	/* DPADR - Dual Port Ram Indirect
+					 * Address Register
+					 */
 #define	FT1000_REG_SUP_CTRL	0x0020	/* HCTR - Host Control Register */
 #define	FT1000_REG_SUP_STAT	0x0022	/* HSTAT - Host Status Register */
 #define	FT1000_REG_RESET	0x0024	/* HCTR - Host Control Register */
-- 
1.7.10.4


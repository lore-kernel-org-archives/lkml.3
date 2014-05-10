Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757091AbaEISyy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 14:54:54 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:63236 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754353AbaEISyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 14:54:53 -0400
From: Artem Fetishev <wwctrsrx@gmail.com>
To: marek.belisko@gmail.com, gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, Artem Fetishev <wwctrsrx@gmail.com>
Subject: [PATCH] drivers: staging: ft1000: Improve coding style
Date: Sat, 10 May 2014 09:53:33 +0300
Message-Id: <1399704813-9516-1-git-send-email-wwctrsrx@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Improvements include:
 - Lines over 80 characters;
 - Use pr_info() instead printk(KERN_INFO);
 - Removal of typedefs;
 - Indentation.
 - Fix IOCTL_FT1000_* marcos:
   - Add closing brackets;
   - remove sizeof (_IOR and _IOW macro can accept types);
   - replace _IOW which size of 0 (the last arg) with _IO.
   - Actually these macros are not used anywhere and might be removed.

Signed-off-by: Artem Fetishev <wwctrsrx@gmail.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_debug.c |   40 +++----
 drivers/staging/ft1000/ft1000-usb/ft1000_ioctl.h |  138 ++++++++++++----------
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.h   |   33 +++---
 drivers/staging/ft1000/ft1000.h                  |    8 +-
 4 files changed, 119 insertions(+), 100 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_debug.c b/drivers/staging/ft1000/ft1000-usb/ft1000_debug.c
index ffdc7f5..6dfb985 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_debug.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_debug.c
@@ -408,17 +408,17 @@ static unsigned int ft1000_poll_dev(struct file *file, poll_table *wait)
 static long ft1000_ioctl(struct file *file, unsigned int command,
                            unsigned long argument)
 {
-    void __user *argp = (void __user *)argument;
+	void __user *argp = (void __user *) argument;
 	struct ft1000_info *info;
-    struct ft1000_usb *ft1000dev;
-    int result=0;
-    int cmd;
-    int i;
-    u16 tempword;
-    unsigned long flags;
-    struct timeval tv;
-    IOCTL_GET_VER get_ver_data;
-    IOCTL_GET_DSP_STAT get_stat_data;
+	struct ft1000_usb *ft1000dev;
+	int result = 0;
+	int cmd;
+	int i;
+	u16 tempword;
+	unsigned long flags;
+	struct timeval tv;
+	struct IOCTL_GET_VER get_ver_data;
+	struct IOCTL_GET_DSP_STAT get_stat_data;
     u8 ConnectionMsg[] = {0x00,0x44,0x10,0x20,0x80,0x00,0x00,0x00,0x00,0x00,0x03,0x00,0x00,0x00,0x93,0x64,
                           0x00,0x00,0x02,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x05,0x00,0x00,0x00,0x0a,
                           0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x02,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
@@ -527,15 +527,15 @@ static long ft1000_ioctl(struct file *file, unsigned int command,
         break;
     case IOCTL_SET_DPRAM_CMD:
         {
-            IOCTL_DPRAM_BLK *dpram_data = NULL;
-            /* IOCTL_DPRAM_COMMAND dpram_command; */
-            u16 qtype;
-            u16 msgsz;
+		struct IOCTL_DPRAM_BLK *dpram_data = NULL;
+		/* struct IOCTL_DPRAM_COMMAND dpram_command; */
+		u16 qtype;
+		u16 msgsz;
 		struct pseudo_hdr *ppseudo_hdr;
-            u16 *pmsg;
-            u16 total_len;
-            u16 app_index;
-            u16 status;
+		u16 *pmsg;
+		u16 total_len;
+		u16 app_index;
+		u16 status;
 
             /* DEBUG("FT1000:ft1000_ioctl: IOCTL_FT1000_SET_DPRAM called\n");*/
 
@@ -672,8 +672,8 @@ static long ft1000_ioctl(struct file *file, unsigned int command,
     case IOCTL_GET_DPRAM_CMD:
         {
 		struct dpram_blk *pdpram_blk;
-            IOCTL_DPRAM_BLK __user *pioctl_dpram;
-            int msglen;
+		struct IOCTL_DPRAM_BLK __user *pioctl_dpram;
+		int msglen;
 
             /* DEBUG("FT1000:ft1000_ioctl: IOCTL_FT1000_GET_DPRAM called\n"); */
 
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_ioctl.h b/drivers/staging/ft1000/ft1000-usb/ft1000_ioctl.h
index 419e534..9769311 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_ioctl.h
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_ioctl.h
@@ -23,83 +23,97 @@
 * History:
 * 11/5/02    Whc                Created.
 *
-*---------------------------------------------------------------------------//---------------------------------------------------------------------------
+*---------------------------------------------------------------------------
 */
 #ifndef _FT1000IOCTLH_
 #define _FT1000IOCTLH_
 
-typedef struct _IOCTL_GET_VER {
-    unsigned long drv_ver;
-} __packed IOCTL_GET_VER, *PIOCTL_GET_VER;
+struct IOCTL_GET_VER {
+	unsigned long drv_ver;
+} __packed;
 
 /* Data structure for Dsp statistics */
-typedef struct _IOCTL_GET_DSP_STAT {
-    unsigned char DspVer[DSPVERSZ];        /* DSP version number */
-    unsigned char HwSerNum[HWSERNUMSZ];    /* Hardware Serial Number */
-    unsigned char Sku[SKUSZ];              /* SKU */
-    unsigned char eui64[EUISZ];            /* EUI64 */
-    unsigned short ConStat;                /* Connection Status */
-                                /*    Bits 0-3 = Connection Status Field */
-                                /*               0000=Idle (Disconnect) */
-                                /*               0001=Searching */
-                                /*               0010=Active (Connected) */
-                                /*               0011=Waiting for L2 down */
-                                /*               0100=Sleep */
-    unsigned short LedStat;                /* Led Status */
-                                /*    Bits 0-3   = Signal Strength Field */
-                                /*                 0000 = -105dBm to -92dBm */
-                                /*                 0001 = -92dBm to -85dBm */
-                                /*                 0011 = -85dBm to -75dBm */
-                                /*                 0111 = -75dBm to -50dBm */
-                                /*                 1111 = -50dBm to 0dBm */
-                                /*    Bits 4-7   = Reserved */
-                                /*    Bits 8-11  = SNR Field */
-                                /*                 0000 = <2dB */
-                                /*                 0001 = 2dB to 8dB */
-                                /*                 0011 = 8dB to 15dB */
-                                /*                 0111 = 15dB to 22dB */
-                                /*                 1111 = >22dB */
-                                /*    Bits 12-15 = Reserved */
-    unsigned long nTxPkts;                /* Number of packets transmitted from host to dsp */
-    unsigned long nRxPkts;                /* Number of packets received from dsp to host */
-    unsigned long nTxBytes;               /* Number of bytes transmitted from host to dsp */
-    unsigned long nRxBytes;               /* Number of bytes received from dsp to host */
-    unsigned long ConTm;                  /* Current session connection time in seconds */
-    unsigned char CalVer[CALVERSZ];       /* Proprietary Calibration Version */
-    unsigned char CalDate[CALDATESZ];     /* Proprietary Calibration Date */
-} __packed IOCTL_GET_DSP_STAT, *PIOCTL_GET_DSP_STAT;
+struct IOCTL_GET_DSP_STAT {
+	unsigned char DspVer[DSPVERSZ];        /* DSP version number */
+	unsigned char HwSerNum[HWSERNUMSZ];    /* Hardware Serial Number */
+	unsigned char Sku[SKUSZ];              /* SKU */
+	unsigned char eui64[EUISZ];            /* EUI64 */
+	unsigned short ConStat; /* Connection Status
+				 * Bits 0-3 = Connection Status Field
+				 *               0000=Idle (Disconnect)
+				 *               0001=Searching
+				 *               0010=Active (Connected)
+				 *               0011=Waiting for L2 down
+				 *               0100=Sleep
+				 */
+	unsigned short LedStat; /* Led Status
+				 *    Bits 0-3   = Signal Strength Field
+				 *                 0000 = -105dBm to -92dBm
+				 *                 0001 = -92dBm to -85dBm
+				 *                 0011 = -85dBm to -75dBm
+				 *                 0111 = -75dBm to -50dBm
+				 *                 1111 = -50dBm to 0dBm
+				 *    Bits 4-7   = Reserved
+				 *    Bits 8-11  = SNR Field
+				 *                 0000 = <2dB
+				 *                 0001 = 2dB to 8dB
+				 *                 0011 = 8dB to 15dB
+				 *                 0111 = 15dB to 22dB
+				 *                 1111 = >22dB
+				 *    Bits 12-15 = Reserved
+				 */
+	unsigned long nTxPkts;  /* Number of packets transmitted from host to
+				 * dsp
+				 */
+	unsigned long nRxPkts;  /* Number of packets received from dsp to
+				 * host
+				 */
+	unsigned long nTxBytes; /* Number of bytes transmitted from host to
+				 * dsp
+				 */
+	unsigned long nRxBytes; /* Number of bytes received from dsp to host */
+	unsigned long ConTm;    /* Current session connection time in seconds */
+	unsigned char CalVer[CALVERSZ];    /* Proprietary Calibration Version */
+	unsigned char CalDate[CALDATESZ];     /* Proprietary Calibration Date */
+} __packed;
 
 /* Data structure for Dual Ported RAM messaging between Host and Dsp */
-typedef struct _IOCTL_DPRAM_BLK {
-    unsigned short total_len;
+struct IOCTL_DPRAM_BLK {
+	unsigned short total_len;
 	struct pseudo_hdr pseudohdr;
-    unsigned char buffer[1780];
-} __packed IOCTL_DPRAM_BLK, *PIOCTL_DPRAM_BLK;
+	unsigned char buffer[1780];
+} __packed;
 
-typedef struct _IOCTL_DPRAM_COMMAND {
-    unsigned short extra;
-    IOCTL_DPRAM_BLK dpram_blk;
-} __packed IOCTL_DPRAM_COMMAND, *PIOCTL_DPRAM_COMMAND;
+struct IOCTL_DPRAM_COMMAND {
+	unsigned short extra;
+	struct IOCTL_DPRAM_BLK dpram_blk;
+} __packed;
 
 /*
 * Custom IOCTL command codes
 */
 #define FT1000_MAGIC_CODE      'F'
 
-#define IOCTL_REGISTER_CMD					0
-#define IOCTL_SET_DPRAM_CMD					3
-#define IOCTL_GET_DPRAM_CMD					4
-#define IOCTL_GET_DSP_STAT_CMD      6
-#define IOCTL_GET_VER_CMD           7
-#define IOCTL_CONNECT               10
-#define IOCTL_DISCONNECT            11
+#define IOCTL_REGISTER_CMD	0
+#define IOCTL_SET_DPRAM_CMD	3
+#define IOCTL_GET_DPRAM_CMD	4
+#define IOCTL_GET_DSP_STAT_CMD	6
+#define IOCTL_GET_VER_CMD	7
+#define IOCTL_CONNECT		10
+#define IOCTL_DISCONNECT	11
 
-#define IOCTL_FT1000_GET_DSP_STAT _IOR(FT1000_MAGIC_CODE, IOCTL_GET_DSP_STAT_CMD, sizeof(IOCTL_GET_DSP_STAT)
-#define IOCTL_FT1000_GET_VER _IOR(FT1000_MAGIC_CODE, IOCTL_GET_VER_CMD, sizeof(IOCTL_GET_VER)
-#define IOCTL_FT1000_CONNECT _IOW(FT1000_MAGIC_CODE, IOCTL_CONNECT, 0
-#define IOCTL_FT1000_DISCONNECT _IOW(FT1000_MAGIC_CODE, IOCTL_DISCONNECT, 0
-#define IOCTL_FT1000_SET_DPRAM _IOW(FT1000_MAGIC_CODE, IOCTL_SET_DPRAM_CMD, sizeof(IOCTL_DPRAM_BLK)
-#define IOCTL_FT1000_GET_DPRAM _IOR(FT1000_MAGIC_CODE, IOCTL_GET_DPRAM_CMD, sizeof(IOCTL_DPRAM_BLK)
-#define IOCTL_FT1000_REGISTER  _IOW(FT1000_MAGIC_CODE, IOCTL_REGISTER_CMD, sizeof(unsigned short *)
-#endif /* _FT1000IOCTLH_ */
+#define IOCTL_FT1000_GET_DSP_STAT _IOR(FT1000_MAGIC_CODE, \
+				       IOCTL_GET_DSP_STAT_CMD, \
+				       struct IOCTL_GET_DSP_STAT)
+#define IOCTL_FT1000_GET_VER _IOR(FT1000_MAGIC_CODE, IOCTL_GET_VER_CMD, \
+				  struct IOCTL_GET_VER)
+#define IOCTL_FT1000_CONNECT _IO(FT1000_MAGIC_CODE, IOCTL_CONNECT)
+#define IOCTL_FT1000_DISCONNECT _IO(FT1000_MAGIC_CODE, IOCTL_DISCONNECT)
+#define IOCTL_FT1000_SET_DPRAM _IOW(FT1000_MAGIC_CODE, IOCTL_SET_DPRAM_CMD, \
+				    struct IOCTL_DPRAM_BLK)
+#define IOCTL_FT1000_GET_DPRAM _IOR(FT1000_MAGIC_CODE, IOCTL_GET_DPRAM_CMD, \
+				    struct IOCTL_DPRAM_BLK)
+#define IOCTL_FT1000_REGISTER  _IOW(FT1000_MAGIC_CODE, IOCTL_REGISTER_CMD, \
+				    unsigned short *)
 
+#endif /* _FT1000IOCTLH_ */
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
index a6fdd524..11498eb 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
@@ -14,17 +14,21 @@
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
 
-#define DEBUG(args...) printk(KERN_INFO args)
+#define DEBUG(args...) pr_info(args)
 
 #define FALSE           0
 #define TRUE            1
@@ -41,9 +45,9 @@ struct app_info_block {
 /* MEMORY MAP FOR MAGNEMITE */
 /* the indexes are swapped comparing to PCMCIA - is it OK or a bug? */
 #undef FT1000_MAG_DSP_LED_INDX
-#define FT1000_MAG_DSP_LED_INDX		0x1	/* dsp led status for PAD device */
+#define FT1000_MAG_DSP_LED_INDX		0x1  /* dsp led status for PAD device */
 #undef FT1000_MAG_DSP_CON_STATE_INDX
-#define FT1000_MAG_DSP_CON_STATE_INDX	0x0	/* DSP Connection Status Info */
+#define FT1000_MAG_DSP_CON_STATE_INDX	0x0  /* DSP Connection Status Info */
 
 /* Maximum times trying to get ASIC out of reset */
 #define MAX_ASIC_RESET_CNT      20
@@ -99,21 +103,21 @@ struct dpram_blk {
 } __packed;
 
 int ft1000_read_register(struct ft1000_usb *ft1000dev,
-			u16 *Data, u16 nRegIndx);
+			 u16 *Data, u16 nRegIndx);
 int ft1000_write_register(struct ft1000_usb *ft1000dev,
 			u16 value, u16 nRegIndx);
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
@@ -125,12 +129,13 @@ int scram_dnldr(struct ft1000_usb *ft1000dev, void *pFileStart,
 
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
@@ -145,6 +150,4 @@ int ft1000_poll(void *dev_id);
 int ft1000_init_proc(struct net_device *dev);
 void ft1000_cleanup_proc(struct ft1000_info *info);
 
-
-
-#endif
+#endif  /* _FT1000_USB_H_ */
diff --git a/drivers/staging/ft1000/ft1000.h b/drivers/staging/ft1000/ft1000.h
index ccb821a..54dd3d5 100644
--- a/drivers/staging/ft1000/ft1000.h
+++ b/drivers/staging/ft1000/ft1000.h
@@ -1,8 +1,8 @@
 /*
- * Common structures and definitions for FT1000 Flarion Flash OFDM PCMCIA and USB devices
+ * Common structures and definitions for FT1000 Flarion Flash OFDM PCMCIA and
+ * USB devices.
  *
  * Originally copyright (c) 2002 Flarion Technologies
- *
  */
 
 #define DSPVERSZ	4
@@ -17,7 +17,9 @@
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


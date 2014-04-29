Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695AbaD2CWu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 22:22:50 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:41063 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752104AbaD2CWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 22:22:39 -0400
X-Sasl-enc: VlMXg475ItDa+OJZ/YP+tKrx2Ma7Jyi+bMmtaa7tTsj6 1398738157
Message-ID: <535F0CCB.5030405@fastmail.fm>
Date: Tue, 29 Apr 2014 10:22:03 +0800
From: Michalis Pappas <mpappas@fastmail.fm>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>,
        Greg KH <gregkh@linuxfoundation.org>
CC: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 9/10] staging: gdm72xx: Indentation and other whitespace
 fixes.
References: <532BF9B0.2080008@fastmail.fm> <20140418225229.GA28077@kroah.com> <53534051.2020504@fastmail.fm> <53534116.3040705@fastmail.fm> <20140422093743.GC26890@mwanda> <53570BAA.3080709@fastmail.fm> <20140423080447.GS26890@mwanda> <53577E96.10106@fastmail.fm> <20140423090557.GU26890@mwanda> <20140423090904.GV26890@mwanda> <535F0866.2060207@fastmail.fm>
In-Reply-To: <535F0866.2060207@fastmail.fm>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Indentation and other whitespace fixes.

Signed-off-by: Michalis Pappas <mpappas@fastmail.fm>
---
 drivers/staging/gdm72xx/gdm_qos.c   |  2 +-
 drivers/staging/gdm72xx/gdm_sdio.c  | 14 +++---
 drivers/staging/gdm72xx/gdm_sdio.h  | 29 +++++--------
 drivers/staging/gdm72xx/gdm_usb.c   | 17 ++++----
 drivers/staging/gdm72xx/gdm_usb.h   | 11 +----
 drivers/staging/gdm72xx/gdm_wimax.c | 21 +++++----
 drivers/staging/gdm72xx/gdm_wimax.h | 21 ++++-----
 drivers/staging/gdm72xx/hci.h       | 87 +++++++++++++++++--------------------
 drivers/staging/gdm72xx/usb_ids.h   |  2 +-
 drivers/staging/gdm72xx/wm_ioctl.h  | 22 +++++-----
 10 files changed, 97 insertions(+), 129 deletions(-)

diff --git a/drivers/staging/gdm72xx/gdm_qos.c b/drivers/staging/gdm72xx/gdm_qos.c
index 33df46a..eba3bfa 100644
--- a/drivers/staging/gdm72xx/gdm_qos.c
+++ b/drivers/staging/gdm72xx/gdm_qos.c
@@ -24,7 +24,7 @@
 #include "hci.h"
 #include "gdm_qos.h"
 
-#define B2H(x)		__be16_to_cpu(x)
+#define B2H(x)	__be16_to_cpu(x)
 
 #define MAX_FREE_LIST_CNT		32
 static struct {
diff --git a/drivers/staging/gdm72xx/gdm_sdio.c b/drivers/staging/gdm72xx/gdm_sdio.c
index 07be325..6d1de33 100644
--- a/drivers/staging/gdm72xx/gdm_sdio.c
+++ b/drivers/staging/gdm72xx/gdm_sdio.c
@@ -31,11 +31,11 @@
 #define MAX_NR_RX_BUF	4
 
 #define SDU_TX_BUF_SIZE	2048
-#define TX_BUF_SIZE		2048
+#define TX_BUF_SIZE	2048
 #define TX_CHUNK_SIZE	(2048 - TYPE_A_HEADER_SIZE)
-#define RX_BUF_SIZE		(25*1024)
+#define RX_BUF_SIZE	(25*1024)
 
-#define TX_HZ	2000
+#define TX_HZ		2000
 #define TX_INTERVAL	(1000000/TX_HZ)
 
 static int init_sdio(struct sdiowm_dev *sdev);
@@ -127,10 +127,10 @@ static void put_rx_struct(struct rx_cxt *rx, struct sdio_rx *r)
 static int init_sdio(struct sdiowm_dev *sdev)
 {
 	int ret = 0, i;
-	struct tx_cxt	*tx = &sdev->tx;
-	struct rx_cxt	*rx = &sdev->rx;
-	struct sdio_tx	*t;
-	struct sdio_rx	*r;
+	struct tx_cxt *tx = &sdev->tx;
+	struct rx_cxt *rx = &sdev->rx;
+	struct sdio_tx *t;
+	struct sdio_rx *r;
 
 	INIT_LIST_HEAD(&tx->free_list);
 	INIT_LIST_HEAD(&tx->sdu_list);
diff --git a/drivers/staging/gdm72xx/gdm_sdio.h b/drivers/staging/gdm72xx/gdm_sdio.h
index 216e98f..0c0e2cb 100644
--- a/drivers/staging/gdm72xx/gdm_sdio.h
+++ b/drivers/staging/gdm72xx/gdm_sdio.h
@@ -22,10 +22,8 @@
 struct sdio_tx {
 	struct list_head	list;
 	struct tx_cxt		*tx_cxt;
-
-	u8	*buf;
-	int	len;
-
+	u8			*buf;
+	int			len;
 	void (*callback)(void *cb_data);
 	void *cb_data;
 };
@@ -35,18 +33,15 @@ struct tx_cxt {
 	struct list_head	sdu_list;
 	struct list_head	hci_list;
 	struct timeval		sdu_stamp;
-
-	u8	*sdu_buf;
-
-	spinlock_t			lock;
-	int	can_send;
-	int stop_sdu_tx;
+	u8			*sdu_buf;
+	spinlock_t		lock;
+	int			can_send;
+	int			stop_sdu_tx;
 };
 
 struct sdio_rx {
 	struct list_head	list;
 	struct rx_cxt		*rx_cxt;
-
 	void (*callback)(void *cb_data, void *data, int len);
 	void *cb_data;
 };
@@ -54,18 +49,14 @@ struct sdio_rx {
 struct rx_cxt {
 	struct list_head	free_list;
 	struct list_head	req_list;
-
-	u8		*rx_buf;
-
-	spinlock_t			lock;
+	u8			*rx_buf;
+	spinlock_t		lock;
 };
 
 struct sdiowm_dev {
 	struct sdio_func	*func;
-
-	struct tx_cxt	tx;
-	struct rx_cxt	rx;
-
+	struct tx_cxt		tx;
+	struct rx_cxt		rx;
 	struct work_struct	ws;
 };
 
diff --git a/drivers/staging/gdm72xx/gdm_usb.c b/drivers/staging/gdm72xx/gdm_usb.c
index c7298d0..c59a7a4 100644
--- a/drivers/staging/gdm72xx/gdm_usb.c
+++ b/drivers/staging/gdm72xx/gdm_usb.c
@@ -27,6 +27,7 @@
 MODULE_DEVICE_TABLE(usb, id_table);
 
 #define TX_BUF_SIZE		2048
+
 #if defined(CONFIG_WIMAX_GDM72XX_WIMAX2)
 #define RX_BUF_SIZE		(128*1024)	/* For packet aggregation */
 #else
@@ -166,10 +167,10 @@ static void put_rx_struct(struct rx_cxt *rx, struct usb_rx *r)
 static int init_usb(struct usbwm_dev *udev)
 {
 	int ret = 0, i;
-	struct tx_cxt	*tx = &udev->tx;
-	struct rx_cxt	*rx = &udev->rx;
-	struct usb_tx	*t;
-	struct usb_rx	*r;
+	struct tx_cxt *tx = &udev->tx;
+	struct rx_cxt *rx = &udev->rx;
+	struct usb_tx *t;
+	struct usb_rx *r;
 	unsigned long flags;
 
 	INIT_LIST_HEAD(&tx->free_list);
@@ -215,10 +216,10 @@ fail:
 
 static void release_usb(struct usbwm_dev *udev)
 {
-	struct tx_cxt	*tx = &udev->tx;
-	struct rx_cxt	*rx = &udev->rx;
-	struct usb_tx	*t, *t_next;
-	struct usb_rx	*r, *r_next;
+	struct tx_cxt *tx = &udev->tx;
+	struct rx_cxt *rx = &udev->rx;
+	struct usb_tx *t, *t_next;
+	struct usb_rx *r, *r_next;
 	unsigned long flags;
 
 	spin_lock_irqsave(&tx->lock, flags);
diff --git a/drivers/staging/gdm72xx/gdm_usb.h b/drivers/staging/gdm72xx/gdm_usb.h
index f2c5451..3050652 100644
--- a/drivers/staging/gdm72xx/gdm_usb.h
+++ b/drivers/staging/gdm72xx/gdm_usb.h
@@ -28,12 +28,10 @@ struct usb_tx {
 	struct list_head	p_list;
 #endif
 	struct tx_cxt		*tx_cxt;
-
 	struct urb		*urb;
 	u8			*buf;
-
 	void (*callback)(void *cb_data);
-	void *cb_data;
+	void			*cb_data;
 };
 
 struct tx_cxt {
@@ -43,17 +41,14 @@ struct tx_cxt {
 #if defined(CONFIG_WIMAX_GDM72XX_USB_PM) || defined(CONFIG_WIMAX_GDM72XX_K_MODE)
 	struct list_head	pending_list;
 #endif
-
 	spinlock_t		lock;
 };
 
 struct usb_rx {
 	struct list_head	list;
 	struct rx_cxt		*rx_cxt;
-
 	struct urb		*urb;
 	u8			*buf;
-
 	void (*callback)(void *cb_data, void *data, int len);
 	void *cb_data;
 };
@@ -75,11 +70,9 @@ struct usbwm_dev {
 	int bw_switch;
 	struct list_head	list;
 #endif
-
 	struct tx_cxt		tx;
 	struct rx_cxt		rx;
-
-	int padding;
+	int			padding;
 };
 
 #endif /* __GDM_USB_H__ */
diff --git a/drivers/staging/gdm72xx/gdm_wimax.c b/drivers/staging/gdm72xx/gdm_wimax.c
index 094e9c9..492bc78 100644
--- a/drivers/staging/gdm72xx/gdm_wimax.c
+++ b/drivers/staging/gdm72xx/gdm_wimax.c
@@ -35,10 +35,10 @@
 #define EVT_MAX_SIZE	2048
 
 struct evt_entry {
-	struct list_head list;
-	struct net_device *dev;
-	char evt_data[EVT_MAX_SIZE];
-	int	 size;
+	struct	list_head list;
+	struct	net_device *dev;
+	char	evt_data[EVT_MAX_SIZE];
+	int	size;
 };
 
 static void __gdm_wimax_event_send(struct work_struct *work);
@@ -52,7 +52,6 @@ static struct {
 	struct sock *sock;
 	struct list_head evtq;
 	spinlock_t evt_lock;
-
 	struct list_head freeq;
 	struct work_struct ws;
 } wm_event;
@@ -868,13 +867,13 @@ static void start_rx_proc(struct nic *nic)
 }
 
 static struct net_device_ops gdm_netdev_ops = {
-	.ndo_open				= gdm_wimax_open,
-	.ndo_stop				= gdm_wimax_close,
-	.ndo_set_config			= gdm_wimax_set_config,
-	.ndo_start_xmit			= gdm_wimax_tx,
-	.ndo_get_stats			= gdm_wimax_stats,
+	.ndo_open		= gdm_wimax_open,
+	.ndo_stop		= gdm_wimax_close,
+	.ndo_set_config		= gdm_wimax_set_config,
+	.ndo_start_xmit		= gdm_wimax_tx,
+	.ndo_get_stats		= gdm_wimax_stats,
 	.ndo_set_mac_address	= gdm_wimax_set_mac_addr,
-	.ndo_do_ioctl			= gdm_wimax_ioctl,
+	.ndo_do_ioctl		= gdm_wimax_ioctl,
 };
 
 int register_wimax_device(struct phy_dev *phy_dev, struct device *pdev)
diff --git a/drivers/staging/gdm72xx/gdm_wimax.h b/drivers/staging/gdm72xx/gdm_wimax.h
index 21087c03..7e2c888 100644
--- a/drivers/staging/gdm72xx/gdm_wimax.h
+++ b/drivers/staging/gdm72xx/gdm_wimax.h
@@ -34,28 +34,23 @@
 #define DB2H(x)		__be32_to_cpu(x)
 
 struct phy_dev {
-	void	*priv_dev;
+	void			*priv_dev;
 	struct net_device	*netdev;
-
-	int	(*send_func)(void *priv_dev, void *data, int len,
-			     void (*cb)(void *cb_data), void *cb_data);
-	int	(*rcv_func)(void *priv_dev,
-			    void (*cb)(void *cb_data, void *data, int len),
-			    void *cb_data);
+	int (*send_func)(void *priv_dev, void *data, int len,
+			 void (*cb)(void *cb_data), void *cb_data);
+	int (*rcv_func)(void *priv_dev,
+			void (*cb)(void *cb_data, void *data, int len),
+			void *cb_data);
 };
 
 struct nic {
 	struct net_device	*netdev;
 	struct phy_dev		*phy_dev;
-
 	struct net_device_stats	stats;
-
-	struct data_s	sdk_data[SIOC_DATA_MAX];
-
+	struct data_s		sdk_data[SIOC_DATA_MAX];
 #if defined(CONFIG_WIMAX_GDM72XX_QOS)
-	struct qos_cb_s	qos;
+	struct qos_cb_s		qos;
 #endif
-
 };
 
 int register_wimax_device(struct phy_dev *phy_dev, struct device *pdev);
diff --git a/drivers/staging/gdm72xx/hci.h b/drivers/staging/gdm72xx/hci.h
index 0e06766..2485a37 100644
--- a/drivers/staging/gdm72xx/hci.h
+++ b/drivers/staging/gdm72xx/hci.h
@@ -18,18 +18,18 @@
 #define HCI_VALUE_OFFS		(HCI_HEADER_SIZE)
 #define HCI_MAX_PACKET		2048
 #define HCI_MAX_PARAM		(HCI_MAX_PACKET-HCI_HEADER_SIZE)
-#define HCI_MAX_TLV			32
+#define HCI_MAX_TLV		32
 
 /* CMD-EVT */
 
 /* Category 0 */
-#define WIMAX_RESET				0x0000
-#define WIMAX_SET_INFO			0x0001
-#define WIMAX_GET_INFO			0x0002
+#define WIMAX_RESET		0x0000
+#define WIMAX_SET_INFO		0x0001
+#define WIMAX_GET_INFO		0x0002
 #define WIMAX_GET_INFO_RESULT	0x8003
-#define WIMAX_RADIO_OFF			0x0004
-#define WIMAX_RADIO_ON			0x0006
-#define WIMAX_WIMAX_RESET		0x0007	/* Is this still here */
+#define WIMAX_RADIO_OFF		0x0004
+#define WIMAX_RADIO_ON		0x0006
+#define WIMAX_WIMAX_RESET	0x0007	/* Is this still here */
 
 /* Category 1 */
 #define WIMAX_NET_ENTRY			0x0100
@@ -40,26 +40,22 @@
 #define WIMAX_EXIT_IDLE			0x0106
 #define WIMAX_MODE_CHANGE		0x8108
 #define WIMAX_HANDOVER			0x8109	/* obsolete */
-
-#define WIMAX_SCAN				0x010d
+#define WIMAX_SCAN			0x010d
 #define WIMAX_SCAN_COMPLETE		0x810e
 #define WIMAX_SCAN_RESULT		0x810f
-
 #define WIMAX_CONNECT			0x0110
 #define WIMAX_CONNECT_START		0x8111
-#define WIMAX_CONNECT_COMPLETE	0x8112
+#define WIMAX_CONNECT_COMPLETE		0x8112
 #define WIMAX_ASSOC_START		0x8113
-#define WIMAX_ASSOC_COMPLETE	0x8114
+#define WIMAX_ASSOC_COMPLETE		0x8114
 #define WIMAX_DISCONN_IND		0x8115
 #define WIMAX_ENTRY_IND			0x8116
 #define WIMAX_HO_START			0x8117
 #define WIMAX_HO_COMPLETE		0x8118
-#define WIMAX_RADIO_STATE_IND	0x8119
+#define WIMAX_RADIO_STATE_IND		0x8119
 #define WIMAX_IP_RENEW_IND		0x811a
-
-#define WIMAX_DISCOVER_NSP			0x011d
+#define WIMAX_DISCOVER_NSP		0x011d
 #define WIMAX_DISCOVER_NSP_RESULT	0x811e
-
 #define WIMAX_SDU_TX_FLOW		0x8125
 
 /* Category 2 */
@@ -71,34 +67,33 @@
 #define WIMAX_TX_SDU_AGGR	0x0205
 
 /* Category 3 */
-#define WIMAX_DM_CMD				0x030a
-#define WIMAX_DM_RSP				0x830b
-
-#define WIMAX_CLI_CMD				0x030c
-#define WIMAX_CLI_RSP				0x830d
+#define WIMAX_DM_CMD		0x030a
+#define WIMAX_DM_RSP		0x830b
 
-#define WIMAX_DL_IMAGE				0x0310
-#define WIMAX_DL_IMAGE_STATUS		0x8311
-#define WIMAX_UL_IMAGE				0x0312
-#define WIMAX_UL_IMAGE_RESULT		0x8313
-#define WIMAX_UL_IMAGE_STATUS		0x0314
+#define WIMAX_CLI_CMD		0x030c
+#define WIMAX_CLI_RSP		0x830d
 
-#define WIMAX_EVT_MODEM_REPORT		0x8325
+#define WIMAX_DL_IMAGE		0x0310
+#define WIMAX_DL_IMAGE_STATUS	0x8311
+#define WIMAX_UL_IMAGE		0x0312
+#define WIMAX_UL_IMAGE_RESULT	0x8313
+#define WIMAX_UL_IMAGE_STATUS	0x0314
+#define WIMAX_EVT_MODEM_REPORT	0x8325
 
 /* Category 0xF */
-#define WIMAX_FSM_UPDATE			0x8F01
-#define WIMAX_IF_UPDOWN				0x8F02
-	#define WIMAX_IF_UP				1
-	#define WIMAX_IF_DOWN			2
+#define WIMAX_FSM_UPDATE	0x8F01
+#define WIMAX_IF_UPDOWN		0x8F02
+#define WIMAX_IF_UP		1
+#define WIMAX_IF_DOWN		2
 
 /* WIMAX mode */
-#define W_NULL				0
-#define W_STANDBY			1
-#define W_OOZ				2
-#define W_AWAKE				3
-#define W_IDLE				4
-#define W_SLEEP				5
-#define W_WAIT				6
+#define W_NULL		0
+#define W_STANDBY	1
+#define W_OOZ		2
+#define W_AWAKE		3
+#define W_IDLE		4
+#define W_SLEEP		5
+#define W_WAIT		6
 
 #define W_NET_ENTRY_RNG		0x80
 #define W_NET_ENTRY_SBC		0x81
@@ -113,8 +108,8 @@
 #define W_NET_ENTRY_DSX_FAIL	0x1104000
 
 /* Scan Type */
-#define W_SCAN_ALL_CHANNEL				0
-#define W_SCAN_ALL_SUBSCRIPTION			1
+#define W_SCAN_ALL_CHANNEL		0
+#define W_SCAN_ALL_SUBSCRIPTION		1
 #define W_SCAN_SPECIFIED_SUBSCRIPTION	2
 
 /*
@@ -126,7 +121,7 @@
  *
  */
 #define TLV_L(x)		(((x) >> 16) & 0xff)
-#define TLV_T(x)			((x) & 0xff)
+#define TLV_T(x)		((x) & 0xff)
 #define TLV_COMPOSITE(x)	((x) >> 31)
 
 /* GENERAL */
@@ -141,7 +136,6 @@
 #define T_OOZ_SCAN_INTERVAL		(0x08	| (4 << 16))
 #define T_IMEI				(0x09	| (8 << 16))
 #define T_PID				(0x0a	| (12 << 16))
-
 #define T_CAPABILITY			(0x1a	| (4 << 16))
 #define T_RELEASE_NUMBER		(0x1b	| (4 << 16))
 #define T_DRIVER_REVISION		(0x1c	| (4 << 16))
@@ -150,19 +144,16 @@
 #define T_PHY_HW_REVISION		(0x1f	| (4 << 16))
 
 /* HANDOVER */
-#define T_SCAN_INTERVAL		(0x20	| (1 << 16))
-
+#define T_SCAN_INTERVAL			(0x20	| (1 << 16))
 #define T_RSC_RETAIN_TIME		(0x2f	| (2 << 16))
 
 /* SLEEP */
 #define T_TYPE1_ISW			(0x40	| (1 << 16))
-
 #define T_SLP_START_TO			(0x4a	| (2 << 16))
 
 /* IDLE */
 #define T_IDLE_MODE_TO			(0x50	| (2 << 16))
-
-#define T_IDLE_START_TO		(0x54	| (2 << 16))
+#define T_IDLE_START_TO			(0x54	| (2 << 16))
 
 /* MONITOR */
 #define T_RSSI				(0x60	| (1 << 16))
@@ -180,7 +171,7 @@
 #define T_CS_TYPE			(0xa6	| (2 << 16))
 #define T_VENDOR_NAME			(0xa7	| (0 << 16))
 #define T_MOD_NAME			(0xa8	| (0 << 16))
-#define T_PACKET_FILTER		(0xa9	| (1 << 16))
+#define T_PACKET_FILTER			(0xa9	| (1 << 16))
 #define T_NSP_CHANGE_COUNT		(0xaa	| (4 << 16))
 #define T_RADIO_STATE			(0xab	| (1 << 16))
 #define T_URI_CONTACT_TYPE		(0xac	| (1 << 16))
diff --git a/drivers/staging/gdm72xx/usb_ids.h b/drivers/staging/gdm72xx/usb_ids.h
index b34616b..1a61b35 100644
--- a/drivers/staging/gdm72xx/usb_ids.h
+++ b/drivers/staging/gdm72xx/usb_ids.h
@@ -29,7 +29,7 @@
 	.idVendor = (vend), .idProduct = (prod), .bInterfaceClass = (intf)
 
 #define EMERGENCY_PID		0x720f
-#define BL_PID_MASK			0xffc0
+#define BL_PID_MASK		0xffc0
 
 #define USB_DEVICE_BOOTLOADER(vid, pid)	\
 	{USB_DEVICE((vid), ((pid)&BL_PID_MASK)|B_DOWNLOAD)},	\
diff --git a/drivers/staging/gdm72xx/wm_ioctl.h b/drivers/staging/gdm72xx/wm_ioctl.h
index 9f46e06..d022c6c 100644
--- a/drivers/staging/gdm72xx/wm_ioctl.h
+++ b/drivers/staging/gdm72xx/wm_ioctl.h
@@ -19,10 +19,10 @@
 
 #define NETLINK_WIMAX	31
 
-#define SIOCWMIOCTL			SIOCDEVPRIVATE
+#define SIOCWMIOCTL	SIOCDEVPRIVATE
 
-#define SIOCG_DATA			0x8D10
-#define SIOCS_DATA			0x8D11
+#define SIOCG_DATA	0x8D10
+#define SIOCS_DATA	0x8D11
 
 enum {
 	SIOC_DATA_FSM,
@@ -34,7 +34,7 @@ enum {
 	SIOC_DATA_END
 };
 
-#define SIOC_DATA_MAX			16
+#define SIOC_DATA_MAX	16
 
 /* FSM */
 enum {
@@ -67,23 +67,21 @@ enum {
 };
 
 struct fsm_s {
-	int		m_status;	/*main status*/
-	int		c_status;	/*connection status*/
-	int		d_status;	/*oma-dm status*/
+	int	m_status;	/*main status*/
+	int	c_status;	/*connection status*/
+	int	d_status;	/*oma-dm status*/
 };
 
 struct data_s {
-	int		size;
+	int	size;
 	void	*buf;
 };
 
 struct wm_req_s {
 	union {
-		char	ifrn_name[IFNAMSIZ];
+		char ifrn_name[IFNAMSIZ];
 	} ifr_ifrn;
-
 	unsigned short	cmd;
-
 	unsigned short	data_id;
 	struct data_s	data;
 
@@ -91,7 +89,7 @@ struct wm_req_s {
 };
 
 #ifndef ifr_name
-#define ifr_name	ifr_ifrn.ifrn_name
+#define ifr_name ifr_ifrn.ifrn_name
 #endif
 
 #endif
-- 
1.8.4


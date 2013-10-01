Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541Ab3JALJX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 07:09:23 -0400
Received: from mail-bk0-f43.google.com ([209.85.214.43]:48915 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753409Ab3JALJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 07:09:20 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: "David S. Miller" <davem@davemloft.net>,
        Brett Rudley <brudley@broadcom.com>,
        Arend van Spriel <arend@broadcom.com>,
        "Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
        Hante Meuleman <meuleman@broadcom.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the net-next tree
Date: Tue,  1 Oct 2013 13:07:21 +0200
Message-Id: <1380625644-11331-5-git-send-email-treding@nvidia.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <20131001110344.GA20249@ulmo.nvidia.com>
References: <20131001110344.GA20249@ulmo.nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Today's linux-next merge of the net-next tree got conflicts in

	arch/h8300/include/uapi/asm/socket.h
	drivers/net/usb/qmi_wwan.c
	drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
	include/net/secure_seq.h

I removed the h8300 file and fixed up the other three (see below).
Please check if the resolution looks correct.

Thanks,
Thierry
---
diff --cc drivers/net/usb/qmi_wwan.c
index 3d6aaf7,0e59f9e..d03b6b6
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@@ -714,7 -729,8 +729,8 @@@ static const struct usb_device_id produ
  	{QMI_FIXED_INTF(0x2357, 0x0201, 4)},	/* TP-LINK HSUPA Modem MA180 */
  	{QMI_FIXED_INTF(0x2357, 0x9000, 4)},	/* TP-LINK MA260 */
  	{QMI_FIXED_INTF(0x1bc7, 0x1200, 5)},	/* Telit LE920 */
+ 	{QMI_FIXED_INTF(0x1bc7, 0x1201, 2)},	/* Telit LE920 */
 -	{QMI_FIXED_INTF(0x1e2d, 0x12d1, 4)},	/* Cinterion PLxx */
 +	{QMI_FIXED_INTF(0x1e2d, 0x0060, 4)},	/* Cinterion PLxx */
  
  	/* 4. Gobi 1000 devices */
  	{QMI_GOBI1K_DEVICE(0x05c6, 0x9212)},	/* Acer Gobi Modem Device */
diff --cc drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
index 74156f8,5bc0276..7f1340d
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
@@@ -132,35 -132,33 +132,34 @@@ struct pktq *brcmf_bus_gettxq(struct br
   * interface functions from common layer
   */
  
- extern bool brcmf_c_prec_enq(struct device *dev, struct pktq *q,
- 			 struct sk_buff *pkt, int prec);
+ bool brcmf_c_prec_enq(struct device *dev, struct pktq *q, struct sk_buff *pkt,
+ 		      int prec);
  
  /* Receive frame for delivery to OS.  Callee disposes of rxp. */
- extern void brcmf_rx_frames(struct device *dev, struct sk_buff_head *rxlist);
+ void brcmf_rx_frames(struct device *dev, struct sk_buff_head *rxlist);
  
  /* Indication from bus module regarding presence/insertion of dongle. */
- extern int brcmf_attach(uint bus_hdrlen, struct device *dev);
+ int brcmf_attach(uint bus_hdrlen, struct device *dev);
  /* Indication from bus module regarding removal/absence of dongle */
- extern void brcmf_detach(struct device *dev);
+ void brcmf_detach(struct device *dev);
  /* Indication from bus module that dongle should be reset */
- extern void brcmf_dev_reset(struct device *dev);
+ void brcmf_dev_reset(struct device *dev);
  /* Indication from bus module to change flow-control state */
- extern void brcmf_txflowblock(struct device *dev, bool state);
+ void brcmf_txflowblock(struct device *dev, bool state);
  
  /* Notify the bus has transferred the tx packet to firmware */
- extern void brcmf_txcomplete(struct device *dev, struct sk_buff *txp,
- 			     bool success);
+ void brcmf_txcomplete(struct device *dev, struct sk_buff *txp, bool success);
  
- extern int brcmf_bus_start(struct device *dev);
+ int brcmf_bus_start(struct device *dev);
  
  #ifdef CONFIG_BRCMFMAC_SDIO
- extern void brcmf_sdio_exit(void);
- extern void brcmf_sdio_init(void);
- extern void brcmf_sdio_register(void);
+ void brcmf_sdio_exit(void);
+ void brcmf_sdio_init(void);
++void brcmf_sdio_register(void);
  #endif
  #ifdef CONFIG_BRCMFMAC_USB
- extern void brcmf_usb_exit(void);
- extern void brcmf_usb_register(void);
+ void brcmf_usb_exit(void);
 -void brcmf_usb_init(void);
++void brcmf_usb_register(void);
  #endif
  
  #endif				/* _BRCMF_BUS_H_ */
diff --cc include/net/secure_seq.h
index c2e542b,52c1a90..f257486
--- a/include/net/secure_seq.h
+++ b/include/net/secure_seq.h
@@@ -3,18 -3,19 +3,18 @@@
  
  #include <linux/types.h>
  
- extern __u32 secure_ip_id(__be32 daddr);
- extern __u32 secure_ipv6_id(const __be32 daddr[4]);
- extern u32 secure_ipv4_port_ephemeral(__be32 saddr, __be32 daddr, __be16 dport);
- extern u32 secure_ipv6_port_ephemeral(const __be32 *saddr, const __be32 *daddr,
- 				      __be16 dport);
- extern __u32 secure_tcp_sequence_number(__be32 saddr, __be32 daddr,
- 					__be16 sport, __be16 dport);
- extern __u32 secure_tcpv6_sequence_number(const __be32 *saddr, const __be32 *daddr,
- 					  __be16 sport, __be16 dport);
- extern u64 secure_dccp_sequence_number(__be32 saddr, __be32 daddr,
- 				       __be16 sport, __be16 dport);
- extern u64 secure_dccpv6_sequence_number(__be32 *saddr, __be32 *daddr,
- 					 __be16 sport, __be16 dport);
 -void net_secret_init(void);
+ __u32 secure_ip_id(__be32 daddr);
+ __u32 secure_ipv6_id(const __be32 daddr[4]);
+ u32 secure_ipv4_port_ephemeral(__be32 saddr, __be32 daddr, __be16 dport);
+ u32 secure_ipv6_port_ephemeral(const __be32 *saddr, const __be32 *daddr,
+ 			       __be16 dport);
+ __u32 secure_tcp_sequence_number(__be32 saddr, __be32 daddr,
+ 				 __be16 sport, __be16 dport);
+ __u32 secure_tcpv6_sequence_number(const __be32 *saddr, const __be32 *daddr,
+ 				   __be16 sport, __be16 dport);
+ u64 secure_dccp_sequence_number(__be32 saddr, __be32 daddr,
+ 				__be16 sport, __be16 dport);
+ u64 secure_dccpv6_sequence_number(__be32 *saddr, __be32 *daddr,
+ 				  __be16 sport, __be16 dport);
  
  #endif /* _NET_SECURE_SEQ */

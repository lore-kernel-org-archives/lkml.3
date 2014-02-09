Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751646AbaBIIlQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 03:41:16 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:49097 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379AbaBIIlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 03:41:14 -0500
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 1/3] staging: rtl8188eu: remove header file if_ether.h
Date: Sun,  9 Feb 2014 14:10:44 +0530
Message-Id: <1391935247-3797-1-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"if_ether.h" is included in three files but not being used, so
remove "include/if_ether.h" header file and inclusion of this header file.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_recv.c      |    1 -
 drivers/staging/rtl8188eu/hal/rtl8188eu_recv.c |    1 -
 drivers/staging/rtl8188eu/include/if_ether.h   |  111 ------------------------
 drivers/staging/rtl8188eu/os_dep/xmit_linux.c  |    1 -
 4 files changed, 114 deletions(-)
 delete mode 100644 drivers/staging/rtl8188eu/include/if_ether.h

diff --git a/drivers/staging/rtl8188eu/core/rtw_recv.c b/drivers/staging/rtl8188eu/core/rtw_recv.c
index 8490d51..92fb12e 100644
--- a/drivers/staging/rtl8188eu/core/rtw_recv.c
+++ b/drivers/staging/rtl8188eu/core/rtw_recv.c
@@ -24,7 +24,6 @@
 #include <recv_osdep.h>
 #include <mlme_osdep.h>
 #include <ip.h>
-#include <if_ether.h>
 #include <ethernet.h>
 #include <usb_ops.h>
 #include <wifi.h>
diff --git a/drivers/staging/rtl8188eu/hal/rtl8188eu_recv.c b/drivers/staging/rtl8188eu/hal/rtl8188eu_recv.c
index 17c94f4..6e84f08 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188eu_recv.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188eu_recv.c
@@ -23,7 +23,6 @@
 #include <recv_osdep.h>
 #include <mlme_osdep.h>
 #include <ip.h>
-#include <if_ether.h>
 #include <ethernet.h>
 
 #include <usb_ops.h>
diff --git a/drivers/staging/rtl8188eu/include/if_ether.h b/drivers/staging/rtl8188eu/include/if_ether.h
deleted file mode 100644
index db15771..0000000
--- a/drivers/staging/rtl8188eu/include/if_ether.h
+++ /dev/null
@@ -1,111 +0,0 @@
-/******************************************************************************
- *
- * Copyright(c) 2007 - 2011 Realtek Corporation. All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of version 2 of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
- * more details.
- *
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
- *
- *
- ******************************************************************************/
-
-#ifndef _LINUX_IF_ETHER_H
-#define _LINUX_IF_ETHER_H
-
-/*
- *	IEEE 802.3 Ethernet magic constants.  The frame sizes omit the preamble
- *	and FCS/CRC (frame check sequence).
- */
-
-#define ETH_ALEN	6		/* Octets in one ethernet addr	 */
-#define ETH_HLEN	14		/* Total octets in header.	 */
-#define ETH_ZLEN	60		/* Min. octets in frame sans FCS */
-#define ETH_DATA_LEN	1500		/* Max. octets in payload	 */
-#define ETH_FRAME_LEN	1514		/* Max. octets in frame sans FCS */
-
-/*
- *	These are the defined Ethernet Protocol ID's.
- */
-
-#define ETH_P_LOOP	0x0060		/* Ethernet Loopback packet	*/
-#define ETH_P_PUP	0x0200		/* Xerox PUP packet		*/
-#define ETH_P_PUPAT	0x0201		/* Xerox PUP Addr Trans packet	*/
-#define ETH_P_IP	0x0800		/* Internet Protocol packet	*/
-#define ETH_P_X25	0x0805		/* CCITT X.25			*/
-#define ETH_P_ARP	0x0806		/* Address Resolution packet	*/
-#define	ETH_P_BPQ	0x08FF		/* G8BPQ AX.25 Ethernet Packet  */
-#define ETH_P_IEEEPUP	0x0a00		/* Xerox IEEE802.3 PUP packet   */
-#define ETH_P_IEEEPUPAT	0x0a01		/* Xerox IEEE802.3 PUP		*/
-#define ETH_P_DEC       0x6000          /* DEC Assigned proto           */
-#define ETH_P_DNA_DL    0x6001          /* DEC DNA Dump/Load            */
-#define ETH_P_DNA_RC    0x6002          /* DEC DNA Remote Console       */
-#define ETH_P_DNA_RT    0x6003          /* DEC DNA Routing              */
-#define ETH_P_LAT       0x6004          /* DEC LAT                      */
-#define ETH_P_DIAG      0x6005          /* DEC Diagnostics              */
-#define ETH_P_CUST      0x6006          /* DEC Customer use             */
-#define ETH_P_SCA       0x6007          /* DEC Systems Comms Arch       */
-#define ETH_P_RARP      0x8035		/* Reverse Addr Res packet	*/
-#define ETH_P_ATALK	0x809B		/* Appletalk DDP		*/
-#define ETH_P_AARP	0x80F3		/* Appletalk AARP		*/
-#define ETH_P_8021Q	0x8100          /* 802.1Q VLAN Extended Header  */
-#define ETH_P_IPX	0x8137		/* IPX over DIX			*/
-#define ETH_P_IPV6	0x86DD		/* IPv6 over bluebook		*/
-#define ETH_P_PPP_DISC	0x8863		/* PPPoE discovery messages     */
-#define ETH_P_PPP_SES	0x8864		/* PPPoE session messages	*/
-#define ETH_P_ATMMPOA	0x884c		/* MultiProtocol Over ATM	*/
-#define ETH_P_ATMFATE	0x8884		/* Frame-based ATM Transport
-					 * over Ethernet
-					 */
-
-/*
- *	Non DIX types. Won't clash for 1500 types.
- */
-
-#define ETH_P_802_3	0x0001		/* Dummy type for 802.3 frames  */
-#define ETH_P_AX25	0x0002		/* Dummy protocol id for AX.25  */
-#define ETH_P_ALL	0x0003		/* Every packet (be careful!!!) */
-#define ETH_P_802_2	0x0004		/* 802.2 frames			*/
-#define ETH_P_SNAP	0x0005		/* Internal only		*/
-#define ETH_P_DDCMP     0x0006          /* DEC DDCMP: Internal only     */
-#define ETH_P_WAN_PPP   0x0007          /* Dummy type for WAN PPP frames*/
-#define ETH_P_PPP_MP    0x0008          /* Dummy type for PPP MP frames */
-#define ETH_P_LOCALTALK 0x0009		/* Localtalk pseudo type	*/
-#define ETH_P_PPPTALK	0x0010		/* Dummy type for Atalk over PPP*/
-#define ETH_P_TR_802_2	0x0011		/* 802.2 frames			*/
-#define ETH_P_MOBITEX	0x0015		/* Mobitex (kaz@cafe.net)	*/
-#define ETH_P_CONTROL	0x0016		/* Card specific control frames */
-#define ETH_P_IRDA	0x0017		/* Linux-IrDA			*/
-#define ETH_P_ECONET	0x0018		/* Acorn Econet			*/
-
-/*
- *	This is an Ethernet frame header.
- */
-
-struct ethhdr {
-	unsigned char	h_dest[ETH_ALEN];	/* destination eth addr	*/
-	unsigned char	h_source[ETH_ALEN];	/* source ether addr	*/
-	unsigned short	h_proto;		/* packet type ID field	*/
-};
-
-struct _vlan {
-	unsigned short       h_vlan_TCI;	/*  Encap prio and VLAN ID */
-	unsigned short       h_vlan_encapsulated_proto;
-};
-
-#define get_vlan_id(pvlan)				\
-	((ntohs((unsigned short)pvlan->h_vlan_TCI)) & 0xfff)
-#define get_vlan_priority(pvlan)			\
-	((ntohs((unsigned short)pvlan->h_vlan_TCI))>>13)
-#define get_vlan_encap_proto(pvlan)			\
-	 (ntohs((unsigned short)pvlan->h_vlan_encapsulated_proto))
-
-#endif	/* _LINUX_IF_ETHER_H */
diff --git a/drivers/staging/rtl8188eu/os_dep/xmit_linux.c b/drivers/staging/rtl8188eu/os_dep/xmit_linux.c
index 9005971..24a8407 100644
--- a/drivers/staging/rtl8188eu/os_dep/xmit_linux.c
+++ b/drivers/staging/rtl8188eu/os_dep/xmit_linux.c
@@ -23,7 +23,6 @@
 #include <osdep_service.h>
 #include <drv_types.h>
 
-#include <if_ether.h>
 #include <ip.h>
 #include <wifi.h>
 #include <mlme_osdep.h>
-- 
1.7.10.4


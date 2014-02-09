Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751806AbaBIIll (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 03:41:41 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:59415 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763AbaBIIlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 03:41:39 -0500
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 2/3] staging: rtl8188eu: remove header file ip.h
Date: Sun,  9 Feb 2014 14:10:45 +0530
Message-Id: <1391935247-3797-2-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1391935247-3797-1-git-send-email-navin.patidar@gmail.com>
References: <1391935247-3797-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"ip.h" is included in four files but not being used, so
remove "include/ip.h" header file and inclusion of this header file.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_recv.c      |    1 -
 drivers/staging/rtl8188eu/core/rtw_xmit.c      |    1 -
 drivers/staging/rtl8188eu/hal/rtl8188eu_recv.c |    1 -
 drivers/staging/rtl8188eu/include/ip.h         |  126 ------------------------
 drivers/staging/rtl8188eu/os_dep/xmit_linux.c  |    1 -
 5 files changed, 130 deletions(-)
 delete mode 100644 drivers/staging/rtl8188eu/include/ip.h

diff --git a/drivers/staging/rtl8188eu/core/rtw_recv.c b/drivers/staging/rtl8188eu/core/rtw_recv.c
index 92fb12e..b49a246 100644
--- a/drivers/staging/rtl8188eu/core/rtw_recv.c
+++ b/drivers/staging/rtl8188eu/core/rtw_recv.c
@@ -23,7 +23,6 @@
 #include <drv_types.h>
 #include <recv_osdep.h>
 #include <mlme_osdep.h>
-#include <ip.h>
 #include <ethernet.h>
 #include <usb_ops.h>
 #include <wifi.h>
diff --git a/drivers/staging/rtl8188eu/core/rtw_xmit.c b/drivers/staging/rtl8188eu/core/rtw_xmit.c
index aa77270..ca7a25a 100644
--- a/drivers/staging/rtl8188eu/core/rtw_xmit.c
+++ b/drivers/staging/rtl8188eu/core/rtw_xmit.c
@@ -23,7 +23,6 @@
 #include <drv_types.h>
 #include <wifi.h>
 #include <osdep_intf.h>
-#include <ip.h>
 #include <usb_ops.h>
 #include <usb_osintf.h>
 
diff --git a/drivers/staging/rtl8188eu/hal/rtl8188eu_recv.c b/drivers/staging/rtl8188eu/hal/rtl8188eu_recv.c
index 6e84f08..540c5ad 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188eu_recv.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188eu_recv.c
@@ -22,7 +22,6 @@
 #include <drv_types.h>
 #include <recv_osdep.h>
 #include <mlme_osdep.h>
-#include <ip.h>
 #include <ethernet.h>
 
 #include <usb_ops.h>
diff --git a/drivers/staging/rtl8188eu/include/ip.h b/drivers/staging/rtl8188eu/include/ip.h
deleted file mode 100644
index 9fdac6d..0000000
--- a/drivers/staging/rtl8188eu/include/ip.h
+++ /dev/null
@@ -1,126 +0,0 @@
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
-#ifndef _LINUX_IP_H
-#define _LINUX_IP_H
-
-/* SOL_IP socket options */
-
-#define IPTOS_TOS_MASK		0x1E
-#define IPTOS_TOS(tos)		((tos)&IPTOS_TOS_MASK)
-#define	IPTOS_LOWDELAY		0x10
-#define	IPTOS_THROUGHPUT	0x08
-#define	IPTOS_RELIABILITY	0x04
-#define	IPTOS_MINCOST		0x02
-
-#define IPTOS_PREC_MASK		0xE0
-#define IPTOS_PREC(tos)		((tos)&IPTOS_PREC_MASK)
-#define IPTOS_PREC_NETCONTROL           0xe0
-#define IPTOS_PREC_INTERNETCONTROL      0xc0
-#define IPTOS_PREC_CRITIC_ECP           0xa0
-#define IPTOS_PREC_FLASHOVERRIDE        0x80
-#define IPTOS_PREC_FLASH                0x60
-#define IPTOS_PREC_IMMEDIATE            0x40
-#define IPTOS_PREC_PRIORITY             0x20
-#define IPTOS_PREC_ROUTINE              0x00
-
-
-/* IP options */
-#define IPOPT_COPY		0x80
-#define IPOPT_CLASS_MASK	0x60
-#define IPOPT_NUMBER_MASK	0x1f
-
-#define	IPOPT_COPIED(o)		((o)&IPOPT_COPY)
-#define	IPOPT_CLASS(o)		((o)&IPOPT_CLASS_MASK)
-#define	IPOPT_NUMBER(o)		((o)&IPOPT_NUMBER_MASK)
-
-#define	IPOPT_CONTROL		0x00
-#define	IPOPT_RESERVED1		0x20
-#define	IPOPT_MEASUREMENT	0x40
-#define	IPOPT_RESERVED2		0x60
-
-#define IPOPT_END	(0 | IPOPT_CONTROL)
-#define IPOPT_NOOP	(1 | IPOPT_CONTROL)
-#define IPOPT_SEC	(2 | IPOPT_CONTROL | IPOPT_COPY)
-#define IPOPT_LSRR	(3 | IPOPT_CONTROL | IPOPT_COPY)
-#define IPOPT_TIMESTAMP	(4 | IPOPT_MEASUREMENT)
-#define IPOPT_RR	(7 | IPOPT_CONTROL)
-#define IPOPT_SID	(8 | IPOPT_CONTROL | IPOPT_COPY)
-#define IPOPT_SSRR	(9 | IPOPT_CONTROL | IPOPT_COPY)
-#define IPOPT_RA	(20 | IPOPT_CONTROL | IPOPT_COPY)
-
-#define IPVERSION	4
-#define MAXTTL		255
-#define IPDEFTTL	64
-#define IPOPT_OPTVAL 0
-#define IPOPT_OLEN   1
-#define IPOPT_OFFSET 2
-#define IPOPT_MINOFF 4
-#define MAX_IPOPTLEN 40
-#define IPOPT_NOP IPOPT_NOOP
-#define IPOPT_EOL IPOPT_END
-#define IPOPT_TS  IPOPT_TIMESTAMP
-
-#define	IPOPT_TS_TSONLY		0	/* timestamps only */
-#define	IPOPT_TS_TSANDADDR	1	/* timestamps and addresses */
-#define	IPOPT_TS_PRESPEC	3	/* specified modules only */
-
-struct ip_options {
-	__u32		faddr;			/* Saved first hop address */
-	unsigned char	optlen;
-	unsigned char srr;
-	unsigned char rr;
-	unsigned char ts;
-	unsigned char	is_setbyuser:1,	/* Set by setsockopt?		*/
-			is_data:1,	/* Options in __data, rather than skb*/
-			is_strictroute:1,/* Strict source route		*/
-			srr_is_hit:1,	/* Packet destn addr was ours */
-			is_changed:1,	/* IP checksum more not valid	*/
-			rr_needaddr:1,	/* Need to record addr of out dev*/
-			ts_needtime:1,	/* Need to record timestamp	*/
-			ts_needaddr:1;	/* Need to record addr of out dev  */
-	unsigned char router_alert;
-	unsigned char __pad1;
-	unsigned char __pad2;
-	unsigned char __data[0];
-};
-
-#define optlength(opt) (sizeof(struct ip_options) + opt->optlen)
-
-struct iphdr {
-#if defined(__LITTLE_ENDIAN_BITFIELD)
-	__u8	ihl:4,
-		version:4;
-#elif defined(__BIG_ENDIAN_BITFIELD)
-	__u8	version:4,
-		ihl:4;
-#endif
-	__u8	tos;
-	__u16	tot_len;
-	__u16	id;
-	__u16	frag_off;
-	__u8	ttl;
-	__u8	protocol;
-	__u16	check;
-	__u32	saddr;
-	__u32	daddr;
-	/*The options start here. */
-};
-
-#endif	/* _LINUX_IP_H */
diff --git a/drivers/staging/rtl8188eu/os_dep/xmit_linux.c b/drivers/staging/rtl8188eu/os_dep/xmit_linux.c
index 24a8407..8097903 100644
--- a/drivers/staging/rtl8188eu/os_dep/xmit_linux.c
+++ b/drivers/staging/rtl8188eu/os_dep/xmit_linux.c
@@ -23,7 +23,6 @@
 #include <osdep_service.h>
 #include <drv_types.h>
 
-#include <ip.h>
 #include <wifi.h>
 #include <mlme_osdep.h>
 #include <xmit_osdep.h>
-- 
1.7.10.4


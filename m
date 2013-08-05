Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754423Ab3HEJ64 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 05:58:56 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:45718 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754310Ab3HEJ6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 05:58:52 -0400
From: Iker Pedrosa <ikerpedrosam@gmail.com>
To: pavel@ucw.cz
Cc: gregkh@linuxfoundation.org, justinmattock@gmail.com,
        ikerpedrosam@gmail.com, mujeeb.adil@gmail.com, harsh1kumar@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/6] Staging: winbond: mds: fixed some lines over 80 characters
Date: Mon,  5 Aug 2013 11:58:30 +0200
Message-Id: <1375696712-5276-5-git-send-email-ikerpedrosam@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1375696712-5276-1-git-send-email-ikerpedrosam@gmail.com>
References: <1375696712-5276-1-git-send-email-ikerpedrosam@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed some coding style issues

Signed-off-by: Iker Pedrosa <ikerpedrosam@gmail.com>
---
 drivers/staging/winbond/mds.c | 56 +++++++++++++++++++++++++------------------
 1 file changed, 33 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/winbond/mds.c b/drivers/staging/winbond/mds.c
index faa93f0..fcc3d21 100644
--- a/drivers/staging/winbond/mds.c
+++ b/drivers/staging/winbond/mds.c
@@ -15,7 +15,8 @@ Mds_initial(struct wbsoft_priv *adapter)
 	return hal_get_tx_buffer(&adapter->sHwData, &pMds->pTxBuffer);
 }
 
-static void Mds_DurationSet(struct wbsoft_priv *adapter,  struct wb35_descriptor *pDes,  u8 *buffer)
+static void Mds_DurationSet(struct wbsoft_priv *adapter,
+			    struct wb35_descriptor *pDes, u8 *buffer)
 {
 	struct T00_descriptor *pT00;
 	struct T01_descriptor *pT01;
@@ -43,10 +44,11 @@ static void Mds_DurationSet(struct wbsoft_priv *adapter,  struct wb35_descriptor
 	 * Set RTS/CTS mechanism
 	 ******************************************/
 	if (!boGroupAddr) {
-		/* NOTE : If the protection mode is enabled and the MSDU will be fragmented,
-		 *		 the tx rates of MPDUs will all be DSSS rates. So it will not use
-		 *		 CTS-to-self in this case. CTS-To-self will only be used when without
-		 *		 fragmentation. -- 20050112 */
+		/* NOTE : If the protection mode is enabled and the MSDU will
+		 *	  be fragmented, the tx rates of MPDUs will all be DSSS
+		 *	  rates. So it will not use CTS-to-self in this case.
+		 *	  CTS-To-self will only be used when without
+		 *	  fragmentation. -- 20050112 */
 		BodyLen = (u16)pT00->T00_frame_length;	/* include 802.11 header */
 		BodyLen += 4;	/* CRC */
 
@@ -90,8 +92,8 @@ static void Mds_DurationSet(struct wbsoft_priv *adapter,  struct wb35_descriptor
 				 * CTS Rate : 24 Mega bps
 				 * CTS frame length = 14 bytes */
 				Duration += (DEFAULT_SIFSTIME +
-								PREAMBLE_PLUS_SIGNAL_PLUS_SIGNALEXTENSION +
-								((112 + 22 + 95)/96)*Tsym);
+					    PREAMBLE_PLUS_SIGNAL_PLUS_SIGNALEXTENSION +
+					    ((112 + 22 + 95)/96)*Tsym);
 			} else {
 				/* CTS + 1 SIFS + CTS duration
 				 * CTS Rate : ?? Mega bps
@@ -101,7 +103,8 @@ static void Mds_DurationSet(struct wbsoft_priv *adapter,  struct wb35_descriptor
 				else
 					Duration += SHORT_PREAMBLE_PLUS_PLCPHEADER_TIME;
 
-				Duration += (((112 + Rate-1) / Rate) + DEFAULT_SIFSTIME);
+				Duration += (((112 + Rate-1) / Rate) +
+					     DEFAULT_SIFSTIME);
 			}
 		}
 
@@ -127,9 +130,10 @@ static void Mds_DurationSet(struct wbsoft_priv *adapter,  struct wb35_descriptor
 				 *  Rate : ??Mega bps
 				 *  ACK frame length = 14 bytes, tx rate = 24M */
 				Duration = PREAMBLE_PLUS_SIGNAL_PLUS_SIGNALEXTENSION * 3;
-				Duration += (((NextBodyLen*8 + 22 + Rate*4 - 1)/(Rate*4)) * Tsym +
-							(((2*14)*8 + 22 + 95)/96)*Tsym +
-							DEFAULT_SIFSTIME*3);
+				Duration += (((NextBodyLen*8 + 22 + Rate*4 - 1)
+					     /(Rate*4)) * Tsym +
+					     (((2*14)*8 + 22 + 95)/96)*Tsym +
+					    DEFAULT_SIFSTIME*3);
 			} else {
 				/* DSSS
 				 *  data transmit time + 2 ACK + 3 SIFS
@@ -141,8 +145,9 @@ static void Mds_DurationSet(struct wbsoft_priv *adapter,  struct wb35_descriptor
 				else
 					Duration = SHORT_PREAMBLE_PLUS_PLCPHEADER_TIME*3;
 
-				Duration += (((NextBodyLen + (2*14))*8 + Rate-1) / Rate +
-							DEFAULT_SIFSTIME*3);
+				Duration += (((NextBodyLen + (2*14))*8
+					     + Rate-1) / Rate +
+					    DEFAULT_SIFSTIME*3);
 			}
 
 			((u16 *)buffer)[5] = cpu_to_le16(Duration); /* 4 USHOR for skip 8B USB, 2USHORT=FC + Duration */
@@ -168,7 +173,8 @@ static void Mds_DurationSet(struct wbsoft_priv *adapter,  struct wb35_descriptor
 			 * ACK frame length = 14 bytes */
 			Duration = PREAMBLE_PLUS_SIGNAL_PLUS_SIGNALEXTENSION;
 			/* The Tx rate of ACK use 24M */
-			Duration += (((112 + 22 + 95)/96)*Tsym + DEFAULT_SIFSTIME);
+			Duration += (((112 + 22 + 95)/96)*Tsym +
+				    DEFAULT_SIFSTIME);
 		} else {
 			/* DSSS
 			 * 1 ACK + 1 SIFS
@@ -191,7 +197,8 @@ static void Mds_DurationSet(struct wbsoft_priv *adapter,  struct wb35_descriptor
 }
 
 /* The function return the 4n size of usb pk */
-static u16 Mds_BodyCopy(struct wbsoft_priv *adapter, struct wb35_descriptor *pDes, u8 *TargetBuffer)
+static u16 Mds_BodyCopy(struct wbsoft_priv *adapter,
+			struct wb35_descriptor *pDes, u8 *TargetBuffer)
 {
 	struct T00_descriptor *pT00;
 	struct wb35_mds *pMds = &adapter->Mds;
@@ -246,7 +253,7 @@ static u16 Mds_BodyCopy(struct wbsoft_priv *adapter, struct wb35_descriptor *pDe
 				buf_index++;
 				buf_index %= MAX_DESCRIPTOR_BUFFER_INDEX;
 			} else {
-				u8	*pctmp = pDes->buffer_address[buf_index];
+				u8 *pctmp = pDes->buffer_address[buf_index];
 				pctmp += CopySize;
 				pDes->buffer_address[buf_index] = pctmp;
 				pDes->buffer_size[buf_index] -= CopySize;
@@ -290,7 +297,8 @@ static u16 Mds_BodyCopy(struct wbsoft_priv *adapter, struct wb35_descriptor *pDe
 	return Size;
 }
 
-static void Mds_HeaderCopy(struct wbsoft_priv *adapter, struct wb35_descriptor *pDes, u8 *TargetBuffer)
+static void Mds_HeaderCopy(struct wbsoft_priv *adapter,
+			   struct wb35_descriptor *pDes, u8 *TargetBuffer)
 {
 	struct wb35_mds *pMds = &adapter->Mds;
 	u8	*src_buffer = pDes->buffer_address[0]; /* 931130.5.g */
@@ -391,11 +399,12 @@ static void Mds_HeaderCopy(struct wbsoft_priv *adapter, struct wb35_descriptor *
 		pDes->PreambleMode =  WLAN_PREAMBLE_TYPE_LONG;
 	else
 		pDes->PreambleMode =  CURRENT_PREAMBLE_MODE;
-	pT01->T01_plcp_header_length = pDes->PreambleMode;	/* Set preamble */
+	pT01->T01_plcp_header_length = pDes->PreambleMode; /* Set preamble */
 
 }
 
-static void MLME_GetNextPacket(struct wbsoft_priv *adapter, struct wb35_descriptor *desc)
+static void MLME_GetNextPacket(struct wbsoft_priv *adapter,
+			       struct wb35_descriptor *desc)
 {
 	desc->InternalUsed = desc->buffer_start_index + desc->buffer_number;
 	desc->InternalUsed %= MAX_DESCRIPTOR_BUFFER_INDEX;
@@ -423,7 +432,8 @@ static void MLMEfreeMMPDUBuffer(struct wbsoft_priv *adapter, s8 *pData)
 	}
 }
 
-static void MLME_SendComplete(struct wbsoft_priv *adapter, u8 PacketID, unsigned char SendOK)
+static void MLME_SendComplete(struct wbsoft_priv *adapter, u8 PacketID,
+			      unsigned char SendOK)
 {
     /* Reclaim the data buffer */
 	adapter->sMlmeFrame.len = 0;
@@ -440,9 +450,9 @@ Mds_Tx(struct wbsoft_priv *adapter)
 	struct wb35_mds *pMds = &adapter->Mds;
 	struct wb35_descriptor	TxDes;
 	struct wb35_descriptor *pTxDes = &TxDes;
-	u8		*XmitBufAddress;
-	u16		XmitBufSize, PacketSize, stmp, CurrentSize, FragmentThreshold;
-	u8		FillIndex, TxDesIndex, FragmentCount, FillCount;
+	u8	*XmitBufAddress;
+	u16	XmitBufSize, PacketSize, stmp, CurrentSize, FragmentThreshold;
+	u8	FillIndex, TxDesIndex, FragmentCount, FillCount;
 	unsigned char	BufferFilled = false;
 
 
-- 
1.8.1.2


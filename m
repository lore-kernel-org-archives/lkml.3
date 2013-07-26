Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933091Ab3GZUyK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 16:54:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51015 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932867Ab3GZUxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 16:53:41 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 24/59] sh_eth: fix unhandled RFE interrupt
Date: Fri, 26 Jul 2013 13:52:48 -0700
Message-Id: <20130726205016.399656912@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130726205013.795696531@linuxfoundation.org>
References: <20130726205013.795696531@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

[ Upstream commit ca8c35852138ee0585eaffe6b9f10a5261ea7771 ]

EESR.RFE (receive FIFO overflow) interrupt is enabled by the driver on all SoCs
and sh_eth_error() handles it but it's not present in any initializer/assignment
of the 'eesr_err_check' field of 'struct sh_eth_cpu_data'. This leads to that
interrupt not being handled and cleared, and finally to disabling IRQ and the
driver being non-functional.

Modify DEFAULT_EESR_ERR_CHECK macro and all explicit initializers of the above
mentioned field to contain the EESR.RFE bit. Remove useless backslashes from the
initializers, while at it.

Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/renesas/sh_eth.c |   17 +++++++++--------
 drivers/net/ethernet/renesas/sh_eth.h |    2 +-
 2 files changed, 10 insertions(+), 9 deletions(-)

--- a/drivers/net/ethernet/renesas/sh_eth.c
+++ b/drivers/net/ethernet/renesas/sh_eth.c
@@ -137,8 +137,9 @@ static struct sh_eth_cpu_data sh_eth_my_
 	.rmcr_value	= 0x00000001,
 
 	.tx_check	= EESR_FTC | EESR_CND | EESR_DLC | EESR_CD | EESR_RTO,
-	.eesr_err_check	= EESR_TWB | EESR_TABT | EESR_RABT | EESR_RDE |
-			  EESR_RFRMER | EESR_TFE | EESR_TDE | EESR_ECI,
+	.eesr_err_check	= EESR_TWB | EESR_TABT | EESR_RABT | EESR_RFE |
+			  EESR_RDE | EESR_RFRMER | EESR_TFE | EESR_TDE |
+			  EESR_ECI,
 	.tx_error_check	= EESR_TWB | EESR_TABT | EESR_TDE | EESR_TFE,
 
 	.apr		= 1,
@@ -252,9 +253,9 @@ static struct sh_eth_cpu_data sh_eth_my_
 	.eesipr_value	= DMAC_M_RFRMER | DMAC_M_ECI | 0x003fffff,
 
 	.tx_check	= EESR_TC1 | EESR_FTC,
-	.eesr_err_check	= EESR_TWB1 | EESR_TWB | EESR_TABT | EESR_RABT | \
-			  EESR_RDE | EESR_RFRMER | EESR_TFE | EESR_TDE | \
-			  EESR_ECI,
+	.eesr_err_check	= EESR_TWB1 | EESR_TWB | EESR_TABT | EESR_RABT |
+			  EESR_RFE | EESR_RDE | EESR_RFRMER | EESR_TFE |
+			  EESR_TDE | EESR_ECI,
 	.tx_error_check	= EESR_TWB1 | EESR_TWB | EESR_TABT | EESR_TDE | \
 			  EESR_TFE,
 	.fdr_value	= 0x0000072f,
@@ -361,9 +362,9 @@ static struct sh_eth_cpu_data sh_eth_my_
 	.eesipr_value	= DMAC_M_RFRMER | DMAC_M_ECI | 0x003fffff,
 
 	.tx_check	= EESR_TC1 | EESR_FTC,
-	.eesr_err_check	= EESR_TWB1 | EESR_TWB | EESR_TABT | EESR_RABT | \
-			  EESR_RDE | EESR_RFRMER | EESR_TFE | EESR_TDE | \
-			  EESR_ECI,
+	.eesr_err_check	= EESR_TWB1 | EESR_TWB | EESR_TABT | EESR_RABT |
+			  EESR_RFE | EESR_RDE | EESR_RFRMER | EESR_TFE |
+			  EESR_TDE | EESR_ECI,
 	.tx_error_check	= EESR_TWB1 | EESR_TWB | EESR_TABT | EESR_TDE | \
 			  EESR_TFE,
 
--- a/drivers/net/ethernet/renesas/sh_eth.h
+++ b/drivers/net/ethernet/renesas/sh_eth.h
@@ -467,7 +467,7 @@ enum EESR_BIT {
 
 #define DEFAULT_TX_CHECK	(EESR_FTC | EESR_CND | EESR_DLC | EESR_CD | \
 				 EESR_RTO)
-#define DEFAULT_EESR_ERR_CHECK	(EESR_TWB | EESR_TABT | EESR_RABT | \
+#define DEFAULT_EESR_ERR_CHECK	(EESR_TWB | EESR_TABT | EESR_RABT | EESR_RFE | \
 				 EESR_RDE | EESR_RFRMER | EESR_ADE | \
 				 EESR_TFE | EESR_TDE | EESR_ECI)
 #define DEFAULT_TX_ERROR_CHECK	(EESR_TWB | EESR_TABT | EESR_ADE | EESR_TDE | \



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576AbaKFXZa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 18:25:30 -0500
Received: from mail-oi0-f50.google.com ([209.85.218.50]:52357 "EHLO
	mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301AbaKFXZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 18:25:25 -0500
Date: Thu, 6 Nov 2014 17:24:54 -0600
From: Jaime Arrocha <jarrocha27@gmail.com>
To: gregkh@linuxfoundation.org
Cc: liodot@gmail.com, charrer@alacritech.com, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: slicoss.c: checkpatch warnings
Message-ID: <20141106232454.GA16568@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correction of warnings of lines with 80 plus character.
Some warnings were left in favor of readability, others
were created by breaking quoted strings.
Memory barriers comments are obvious but remove warnings.
Let me know if any corrections are needed.

Signed-off-by: Jaime Arrocha <jarrocha27@gmail.com>
---
 drivers/staging/slicoss/slicoss.c | 31 ++++++++++++++++++-------------
 1 file changed, 18 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/slicoss/slicoss.c b/drivers/staging/slicoss/slicoss.c
index cff7cbe..e546dae 100644
--- a/drivers/staging/slicoss/slicoss.c
+++ b/drivers/staging/slicoss/slicoss.c
@@ -99,8 +99,8 @@
 #include "slic.h"
 
 static uint slic_first_init = 1;
-static char *slic_banner = "Alacritech SLIC Technology(tm) Server "
-		"and Storage Accelerator (Non-Accelerated)";
+char *slic_banner = "Alacritech SLIC Technology(tm) Server and "
+			"Storage Accelerator (Non-Accelerated)";
 
 static char *slic_proc_version = "2.0.351  2006/07/14 12:26:00";
 
@@ -139,7 +139,7 @@ static inline void slic_reg32_write(void __iomem *reg, u32 value, bool flush)
 {
 	writel(value, reg);
 	if (flush)
-		mb();
+		mb();	/* memory barrier for mapped registry */
 }
 
 static inline void slic_reg64_write(struct adapter *adapter, void __iomem *reg,
@@ -154,7 +154,7 @@ static inline void slic_reg64_write(struct adapter *adapter, void __iomem *reg,
 	}
 	writel(value, reg);
 	if (flush)
-		mb();
+		mb();	/* memory barrier for mapped registry */
 	spin_unlock_irqrestore(&adapter->bit64reglock.lock,
 				adapter->bit64reglock.flags);
 }
@@ -498,12 +498,14 @@ static int slic_card_download(struct adapter *adapter)
 			slic_reg32_write(&slic_regs->slic_wcs,
 					 baseaddress + codeaddr, FLUSH);
 			/* Write out instruction to low addr */
-			slic_reg32_write(&slic_regs->slic_wcs, instruction, FLUSH);
+			slic_reg32_write(&slic_regs->slic_wcs,
+					 instruction, FLUSH);
 			instruction = *(u32 *)(fw->data + index);
 			index += 4;
 
 			/* Write out instruction to high addr */
-			slic_reg32_write(&slic_regs->slic_wcs, instruction, FLUSH);
+			slic_reg32_write(&slic_regs->slic_wcs,
+					 instruction, FLUSH);
 			instruction = *(u32 *)(fw->data + index);
 			index += 4;
 		}
@@ -1884,7 +1886,8 @@ static void slic_xmit_fail(struct adapter *adapter,
 			break;
 		case XMIT_FAIL_HOSTCMD_FAIL:
 			dev_err(&adapter->netdev->dev,
-				"xmit_start skb[%p] type[%x] No host commands available\n", skb, skb->pkt_type);
+				"xmit_start skb[%p] type[%x] No host commands available\n",
+				skb, skb->pkt_type);
 			break;
 		}
 	}
@@ -2096,11 +2099,10 @@ static void slic_interrupt_card_up(u32 isr, struct adapter *adapter,
 				}
 			} else if (isr & ISR_XDROP) {
 				dev_err(&dev->dev,
-						"isr & ISR_ERR [%x] ISR_XDROP\n", isr);
+					"isr & ISR_ERR [%x] ISR_XDROP\n", isr);
 			} else {
 				dev_err(&dev->dev,
-						"isr & ISR_ERR [%x]\n",
-						isr);
+					"isr & ISR_ERR [%x]\n",	isr);
 			}
 		}
 
@@ -2340,7 +2342,8 @@ static int slic_if_init(struct adapter *adapter)
 				 SLIC_GET_ADDR_LOW(&pshmem->isr), FLUSH);
 #else
 		slic_reg32_write(&slic_regs->slic_addr_upper, 0, DONT_FLUSH);
-		slic_reg32_write(&slic_regs->slic_isp, (u32)&pshmem->isr, FLUSH);
+		slic_reg32_write(&slic_regs->slic_isp,
+				 (u32)&pshmem->isr, FLUSH);
 #endif
 		spin_unlock_irqrestore(&adapter->bit64reglock.lock,
 					adapter->bit64reglock.flags);
@@ -2555,7 +2558,8 @@ static int slic_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 
 			if (copy_from_user(data, rq->ifr_data, 28)) {
 				PRINT_ERROR
-				    ("slic: copy_from_user FAILED getting initial simba param\n");
+				    ("slic: copy_from_user FAILED getting"
+				     " initial simba param\n");
 				return -EFAULT;
 			}
 
@@ -2570,7 +2574,8 @@ static int slic_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 				   (tracemon_request ==
 				    SLIC_DUMP_IN_PROGRESS)) {
 				PRINT_ERROR
-				    ("ATK Diagnostic Trace Dump Requested but already in progress... ignore\n");
+				    ("ATK Diagnostic Trace Dump Requested"
+				     " but already in progress... ignore\n");
 			} else {
 				PRINT_ERROR
 				    ("ATK Diagnostic Trace Dump Requested\n");
-- 
1.8.3.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940Ab3ALBRL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 20:17:11 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20147 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752427Ab3ALBRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 20:17:09 -0500
X-Authority-Analysis: v=2.0 cv=O9a7TWBW c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=t-QQXLkMxoMA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=LItqDF-jgyYA:10 a=JfrnYn6hAAAA:8 a=AgIYPZolaqLdBpfqN0cA:9 a=PUjeQqilurYA:10 a=3Rfx1nUSh_UA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1357953421.5141.48.camel@gandalf.local.home>
Subject: [PATCH] staging/sb105x: PARPORT config is not good enough must use
 PARPORT_PC
From: Steven Rostedt <rostedt@goodmis.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 11 Jan 2013 20:17:01 -0500
In-Reply-To: <20130112004244.GA2578@kroah.com>
References: <20130110143241.041ef77011ef7b1f68ae5c61@canb.auug.org.au>
	 <50EF11B2.9090505@infradead.org>
	 <1357851057.5141.16.camel@gandalf.local.home>
	 <50EF3B6A.70704@infradead.org> <20130112004244.GA2578@kroah.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sb105x driver calls parport_pc_probe_port() which isn't defined if
PARPORT_PC isn't enabled. Protecting it with CONFIG_PARPORT is not good
enough, must protect it with CONFIG_PARPORT_PC.

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
based off of latest linux-next

diff --git a/drivers/staging/sb105x/sb_pci_mp.c b/drivers/staging/sb105x/sb_pci_mp.c
index 131afd0c..9464f38 100644
--- a/drivers/staging/sb105x/sb_pci_mp.c
+++ b/drivers/staging/sb105x/sb_pci_mp.c
@@ -3054,7 +3054,7 @@ static int init_mp_dev(struct pci_dev *pcidev, mppcibrd_t brd)
 				sbdev->nr_ports = ((portnum_hex/16)*10) + (portnum_hex % 16);
 			}
 			break;
-#ifdef CONFIG_PARPORT
+#ifdef CONFIG_PARPORT_PC
 		case PCI_DEVICE_ID_MP2S1P :
 			sbdev->nr_ports = 2;
 



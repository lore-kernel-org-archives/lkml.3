Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757786Ab3ERC2H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 22:28:07 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:14784 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756107Ab3ERCQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 22:16:48 -0400
X-Authority-Analysis: v=2.0 cv=UY7TuduN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=exmykxdffGYA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=nPpayWS1zCUA:10 a=6ohNodAXAAAA:8 a=VwQbUJbxAAAA:8 a=ag1SF4gXAAAA:8 a=aCPqOQJ_S1qBLZ7JjQ4A:9 a=gDjHQkheYgsA:10 a=bONE_x0Jl_YA:10 a=1TSTQ8KKaH4A:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130518021644.799014003@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 17 May 2013 22:16:16 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Michael Braun <michael-dev@fami-braun.de>,
        Shengzhou Liu <Shengzhou.Liu@freescale.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 019/136 ] usb: remove redundant tdi_reset
References: <20130518021557.139113314@goodmis.org>
Content-Disposition: inline; filename=0019-usb-remove-redundant-tdi_reset.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.4 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Shengzhou Liu <Shengzhou.Liu@freescale.com>

[ Upstream commit 61ac6ac8d662ac7ac67c864954d39d1b19948354 ]

We remove the redundant tdi_reset in ehci_setup since there
is already it in ehci_reset.
It was observed that the duplicated tdi_reset was causing
the PHY_CLK_VALID bit unstable.

Reported-by: Michael Braun <michael-dev@fami-braun.de>
Signed-off-by: Shengzhou Liu <Shengzhou.Liu@freescale.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Cc: stable <stable@vger.kernel.org> # 3.6+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/usb/host/ehci-hcd.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/usb/host/ehci-hcd.c b/drivers/usb/host/ehci-hcd.c
index b05c686..e90ca68 100644
--- a/drivers/usb/host/ehci-hcd.c
+++ b/drivers/usb/host/ehci-hcd.c
@@ -684,9 +684,6 @@ static int ehci_setup(struct usb_hcd *hcd)
 	if (retval)
 		return retval;
 
-	if (ehci_is_TDI(ehci))
-		tdi_reset(ehci);
-
 	ehci_reset(ehci);
 
 	return 0;
-- 
1.7.10.4



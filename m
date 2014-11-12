Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932272AbaKLB0l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:26:41 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58920 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932253AbaKLB0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:26:36 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Anton Kolesov <akolesov@synopsys.com>,
        Vineet Gupta <vgupta@synopsys.com>
Subject: [PATCH 3.17 137/319] ARC: [nsimosci] Allow "headless" models to boot
Date: Wed, 12 Nov 2014 10:14:35 +0900
Message-Id: <20141112011015.200103834@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vineet Gupta <vgupta@synopsys.com>

commit 5c05483e2db91890faa9a7be0a831701a3f442d6 upstream.

There are certain test configuration of virtual platform which don't
have any real console device (uart/pgu). So add tty0 as a fallback console
device to allow system to boot and be accessible via telnet

Otherwise with ttyS0 as only console, but 8250 disabled in kernel build,
init chokes.

Reported-by: Anton Kolesov <akolesov@synopsys.com>
Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arc/boot/dts/nsimosci.dts |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arc/boot/dts/nsimosci.dts
+++ b/arch/arc/boot/dts/nsimosci.dts
@@ -20,7 +20,7 @@
 		/* this is for console on PGU */
 		/* bootargs = "console=tty0 consoleblank=0"; */
 		/* this is for console on serial */
-		bootargs = "earlycon=uart8250,mmio32,0xc0000000,115200n8 console=ttyS0,115200n8 consoleblank=0 debug";
+		bootargs = "earlycon=uart8250,mmio32,0xc0000000,115200n8 console=tty0 console=ttyS0,115200n8 consoleblank=0 debug";
 	};
 
 	aliases {



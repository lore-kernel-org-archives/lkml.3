Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756503Ab3ASBbB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 20:31:01 -0500
Received: from mail.kernel.org ([198.145.19.201]:56544 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756204Ab3ASBSM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 20:18:12 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Tony Prisk <linux@prisktech.co.nz>
Subject: [ 27/33] tty: serial: vt8500: fix return value check in vt8500_serial_probe()
Date: Fri, 18 Jan 2013 17:16:52 -0800
Message-Id: <20130119010355.658816062@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130119010345.885772698@linuxfoundation.org>
References: <20130119010345.885772698@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

commit a6dd114e16cbc4410049a90a8a67b967333d108d upstream.

In case of error, function of_clk_get() returns ERR_PTR()
and never returns NULL. The NULL test in the return value
check should be replaced with IS_ERR().

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Acked-by: Tony Prisk <linux@prisktech.co.nz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/vt8500_serial.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/serial/vt8500_serial.c
+++ b/drivers/tty/serial/vt8500_serial.c
@@ -604,7 +604,7 @@ static int __devinit vt8500_serial_probe
 	vt8500_port->uart.flags = UPF_IOREMAP | UPF_BOOT_AUTOCONF;
 
 	vt8500_port->clk = of_clk_get(pdev->dev.of_node, 0);
-	if (vt8500_port->clk) {
+	if (!IS_ERR(vt8500_port->clk)) {
 		vt8500_port->uart.uartclk = clk_get_rate(vt8500_port->clk);
 	} else {
 		/* use the default of 24Mhz if not specified and warn */



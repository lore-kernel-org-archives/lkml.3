Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756258Ab3ASBSN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 20:18:13 -0500
Received: from mail.kernel.org ([198.145.19.201]:56534 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756114Ab3ASBSK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 20:18:10 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Chen Jun <jun.d.chen@intel.com>, channing <chao.bi@intel.com>
Subject: [ 26/33] serial:ifx6x60:Delete SPI timer when shut down port
Date: Fri, 18 Jan 2013 17:16:51 -0800
Message-Id: <20130119010355.324329408@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130119010345.885772698@linuxfoundation.org>
References: <20130119010345.885772698@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: chao bi <chao.bi@intel.com>

commit 014b9b4ce84281ccb3d723c792bed19815f3571a upstream.

When shut down SPI port, it's possible that MRDY has been asserted and a SPI
timer was activated waiting for SRDY assert, in the case, it needs to delete
this timer.

Signed-off-by: Chen Jun <jun.d.chen@intel.com>
Signed-off-by: channing <chao.bi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/ifx6x60.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/tty/serial/ifx6x60.c
+++ b/drivers/tty/serial/ifx6x60.c
@@ -552,6 +552,7 @@ static void ifx_port_shutdown(struct tty
 		container_of(port, struct ifx_spi_device, tty_port);
 
 	mrdy_set_low(ifx_dev);
+	del_timer(&ifx_dev->spi_timer);
 	clear_bit(IFX_SPI_STATE_TIMER_PENDING, &ifx_dev->flags);
 	tasklet_kill(&ifx_dev->io_work_tasklet);
 }



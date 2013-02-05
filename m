Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757172Ab3BEWdd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 17:33:33 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47842 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757072Ab3BEWIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 17:08:02 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Chen Jun <jun.d.chen@intel.com>, channing <chao.bi@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 07/93] serial:ifx6x60:Delete SPI timer when shut down port
Date: Tue,  5 Feb 2013 20:05:56 -0200
Message-Id: <1360102042-10732-8-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
References: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: chao bi <chao.bi@intel.com>

commit 014b9b4ce84281ccb3d723c792bed19815f3571a upstream.

When shut down SPI port, it's possible that MRDY has been asserted and a SPI
timer was activated waiting for SRDY assert, in the case, it needs to delete
this timer.

Signed-off-by: Chen Jun <jun.d.chen@intel.com>
Signed-off-by: channing <chao.bi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ herton: adjust context ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/tty/serial/ifx6x60.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/tty/serial/ifx6x60.c b/drivers/tty/serial/ifx6x60.c
index 144cd39..17f587c 100644
--- a/drivers/tty/serial/ifx6x60.c
+++ b/drivers/tty/serial/ifx6x60.c
@@ -552,6 +552,7 @@ static void ifx_port_shutdown(struct tty_port *port)
 		container_of(port, struct ifx_spi_device, tty_port);
 
 	mrdy_set_low(ifx_dev);
+	del_timer(&ifx_dev->spi_timer);
 	clear_bit(IFX_SPI_STATE_TIMER_PENDING, &ifx_dev->flags);
 	tasklet_kill(&ifx_dev->io_work_tasklet);
 }
-- 
1.7.9.5


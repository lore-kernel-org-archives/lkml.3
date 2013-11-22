Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755990Ab3KVSHw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 13:07:52 -0500
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:41177 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755903Ab3KVSGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 13:06:33 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH staging-next 2/4] staging/fwserial: Up the tty buffer limit to 128K
Date: Fri, 22 Nov 2013 13:06:09 -0500
Message-Id: <1385143571-3571-3-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1385143571-3571-1-git-send-email-peter@hurleysoftware.com>
References: <1385143571-3571-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The firewire driver can overrun the tty buffers before the
line discipline can throttle the input; up the buffer limit.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/staging/fwserial/fwserial.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/fwserial/fwserial.c b/drivers/staging/fwserial/fwserial.c
index c96f62e..cad9e3f 100644
--- a/drivers/staging/fwserial/fwserial.c
+++ b/drivers/staging/fwserial/fwserial.c
@@ -2225,6 +2225,7 @@ static int fwserial_create(struct fw_unit *unit)
 		port->index = FWTTY_INVALID_INDEX;
 		port->port.ops = &fwtty_port_ops;
 		port->serial = serial;
+		tty_buffer_set_limit(&port->port, 128 * 1024);
 
 		spin_lock_init(&port->lock);
 		INIT_DELAYED_WORK(&port->drain, fwtty_drain_tx);
-- 
1.8.1.2


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792AbbAMNpW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 08:45:22 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38894 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071AbbAMNpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 08:45:19 -0500
From: Markus Pargmann <mpa@pengutronix.de>
To: Paul Clements <Paul.Clements@steeleye.com>
Cc: nbd-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de, Markus Pargmann <mpa@pengutronix.de>
Subject: [RFC 0/4] nbd: root device support
Date: Tue, 13 Jan 2015 14:44:21 +0100
Message-Id: <1421156665-27318-1-git-send-email-mpa@pengutronix.de>
X-Mailer: git-send-email 2.1.4
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: mpa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This series adds root device support to nbd. The last patch contains a simple
and small implementation of the nbd-client to make the nbd negotiation. After
the negotiation, the socket is bound to nbd0 so the rootfs can be mounted from
nbd0. The connection parameters are passed as module parameter in the following
format:
	nbd.root_server=[<SERVER_IP>:]<SERVER_PORT>/<EXPORT_NAME>

Patches 2 and 3 are preparation patches for patch 4 which adds nbd-root.

Patch 4 uses blkdev_get_by_dev() at the moment to get the blockdevice for a
specific nbd_device. However the documentation of blkdev_get_by_dev() states
that the function should not be used. I couldn't find any better way to get
the blockdevice so I would appreciate any suggestions on how to do it correctly.

Best regards,

Markus


Markus Pargmann (4):
  nbd: Replace kthread_create with kthread_run
  nbd: Split 'DO_IT' into three functions
  nbd: Create helper functions for ioctls
  nbd: Add support for nbd as root device

 drivers/block/nbd.c | 531 ++++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 454 insertions(+), 77 deletions(-)

-- 
2.1.4


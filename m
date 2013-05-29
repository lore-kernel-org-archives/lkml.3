Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966064Ab3E2NHK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 09:07:10 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:41929 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934837Ab3E2NHJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 09:07:09 -0400
From: Ravi Babu <ravibabu@ti.com>
To: <linux-usb@vger.kernel.org>
CC: <balbi@ti.com>, <linux-kernel@vger.kernel.org>,
        Ravi Babu <ravibabu@ti.com>
Subject: [PATCH v1 0/3] babble error workaround for am335x platform
Date: Wed, 29 May 2013 18:37:01 +0530
Message-ID: <1369832824-29071-1-git-send-email-ravibabu@ti.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During the babble condition on usb bus, the musb controller removes the 
session and stops host mode functionality. All the devices connected 
to root port will be disconnected due to this babble event.

	As part of recovery of babble bus condition, restarting the
controller is needed as all devices got disconnected. Just setting the 
session bit would not be sufficient as the configured endpoint fifo
register getting changed during this condition as confirmed by HW/IP
owner of musb controller. 

	This patch set series adds the support to handle the babble
error recovery mechanism, this can be extended to other musb platforms.

This patch has been verified on tree [1] and tested on am335x platforms.

[1] git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git

Ravi Babu (3):
  usb: musb: core: added musb_restart() API to handle babble condition
  usb: musb: core: added babble recovery func-ptr to musb->ops
  usb: musb: dsps: handle babble condition for dsps platform

 drivers/usb/musb/musb_core.c |   30 ++++++++++++++++++++++++++++++
 drivers/usb/musb/musb_core.h |    8 ++++++++
 drivers/usb/musb/musb_dsps.c |   34 +++++++++++++++++++++++++++++++++-
 3 files changed, 71 insertions(+), 1 deletions(-)


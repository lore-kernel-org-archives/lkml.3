Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757272Ab3CHVqO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 16:46:14 -0500
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:60560
	"EHLO p3plsmtps2ded03.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753147Ab3CHVqN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 16:46:13 -0500
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 0/6] Drivers: hv 
Date: Fri,  8 Mar 2013 14:15:45 -0800
Message-Id: <1362780945-9796-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set enhances the balloon driver functionality to add support
for memory "hot-add". Windows hosts use a combination of ballooning and
hot-add to dynamically balance the available memory across competing virtual
machines. With this, Linux guests can fully participate in the Windows
Dynamic Memory protocol.

Additionally, I have also fixed an issue in the Vmbus driver in the way
the offer rescind message is handled.

K. Y. Srinivasan (6):
  Drivers: hv: balloon: Do not request completion notification
  Drivers: hv: balloon: Execute balloon inflation in a separate context
  Drivers: hv: balloon: Execute hot-add code in a separate context
  Drivers: hv: balloon: Make the balloon driver not unloadable
  Drivers: hv: balloon: Implement hot-add functionality
  Drivers: hv: vmbus: Handle channel rescind message correctly

 drivers/hv/channel_mgmt.c |   11 +
 drivers/hv/hv_balloon.c   |  467 +++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 425 insertions(+), 53 deletions(-)

-- 
1.7.4.1


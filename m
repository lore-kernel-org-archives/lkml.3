Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756890AbaDIAu7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 20:50:59 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:34152
	"EHLO p3plsmtps2ded01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756232AbaDIAu6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 20:50:58 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 0/2] Eliminate spin locks in the vmbus channel callback path 
Date: Tue,  8 Apr 2014 18:45:28 -0700
Message-Id: <1397007928-13555-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently we map the channel handle to the channel under the protection of
a spin lock. Additionally, we dispatch the channel callback function under the
protection of the channel inbound lock (another spin lock). In some recent
nework performance runs, the time spent acquiring and releasing these locks
were identified as potential bottlenecks. This patch-set gets rid of these
locks by leveraging the interrupt bindings that we support starting with win8.

K. Y. Srinivasan (2):
  Drivers: hv: Eliminate the channel spinlock in the callback path
  Drivers: hv: vmbus: Implement per-CPU mapping of relid to channel

 drivers/hv/channel.c      |   16 ++++++++++---
 drivers/hv/channel_mgmt.c |   52 ++++++++++++++++++++++++++++++++++++++++----
 drivers/hv/connection.c   |   35 +++++++++++++++++++++++-------
 drivers/hv/hv.c           |    2 +
 drivers/hv/hyperv_vmbus.h |    5 ++++
 include/linux/hyperv.h    |    7 ++++++
 6 files changed, 100 insertions(+), 17 deletions(-)

-- 
1.7.4.1


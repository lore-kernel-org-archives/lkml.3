Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753644AbbATPpT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 10:45:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47927 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753572AbbATPpP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 10:45:15 -0500
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>, devel@linuxdriverproject.org
Cc: Haiyang Zhang <haiyangz@microsoft.com>, linux-kernel@vger.kernel.org,
        Dexuan Cui <decui@microsoft.com>, Jason Wang <jasowang@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH v3 0/3] Drivers: hv: vmbus: protect Offer/Rescind offer processing
Date: Tue, 20 Jan 2015 16:45:03 +0100
Message-Id: <1421768706-5363-1-git-send-email-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series is a renamed successor of "[PATCH] Drivers: hv: vmbus:
serialize Offer and Rescind offer processing".

Changes from v2:
- Rename labels in vmbus_process_offer() ("out" -> "done_init_rescind" in
  PATCH 3/3, "error" -> "err_free_chan" in PATCH 1/3) [Dan Carpenter]
- Invert condition, update comment, and remove "out" label in
  vmbus_onoffer_rescind()

Changes from v1:
- Separate vmbus_device_create() return value check [K. Y. Srinivasan]
- Do not lose a rescind offer received during offer processing. Use renamed
(in [PATCH v2 2/3]) spinlock to protect simulteneous test-and-set workflow for
rescind and work fields. [K. Y. Srinivasan]

Vitaly Kuznetsov (3):
  Drivers: hv: check vmbus_device_create() return value in
    vmbus_process_offer()
  Drivers: hv: rename sc_lock to the more generic lock
  Drivers: hv: vmbus: serialize Offer and Rescind offer

 drivers/hv/channel.c      |  6 +++---
 drivers/hv/channel_mgmt.c | 50 ++++++++++++++++++++++++++++++++---------------
 include/linux/hyperv.h    |  7 ++++++-
 3 files changed, 43 insertions(+), 20 deletions(-)

-- 
1.9.3


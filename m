Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752238AbbASQ4Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 11:56:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33652 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751614AbbASQ4X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 11:56:23 -0500
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>, devel@linuxdriverproject.org
Cc: Haiyang Zhang <haiyangz@microsoft.com>, linux-kernel@vger.kernel.org,
        Dexuan Cui <decui@microsoft.com>, Jason Wang <jasowang@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH v2 0/3] Drivers: hv: vmbus: protect Offer/Rescind offer processing
Date: Mon, 19 Jan 2015 17:56:10 +0100
Message-Id: <1421686573-12771-1-git-send-email-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series is a successor of "[PATCH] Drivers: hv: vmbus: serialize
Offer and Rescind offer processing" and thereby have 'v2' in its name.

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
 drivers/hv/channel_mgmt.c | 45 ++++++++++++++++++++++++++++++++-------------
 include/linux/hyperv.h    |  7 ++++++-
 3 files changed, 41 insertions(+), 17 deletions(-)

-- 
1.9.3


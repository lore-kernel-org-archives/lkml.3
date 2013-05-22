Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757168Ab3EVUkW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 16:40:22 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:33655 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756683Ab3EVUkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 16:40:20 -0400
X-IronPort-AV: E=Sophos;i="4.87,723,1363158000"; 
   d="scan'208";a="49724176"
From: Stephen Boyd <sboyd@codeaurora.org>
To: Grant Likely <grant.likely@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [RFC/PATCH 0/2] Remove most of_device_match() calls
Date: Wed, 22 May 2013 13:40:15 -0700
Message-Id: <1369255217-29764-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.3.rc3.8.g5e49f30.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sending this as an RFC with one driver converted to see what people
think. The goal is to avoid having to run the match twice and be
similar to how platform_device_id works right now. If people agree
I can go through and send out patches for all the drivers doing
the duplicate search (~100 files).

Stephen Boyd (2):
  of: Assign of_device_id to matching device_node
  gpio/omap: Use of_node->id_entry directly

 drivers/gpio/gpio-omap.c  |  4 +---
 drivers/of/device.c       | 18 ++++++++++++++++++
 include/linux/of.h        |  1 +
 include/linux/of_device.h | 12 ++----------
 4 files changed, 22 insertions(+), 13 deletions(-)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation


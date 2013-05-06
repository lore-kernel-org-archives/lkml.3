Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753689Ab3EFHXc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 03:23:32 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:51452 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753258Ab3EFHXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 03:23:30 -0400
From: Jassi Brar <jassisinghbrar@gmail.com>
To: s-anna@ti.com, loic.pallardy@st.com
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Jassi Brar <jaswinder.singh@linaro.org>
Subject: [PATCHv2 0/4] mailbox: Common API
Date: Mon,  6 May 2013 12:52:26 +0530
Message-Id: <1367824946-6160-1-git-send-email-jaswinder.singh@linaro.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
  I have made the implementation look more proper. Also made some changes
suggested by Suman. Changes since V1:

* Delete timer upon mailbox release
* Filled in the stub ipc_links_unregister()
* Check kzalloc return for errors.
* Add the controller driver for OMAP2 class. I have taken the patch
  for mailbox's hwmod from Suman's. The clients are yet to be converted
  but this should be enough to convey the idea that the API could
  work for OMAP as well. If I had access to STE documentation, I might
  have done some implementation for U8500 as well.

 arch/arm/mach-omap2/omap_hwmod_2420_data.c |   12 +
 arch/arm/mach-omap2/omap_hwmod_2430_data.c |   11 +
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c |   11 +
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c |   13 +
 drivers/cpufreq/highbank-cpufreq.c         |   22 +-
 drivers/mailbox/Kconfig                    |    9 +
 drivers/mailbox/Makefile                   |    7 +-
 drivers/mailbox/mailbox.c                  |  494 ++++++++++++++++++++++++++++
 drivers/mailbox/omap2.c                    |  420 +++++++++++++++++++++++
 drivers/mailbox/pl320-ipc.c                |  198 -----------
 drivers/mailbox/pl320.c                    |  212 ++++++++++++
 include/linux/mailbox.h                    |   28 +-
 include/linux/mailbox_client.h             |   85 +++++
 include/linux/mailbox_controller.h         |  102 ++++++
 include/linux/platform_data/mailbox-omap.h |   64 ++++
 15 files changed, 1473 insertions(+), 215 deletions(-)

Cheers,
-Jassi

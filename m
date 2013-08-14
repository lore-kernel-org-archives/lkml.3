Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758829Ab3HNHOp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 03:14:45 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:52294 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754723Ab3HNHOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 03:14:44 -0400
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Bryan Wu <cooloney@gmail.com>,
        Peter Meerwald <p.meerwald@bct-electronic.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH v4 0/5] PCA9633: Add support to PCA9634 and fix some problems
Date: Wed, 14 Aug 2013 09:14:21 +0200
Message-Id: <1376464470-6845-1-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Add Support for the PCA9634 chip. Simimart to the 9633, but with 8 outputs instead of 4.
Fix bug when 2 chips where present on the system, the ledclass will fail and the chip wont probe.
Protect ledout register with a mutex to support updates of more than leds at the same time
Fix device tree parsing

v4: Rebase to latest leds-next and new patch to Fix the dt parsing

v3: Contains feedback from Bryan Wu
Bryan: Rename pca9633 to pca963x

v2: Contains feedback from Peter Meerwald
Peter: Fix typo on commit message. Add bus number to name

Ricardo Ribalda Delgado (4):
  leds-pca9633: Unique naming of the LEDs
  leds-pca9633: Add mutex to the ledout register
  leds-pca9633: Rename to leds-pca963x
  leds-pca963x: Fix device tree parsing

 drivers/leds/Kconfig                       |    2 +-
 drivers/leds/Makefile                      |    2 +-
 drivers/leds/leds-pca9633.c                |  435 --------------------------
 drivers/leds/leds-pca963x.c                |  460 ++++++++++++++++++++++++++++
 include/linux/platform_data/leds-pca9633.h |   41 ---
 include/linux/platform_data/leds-pca963x.h |   42 +++
 6 files changed, 504 insertions(+), 478 deletions(-)
 delete mode 100644 drivers/leds/leds-pca9633.c
 create mode 100644 drivers/leds/leds-pca963x.c
 delete mode 100644 include/linux/platform_data/leds-pca9633.h
 create mode 100644 include/linux/platform_data/leds-pca963x.h

-- 
1.7.10.4


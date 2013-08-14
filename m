Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933305Ab3HNVX7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 17:23:59 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:44086 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933191Ab3HNVX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 17:23:57 -0400
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Bryan Wu <cooloney@gmail.com>,
        Peter Meerwald <p.meerwald@bct-electronic.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH v4 0/5] PCA9633: Add support to PCA9634 and fix some problems
Date: Wed, 14 Aug 2013 23:23:46 +0200
Message-Id: <1376515431-9504-1-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add Support for the PCA9634 chip. Simimart to the 9633, but with 8 outputs instead of 4.
Fix bug when 2 chips where present on the system, the ledclass will fail and the chip wont probe.
Protect ledout register with a mutex to support updates of more than leds at the same time
Fix device tree parsing

v5: Contains feedback from Bryan Wu
Bryan: Fix device tree bindings documentation

v4: Rebase to latest leds-next and new patch to Fix the dt parsing

v3: Contains feedback from Bryan Wu
Bryan: Rename pca9633 to pca963x

v2: Contains feedback from Peter Meerwald
Peter: Fix typo on commit message. Add bus number to name

Ricardo Ribalda Delgado (5):
  leds-pca9633: Add support for PCA9634
  leds-pca9633: Unique naming of the LEDs
  leds-pca9633: Add mutex to the ledout register
  leds-pca9633: Rename to leds-pca963x
  leds-pca963x: Fix device tree parsing

 Documentation/devicetree/bindings/leds/pca9633.txt |   46 --
 Documentation/devicetree/bindings/leds/pca963x.txt |   47 ++
 drivers/leds/Kconfig                               |    9 +-
 drivers/leds/Makefile                              |    2 +-
 drivers/leds/leds-pca9633.c                        |  393 -----------------
 drivers/leds/leds-pca963x.c                        |  461 ++++++++++++++++++++
 include/linux/platform_data/leds-pca9633.h         |   41 --
 include/linux/platform_data/leds-pca963x.h         |   42 ++
 8 files changed, 556 insertions(+), 485 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/leds/pca9633.txt
 create mode 100644 Documentation/devicetree/bindings/leds/pca963x.txt
 delete mode 100644 drivers/leds/leds-pca9633.c
 create mode 100644 drivers/leds/leds-pca963x.c
 delete mode 100644 include/linux/platform_data/leds-pca9633.h
 create mode 100644 include/linux/platform_data/leds-pca963x.h

-- 
1.7.10.4


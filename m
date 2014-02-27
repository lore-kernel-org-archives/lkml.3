Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745AbaB0FyF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 00:54:05 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:18605 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742AbaB0FyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 00:54:03 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 26 Feb 2014 21:51:21 -0800
From: Alexandre Courbot <acourbot@nvidia.com>
To: Thierry Reding <thierry.reding@gmail.com>,
        Jingoo Han <jg1.han@samsung.com>, Bryan Wu <cooloney@gmail.com>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>
CC: <linux-pwm@vger.kernel.org>, <linux-gpio@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH 0/2] pwm-backlight: switch to gpiod interface (part 1)
Date: Thu, 27 Feb 2014 14:53:32 +0900
Message-ID: <1393480414-19473-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.9.0
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These two patches initiate the switch of the pwm-backlight driver to
the gpiod GPIO interface, as it considerably simplifies the code.

For compatibility with current users of the driver, it is still possible
to pass the enable GPIO number as platform data. Two platforms are still
relying on this feature (pxa/palmtc and shmobile/armadillo800eva) which
will be removed as soon as its last users are switched to GPIO mapping
tables.

Alexandre Courbot (2):
  ARM: SAMSUNG: remove gpio flags in dev-backlight
  pwm-backlight: switch to gpiod interface

 arch/arm/plat-samsung/dev-backlight.c |  2 -
 drivers/video/backlight/pwm_bl.c      | 72 +++++++++++++++--------------------
 include/linux/pwm_backlight.h         |  5 +--
 3 files changed, 32 insertions(+), 47 deletions(-)

-- 
1.9.0


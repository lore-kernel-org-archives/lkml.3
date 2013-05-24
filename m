Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757375Ab3EXSbX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 14:31:23 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:53640 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757350Ab3EXSbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 14:31:21 -0400
X-IronPort-AV: E=Sophos;i="4.87,736,1363158000"; 
   d="scan'208";a="50557350"
From: Rohit Vaswani <rvaswani@codeaurora.org>
To: David Brown <davidb@codeaurora.org>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: Rohit Vaswani <rvaswani@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCHv2 0/3] Cleanup MSM_GPIOMUX and add DT support for gpio-msm
Date: Fri, 24 May 2013 11:30:56 -0700
Message-Id: <1369420259-26271-1-git-send-email-rvaswani@codeaurora.org>
X-Mailer: git-send-email 1.7.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,
Could this series go through David's tree or is there a better way to do this?
It would be great if I can have you ack for the gpio patch.

Thanks,
Rohit

Rohit Vaswani (3):
  ARM: msm: Remove gpiomux-v2 and re-organize MSM_GPIOMUX configs
  ARM: msm: Remove unused and unmapped MSM_TLMM_BASE for 8x60
  gpio: msm: Add device tree and irqdomain support for gpio-msm-v2

 .../devicetree/bindings/gpio/gpio-msm.txt          |   26 +++
 arch/arm/boot/dts/msm8660-surf.dts                 |   11 ++
 arch/arm/boot/dts/msm8960-cdp.dts                  |   11 ++
 arch/arm/mach-msm/Kconfig                          |   13 +-
 arch/arm/mach-msm/Makefile                         |    6 +-
 arch/arm/mach-msm/gpiomux-8x60.c                   |   19 ---
 arch/arm/mach-msm/gpiomux-v2.c                     |   25 ---
 arch/arm/mach-msm/gpiomux-v2.h                     |   61 -------
 arch/arm/mach-msm/gpiomux.c                        |   15 ++
 arch/arm/mach-msm/gpiomux.h                        |    5 -
 arch/arm/mach-msm/include/mach/msm_iomap-8x60.h    |    4 -
 drivers/gpio/Kconfig                               |    2 +-
 drivers/gpio/gpio-msm-v2.c                         |  170 ++++++++++++--------
 13 files changed, 176 insertions(+), 192 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio-msm.txt
 delete mode 100644 arch/arm/mach-msm/gpiomux-8x60.c
 delete mode 100644 arch/arm/mach-msm/gpiomux-v2.c
 delete mode 100644 arch/arm/mach-msm/gpiomux-v2.h

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation


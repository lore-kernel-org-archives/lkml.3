Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123Ab3EFBaJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 May 2013 21:30:09 -0400
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:43694 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751778Ab3EFBaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 May 2013 21:30:07 -0400
From: Chao Xie <chao.xie@marvell.com>
To: <thierry.reding@avionic-design.de>, <linux-kernel@vger.kernel.org>,
        <xiechao.mail@gmail.com>, <eric.y.miao@gmail.com>
CC: Chao Xie <chao.xie@marvell.com>
Subject: [PATCH V4 0/3] pwm: pxa: bug fix and device tree support
Date: Sun, 5 May 2013 21:29:58 -0400
Message-ID: <1367803801-17111-1-git-send-email-chao.xie@marvell.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patches fix some bugs
1. pwm-pxa driver is shared by ARCH_PXA and ARCH_MMP
2. use module_platform_driver for driver register

The patches also add device tree support for pwm.

V2->V1:
  Remove the redundant initialization.
  Fix bug of no initialization of .of_match_table.
  Use CONFIG_OF for device tree support. 
  Rebase to for-next

V3->V2:
  Change "mrvl,xxx" to "marvell,xxx".

V4->V3
  Change comments for "pwm: pxa: use module_platform_driver()"
  and "pwm: pxa: ARCH_MMP share same pwm driver with ARCH_PXA".
  Use "static const" for pxa_pwm_of_match definition.
  Use the below scheme for DT support.
  	if (!id_entry) {
		if (IS_ENABLED(CONFIG_OF))
			err = parse_dt();
		else
			err = -ENODEV;
	  } else {
  		err = parse_pdata();
	  }

	  if (err < 0)
		  return err;

Chao Xie (3):
  pwm: pxa: ARCH_MMP share same pwm driver with ARCH_PXA
  pwm: pxa: use module_platform_driver()
  pwm: pxa: add device tree support

 drivers/pwm/Kconfig   |    2 +-
 drivers/pwm/pwm-pxa.c |   64 +++++++++++++++++++++++++++++++++++++++---------
 2 files changed, 53 insertions(+), 13 deletions(-)

-- 
1.7.4.1


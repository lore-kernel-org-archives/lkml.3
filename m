Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751751AbaI3PKS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 11:10:18 -0400
Received: from mx.vmgattei.com ([77.223.18.35]:48167 "EHLO mx.vmgattei.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751068AbaI3PKP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 11:10:15 -0400
From: Matteo Facchinetti <matteo.facchinetti@sirius-es.it>
To: chris@printf.net, ulf.hansson@linaro.org
Cc: shc_work@mail.ru, s.hauer@pengutronix.de, peter.griffin@linaro.org,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linucppc-dev@lists.ozlabs.org, agust@denx.de, gsi@denx.de,
        sbabic@denx.de, Matteo Facchinetti <matteo.facchinetti@sirius-es.it>
Subject: [PATCH 0/2] mxcmmc driver fixes
Date: Tue, 30 Sep 2014 16:59:36 +0200
Message-Id: <1412089178-21946-1-git-send-email-matteo.facchinetti@sirius-es.it>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matteo Facchinetti <matteo.facchinetti@sirius-es.it>

Hi,

this patchset contains fixes for the mxcmmc driver.

*Patch 1:
fix a rare race condition that breaks a data trasfer when mxcmmc
driver use dma.
To reproduce this error, use mmc as rootfs and start at boot time
a realtime Xenomai application.
The realtime it's not directly related but entropy produced by
ipipe scheduler highlights the problem.
When this event occurs, the mxcmmc watchdog expires,
this cause a read error and application doesn't run.

*Patch 2:
fix the default value for available voltages into mxcmci_probe

Applied to mainline Linux-3.17.0-rc6-next on arch mpc512x.
Tested on mpc5125twr evaluation board

Applied to custom Linux-3.9.4 on arch mpc512x
Tested on a mpc5125 custom board.

Regards,
Matteo Facchinetti
Sirius Electronic Systems


Matteo Facchinetti (2):
  mmc: mxcmmc: fix race condition when dma finish a data transfer
  mmc: mxcmmc: fix the default value for available voltages into
    mxcmci_probe

 drivers/mmc/host/mxcmmc.c | 27 ++++++++++-----------------
 1 file changed, 10 insertions(+), 17 deletions(-)

-- 
1.8.3.2


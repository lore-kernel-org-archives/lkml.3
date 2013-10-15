Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933962Ab3JOWof (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 18:44:35 -0400
Received: from mail-yh0-f74.google.com ([209.85.213.74]:50850 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933522Ab3JOWoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 18:44:34 -0400
From: Doug Anderson <dianders@chromium.org>
To: Chris Ball <cjb@laptop.org>
Cc: Jaehoon Chung <jh80.chung@samsung.com>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        James Hogan <james.hogan@imgtec.com>,
        Grant Grundler <grundler@chromium.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, Olof Johansson <olof@lixom.net>,
        Sonny Rao <sonnyrao@chromium.org>, Bing Zhao <bzhao@marvell.com>,
        Doug Anderson <dianders@chromium.org>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] Prevent races when doing read-modify-write of INTMASK
Date: Tue, 15 Oct 2013 15:39:20 -0700
Message-Id: <1381876762-10892-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bing Zhao at Marvell discovered a race in the way that dw_mmc was
doing a read-modify-write of the INTMASK register.  This 2-patch
series attempts to fix the problem using a simple spinlock.  In order
to do so cleanly, we include a patch to tidy up the way that we
disable low power mode when using SDIO interrupts.

This patch series was not tested on ToT Linux other than basic
compiling and booting, since we don't have the whole Marvell SDIO
stack up and running in mainline yet.  This series is based on
mmc-next (e76b855 mmc: sdhci-esdhc-imx: set actual_clock in clock
setting) merged atop mainlinx Linux.


Doug Anderson (2):
  mmc: dw_mmc: Cleanup disable of low power mode w/ SDIO interrupts
  mmc: dw_mmc: Protect read-modify-write of INTMASK with a lock

 drivers/mmc/host/dw_mmc.c  | 79 +++++++++++++++++++++++++++-------------------
 drivers/mmc/host/dw_mmc.h  |  1 +
 include/linux/mmc/dw_mmc.h |  6 ++++
 3 files changed, 54 insertions(+), 32 deletions(-)

-- 
1.8.4


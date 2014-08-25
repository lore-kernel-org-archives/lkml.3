Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932289AbaHYM01 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 08:26:27 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:62015 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755458AbaHYM0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 08:26:24 -0400
From: Ulf Hansson <ulf.hansson@linaro.org>
To: linux-mmc@vger.kernel.org, Ian Molton <ian.molton@codethink.co.uk>,
        Chris Ball <chris@printf.net>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Linux-sh list <linux-sh@vger.kernel.org>, linux-kernel@vger.kernel.org,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 00/12] mmc: tmio: Fixup PM support
Date: Mon, 25 Aug 2014 14:25:52 +0200
Message-Id: <1408969564-6335-1-git-send-email-ulf.hansson@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset fixup the PM support for tmio and the tmio hosts.
Some re-structuring of the code was also necessary to accomplish the above.

A few of these patches has been posted earlier, but at that time I couldn't get
help in testing them on hardware. Let's give this a second try now.

http://www.spinics.net/lists/linux-mmc/msg23177.html

Ulf Hansson (12):
  mmc: tmio: Keep host active while SDIO IRQ is enabled
  mmc: tmio: Keep host active while serving requests
  mmc: tmio: Extract bus_width modifications to a separate function
  mmc: tmio: Restructure ->set_ios() and adapt ->probe() to it
  mmc: tmio: Handle clock gating from runtime PM functions
  mmc: tmio: Mask all IRQs when inactive
  mmc: tmio: Make runtime PM callbacks available for CONFIG_PM
  mmc: sdhi: Make runtime PM callbacks available for CONFIG_PM
  mmc: tmio_mmc: Enable runtime PM support
  mmc: sdhi: Fixup system PM suspend lock-up
  mmc: tmio_mmc: Fixup system PM suspend lock-up
  mmc: tmio: Remove library functions for system PM

 drivers/mmc/host/sh_mobile_sdhi.c |   5 +-
 drivers/mmc/host/tmio_mmc.c       |   7 +-
 drivers/mmc/host/tmio_mmc.h       |  31 +-----
 drivers/mmc/host/tmio_mmc_pio.c   | 193 ++++++++++++++++++--------------------
 4 files changed, 104 insertions(+), 132 deletions(-)

-- 
1.9.1


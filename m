Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935567Ab3DHMTj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 08:19:39 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:35242 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935057Ab3DHMTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 08:19:37 -0400
From: Prabhakar lad <prabhakar.csengg@gmail.com>
To: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Sekhar Nori <nsekhar@ti.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v3 0/3] davinci: vpss: clock cleanup
Date: Mon,  8 Apr 2013 17:49:10 +0530
Message-Id: <1365423553-12619-1-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lad, Prabhakar <prabhakar.csengg@gmail.com>

This patch series cleanup's the VPSS clock enabling.
The first patch removes vpss clock enabling from the capture
drivers and moves it to the VPSS driver itself.
The second patch moves the venc_enable_vpss_clock() to the driver
which was being done in platform code.

Changes for v3:
1: Changed the commit message for first patch as pointed by Sekhar.
2: Removed a semicolon after NULL in con_ids as pointed by Sekhar.
3: Included the Ack from Sekhar for first patch.

Changes for v2:
1: Used PM runtime API for clock handling and nit's pointed by Sekhar.

Lad, Prabhakar (3):
  media: davinci: vpss: enable vpss clocks
  media: davinci: vpbe: venc: move the enabling of vpss clocks to
    driver
  davinic: vpss: trivial cleanup

 arch/arm/mach-davinci/dm355.c                |    7 +---
 arch/arm/mach-davinci/dm365.c                |   11 +++++--
 arch/arm/mach-davinci/dm644x.c               |    9 +----
 arch/arm/mach-davinci/pm_domain.c            |    2 +-
 drivers/media/platform/davinci/dm355_ccdc.c  |   39 +----------------------
 drivers/media/platform/davinci/dm644x_ccdc.c |   44 --------------------------
 drivers/media/platform/davinci/isif.c        |   28 ++--------------
 drivers/media/platform/davinci/vpbe_venc.c   |   25 ++++++++++++++
 drivers/media/platform/davinci/vpss.c        |   36 ++++++++++++++++-----
 9 files changed, 71 insertions(+), 130 deletions(-)

-- 
1.7.4.1


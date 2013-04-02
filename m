Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761343Ab3DBLpA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 07:45:00 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:48188 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759896Ab3DBLoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 07:44:14 -0400
From: Prabhakar lad <prabhakar.csengg@gmail.com>
To: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Sekhar Nori <nsekhar@ti.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v2 0/3] davinci: vpss: clock cleanup
Date: Tue,  2 Apr 2013 17:14:01 +0530
Message-Id: <1364903044-13752-1-git-send-email-prabhakar.csengg@gmail.com>
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


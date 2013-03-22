Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622Ab3CVHx0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 03:53:26 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:34957 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751679Ab3CVHxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 03:53:24 -0400
From: Prabhakar lad <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Sekhar Nori <nsekhar@ti.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH 0/2] davinci: vpss: clock cleanup
Date: Fri, 22 Mar 2013 13:23:11 +0530
Message-Id: <1363938793-22246-1-git-send-email-prabhakar.csengg@gmail.com>
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

Lad, Prabhakar (2):
  media: davinci: vpss: enable vpss clocks
  media: davinci: vpbe: venc: move the enabling of vpss clocks to
    driver

 arch/arm/mach-davinci/dm355.c                |    3 -
 arch/arm/mach-davinci/dm365.c                |    9 +++-
 arch/arm/mach-davinci/dm644x.c               |    5 --
 drivers/media/platform/davinci/dm355_ccdc.c  |   39 +----------------
 drivers/media/platform/davinci/dm644x_ccdc.c |   44 -------------------
 drivers/media/platform/davinci/isif.c        |   28 ++----------
 drivers/media/platform/davinci/vpbe_venc.c   |   26 +++++++++++
 drivers/media/platform/davinci/vpss.c        |   60 ++++++++++++++++++++++++++
 8 files changed, 98 insertions(+), 116 deletions(-)

-- 
1.7.4.1


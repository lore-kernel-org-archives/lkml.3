Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755019AbaGHQWo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 12:22:44 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:32901 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754828AbaGHQWl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 12:22:41 -0400
From: Suman Anna <s-anna@ti.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: Dave Gerlach <d-gerlach@ti.com>,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, Suman Anna <s-anna@ti.com>
Subject: [PATCH 0/2] couple of generic remoteproc enhancements
Date: Tue, 8 Jul 2014 11:21:59 -0500
Message-ID: <1404836521-59637-1-git-send-email-s-anna@ti.com>
X-Mailer: git-send-email 2.0.0
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ohad,

The following are couple of generic enhancements to the remoteproc core.
The changes are developed to support adding new rproc drivers for processors
like the WkupM3 processor on AM335/AM437, but are generic enough to apply to
non-OMAP devices as well.

The first patch allows MMU-enabled processors like OMAP IPU/DSP as well as
other non-MMU enabled processors on multi-arch kernel images.

The second-patch was developed as part of enabling internal memory loading
of firmware segments on OMAP DSPs, but will also be used by the WkupM3 
remoteproc driver that Dave Gerlach is gonna submit soon.

The two patches are based on 3.16-rc4 and are technically independent of each
other, but submitting them together as the WkupM3 remoteproc driver would need
both of them.

regards
Suman

Suman Anna (2):
  remoteproc: use a flag to detect the presence of IOMMU
  remoteproc: add support to handle internal memories

 drivers/remoteproc/omap_remoteproc.c |   6 +++
 drivers/remoteproc/remoteproc_core.c | 100 ++++++++++++++++++++++++++++++-----
 include/linux/remoteproc.h           |  45 +++++++++++++++-
 3 files changed, 136 insertions(+), 15 deletions(-)

-- 
2.0.0


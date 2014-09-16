Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755221AbaIPUTG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 16:19:06 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:34257 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688AbaIPUTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 16:19:03 -0400
From: Suman Anna <s-anna@ti.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: Dave Gerlach <d-gerlach@ti.com>, Robert Tivy <rtivy@ti.com>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, Suman Anna <s-anna@ti.com>
Subject: [PATCHv2 0/2] couple of generic remoteproc enhancements
Date: Tue, 16 Sep 2014 15:18:36 -0500
Message-ID: <1410898718-10828-1-git-send-email-s-anna@ti.com>
X-Mailer: git-send-email 2.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ohad,

The following is an updated patchset addressing the review comments on v1.
The patches are mainly developed to support the WkupM3 remote processor
driver on TI AM335x/AM437x SoCs. The patches are rebased onto 3.17-rc3
(rc independent actually).

I haven't made any major updates to Patch2 with respect to the ioremap
vs defining a CMA region, as the latter is irrelevant for mapping these
internal RAMs.

Following are the main changes in v2:
- Add explicit setting of the .has_iommu field in each of the existing
  remoteproc platform drivers (Patch 1)
- Update patch description to add the usecase details for the change
  summary (Patch1)
- Fixed a minor checkpatch warning (Patch 2).

regards
Suman

v1:
http://marc.info/?l=linux-omap&m=140483657604924&w=2

Suman Anna (2):
  remoteproc: use a flag to detect the presence of IOMMU
  remoteproc: add support to handle internal memories

 drivers/remoteproc/da8xx_remoteproc.c |  1 +
 drivers/remoteproc/omap_remoteproc.c  |  5 ++
 drivers/remoteproc/remoteproc_core.c  | 98 ++++++++++++++++++++++++++++++-----
 drivers/remoteproc/ste_modem_rproc.c  |  1 +
 include/linux/remoteproc.h            | 45 +++++++++++++++-
 5 files changed, 135 insertions(+), 15 deletions(-)

-- 
2.0.4


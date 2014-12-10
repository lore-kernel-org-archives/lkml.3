Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755185AbaLJCNN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 21:13:13 -0500
Received: from mga01.intel.com ([192.55.52.88]:39276 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754167AbaLJCNL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 21:13:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,549,1413270000"; 
   d="scan'208";a="645191670"
Date: Wed, 10 Dec 2014 10:12:49 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Alan Tull <atull@opensource.altera.com>
Cc: kbuild-all@01.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH socfpga-nex] staging: fpga manager:
 fpga_mgr_low_level_state() can be static
Message-ID: <20141210021249.GA71780@lkp-sb04>
References: <201412101021.JoZosGm6%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201412101021.JoZosGm6%fengguang.wu@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: fengguang.wu@intel.com
X-SA-Exim-Scanned: No (on bee); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/staging/fpga/fpga-mgr.c:46:5: sparse: symbol 'fpga_mgr_low_level_state' was not declared. Should it be static?
drivers/staging/fpga/fpga-mgr.c:324:30: sparse: symbol 'fpga_mgr_groups' was not declared. Should it be static?
drivers/staging/fpga/fpga-mgr.c:365:25: sparse: symbol 'fpga_mgr_dev_pm_ops' was not declared. Should it be static?

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 fpga-mgr.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/fpga/fpga-mgr.c b/drivers/staging/fpga/fpga-mgr.c
index d08cb82..3216276 100644
--- a/drivers/staging/fpga/fpga-mgr.c
+++ b/drivers/staging/fpga/fpga-mgr.c
@@ -43,7 +43,7 @@ static LIST_HEAD(fpga_manager_list);
  *
  * This will be used to initialize framework state
  */
-int fpga_mgr_low_level_state(struct fpga_manager *mgr)
+static int fpga_mgr_low_level_state(struct fpga_manager *mgr)
 {
 	if (!mgr || !mgr->mops || !mgr->mops->state)
 		return FPGA_MGR_STATE_UNKNOWN;
@@ -321,7 +321,7 @@ static const struct attribute_group fpga_mgr_group = {
 	.attrs = fpga_mgr_attrs,
 };
 
-const struct attribute_group *fpga_mgr_groups[] = {
+static const struct attribute_group *fpga_mgr_groups[] = {
 	&fpga_mgr_group,
 	NULL,
 };
@@ -362,7 +362,7 @@ static int fpga_mgr_resume(struct device *dev)
 	return 0;
 }
 
-const struct dev_pm_ops fpga_mgr_dev_pm_ops = {
+static const struct dev_pm_ops fpga_mgr_dev_pm_ops = {
 	.suspend	= fpga_mgr_suspend,
 	.resume		= fpga_mgr_resume,
 };

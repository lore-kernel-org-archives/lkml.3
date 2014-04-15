Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541AbaDORNU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 13:13:20 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:44871 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751241AbaDORLR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 13:11:17 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: Linux PPC <linuxppc-dev@lists.ozlabs.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        LKML <linux-kernel@vger.kernel.org>, Anton Blanchard <anton@samba.org>,
        David.Laight@aculab.com, Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: [PATCH v2 0/6] powerpc/perf/hv_{gpci,24x7}: fixes
Date: Tue, 15 Apr 2014 10:10:49 -0700
Message-Id: <1397581855-4585-1-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.9.2
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14041517-0320-0000-0000-000003019327
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 - 24x7 and gpci probing now uses pr_debug() and doesn't pad to 80 characters
 - Catalog access is fixed for LE kernels
 - remove c99 feature sparse doesn't like
 - 1 device attr made static


Cody P Schafer (6):
  powerpc/perf/hv_24x7: probe errors changed to pr_debug(), padding
    fixed
  powerpc/perf/hv_gpci: probe failures use pr_debug(), and padding
    reduced
  powerpc/perf/hv-gpci: make device attr static
  powerpc/perf/hv-24x7: use (unsigned long) not (u32) values when
    calling plpar_hcall_norets()
  powerpc/perf/hv-24x7: remove [static 4096], sparse chokes on it
  powerpc/perf/hv-24x7: catalog version number is be64, not be32

 arch/powerpc/perf/hv-24x7.c | 30 +++++++++++++++++++++---------
 arch/powerpc/perf/hv-gpci.c |  6 +++---
 2 files changed, 24 insertions(+), 12 deletions(-)

-- 
1.9.2


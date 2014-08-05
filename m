Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755044AbaHEOmX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 10:42:23 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:45452 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753527AbaHEOmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 10:42:21 -0400
Message-ID: <53E0ED41.8030804@linux.vnet.ibm.com>
Date: Tue, 05 Aug 2014 20:12:09 +0530
From: Vishal Mansur <vmansur@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: gwshan@linux.vnet.ibm.com, benh@kernel.crashing.org,
        linuxppc-dev@lists.ozlabs.org
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] powerpc: non-GPL export for eeh_dev_check_failure
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14080514-9574-0000-0000-00000073BF88
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

EEH kernel services are inconsistently exported by the 
kernel. eeh_check_failure is exported for any use, but 
eeh_dev_check_failure is exported only for GPL use. 
While eeh_check_failure is implemented for a specific 
purpose to be used by services such as readl, it is 
not suited for a purpose where caller needs eeh status. 
This functionality is provided by eeh_dev_check_failure.

This patch relaxes the export for eeh_dev_check_failure
to make it consistent with eeh_check_failure() and 
usable by non-GPL modules.

Signed-off-by: Vishal Mansur <vmansur@linux.vnet.ibm.com>
---
 arch/powerpc/kernel/eeh.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/powerpc/kernel/eeh.c b/arch/powerpc/kernel/eeh.c
index 86e2570..8689c30 100644
--- a/arch/powerpc/kernel/eeh.c
+++ b/arch/powerpc/kernel/eeh.c
@@ -496,8 +496,7 @@ dn_unlock:
        eeh_serialize_unlock(flags);
        return rc;
 }
-
-EXPORT_SYMBOL_GPL(eeh_dev_check_failure);
+EXPORT_SYMBOL(eeh_dev_check_failure);

 /**
  * eeh_check_failure - Check if all 1's data is due to EEH slot freeze
--
2.0.1


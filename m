Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754319Ab3G2KUc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 06:20:32 -0400
Received: from smtp.citrix.com ([66.165.176.89]:58844 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753320Ab3G2KUb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 06:20:31 -0400
X-IronPort-AV: E=Sophos;i="4.89,768,1367971200"; 
   d="scan'208";a="39882042"
Date: Mon, 29 Jul 2013 11:20:21 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: <xen-devel@lists.xensource.com>, <linux-kernel@vger.kernel.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        <linux-arm-kernel@lists.infradead.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [GIT PULL] Xen ARM fix for 3.11
Message-ID: <alpine.DEB.2.02.1307291056000.4893@kaball.uk.xensource.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,
I have one fix for Xen on ARM for 3.11 (also appended for your
convenience):


The following changes since commit 3b2f64d00c46e1e4e9bd0bb9bb12619adac27a4b:

  Linux 3.11-rc2 (2013-07-21 12:05:29 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/sstabellini/xen.git xen-arm-3.11-rc2-warn-tag

Stefano Stabellini (1):
      xen/arm,arm64: update xen_restart after ff701306cd49 and 7b6d864b48d9

 arch/arm/xen/enlighten.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


Thanks,

Stefano




commit 2451ade070ef9b0a0f118ac41896da856e72b5a1
Author: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Date:   Sun Jul 21 15:17:54 2013 +0000

    xen/arm,arm64: update xen_restart after ff701306cd49 and 7b6d864b48d9
    
    Commit 7b6d864b48d9 (reboot: arm: change reboot_mode to use enum
    reboot_mode) and ff701306cd49 (arm64: use common reboot infrastructure)
    change the prototype of arm_pm_restart on arm and arm64.
    Update xen_restart accordingly.
    
    Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
index f71c37e..c9770ba 100644
--- a/arch/arm/xen/enlighten.c
+++ b/arch/arm/xen/enlighten.c
@@ -172,7 +172,7 @@ static void __init xen_percpu_init(void *unused)
 	enable_percpu_irq(xen_events_irq, 0);
 }
 
-static void xen_restart(char str, const char *cmd)
+static void xen_restart(enum reboot_mode reboot_mode, const char *cmd)
 {
 	struct sched_shutdown r = { .reason = SHUTDOWN_reboot };
 	int rc;

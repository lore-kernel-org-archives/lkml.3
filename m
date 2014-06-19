Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933426AbaFSPHc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 11:07:32 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:16167 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933127AbaFSPHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 11:07:30 -0400
Date: Thu, 19 Jun 2014 11:07:28 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Mike Galbraith <umgwanakikbuti@gmail.com>
Subject: [ANNOUNCE] 3.12.22-rt34
Message-ID: <20140619110728.795da4ee@gandalf.local.home>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dear RT Folks,

I'm pleased to announce the 3.12.22-rt34 stable release.

Usually for non stable merged releases I post an -rc iteration. But as
this is a small simple fix, I'm posting this next version directly.

-- Steve


You can get this release via the git tree at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git

  branch: v3.12-rt
  Head SHA1: e07e87d7680b060c0c19f1595952fd74a565b17d


Or to build 3.12.22-rt34 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.x/linux-3.12.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.x/patch-3.12.22.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.12/patch-3.12.22-rt34.patch.xz



You can also build from 3.12.22-rt33 by applying the incremental patch:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.12/incr/patch-3.12.22-rt33-rt34.patch.xz



Enjoy,

-- Steve


Changes from v3.12.22-rt33:

---

Steven Rostedt (Red Hat) (2):
      Revert "drivers/net: tulip_remove_one needs to call pci_disable_device()"
      Linux 3.12.22-rt34

----
 drivers/net/ethernet/dec/tulip/tulip_core.c | 1 -
 localversion-rt                             | 2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)
---------------------------
diff --git a/drivers/net/ethernet/dec/tulip/tulip_core.c b/drivers/net/ethernet/dec/tulip/tulip_core.c
index a6d4653ebbc3..779016068a82 100644
--- a/drivers/net/ethernet/dec/tulip/tulip_core.c
+++ b/drivers/net/ethernet/dec/tulip/tulip_core.c
@@ -1939,7 +1939,6 @@ static void tulip_remove_one(struct pci_dev *pdev)
 	pci_iounmap(pdev, tp->base_addr);
 	free_netdev (dev);
 	pci_release_regions (pdev);
-	pci_disable_device(pdev);
 	pci_set_drvdata (pdev, NULL);
 	pci_disable_device(pdev);
 
diff --git a/localversion-rt b/localversion-rt
index e1d836252017..21988f9ad53f 100644
--- a/localversion-rt
+++ b/localversion-rt
@@ -1 +1 @@
--rt33
+-rt34

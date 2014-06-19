Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757119AbaFSDqs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 23:46:48 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:61826 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752553AbaFSDqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 23:46:46 -0400
Message-ID: <1403149603.5189.10.camel@marge.simpson.net>
Subject: Re: [ANNOUNCE] 3.12.22-rt33
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Date: Thu, 19 Jun 2014 05:46:43 +0200
In-Reply-To: <20140618201233.4dd3a59d@gandalf.local.home>
References: <20140618201233.4dd3a59d@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-06-18 at 20:12 -0400, Steven Rostedt wrote: 
> Dear RT Folks,
> 
> I'm pleased to announce the 3.12.22-rt33 stable release.


git@marge:~/linux-2.6> git diff v3.12... drivers/net/ethernet/dec/tulip/tulip_core.c
diff --git a/drivers/net/ethernet/dec/tulip/tulip_core.c b/drivers/net/ethernet/dec/tulip/tulip_core.c
index 4e8cfa2ac803..a6d4653ebbc3 100644
--- a/drivers/net/ethernet/dec/tulip/tulip_core.c
+++ b/drivers/net/ethernet/dec/tulip/tulip_core.c
@@ -1939,7 +1939,9 @@ static void tulip_remove_one(struct pci_dev *pdev)
 	pci_iounmap(pdev, tp->base_addr);
 	free_netdev (dev);
 	pci_release_regions (pdev);
+	pci_disable_device(pdev);
 	pci_set_drvdata (pdev, NULL);
+	pci_disable_device(pdev);
 
 	/* pci_power_off (pdev, -1); */
 }

commit 4a77edc195f0b03644e84dda00fcfe9827868e8e
Author: Ingo Molnar <mingo@elte.hu>
Date:   Fri Jul 3 08:30:18 2009 -0500

    drivers/net: tulip_remove_one needs to call pci_disable_device()
    
    Otherwise the device is not completely shut down.
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

diff --git a/drivers/net/ethernet/dec/tulip/tulip_core.c b/drivers/net/ethernet/dec/tulip/tulip_core.c
index 4e8cfa2ac803..7565b994ec50 100644
--- a/drivers/net/ethernet/dec/tulip/tulip_core.c
+++ b/drivers/net/ethernet/dec/tulip/tulip_core.c
@@ -1939,6 +1939,7 @@ static void tulip_remove_one(struct pci_dev *pdev)
 	pci_iounmap(pdev, tp->base_addr);
 	free_netdev (dev);
 	pci_release_regions (pdev);
+	pci_disable_device(pdev);
 	pci_set_drvdata (pdev, NULL);
 
 	/* pci_power_off (pdev, -1); */


commit 831bb5573dcbeb0da783c82e21084ac191dafc24
Author: Ingo Molnar <mingo@elte.hu>
Date:   Fri Feb 14 15:32:20 2014 +0100

    drivers/net: tulip_remove_one needs to call pci_disable_device()
    
    commit c321f7d7c87cdc623c87845f6378620573e57512 upstream.
    
    Otherwise the device is not completely shut down.
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
    Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    Signed-off-by: David S. Miller <davem@davemloft.net>
    Signed-off-by: Jiri Slaby <jslaby@suse.cz>

diff --git a/drivers/net/ethernet/dec/tulip/tulip_core.c b/drivers/net/ethernet/dec/tulip/tulip_core.c
index 4e8cfa2ac803..779016068a82 100644
--- a/drivers/net/ethernet/dec/tulip/tulip_core.c
+++ b/drivers/net/ethernet/dec/tulip/tulip_core.c
@@ -1940,6 +1940,7 @@ static void tulip_remove_one(struct pci_dev *pdev)
 	free_netdev (dev);
 	pci_release_regions (pdev);
 	pci_set_drvdata (pdev, NULL);
+	pci_disable_device(pdev);
 
 	/* pci_power_off (pdev, -1); */
 }



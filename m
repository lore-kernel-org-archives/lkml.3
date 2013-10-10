Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757231Ab3JJU2K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 16:28:10 -0400
Received: from ns1.pc-advies.be ([83.149.101.17]:37019 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756586Ab3JJU2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 16:28:08 -0400
Date: Thu, 10 Oct 2013 22:28:05 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Thomas Mingarelli <Thomas.Mingarelli@hp.com>
Subject: [GIT PULL REQUEST] watchdog - v3.12-rc4 Fixes
Message-ID: <20131010202805.GM401@spo001.leaseweb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from 'master' branch of
	git://www.linux-watchdog.org/linux-watchdog.git

It will make sure that the hpwdt driver will not load auxilary iLO devices.

This will update the following files:

 hpwdt.c |    6 ++++++
 1 files changed, 6 insertions(+)

with these Changes:

commit 0821f20d49d19f49e53b05ef6727e010c4b1f11d
Author: Mingarelli, Thomas <Thomas.Mingarelli@hp.com>
Date:   Fri Aug 9 16:31:09 2013 +0000

    watchdog: hpwdt: Patch to ignore auxilary iLO devices
    
    This patch is to prevent hpwdt from loading on any auxilary iLO devices defined
    after the initial (or main) iLO device. All auxilary iLO devices will have a
    subsystem device ID set to 0x1979 in order for hpwdt to differentiate between
    the two types.
    
    Signed-off-by: Thomas Mingarelli <thomas.mingarelli@hp.com>
    Tested-by: Lisa Mitchell <lisa.mitchell@hp.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

For completeness, I added the overal diff below.

Greetings,
Wim.

================================================================================
commit 0821f20d49d19f49e53b05ef6727e010c4b1f11d
Author: Mingarelli, Thomas <Thomas.Mingarelli@hp.com>
Date:   Fri Aug 9 16:31:09 2013 +0000

    watchdog: hpwdt: Patch to ignore auxilary iLO devices
    
    This patch is to prevent hpwdt from loading on any auxilary iLO devices defined
    after the initial (or main) iLO device. All auxilary iLO devices will have a
    subsystem device ID set to 0x1979 in order for hpwdt to differentiate between
    the two types.
    
    Signed-off-by: Thomas Mingarelli <thomas.mingarelli@hp.com>
    Tested-by: Lisa Mitchell <lisa.mitchell@hp.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

diff --git a/drivers/watchdog/hpwdt.c b/drivers/watchdog/hpwdt.c
index 5be5e3d..19f3c3f 100644
--- a/drivers/watchdog/hpwdt.c
+++ b/drivers/watchdog/hpwdt.c
@@ -802,6 +802,12 @@ static int hpwdt_init_one(struct pci_dev *dev,
 		return -ENODEV;
 	}
 
+	/*
+	 * Ignore all auxilary iLO devices with the following PCI ID
+	 */
+	if (dev->subsystem_device == 0x1979)
+		return -ENODEV;
+
 	if (pci_enable_device(dev)) {
 		dev_warn(&dev->dev,
 			"Not possible to enable PCI Device: 0x%x:0x%x.\n",

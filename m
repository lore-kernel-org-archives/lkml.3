Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752505AbaKVTrX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2014 14:47:23 -0500
Received: from mail-la0-f42.google.com ([209.85.215.42]:33411 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751933AbaKVTrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2014 14:47:21 -0500
From: Alexander Kochetkov <al.kochet@gmail.com>
To: linux-omap@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>, Tony Lindgren <tony@atomide.com>,
        Felipe Balbi <balbi@ti.com>, al.kochet@gmail.com
Subject: [PATCH v3 0/4] i2c: omap: patch series related to multimaster mode
Date: Sat, 22 Nov 2014 23:47:10 +0400
Message-Id: <1416685634-5864-1-git-send-email-al.kochet@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1416518925-20679-1-git-send-email-al.kochet@gmail.com>
References: <1416518925-20679-1-git-send-email-al.kochet@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is the patch series intended to improve stability of
i2c-omap driver in the i2c multimaster environments.

Tested on Beagleboard XM C.
For now all fine. No controller timeouts, no data corruptions.

Also impelemented i2c bus fault detection during startup and
after reset.

So, instead of the message "controller timeout" blaming IP,
you get "timeout waiting for bus ready".

Rebased against i2c/for-next (eb61694b43dea0d43ea2574e7d48f476a6bdffb0)

Tested on the kernel from angstrom-v2013.06-yocto1.4
Kernel recepie linux-mainline_3.2.bb
git://github.com/Angstrom-distribution/meta-ti.git; branch angstrom-staging-yocto1.4
With all i2-omap.c patches backported from upstream linux/master

Signed-off-by: Alexander Kochetkov <al.kochet@gmail.com>

Alexander Kochetkov (4):
  i2c: omap: cleanup register definitions
  i2c: omap: implement workaround for handling invalid BB-bit values
  i2c: omap: don't reset controller if Arbitration Lost detected
  i2c: omap: add notes related to i2c multimaster mode

 drivers/i2c/busses/i2c-omap.c |  131 +++++++++++++++++++++++++++++++++++++++--
 1 file changed, 125 insertions(+), 6 deletions(-)

-- 
1.7.9.5


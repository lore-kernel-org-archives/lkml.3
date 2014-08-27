Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965538AbaH0X2R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 19:28:17 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:38076 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965243AbaH0X2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 19:28:15 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18lzeK4iyuMwKEOLGWu8s/x
From: Tony Lindgren <tony@atomide.com>
To: kishon@ti.com
Cc: balbi@ti.com, linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: [PATCH 0/5] Clean-up for twl4030-usb
Date: Wed, 27 Aug 2014 16:28:06 -0700
Message-Id: <1409182091-31191-1-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.8.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here are few more patches for v3.18 to clean up twl4030-usb.

These are based on the two regression fixes I sent earlier:

[PATCH] usb: phy: twl4030-usb: Fix regressions to runtime PM on omaps
[PATCH] usb: phy: twl4030-usb: Fix lost interrupts after ID pin goes down

For testing with v3.17-rc2, you probably also want to revert
commit a9232076374334ca2bc2a448dfde96d38a54349a until that
hits the mainline tree. And you may also want to apply the
following patch if testing with PM:

[PATCH] mfd: twl4030-power: Fix PM idle pin configuration to not conflict with regulators

I've also pushed these patches with the optional patches
into a temporary testing branch at [1].

Regards,

Tony

[1] git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap.git omap-for-v3.17/testing-pending-usb

Tony Lindgren (5):
  usb: phy: twl4030-usb: Remove unused irq_enabled
  usb: phy: twl4030-usb: Simplify phy init to use runtime PM
  usb: phy: twl4030-usb: Move code from twl4030_phy_power to the runtime
    PM calls
  usb: phy: twl4030-usb: Remove asleep and rely on runtime PM
  usb: phy: twl4030-usb: Use mutex instead of spinlock for protecting
    the data

 drivers/phy/phy-twl4030-usb.c     | 124 ++++++++++++++------------------------
 drivers/usb/phy/phy-twl6030-usb.c |   2 -
 2 files changed, 46 insertions(+), 80 deletions(-)

-- 
1.8.1.1


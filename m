Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751998Ab3LMFNr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 00:13:47 -0500
Received: from mga02.intel.com ([134.134.136.20]:44826 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750756Ab3LMFNp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 00:13:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,476,1384329600"; 
   d="scan'208";a="423990238"
From: David Cohen <david.a.cohen@linux.intel.com>
To: pavel@ucw.cz, rjw@rjwysocki.net, len.brown@intel.com,
        sarah.a.sharp@linux.intel.com, gregkh@linuxfoundation.org
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, santosh.shilimkar@ti.com,
        David Cohen <david.a.cohen@linux.intel.com>
Subject: [RFC/PATCH 0/3] pm: Make SET_*_PM_OPS() macros more smart
Date: Thu, 12 Dec 2013 21:18:22 -0800
Message-Id: <1386911905-2366-1-git-send-email-david.a.cohen@linux.intel.com>
X-Mailer: git-send-email 1.8.4.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

These patches are proposal to extend the lack of #ifdef checks on PM callback
to its implementation too.

Currently SET_*_PM_OPS() macros make #ifdefs checks not necessary when setting
the callback to PM ops, but the callbacks implementation don't see same
benefit.

This RFC Solves a problem reported by Santosh on xhci-plat.c driver due to
wrong #ifdef checks:

drivers/usb/host/xhci-plat.c:201:12: warning: ‘xhci_plat_suspend’ defined but not used [-Wunused-function]
drivers/usb/host/xhci-plat.c:209:12: warning: ‘xhci_plat_resume’ defined but not used [-Wunused-function]

But instead of fixing the #ifdefs, we remove the need for it :)

Br, David Cohen

---
David Cohen (2):
  pm: make PM macros more smart
  usb/xhci: implement proper static inline stubs when !CONFIG_PM

Santosh Shilimkar (1):
  usb/xhci-plat: remove unnecessary #ifdef checks for CONFIG_PM_SLEEP

 drivers/usb/host/xhci-plat.c |  7 +------
 drivers/usb/host/xhci.h      |  6 ++++--
 include/linux/pm.h           | 11 +++++++++--
 3 files changed, 14 insertions(+), 10 deletions(-)

-- 
1.8.4.2


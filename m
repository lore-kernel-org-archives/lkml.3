Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751566AbaBQFwT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 00:52:19 -0500
Received: from mga09.intel.com ([134.134.136.24]:5162 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751074AbaBQFwS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 00:52:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,858,1384329600"; 
   d="scan'208";a="476347642"
From: Chuansheng Liu <chuansheng.liu@intel.com>
To: rjw@rjwysocki.net, gregkh@linuxfoundation.org, len.brown@intel.com,
        pavel@ucw.cz
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        chuansheng.liu@intel.com, zhuangzhi.li@intel.com
Subject: [PATCH v2 0/5] Enabling the asynchronous threads for other phases
Date: Mon, 17 Feb 2014 13:42:21 +0800
Message-Id: <1392615746-4574-1-git-send-email-chuansheng.liu@intel.com>
X-Mailer: git-send-email 1.9.rc0
In-Reply-To: <y>
References: <y>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patch series are for enabling the asynchronous threads for the phases
resume_noirq, resume_early, suspend_noirq and suspend_late.

Just like commit 5af84b82701a and 97df8c12995, with async threads it will
reduce the system suspending and resuming time significantly.

With these patches, in my test platform, it saved 80% time in resume_noirq
phase.

Best Regards,

---
V2:
 -- Based on Rafael's minor changes related to coding style, white space etc;
 -- Rafael pointed out the v1 series break the device parent-children
    suspending/resuming order when enabling asyncing, here using the
    dev completion to sync parent-children order;

---
[PATCH 1/5] PM / sleep: Two flags for async suspend_noirq and
[PATCH 2/5] PM / sleep: Asynchronous threads for resume_noirq
[PATCH 3/5] PM / sleep: Asynchronous threads for resume_early
[PATCH 4/5] PM / sleep: Asynchronous threads for suspend_noirq
[PATCH 5/5] PM / sleep: Asynchronous threads for suspend_late

 drivers/base/power/main.c | 273 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++----------------------------
 include/linux/pm.h        |   2 ++
 2 files changed, 225 insertions(+), 50 deletions(-)



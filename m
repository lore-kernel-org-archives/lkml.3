Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696AbaBQGae (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 01:30:34 -0500
Received: from mga02.intel.com ([134.134.136.20]:39340 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751403AbaBQGac (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 01:30:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,859,1384329600"; 
   d="scan'208";a="476359021"
From: Chuansheng Liu <chuansheng.liu@intel.com>
To: rjw@rjwysocki.net, gregkh@linuxfoundation.org, len.brown@intel.com,
        pavel@ucw.cz
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        chuansheng.liu@intel.com, zhuangzhi.li@intel.com
Subject: [PATCH v3 0/5] Enabling the asynchronous threads for other phases
Date: Mon, 17 Feb 2014 14:19:09 +0800
Message-Id: <1392617954-5292-1-git-send-email-chuansheng.liu@intel.com>
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

V3:
 -- In patch v2 5/5, there is one missing "dpm_wait_for_children";

---

[PATCH v3 1/5] PM / sleep: Two flags for async suspend_noirq and
[PATCH v3 2/5] PM / sleep: Asynchronous threads for resume_noirq
[PATCH v3 3/5] PM / sleep: Asynchronous threads for resume_early
[PATCH v3 4/5] PM / sleep: Asynchronous threads for suspend_noirq
[PATCH v3 5/5] PM / sleep: Asynchronous threads for suspend_late

 drivers/base/power/main.c | 275 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++----------------------------
 include/linux/pm.h        |   2 ++
 2 files changed, 227 insertions(+), 50 deletions(-)



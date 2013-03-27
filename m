Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752036Ab3C0OAC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 10:00:02 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:64379 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968Ab3C0OAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 10:00:00 -0400
X-Greylist: delayed 392 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Mar 2013 10:00:00 EDT
From: Rajagopal Venkat <rajagopal.venkat@linaro.org>
To: myungjoo.ham@samsung.com, rjw@sisk.pl, Kevin Hilman <khilman@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>
Cc: patches@linaro.org, linaro-kernel@lists.linaro.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rajagopal Venkat <rajagopal.venkat@linaro.org>
Subject: [PATCH v2 0/2] Add devfreq runtime pm support
Date: Wed, 27 Mar 2013 19:22:52 +0530
Message-Id: <1364392374-12236-1-git-send-email-rajagopal.venkat@linaro.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch to bind devfreq to runtime pm framework. Instead of explicitly
using devfreq_suspend_device() and devfreq_resume_device() apis for
devfreq core suspend/resume, let runtime-pm core handle it automatically.

Suspend device devfreq core load monitoring with pm_runtime_suspend() and
resume back on pm_runtime_resume().

Discussed at http://comments.gmane.org/gmane.linux.linaro.devel/13787

Changes from v1:
- improved change log and code comments
- added NULL check for devfreq runtime-pm callbacks
-----

Rajagopal Venkat (2):
  PM / devfreq: Fix compiler warnings
  PM / devfreq: tie suspend/resume to runtime-pm

 drivers/base/power/runtime.c |   21 ++++++++++++-
 drivers/devfreq/devfreq.c    |   69 +++++++++++++++++++++++++++++++++++++++---
 include/linux/devfreq.h      |   30 ++++++------------
 include/linux/pm.h           |    2 ++
 4 files changed, 97 insertions(+), 25 deletions(-)

-- 
1.7.10.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381Ab3LJNiC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 08:38:02 -0500
Received: from mail-la0-f54.google.com ([209.85.215.54]:43452 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905Ab3LJNh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 08:37:59 -0500
From: Ulf Hansson <ulf.hansson@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, linux-pm@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH V2 0/3] PM: Enable option of re-use runtime PM callbacks at system suspend
Date: Tue, 10 Dec 2013 14:37:39 +0100
Message-Id: <1386682662-17633-1-git-send-email-ulf.hansson@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To put devices into low power state during system suspend, it is convenient
for some runtime PM supported power domains, subsystems and drivers to have
the option of re-using and invoking the runtime PM callbacks from their system
PM callbacks.

The benefit is that we don't need to implement wrapper functions which
handles runtime PM resourses, typically called from both runtime PM and system
PM callbacks.

Some new helper macros for defining the PM callbacks are added.

SET_PM_RUNTIME_PM_OPS; to define runtime PM callbacks for CONFIG_PM instead of
CONFIG_PM_RUNTIME.

SET_LATE_SYSTEM_SLEEP_PM_OPS; to define common late/early system PM callbacks,
same approach is applicable to the existing SET_SYSTEM_SLEEP_PM_OPS which
defines common suspend/resume system PM callbacks.

A minor fix was needed for the platform bus, which runtime PM callbacks are set
to the pm_generic_runtime_suspend|resume functions. These were implemented only
for CONFIG_PM_RUNTIME and thus the platform bus prevented driver's runtime PM
callbacks to be invoked when only CONFIG_PM_SLEEP was used. We move them into
CONFIG_PM to resolve the problem.

Changes in v2:
	Updated commit messages to try to better reflect the changes. 
	Removed the below patches from this patch set. Let's leave those to be
	addressed separately, if needed.
	- PM / Sleep: Add pm_generic functions to re-use runtime PM callbacks
	- drm/exynos: Convert to suspend_late/resume_early callbacks for fimc


Ulf Hansson (3):
  PM / Runtime: Add second macro for definition of runtime PM callbacks
  PM / Runtime: Implement the pm_generic_runtime functions for
    CONFIG_PM
  PM / Sleep: Add macro to define common late/early system PM callbacks

 drivers/base/power/generic_ops.c |    4 ++--
 include/linux/pm.h               |   21 +++++++++++++++++++++
 include/linux/pm_runtime.h       |   12 ++++++++----
 3 files changed, 31 insertions(+), 6 deletions(-)

-- 
1.7.9.5


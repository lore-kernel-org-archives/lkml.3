Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386AbaJQQ7z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 12:59:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47836 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752830AbaJQQ7y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 12:59:54 -0400
From: Ulrich Obergfell <uobergfe@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: dzickus@redhat.com, uobergfe@redhat.com
Subject: [PATCH v2 0/9] watchdog: parameters to control hard and soft lockup detector individually
Date: Fri, 17 Oct 2014 19:06:19 +0200
Message-Id: <1413565588-4144-1-git-send-email-uobergfe@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This post follows up to https://lkml.org/lkml/2014/8/11/329.
During the discussion of that patch, Ingo Molnar commented in
https://lkml.org/lkml/2014/8/18/577.

 "The softlockup and hardlockup detection control variables 
  should be in separate flags, inside and outside the kernel - 
  they (should) not relate to each other."

Please refer to [PATCH v2 7/9] for a description of the proposed
changes of the 'user interface' in /proc/sys/kernel and kernel
command line parameters.

There are no functional changes between the initial version in
https://lkml.org/lkml/2014/10/13/313 and v2. The new version is
merely a re-base to the following upstream commits.

commit 6e7458a6f074c71e74cda31c483114e65ea0f570
Author: Ulrich Obergfell <uobergfe@redhat.com>
Date:   Mon Oct 13 15:55:35 2014 -0700

    kernel/watchdog.c: control hard lockup detection default

commit 9919e39a17381058dd0cdef2f78dbf5619e26474
Author: Ulrich Obergfell <uobergfe@redhat.com>
Date:   Mon Oct 13 15:55:37 2014 -0700

    kvm: ensure hard lockup detection is disabled by default

Ulrich Obergfell (9):
  watchdog: new definitions and variables, initialization
  watchdog: introduce the proc_watchdog_update() function
  watchdog: move definition of 'watchdog_proc_mutex' outside of
    proc_dowatchdog()
  watchdog: introduce the proc_watchdog_common() function
  watchdog: introduce separate handlers for parameters in
    /proc/sys/kernel
  watchdog: implement error handling for failure to set up hardware
    perf events
  watchdog: enable the new user interface of the watchdog mechanism
  watchdog: clean up some function names and arguments
  watchdog: introduce the hardlockup_detector_disable() function

 arch/x86/kernel/kvm.c |   2 +-
 include/linux/nmi.h   |  21 ++--
 kernel/sysctl.c       |  35 +++++--
 kernel/watchdog.c     | 277 ++++++++++++++++++++++++++++++++++++--------------
 4 files changed, 240 insertions(+), 95 deletions(-)

-- 
1.7.11.7


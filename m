Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645Ab3EOVpf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 17:45:35 -0400
Received: from mail-qc0-f201.google.com ([209.85.216.201]:57924 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414Ab3EOVpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 17:45:34 -0400
From: Todd Poynor <toddpoynor@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, John Stultz <john.stultz@linaro.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Todd Poynor <toddpoynor@google.com>
Subject: [PATCH 0/2] timerfd support for wakeup alarm timers
Date: Wed, 15 May 2013 14:38:10 -0700
Message-Id: <1368653892-18939-1-git-send-email-toddpoynor@google.com>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable wakeup alarm timers via file descriptors.  Hook up alarmtimer
to timerfd via clocks CLOCK_REALTIME_ALARM and CLOCK_BOOTTIME_ALARM,
and add needed functions to alarmtimer.

 fs/timerfd.c               |  131 +++++++++++++++++++++++++++++++++++++--------
 include/linux/alarmtimer.h |    4 +
 kernel/time/alarmtimer.c   |   39 +++++++++++++
 3 files changed, 150 insertions(+), 24 deletions(-)

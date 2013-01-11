Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755581Ab3AKVtR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 16:49:17 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:56839 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754610Ab3AKVtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 16:49:16 -0500
From: John Stultz <john.stultz@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: John Stultz <john.stultz@linaro.org>, Greg KH <gregkh@linuxfoundation.org>,
        Serban Constantinescu <serban.constantinescu@arm.com>,
        =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Android Kernel Team <kernel-team@android.com>
Subject: [RFC][PATCH 0/2] staging: alarm-dev: compat_ioctl support
Date: Fri, 11 Jan 2013 13:48:36 -0800
Message-Id: <1357940918-14941-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a first-pass at implementing compat_ioctl support for
Android's alarm-dev driver in staging.

The first patch is some refactoring to cleanup and separate the
copying of user data from the logic, and the second patch adds
the compat_ioctl support.

As noted in the patch, the only really squirly bit is the handling
of ANDROID_ALARM_SET_OLD and ANDROID_ALARM_SET_AND_WAIT_OLD. These
are present to support existing older Android applications.
Unfortunately these cause ioctl number aliasing issues with
the compat ioctls, so on 64bit they are only supported in the
compat patch (since any existing android app old enough to use
them are likely 32bit).

I'd appreciate feedback from the Android devs on if this is
an ok assumption and if it might be reasonable to establish
some sort of a phase-out timeline for the _OLD ioctl support.

Any other feedback or thoughts would be welcome!

thanks
-john

Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Serban Constantinescu <serban.constantinescu@arm.com>
Cc: Arve Hjønnevåg <arve@android.com>
Cc: Android Kernel Team <kernel-team@android.com>

John Stultz (2):
  staging: alarm-dev: Refactor alarm-dev ioctl code in prep for
    compat_ioctl
  staging: alarm-dev: Implement compat_ioctl support

 drivers/staging/android/alarm-dev.c     |  290 +++++++++++++++++++++----------
 drivers/staging/android/android_alarm.h |   19 ++
 2 files changed, 213 insertions(+), 96 deletions(-)

-- 
1.7.10.4


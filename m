Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755594Ab3AKXqf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 18:46:35 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:35765 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755088Ab3AKXqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 18:46:34 -0500
From: John Stultz <john.stultz@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: John Stultz <john.stultz@linaro.org>, Greg KH <gregkh@linuxfoundation.org>,
        Serban Constantinescu <serban.constantinescu@arm.com>,
        =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Colin Cross <ccross@google.com>,
        Android Kernel Team <kernel-team@android.com>
Subject: [RFC][PATCH 0/3] staging: alarm-dev: Cleanups and compat_ioctl support (v2)
Date: Fri, 11 Jan 2013 15:46:21 -0800
Message-Id: <1357947984-15611-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is the second revision at implementing compat_ioctl support for
Android's alarm-dev driver in staging.

The first patch removes the pre-Android 1.0 _OLD ioctls, per Colin's
suggestion. Then the second patch does some refactoring to cleanup
and separate the copying of user data from the logic, and the final
patch adds the compat_ioctl support.

I've tested this with a trivial unit test compiled for both 32bit
and 64bit on a x86_64 kernel, and it looks ok, but closer review
would be appreciated to make sure I didn't break anything.

Additional feedback or thoughts would be welcome!

thanks
-john

Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Serban Constantinescu <serban.constantinescu@arm.com>
Cc: Arve Hjønnevåg <arve@android.com>
Cc: Colin Cross <ccross@google.com>
Cc: Android Kernel Team <kernel-team@android.com>

John Stultz (3):
  staging: alarm-dev: Drop pre Android 1.0 _OLD ioctls
  staging: alarm-dev: Refactor alarm-dev ioctl code in prep for
    compat_ioctl
  staging: alarm-dev: Implement compat_ioctl support

 drivers/staging/android/alarm-dev.c     |  277 +++++++++++++++++++------------
 drivers/staging/android/android_alarm.h |   19 +++
 2 files changed, 193 insertions(+), 103 deletions(-)

-- 
1.7.10.4


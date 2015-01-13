Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752879AbbAMPqj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 10:46:39 -0500
Received: from m15-111.126.com ([220.181.15.111]:37352 "EHLO m15-111.126.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752228AbbAMPqh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 10:46:37 -0500
From: Xunlei Pang <xlpang@126.com>
To: linux-kernel@vger.kernel.org, John Stultz <john.stultz@linaro.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>
Cc: rtc-linux@googlegroups.com, Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Xunlei Pang <pang.xunlei@linaro.org>
Subject: [RFC PATCH v2 0/9] Provide y2038/y2106 safe rtc_class_ops.set_mmss64()
Date: Tue, 13 Jan 2015 23:44:48 +0800
Message-Id: <1421163897-8020-1-git-send-email-xlpang@126.com>
X-Mailer: git-send-email 2.0.4
X-CM-TRANSID: C8mowEAZEUVxPbVUBIRpDg--.692S3
X-Coremail-Antispam: 1Uf129KBjvJXoW7Aw4kZFWUJr4kXr48uF4xCrg_yoW8Wr1UpF
	43GFy3Xrn3trW3urs3CrnFkFWrZws3Ja4UKwnrt3yrZryYvFy7Ar1kGr18JFWDWFykGrn3
	A3W5Cr15Gw1UuFDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07bjlk3UUUUU=
X-Originating-IP: [182.149.91.53]
X-CM-SenderInfo: p0ost0bj6rjloofrz/1tbimhWAv1GfUwd15AAAs7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xunlei Pang <pang.xunlei@linaro.org>

This patch series relies on a former patchset[1], it provides y2038/y2106
safe rtc_class_ops.set_mmss64(), and converts some possible users of set_mmss()
to use set_mmss64(), in the hope that making these users(i.e. rtc drivers)
y2038/y2106 safe.


The first version of this patchset is: [2].

[1] https://lkml.org/lkml/2014/11/18/218
[2] https://lkml.org/lkml/2014/11/27/341

Xunlei Pang (9):
  rtc: Provide y2038 safe rtc_class_ops.set_mmss() replacement
  time: Provide y2106 safe get_seconds() replacement
  rtc/test: Update driver to address y2038/y2106 issues
  rtc/ab3100: Update driver to address y2038/y2106 issues
  rtc/mc13xxx: Update driver to address y2038/y2106 issues
  rtc/mxc: Modify rtc_update_alarm() not to touch the alarm time
  rtc/mxc: Convert get_alarm_or_time()/set_alarm_or_time() to use
    time64_t
  rtc/mxc: Update driver to address y2038/y2106 issues
  alpha: change to use rtc_class_ops's set_mmss64()

 arch/alpha/kernel/rtc.c     |  8 +++----
 drivers/rtc/interface.c     |  9 +++++++-
 drivers/rtc/rtc-ab3100.c    | 55 ++++++++++++++++++++++-----------------------
 drivers/rtc/rtc-mc13xxx.c   | 32 ++++++++++++--------------
 drivers/rtc/rtc-mxc.c       | 55 +++++++++++++++++----------------------------
 drivers/rtc/rtc-test.c      |  8 +++----
 drivers/rtc/systohc.c       |  5 ++++-
 include/linux/rtc.h         |  1 +
 include/linux/timekeeping.h | 10 ++++++++-
 kernel/time/timekeeping.c   |  4 ++--
 10 files changed, 93 insertions(+), 94 deletions(-)

-- 
1.9.1



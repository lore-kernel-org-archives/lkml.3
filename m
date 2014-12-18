Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752009AbaLRLwu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 06:52:50 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:62073 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776AbaLRLws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 06:52:48 -0500
From: Chunyan Zhang <zhang.chunyan@linaro.org>
To: m.chehab@samsung.com, david@hardeman.nu, uli-lirc@uli-eckhardt.de,
        hans.verkuil@cisco.com, julia.lawall@lip6.fr, himangi774@gmail.com,
        khoroshilov@ispras.ru, joe@perches.com, dborkman@redhat.com,
        john.stultz@linaro.org, tglx@linutronix.de, davem@davemloft.net,
        dwmw2@infradead.org, computersforpeace@gmail.com, arnd@linaro.org
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, zhang.lyra@gmail.com
Subject: [PATCH 0/3] Changes the time type 'timeval' to 'Ktime'
Date: Thu, 18 Dec 2014 19:51:59 +0800
Message-Id: <1418903522-19137-1-git-send-email-zhang.chunyan@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <ktime-mtd-rc-v1>
References: <ktime-mtd-rc-v1>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch-set changes the 32-bit time type (timeval) to the 64-bit one
(ktime_t) in imon.c, speedtest.c and torturetest.c, since 32-bit time
types will break in the year 2038.

This patch-set also introduces a reusable time difference function which
returns the difference in millisecond in ktime.h. The last two patches
of this patch-set will use this function, so they are dependent on the
first one. 

Chunyan Zhang (3):
  ktime.h: Introduce ktime_ms_delta
  mtd: test: Replace timeval with ktime_t in speedtest.c and torturetest.c
  media: rc: Replace timeval with ktime_t in imon.c

 drivers/media/rc/imon.c         |   49 +++++++++++----------------------------
 drivers/mtd/tests/speedtest.c   |   10 ++++----
 drivers/mtd/tests/torturetest.c |   10 ++++----
 include/linux/ktime.h           |    5 ++++
 4 files changed, 28 insertions(+), 46 deletions(-)

-- 
1.7.9.5


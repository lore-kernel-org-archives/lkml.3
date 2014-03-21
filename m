Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755576AbaCUGdM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 02:33:12 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:38810 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754363AbaCUGdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 02:33:08 -0400
From: =?UTF-8?q?Matias=20Bj=C3=B8rling?= <m@bjorling.me>
To: snitzer@redhat.com, agk@redhat.com, dm-devel@redhat.com, neilb@suse.de,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Matias=20Bj=C3=B8rling?= <m@bjorling.me>
Subject: [PATCH RFC v1 00/01] dm-lightnvm introduction
Date: Thu, 20 Mar 2014 23:32:17 -0700
Message-Id: <1395383538-18019-1-git-send-email-m@bjorling.me>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Users that have custom firmware SSDs, may choose to expose their flash directly.
This allows the host to control logical to physical address mappings, garbage
collection strategy, wear-leveling, and so on.

This is beneficial when you either want to strip the cost of a costly controller
or want detailed control over an SSD. Such as implementing key-value stores,
object-stored, atomic I/Os, etc.

LightNVM implements the host-side core. It supports two modes. Users that
doesn't have hardware available and want to emulate an SSD, and users with a
physical SSD, that has a LightNVM compatible firmware.

The behavior of the core can be exposed through the various components that make
up an FTL. Thus, it is not single implementation, but instead possible to
mix the best algorithms for the user-space application workloads.

Currently, LightNVM implements a page-based FTL, cost-based GC and simple
wear-leveling. Additionally, it allows simulation of flash timings when hardware
isn't available. There's work on getting it to the OpenSSD platform with a
custom firmware and getting it stable for broad use.

There is still much work to do. I'm looking for feedback on the approach, dm
integration, and more. Any feedback is greatly appreciated.

A presentation was given at the recent Non-Volatile Memory Workshop (NVMW)
workshop. Slides are available at: http://bjorling.me/NVMW2014-LightNVM.pdf

Major todo's:
 * Patch has TODO and FIXME in places that needs to be cleaned.
 * LightNVM compatible firmware for the OpenSSD platform and integration.
 * Performance regressions during GC.
 * Durability during power failure.

Thanks,

Matias

Matias Bjørling (1):
  dm-lightnvm: An open FTL for open firmware SSDs

 drivers/md/Kconfig             |   1 +
 drivers/md/Makefile            |   1 +
 drivers/md/lightnvm/Kconfig    |  14 +
 drivers/md/lightnvm/Makefile   |   1 +
 drivers/md/lightnvm/core.c     | 705 +++++++++++++++++++++++++++++++++++++++++
 drivers/md/lightnvm/gc.c       | 208 ++++++++++++
 drivers/md/lightnvm/lightnvm.c | 589 ++++++++++++++++++++++++++++++++++
 drivers/md/lightnvm/lightnvm.h | 592 ++++++++++++++++++++++++++++++++++
 drivers/md/lightnvm/reg.c      |  41 +++
 9 files changed, 2152 insertions(+)
 create mode 100644 drivers/md/lightnvm/Kconfig
 create mode 100644 drivers/md/lightnvm/Makefile
 create mode 100644 drivers/md/lightnvm/core.c
 create mode 100644 drivers/md/lightnvm/gc.c
 create mode 100644 drivers/md/lightnvm/lightnvm.c
 create mode 100644 drivers/md/lightnvm/lightnvm.h
 create mode 100644 drivers/md/lightnvm/reg.c

-- 
1.8.3.2


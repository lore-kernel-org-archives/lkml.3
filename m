Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713AbaHEOfs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 10:35:48 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:51914 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753078AbaHEOfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 10:35:46 -0400
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
To: linux-pm@vger.kernel.org
Cc: Thierry Reding <thierry.reding@gmail.com>,
        =?UTF-8?q?Terje=20Bergstr=C3=B6m?= <tbergstrom@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>
Subject: [RFC 0/2] Add PM_QOS_MEMORY_BANDWIDTH class
Date: Tue,  5 Aug 2014 16:35:22 +0200
Message-Id: <1407249324-8568-1-git-send-email-tomeu.vizoso@collabora.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I need a way for device drivers to register their needs of memory bandwidth so
the optimal frequency for the memory bus clock can be set.

Adding one more pm_qos class and a PM_QOS_SUM class type seems to accomplish
that neatly, so I'm asking for comments on these very simple patches.

The patch to drm/tegra isn't really functional because the EMC clock
implementation [0] hasn't been merged yet, and I'm not posting an
implementation of a notification listener because in my platform that would be
the EMC driver which is still under discussion as well.

This will be most useful once we have per-user clock constraints [1], so the
EMC driver can set one more floor frequency that together with the other
constraints would lead to the effective rate of the memory bus.

Thanks,

Tomeu

[0] http://article.gmane.org/gmane.linux.kernel/1744817
[1] http://article.gmane.org/gmane.linux.kernel/1760039

Tomeu Vizoso (2):
  PM / QoS: Add PM_QOS_MEMORY_BANDWIDTH class
  drm/tegra: Request memory bandwidth for the display controller

 drivers/gpu/drm/tegra/dc.c  | 11 +++++++++++
 drivers/gpu/drm/tegra/drm.h |  2 ++
 include/linux/pm_qos.h      |  5 ++++-
 kernel/power/qos.c          | 27 ++++++++++++++++++++++++++-
 4 files changed, 43 insertions(+), 2 deletions(-)

-- 
1.9.3


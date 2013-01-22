Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753079Ab3AVLqu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 06:46:50 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:61946 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752264Ab3AVLqt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 06:46:49 -0500
X-IronPort-AV: E=Sophos;i="4.84,514,1355068800"; 
   d="scan'208";a="6628483"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: akpm@linux-foundation.org, rjw@sisk.pl, len.brown@intel.com,
        mingo@redhat.com, tglx@linutronix.de, minchan.kim@gmail.com,
        rientjes@google.com, benh@kernel.crashing.org, paulus@samba.org,
        cl@linux.com, kosaki.motohiro@jp.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, wujianguo@huawei.com,
        wency@cn.fujitsu.com, hpa@zytor.com, linfeng@cn.fujitsu.com,
        laijs@cn.fujitsu.com, mgorman@suse.de, yinghai@kernel.org,
        glommer@parallels.com, jiang.liu@huawei.com, julian.calaby@gmail.com,
        sfr@canb.auug.org.au
Cc: x86@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-acpi@vger.kernel.org
Subject: [PATCH Bug fix 0/5] Bug fix for node offline
Date: Tue, 22 Jan 2013 19:45:51 +0800
Message-Id: <1358855156-6126-1-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.10.1
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/22 19:45:51,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/22 19:45:52,
	Serialize complete at 2013/01/22 19:45:52
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on physical memory hot-remove functionality, we can implement
node hot-remove. But there are some problems in cpu driver when offlining
a node. This patch-set will fix them.

All these patches are based on the latest -mm tree.
git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git akpm

Tang Chen (1):
  Do not use cpu_to_node() to find an offlined cpu's node.

Wen Congyang (4):
  cpu_hotplug: clear apicid to node when the cpu is hotremoved
  memory-hotplug: export the function try_offline_node()
  cpu-hotplug, memory-hotplug: try offline the node when hotremoving a
    cpu
  cpu-hotplug,memory-hotplug: clear cpu_to_node() when offlining the
    node

 arch/x86/kernel/acpi/boot.c     |    4 ++++
 drivers/acpi/processor_driver.c |    2 ++
 include/linux/memory_hotplug.h  |    2 ++
 kernel/sched/core.c             |   28 +++++++++++++++++++---------
 mm/memory_hotplug.c             |   33 +++++++++++++++++++++++++++++++--
 5 files changed, 58 insertions(+), 11 deletions(-)


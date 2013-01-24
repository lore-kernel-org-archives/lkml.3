Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131Ab3AXJj2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 04:39:28 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:47489 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752793Ab3AXJjF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 04:39:05 -0500
X-IronPort-AV: E=Sophos;i="4.84,529,1355068800"; 
   d="scan'208";a="6640642"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: akpm@linux-foundation.org, rjw@sisk.pl, len.brown@intel.com,
        mingo@redhat.com, tglx@linutronix.de, minchan.kim@gmail.com,
        rientjes@google.com, benh@kernel.crashing.org, paulus@samba.org,
        cl@linux.com, kosaki.motohiro@jp.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, wujianguo@huawei.com,
        wency@cn.fujitsu.com, hpa@zytor.com, linfeng@cn.fujitsu.com,
        laijs@cn.fujitsu.com, mgorman@suse.de, yinghai@kernel.org,
        glommer@parallels.com, jiang.liu@huawei.com, julian.calaby@gmail.com,
        sfr@canb.auug.org.au, guz.fnst@cn.fujitsu.com
Cc: x86@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-acpi@vger.kernel.org
Subject: [PATCH 0/2] Fix section mismatch caused by node offline code.
Date: Thu, 24 Jan 2013 17:38:05 +0800
Message-Id: <1359020287-11661-1-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.10.1
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/24 17:37:57,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/24 17:38:01,
	Serialize complete at 2013/01/24 17:38:01
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since node offline code uses __apicid_to_node[] and numa_clear_node(),
they are no longer init data or function. So do not declare them as
__cpuinitdata or __cpuinit.

Tang Chen (2):
  cpu_hotplug: Remove __cpuinitdata declaration of __apicid_to_node[].
  cpu-hotplug,memory-hotplug: Remove __cpuinit declaration of
    numa_clear_node().

 arch/x86/mm/numa.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)


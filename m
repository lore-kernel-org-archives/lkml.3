Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804AbaA1JCv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 04:02:51 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:26391 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750816AbaA1JCr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 04:02:47 -0500
X-IronPort-AV: E=Sophos;i="4.95,735,1384272000"; 
   d="scan'208";a="9461133"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: davej@redhat.com, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        akpm@linux-foundation.org, zhangyanfei@cn.fujitsu.com,
        guz.fnst@cn.fujitsu.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] numa, mem-hotplug: Fix array out of boundary in numa initialization.
Date: Tue, 28 Jan 2014 17:05:14 +0800
Message-Id: <1390899916-23566-1-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.11.7
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/01/28 17:01:10,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/01/28 17:01:10,
	Serialize complete at 2014/01/28 17:01:10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave found a kernel crash problem during boot. This is a problem of array out of boundary.
These two patches fix this problem.

Since I am in a hurry, if the changelog is not good enough, I'll resend a new version tomorrow.

Tang Chen (2):
  numa, mem-hotplug: Initialize numa_kernel_nodes in
    numa_clear_kernel_node_hotplug().
  numa, mem-hotplug: Fix array index overflow when synchronizing nid to
    memblock.reserved.

 arch/x86/mm/numa.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

-- 
1.8.3.1


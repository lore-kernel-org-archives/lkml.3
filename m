Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190Ab3AVLrQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 06:47:16 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:39095 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752264Ab3AVLrM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 06:47:12 -0500
X-IronPort-AV: E=Sophos;i="4.84,514,1355068800"; 
   d="scan'208";a="6628489"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: akpm@linux-foundation.org, rientjes@google.com, len.brown@intel.com,
        benh@kernel.crashing.org, paulus@samba.org, cl@linux.com,
        minchan.kim@gmail.com, kosaki.motohiro@jp.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, wujianguo@huawei.com,
        wency@cn.fujitsu.com, hpa@zytor.com, linfeng@cn.fujitsu.com,
        laijs@cn.fujitsu.com, mgorman@suse.de, yinghai@kernel.org,
        glommer@parallels.com, jiang.liu@huawei.com, julian.calaby@gmail.com,
        sfr@canb.auug.org.au
Cc: x86@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-acpi@vger.kernel.org
Subject: [PATCH Bug fix 0/4] Bug fix for movablecore_map boot option.
Date: Tue, 22 Jan 2013 19:46:17 +0800
Message-Id: <1358855181-6160-1-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.10.1
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/22 19:46:16,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/22 19:46:16,
	Serialize complete at 2013/01/22 19:46:16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

patch1 ~ patch3 fix some problems of movablecore_map boot option.
And since the name "core" could be confused, patch4 rename this option
to movablemem_map.

All these patches are based on the latest -mm tree.
git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git akpm

Tang Chen (4):
  Bug fix: Use CONFIG_HAVE_MEMBLOCK_NODE_MAP to protect movablecore_map
    in memblock_overlaps_region().
  Bug fix: Fix the doc format.
  Bug fix: Remove the unused sanitize_zone_movable_limit() definition.
  Rename movablecore_map to movablemem_map.

 Documentation/kernel-parameters.txt |    8 +-
 include/linux/memblock.h            |    3 +-
 include/linux/mm.h                  |    8 +-
 mm/memblock.c                       |   42 +++++++++++-
 mm/page_alloc.c                     |  116 +++++++++++++++++-----------------
 5 files changed, 106 insertions(+), 71 deletions(-)


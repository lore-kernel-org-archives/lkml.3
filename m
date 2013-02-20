Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935025Ab3BTLCN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 06:02:13 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:27708 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S933928Ab3BTLBn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 06:01:43 -0500
X-IronPort-AV: E=Sophos;i="4.84,701,1355068800"; 
   d="scan'208";a="6736031"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: akpm@linux-foundation.org, jiang.liu@huawei.com, wujianguo@huawei.com,
        hpa@zytor.com, wency@cn.fujitsu.com, laijs@cn.fujitsu.com,
        linfeng@cn.fujitsu.com, yinghai@kernel.org,
        isimatu.yasuaki@jp.fujitsu.com, rob@landley.net,
        kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, mgorman@suse.de,
        rientjes@google.com, guz.fnst@cn.fujitsu.com, rusty@rustcorp.com.au,
        lliubbo@gmail.com, jaegeuk.hanse@gmail.com, tony.luck@intel.com,
        glommer@parallels.com
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [Bug fix PATCH 0/2] Make whatever node kernel resides in un-hotpluggable.
Date: Wed, 20 Feb 2013 19:00:54 +0800
Message-Id: <1361358056-1793-1-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.10.1
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/20 19:00:51,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/20 19:00:59,
	Serialize complete at 2013/02/20 19:00:59
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As mentioned by HPA before, when we are using movablemem_map=acpi, if all the
memory in SRAT is hotpluggable, then the kernel will have no memory to use, and
will fail to boot.

Before parsing SRAT, memblock has already reserved some memory in memblock.reserve,
which is used by the kernel, such as storing the kernel image. We are not able to
prevent the kernel from using these memory. So, these 2 patches make the node which
the kernel resides in un-hotpluggable.

patch1: Do not add the memory reserved by memblock into movablemenm_map.map[].
patch2: Do not add any other memory ranges in the same node into movablemenm_map.map[],
        so that make the node which the kernel resides in un-hotpluggable.

Tang Chen (2):
  acpi, movablemem_map: Exclude memblock.reserved ranges when parsing
    SRAT.
  acpi, movablemem_map: Make whatever nodes the kernel resides in
    un-hotpluggable.

 Documentation/kernel-parameters.txt |    6 ++++++
 arch/x86/mm/srat.c                  |   35 ++++++++++++++++++++++++++++++++++-
 include/linux/mm.h                  |    1 +
 3 files changed, 41 insertions(+), 1 deletions(-)


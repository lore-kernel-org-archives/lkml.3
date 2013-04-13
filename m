Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757155Ab3DMAhB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 20:37:01 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:37365 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756727Ab3DMAgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 20:36:55 -0400
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Bob Liu <bob.liu@oracle.com>, Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH PART3 v3 0/6] staging: zcache/ramster: fix and ramster/debugfs improvement
Date: Sat, 13 Apr 2013 08:36:05 +0800
Message-Id: <1365813371-19006-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
x-cbid: 13041300-7014-0000-0000-000002D8C1A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changelog: 
 v2 -> v3:
  * update patch description of staging: ramster: Move debugfs code out of ramster.c file 
  * update patch title of staging: ramster/debug: Add RAMSTER_DEBUG Kconfig entry 
 v1 -> v2:  
  * fix bisect issue 
  * fix issue in patch staging: ramster: Provide accessory functions for counter decrease
  * drop patch staging: zcache: remove zcache_freeze 
  * Add Dan Acked-by

Fix bugs in zcache and rips out the debug counters out of ramster.c and 
sticks them in a debug.c file. Introduce accessory functions for counters 
increase/decrease, they are available when config RAMSTER_DEBUG, otherwise 
they are empty non-debug functions. Using an array to initialize/use debugfs 
attributes to make them neater. Dan Magenheimer confirm these works 
are needed. http://marc.info/?l=linux-mm&m=136535713106882&w=2

Patch 1~2 fix bugs in zcache

Patch 3~8 rips out the debug counters out of ramster.c and sticks them 
		  in a debug.c file 

Patch 9 fix coding style issue introduced in zcache2 cleanups 
        (s/int/bool + debugfs movement) patchset 

Patch 10 add how-to for ramster 

Dan Magenheimer (1):
	staging: ramster: add how-to for ramster
	
Wanpeng Li (6):
	staging: ramster: decrease foregin pers pages when count < 0
	staging: ramster: Move debugfs code out of ramster.c files
	staging: ramster/debug: Use an array to initialize/use debugfs attributes
	staging: ramster/debug: Add RAMSTER_DEBUG Kconfig entry
	staging: ramster: Add incremental accessory counters
	staging: zcache/debug: fix coding style

 drivers/staging/zcache/Kconfig           |    8 +
 drivers/staging/zcache/Makefile          |    1 +
 drivers/staging/zcache/debug.h           |   95 ++++++++---
 drivers/staging/zcache/ramster/HOWTO.txt |  257 ++++++++++++++++++++++++++++++
 drivers/staging/zcache/ramster/debug.c   |   66 ++++++++
 drivers/staging/zcache/ramster/debug.h   |  143 +++++++++++++++++
 drivers/staging/zcache/ramster/ramster.c |  148 +++--------------
 7 files changed, 573 insertions(+), 145 deletions(-)
 create mode 100644 drivers/staging/zcache/ramster/HOWTO.txt
 create mode 100644 drivers/staging/zcache/ramster/debug.c
 create mode 100644 drivers/staging/zcache/ramster/debug.h

-- 
1.7.10.4


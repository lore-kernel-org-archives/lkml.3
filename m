Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932332Ab3BNDHT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 22:07:19 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:47996 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754727Ab3BNDFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 22:05:18 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        dan.magenheimer@oracle.com, gregkh@linuxfoundation.org
Cc: sjenning@linux.vnet.ibm.com, rcj@linux.vnet.ibm.com
Subject: [PATCH] Various cleanups/fixes to zcache (v3).
Date: Wed, 13 Feb 2013 22:04:50 -0500
Message-Id: <1360811106-2679-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.0.2
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> # This line is ignored.
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH] Various cleanups/fixes to zcache (v3).
In-Reply-To: 

Hey Greg,

These patches do various cleanups of the zcache driver. The majority of the
work is just to move all the different counters out to a debug file. The next
step would be to figure out which ones are actually pertient and which can
go under the knife. Oh, and also fix some of the compiler warnings.

This is based on top of ommit 76426daf50d5df38893cc189e9ccd026093debc8
("staging/zcache: Fix/improve zcache writeback code, tie to a config option")
so should apply cleanly to your tree.

Please apply.

These patches are also available on this git tree:

git://git.kernel.org/pub/scm/linux/kernel/git/konrad/mm.git devel/zcache.cleanup.v2.5

if you would prefer to pull them.


 drivers/staging/zcache/Kconfig           |   8 +
 drivers/staging/zcache/Makefile          |   1 +
 drivers/staging/zcache/debug.c           |  71 ++++++
 drivers/staging/zcache/debug.h           | 229 ++++++++++++++++++
 drivers/staging/zcache/ramster/ramster.c |  34 +--
 drivers/staging/zcache/zbud.c            | 130 ++++++----
 drivers/staging/zcache/zcache-main.c     | 401 ++++++++-----------------------
 7 files changed, 501 insertions(+), 373 deletions(-)


Konrad Rzeszutek Wilk (16):
      zcache: s/int/bool/ on the various options.
      zcache: Provide accessory functions for counter increase
      zcache: Provide accessory functions for counter decrease.
      zcache: The last of the atomic reads has now an accessory function.
      zcache: Fix compile warnings due to usage of debugfs_create_size_t
      zcache: Make the debug code use pr_debug
      zcache: Move debugfs code out of zcache-main.c file.
      zcache/debug: Use an array to initialize/use debugfs attributes.
      zcache: Move the last of the debugfs counters out
      zcache: Module license is defined twice.
      zcache/debug: Coalesce all debug under CONFIG_ZCACHE_DEBUG
      zcache/zbud: Fix compiler warnings.
      zcache/zbud: Add incremental accessory counters
      zcache/zbud: Provide the accessory functions for counter decrease.
      ramster: Fix compile warnings due to usage of debugfs_create_size_t
      zcache/zbud: Fix __init mismatch


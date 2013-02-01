Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757529Ab3BAUw2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 15:52:28 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:47820 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756967Ab3BAUw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 15:52:26 -0500
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: dan.magenheimer@oracle.com, konrad.wilk@oracle.com,
        sjenning@linux.vnet.ibm.com, gregkh@linuxfoundation.org,
        rcj@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: [RFC PATCH] Various fixes for zcache.
Date: Fri,  1 Feb 2013 15:52:03 -0500
Message-Id: <1359751939-23584-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Greg, and Dan,

I posted these patches some time ago, and I think Dan Ack-ed them but they
are based on the patches which enables frontswap to have backends as modules.

So PLEASE just consider them RFC and _NOT_ apply them - as they won't cleanly
apply. They are based on this posting:

https://lkml.org/lkml/2013/2/1/542

This patchset is just cleaning the zcache driver a bit. I was hoping that the
end goal would be less code but with the header file ('debug.h') that did not
happend. But I can axe it some more - on the next iteration.

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

 drivers/staging/zcache/Kconfig           |   8 +
 drivers/staging/zcache/Makefile          |   3 +-
 drivers/staging/zcache/debug.c           |  66 ++++++
 drivers/staging/zcache/debug.h           | 225 ++++++++++++++++++
 drivers/staging/zcache/ramster/ramster.c |  34 +--
 drivers/staging/zcache/zbud.c            | 130 +++++++----
 drivers/staging/zcache/zcache-main.c     | 382 +++++++------------------------
 7 files changed, 487 insertions(+), 361 deletions(-)

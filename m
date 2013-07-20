Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754183Ab3GTOhN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 10:37:13 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:41294 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754117Ab3GTOhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 10:37:11 -0400
From: Bob Liu <lliubbo@gmail.com>
Cc: linux-kernel@vger.kernel.org, sjenning@linux.vnet.ibm.com,
        gregkh@linuxfoundation.org, ngupta@vflare.org, minchan@kernel.org,
        konrad.wilk@oracle.com, rcj@linux.vnet.ibm.com, mgorman@suse.de,
        riel@redhat.com, penberg@kernel.org, akpm@linux-foundation.org,
        Bob Liu <bob.liu@oracle.com>
Subject: [PATCH 0/2] zcache: a new start for upstream
Date: Sat, 20 Jul 2013 22:36:56 +0800
Message-Id: <1374331018-11045-1-git-send-email-bob.liu@oracle.com>
X-Mailer: git-send-email 1.7.10.4
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We already have zswap helps reducing the swap out/in IO operations by
compressing anon pages.
It has been merged into v3.11-rc1 together with the zbud allocation layer.

However there is another kind of pages(clean file pages) suitable for
compression as well. Upstream has already merged its frontend(cleancache).
Now we are lacking of a backend of cleancache as zswap to frontswap.

Furthermore, we need to balance the number of compressed anon and file pages,
E.g. it's unfair to normal file pages if zswap pool occupies too much memory for
the storage of compressed anon pages.

Although the current version of zcache in staging tree has already done those
works mentioned above, the implementation is too complicated to be merged into
upstream.

What I'm looking for is a new way for zcache towards upstream.
The first change is no more staging tree.
Second is implemented a simple cleancache backend at first, which is based on
the zbud allocation same as zswap.

At the end, I hope we can combine the new cleancache backend with
zswap(frontswap backend), in order to have a generic in-kernel memory
compression solution in upstream.

Bob Liu (2):
  zcache: staging: %s/ZCACHE/ZCACHE_OLD
  mm: zcache: core functions added

 drivers/staging/zcache/Kconfig  |   12 +-
 drivers/staging/zcache/Makefile |    4 +-
 mm/Kconfig                      |   18 +
 mm/Makefile                     |    1 +
 mm/zcache.c                     |  840 +++++++++++++++++++++++++++++++++++++++
 5 files changed, 867 insertions(+), 8 deletions(-)
 create mode 100644 mm/zcache.c

-- 
1.7.10.4


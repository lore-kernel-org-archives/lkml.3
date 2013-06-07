Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819Ab3FGM41 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 08:56:27 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:62930 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754132Ab3FGM4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 08:56:25 -0400
From: Peng Tao <bergwolf@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andreas Dilger <andreas.dilger@intel.com>, linux-next@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Glauber Costa <glommer@openvz.org>, Peng Tao <bergwolf@gmail.com>
Subject: [PATCH 0/5] staging/lustre: fix build in linux-next/akpm tree
Date: Fri,  7 Jun 2013 20:53:41 +0800
Message-Id: <1370609626-3734-1-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Bellow five patches convert Lustre client to new shrinker API and also
adapt num_physpages removal linux-next/akpm tree. Since both changes
are not in Greg's staging tree, I'm sending them to you so that Lustre
can build properly in linux-next.

Thanks,
Tao

Peng Tao (5):
  staging/lustre/ldlm: convert to shrinkers to count/scan API
  staging/lustre/obdclass: convert lu_object shrinker to count/scan API
  staging/lustre/ptlrpc: convert to new shrinker API
  staging/lustre/libcfs: cleanup linux-mem.h
  staging/lustre: replace num_physpages with totalram_pages

 .../lustre/include/linux/libcfs/linux/linux-mem.h  |   42 +-----
 drivers/staging/lustre/lustre/ldlm/ldlm_lib.c      |   10 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_pool.c     |  139 +++++++++++---------
 .../lustre/lustre/libcfs/linux/linux-tracefile.c   |    2 +-
 drivers/staging/lustre/lustre/llite/lproc_llite.c  |    8 +-
 drivers/staging/lustre/lustre/obdclass/class_obd.c |    6 +-
 .../lustre/lustre/obdclass/linux/linux-sysctl.c    |    6 +-
 drivers/staging/lustre/lustre/obdclass/lu_object.c |  100 +++++++-------
 drivers/staging/lustre/lustre/osc/lproc_osc.c      |    2 +-
 .../staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c    |    2 +-
 drivers/staging/lustre/lustre/ptlrpc/sec_bulk.c    |   80 ++++++-----
 11 files changed, 192 insertions(+), 205 deletions(-)

-- 
1.7.9.5


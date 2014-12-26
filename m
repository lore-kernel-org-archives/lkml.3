Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751529AbaLZAFv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2014 19:05:51 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:41992 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbaLZAFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2014 19:05:50 -0500
From: Jeremiah Mahler <jmmahler@gmail.com>
To: Oleg Drokin <oleg.drokin@intel.com>
Cc: Andreas Dilger <andreas.dilger@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peng Tao <bergwolf@gmail.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Kirill Tkhai <ktkhai@parallels.com>, Joe Perches <joe@perches.com>,
        Zi Shen Lim <zlim.lnx@gmail.com>,
        Dmitry Eremin <dmitry.eremin@intel.com>,
        Masaru Nomura <massa.nomura@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        James A Shackleford <shack@linux.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Jeremiah Mahler <jmmahler@gmail.com>
Subject: [PATCH 0/6] staging: lustre: use built in min/max functions
Date: Thu, 25 Dec 2014 16:04:40 -0800
Message-Id: <1419552286-8492-1-git-send-email-jmmahler@gmail.com>
X-Mailer: git-send-email 2.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The lustre modules define their own custom MIN, MAX and min_t functions.
However Linux provides these functions (include/linux/kernel.h) and their
design is more robust.  They check types and produce compiler warnings
if differing types are used.

This patch set updates the lustre modules to use the built in min/max
functions.

Jeremiah Mahler (6):
  staging: lustre: use min/max instead of MIN/MAX, simple cases
  staging: lustre: replace MIN with min_t
  staging: lustre: replace MIN/MAX with min_t/max_t
  staging: lustre: replace MIN with min, cast (__kernel_size_t)
  staging: lustre: replace MIN with min_t, remove cast
  staging: lustre: remove custom MIN/MAX and min_t operations

 .../lustre/include/linux/libcfs/libcfs_private.h     |  8 --------
 .../staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c   |  2 +-
 drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c  |  2 +-
 .../staging/lustre/lnet/klnds/socklnd/socklnd_cb.c   |  6 +++---
 drivers/staging/lustre/lnet/lnet/lib-move.c          | 20 ++++++++++----------
 drivers/staging/lustre/lnet/lnet/router.c            |  4 ++--
 drivers/staging/lustre/lnet/lnet/router_proc.c       |  2 +-
 drivers/staging/lustre/lnet/selftest/conrpc.h        |  2 +-
 drivers/staging/lustre/lnet/selftest/rpc.c           |  4 ++--
 .../lustre/lustre/libcfs/linux/linux-tracefile.c     |  2 +-
 drivers/staging/lustre/lustre/osc/osc_internal.h     |  5 -----
 11 files changed, 22 insertions(+), 35 deletions(-)

-- 
2.1.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757257Ab3FKUYX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 16:24:23 -0400
Received: from cobra.newdream.net ([66.33.216.30]:33857 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756479Ab3FKUYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 16:24:19 -0400
Date: Tue, 11 Jun 2013 13:24:19 -0700 (PDT)
From: Sage Weil <sage@inktank.com>
X-X-Sender: sage@cobra.newdream.net
To: torvalds@linux-foundation.org
cc: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Ceph fixes for -rc6
Message-ID: <alpine.DEB.2.00.1306111320070.28283@cobra.newdream.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following fixes for Ceph from

  git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client.git for-linus

There is a pair of fixes for double-frees in the recent bundle for 3.10, a 
couple of fixes for long-standing bugs (sleep while atomic and an 
endianness fix), and a locking fix that can be triggered when osds are 
going down.

Thanks!
sage

----------------------------------------------------------------
Alex Elder (3):
      libceph: must hold mutex for reset_changed_osds()
      rbd: don't destroy ceph_opts in rbd_add()
      rbd: fix cleanup in rbd_add()

Jim Schutt (2):
      ceph: add cpu_to_le32() calls when encoding a reconnect capability
      ceph: ceph_pagelist_append might sleep while atomic

 drivers/block/rbd.c   | 33 ++++++++++++-----------
 fs/ceph/locks.c       | 73 +++++++++++++++++++++++++++++++++------------------
 fs/ceph/mds_client.c  | 65 ++++++++++++++++++++++++---------------------
 fs/ceph/super.h       |  9 +++++--
 net/ceph/osd_client.c |  2 +-
 5 files changed, 108 insertions(+), 74 deletions(-)

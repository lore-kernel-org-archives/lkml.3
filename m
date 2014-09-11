Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752248AbaIKVYz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 17:24:55 -0400
Received: from cobra.newdream.net ([66.33.216.30]:60502 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996AbaIKVYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 17:24:54 -0400
Date: Thu, 11 Sep 2014 14:24:53 -0700 (PDT)
From: Sage Weil <sweil@redhat.com>
X-X-Sender: sage@cobra.newdream.net
To: torvalds@linux-foundation.org
cc: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Ceph fixes for 3.17-rc5
Message-ID: <alpine.DEB.2.00.1409111419010.15855@cobra.newdream.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following Ceph fixes from

  git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client.git for-linus

The main thing here is a set of three patches that fix a buffer overrun 
for large authentication tickets (sigh).  There is also a trivial warning 
fix and an error path fix that are both regressions.

Thanks!
sage

----------------------------------------------------------------
Ilya Dryomov (3):
      rbd: avoid format-security warning inside alloc_workqueue()
      libceph: add process_one_ticket() helper
      libceph: do not hard code max auth ticket len

Sage Weil (1):
      libceph: gracefully handle large reply messages from the mon

Wei Yongjun (1):
      rbd: fix error return code in rbd_dev_device_setup()

 drivers/block/rbd.c   |   6 +-
 net/ceph/auth_x.c     | 256 ++++++++++++++++++++++++++------------------------
 net/ceph/mon_client.c |   8 ++
 3 files changed, 147 insertions(+), 123 deletions(-)

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751365AbaKCKr5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 05:47:57 -0500
Received: from cobra.newdream.net ([66.33.216.30]:42077 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033AbaKCKrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 05:47:55 -0500
Date: Mon, 3 Nov 2014 02:47:54 -0800 (PST)
From: Sage Weil <sage@newdream.net>
To: torvalds@linux-foundation.org
cc: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Ceph fixes for 3.18
Message-ID: <alpine.DEB.2.00.1411030242480.13332@cobra.newdream.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following fixes for RBD from

  git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client.git for-linus

There is a GFP flag fix from Mike Christie, an error code fix from Jan, 
and fixes for two unnecessary allocations (kmalloc and workqueue) from 
Ilya. All are well tested.

Ilya has one other fix on the way but it didn't get tested in time.

Thanks!
sage


----------------------------------------------------------------
Ilya Dryomov (2):
      rbd: use a single workqueue for all devices
      libceph: eliminate unnecessary allocation in process_one_ticket()

Jan Kara (1):
      rbd: Fix error recovery in rbd_obj_read_sync()

Mike Christie (1):
      libceph: use memalloc flags for net IO

 drivers/block/rbd.c  | 35 +++++++++++++++++++----------------
 net/ceph/auth_x.c    | 25 ++++++++++---------------
 net/ceph/messenger.c | 10 +++++++++-
 3 files changed, 38 insertions(+), 32 deletions(-)

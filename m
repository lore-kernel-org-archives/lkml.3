Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751228Ab3LPFbI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 00:31:08 -0500
Received: from cobra.newdream.net ([66.33.216.30]:57457 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802Ab3LPFbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 00:31:06 -0500
Date: Sun, 15 Dec 2013 21:31:05 -0800 (PST)
From: Sage Weil <sage@inktank.com>
X-X-Sender: sage@cobra.newdream.net
To: torvalds@linux-foundation.org
cc: ceph-devel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Ceph fixes for 3.13-rc5
Message-ID: <alpine.DEB.2.00.1312130916510.14857@cobra.newdream.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following pair of Ceph fixes from

  git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client.git for-linus

One of these is fixing a regression from the d_flags file type patch that 
went into -rc1 that broke instantiation of inodes and dentries (we were 
doing dentries first).  The other is just an off-by-one corner case.

Thanks!
sage

----------------------------------------------------------------
Li Wang (1):
      ceph: Avoid data inconsistency due to d-cache aliasing in readpage()

Yan, Zheng (1):
      ceph: initialize inode before instantiating dentry

 fs/ceph/addr.c  |   8 +++-
 fs/ceph/inode.c | 136 ++++++++++++++++++++++++--------------------------------
 2 files changed, 64 insertions(+), 80 deletions(-)

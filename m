Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757788AbaEPT7q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 15:59:46 -0400
Received: from cobra.newdream.net ([66.33.216.30]:60659 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757312AbaEPT7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 15:59:45 -0400
Date: Fri, 16 May 2014 12:59:44 -0700 (PDT)
From: Sage Weil <sage@inktank.com>
X-X-Sender: sage@cobra.newdream.net
To: torvalds@linux-foundation.org
cc: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Ceph fixes for -rc6
Message-ID: <alpine.DEB.2.00.1405161252410.5149@cobra.newdream.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following Ceph fixes from

  git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client.git for-linus

The first patch fixes a problem when we have a page count of 0 for 
sendpage which is triggered by zfs.  The second fixes a bug in CRUSH that 
was resolved in the userland code a while back but fell through the cracks 
on the kernel side.

Thanks!
sage


----------------------------------------------------------------
Chunwei Chen (1):
      libceph: fix corruption when using page_count 0 page in rbd

Ilya Dryomov (1):
      crush: decode and initialize chooseleaf_vary_r

 net/ceph/messenger.c | 20 +++++++++++++++++++-
 net/ceph/osdmap.c    |  5 +++++
 2 files changed, 24 insertions(+), 1 deletion(-)

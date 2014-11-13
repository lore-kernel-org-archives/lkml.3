Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934123AbaKMVSS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 16:18:18 -0500
Received: from cobra.newdream.net ([66.33.216.30]:42913 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753906AbaKMVSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 16:18:17 -0500
Date: Thu, 13 Nov 2014 13:18:16 -0800 (PST)
From: Sage Weil <sweil@redhat.com>
X-X-Sender: sage@cobra.newdream.net
To: torvalds@linux-foundation.org
cc: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Ceph fixes for -rc5
Message-ID: <alpine.DEB.2.00.1411131314460.10048@cobra.newdream.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following Ceph fixes from

  git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client.git for-linus

There is an overflow bug fix for cephfs from Zheng, a fix for handling 
large authentication ticket buffers in libceph from Ilya, and a few fixes 
for the request handling code from Ilya that affect RBD volumes.

Thanks!
sage

----------------------------------------------------------------
Ilya Dryomov (4):
      libceph: do not crash on large auth tickets
      libceph: unlink from o_linger_requests when clearing r_osd
      libceph: clear r_req_lru_item in __unregister_linger_request()
      libceph: change from BUG to WARN for __remove_osd() asserts

Yan, Zheng (1):
      ceph: fix flush tid comparision

 fs/ceph/caps.c        |    2 +-
 net/ceph/crypto.c     |  169 ++++++++++++++++++++++++++++++++++++++-----------
 net/ceph/osd_client.c |    7 +-
 3 files changed, 138 insertions(+), 40 deletions(-)

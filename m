Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751975Ab3GHLos (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 07:44:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50764 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751651Ab3GHLor (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 07:44:47 -0400
Date: Mon, 8 Jul 2013 14:45:56 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org, asias@redhat.com,
        jasowang@redhat.com, mst@redhat.com
Subject: [PULL] vhost: cleanups and fixes
Message-ID: <20130708114556.GA17036@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 8bb495e3f02401ee6f76d1b1d77f3ac9f079e376:

  Linux 3.10 (2013-06-30 15:13:29 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to 09a34c8404c1d4c5782de319c02e1d742c57875c:

  vhost/test: update test after vhost cleanups (2013-07-07 18:02:25 +0300)

----------------------------------------------------------------
vhost: fixes and cleanups 3.11

This includes some fixes and cleanups for vhost net and scsi drivers.
The scsi driver changes will cause a conflict with  Nicholas Bellinger's scsi
target changes, but the conflicting commit in my tree simply renames some
variables so it's trivial to resolve.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Asias He (8):
      vhost: Simplify dev->vqs[i] access
      vhost-scsi: Remove unnecessary forward struct vhost_scsi declaration
      vhost-scsi: Rename struct vhost_scsi *s to *vs
      vhost-scsi: Make func indention more consistent
      vhost-scsi: Rename struct tcm_vhost_tpg *tv_tpg to *tpg
      vhost-scsi: Rename struct tcm_vhost_cmd *tv_cmd to *cmd
      vhost: Make vhost a separate module
      vhost: Make local function static

Michael S. Tsirkin (2):
      vhost-net: fix use-after-free in vhost_net_flush
      vhost/test: update test after vhost cleanups

 drivers/vhost/Kconfig  |   8 +
 drivers/vhost/Makefile |   3 +-
 drivers/vhost/net.c    |  13 +-
 drivers/vhost/scsi.c   | 472 ++++++++++++++++++++++++++-----------------------
 drivers/vhost/test.c   |  33 ++--
 drivers/vhost/vhost.c  |  86 +++++++--
 drivers/vhost/vhost.h  |   2 +
 7 files changed, 356 insertions(+), 261 deletions(-)

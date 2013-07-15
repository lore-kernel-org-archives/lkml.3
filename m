Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754431Ab3GOSah (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 14:30:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41397 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753601Ab3GOSaf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 14:30:35 -0400
Date: Mon, 15 Jul 2013 21:31:49 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org, asias@redhat.com,
        mst@redhat.com
Subject: [PULL] vhost: cleanups and fixes
Message-ID: <20130715183149.GA8215@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 09a34c8404c1d4c5782de319c02e1d742c57875c:

  vhost/test: update test after vhost cleanups (2013-07-07 18:02:25 +0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to 22fa90c7fb479694d6affebc049d21f06b714be6:

  vhost: Remove custom vhost rcu usage (2013-07-11 15:38:40 +0300)

----------------------------------------------------------------
vhost: more fixes for 3.11

This includes some fixes for vhost net and scsi drivers.
The test module has already been reworked to avoid rcu
usage, but the necessary core changes are missing,
we fixed this.
Unlikely to affect any real-world users, but it's
early in the cycle so, let's merge them.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Asias He (3):
      vhost-net: Always access vq->private_data under vq mutex
      vhost-scsi: Always access vq->private_data under vq mutex
      vhost: Remove custom vhost rcu usage

 drivers/vhost/net.c   | 37 ++++++++++++++++---------------------
 drivers/vhost/scsi.c  | 17 ++++++-----------
 drivers/vhost/test.c  |  6 ++----
 drivers/vhost/vhost.h | 10 ++--------
 4 files changed, 26 insertions(+), 44 deletions(-)

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753700Ab3FNSzA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 14:55:00 -0400
Received: from mail09.linbit.com ([212.69.161.110]:52586 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753645Ab3FNSy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 14:54:58 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com, Andreas Gruenbacher <agruen@linbit.com>,
        Philipp Reisner <philipp.reisner@linbit.com>
Subject: [PATCH 0/6] RFC: DRBD fixes and one functional enhancemet
Date: Fri, 14 Jun 2013 20:54:17 +0200
Message-Id: <1371236063-17198-1-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first 4 patches are obvious fixes. The last patch adds
the capability to change the activity log layout online.
(al-stripes and al-stripe-size)

Andreas Gruenbacher (2):
  drbd: Do not sleep inside rcu
  drbd: Fix rcu_read_lock balance on error path

Philipp Reisner (3):
  drbd: Ignore the exit code of a fence-peer handler if it returns too late
  drbd: Constants should be UPPERCASE
  drbd: Allow online change of al-stripes and al-stripe-size

Wei Yongjun (1):
  drbd: fix error return code in drbd_init()

 drivers/block/drbd/drbd_actlog.c   |   21 ++++
 drivers/block/drbd/drbd_int.h      |   15 ++-
 drivers/block/drbd/drbd_main.c     |   61 ++++++------
 drivers/block/drbd/drbd_nl.c       |  185 ++++++++++++++++++++++++++++--------
 drivers/block/drbd/drbd_receiver.c |   12 +--
 drivers/block/drbd/drbd_state.c    |    4 +-
 include/linux/drbd.h               |    6 +-
 include/linux/drbd_genl.h          |    2 +
 include/linux/drbd_limits.h        |    9 ++
 9 files changed, 236 insertions(+), 79 deletions(-)

-- 
1.7.9.5


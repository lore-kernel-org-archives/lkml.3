Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097Ab3FYOuS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 10:50:18 -0400
Received: from mail09.linbit.com ([212.69.161.110]:50480 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387Ab3FYOuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 10:50:13 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 0/6] DRBD fixes and one functional enhancemet
Date: Tue, 25 Jun 2013 16:50:02 +0200
Message-Id: <1372171808-30515-1-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

Please consider to apply these patches to your for-3.11/drivers branch.

The first 4 patches are obvious fixes. The last patch adds
the capability to change the activity log layout online.
(al-stripes and al-stripe-size)

I posted these patches on the 14th for review.


Andreas Gruenbacher (2):
  drbd: Do not sleep inside rcu
  drbd: Fix rcu_read_lock balance on error path

Philipp Reisner (3):
  drbd: Ignore the exit code of a fence-peer handler if it returns too
    late
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


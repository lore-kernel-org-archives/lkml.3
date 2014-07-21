Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831AbaGULqy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 07:46:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14371 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754504AbaGULqw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 07:46:52 -0400
From: Amit Shah <amit.shah@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Virtualization List <virtualization@lists.linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>, herbert@gondor.apana.org.au,
        keescook@chromium.org, jason@lakedaemon.net,
        Amos Kong <akong@redhat.com>, Amit Shah <amit.shah@redhat.com>
Subject: [PATCH v2 0/4] virtio-rng: contribute to early randomness requests
Date: Mon, 21 Jul 2014 17:15:48 +0530
Message-Id: <cover.1405942162.git.amit.shah@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v2:
 - update patch 3 to store the hwrng_register_done bool per-device
   rather than global
 - add patch 2 that re-arranges struct elems for better packing.

Hi,

This series enables virtio-rng to service the early randomness
requests made by the hwrng core (patch 3), with Herbert's idea of
using the scan routine.

Patch 4 reverts the previous restriction, which no longer applies, to
not send read requests to the host before successful probe.

Patches 1 and 2 are minor cleanups.

Please review and apply,

Amit Shah (4):
  virtio: rng: remove unused struct element
  virtio: rng: re-arrange struct elements for better packing
  virtio: rng: delay hwrng_register() till driver is ready
  Revert "hwrng: virtio - ensure reads happen after successful probe"

 drivers/char/hw_random/core.c       |  6 ------
 drivers/char/hw_random/virtio-rng.c | 39 ++++++++++++++++---------------------
 2 files changed, 17 insertions(+), 28 deletions(-)

-- 
1.9.3


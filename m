Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754152AbaGUJc0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 05:32:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50262 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753658AbaGUJcX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 05:32:23 -0400
From: Amit Shah <amit.shah@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Virtualization List <virtualization@lists.linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>, herbert@gondor.apana.org.au,
        keescook@chromium.org, jason@lakedaemon.net,
        Amos Kong <akong@redhat.com>, Amit Shah <amit.shah@redhat.com>
Subject: [PATCH 0/3] virtio-rng: contribute to early randomness requests
Date: Mon, 21 Jul 2014 15:00:58 +0530
Message-Id: <cover.1405934853.git.amit.shah@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This series enables virtio-rng to service the early randomness
requests made by the hwrng core (patch 2), with Herbert's idea of
using the scan routine.

Patch 3 reverts the previous restriction, which no longer applies, to
not send read requests to the host before successful probe.

Patch 1 is a minor cleanup.

Please review and apply,

Amit Shah (3):
  virtio: rng: remove unused struct element
  virtio: rng: delay hwrng_register() till driver is ready
  Revert "hwrng: virtio - ensure reads happen after successful probe"

 drivers/char/hw_random/core.c       |  6 ------
 drivers/char/hw_random/virtio-rng.c | 35 +++++++++++++++--------------------
 2 files changed, 15 insertions(+), 26 deletions(-)

-- 
1.9.3


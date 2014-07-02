Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752298AbaGBK2y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 06:28:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40182 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750852AbaGBK2x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 06:28:53 -0400
From: Amit Shah <amit.shah@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Virtualization List <virtualization@lists.linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>, herbert@gondor.apana.org.au,
        keescook@chromium.org, jason@lakedaemon.net,
        Amit Shah <amit.shah@redhat.com>
Subject: [PATCH 0/2] hwrng: don't fetch data before device init
Date: Wed,  2 Jul 2014 15:58:14 +0530
Message-Id: <cover.1404296679.git.amit.shah@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

When booting a recent kernel under KVM with the virtio-rng device
enabled, the boot process was stalling.  Bisect pointed to a commit
made during the 3.15 window to fetch randomness from newly-registered
devices in the hwrng core.  The details are in the patches.

I considered a couple of approaches, but basing on the init() function
being registered, as is done in patch 1 here, seems like the best idea,
since quite a few drivers need to initialize their devices before data
is fetched off them.

Please review and apply if appropriate,

Amit Shah (2):
  hwrng: don't fetch rng from sources without init
  virtio: rng: introduce an init fn for hwrng core

 drivers/char/hw_random/core.c       |  8 +++++---
 drivers/char/hw_random/virtio-rng.c | 11 +++++++++++
 2 files changed, 16 insertions(+), 3 deletions(-)

-- 
1.9.3


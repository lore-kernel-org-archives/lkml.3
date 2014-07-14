Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522AbaGNEgS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 00:36:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57797 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750737AbaGNEgK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 00:36:10 -0400
From: Amit Shah <amit.shah@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Virtualization List <virtualization@lists.linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>, herbert@gondor.apana.org.au,
        keescook@chromium.org, jason@lakedaemon.net,
        Amit Shah <amit.shah@redhat.com>
Subject: [RFC PATCH 0/3] hw_random: support for delayed init randomness requests
Date: Mon, 14 Jul 2014 10:05:18 +0530
Message-Id: <cover.1405277045.git.amit.shah@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This series introduces a way to allow devices to contribute to initial
system randomness after a certain delay.  Specifically, the virtio-rng
device can contribute initial randomness only after a successful
probe().

A delayed workqueue item is queued in the system queue to fetch this
randomness if the device indicates it's capable of contributing only
after a delay, via the new HWRNG_DELAY_READ_AT_INIT flag.

This series is intended for the next merge window.  I've marked it as
RFC because the last revert doesn't yet have a linux.git sha1.  I'll
re-post when the previous series gets committed.

Please review,

Amit Shah (3):
  hw_random: allow RNG devices to give early randomness after a delay
  virtio: rng: only accept delayed early randomness requests
  Revert "virtio: rng: ensure reads happen after successful probe"

 drivers/char/hw_random/core.c       | 26 +++++++++++++++++++-------
 drivers/char/hw_random/virtio-rng.c | 11 +----------
 include/linux/hw_random.h           |  8 ++++++++
 3 files changed, 28 insertions(+), 17 deletions(-)

-- 
1.9.3


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751533AbaKITrG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 14:47:06 -0500
Received: from smtp4-g21.free.fr ([212.27.42.4]:5838 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751095AbaKITrF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 14:47:05 -0500
X-Mailbox-Line: From 7d82dde0dc838d41bfb44ab734d10f838b49c47b Mon Sep 17 00:00:00 2001
Message-Id: <cover.1415562021.git.moinejf@free.fr>
From: Jean-Francois Moine <moinejf@free.fr>
Date: Sun, 9 Nov 2014 20:40:21 +0100
Subject: [PATCH v2 0/2] Fix some 'const' problems
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        Lars-Peter Clausen <lars@metafoo.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A cast was often needed to call some OF functions, removing
a 'const' attribute.
This patchset removes 'const' from the device_node pointers of the
sound/soc structures and also removes some useless casts
in the sound/soc tree.

v2: remove const from the pointers instead of modifying the
    OF functions (Russell King)

Jean-Francois Moine (2):
  ASoC: Remove 'const' from the device_node pointers
  ASoC: simple-card: Remove useless casts

 include/sound/soc.h                   | 6 +++---
 sound/soc/generic/simple-card.c       | 7 ++-----
 sound/soc/samsung/odroidx2_max98090.c | 4 ++--
 sound/soc/ux500/mop500.c              | 6 ++----
 4 files changed, 9 insertions(+), 14 deletions(-)

-- 
2.1.3


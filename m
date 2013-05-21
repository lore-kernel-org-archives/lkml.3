Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752956Ab3EUKEh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 06:04:37 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:56195 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533Ab3EUKEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 06:04:36 -0400
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        Ola Lilja <ola.o.lilja@stericsson.com>,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH 0/2] Set ab8500-codec dai slots from machine drivers
Date: Tue, 21 May 2013 12:04:07 +0200
Message-Id: <1369130649-15179-1-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.8.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

these two patches rework the slot selection code in ab8500-codec to use
the slots masks provided by the machine drivers instead of the hardcoded
ones as suggested.

The patches replaces some of the previous macros with a parametrized
version in the effort of making the actual code compact and readable,
and should be applied in order.  Also, the second patch drops the
hardcoded defintions swapped in -rc2, so you may want to rebase the
ux500 topic branch to avoid the conflict, or I can resend the patch
based on the topic branch directly.  Just let me know.

Big thanks to Ola for helping me figuring out the weird ab8500 slot
mapping logic.

Fabio

Fabio Baltieri (2):
  ASoC: ab8500-codec: Set tx dai slots from tx_mask
  ASoC: ab8500-codec: Set rx dai slots from rx_mask

 sound/soc/codecs/ab8500-codec.c | 60 ++++++++++++++++++++++++++---------------
 sound/soc/codecs/ab8500-codec.h | 42 +++++++++++++++--------------
 2 files changed, 61 insertions(+), 41 deletions(-)

-- 
1.8.2


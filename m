Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319AbaKHAPF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 19:15:05 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59956 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753083AbaKHAPC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 19:15:02 -0500
From: NeilBrown <neilb@suse.de>
To: Ulf Hansson <ulf.hansson@linaro.org>, Chris Ball <chris@printf.net>
Date: Sat, 08 Nov 2014 11:14:11 +1100
Subject: [PATCH 0/2] mmc: improve power-on for sdio wifi card.
Cc: devicetree@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, GTA04 owners <gta04-owner@goldelico.com>
Message-ID: <20141108000919.5629.55381.stgit@notabene.brown>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These two patches improve power-on management for my 'libertas'
wifi card.

On my board the card shares a regulator with a bluetooth device, so
turning off the regulator may not powercycle the card.  To get it to a
clean state it is necessary to hold the reset line down while enabling
the regulator.

So the first patch add a reset-gpio function for all sdio cards
which is configured through devicetree.

The sequence of commands sent to the sdio device for power-up differs
between runtime power resume (which works nicely) and system-suspend
resume (which doesn't).
The second patch add to calls to make these sequences the same and
allowed my device to work reliably after system suspend (though the
libertas driver needs a bit of work before it is completely reliable).

Thanks,
NeilBrown
---

NeilBrown (2):
      mmc: core: allow a reset gpio to be configured.
      mmc: core: reset sdio card properly on resume.


 Documentation/devicetree/bindings/mmc/mmc.txt |    3 +
 drivers/mmc/core/core.c                       |    3 +
 drivers/mmc/core/host.c                       |   12 ++++
 drivers/mmc/core/sdio.c                       |    8 ++-
 drivers/mmc/core/slot-gpio.c                  |   70 +++++++++++++++++++++++++
 include/linux/mmc/slot-gpio.h                 |    4 +
 6 files changed, 97 insertions(+), 3 deletions(-)

--
Signature


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759299AbbA0XgM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 18:36:12 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50781 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755523AbbA0XgJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 18:36:09 -0500
From: NeilBrown <neilb@suse.de>
To: Tony Lindgren <tony@atomide.com>, Ulf Hansson <ulf.hansson@linaro.org>
Date: Wed, 28 Jan 2015 10:35:24 +1100
Subject: [PATCH-RFC 0/3] mmc: switch to 1-bit mode which stopping clocks.
Cc: GTA04 owners <gta04-owner@goldelico.com>, linux-omap@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andreas Fenkart <afenkart@gmail.com>
Message-ID: <20150127233118.32160.11899.stgit@notabene.brown>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An mmc/sdio host which is expecting interrupts from an SDIO card
should not turn off clocks unless the bus is configured to a width
of 1-bit.  In 4-bit mode interrupts may not be generated without
the clock.

This series fixes omap_hsmmc to set 1-bit mode when appropriate
and so allows my wifi chip to work much better.

This is an RFC.  The code seems to work, but I feel it could be
structured better (so that other drivers can share more of it), and
I need to convince myself there is no room for races.

Thanks,
NeilBrown


---

NeilBrown (3):
      mmc: core: allow non-blocking form of mmc_claim_host
      mmc: core: export functions for setting bus width.
      mmc: omap_hsmmc: switch to 1-bit before turning off clocks if interrupts expected.


 drivers/mmc/core/core.c       |    4 ++-
 drivers/mmc/core/sdio.c       |    8 +++---
 drivers/mmc/host/omap_hsmmc.c |   55 ++++++++++++++++++++++++++++++++++++++++-
 include/linux/mmc/host.h      |    4 +++
 4 files changed, 64 insertions(+), 7 deletions(-)

--
Signature


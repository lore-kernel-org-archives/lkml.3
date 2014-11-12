Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934943AbaKLDz6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 22:55:58 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57537 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933282AbaKLDz4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 22:55:56 -0500
From: NeilBrown <neilb@suse.de>
To: Ulf Hansson <ulf.hansson@linaro.org>, Chris Ball <chris@printf.net>
Date: Wed, 12 Nov 2014 14:55:19 +1100
Subject: [PATCH 0/2] mmc: core: power-on sdio card correctly.
Cc: GTA04 owners <gta04-owner@goldelico.com>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20141112035217.18267.43304.stgit@notabene.brown>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These two patches replace my previous patch
  [PATCH 2/2] mmc: core: reset sdio card properly on resume.

The only change is to use host->card->ocr instead of
host->ocr_avail, as recommend by Ulf.

These restore my libertas  wifi device properly on system
resume.

(I'm still hoping for a reply to my other patch:
   [PATCH 1/2] mmc: core: allow a reset gpio to be configured.
)

Thanks,
NeilBrown

---

NeilBrown (2):
      mmc: core: use card->ocr when negotiating voltage setting in mmc_sdio_power_restore
      mmc: core: reset sdio card properly on resume.


 drivers/mmc/core/sdio.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--
Signature


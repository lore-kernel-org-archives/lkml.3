Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755610AbbALTYp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 14:24:45 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54336 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755213AbbALTYn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 14:24:43 -0500
From: NeilBrown <neilb@suse.de>
To: Ulf Hansson <ulf.hansson@linaro.org>, Chris Ball <chris@printf.net>
Date: Tue, 13 Jan 2015 08:23:18 +1300
Subject: [PATCH 0/3] Convert omap_hsmmc to use common devicetree parsing
 code.
Cc: GTA04 owners <gta04-owner@goldelico.com>,
        linux-omap <linux-omap@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20150112191702.2895.75815.stgit@notabene.brown>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is another resend with mmc_gpio_set_cd_isr() now returning
void and being EXPORTed.

I included
	WARN_ON(ctx->cd_gpio_isr);
to guard against misuse.

My goal is to get omap_hsmmc to use the common code for parsing of,
particularly so that I can set "cap-power-off-card", which omap_hsmmc
doesn't explicitly report.

Thanks,
NeilBrown

P.S. Sorry for delay - I've been travelling.

---

NeilBrown (3):
      mmc: core: Allow host driver to provide isr for card-detect interrupts.
      mmc: omap_hsmmc: use slot-gpio library for gpio support.
      mmc: omap_hsmmc: use mmc_of_parse to parse common mmc configuration.


 drivers/mmc/core/slot-gpio.c  |   18 +++++++
 drivers/mmc/host/omap_hsmmc.c |  100 +++++++++--------------------------------
 include/linux/mmc/slot-gpio.h |    2 +
 3 files changed, 40 insertions(+), 80 deletions(-)

--
Signature


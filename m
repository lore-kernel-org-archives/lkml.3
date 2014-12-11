Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965189AbaLKVoO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 16:44:14 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42125 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933369AbaLKVoM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 16:44:12 -0500
From: NeilBrown <neilb@suse.de>
To: Ulf Hansson <ulf.hansson@linaro.org>, Chris Ball <chris@printf.net>
Date: Fri, 12 Dec 2014 08:43:08 +1100
Subject: [PATCH v2 0/3] mmc: omap_hsmmc: make more use of mmc library
 functionality
Cc: GTA04 owners <gta04-owner@goldelico.com>, linux-omap@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>
Message-ID: <20141211214023.3753.10652.stgit@notabene.brown>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is resend, rebased on
  git://git.linaro.org/people/ulf.hansson/mmc.git  next

and so should apply to 3.19-rc1.

omap_hsmmc currently duplicates some work that can be done for
it by common code, and consequently does not benefit from extra
functionality in that common code.

In particular, mmc_of_parse and the slot-gpio library are not used.

This set of patches allows omap_hsmmc to use that common
functionality, and benefit from any extra devicetree parsing
that it performs.

The one awkward part of this change is that omap_hsmmc has an
interrupt handler for 'card detect' which does more than the
common code.
I see three options:
 1 - move that functionality into common code
 2 - discard that functionality
 3 - allow the common code to be configured to use a device-specific
     card detect interrupt.

This series implements '3'.  I suspect a mix of '1' and '2' would
be a better choice but I know none of the history or justification
for those differences.

My preference would be for this series to be applied (if there are
no other issues) and if there are opinions about effecting '1' or '2',
they can be done with subsequent patches.

Thanks,
NeilBrown


---

NeilBrown (3):
      mmc: omap_hsmmc: remove prepare/complete system suspend support.
      mmc: omap_hsmmc: use slot-gpio library for gpio support.
      mmc: omap_hsmmc: use mmc_of_parse to parse common mmc configuration.


 drivers/mmc/core/slot-gpio.c           |   24 +++++
 drivers/mmc/host/omap_hsmmc.c          |  150 +++++---------------------------
 include/linux/mmc/slot-gpio.h          |    2 
 include/linux/platform_data/mmc-omap.h |    4 -
 4 files changed, 47 insertions(+), 133 deletions(-)

--
Signature


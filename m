Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753038Ab3GUG6g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 02:58:36 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:52366 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751693Ab3GUG6e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 02:58:34 -0400
From: Joel Fernandes <joelf@ti.com>
To: Tony Lindgren <tony@atomide.com>, Sekhar Nori <nsekhar@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Sricharan R <r.sricharan@ti.com>, Rajendra Nayak <rnayak@ti.com>,
        Lokesh Vutla <lokeshvutla@ti.com>, Matt Porter <matt@ohporter.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Mark Brown <broonie@linaro.org>,
        Benoit Cousson <benoit.cousson@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Balaji TK <balajitk@ti.com>, Gururaja Hebbar <gururaja.hebbar@ti.com>,
        Chris Ball <cjb@laptop.org>, Jason Kridner <jkridner@beagleboard.org>
CC: Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>
Subject: [RFC 0/5] EDMA: Support to DMA scatter-lists with any no. of entries
Date: Sun, 21 Jul 2013 01:57:33 -0500
Message-ID: <1374389853-32458-1-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Re: on-going discussion at [1], I've added support to EDMA driver to be
able to accept scatter gather lists of arbitrary length, but still make
use of only a certain MAX number of slots. Thus free-ing up the rest of
the slots to other slave users.  With this there is no need for slave
drivers to query the EDMA driver how much is the MAX. It can send SG lists
of any number of entries to DMA.

Tested with various number of MAX slots , even just "1". In the case where
it is 1, only 1-slot is used to transmit an entire set of scatter list.
If only 1 slot is used for a channel, there is a performance impact, but
it works. A DMA resources vs Performance tradeoff.

[1] http://marc.info/?l=linux-omap&m=137416733628831&w=2

Joel Fernandes (5):
  dma: edma: Setup parameters to DMA MAX_SG_NR at a time
  dma: edma: Write out and handle MAX_SG_NR at a given time
  ARM: edma: Add function to manually trigger an EDMA channel
  dma: edma: Find missed events and issue them
  DMA: EDMA: Leave linked to Null slot instead of DUMMY slot

 arch/arm/common/edma.c             |   21 +++++++
 drivers/dma/edma.c                 |  113 ++++++++++++++++++++++++++----------
 include/linux/platform_data/edma.h |    2 +
 3 files changed, 104 insertions(+), 32 deletions(-)

-- 
1.7.9.5


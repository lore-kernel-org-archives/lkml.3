Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754AbaJ0FZY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 01:25:24 -0400
Received: from smtprelay0101.hostedemail.com ([216.40.44.101]:44381 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751326AbaJ0FZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 01:25:20 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::,RULES_HIT:41:355:379:541:973:988:989:1260:1345:1437:1534:1541:1711:1730:1747:1777:1792:1801:2198:2199:2393:2559:2562:3138:3139:3140:3141:3142:3353:3865:3866:3868:4605:4823:5007:6261:10004:10848:11026:11658:11914:12043:12048:12438:12517:12519:12555:12679:13141:13230:13311:13357:14096:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: eyes46_4b21bb1149903
X-Filterd-Recvd-Size: 2578
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
        dri-devel@lists.freedesktop.org, ivtv-devel@ivtvdriver.org,
        linux-media@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-parisc@vger.kernel.org
Cc: linux-input@vger.kernel.org, linux-wireless@vger.kernel.org,
        alsa-devel@alsa-project.org
Subject: [PATCH 00/11] treewide: mask then shift defects and style updates
Date: Sun, 26 Oct 2014 22:24:56 -0700
Message-Id: <cover.1414387334.git.joe@perches.com>
X-Mailer: git-send-email 2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

logical mask has lower precedence than shift but should be
done before the shift so parentheses are generally required.

And when masking with a fixed value after a shift, normal kernel
style has the shift on the left, then the shift on the right so
convert a few non-conforming uses.

Joe Perches (11):
  block: nvme-scsi: Fix probable mask then right shift defects
  radeon: evergreen: Fix probable mask then right shift defects
  aiptek: Fix probable mask then right shift defects
  dvb-net: Fix probable mask then right shift defects
  cx25840/cx18: Use standard ordering of mask and shift
  wm8350-core: Fix probable mask then right shift defect
  iwlwifi: dvm: Fix probable mask then right shift defect
  ssb: driver_chip_comon_pmu: Fix probable mask then right shift defect
  tty: ipwireless: Fix probable mask then right shift defects
  hwa-hc: Fix probable mask then right shift defect
  sound: ad1889: Fix probable mask then right shift defects

 drivers/block/nvme-scsi.c                | 12 ++++++------
 drivers/gpu/drm/radeon/evergreen.c       |  3 ++-
 drivers/input/tablet/aiptek.c            |  6 +++---
 drivers/media/dvb-core/dvb_net.c         |  4 +++-
 drivers/media/i2c/cx25840/cx25840-core.c | 12 ++++++------
 drivers/media/pci/cx18/cx18-av-core.c    | 16 ++++++++--------
 drivers/mfd/wm8350-core.c                |  2 +-
 drivers/net/wireless/iwlwifi/dvm/lib.c   |  4 ++--
 drivers/ssb/driver_chipcommon_pmu.c      |  4 ++--
 drivers/tty/ipwireless/hardware.c        | 12 ++++++------
 drivers/usb/host/hwa-hc.c                |  2 +-
 sound/pci/ad1889.c                       |  8 ++++----
 12 files changed, 44 insertions(+), 41 deletions(-)

-- 
2.1.2


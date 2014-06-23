Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756023AbaFWNmc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 09:42:32 -0400
Received: from smtprelay0225.hostedemail.com ([216.40.44.225]:40905 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755980AbaFWNm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 09:42:27 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::,RULES_HIT:41:69:355:379:541:973:982:988:989:1260:1345:1437:1535:1544:1711:1730:1747:1777:1792:1801:1981:2194:2199:2393:2553:2559:2562:3138:3139:3140:3141:3142:3354:3865:3868:3870:3872:4605:5007:6261:8603:10004:10026:10848:11026:11658:11914:12043:1211
X-HE-Tag: chain31_85f38761aed43
X-Filterd-Recvd-Size: 5259
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        iss_storagedev@hp.com, linux-crypto@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-rdma@vger.kernel.org,
        linux-media@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-eata@i-connect.net,
        devel@driverdev.osuosl.org, linux-arch@vger.kernel.org
Subject: [PATCH 00/22] Add and use pci_zalloc_consistent
Date: Mon, 23 Jun 2014 06:41:28 -0700
Message-Id: <cover.1403530604.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding the helper reduces object code size as well as overall
source size line count.

It's also consistent with all the various zalloc mechanisms
in the kernel.

Done with a simple cocci script and some typing.

Joe Perches (22):
  pci-dma-compat: Add pci_zalloc_consistent helper
  atm: Use pci_zalloc_consistent
  block: Use pci_zalloc_consistent
  crypto: Use pci_zalloc_consistent
  infiniband: Use pci_zalloc_consistent
  i810: Use pci_zalloc_consistent
  media: Use pci_zalloc_consistent
  amd: Use pci_zalloc_consistent
  atl1e: Use pci_zalloc_consistent
  enic: Use pci_zalloc_consistent
  sky2: Use pci_zalloc_consistent
  micrel: Use pci_zalloc_consistent
  qlogic: Use pci_zalloc_consistent
  irda: Use pci_zalloc_consistent
  ipw2100: Use pci_zalloc_consistent
  mwl8k: Use pci_zalloc_consistent
  rtl818x: Use pci_zalloc_consistent
  rtlwifi: Use pci_zalloc_consistent
  scsi: Use pci_zalloc_consistent
  staging: Use pci_zalloc_consistent
  synclink_gt: Use pci_zalloc_consistent
  vme: bridges: Use pci_zalloc_consistent

 drivers/atm/he.c                                   | 31 ++++++++---------
 drivers/atm/idt77252.c                             | 15 ++++----
 drivers/block/DAC960.c                             | 18 +++++-----
 drivers/block/cciss.c                              | 11 +++---
 drivers/block/skd_main.c                           | 25 +++++---------
 drivers/crypto/hifn_795x.c                         |  5 ++-
 drivers/gpu/drm/i810/i810_dma.c                    |  5 ++-
 drivers/infiniband/hw/amso1100/c2.c                |  6 ++--
 drivers/infiniband/hw/nes/nes_hw.c                 | 12 +++----
 drivers/infiniband/hw/nes/nes_verbs.c              |  5 ++-
 drivers/media/common/saa7146/saa7146_core.c        | 15 ++++----
 drivers/media/common/saa7146/saa7146_fops.c        |  5 +--
 drivers/media/pci/bt8xx/bt878.c                    | 16 +++------
 drivers/media/pci/ngene/ngene-core.c               |  7 ++--
 drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c  | 11 ++----
 drivers/media/usb/ttusb-dec/ttusb_dec.c            | 11 ++----
 drivers/net/ethernet/amd/pcnet32.c                 | 16 ++++-----
 drivers/net/ethernet/atheros/atl1e/atl1e_main.c    |  7 ++--
 drivers/net/ethernet/cisco/enic/vnic_dev.c         |  8 ++---
 drivers/net/ethernet/marvell/sky2.c                |  5 ++-
 drivers/net/ethernet/micrel/ksz884x.c              |  7 ++--
 .../net/ethernet/qlogic/netxen/netxen_nic_ctx.c    |  4 +--
 drivers/net/ethernet/qlogic/qlge/qlge_main.c       | 11 +++---
 drivers/net/irda/vlsi_ir.c                         |  4 +--
 drivers/net/wireless/ipw2x00/ipw2100.c             | 16 +++------
 drivers/net/wireless/mwl8k.c                       |  6 ++--
 drivers/net/wireless/rtl818x/rtl8180/dev.c         | 11 +++---
 drivers/net/wireless/rtlwifi/pci.c                 | 17 +++------
 drivers/scsi/3w-sas.c                              |  5 ++-
 drivers/scsi/a100u2w.c                             |  8 ++---
 drivers/scsi/be2iscsi/be_main.c                    | 10 +++---
 drivers/scsi/be2iscsi/be_mgmt.c                    |  3 +-
 drivers/scsi/csiostor/csio_wr.c                    |  8 +----
 drivers/scsi/eata.c                                |  5 ++-
 drivers/scsi/hpsa.c                                |  8 ++---
 drivers/scsi/megaraid/megaraid_mbox.c              | 16 ++++-----
 drivers/scsi/megaraid/megaraid_sas_base.c          |  8 ++---
 drivers/scsi/mesh.c                                |  6 ++--
 drivers/scsi/mvumi.c                               |  9 ++---
 drivers/scsi/pm8001/pm8001_sas.c                   |  5 ++-
 drivers/staging/rtl8192e/rtl8192e/rtl_core.c       | 15 +++-----
 drivers/staging/rtl8192ee/pci.c                    | 37 +++++++-------------
 drivers/staging/rtl8821ae/pci.c                    | 36 +++++++------------
 drivers/staging/slicoss/slicoss.c                  |  9 ++---
 drivers/staging/vt6655/device_main.c               | 40 +++++++---------------
 drivers/tty/synclink_gt.c                          |  5 ++-
 drivers/vme/bridges/vme_ca91cx42.c                 |  6 ++--
 drivers/vme/bridges/vme_tsi148.c                   |  6 ++--
 include/asm-generic/pci-dma-compat.h               |  8 +++++
 49 files changed, 209 insertions(+), 354 deletions(-)

-- 
1.8.1.2.459.gbcd45b4.dirty


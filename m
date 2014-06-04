Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751909AbaFDTUu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 15:20:50 -0400
Received: from p02c12o142.mxlogic.net ([208.65.145.75]:39609 "EHLO
	p02c12o142.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293AbaFDTUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 15:20:49 -0400
X-MXL-Hash: 538f719019d350f2-392600272a11e3d0cbeb533f548ae2bb2639721e
From: Joe Lawrence <joe.lawrence@stratus.com>
To: <linux-kernel@vger.kernel.org>
CC: Jens Axboe <axboe@kernel.dk>, Jeff Moyer <jmoyer@redhat.com>,
        Joe Lawrence <joe.lawrence@stratus.com>
Subject: [PATCH v2 0/2] block,scsi: fixup blk_get_request dead queue scenarios
Date: Wed, 4 Jun 2014 15:20:31 -0400
Message-ID: <1401909633-25931-1-git-send-email-joe.lawrence@stratus.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [134.111.199.152]
X-AnalysisOut: [v=2.1 cv=A4XiPsmG c=1 sm=1 tr=0 a=VNTQBUOG7PJoPU2GWtE7Ww==]
X-AnalysisOut: [:117 a=VNTQBUOG7PJoPU2GWtE7Ww==:17 a=E_Dx0WffYqYA:10 a=_KQ]
X-AnalysisOut: [qW7t0BisA:10 a=CdzKgOd8jloA:10 a=BLceEmwcHowA:10 a=uelBKuK]
X-AnalysisOut: [pAAAA:8 a=YlVTAMxIAAAA:8 a=Nd1Jnr_Tmadqe7M_pLQA:9]
X-Spam: [F=0.5000000000; CM=0.500; MH=0.500(2014060421); S=0.200(2014051901)]
X-MAIL-FROM: <joe.lawrence@stratus.com>
X-SOURCE-IP: [134.111.1.17]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v1->v2: incorporate Jeff's feedback in bsg_map_hdr() and Reviewed-by
        tags.

Joe Lawrence (2):
  block,scsi: verify return pointer from blk_get_request
  block,scsi: convert and handle ERR_PTR from blk_get_request

 block/blk-core.c                            | 34 ++++++++++++++---------------
 block/bsg.c                                 |  8 +++----
 block/scsi_ioctl.c                          | 13 ++++++++---
 drivers/block/paride/pd.c                   |  2 ++
 drivers/block/pktcdvd.c                     |  2 ++
 drivers/block/sx8.c                         |  2 +-
 drivers/cdrom/cdrom.c                       |  4 ++--
 drivers/ide/ide-park.c                      |  2 +-
 drivers/scsi/device_handler/scsi_dh_alua.c  |  2 +-
 drivers/scsi/device_handler/scsi_dh_emc.c   |  2 +-
 drivers/scsi/device_handler/scsi_dh_hp_sw.c |  4 ++--
 drivers/scsi/device_handler/scsi_dh_rdac.c  |  2 +-
 drivers/scsi/osd/osd_initiator.c            |  4 ++--
 drivers/scsi/osst.c                         |  2 +-
 drivers/scsi/scsi_error.c                   |  2 ++
 drivers/scsi/scsi_lib.c                     |  2 +-
 drivers/scsi/scsi_tgt_lib.c                 |  2 +-
 drivers/scsi/sg.c                           |  4 ++--
 drivers/scsi/st.c                           |  2 +-
 drivers/target/target_core_pscsi.c          |  2 +-
 20 files changed, 55 insertions(+), 42 deletions(-)

-- 
1.8.3.1


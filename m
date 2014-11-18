Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753862AbaKRLYB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 06:24:01 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:32810 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699AbaKRLX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 06:23:59 -0500
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH 00/12] media: use vb2_ops_wait_prepare/finish helper
Date: Tue, 18 Nov 2014 11:23:29 +0000
Message-Id: <1416309821-5426-1-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

This patch set uses the vb2 ops helpers for wait_prepare and
wait_finish callbacks for drivers which using vb2 helpers.
This patchset is compile tested only.

I am not sure on how mem2mem drivers work because the have
2 queues sharing the same lock, so not sure if these
changes to mem2mem drivers are valid.

Lad, Prabhakar (12):
  media: s3c-camif: use vb2_ops_wait_prepare/finish helper
  media: ti-vpe: use vb2_ops_wait_prepare/finish helper
  media: exynos-gsc: use vb2_ops_wait_prepare/finish helper
  media: soc_camera: use vb2_ops_wait_prepare/finish helper
  media: sh_veu: use vb2_ops_wait_prepare/finish helper
  media: marvell-ccic: use vb2_ops_wait_prepare/finish helper
  media: s5p-tv: use vb2_ops_wait_prepare/finish helper
  media: blackfin: use vb2_ops_wait_prepare/finish helper
  media: s5p-mfc: use vb2_ops_wait_prepare/finish helper
  media: vivid: use vb2_ops_wait_prepare/finish helper
  media: davinci: vpif_capture: use vb2_ops_wait_prepare/finish helper
  media: usb: uvc: use vb2_ops_wait_prepare/finish helper

 drivers/media/platform/blackfin/bfin_capture.c     | 17 ++---------
 drivers/media/platform/davinci/vpif_capture.c      |  2 ++
 drivers/media/platform/exynos-gsc/gsc-core.h       | 12 --------
 drivers/media/platform/exynos-gsc/gsc-m2m.c        |  6 ++--
 drivers/media/platform/marvell-ccic/mcam-core.c    | 29 ++++--------------
 drivers/media/platform/s3c-camif/camif-capture.c   | 17 ++---------
 drivers/media/platform/s5p-mfc/s5p_mfc.c           |  1 +
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c       | 20 ++-----------
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c       | 20 ++-----------
 drivers/media/platform/s5p-tv/mixer_video.c        | 21 ++-----------
 drivers/media/platform/sh_veu.c                    | 35 +++++-----------------
 drivers/media/platform/soc_camera/atmel-isi.c      |  7 +++--
 drivers/media/platform/soc_camera/mx3_camera.c     |  7 +++--
 drivers/media/platform/soc_camera/rcar_vin.c       |  7 +++--
 .../platform/soc_camera/sh_mobile_ceu_camera.c     |  7 +++--
 drivers/media/platform/soc_camera/soc_camera.c     | 16 ----------
 drivers/media/platform/ti-vpe/vpe.c                | 19 ++++--------
 drivers/media/platform/vivid/vivid-core.c          | 19 ++++--------
 drivers/media/platform/vivid/vivid-core.h          |  3 --
 drivers/media/platform/vivid/vivid-sdr-cap.c       |  4 +--
 drivers/media/platform/vivid/vivid-vbi-cap.c       |  4 +--
 drivers/media/platform/vivid/vivid-vbi-out.c       |  4 +--
 drivers/media/platform/vivid/vivid-vid-cap.c       |  4 +--
 drivers/media/platform/vivid/vivid-vid-out.c       |  4 +--
 drivers/media/usb/uvc/uvc_queue.c                  | 19 ++----------
 25 files changed, 75 insertions(+), 229 deletions(-)

-- 
1.9.1


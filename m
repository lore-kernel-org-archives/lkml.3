Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813AbaJLUk4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 16:40:56 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:49049 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107AbaJLUkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 16:40:52 -0400
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH 00/15] media: davinci: vpbe enhancements
Date: Sun, 12 Oct 2014 21:40:30 +0100
Message-Id: <1413146445-7304-1-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds following support:-
1: moves the vb2 queue init to probe.
2: uses vb2_fop_* helpers.
3: adds support for VB2_DMABUF.
4: adds support for VIDIOC_CREATE_BUFS and VIDIOC_EXPBUF.
5: Uses fh provided by v4l core.
6: And some cleanups.

Lad, Prabhakar (15):
  media: davinci: vpbe: initialize vb2 queue and DMA context in probe
  media: davinci: vpbe: drop buf_init() callback
  media: davinci: vpbe: use vb2_ops_wait_prepare/finish helper functions
  media: davinci: vpbe: drop buf_cleanup() callback
  media: davinci: vpbe: improve vpbe_buffer_prepare() callback
  media: davinci: vpbe: use vb2_fop_mmap/poll
  media: davinci: vpbe: use fh handling provided by v4l
  media: davinci: vpbe: use vb2_ioctl_* helpers
  media: davinci: vpbe: add support for VB2_DMABUF
  media: davinci: vpbe: add support for VIDIOC_CREATE_BUFS
  media: davinci: vpbe: add support for VIDIOC_EXPBUF
  media: davinci: vpbe: use helpers provided by core if streaming is
    started
  media: davinci: vpbe: drop unused member memory from vpbe_layer
  media: davinci: vpbe: group v4l2_ioctl_ops
  media: davinci: vpbe: return -ENODATA for *dv_timings/*_std calls

 drivers/media/platform/davinci/vpbe.c         |  18 +-
 drivers/media/platform/davinci/vpbe_display.c | 607 ++++++--------------------
 include/media/davinci/vpbe_display.h          |  19 -
 3 files changed, 159 insertions(+), 485 deletions(-)

-- 
1.9.1


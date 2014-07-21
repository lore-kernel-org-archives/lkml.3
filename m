Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558AbaGUVge (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 17:36:34 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:34750 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753688AbaGUVgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 17:36:33 -0400
From: Fabio Falzoi <fabio.falzoi84@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org, joe@perches.com,
        dan.carpenter@oracle.com, wei_wang@realsil.com.cn,
        micky_ching@realsil.com.cn, Fabio Falzoi <fabio.falzoi84@gmail.com>
Subject: [PATCH v4 0/3] Staging: rts5208: Use standard debug features
Date: Mon, 21 Jul 2014 23:36:01 +0200
Message-Id: <1405978564-11343-1-git-send-email-fabio.falzoi84@gmail.com>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use standard debug features instead of relying on the custom
configuration option CONFIG_RTS5208_DEBUG and a series of home grown
macros.

Changes in v4:
* use dev_dbg instead of pr_debug
* use dev_dbg with %*ph modifier instead of print_hex_dump_bytes

Changes in v3:
* defined rtsx_hex_dump as a static inline function to avoid checkpatch errors

Changes in v2:
* defined rtsx_hex_dump macro to produce output only if DEBUG is defined

Fabio Falzoi (3):
  Staging: rts5208: Replace custom macro with dev_dbg
  Staging: rts5208: Use dev_dbg and %*ph specifier to dump memory
  Staging: rts5208: Remove CONFIG_RTS5208_DEBUG option

 drivers/staging/rts5208/Kconfig          |   7 --
 drivers/staging/rts5208/debug.h          |  43 -------
 drivers/staging/rts5208/ms.c             | 130 +++++++++++----------
 drivers/staging/rts5208/rtsx.c           |   6 +-
 drivers/staging/rts5208/rtsx.h           |   1 -
 drivers/staging/rts5208/rtsx_card.c      |  73 ++++++------
 drivers/staging/rts5208/rtsx_card.h      |   1 -
 drivers/staging/rts5208/rtsx_chip.c      | 139 ++++++++++++----------
 drivers/staging/rts5208/rtsx_chip.h      |   5 +
 drivers/staging/rts5208/rtsx_scsi.c      |  47 ++++----
 drivers/staging/rts5208/rtsx_scsi.h      |   2 +-
 drivers/staging/rts5208/rtsx_transport.c |  55 +++++----
 drivers/staging/rts5208/sd.c             | 194 +++++++++++++++++--------------
 drivers/staging/rts5208/spi.c            |   7 +-
 drivers/staging/rts5208/trace.h          |  14 +--
 drivers/staging/rts5208/xd.c             | 113 ++++++++++--------
 16 files changed, 424 insertions(+), 413 deletions(-)
 delete mode 100644 drivers/staging/rts5208/debug.h

-- 
2.0.0


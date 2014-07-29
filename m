Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754270AbaG2WQP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 18:16:15 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:35106 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbaG2WQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 18:16:14 -0400
From: Fabio Falzoi <fabio.falzoi84@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org, joe@perches.com,
        dan.carpenter@oracle.com, wei_wang@realsil.com.cn,
        micky_ching@realsil.com.cn, Fabio Falzoi <fabio.falzoi84@gmail.com>
Subject: [PATCH v5 0/4] Staging: rts5208: Use standard debug features
Date: Wed, 30 Jul 2014 00:15:51 +0200
Message-Id: <1406672155-13187-1-git-send-email-fabio.falzoi84@gmail.com>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use standard debug features instead of relying on the custom
configuration option CONFIG_RTS5208_DEBUG and a series of home grown
macros.

Changes in v5:
* remove useless prints used just to mark when entering a function
  (we should prefer ftrace for that)

Changes in v4:
* use dev_dbg instead of pr_debug
* use dev_dbg with %*ph modifier instead of print_hex_dump_bytes

Changes in v3:
* defined rtsx_hex_dump as a static inline function to avoid checkpatch errors

Changes in v2:
* defined rtsx_hex_dump macro to produce output only if DEBUG is defined

Fabio Falzoi (4):
  Staging: rts5208: Remove useless traces
  Staging: rts5208: Replace custom macro with dev_dbg
  Staging: rts5208: Use dev_dbg and %*ph specifier to dump memory
  Staging: rts5208: Remove CONFIG_RTS5208_DEBUG option

 drivers/staging/rts5208/Kconfig          |   7 --
 drivers/staging/rts5208/debug.h          |  43 -------
 drivers/staging/rts5208/ms.c             | 130 +++++++++------------
 drivers/staging/rts5208/rtsx.c           |   6 +-
 drivers/staging/rts5208/rtsx.h           |   1 -
 drivers/staging/rts5208/rtsx_card.c      |  73 ++++++------
 drivers/staging/rts5208/rtsx_card.h      |   1 -
 drivers/staging/rts5208/rtsx_chip.c      | 137 ++++++++++++----------
 drivers/staging/rts5208/rtsx_chip.h      |   5 +
 drivers/staging/rts5208/rtsx_scsi.c      |  47 ++++----
 drivers/staging/rts5208/rtsx_scsi.h      |   2 +-
 drivers/staging/rts5208/rtsx_transport.c |  55 +++++----
 drivers/staging/rts5208/sd.c             | 194 +++++++++++++++++--------------
 drivers/staging/rts5208/spi.c            |   7 +-
 drivers/staging/rts5208/trace.h          |  14 +--
 drivers/staging/rts5208/xd.c             | 104 +++++++++--------
 16 files changed, 398 insertions(+), 428 deletions(-)
 delete mode 100644 drivers/staging/rts5208/debug.h

-- 
2.0.0


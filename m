Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751875AbaGHVir (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 17:38:47 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:39564 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958AbaGHVip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 17:38:45 -0400
From: Fabio Falzoi <fabio.falzoi84@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org, joe@perches.com,
        dan.carpenter@oracle.com, wei_wang@realsil.com.cn,
        micky_ching@realsil.com.cn, Fabio Falzoi <fabio.falzoi84@gmail.com>
Subject: [PATCH v3 0/4] Staging: rts5208: Use standard debug features
Date: Tue,  8 Jul 2014 23:38:28 +0200
Message-Id: <1404855512-5864-1-git-send-email-fabio.falzoi84@gmail.com>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use standard debug features instead of relying on the custom
configuration option CONFIG_RTS5208_DEBUG and a series of home grown
macros.

Changes in v3:
* defined rtsx_hex_dump as a static inline function to avoid checkpatch errors

Changes in v2:
* defined rtsx_hex_dump macro to produce output only if DEBUG is defined

Fabio Falzoi (4):
  Staging: rts5208: Replace custom macro with pr_debug
  Staging: rts5208: Replace custom macro with print_hex_dump_bytes
  Staging: rts5208: Remove CONFIG_RTS5208_DEBUG option
  Staging: rts5208: Fix a format specifier for dev_err

 drivers/staging/rts5208/Kconfig          |   7 --
 drivers/staging/rts5208/debug.h          |  43 -------
 drivers/staging/rts5208/ms.c             | 144 ++++++++++++------------
 drivers/staging/rts5208/rtsx.c           |   8 +-
 drivers/staging/rts5208/rtsx.h           |   1 -
 drivers/staging/rts5208/rtsx_card.c      |  72 ++++++------
 drivers/staging/rts5208/rtsx_card.h      |   1 -
 drivers/staging/rts5208/rtsx_chip.c      | 134 +++++++++++-----------
 drivers/staging/rts5208/rtsx_scsi.c      |  45 ++++----
 drivers/staging/rts5208/rtsx_transport.c |  45 ++++----
 drivers/staging/rts5208/sd.c             | 186 +++++++++++++++----------------
 drivers/staging/rts5208/spi.c            |   8 +-
 drivers/staging/rts5208/trace.h          |  15 ++-
 drivers/staging/rts5208/xd.c             | 121 ++++++++++----------
 14 files changed, 393 insertions(+), 437 deletions(-)
 delete mode 100644 drivers/staging/rts5208/debug.h

-- 
2.0.0


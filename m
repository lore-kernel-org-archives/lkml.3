Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751854AbaGFQMy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 12:12:54 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:56038 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806AbaGFQMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 12:12:53 -0400
From: Fabio Falzoi <fabio.falzoi84@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        wei_wang@realsil.com.cn, micky_ching@realsil.com.cn,
        Fabio Falzoi <fabio.falzoi84@gmail.com>
Subject: [PATCH 0/4] Staging: rts5208: Use dynamic debug feature
Date: Sun,  6 Jul 2014 18:12:14 +0200
Message-Id: <1404663138-21333-1-git-send-email-fabio.falzoi84@gmail.com>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use standard dynamic debug features instead of relying on the custom
configuration option CONFIG_RTS5208_DEBUG and a series of home grown
macros.

Fabio Falzoi (4):
  Use standard pr_debug instead of a custom macro
  Use standard print_hex_dump_debug instead of a custom macro
  Remove CONFIG_RTS5208_DEBUG option
  Fix a format specifier for dev_err

 drivers/staging/rts5208/Kconfig          |   7 --
 drivers/staging/rts5208/debug.h          |  43 -------
 drivers/staging/rts5208/ms.c             | 146 ++++++++++++------------
 drivers/staging/rts5208/rtsx.c           |   8 +-
 drivers/staging/rts5208/rtsx.h           |   1 -
 drivers/staging/rts5208/rtsx_card.c      |  72 ++++++------
 drivers/staging/rts5208/rtsx_card.h      |   1 -
 drivers/staging/rts5208/rtsx_chip.c      | 136 +++++++++++-----------
 drivers/staging/rts5208/rtsx_scsi.c      |  46 ++++----
 drivers/staging/rts5208/rtsx_transport.c |  45 ++++----
 drivers/staging/rts5208/sd.c             | 189 ++++++++++++++++---------------
 drivers/staging/rts5208/spi.c            |   8 +-
 drivers/staging/rts5208/trace.h          |  12 +-
 drivers/staging/rts5208/xd.c             | 121 ++++++++++----------
 14 files changed, 396 insertions(+), 439 deletions(-)
 delete mode 100644 drivers/staging/rts5208/debug.h

-- 
2.0.0


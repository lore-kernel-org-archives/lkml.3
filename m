Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753704AbaHEVYn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 17:24:43 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:43475 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753389AbaHEVYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 17:24:42 -0400
From: Fabio Falzoi <fabio.falzoi84@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        micky_ching@realsil.com.cn, wei_wang@realsil.com.cn, joe@perches.org,
        Fabio Falzoi <fabio.falzoi84@gmail.com>
Subject: [PATCH v6 0/2] Staging: rts5208: Use standard debug features
Date: Tue,  5 Aug 2014 23:24:16 +0200
Message-Id: <1407273858-15267-1-git-send-email-fabio.falzoi84@gmail.com>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use standard debug features instead of relying on the custom
configuration option CONFIG_RTS5208_DEBUG and a series of home grown
macros.
This new version contains the remaining two chunks of the v5 patchset:
the first two chunks have already been merged.

Changes in v6:
* Use print_hex_dump_bytes in place of dev_dbg to dump buffer potentially
  larger than 64 bytes.

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

Fabio Falzoi (2):
  Staging: rts5208: Use dev_dbg and print_hex_dump_bytes to dump memory
  Staging: rts5208: Remove CONFIG_RTS5208_DEBUG option

 drivers/staging/rts5208/Kconfig     |  7 -------
 drivers/staging/rts5208/ms.c        |  5 +++--
 drivers/staging/rts5208/rtsx_chip.c |  6 ++++--
 drivers/staging/rts5208/rtsx_scsi.c |  7 +++----
 drivers/staging/rts5208/sd.c        | 11 ++++-------
 drivers/staging/rts5208/trace.h     |  8 --------
 6 files changed, 14 insertions(+), 30 deletions(-)

-- 
2.0.0


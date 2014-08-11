Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932274AbaHKUqM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 16:46:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5968 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932082AbaHKUqL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 16:46:11 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: axboe@fb.com, Akhil.Bhansali@hgst.com
Subject: [patch] skd: add build dependency on HARDIRQ
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 11 Aug 2014 16:46:05 -0400
Message-ID: <x49a97apxf6.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This driver won't build on architectures without generic hardirq
support.

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>

diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
index 014a1cf..f3a5300 100644
--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@ -325,6 +325,7 @@ config BLK_DEV_SKD
 	tristate "STEC S1120 Block Driver"
 	depends on PCI
 	depends on 64BIT
+	depends on GENERIC_HARDIRQS
 	---help---
 	Saying Y or M here will enable support for the
 	STEC, Inc. S1120 PCIe SSD.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965056AbaFCV3Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 17:29:16 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:51660 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932485AbaFCV3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 17:29:15 -0400
From: Andrea Adami <andrea.adami@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Russell King <linux@arm.linux.org.uk>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Olof Johansson <olof@lixom.net>, linux-kernel@vger.kernel.org,
        Andrea Adami <andrea.adami@gmail.com>
Subject: [PATCH 0/2] ARM: sa1100: collie mtd fixes
Date: Tue,  3 Jun 2014 23:28:59 +0200
Message-Id: <1401830941-17086-1-git-send-email-andrea.adami@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After having extensivly tested three different units (2 Zaurus SL-5500,
1 SL-5500G) I finally send this small patches fixing collie's mtd.

The background is the improved support for the specific chips, see pending:
"mtd: cfi_cmdset_0001.c: add support for Sharp LH28F640BF NOR" for linux-mtd.

The most important is the first one reverting to cfi_probe
(the test-unit had broken CFI rom and CFI query was not matched).

The second one exposes the nor bootblock (in a read-only manner).
Sharp decided to put there just a few bytes, the sharpls_param
(COMADJ, UUID, TOUCH, AD, PHAD) set in the Diagnostic Menu.

Andrea Adami (2):
  arm: sa1100: collie: revert back to cfi_probe
  arm: sa1100: collie: add top boot mtd partition

 arch/arm/mach-sa1100/collie.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

-- 
1.9.1


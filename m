Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752626AbaGVCUz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 22:20:55 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:47689 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130AbaGVCUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 22:20:54 -0400
From: Charles Manning <cdhmanning@gmail.com>
To: linux-kernel@vger.kernel.org, s.trumtrar@pengutronix.de,
        dinguyen@altera.com, cslee@altera.com
Cc: Charles Manning <cdhmanning@gmail.com>
Subject: [PATCH 0/3] clk : Fix SOCFPGA clk crash and some clean up
Date: Tue, 22 Jul 2014 14:20:31 +1200
Message-Id: <1405995634-3297-1-git-send-email-cdhmanning@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After some digging into a crash on the SOCFPGA initialisation it was
determined that this was due to the SOCFPGA's name look-up dereferencing
the clock init pointer. This is a bad thing to do because the init data is
constructed on the stack and thus a pointer to the init data is no longer
valid after clk_register() has been called.

Most, if not all, drivers create the init data on the stack. Thus init 
pointer should not be left hanging after it has been used in clk_register.
Thus one of these patches NULLs the pointer so it can't be abused.

In the long term, it would be way, way better to pass the init pointer as
an argument rather than as a pointer in hw.


Charles Manning (3):
  clk : Clean up checkpatch warnings
  clk: Prevent a hanging pointer being abused
  clk: socfpga Change name look-up to not use the init pointer

 drivers/clk/clk.c                | 37 +++++++++++++++++++--------------
 drivers/clk/socfpga/clk-gate.c   | 44 ++++++++++++++++++++++++++--------------
 drivers/clk/socfpga/clk-periph.c | 16 ++++++++++-----
 drivers/clk/socfpga/clk-pll.c    | 13 ++++++++----
 drivers/clk/socfpga/clk.h        |  7 ++++---
 5 files changed, 75 insertions(+), 42 deletions(-)

-- 
1.9.1


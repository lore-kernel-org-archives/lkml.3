Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933075Ab3FRTNI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 15:13:08 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:45560 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756252Ab3FRTNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 15:13:06 -0400
From: David Daney <ddaney.cavm@gmail.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org,
        Jamie Iles <jamie@jamieiles.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>
Subject: [PATCH 0/5] MIPS/tty/8250: Use standard 8250 drivers for OCTEON
Date: Tue, 18 Jun 2013 12:12:50 -0700
Message-Id: <1371582775-12141-1-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

Get rid of the custom OCTEON UART probe code and use 8250_dw instead.

The first patch just gets rid of Ralf's Kconfig workarounds for the
real problem, which is OCTEON's inclomplete serial support.

Then we just make minor patches to 8250_dw, and rip out all this
OCTEON code.

Since the patches are all interdependent, we might want to merge them
via a single tree (perhaps Ralf's MIPS tree).

David Daney (5):
  Revert "MIPS: Octeon: Fix build error if CONFIG_SERIAL_8250=n"
  MIPS: OCTEON: Set proper UART clock in internal device trees.
  tty/8250_dw: Add support for OCTEON UARTS.
  MIPS: OCTEON: Remove custom serial setup code.
  MIPS: Update cavium_octeon_defconfig

 arch/mips/cavium-octeon/Makefile          |   1 -
 arch/mips/cavium-octeon/octeon-platform.c |   9 ++-
 arch/mips/cavium-octeon/serial.c          | 109 ------------------------------
 arch/mips/configs/cavium_octeon_defconfig |   4 +-
 drivers/tty/serial/8250/8250_dw.c         |  45 ++++++++++--
 5 files changed, 48 insertions(+), 120 deletions(-)
 delete mode 100644 arch/mips/cavium-octeon/serial.c

-- 
1.7.11.7


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935148Ab3FSVhj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 17:37:39 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:56158 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934929Ab3FSVhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 17:37:37 -0400
From: David Daney <ddaney.cavm@gmail.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org,
        Jamie Iles <jamie@jamieiles.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>
Subject: [PATCH v2 0/4] MIPS/tty/8250: Use standard 8250 drivers for OCTEON
Date: Wed, 19 Jun 2013 14:37:25 -0700
Message-Id: <1371677849-23912-1-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

Changes from v1: Fix breakage in non-OCTEON builds of 8250_dw.c

1) Fix OCTEON's UART clock rate.

2) Make minor patches to 8250_dw so it can be used by OCTEON

3) Rip out the OCTEON serial code.

4) Update defconfig so we default to having a usable serial port.

Since the patches are all interdependent, we might want to merge them
via a single tree (perhaps Ralf's MIPS tree as OKed by Greg K-H).

David Daney (4):
  MIPS: OCTEON: Set proper UART clock in internal device trees.
  tty/8250_dw: Add support for OCTEON UARTS.
  MIPS: OCTEON: Remove custom serial setup code.
  MIPS: Update cavium_octeon_defconfig

 arch/mips/cavium-octeon/Makefile          |   2 +-
 arch/mips/cavium-octeon/octeon-platform.c |   9 ++-
 arch/mips/cavium-octeon/serial.c          | 109 ------------------------------
 arch/mips/configs/cavium_octeon_defconfig |   4 +-
 drivers/tty/serial/8250/8250_dw.c         | 108 ++++++++++++++++++-----------
 5 files changed, 79 insertions(+), 153 deletions(-)
 delete mode 100644 arch/mips/cavium-octeon/serial.c

-- 
1.7.11.7


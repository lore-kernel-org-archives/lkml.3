Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752317AbaLGPlw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 10:41:52 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:62825 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061AbaLGPlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 10:41:49 -0500
From: robert.ward114@googlemail.com
To: arnd@arndb.de, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Cc: Rob Ward <robert.ward114@googlemail.com>
Subject: [PATCH 0/3] /dev/mem as optional device + associated tidy up
Date: Sun,  7 Dec 2014 15:40:32 +0000
Message-Id: <1417966835-14012-1-git-send-email-robert.ward114@googlemail.com>
X-Mailer: git-send-email 2.2.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Ward <robert.ward114@googlemail.com>

Makes the /dev/mem device optional using the CONFIG_DEVMEM option.

This brings /dev/mem in line with /dev/kmem so it can de disabled. 
Disabling /dev/mem is preferable on devices that do not require
direct access to memory in order to improve security. This is especially
true on platforms where no restiction is placed on the areas of memory
that can be accessed(for example mips) without custom modifcations to
the kernel source.

The implementation of this functionality declares the mem_fops structure
as __maybe_unused to eliminate the need for #ifdefs throughout the
file.

Follow up changes are present to change CONFIG_DEVKMEM and CONFIG_DEVPORT
to use __maybe_unused. This simplifies the code and make the
implementations consistent.

Rob Ward (3):
  drivers: char: mem: Make /dev/mem an optional device
  drivers: char: mem: Simplify DEVKMEM configuration
  drivers: char: mem: Simplify DEVPORT configuration

 drivers/char/Kconfig |  9 +++++++++
 drivers/char/mem.c   | 18 +++++-------------
 2 files changed, 14 insertions(+), 13 deletions(-)

-- 
2.0.2


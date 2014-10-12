Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751227AbaJLHbq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 03:31:46 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:33176 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772AbaJLHbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 03:31:45 -0400
Date: Sun, 12 Oct 2014 00:31:47 -0700
From: Darren Hart <dvhart@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] platform-drivers-x86 for v3.18
Message-ID: <20141012073145.GA15039@vmdeb7>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following have all spent at least a few days in linux-next, most for more
than a week. These are mostly cleanups and error handling improvements with a
few updates to extend existing support to newer hardware.

Thanks,

Darren Hart
Intel Open Source Technology Center

The following changes since commit 9e82bf014195d6f0054982c463575cdce24292be:

  Linux 3.17-rc5 (2014-09-14 17:50:12 -0700)

are available in the git repository at:

  git://git.infradead.org/users/dvhart/linux-platform-drivers-x86.git tags/platform-drivers-x86-v3.18-1

for you to fetch changes up to eabde0fa967052df12bdd8e8a72f0af799e1e704:

  toshiba_acpi: Adapt kbd_bl_timeout_store to the new kbd type (2014-10-06 17:44:42 -0700)

----------------------------------------------------------------
platform-drivers-x86 for 3.18

dell-wmi: Fix access out of memory
eeepc-laptop: Cleanups, refactoring, sysfs perms, and improved error handling
intel-rst: ACPI and error handling cleanups
thinkpad-acpi: Whitespace cleanup
toshiba_acpi: HCI/SCI interface update, keyboard backlight type 2 support,
              new scancodes, cleanups

----------------------------------------------------------------
Azael Avalos (8):
      toshiba_acpi: Additional hotkey scancodes
      toshiba_acpi: Fix illumination not available on certain models
      toshiba_acpi: Change touchpad store to check for invalid values
      toshiba_acpi: Support new keyboard backlight type
      toshiba_acpi: Rename hci_raw to tci_raw
      toshiba_acpi: Unify return codes prefix from HCI/SCI to TOS
      toshiba_acpi: Change HCI/SCI functions return code type
      toshiba_acpi: Adapt kbd_bl_timeout_store to the new kbd type

Frans Klaver (10):
      eeepc-laptop: clean up coding style
      eeepc-laptop: change sysfs function names to API expectations
      eeepc-laptop: use DEVICE_ATTR* to instantiate device_attributes
      eeepc-laptop: pull out ACPI_STORE_FUNC and ACPI_SHOW_FUNC macros
      eeepc-laptop: tell sysfs that the disp attribute is write-only
      eeepc-laptop: pull out SENSOR_STORE_FUNC and SENSOR_SHOW_FUNC macros
      eeepc-laptop: make fan1_input really read-only
      eeepc-laptop: check proper return values in get_cpufv
      eeepc-laptop: store_cpufv: return error if set_acpi fails
      eeepc-laptop: clean up control flow in *_rfkill_notifier

Jan van den Berg (1):
      x86: thinkpad_acpi.c: fixed spacing coding style issue

Pali Rohár (1):
      dell-wmi: Fix access out of memory

Paul Bolle (1):
      eeepc-laptop: simplify parse_arg()

Peter Ujfalusi (2):
      intel-rst: Use ACPI_FAILURE() macro instead !ACPI_SUCCESS() for error checking
      intel-rst: Clean up ACPI add function

 drivers/platform/x86/dell-wmi.c      |  12 +-
 drivers/platform/x86/eeepc-laptop.c  | 206 ++++++------
 drivers/platform/x86/intel-rst.c     |  23 +-
 drivers/platform/x86/thinkpad_acpi.c |  44 +--
 drivers/platform/x86/toshiba_acpi.c  | 606 ++++++++++++++++++++++-------------
 5 files changed, 522 insertions(+), 369 deletions(-)

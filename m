Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751761AbaLRRvX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 12:51:23 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:46438 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068AbaLRRvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 12:51:21 -0500
Date: Thu, 18 Dec 2014 09:51:27 -0800
From: Darren Hart <dvhart@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] platform-drivers-x86 for 3.19
Message-ID: <20141218175126.GA78864@vmdeb7>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following have all spent at least a week in next, most quite a bit more. The
one exception being the acerhdf Kconfig regression fix from Randy Dunlap.

In addition to the usual cleanups, quirks, and new IDs, some larger changes are
included:

thinkpad-acpi using software mute simplifies the driver and the user experience
significantly.

dell-laptop changes nearly doubles the size of the driver to support keyboard
backlight based on new device documentation. It saw several rounds of review
from me and Dan Carpenter caught a bug. I would have preferred a series of
smaller patches, but it didn't seem feasible upon inspection.

The rest are self-explanatory and summarized in the tag.

Thanks,

Darren Hart
Intel Open Source Technology Center

The following changes since commit fc14f9c1272f62c3e8d01300f52467c0d9af50f9:

  Linux 3.18-rc5 (2014-11-16 16:36:20 -0800)

are available in the git repository at:

  git://git.infradead.org/users/dvhart/linux-platform-drivers-x86.git tags/platform-drivers-x86-v3.19-1

for you to fetch changes up to 200db647112d9a0f1dce273604f949f916bd2426:

  platform/x86/acerhdf: Still depends on THERMAL (2014-12-15 09:29:58 -0800)

----------------------------------------------------------------
platform-drivers-x86 for 3.19

thinkpad-acpi: Switch to software mute, cleanups
acerhdf: Bang-bang thermal governor, new models, cleanups
dell-laptop: New keyboard backlight support and documentation
toshiba_acpi: Keyboard backlight updates, hotkey handling
dell-wmi: Keypress filtering, WMI event processing
eeepc-laptop: Multiple cleanups, improved error handling, documentation
hp_wireless: Inform the user if hp_wireless_input_setup()/add() fails
misc: Code cleanups, quirks, various new IDs

----------------------------------------------------------------
Andy Lutomirski (2):
      thinkpad-acpi: Try to use full software mute control
      acpi: Remove _OSI(Linux) for ThinkPads

Azael Avalos (4):
      toshiba_acpi: Fix regression caused by backlight extra check code
      toshiba_acpi: Move hotkey enabling code to its own function
      toshiba_acpi: Change notify funtion to handle more events
      toshiba_acpi: Add keyboard backlight mode change event

Chen Hanxiao (1):
      intel_ips: fix a comment typo

Darren Hart (1):
      Merge branch 'thinkpad-acpi' into for-next

Dominique Leuenberger (1):
      hp_accel: Add support for HP ZBook 15

Frans Klaver (7):
      eeepc-laptop: flatten control flow
      eeepc-laptop: don't break user visible strings
      eeepc-laptop: define rfkill notifier nodes only once
      eeepc-laptop: replace magic numbers with defines
      eeepc-laptop: document fan_pwm conversions
      eeepc-laptop: don't assume get_acpi succeeds
      eeepc-laptop: clean up control flow in eeepc_acpi_notify

Gabriele Mazzotta (3):
      dell-wmi: Don't report keypresses for radio state changes
      dell-wmi: Don't report keypresses on keybord illumination change
      Documentation: Add entry for dell-laptop sysfs interface

Giedrius Statkevicius (1):
      hp_wireless: Inform the user if hp_wireless_input_setup()/add() fails

Giedrius Statkevičius (1):
      drivers: platform: change 0x20 to I8042_STR_AUXDATA in i8042 filters

Hans de Goede (1):
      asus-nb-wmi: Add another wapf=4 quirk

Markus Elfring (2):
      platform: x86: Deletion of checks before backlight_device_unregister()
      Sony-laptop: Deletion of an unnecessary check before the function call "pci_dev_put"

Ondrej Zary (1):
      toshiba-acpi: Add missing ID (TOS6207)

Pali Rohár (3):
      dell-wmi: Update code for processing WMI events
      platform: x86: dell-laptop: Add support for keyboard backlight
      dell-smo8800: Add more ACPI ids and change description of driver

Peter Feuerer (5):
      acerhdf: Adding support for "manual mode"
      acerhdf: Adding support for new models
      acerhdf: Use bang-bang thermal governor
      acerhdf: added critical trip point
      acerhdf: minor clean up

Randy Dunlap (1):
      platform/x86/acerhdf: Still depends on THERMAL

 .../ABI/testing/sysfs-platform-dell-laptop         |   60 ++
 drivers/acpi/blacklist.c                           |   54 -
 drivers/platform/x86/Kconfig                       |    7 +-
 drivers/platform/x86/acerhdf.c                     |  265 +++--
 drivers/platform/x86/asus-laptop.c                 |    3 +-
 drivers/platform/x86/asus-nb-wmi.c                 |    9 +
 drivers/platform/x86/asus-wmi.c                    |    3 +-
 drivers/platform/x86/dell-laptop.c                 | 1057 +++++++++++++++++++-
 drivers/platform/x86/dell-smo8800.c                |   10 +-
 drivers/platform/x86/dell-wmi.c                    |  176 +++-
 drivers/platform/x86/eeepc-laptop.c                |  213 ++--
 drivers/platform/x86/fujitsu-laptop.c              |    6 +-
 drivers/platform/x86/hp-wireless.c                 |    3 +
 drivers/platform/x86/hp_accel.c                    |    1 +
 drivers/platform/x86/ideapad-laptop.c              |    3 +-
 drivers/platform/x86/intel_ips.c                   |    2 +-
 drivers/platform/x86/intel_oaktrail.c              |    3 +-
 drivers/platform/x86/msi-laptop.c                  |    2 +-
 drivers/platform/x86/msi-wmi.c                     |    3 +-
 drivers/platform/x86/sony-laptop.c                 |    6 +-
 drivers/platform/x86/thinkpad_acpi.c               |  116 ++-
 drivers/platform/x86/toshiba_acpi.c                |  166 +--
 22 files changed, 1767 insertions(+), 401 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-platform-dell-laptop

-- 
Darren Hart
Intel Open Source Technology Center

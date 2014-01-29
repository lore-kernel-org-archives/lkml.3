Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755792AbaA2ANq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 19:13:46 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:52597 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752791AbaA2ANo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 19:13:44 -0500
Date: Wed, 29 Jan 2014 00:13:38 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, platform-drivers-x86@vger.kernel.org
Subject: [GIT PULL] x86 platform drivers for 3.14
Message-ID: <20140129001338.GA1427@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Nothing amazingly special here. Some cleanups, a new driver to support a 
single button on some new HPs, a tiny amount of hardware enablement.

The following changes since commit ec513b16c480c6cdda1e3d597e611eafca05227b:

  Merge tag 'usb-3.14-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb (2014-01-20 16:13:02 -0800)

are available in the git repository at:


  git://cavan.codon.org.uk/platform-drivers-x86.git for_linus

for you to fetch changes up to b4b0b4a9e0392dbd00e5f033e1329ce61ed06fef:

  ipc: add intel-mid's pci id macros (2014-01-21 08:47:15 -0500)

----------------------------------------------------------------
Alex Hung (1):
      hp-wireless: new driver for hp wireless button for Windows 8

Colin Ian King (1):
      sony-laptop: remove unnecessary assigment of len

David Cohen (2):
      ipc: simplify platform data approach
      ipc: add intel-mid's pci id macros

David E. Box (1):
      X86 platform: New BayTrail IOSF-SB MBI driver

Guenter Roeck (5):
      compal-laptop: Use devm_kzalloc to allocate local data structure
      eeepc-laptop: Convert to use devm_hwmon_device_register_with_groups
      compal-laptop: Replace SENSOR_DEVICE_ATTR with DEVICE_ATTR
      compal-laptop: Use devm_hwmon_device_register_with_groups
      asus-wmi: Convert to use devm_hwmon_device_register_with_groups

Hans de Goede (2):
      dell-laptop: rkill whitelist Precision models
      dell-laptop: Only install the i8042 filter when rfkill is active

Julia Lawall (1):
      fujitsu-laptop: fix error return code

Rashika Kheria (2):
      drivers: platform: Mark functions as static in hp_accel.c
      drivers: platform: Include appropriate header file in mxm-wmi.c

Takashi Iwai (1):
      hp_accel: Add a new PnP ID HPQ6007 for new HP laptops

Unai Uribarri (1):
      toshiba_acpi: Support RFKILL hotkey scancode

Wei Yongjun (1):
      dell-laptop: fix to return error code in dell_send_intensity()

 drivers/platform/x86/Kconfig          |  19 +++
 drivers/platform/x86/Makefile         |   2 +
 drivers/platform/x86/asus-wmi.c       |  48 ++------
 drivers/platform/x86/compal-laptop.c  | 121 +++++++++---------
 drivers/platform/x86/dell-laptop.c    |  78 ++++++------
 drivers/platform/x86/eeepc-laptop.c   |  52 ++------
 drivers/platform/x86/fujitsu-laptop.c |  15 ++-
 drivers/platform/x86/hp-wireless.c    | 132 ++++++++++++++++++++
 drivers/platform/x86/hp_accel.c       |   7 +-
 drivers/platform/x86/intel_baytrail.c | 224 ++++++++++++++++++++++++++++++++++
 drivers/platform/x86/intel_baytrail.h |  90 ++++++++++++++
 drivers/platform/x86/intel_scu_ipc.c  |  87 ++++++-------
 drivers/platform/x86/mxm-wmi.c        |   1 +
 drivers/platform/x86/sony-laptop.c    |   2 +-
 drivers/platform/x86/toshiba_acpi.c   |   1 +
 15 files changed, 642 insertions(+), 237 deletions(-)
 create mode 100644 drivers/platform/x86/hp-wireless.c
 create mode 100644 drivers/platform/x86/intel_baytrail.c
 create mode 100644 drivers/platform/x86/intel_baytrail.h


-- 
Matthew Garrett | mjg59@srcf.ucam.org

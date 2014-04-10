Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758624AbaDJQTc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 12:19:32 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:57933 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753045AbaDJQTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 12:19:30 -0400
Date: Thu, 10 Apr 2014 17:19:27 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: torvalds@linux-foundation.org
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] X86 platform driver updates
Message-ID: <20140410161927.GA29203@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Support for the new keyboard features on the Thinkpad Carbon, a bunch of 
updates for the Sony and Toshiba drivers, a new driver for upcoming 
Alienware hardware and a few misc fixes. There's a couple of patches 
that got Acked today but aren't invasive, so I'll send a further PR for 
them next week.

The following changes since commit 18a1a7a1d862ae0794a0179473d08a414dd49234:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/cmetcalf/linux-tile (2014-04-06 08:11:57 -0700)

are available in the git repository at:


  git://cavan.codon.org.uk/platform-drivers-x86.git for_linus

for you to fetch changes up to 562c7cec1e92be85ade6f65fff107651e10ee2ed:

  alienware-wmi: cover some scenarios where memory allocations would fail (2014-04-10 12:11:56 -0400)

----------------------------------------------------------------
Azael Avalos (7):
      toshiba_acpi: Add System Configuration Interface
      toshiba_acpi: Adapt Illumination code to use SCI
      toshiba_acpi: Add keyboard backlight support
      toshiba_acpi: Add touchpad enable/disable support-
      toshiba_acpi: Add ECO mode led support
      toshiba_acpi: Add accelerometer support
      toshiba_acpi: Update version and copyright info

Behan Webster (1):
      x86, acpi: LLVMLinux: Remove nested functions from Thinkpad ACPI

Borislav Petkov (1):
      x86, platform: Make HP_WIRELESS option text more descriptive

David E. Box (1):
      Revert "X86 platform: New BayTrail IOSF-SB MBI driver"

Javier Achirica (8):
      sony-laptop: add support as Fn+1 as a hot key
      sony-laptop: Add support for lid resume settings on Vaio Pro
      sony-laptop: add panel_id function
      sony-laptop: add usb charge function
      sony-laptop: add fan speed regulation function
      sony-laptop: add hibernate on low battery function
      sony-laptop: adjust keyboard backlight values for off/auto/on
      sony-laptop: add smart connect control function

Jean Delvare (1):
      sonypi: Simplify dependencies

Mario Limonciello (2):
      Add WMI driver for controlling AlienFX features on some Alienware products
      alienware-wmi: cover some scenarios where memory allocations would fail

Matthew Garrett (1):
      toshiba_acpi: Fix whitespace

Mattia Dongili (1):
      sony-laptop: remove useless sony-laptop versioning

Scott K Logan (1):
      fujitsu-tablet: add support for Lifebook T901 and T902

Shuduo Sang (2):
      support Thinkpad X1 Carbon 2nd generation's adaptive keyboard
      save and restore adaptive keyboard mode for suspend and,resume

Stefan Seyfried (1):
      Fix sleep / suspend keys for Toughbook CF-51

Takashi Iwai (1):
      thinkpad_acpi: Fix inconsistent mute LED after resume

 drivers/char/Kconfig                    |   2 +-
 drivers/platform/x86/Kconfig            |  22 +-
 drivers/platform/x86/Makefile           |   2 +-
 drivers/platform/x86/alienware-wmi.c    | 565 ++++++++++++++++++++++++++++
 drivers/platform/x86/fujitsu-tablet.c   |  65 ++++
 drivers/platform/x86/intel_baytrail.c   | 224 -----------
 drivers/platform/x86/intel_baytrail.h   |  90 -----
 drivers/platform/x86/panasonic-laptop.c |  11 +
 drivers/platform/x86/sony-laptop.c      | 539 ++++++++++++++++++++++++---
 drivers/platform/x86/thinkpad_acpi.c    | 227 +++++++++---
 drivers/platform/x86/toshiba_acpi.c     | 635 +++++++++++++++++++++++++++++---
 11 files changed, 1901 insertions(+), 481 deletions(-)
 create mode 100644 drivers/platform/x86/alienware-wmi.c
 delete mode 100644 drivers/platform/x86/intel_baytrail.c
 delete mode 100644 drivers/platform/x86/intel_baytrail.h


-- 
Matthew Garrett | mjg59@srcf.ucam.org

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853Ab3JCELO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 00:11:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46851 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753667Ab3JCELN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 00:11:13 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [ 00/16] 3.4.65-stable review
Date: Wed,  2 Oct 2013 21:05:24 -0700
Message-Id: <20131003040445.523176877@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.4.65 release.
There are 16 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat Oct  5 04:04:34 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.65-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.4.65-rc1

Kees Cook <keescook@chromium.org>
    HID: LG: validate HID output report details

Khalid Aziz <khalid.aziz@oracle.com>
    mm: fix aio performance regression for database caused by THP

David Rientjes <rientjes@google.com>
    mm, memcg: give exiting processes access to memory reserves

Liam Girdwood <liam.r.girdwood@linux.intel.com>
    ALSA: compress: Fix compress device unregister.

Henrik Rydberg <rydberg@euromail.se>
    hwmon: (applesmc) Check key count before proceeding

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: disable tests/benchmarks if accel is disabled

Jani Nikula <jani.nikula@intel.com>
    drm/i915/dp: increase i2c-over-aux retry interval on AUX DEFER

Mikulas Patocka <mpatocka@redhat.com>
    dm-snapshot: fix performance degradation due to small hash size

Mikulas Patocka <mpatocka@redhat.com>
    dm snapshot: workaround for a false positive lockdep warning

Kurt Garloff <kurt@garloff.de>
    usb/core/devio.c: Don't reject control message to endpoint with wrong direction bit

Florian Wolter <wolly84@web.de>
    xhci: Fix race between ep halt and URB cancellation

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: Fix oops happening after address device timeout

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: Ensure a command structure points to the correct trb on the command ring

Malcolm Priestley <tvboxspy@gmail.com>
    staging: vt6656: [BUG] main_usb.c oops on device_close move flag earlier.

Josh Boyer <jwboyer@redhat.com>
    x86, efi: Don't map Boot Services on i386

Masoud Sharbiani <msharbiani@twitter.com>
    x86/reboot: Add quirk to make Dell C6100 use reboot=pci automatically


-------------

Diffstat:

 Makefile                               |  4 +--
 arch/x86/kernel/reboot.c               | 16 +++++++++
 arch/x86/platform/efi/efi.c            | 11 +++---
 drivers/gpu/drm/i915/intel_dp.c        | 13 ++++++-
 drivers/gpu/drm/radeon/radeon_device.c | 15 ++++++--
 drivers/hid/hid-lg2ff.c                | 19 ++--------
 drivers/hid/hid-lg3ff.c                | 29 ++++-----------
 drivers/hid/hid-lg4ff.c                | 20 +----------
 drivers/hid/hid-lgff.c                 | 17 ++-------
 drivers/hwmon/applesmc.c               | 11 +++++-
 drivers/md/dm-snap-persistent.c        |  2 +-
 drivers/md/dm-snap.c                   |  5 ++-
 drivers/staging/vt6656/main_usb.c      |  3 +-
 drivers/usb/core/devio.c               | 16 +++++++++
 drivers/usb/host/xhci-hub.c            |  2 +-
 drivers/usb/host/xhci-ring.c           | 24 +++++++++++--
 drivers/usb/host/xhci.c                | 25 +++----------
 drivers/usb/host/xhci.h                |  1 +
 mm/oom_kill.c                          |  8 ++---
 mm/swap.c                              | 65 ++++++++++++++++++++++++----------
 sound/core/compress_offload.c          |  3 +-
 21 files changed, 174 insertions(+), 135 deletions(-)



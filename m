Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756380Ab3FKUDQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 16:03:16 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41681 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754658Ab3FKUDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 16:03:09 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [ 00/32] 3.4.49-stable review
Date: Tue, 11 Jun 2013 13:02:59 -0700
Message-Id: <20130611200126.214442788@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.254.g5578ad7
User-Agent: quilt/0.60-5.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.4.49 release.
There are 32 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu Jun 13 19:59:36 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.49-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.4.49-rc1

Steven Rostedt <rostedt@goodmis.org>
    ftrace: Move ftrace_filter_lseek out of CONFIG_DYNAMIC_FTRACE section

Namhyung Kim <namhyung.kim@lge.com>
    tracing: Fix possible NULL pointer dereferences

Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
    drm/gma500: Increase max resolution for mode setting

Ying Xue <ying.xue@windriver.com>
    USB: ftdi_sio: Quiet sparse noise about using plain integer was NULL pointer

Jan Beulich <jbeulich@suse.com>
    xen-pciback: rate limit error messages from xen_pcibk_enable_msi{,x}()

Ben Mesman <ben@bnc.nl>
    drm/i915: no lvds quirk for hp t5740

Egbert Eich <eich@suse.de>
    drm/i915/sdvo: Use &intel_sdvo->ddc instead of intel_sdvo->i2c for DDC.

Huacai Chen <chenhc@lemote.com>
    drm: fix a use-after-free when GPU acceleration disabled

Guenter Roeck <linux@roeck-us.net>
    hwmon: (adm1021) Strengthen chip detection for ADM1021, LM84 and MAX1617

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: don't allow audio on DCE6

Adis Hamzić <adis@hamzadis.com>
    radeon: Fix system hang issue when using KMS with older cards

Gavin Shan <shangw@linux.vnet.ibm.com>
    powerpc/eeh: Don't check RTAS token to get PE addr

Ash Willis <ashwillis.kernel@gmail.com>
    ACPI / video: ignore BIOS initial backlight value for HP Pavilion g6

Alex Hung <alex.hung@canonical.com>
    ACPI / video: ignore BIOS initial backlight value for HP m4

Johan Hovold <jhovold@gmail.com>
    USB: mos7720: fix hardware flow control

Johan Hovold <jhovold@gmail.com>
    USB: mos7720: fix message timeouts

Johan Hovold <jhovold@gmail.com>
    USB: mos7720: fix DMA to stack

Alan Stern <stern@rowland.harvard.edu>
    USB: revert periodic scheduling bugfix

Johan Hovold <jhovold@gmail.com>
    USB: serial: fix Treo/Kyocera interrrupt-in urb context

Johan Hovold <jhovold@gmail.com>
    USB: whiteheat: fix broken port configuration

Robert Butora <robert.butora.fi@gmail.com>
    USB: Serial: cypress_M8: Enable FRWD Dongle hidcom device

Johan Hovold <jhovold@gmail.com>
    USB: visor: fix initialisation of Treo/Kyocera devices

Johan Hovold <jhovold@gmail.com>
    USB: ark3116: fix control-message timeout

Johan Hovold <jhovold@gmail.com>
    USB: keyspan: fix bogus array index

Johan Hovold <jhovold@gmail.com>
    USB: iuu_phoenix: fix bulk-message timeout

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio - Fix invalid volume resolution on Logitech HD webcam c270

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio - Apply Logitech QuickCam Pro 9000 quirk only to audio iface

Clemens Ladisch <clemens@ladisch.de>
    ALSA: usb-audio: fix Roland/Cakewalk UM-3G support

Vladimir Murzin <murzin.v@gmail.com>
    xhci: fix list access before init

Sergio Aguirre <sergio.a.aguirre.rodriguez@intel.com>
    xhci-mem: init list heads at the beginning of init

Tony Camuso <tcamuso@redhat.com>
    xhci - correct comp_mode_recovery_timer on return from hibernate

Bjørn Mork <bjorn@mork.no>
    USB: option: blacklist network interface on Huawei E1820


-------------

Diffstat:

 Makefile                                     |  4 +-
 arch/powerpc/platforms/pseries/eeh_pseries.c | 12 +++---
 drivers/acpi/video.c                         | 16 ++++++++
 drivers/gpu/drm/drm_irq.c                    |  6 ++-
 drivers/gpu/drm/gma500/framebuffer.c         |  4 +-
 drivers/gpu/drm/i915/intel_lvds.c            |  4 +-
 drivers/gpu/drm/i915/intel_sdvo.c            |  2 +-
 drivers/gpu/drm/radeon/atombios_encoders.c   | 11 ++++--
 drivers/gpu/drm/radeon/evergreen.c           | 10 +++--
 drivers/gpu/drm/radeon/ni.c                  | 10 +++--
 drivers/gpu/drm/radeon/r100.c                |  9 +++--
 drivers/gpu/drm/radeon/r300.c                |  9 +++--
 drivers/gpu/drm/radeon/r420.c                | 10 +++--
 drivers/gpu/drm/radeon/r520.c                |  9 +++--
 drivers/gpu/drm/radeon/r600.c                | 10 +++--
 drivers/gpu/drm/radeon/rs400.c               |  9 +++--
 drivers/gpu/drm/radeon/rs600.c               |  9 +++--
 drivers/gpu/drm/radeon/rs690.c               |  9 +++--
 drivers/gpu/drm/radeon/rv515.c               |  9 +++--
 drivers/gpu/drm/radeon/rv770.c               | 10 +++--
 drivers/gpu/drm/radeon/si.c                  | 10 +++--
 drivers/hwmon/adm1021.c                      | 58 ++++++++++++++++++++++++----
 drivers/usb/host/ehci-sched.c                |  2 +-
 drivers/usb/host/xhci-mem.c                  | 10 +++--
 drivers/usb/host/xhci.c                      | 12 +++++-
 drivers/usb/serial/ark3116.c                 |  2 +-
 drivers/usb/serial/cypress_m8.c              | 18 ++++++++-
 drivers/usb/serial/cypress_m8.h              |  4 ++
 drivers/usb/serial/ftdi_sio.c                |  2 +-
 drivers/usb/serial/iuu_phoenix.c             |  4 +-
 drivers/usb/serial/keyspan.c                 |  2 +-
 drivers/usb/serial/mos7720.c                 | 25 ++++++++----
 drivers/usb/serial/option.c                  |  2 +
 drivers/usb/serial/visor.c                   |  9 +++++
 drivers/usb/serial/whiteheat.c               |  2 +-
 drivers/xen/xen-pciback/pciback_ops.c        | 16 ++++----
 include/linux/ftrace.h                       |  3 +-
 kernel/trace/ftrace.c                        | 36 ++++++++---------
 kernel/trace/trace_stack.c                   |  2 +-
 sound/usb/mixer.c                            |  1 +
 sound/usb/quirks-table.h                     | 14 ++++++-
 41 files changed, 287 insertions(+), 119 deletions(-)



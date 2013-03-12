Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754905Ab3CLDgN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 23:36:13 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:63441 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752714Ab3CLDgL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 23:36:11 -0400
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Mon, 11 Mar 2013 20:35:48 -0700
X-Google-Sender-Auth: vg4IcZfBBh8MZyb6_37C_xfAn4M
Message-ID: <CAB=NE6UmGoVkJS5CuBL5rUBszsXVx5DVaPRKSV7cF7ugQa3rcA@mail.gmail.com>
Subject: compat-drivers v3.8.2 release
To: backports@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

compat-drivers gets a series of v3.8.2 based releases kicked out [0].
Below is the ChangeLog relevant to the backport effort, thanks to
everyone who contributed! For the full ChangeLog that includes all
kernel components updated refer to the upstream file [1]. Be sure to
use the new release page for now [2]. Interesting to note was there
are a slew of pending-stable patches not yet merged into linux-3.8.y
for the networking subsystem but nothing for DRM, we get these merged
in on the -s releases, as a short cut, instead of having to wait for
them to be merged.

[0] https://www.kernel.org/pub/linux/kernel/projects/backports/stable/v3.8.2/
[1] https://www.kernel.org/pub/linux/kernel/projects/backports/stable/v3.8.2/ChangeLog-3.8.2-2
[2] http://drvbp1.linux-foundation.org/~mcgrof/rel-html/compat-drivers/

  Luis

================================================================
ChangeLog for compat-drivers-v3.8.2-2 based on linux-3.8.2
================================================================

This is the ChangeLog for the Linux kernel project compat-drivers.
It provides a backport of a few Linux kernel subsystems down to
older kernels:

  * 802.11
  * Bluetooth
  * Ethernet
  * DRM

For more details refer to the home pages:

https://backports.wiki.kernel.org

The compat-drivers project consists of code from three projects:

  * The Linux kernel: linux-stable.git
  * Compat-wirelesS: compat-drivers.git
  * Compat: compat.git

The compat-drivers stable releases incorporates code from from
each of these git trees for the respective upstream Linux kernel
stable release. A branch called linux-3.x.y exists for each
stable release. Below we provide the ChangeLog of changes from
the previous branched release to the new branched release.

Release: linux-3.8


Updates from the compat.git project:
====================================

git shortlog linux-3.7.y..linux-3.8.y

Felix Fietkau (1):
      compat: fix compile errors when assembly is built into modules

Hauke Mehrtens (21):
      compat: update list of kernel headers
      compat: add USB_SUBCLASS_VENDOR_SPEC
      compat: make compat load without CONFIG_CPU_FREQ
      compat: add eth_zero_addr()
      compat: add kref_get_unless_zero()
      compat: move config_enabled to compat-3.4.h
      compat: fix compiler warning in nla_get_s64()
      compat: export platform_device_register_data()
      compat: fix warning of missing struct netdev_queue
      compat: add missing return value to netif_set_real_num_tx_queues
      compat: add simple_write_to_buffer
      compat: add ETHTOOL_FWVERS_LEN
      compat: fix warning in usb_autopm_get_interface_no_{resume,suspend}
      compat: do not access default_ethtool_ops
      compat: ckmake: make return code 2 is error
      compat: ckmake: remove lots of warning spam for the log
      compat: ckmake: do not start all build at the same time
      compat: add efi_enabled()
      compat: netdev_set_default_ethtool_ops() is not in kernel 3.7.5
      compat: check if efi_enabled() was already backported
      compat: deactivate netdev_set_default_ethtool_ops() for some 3.7 kernels

Johannes Berg (1):
      compat: backport unsigned netlink attribute accessors

Luis R. Rodriguez (41):
      compat: fix libc dependency on bin/get-compat-kernels
      compat: fix typo in bin/get-compat-kernels
      compat: run ckmake with num cpu threads
      compat: fix get-compat-kernels for libc issue again
      compat: change count to 4 for glibc kernel fix
      compat: add gpio header for kernels older than 2.6.24
      compat: backport ethtool_rxfh_indir_default()
      compat: backport ethtool to mii advertisment conversion helpers
      compat: backport BQL helpers
      compat: define NETIF_F_RXCSUM
      compat: fix addition of NETIF_F_RXCSUM
      compat: backport PCI MSI-X entry definitions
      compat: backport alloc_etherdev_mqs()
      compat: backport definition of PCI_MSIX_ENTRY_CTRL_MASKBIT
      compat: backport PTR_RET()
      compat: backport netif_set_real_num_tx_queues()
      compat: backport netif_set_real_num_rx_queues()
      compat: rename MDIO exported symbols
      compat: backplane mode negotiation ethtool definitions
      compat: backport napi_gro_receive()
      compat: generate CONFIG_COMPAT_KERNEL_3_8
      compat: backport hid_ignore()
      compat: backport PCI_EXP_LNKCTL_ASPM_L0S and PCI_EXP_LNKCTL_ASPM_L1
      compat: backport definition of HID_TYPE_USBNONE
      compat: add HID_QUIRK_HIDDEV_FORCE and HID_QUIRK_NO_IGNORE
      compat: add HID_QUIRK_IGNORE
      compat: backport HID_USB_DEVICE() and HID_BLUETOOTH_DEVICE()
      compat: backport struct hid_device_id
      compat: fix compilation on hid_ignore()
      compat: backport platform_device_register_data()
      compat: adjust get-compat-kernels for root usage
      compat: adjust get-compat-kernels for root users
      compat: add v3.7 to get-compat-kernels
      compat: add support for forcing get-compat-kernels
      compat: fix get-compat-kernels for rebuilding kernel headers
      compat: add 3.2 and 3.3 kernels to rebuild headers
      compat: rewrite ckmake in Python
      compat: add ionice to ckmake again
      compat: move HID_USB_DEVICE and HID_BLUETOOTH_DEVICE
      compat: backport netdev_set_default_ethtool_ops()
      compat: remove trailing erroneous semicolon from compat-3.8.c

Updates from the compat-drivers.git project:
=============================================

git shortlog linux-3.7.y..linux-3.8.y

Hauke Mehrtens (36):
      compat-drivers: make patches apply again
      compat-drivers: deactivate cfg80211 tracing for kernels <= 2.6.32
      compat-drivers: add ar5523 driver
      compat-drivers: refresh patches
      compat-drivers: remove CONFIG_ATH9K_PKTLOG form config.mk
      compat-drivers: activate CONFIG_BT_HCIUART_3WIRE in config.mk
      compat-drivers: add CONFIG_BT_WILINK in config.mk
      compat-drviers: remove CONFIG_IWM from config.mk
      compat-drivers: remove CONFIG_WIL6210 from config.mk
      compat-drivers: add CONFIG_RT2800PCI_RT3290 in config.mk
      compat-drivers: add CONFIG_MWIFIEX_USB in config.mk
      compat-drivers: rename drm config symbols
      compat-drivers: make patches apply again
      compat-drivers: remove option for alx driver
      compat-drivers: build RTL8723AE
      compat-drivers: refresh patches
      compat-drivers: add import to fix compile error
      compat-drivers: do not use struct spinlock
      compat-drivers: print original name and path of patch in refresh
      compat-drivers: remove copy of README in refresh
      compat-drivers: prevent mixing patches from different
directories in refresh
      compat-drivers: run refresh for all patches
      compat-drivers: do not apply patches in natural sort order
      compat-drivers: make patches apply again
      compat-drivers: make patches apply again
      compat-drivers: add old suspend/resume handlers only when
function is available
      compat-drivers: fix section mismatch in ath5k
      compat-drivers: add wil6210 driver
      compat-drivers: remove devinit and devexit from alx driver
      compat-drivers: deactivate loopback testing for older kernels
      compat-drivers: do not treat a warning as error
      compat-drivers: refresh patches
      compat-drivers: update genlog-3.8 for rc5
      compat-drivers: refresh patches
      compat-drivers: move disable_drm
      compat-drivers: refresh patches

Luis R. Rodriguez (63):
      compat-drivers: fix sed for gen-release.sh
      compat-drivers: add support for uploading stable releases
      compat-drivers: add / to target stable release end dir
      compat-drivers: add genlog
      compat-drivers: fix ChangeLog file name
      compat-drivers: add target path for ChangeLog file
      compat-drivers: fix admin-update.sh network
      compat-drivers: add rtl8723ae code
      compat-drivers: disable mwifiex for kernels older than 2.6.27
      compat-drivers: refresh patches for next-20121129
      compat-drivers: move all patch types under patches/
      compat-drivers: add support for unified drivers
      compat-drivers: update refresh-compat scripts
      compat-drivers: add Debian to scripts/update-initramfs
      compat-drivers: split up admin-update.sh
      compat-drivers: add disable_drm to driver-select
      compat-drivers: fix typo on 0002-enable-alx.patch
      compat-drivers: fix alx backport on netdev features
      compat-drivers: fix typo which removed entries on Makefile
      compat-drivers: fix 11-dev-pm-ops.patch
      compat-drivers: add the MDIO module
      compat-drivers: fix alx suspend/resume calls for old kernels
      compat-drivers: modify release script to support unified drivers
      compat-drivers: remove ksize() ifdef on scan.c
      compat-drivers: remove __devexit_p() from 11-dev-pm-ops.patch
      compat-drivers: fix 45-remove-platform-id-table.patch
      compat-drivers: fix 62-usb_driver_lpm.patch
      compat-drivers: remove 67-use_spinlock_t.patch
      compat-drivers: ship include/linux/bcm47xx_wdt.h
      compat-drivers: refresh patches for next-20121211
      compat-drivers: refresh patches for next-20121214
      compat-drivers: refresh -u patches
      compat-drivers: allow git-paranoia to work on current directory
      compat-drivers: refresh patches for next-20121218
      compat-drivers: fix alx backport patch
      compat-drivers: update 0001-backport-alx.patch context
      compat-drivers: refresh patch 0001-backport-alx.patch
      compat-drivers: refresh 0001-backport-alx.patch
      compat-drivers: add __devexit_p() for bmca driver
      compat-drivers: add genlog-3.8
      compat-drivers: update genlog-3.8
      compat-drivers: trim 'v' prefix from ChangeLog file
      compat-drivers: remove 'v' prefix from version on ChangeLog
      compat-drivers: fix 11-dev-pm-ops.patch
      compat-drivers: refresh patches for v3.8-rc3
      compat-drivers: refresh patches for v3.8-rc4
      compat-drivers: update genlog-3.8 for rc4
      compat-drivers: disable DRM drivers for 802.11 drivers
      compat-drivers: do not call make clean for unified drivers
      compat-drivers: fix driver-select for atheros drivers
      compat-drivers: refresh patches for v3.8.2
      compat-drivers: fix processing pending-stable patches
      compat-drivers: fix removal of tmp pending-stable files
      compat-drivers: fix copying of pending-stable patches
      compat-drivers: skip already appplied patches
      compat-drivers: skip pending stable mac80211 patch
      compat-drivers: backport rt2x00 pending-stable fix
      compat-drivers: skip DRM udl stable fix
      compat-drivers: skip another DRM udl stable fix
      compat-drivers: ignore drm i915 brightness quirk stable fix
      compat-drivers: add pending-stable patches
      compat-drivers: update genlog for 3.8
      compat-drivers: fix commend for genlog

Ozan Çağlayan (16):
      compat-drivers: Separate code metrics for each subsystem
      compat-drivers: Enable CONFIG_DRM_LOAD_EDID_FIRMWARE
      compat-drivers: Copy core/ subdir of nouveau driver
      compat-drivers: Handle int's when generating compat_autoconf.h
      compat-drivers: Rename CONFIG_* vars in nouveau driver
      compat-drivers: Add missing config check
      compat-drivers: Rename CONFIG_DRM_NOUVEAU_BACKLIGHT
      compat-drivers: Fix comments
      compat-drivers: Enable nouveau DRM driver for kernels >= 3.3
      compat-drivers: Update README
      compat-drivers: Rename CONFIG_DRM_RADEON_KMS
      compat-drivers: drm: Revert ACPI table size check for < 3.6
      compat-drivers: Enable ATI/AMD Radeon for kernels >= 3.2
      update-initramfs: Update comments, fix some typos
      update-initramfs: Silence lsb_release output
      update-initramfs: Add support for Fedora

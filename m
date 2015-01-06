Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754461AbbAFBqS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 20:46:18 -0500
Received: from mail-qg0-f52.google.com ([209.85.192.52]:51128 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753526AbbAFBqQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 20:46:16 -0500
MIME-Version: 1.0
Date: Mon, 5 Jan 2015 17:46:15 -0800
X-Google-Sender-Auth: bzpQu7g-RQ3eMiO9wVZVfQts_Cc
Message-ID: <CA+55aFwsxoyLb9OWMSCL3doe_cz_EQtKsEFCyPUYn_T87pbz0A@mail.gmail.com>
Subject: Linux 3.19-rc3
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's a day delayed - not because of any particular development issues,
but simply because I was tiling a bathroom yesterday. But rc3 is out
there now, and things have stayed reasonably calm. I really hope that
implies that 3.19 is looking good, but it's equally likely that it's
just that people are still recovering from the holiday season.

A bit over three quarters of the changes here are drivers - mostly
networking, thermal, input layer, sound, power management. The rest is
misc - filesystems, core networking, some arch fixes, etc. But all of
it is pretty small.

So go out and test,

                       Linus

---

Aaron Lu (1):
      ACPI / video: Add some Samsung models to disable_native_backlight list

Abhilash Kesavan (1):
      drivers: thermal: Remove ARCH_HAS_BANDGAP dependency for samsung

Al Viro (3):
      Bluetooth: hidp_connection_add() unsafe use of l2cap_pi()
      Bluetooth: cmtp: cmtp_add_connection() should verify that it's
dealing with l2cap socket
      Bluetooth: bnep: bnep_add_connection() should verify that it's
dealing with l2cap socket

Alan Stern (1):
      SCSI: fix regression in scsi_send_eh_cmnd()

Alexandre Belloni (1):
      mmc: core: stop trying to switch width when only one bit is supported

Amir Vadai (1):
      net/mlx4_en: Doorbell is byteswapped in Little Endian archs

Amit Daniel Kachhap (1):
      PM / Domains: Export of_genpd_get_from_provider function

Andrew Bresticker (2):
      spi: img-spfi: Enable controller before starting TX DMA
      spi: img-spfi: Increase DMA burst size

Andrew Jackson (2):
      ASoC: dwc: Ensure FIFOs are flushed to prevent channel swap
      ASoC: dwc: Iterate over all channels

Anil Chintalapati (achintal) (1):
      fnic: IOMMU Fault occurs when IO and abort IO is out of order

Aniroop Mathur (1):
      Input: evdev - add CLOCK_BOOTTIME support

Anshul Garg (1):
      Input: optimize events_per_packet count calculation

Antonio Quartulli (1):
      batman-adv: avoid NULL dereferences and fix if check

Appana Durga Kedareswara Rao (1):
      net: xilinx: Remove unnecessary temac_property in the driver

Asaf Vertz (1):
      Input: edt-ft5x06 - fixed a macro coding style issue

Catalin Marinas (1):
      clocksource: arch_timer: Only use the virtual counter (CNTVCT) on arm64

Dan Carpenter (2):
      thermal: cpu_cooling: small memory leak on error
      OMAPDSS: pll: NULL dereference in error handling

Dan Collins (1):
      packet: Fixed TPACKET V3 to signal poll when block is closed
rather than every packet

Daniel Borkmann (1):
      x86, um: actually mark system call tables readonly

Daniel Glöckner (1):
      net: s6gmac: remove driver

David S. Miller (1):
      genetlink: A genl_bind() to an out-of-range multicast group
should not WARN().

Dmitry Torokhov (6):
      Input: gpio_keys - allow separating gpio and irq in device tree
      Input: gpio_keys - replace timer and workqueue with delayed workqueue
      PM / OPP: add some lockdep annotations
      PM / OPP: fix warning in of_free_opp_table()
      PM / OPP: take RCU lock in dev_pm_opp_get_opp_count
      cpufreq-dt: defer probing if OPP table is not ready

Eduardo Valentin (3):
      thermal: cpu_cooling: check for the readiness of cpufreq layer
      thermal: db8500: Do not print error message in the EPROBE_DEFER case
      thermal: ti-soc-thermal: Do not print error message in the
EPROBE_DEFER case

Eliad Peller (1):
      iwlwifi: mvm: clear IN_HW_RESTART flag on stop()

Emmanuel Grumbach (3):
      iwlwifi: pcie: re-ACK all interrupts after device reset
      iwlwifi: don't double free a pointer if no FW was found
      iwlwifi: add new device IDs for 3165

Ethan Zhao (1):
      cpufreq: fix a NULL pointer dereference in __cpufreq_governor()

Fabio Estevam (1):
      thermal: imx: Do not print error message in the EPROBE_DEFER case

Fang, Yang A (1):
      ASoC: rt5677: fixed rt5677_dsp_vad_put rt5677_dsp_vad_get panic

Geert Uytterhoeven (1):
      selftests/exec: Use %zu to format size_t

Govindarajulu Varadarajan (1):
      enic: fix rx skb checksum

Gregory CLEMENT (1):
      ARM: mvebu: Fix pinctrl configuration for Armada 370 DB

Haiyang Zhang (1):
      hyperv: Fix some variable name typos in send-buffer init/revoke

Hans de Goede (4):
      Input: alps - v7: ignore new packets
      Input: alps - v7: sometimes a single touch is reported in mt[1]
      Input: alps - v7: fix finger counting for > 2 fingers on clickpads
      Input: alps - v7: document the v7 touchpad packet protocol

Hari Bathini (1):
      powerpc/kdump: Ignore failure in enabling big endian exception
during crash

Hariprasad Shenai (1):
      cxgb4vf: Fix ethtool get_settings for VF driver

Herbert Xu (6):
      virtio_net: Fix napi poll list corruption
      caif: Fix napi poll list corruption
      net: Move napi polling code out of net_rx_action
      net: Detect drivers that reschedule NAPI and exhaust budget
      net: Always poll at least one device in net_rx_action
      net: Rearrange loop in net_rx_action

Hisashi Nakamura (1):
      spi: sh-msiof: Add runtime PM lock in initializing

Huacai Chen (1):
      stmmac: Don't init ptp again when resume from suspend/hibernation

Ilkka Koskinen (1):
      Thermal/int340x: Handle properly the case when _trt or _art acpi
entry is missing

Jacob Pan (2):
      powercap / RAPL: add IDs for future Xeon CPUs
      thermal/powerclamp: add ids for future xeon cpus

Jan Kara (6):
      isofs: Fix unchecked printing of ER records
      udf: Verify i_size when loading inode
      udf: Verify symlink size before loading it
      udf: Check path length when reading symlink
      udf: Check component length before reading it
      udf: Reduce repeated dereferences

Jarkko Nikula (3):
      ASoC: Intel: Add I2C dependency to two new machines
      ASoC: Intel: Fix BYTCR firmware name
      ASoC: Intel: Fix BYTCR machine driver MODULE_ALIAS

Jason Wang (1):
      net: drop the packet when fails to do software segmentation or
header check

Javi Merino (2):
      thermal: cpu_cooling: return ERR_PTR() for !CPU_THERMAL or !THERMAL_OF
      thermal: cpu_cooling: document node in struct cpufreq_cooling_device

Jay Vosburgh (1):
      net/core: Handle csum for CHECKSUM_COMPLETE VXLAN forwarding

Jesse Gross (1):
      net: Generalize ndo_gso_check to ndo_features_check

Jia-Ju Bai (3):
      8139too: Fix the lack of pci_disable_device
      8139too: Add netif_napi_del in the driver
      ne2k-pci: Add pci_disable_device in error handling

Jianqun Xu (2):
      ASoC: rockchip: i2s: fix error defination of transmit data level
      ASoC: rockchip: i2s: fix maxburst of dma data to 4

Jie Yang (1):
      ASoC: Intel: correct the fixed free block allocation

Jiri Kosina (1):
      Revert "cfg80211: make WEXT compatibility unselectable"

Johan Hedberg (1):
      Bluetooth: Fix accepting connections when not using mgmt

Johan Hovold (1):
      net: phy: micrel: use generic config_init for KSZ8021/KSZ8031

Johannes Berg (6):
      netlink: rename netlink_unbind() to netlink_undo_bind()
      genetlink: pass only network namespace to genl_has_listeners()
      netlink: update listeners directly when removing socket
      netlink: call unbind when releasing socket
      genetlink: pass multicast bind/unbind to families
      netlink/genetlink: pass network namespace to bind/unbind

Jukka Rissanen (1):
      Bluetooth: 6lowpan: Do not free skb when packet is dropped

Kevin Cernekee (1):
      Fix signed/unsigned pointer warning

Krzysztof Kozlowski (1):
      regulator: s2mps11: Fix dw_mmc failure on Gear 2

Lars-Peter Clausen (1):
      ALSA: pcm: Fix kerneldoc for params_*() functions

Len Brown (3):
      cpuidle: menu: Better idle duration measurement without using
CPUIDLE_FLAG_TIME_INVALID
      cpuidle: ladder: Better idle duration measurement without using
CPUIDLE_FLAG_TIME_INVALID
      cpuidle / ACPI: remove unused CPUIDLE_FLAG_TIME_INVALID

Li RongQing (1):
      sunvnet: fix a memory leak in vnet_handle_offloads

Liad Kaufman (1):
      iwlwifi: pcie: limit fw chunk sizes given to fh

Linus Torvalds (2):
      Revert "Input: atmel_mxt_ts - use deep sleep mode when stopped"
      Linux 3.19-rc3

Linus Walleij (3):
      mfd: stmpe: add pull up/down register offsets for STMPE
      Input: stmpe - enforce device tree only mode
      Input: stmpe - bias keypad columns properly

Lukasz Majewski (1):
      thermal:core:fix: Check return code of the ->get_max_state() callback

Marcel Holtmann (1):
      Bluetooth: Fix controller configuration with HCI_QUIRK_INVALID_BDADDR

Mark Brown (1):
      ASoC: dapm: Remove snd_soc_of_parse_audio_routing() due to deferred probe

Martin K. Petersen (1):
      sd: tweak discard heuristics to work around QEMU SCSI issue

Michael Ellerman (1):
      Revert "powerpc: Secondary CPUs must set cpu_callin_map after
setting active and online"

Michael S. Tsirkin (2):
      virtio_ring: document alignment requirements
      vhost: relax used address alignment

Michal Hocko (1):
      mm: get rid of radix tree gfp mask for pagecache_get_page

Michal Privoznik (1):
      tools / cpupower: Correctly detect if running as root

Mika Westerberg (1):
      brcmfmac: Do not crash if platform data is not populated

Nakajima Akira (1):
      cifs: make new inode cache when file type is different

Nicholas Mc Guire (2):
      net: incorrect use of init_completion fixup
      Input: hil_kbd - fix incorrect use of init_completion

Nicolas Dichtel (2):
      tcp6: don't move IP6CB before xfrm6_policy_check()
      neigh: remove next ptr from struct neigh_table

Paul Bolle (1):
      ipw2200: select CFG80211_WEXT

Paul Moore (1):
      audit: create private file name copies when auditing inodes

Pavel Machek (1):
      Revert "ARM: 7830/1: delay: don't bother reporting bogomips in
/proc/cpuinfo"

Pranith Kumar (1):
      powerpc: Wire up sys_execveat() syscall

Prarit Bhargava (1):
      tools / cpupower: Fix no idle state information return value

Prashant Sreedharan (1):
      tg3: tg3_disable_ints using uninitialized mailbox value to
disable interrupts

Pravin B Shelar (6):
      mpls: Fix config check for mpls.
      mpls: Fix allowed protocols for mpls gso
      openvswitch: Fix MPLS action validation.
      openvswitch: Fix GSO with multiple MPLS label.
      openvswitch: Fix vport_send double free
      vxlan: Fix double free of skb.

Punit Agrawal (1):
      thermal: Fix cdev registration with THERMAL_NO_LIMIT on 64bit

Rabin Vincent (1):
      crypto: af_alg - fix backlog handling

Richard Weinberger (1):
      um: Skip futex_atomic_cmpxchg_inatomic() test

Rickard Strandqvist (1):
      net: ethernet: micrel: ksz884x.c: Remove unused function

Sachin Prabhu (1):
      Convert MessageID in smb2_hdr to LE

Srinivas Pandruvada (4):
      thermal: int340x: Introduce processor reporting device
      Thermal/int340x/int3403: Fix memory leak
      Thermal/int340x/processor_thermal: Fix memory leak
      Thermal/int340x/int3403: Free acpi notification handler

Steev Klimaszewski (1):
      Add USB_EHCI_EXYNOS to multi_v7_defconfig

Sven Eckelmann (2):
      batman-adv: Calculate extra tail size based on queued fragments
      batman-adv: Unify fragment size calculation

Thomas Graf (1):
      net: Reset secmark when scrubbing packet

Tobias Klauser (1):
      nios2: Use preempt_schedule_irq

Tomi Valkeinen (4):
      OMAPDSS: HDMI: remove double initializer entries
      video/logo: prevent use of logos after they have been freed
      video/fbdev: fix defio's fsync
      OMAPDSS: SDI: fix output port_num

Tony Luck (1):
      [IA64] Enable execveat syscall for ia64

Toshiaki Makita (1):
      net: Fix stacked vlan offload features computation

Viresh Kumar (25):
      thermal: db8500: pass cpu_present_mask to cpufreq_cooling_register()
      thermal: imx: pass cpu_present_mask to cpufreq_cooling_register()
      thermal: exynos: pass cpu_present_mask to cpufreq_cooling_register()
      thermal: cpu_cooling: random comment fixups
      thermal: cpu_cooling: fix doc comment over struct cpufreq_cooling_device
      thermal: cpu_cooling: Add comment to clarify relation between
cooling state and frequency
      thermal: cpu_cooling: Pass variable instead of its type to sizeof()
      thermal: cpu_cooling: no need to set cpufreq_state to zero
      thermal: cpu_cooling: no need to set cpufreq_dev to NULL
      thermal: cpu_cooling: no need to initialze 'ret'
      thermal: cpu_cooling: propagate error returned by idr_alloc()
      thermal: cpu_cooling: Don't match min/max frequencies for all
CPUs on cooling register
      thermal: cpu_cooling: don't iterate over all allowed_cpus to
update cpufreq policy
      thermal: cpu_cooling: Don't check is_cpufreq_valid()
      thermal: cpu_cooling: do error handling at the bottom in
__cpufreq_cooling_register()
      thermal: cpu_cooling: initialize 'cpufreq_val' on registration
      thermal: cpu_cooling: Merge cpufreq_apply_cooling() into
cpufreq_set_cur_state()
      thermal: cpu_cooling: remove unnecessary wrapper get_cpu_frequency()
      thermal: cpu_cooling: find max level during device registration
      thermal: cpu_cooling: get_property() doesn't need to support
GET_MAXL anymore
      thermal: cpu_cooling: use cpufreq_dev_list instead of cpufreq_dev_count
      thermal: cpu_cooling: Pass 'cpufreq_dev' to get_property()
      thermal: cpu_cooling: Store frequencies in descending order
      thermal: cpu_cooling: Use cpufreq_dev->freq_table for finding level/freq
      thermal: cpu_cooling: update copyright tags

Walter Goossens (1):
      nios2: Initialize cpuinfo.mmu

Wengang Wang (1):
      bonding: change error message to debug message in __bond_release_one()

Wolfram Sang (3):
      thermal: drop owner assignment from platform_drivers
      thermal: int340x_thermal: drop owner assignment from platform_drivers
      net: ethernet: stmicro: stmmac: drop owner assignment from
platform_drivers

Wu Fengguang (1):
      openvswitch: fix odd_ptr_err.cocci warnings

haarp (1):
      Input: psmouse - expose drift duration for IBM trackpoints

stephen hemminger (1):
      in6: fix conflict with glibc

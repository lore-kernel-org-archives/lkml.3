Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754978Ab3ARDwO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 22:52:14 -0500
Received: from mail-vc0-f170.google.com ([209.85.220.170]:57486 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754310Ab3ARDwL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 22:52:11 -0500
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 17 Jan 2013 19:51:50 -0800
X-Google-Sender-Auth: Wi-ZHyZUL_koschaKXIs1iyvZOY
Message-ID: <CA+55aFx5ZyFtd59ygn6ja5X-3ZyRvhfJLqtNKyF_mH3+-kSjKg@mail.gmail.com>
Subject: Linux 3.8-rc4
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, it's been another week already! In fact, it took me so much by
surprise that it's been an extra day. The whole "release in the middle
of the week" thing feels odd to me.

[ That actually got me to wonder what the most common day was, and
statistically I definitely do most releases on Sunday. The "git tip of
the week" looks like this:

    git log --no-walk --pretty="%ad" $(git tag -l)

  which can then be piped into

    cut -d' ' -f1 | sort | uniq -c | sort -n

  to see the full git tagging statistics ]

Anyway, with that digression, I can happily report that -rc4 is
smaller than -rc3 despite the extra day, although not by much. There's
not really a whole lot that stands out: apart from one new wireless
driver (the Atheros Wilocity driver) and some OMAP drm changes, the
diffstat looks pretty flat and spread out. Which just means lots of
small changes all over.

The ShortLog is appended, but it's basically 85% drivers, with over
half the patch being to the aforementioned new wireless one and the
OMAP drm changes. There's some other stuff there too, but it's largely
in the noise - small ARM and s390 updates (and a smattering of SuperH
and x86), a few tiny filesystem fixes, things like that.

Go forth and test. My gut feel is that things really are calming down.
And I'd hate to be proven wrong.

            Linus

---

Afzal Mohammed (1):
      usb: musb: dsps: header movement build error fix

Alan Stern (1):
      USB: usbtest: fix test number in log message

Aleksi Torhamo (2):
      drm/nouveau/clock: fix support for more than 2 monitors on nve0
      drm/nvc0/fb: fix crash when different mutex is used to protect same list

Alexander Holler (1):
      iio: hid-sensors: respect CONFIG_IIO_TRIGGER

Alexey Khoroshilov (1):
      mei: fix mismatch in mutex unlock-lock in mei_amthif_read()

Amerigo Wang (1):
      qlge: remove NETIF_F_TSO6 flag

Amitkumar Karwar (1):
      mwifiex: fix typo in setting up ibss network parameters

Anatolij Gustschin (3):
      USB: fix fsl_otg config dependency
      USB: fsl-mph-dr-of: fix regression on mpc5121e
      USB: ehci-fsl: fix regression on mpc5121e

Andre Schramm (1):
      ALSA: hdspm - Fix wordclock status on AES32

Andreas Fleig (1):
      USB: Add device quirk for Microsoft VX700 webcam

Andreas Schwab (1):
      KVM: PPC: Book3S HV: Fix compilation without CONFIG_PPC_POWERNV

Andrew Morton (3):
      drivers/rtc/rtc-da9055.c: fix cross-section reference
      arch/mn10300/Kconfig: select CONFIG_GENERIC_ATOMIC64
      kernel/audit.c: avoid negative sleep durations

Axel Lin (17):
      ASoC: sta529: Fix update register bits in sta529_set_dai_fmt
      ASoC: wm2200: Fix setting dai format in wm2200_set_fmt
      ASoC: lm49453: Fix mask for setting mode bit in lm49453_set_dai_fmt()
      ASoC: arizona: Do proper shift for setting AIF rate
      ASoC: cs42l52: Catch no-match case in cs42l52_get_clk
      regulator: core: Fix continuous_voltage_range case in
regulator_can_change_voltage
      iio: adc: ad7266: Don't set error code to st->vref_uv
      iio: dac: ad5380: Don't set error code to st->vref
      iio: dac: ad5791: Don't set error code to [pos|neg]_voltage_uv
      iio: dac: ad5504: Don't set error code to voltage_uv
      iio: dac: ad5624r_spi: Don't set error code to voltage_uv
      iio: dac: ad5686: Don't set error code to voltage_uv
      iio: dac: ad5446: Don't set error code to voltage_uv
      regulator: core: Fix comment for regulator_register()
      regulator: max8997: Use uV in voltage_map_desc
      regulator: max8998: Use uV in voltage_map_desc
      regulator: max8998: Ensure enough delay time for
max8998_set_voltage_buck_time_sel

Barak Witkowski (1):
      bnx2x: Allow management traffic after boot from SAN

Ben Hutchings (1):
      asus-laptop: Do not call HWRS on init

Ben Skeggs (2):
      drm/nouveau/devinit: ensure legacy vga control is enabled during post
      drm/nouveau: do not forcibly power on lvds panels

Bharat Bhushan (1):
      powerpc: Corrected include header path in kvm_para.h

Bing Zhao (1):
      mwifiex: check wait_event_interruptible return value

Bjørn Mork (2):
      USB: option: blacklist network interface on ZTE MF880
      USB: option: add Telekom Speedstick LTE II

Bo Shen (2):
      ARM: at91/dts: add pinctrl support for SSC peripheral
      ASoC: atmel-ssc: add pinctrl selection to driver

Brian Foster (1):
      xfs: remove int casts from debug dquot soft limit timer asserts

Chaitanya (1):
      mac80211: fix maximum MTU

Chao Xie (3):
      usb: gadget: mv_udc: fix the clk APIs
      usb: host: ehci-mv: fix clk APIs
      usb: otg: mv_otg: fix the clk APIs

Chen Gang (2):
      drivers/net/wireless/iwlegacy: use strlcpy instead of strncpy
      MAINTAINERS: Omar had moved

Chris Wilson (6):
      drm/i915; Only increment the user-pin-count after successfully
pinning the bo
      drm/i915: Treat crtc->mode.clock == 0 as disabled
      drm: Only evict the blocks required to create the requested hole
      drm/i915: The sprite scaler on Ironlake also support YUV planes
      drm/i915: Add DEBUG messages to all
intel_create_user_framebuffer error paths
      drm/i915: Use pixel size for computing linear offsets into a sprite

Christian Borntraeger (1):
      s390/kvm: Fix BUG in include/linux/kvm_host.h:745

Chuansheng Liu (3):
      ASoC: core: fix the memory leak in case of device_add() failure
      ASoC: core: fix the memory leak in case of remove_aux_dev()
      mfd, TWL4030: TWL4030 need select REGMAP_I2C

Cong Wang (1):
      net: prevent setting ttl=0 via IP_TTL

Dan Carpenter (1):
      bnx2x: move debugging code before the return

Daniel Lezcano (1):
      cpuidle: remove the power_specified field in the driver

Daniel Mack (2):
      ASoC: cs4271: fix sparse warning
      ASoC: cs4271: fix property check

Daniel Vetter (2):
      Revert "drm/i915: no lvds quirk for Zotac ZDBOX SD ID12/ID13"
      drm/i915: Revert shrinker changes from "Track unbound pages"

Dave Reisner (1):
      debugfs: convert gid= argument from decimal, not octal

David Decotigny (1):
      lib: cpu_rmap: avoid flushing all workqueues

David Henningsson (2):
      Revert "ALSA: hda - Shut up pins at power-saving mode with
Conexnat codecs"
      ALSA: usb - fix race in creation of M-Audio Fast track pro driver

David S. Miller (1):
      sparc: Hook up finit_module syscall.

Denis N Ladin (1):
      USB: cdc-acm: Add support for "PSC Scanning, Magellan 800i"

Dzianis Kahanovich (1):
      USB: option: add Nexpring NP10T terminal id

Eldad Zack (3):
      ALSA: usb-audio: correct M-Audio C400 clock source quirk
      ALSA: usb-audio: M-Audio FT C400 skip packet quirk
      ALSA: usb-audio: selector map for M-Audio FT C400

Emil Goode (1):
      Staging: wlan-ng: Add missing argument

Emmanuel Grumbach (1):
      iwlwifi: fix the reclaimed packet tracking upon flush queue

Enric Balletbo i Serra (1):
      staging: tidspbridge: Fix build breakage due to splitting CM functions.

Eric Dumazet (3):
      tcp: splice: fix an infinite loop in tcp_read_sock()
      tcp: fix splice() and tcp collapsing interaction
      tcp: accept RST without ACK flag

Éric Piel (1):
      staging: comedi: fix minimum AO period for NI 625x and NI 628x

Eric Sandeen (2):
      jbd: don't wake kjournald unnecessarily
      xfs: recalculate leaf entry pointer after compacting a dir2 block

Fabio Estevam (4):
      ASoC: soc-core: Remove unused 'ret' variable
      ASoC: sgtl5000: Fix maximum value for microphone gain
      usb: imx21-hcd: Include missing linux/module.h
      usb: chipidea: Allow disabling streaming not only in udc mode

Felipe Balbi (1):
      usb: host: ohci-tmio: fix compile warning

Felix Fietkau (1):
      mac80211: flush AP_VLAN stations when tearing down the BSS AP

Gerald Schaefer (1):
      s390/mm: fix pmd_pfn() for thp

Greg Kroah-Hartman (1):
      Remove __dev* markings from init.h

Guenter Roeck (2):
      iio: (max1363) Fix probe error path
      hwmon: (vexpress) Fix build error seen if CONFIG_OF_DEVICE is not set

H. Peter Anvin (2):
      x86/Sandy Bridge: mark arrays in __init functions as __initconst
      x86/Sandy Bridge: Sandy Bridge workaround depends on CONFIG_PCI

Haipeng YU (1):
      usb: gadget: u_serial: fix switch off blocked

Hannes Reinecke (3):
      target: use correct sense code for LUN communication failure
      target: Introduce TCM_NO_SENSE
      target: Use TCM_NO_SENSE for initialisation

Hans de Goede (3):
      udldrmfb: Fix EDID not working with monitors with EDID extension blocks
      udldrmfb: udl_get_edid: usb_control_msg buffer must not be on the stack
      udldrmfb: udl_get_edid: drop unneeded i--

Heiko Carstens (12):
      s390/smp: fix section mismatch for smp_add_present_cpu()
      s390/pci: remove dead code
      s390/syscalls: wire up finit_module syscall
      s390/irq: enable irq sum accounting for /proc/stat again
      s390/irq: remove split irq fields from /proc/stat
      s390/irq: count cpu restart events
      s390/3215: partially revert tty close handling fix
      s390/pci: define isa_dma_bridge_buggy
      s390/pm: export pm_power_off
      s390/topology: export cpu_topology
      s390/pci: define read*_relaxed functions
      s390/time: fix sched_clock() overflow

Ian Abbott (3):
      staging: comedi: prevent auto-unconfig of manually configured devices
      staging: comedi: Kconfig: COMEDI_NI_AT_A2150 should select COMEDI_FC
      staging: comedi: comedi_test: fix race when cancelling command

Ilija Hadzic (3):
      drm/radeon: fix NULL pointer dereference in UMS mode
      drm/radeon: fix a bogus kfree
      drm/radeon: fix error path in kpage allocation

Inderpal Singh (1):
      regulator: s5m8767: Fix probe failure due to stack corruption

Jack Pham (1):
      usb: dwc3: debugfs: fix regdump offset

Jan Beulich (1):
      USB: ehci: make debug port in-use detection functional again

Jason Liu (1):
      mm: compaction: fix echo 1 > compact_memory return error issue

Jason Wang (3):
      tuntap: switch to use rtnl_dereference()
      tuntap: forbid calling TUNSETIFF when detached
      tuntap: fix leaking reference count

Jean-Christophe PLAGNIOL-VILLARD (1):
      iio: at91: fix dev var name in at91_adc_trigger_handler

Jerome Glisse (2):
      radeon/kms: force rn50 chip to always report connected on analog output
      radeon/kms: fix dma relocation checking

Jesse Barnes (1):
      x86/Sandy Bridge: reserve pages when integrated graphics is present

Jiri Kosina (3):
      lockdep, rwsem: provide down_write_nest_lock()
      mm: mmap: annotate vm_lock_anon_vma locking properly for lockdep
      lockdep, rwsem: fix down_write_nest_lock() if !CONFIG_DEBUG_LOCK_ALLOC

Johannes Berg (5):
      mac80211: assign VLAN channel contexts
      mac80211: fix station destruction in AP/mesh modes
      mac80211: use del_timer_sync for final sta cleanup timer deletion
      mac80211: fix dtim_period in hidden SSID AP association
      iwlwifi: fix PCIe interrupt handle return value

Julian Wollrath (1):
      rtlwifi: Fix typo in debug output of rtl8192c and rtl8723ae

Kailang Yang (1):
      ALSA: hda - Add support of new codec ALC284

Kees Cook (2):
      audit: create explicit AUDIT_SECCOMP event type
      audit: catch possible NULL audit buffers

Kirill Smelkov (1):
      Tell the world we gave up on pushing CC_OPTIMIZE_FOR_SIZE

Konstantin Khlebnikov (1):
      staging: vme_pio2: fix oops on module unloading

Krzysztof Mazur (1):
      cpuidle: fix number of initialized/destroyed states

Kuninori Morimoto (6):
      usb: renesas_usbhs: gadget: remove usbhsg_uep_init()
      usb: renesas_usbhs: gadget: usbhsg_ep_disable() care pipe settings
      usb: renesas_usbhs: mod_host: fixup usbhsh_ureq_free() timing
      sh: define TASK_UNMAPPED_BASE as a page aligned constant
      sh: clkfwk: bugfix: sh_clk_div_enable() care sh_clk_div_set_rate() if div6
      sh: ecovec: add sample amixer settings

Larry Finger (4):
      staging: r8712u: Add new device ID
      b43: Fix firmware loading when driver is built into the kernel
      staging: rtl8187se: Fix failure to check pci_map_single()
      staging: rtl8192e: Fix failure to check pci_map_single()

Lars-Peter Clausen (2):
      staging:iio:adis16260: Select adislib
      bfin_mac: Restore hardware time-stamping dependency on BF518

Laura Abbott (1):
      mm: use aligned zone start for pfn_to_bitidx calculation

Lee, Chun-Yi (3):
      MAINTAINERS: change the mail address of acer-wmi/msi-laptop maintainer
      acer-wmi: fix obj is NULL but dereferenced
      acer-wmi: change to emit touchpad on off key

Li Zhong (1):
      Add rcu user eqs exception hooks for async page fault

Lin Feng (1):
      mm: memblock: fix wrong memmove size in memblock_merge_regions()

Linus Torvalds (2):
      vfs: add missing virtual cache flush after editing partial pages
      Linux 3.8-rc4

Liu Bo (1):
      tracing: Fix regression of trace_pipe

Lothar Waßmann (3):
      staging: drm/imx: check return value of ipu_reset()
      staging: drm/imx: several bug fixes
      staging: drm/imx: fix double free bug in error path

Luciano Coelho (1):
      firmware: make sure the fw file size is not 0

MR.Swami.Reddy@ti.com (2):
      ASoC: lm49453: Fix adc, mic and sidetone volume ranges
      ASoC: lm49453: Update lm49453_reg_defs values as per LM49453 HW revision-B

Marcelo Tosatti (1):
      KVM: x86: use dynamic percpu allocations for shared msrs area

Marcin Slusarz (7):
      drm/nouveau: add locking around instobj list operations
      drm/nouveau/vm: fix memory corruption when pgt allocation fails
      drm/nouveau: don't return freed object from nouveau_handle_create
      drm/nouveau: fix nouveau_client allocation failure path
      drm/nouveau: fix blank LVDS screen regression on pre-nv50 cards
      drm/nv17-50: restore fence buffer on resume
      drm/nv50/disp: fix selection of bios script for analog outputs

Mark Brown (13):
      ASoC: core: Fix SOC_DOUBLE_RANGE() macros
      ASoC: arizona: Correct FLL source definitions
      ASoC: wm5102: Improve speaker enable performance
      ASoC: wm2200: Remove DSP B and left justified AIF modes
      ASoC: arizona: Remove DSP B and left justified AIF modes
      ASoC: wm5100: Remove DSP B and left justified formats
      ASoC: wm2000: Fix sense of speech clarity enable
      ASoC: wm_adsp: Ensure that block writes are from DMA aligned addresses
      regmap: debugfs: Fix attempts to read nonexistant register blocks
      regmap: debugfs: Fix check for block start in cached seeks
      regmap: debugfs: Discard the cache if we fail to allocate an entry
      regmap: debugfs: Ensure a correct return value for empty caches
      regmap: debugfs: Make sure we store the last entry in the offset cache

Mark Rustad (2):
      tcm_fc: Do not indicate retry capability to initiators
      tcm_fc: Do not report target role when target is not defined

Mark Tinguely (4):
      xfs: use b_maps[] for discontiguous buffers
      xfs: rename bli_format to avoid confusion with bli_formats
      xfs: fix segment in xfs_buf_item_format_segment
      xfs: fix the multi-segment log buffer format

Martin Schwidefsky (1):
      s390: use -fPIC for module compile

Matthew Garrett (2):
      Update MAINTAINERS entry
      asus-laptop: Fix potential invalid pointer dereference

Mattia Dongili (1):
      sony-laptop: fix SNC buffer calls when SN06 returns Integers

Max Filippov (1):
      mm: bootmem: fix free_all_bootmem_core() with odd bitmap alignment

Maxime Ripard (2):
      drivers/video/ssd1307fb.c: fix bit order bug in the byte
translation function
      USB: select USB_ARCH_HAS_EHCI for MXS

Mel Gorman (4):
      mm: compaction: Partially revert capture of suitable high-order page
      mm: migrate: check page_count of THP before migrating
      mm: thp: acquire the anon_vma rwsem for write during split
      mm: compaction: partially revert capture of suitable high-order page

Michael Hennerich (1):
      iio:adf4350: Fix typo

Michael Holzheu (1):
      s390/debug: Fix s390dbf lockdep problem in debug_(un)register_view()

Michael S. Tsirkin (1):
      tun: avoid owner checks on IFF_ATTACH_QUEUE

Michal Simek (2):
      net: ethernet: xilinx: Do not use axienet on PPC
      net: ethernet: xilinx: Do not use NO_IRQ in axienet

Michel Lespinasse (1):
      lib/rbtree.c: avoid the use of non-static __always_inline

Mike Dunn (2):
      ALSA: pxa27x: fix ac97 cold reset
      ALSA: pxa27x: fix ac97 warm reset

Mike Frysinger (1):
      linux/audit.h: move ptrace.h include to kernel header

Namjae Jeon (1):
      UDF: Fix a null pointer dereference in udf_sb_free_partitions

Nickolai Zeldovich (2):
      drivers/net/wireless/mwl8k.c: avoid use-after-free
      staging: speakup: avoid out-of-range access in synth_init()

Nitin Gupta (1):
      staging: zram: fix invalid memory references during disk write

Oliver Neukum (1):
      USB: hub: handle claim of enabled remote wakeup after reset

Omar Ramirez Luna (1):
      staging: tidspbridge: use prepare/unprepare on dsp clocks

Patrick Lai (1):
      ASoC: pcm: allow backend hardware to be freed in pause state

Paul Mundt (2):
      sh: wire up finit_module syscall.
      sh: Fix up stack debugging build.

Peter Hurley (3):
      staging/fwserial: Refine Kconfig help text
      staging/fwserial: Limit tx/rx to 1394-2008 spec maximum
      staging/fwserial: Update TODO file per reviewer comments

Quentin.Li (1):
      USB: option: Add new MEDIATEK PID support

Ralf Baechle (1):
      drivers/base/cpu.c: Fix typo in comment

Randy Dunlap (4):
      nfs: fix sunrpc/clnt.c kernel-doc warnings
      audit: fix auditfilter.c kernel-doc warnings
      pci: fix iov.c kernel-doc warnings
      seq_file: fix new kernel-doc warnings

Rob Clark (2):
      staging: drm/omap: use omapdss low level API
      staging: drm/omap: fix flags in dma buf exporting

Roland Dreier (4):
      target: Fix missing CMD_T_ACTIVE bit regression for pending WRITEs
      target: Fix use-after-free in LUN RESET handling
      target: Release se_cmd when LUN lookup fails for TMR
      iscsi-target: Fix CmdSN comparison (use cmd->cmd_sn instead of
cmd->stat_sn)

Romain Kuntz (2):
      ipv6: fix the noflags test in addrconf_get_prefix_route
      ipv6: use addrconf_get_prefix_route for prefix route lookup [v2]

Sachin Kamat (1):
      ALSA: usb-audio: Make ebox44_table static

Sam Ravnborg (1):
      sparc: remove __devinit, __devexit annotations

Samuel Thibault (1):
      staging: speakup: avoid out-of-range access in synth_add()

Sarah Sharp (8):
      xhci: Handle HS bulk/ctrl endpoints that don't NAK.
      USB: Handle auto-transition from hot to warm reset.
      USB: Ignore xHCI Reset Device status.
      USB: Allow USB 3.0 ports to be disabled.
      USB: Increase reset timeout.
      USB: Ignore port state until reset completes.
      USB: Handle warm reset failure on empty port.
      xhci: Avoid "dead ports", add roothub port polling.

Sasha Levin (1):
      x86, efi: correct precedence of operators in setup_efi_pci

Sathya Perla (1):
      be2net: fix unconditionally returning IRQ_HANDLED in INTx

Sebastian Andrzej Siewior (1):
      usb: gadget: dummy: fix enumeration with g_multi

Sebastian Ott (1):
      s390/chsc: fix SEI usage

Sergei Shtylyov (1):
      usb: musb: core: print new line in the driver banner again

Sergey Senozhatsky (1):
      acer-wmi: add Aspire 5741G touchpad toggle key

Seth Forshee (1):
      samsung-laptop: Add quirk for broken acpi_video backlight on N250P

Stanislaw Gruszka (2):
      mac80211: fix ibss scanning
      net, wireless: overwrite default_ethtool_ops

Stefan Hajnoczi (1):
      tuntap: refuse to re-attach to different tun_struct

Stephen Warren (2):
      arm64: dts: prevent *.dtb from always being rebuilt
      ARM: dts: prevent *.dtb from always being rebuilt

Steven Rostedt (4):
      staging: Make SystemBase PCI Multiport UART only for x86
      staging: Enable parport sb105x drivers if parport is configured
      tracing: Fix regression of trace_options file setting
      tracing: Fix regression with irqsoff tracer and tracing_on file

Takashi Iwai (3):
      ALSA: hda - Disable runtime D3 for Intel CPT & co
      ALSA: usb-audio: Fix NULL dereference by access to non-existing substream
      ALSA: hda/hdmi - Work around "alsactl restore" errors

Tejun Heo (1):
      module, async: async_synchronize_full() on module init iff async is used

Thomas Pedersen (1):
      mac80211: RMC buckets are just list heads

Thomas Schwinge (1):
      sh: Fix FDPIC binary loader

Timur Tabi (1):
      MAINTAINERS: update email address for Timur Tabi

Tomasz Mloduchowski (1):
      usb: ftdi_sio: Crucible Technologies COMET Caller ID - pid added

Trond Myklebust (1):
      SUNRPC: Ensure we release the socket write lock if the rpc_task
exits early

Tushar Behera (1):
      usb: gadget: s3c-hsotg: Fix invalid free of devm_ allocated data

Vladimir Kondratiev (1):
      wireless: add new wil6210 802.11ad 60GHz driver

Wei Yongjun (1):
      usb: gadget: tcm_usb_gadge: fix to return error or 0 in
tcm_usbg_drop_nexus()

Will Deacon (4):
      arm64: vdso: remove broken, redundant sequence counting for timezones
      arm64: mm: only wrprotect clean ptes if they are present
      arm64: mm: introduce present, faulting entries for PAGE_NONE
      arm64: compat: add syscall table entries for new syscalls

Xi Wang (2):
      usb: gadget: amd5536udc: avoid NULL pointer dereference in udc_pci_probe()
      fs/exec.c: work around icc miscompilation

Yinghai Lu (1):
      ACPI / glue: Fix build with ACPI_GLUE_DEBUG set

Yuval Mintz (1):
      bnx2x: Fix fastpath structures when memory allocation fails

Zhang Yanfei (2):
      MAINTAINERS: fix arch/arm/plat-omap/include/plat/omap_hwmod.h
      MAINTAINERS: fix a status pattern

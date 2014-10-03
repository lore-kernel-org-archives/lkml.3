Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932626AbaJCWYH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 18:24:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47238 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932287AbaJCWXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:23:52 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: [PATCH 3.10 000/143] 3.10.56-stable review
Date: Fri,  3 Oct 2014 14:33:15 -0700
Message-Id: <20141003213314.470709810@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.10.56 release.
There are 143 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun Oct  5 21:32:57 UTC 2014.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.56-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.10.56-rc1

Oleg Nesterov <oleg@redhat.com>
    vm_is_stack: use for_each_thread() rather then buggy while_each_thread()

Oleg Nesterov <oleg@redhat.com>
    oom_kill: add rcu_read_lock() into find_lock_task_mm()

Oleg Nesterov <oleg@redhat.com>
    oom_kill: has_intersects_mems_allowed() needs rcu_read_lock()

Oleg Nesterov <oleg@redhat.com>
    oom_kill: change oom_kill.c to use for_each_thread()

Oleg Nesterov <oleg@redhat.com>
    introduce for_each_thread() to replace the buggy while_each_thread()

Oleg Nesterov <oleg@redhat.com>
    kernel/fork.c:copy_process(): unify CLONE_THREAD-or-thread_group_leader code

Soren Brinkmann <soren.brinkmann@xilinx.com>
    arm: multi_v7_defconfig: Enable Zynq UART driver

Jan Kara <jack@suse.cz>
    ext2: Fix fs corruption in ext2_get_xip_mem()

Heikki Krogerus <heikki.krogerus@linux.intel.com>
    serial: 8250_dma: check the result of TX buffer mapping

Will Deacon <will.deacon@arm.com>
    ARM: 7748/1: oabi: handle faults when loading swi instruction from userspace

Florian Westphal <fw@strlen.de>
    netfilter: nf_conntrack: avoid large timeout for mid-stream pickup

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PM / sleep: Use valid_state() for platform-dependent sleep states only

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PM / sleep: Add state field to pm_states[] entries

Julian Anastasov <ja@ssi.bg>
    ipvs: fix ipv6 hook registration for local replies

Alex Gartrell <agartrell@fb.com>
    ipvs: Maintain all DSCP and ECN bits for ipv6 tun forwarding

Julian Anastasov <ja@ssi.bg>
    ipvs: avoid netns exit crash on ip_vs_conn_drop_conntrack

NeilBrown <neilb@suse.de>
    md/raid1: fix_read_error should act on all non-faulty devices.

Hans Verkuil <hans.verkuil@cisco.com>
    media: cx18: fix kernel oops with tda8290 tuner

Anton Altaparmakov <aia21@cam.ac.uk>
    Fix nasty 32-bit overflow bug in buffer i/o code.

Jiri Olsa <jolsa@redhat.com>
    perf kmem: Make it work again on non NUMA machines

Cong Wang <cwang@twopensource.com>
    perf: Fix a race condition in perf_remove_from_context()

Richard Larocque <rlarocque@google.com>
    alarmtimer: Lock k_itimer during timer callback

Richard Larocque <rlarocque@google.com>
    alarmtimer: Do not signal SIGEV_NONE timers

John David Anglin <dave.anglin@bell.net>
    parisc: Only use -mfast-indirect-calls option for 32-bit kernel builds

Anton Blanchard <anton@samba.org>
    powerpc/perf: Fix ABIv2 kernel backtraces

Wanpeng Li <wanpeng.li@linux.intel.com>
    sched: Fix unreleased llc_shared_mask bit during CPU hotplug

Joseph Qi <joseph.qi@huawei.com>
    ocfs2/dlm: do not get resource spinlock if lockres is new

Andreas Rohner <andreas.rohner@gmx.net>
    nilfs2: fix data loss with mmap()

Andrey Vagin <avagin@openvz.org>
    fs/notify: don't show f_handle if exportfs_encode_inode_fh failed

Andrey Vagin <avagin@openvz.org>
    fsnotify/fdinfo: use named constants instead of hardcoded values

Rasmus Villemoes <linux@rasmusvillemoes.dk>
    kcmp: fix standard comparison bug

Johannes Berg <johannes.berg@intel.com>
    Revert "mac80211: disable uAPSD if all ACs are under ACM"

Felipe Balbi <balbi@ti.com>
    usb: dwc3: core: fix ordering for PHY suspend

Felipe Balbi <balbi@ti.com>
    usb: dwc3: core: fix order of PM runtime calls

Felipe Balbi <balbi@ti.com>
    usb: host: xhci: fix compliance mode workaround

Jens Axboe <axboe@fb.com>
    genhd: fix leftover might_sleep() in blk_free_devt()

J. Bruce Fields <bfields@redhat.com>
    lockd: fix rpcbind crash on lockd startup failure

Larry Finger <Larry.Finger@lwfinger.net>
    rtlwifi: rtl8192cu: Add new ID

Tejun Heo <tj@kernel.org>
    percpu: perform tlb flush after pcpu_map_pages() failure

Tejun Heo <tj@kernel.org>
    percpu: fix pcpu_alloc_pages() failure path

Honggang Li <enjoymindful@gmail.com>
    percpu: free percpu allocation info for uniprocessor system

James Ralston <james.d.ralston@intel.com>
    ata_piix: Add Device IDs for Intel 9 Series PCH

Hans de Goede <hdegoede@redhat.com>
    Input: i8042 - add nomux quirk for Avatar AVIU-145A6

Hans de Goede <hdegoede@redhat.com>
    Input: i8042 - add Fujitsu U574 to no_timeout dmi table

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: atkbd - do not try 'deactivate' keyboard on any LG laptops

Hans de Goede <hdegoede@redhat.com>
    Input: elantech - fix detection of touchpad on ASUS s301l

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: synaptics - add support for ForcePads

John Sung <penmount.touch@gmail.com>
    Input: serport - add compat handling for SPIOCSTYPE ioctl

Mikulas Patocka <mpatocka@redhat.com>
    dm crypt: fix access beyond the end of allocated space

Keith Busch <keith.busch@intel.com>
    block: Fix dev_t minor allocation lifetime

Tejun Heo <tj@kernel.org>
    workqueue: apply __WQ_ORDERED to create_singlethread_workqueue()

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    Revert "iwlwifi: dvm: don't enable CTS to self"

Mike Christie <michaelc@cs.wisc.edu>
    SCSI: libiscsi: fix potential buffer overrun in __iscsi_conn_send_pdu

Dan Carpenter <dan.carpenter@oracle.com>
    NFC: microread: Potential overflows in microread_target_discovered()

Nicholas Bellinger <nab@linux-iscsi.org>
    iscsi-target: Fix memory corruption in iscsit_logout_post_handler_diffcid

Joern Engel <joern@logfs.org>
    iscsi-target: avoid NULL pointer in iscsi_copy_param_list failure

Sagi Grimberg <sagig@mellanox.com>
    Target/iser: Don't put isert_conn inside disconnected handler

Sagi Grimberg <sagig@mellanox.com>
    Target/iser: Get isert_conn reference once got to connected_handler

Johannes Pointner <johannes.pointner@gmail.com>
    iio:inkern: fix overwritten -EPROBE_DEFER in of_iio_channel_get_by_name

Denis CIOCCA <denis.ciocca@st.com>
    iio:magnetometer: bugfix magnetometers gain values

Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
    iio: adc: ad_sigma_delta: Fix indio_dev->trig assignment

Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
    iio: st_sensors: Fix indio_dev->trig assignment

Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
    iio: meter: ade7758: Fix indio_dev->trig assignment

Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
    iio: inv_mpu6050: Fix indio_dev->trig assignment

Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
    iio: gyro: itg3200: Fix indio_dev->trig assignment

Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
    iio:trigger: modify return value for iio_trigger_get

Pavel Shilovsky <pshilovsky@samba.org>
    CIFS: Fix SMB2 readdir error handling

Pavel Shilovsky <pshilovsky@samba.org>
    CIFS: Fix directory rename error

Peter Ujfalusi <peter.ujfalusi@ti.com>
    ASoC: davinci-mcasp: Correct rx format unit configuration

Miklos Szeredi <mszeredi@suse.cz>
    shmem: fix nlink for rename overwrite directory

Dave Young <dyoung@redhat.com>
    x86 early_ioremap: Increase FIX_BTMAPS_SLOTS to 8

Marcelo Tosatti <mtosatti@redhat.com>
    KVM: x86: handle idiv overflow at kvm_write_tsc

Mark Brown <broonie@linaro.org>
    regmap: Fix handling of volatile registers for format_write() chips

Bob Moore <Robert.Moore@intel.com>
    ACPICA: Update to GPIO region handler interface.

Markos Chandras <markos.chandras@imgtec.com>
    MIPS: mcount: Adjust stack pointer for static trace in MIPS32

Aurelien Jarno <aurelien@aurel32.net>
    MIPS: ZBOOT: add missing <linux/string.h> include

Robin Murphy <robin.murphy@arm.com>
    ARM: 8165/1: alignment: don't break misaligned NEON load/store

Dave Martin <dave.martin@linaro.org>
    ARM: 7897/1: kexec: Use the right ISA for relocate_new_kernel

Sudeep Holla <sudeep.holla@arm.com>
    ARM: 8133/1: use irq_set_affinity with force=false when migrating irqs

Mark Rutland <mark.rutland@arm.com>
    ARM: 8128/1: abort: don't clear the exclusive monitors

Trond Myklebust <trond.myklebust@primarydata.com>
    NFSv4: Fix another bug in the close/open_downgrade code

Steve Dickson <steved@redhat.com>
    NFSv4: nfs4_state_manager() vs. nfs_server_remove_lists()

Shen Guang <shenguang10@gmail.com>
    usb:hub set hub->change_bits when over-current happens

Felipe Balbi <balbi@ti.com>
    usb: dwc3: omap: fix ordering for runtime pm calls

Alan Stern <stern@rowland.harvard.edu>
    USB: EHCI: unlink QHs even after the controller has stopped

Mark <markk@clara.co.uk>
    USB: storage: Add quirks for Entrega/Xircom USB to SCSI converters

Mark <markk@clara.co.uk>
    USB: storage: Add quirk for Ariston Technologies iConnect USB to SCSI adapter

Mark <markk@clara.co.uk>
    USB: storage: Add quirk for Adaptec USBConnect 2000 USB-to-SCSI Adapter

Mark <markk@clara.co.uk>
    storage: Add single-LUN quirk for Jaz USB Adapter

Joe Lawrence <joe.lawrence@stratus.com>
    usb: hub: take hub->hdev reference when processing from eventlist

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: fix oops when xhci resumes from hibernate with hw lpm capable devices

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: Fix null pointer dereference if xhci initialization fails

Johan Hovold <johan@kernel.org>
    USB: zte_ev: fix removed PIDs

Johan Hovold <johan@kernel.org>
    USB: ftdi_sio: add support for NOVITUS Bono E thermal printer

Bjørn Mork <bjorn@mork.no>
    USB: sierra: add 1199:68AA device ID

Bjørn Mork <bjorn@mork.no>
    USB: sierra: avoid CDC class functions on "68A3" devices

Johan Hovold <johan@kernel.org>
    USB: zte_ev: remove duplicate Qualcom PID

Johan Hovold <johan@kernel.org>
    USB: zte_ev: remove duplicate Gobi PID

Johan Hovold <johan@kernel.org>
    Revert "USB: option,zte_ev: move most ZTE CDMA devices to zte_ev"

Brennan Ashton <bashton@brennanashton.com>
    USB: option: add VIA Telecom CDS7 chipset device id

Johan Hovold <johan@kernel.org>
    USB: option: reduce interrupt-urb logging verbosity

Johan Hovold <johan@kernel.org>
    USB: serial: fix potential heap buffer overflow

Stephen Hemminger <stephen@networkplumber.org>
    USB: sisusb: add device id for Magic Control USB video

Johan Hovold <johan@kernel.org>
    USB: serial: fix potential stack buffer overflow

Greg KH <gregkh@linuxfoundation.org>
    USB: serial: pl2303: add device id for ztek device

Max Filippov <jcmvbkbc@gmail.com>
    xtensa: fix a6 and a7 handling in fast_syscall_xtensa

Max Filippov <jcmvbkbc@gmail.com>
    xtensa: fix TLBTEMP_BASE_2 region handling in fast_second_level_miss

Max Filippov <jcmvbkbc@gmail.com>
    xtensa: fix access to THREAD_RA/THREAD_SP/THREAD_DS

Alan Douglas <adouglas@cadence.com>
    xtensa: fix address checks in dma_{alloc,free}_coherent

Max Filippov <jcmvbkbc@gmail.com>
    xtensa: replace IOCTL code definitions with constants

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: add connector quirk for fujitsu board

Thomas Hellstrom <thellstrom@vmware.com>
    drm/vmwgfx: Fix a potential infinite spin waiting for fifo idle

Y.C. Chen <yc_chen@aspeedtech.com>
    drm/ast: AST2000 cannot be detected correctly

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915: Wait for vblank before enabling the TV encoder

Mathias Krause <minipli@googlemail.com>
    drm/i915: Remove bogus __init annotation from DMI callbacks

Benjamin Tissoires <benjamin.tissoires@redhat.com>
    HID: logitech-dj: prevent false errors to be shown

Jiri Kosina <jkosina@suse.cz>
    HID: magicmouse: sanity check report size in raw_event() callback

Jiri Kosina <jkosina@suse.cz>
    HID: picolcd: sanity check report size in raw_event() callback

Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>
    cfq-iosched: Fix wrong children_weight calculation

Clemens Ladisch <clemens@ladisch.de>
    ALSA: pcm: fix fifo_size frame calculation

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Fix invalid pin powermap without jack detection

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Fix COEF setups for ALC1150 codec

Clemens Ladisch <clemens@ladisch.de>
    ALSA: core: fix buffer overflow in snd_info_get_line()

Will Deacon <will.deacon@arm.com>
    arm64: ptrace: fix compat hardware watchpoint reporting

Josef Bacik <jbacik@fb.com>
    trace: Fix epoll hang when we race with new entries

Simon Lindgren <simon@aqwary.com>
    i2c: at91: Fix a race condition during signal handling in at91_do_twi_xfer.

Marek Roszko <mark.roszko@gmail.com>
    i2c: at91: add bound checking on SMBus block length bytes

Will Deacon <will.deacon@arm.com>
    arm64: flush TLS registers during exec

Anton Blanchard <anton@samba.org>
    ibmveth: Fix endian issues with rx_no_buffer statistic

Murali Karicheri <m-karicheri2@ti.com>
    ahci: add pcid for Marvel 0x9182 controller

James Ralston <james.d.ralston@intel.com>
    ahci: Add Device IDs for Intel 9 Series PCH

Arjun Sreedharan <arjun024@gmail.com>
    pata_scc: propagate return value of scc_wait_after_reset

Jiri Kosina <jkosina@suse.cz>
    drm/i915: read HEAD register back in init_ring_common() to enforce ordering

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: load the lm63 driver for an lm64 thermal chip.

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    drm/ttm: Choose a pool to shrink correctly in ttm_dma_pool_shrink_scan().

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    drm/ttm: Fix possible division by 0 in ttm_dma_pool_shrink_scan().

Guido Martínez <guido@vanguardiasur.com.ar>
    drm/tilcdc: fix double kfree

Guido Martínez <guido@vanguardiasur.com.ar>
    drm/tilcdc: fix release order on exit

Guido Martínez <guido@vanguardiasur.com.ar>
    drm/tilcdc: panel: fix leak when unloading the module

Guido Martínez <guido@vanguardiasur.com.ar>
    drm/tilcdc: tfp410: fix dangling sysfs connector node

Guido Martínez <guido@vanguardiasur.com.ar>
    drm/tilcdc: slave: fix dangling sysfs connector node

Guido Martínez <guido@vanguardiasur.com.ar>
    drm/tilcdc: panel: fix dangling sysfs connector node

Ronald Wahl <ronald.wahl@raritan.com>
    carl9170: fix sending URBs with wrong type when using full-speed


-------------

Diffstat:

 Makefile                                           |  4 +-
 arch/arm/configs/multi_v7_defconfig                |  2 +
 arch/arm/kernel/entry-common.S                     | 42 ++++++++-----
 arch/arm/kernel/irq.c                              |  2 +-
 arch/arm/kernel/machine_kexec.c                    | 17 +++---
 arch/arm/kernel/relocate_kernel.S                  |  8 ++-
 arch/arm/mm/abort-ev6.S                            |  6 --
 arch/arm/mm/abort-ev7.S                            |  6 --
 arch/arm/mm/alignment.c                            |  3 +
 arch/arm64/include/asm/hw_breakpoint.h             |  1 -
 arch/arm64/kernel/process.c                        | 18 ++++++
 arch/arm64/kernel/ptrace.c                         |  3 +-
 arch/arm64/kernel/sys_compat.c                     |  6 ++
 arch/mips/boot/compressed/decompress.c             |  1 +
 arch/mips/kernel/mcount.S                          | 12 ++++
 arch/parisc/Makefile                               |  7 ++-
 arch/powerpc/include/asm/ptrace.h                  |  7 +++
 arch/powerpc/perf/callchain.c                      |  2 +-
 arch/x86/include/asm/fixmap.h                      |  6 +-
 arch/x86/kernel/smpboot.c                          |  3 +
 arch/x86/kvm/x86.c                                 | 23 +++++++-
 arch/xtensa/include/asm/pgtable.h                  |  7 ++-
 arch/xtensa/include/asm/uaccess.h                  |  5 ++
 arch/xtensa/include/uapi/asm/ioctls.h              | 19 +++---
 arch/xtensa/kernel/entry.S                         | 26 +++++----
 arch/xtensa/kernel/pci-dma.c                       | 12 ++--
 block/cfq-iosched.c                                | 11 +++-
 block/genhd.c                                      | 26 +++++----
 block/partition-generic.c                          |  2 +-
 drivers/acpi/acpica/aclocal.h                      |  1 +
 drivers/acpi/acpica/acobject.h                     |  1 +
 drivers/acpi/acpica/dsfield.c                      |  2 +
 drivers/acpi/acpica/evregion.c                     | 47 ++++++++++-----
 drivers/acpi/acpica/exfield.c                      | 67 +++++++++++++++++++++
 drivers/acpi/acpica/exprep.c                       |  2 +
 drivers/ata/ahci.c                                 | 10 ++++
 drivers/ata/ata_piix.c                             |  8 +++
 drivers/ata/pata_scc.c                             | 15 +++--
 drivers/base/regmap/regmap.c                       |  2 +-
 drivers/gpu/drm/ast/ast_main.c                     |  2 +-
 drivers/gpu/drm/i915/intel_bios.c                  |  2 +-
 drivers/gpu/drm/i915/intel_crt.c                   |  2 +-
 drivers/gpu/drm/i915/intel_lvds.c                  |  2 +-
 drivers/gpu/drm/i915/intel_ringbuffer.c            |  3 +
 drivers/gpu/drm/i915/intel_tv.c                    |  4 ++
 drivers/gpu/drm/radeon/radeon_atombios.c           | 11 +++-
 drivers/gpu/drm/tilcdc/tilcdc_drv.c                |  7 ++-
 drivers/gpu/drm/tilcdc/tilcdc_panel.c              |  5 +-
 drivers/gpu/drm/tilcdc/tilcdc_slave.c              |  1 +
 drivers/gpu/drm/tilcdc/tilcdc_tfp410.c             |  1 +
 drivers/gpu/drm/ttm/ttm_page_alloc_dma.c           |  9 ++-
 drivers/gpu/drm/vmwgfx/vmwgfx_fifo.c               |  3 +-
 drivers/hid/hid-logitech-dj.c                      | 43 ++++++++------
 drivers/hid/hid-logitech-dj.h                      |  1 +
 drivers/hid/hid-magicmouse.c                       | 10 ++++
 drivers/hid/hid-picolcd_core.c                     |  6 ++
 drivers/i2c/busses/i2c-at91.c                      | 32 ++++++++--
 drivers/iio/adc/ad_sigma_delta.c                   |  2 +-
 drivers/iio/common/st_sensors/st_sensors_trigger.c |  2 +-
 drivers/iio/gyro/itg3200_buffer.c                  |  2 +-
 drivers/iio/imu/inv_mpu6050/inv_mpu_trigger.c      |  2 +-
 drivers/iio/inkern.c                               |  2 +-
 drivers/iio/magnetometer/st_magn_core.c            | 52 ++++++++++-------
 drivers/infiniband/ulp/isert/ib_isert.c            |  7 ++-
 drivers/input/keyboard/atkbd.c                     |  8 ---
 drivers/input/mouse/elantech.c                     |  7 +++
 drivers/input/mouse/synaptics.c                    | 68 +++++++++++++++++-----
 drivers/input/mouse/synaptics.h                    | 11 ++++
 drivers/input/serio/i8042-x86ia64io.h              | 15 +++++
 drivers/input/serio/serport.c                      | 45 +++++++++++---
 drivers/md/dm-crypt.c                              | 20 +++++--
 drivers/md/raid1.c                                 |  4 +-
 drivers/media/pci/cx18/cx18-driver.c               |  1 +
 drivers/net/ethernet/ibm/ibmveth.c                 | 18 ++++--
 drivers/net/wireless/ath/carl9170/carl9170.h       |  1 +
 drivers/net/wireless/ath/carl9170/usb.c            | 31 ++++++++--
 drivers/net/wireless/iwlwifi/dvm/rxon.c            | 12 ++++
 drivers/net/wireless/rtlwifi/rtl8192cu/sw.c        |  1 +
 drivers/nfc/microread/microread.c                  | 16 +++--
 drivers/scsi/libiscsi.c                            | 10 ++++
 drivers/staging/iio/meter/ade7758_trigger.c        |  2 +-
 drivers/target/iscsi/iscsi_target.c                |  4 +-
 drivers/target/iscsi/iscsi_target_parameters.c     |  2 +-
 drivers/tty/serial/8250/8250_dma.c                 | 17 ++++--
 drivers/usb/core/hub.c                             |  7 ++-
 drivers/usb/dwc3/core.c                            | 13 +++--
 drivers/usb/dwc3/dwc3-omap.c                       |  2 +-
 drivers/usb/host/ehci-hcd.c                        |  2 -
 drivers/usb/host/xhci-hub.c                        |  8 ++-
 drivers/usb/host/xhci-mem.c                        |  2 +-
 drivers/usb/host/xhci.c                            | 12 +++-
 drivers/usb/misc/sisusbvga/sisusb.c                |  1 +
 drivers/usb/serial/ftdi_sio.c                      |  1 +
 drivers/usb/serial/ftdi_sio_ids.h                  |  6 ++
 drivers/usb/serial/option.c                        | 31 +++++++++-
 drivers/usb/serial/pl2303.c                        |  1 +
 drivers/usb/serial/pl2303.h                        |  1 +
 drivers/usb/serial/sierra.c                        |  9 ++-
 drivers/usb/serial/usb-serial.c                    | 37 ++++++++----
 drivers/usb/serial/zte_ev.c                        | 24 ++------
 drivers/usb/storage/unusual_devs.h                 | 38 ++++++++++++
 fs/buffer.c                                        |  6 +-
 fs/cifs/cifsglob.h                                 |  2 +
 fs/cifs/file.c                                     |  2 +-
 fs/cifs/inode.c                                    |  5 +-
 fs/cifs/readdir.c                                  |  2 +-
 fs/cifs/smb1ops.c                                  |  7 +++
 fs/cifs/smb2maperror.c                             |  2 +-
 fs/cifs/smb2ops.c                                  |  8 +++
 fs/cifs/smb2pdu.c                                  |  9 ++-
 fs/ext2/inode.c                                    |  2 +
 fs/ext2/xip.c                                      |  1 +
 fs/lockd/svc.c                                     |  4 +-
 fs/nfs/nfs4client.c                                | 38 ++++++------
 fs/nfs/nfs4proc.c                                  | 30 +++++-----
 fs/nilfs2/inode.c                                  |  7 ++-
 fs/notify/fdinfo.c                                 |  4 +-
 fs/ocfs2/dlm/dlmmaster.c                           | 18 +++---
 include/linux/iio/trigger.h                        |  4 +-
 include/linux/init_task.h                          |  2 +
 include/linux/sched.h                              | 12 ++++
 include/linux/workqueue.h                          |  2 +-
 kernel/events/core.c                               | 10 ++++
 kernel/exit.c                                      |  1 +
 kernel/fork.c                                      | 22 ++++---
 kernel/kcmp.c                                      |  7 ++-
 kernel/power/main.c                                | 21 +++----
 kernel/power/power.h                               |  9 ++-
 kernel/power/suspend.c                             | 66 ++++++++++-----------
 kernel/power/suspend_test.c                        | 24 ++++----
 kernel/time/alarmtimer.c                           | 16 +++--
 kernel/trace/ring_buffer.c                         | 16 ++++-
 mm/oom_kill.c                                      | 51 +++++++++-------
 mm/percpu-vm.c                                     | 22 +++++--
 mm/percpu.c                                        |  2 +
 mm/shmem.c                                         |  4 +-
 mm/util.c                                          |  9 +--
 net/mac80211/mlme.c                                |  3 +-
 net/netfilter/ipvs/ip_vs_conn.c                    |  1 -
 net/netfilter/ipvs/ip_vs_core.c                    |  2 +-
 net/netfilter/ipvs/ip_vs_xmit.c                    |  2 +-
 net/netfilter/nf_conntrack_proto_tcp.c             |  6 ++
 sound/core/info.c                                  |  4 +-
 sound/core/pcm_lib.c                               |  8 ++-
 sound/pci/hda/patch_realtek.c                      |  2 +
 sound/pci/hda/patch_sigmatel.c                     | 17 ++++--
 sound/soc/davinci/davinci-mcasp.c                  | 11 +++-
 tools/perf/builtin-kmem.c                          |  2 +-
 148 files changed, 1168 insertions(+), 480 deletions(-)



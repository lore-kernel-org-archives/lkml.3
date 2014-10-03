Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203AbaJCVpM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 17:45:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45392 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756057AbaJCVnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:43:21 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: [PATCH 3.14 000/238] 3.14.20-stable review
Date: Fri,  3 Oct 2014 14:28:35 -0700
Message-Id: <20141003212913.680985295@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.14.20 release.
There are 238 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun Oct  5 21:28:26 UTC 2014.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.14.20-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.14.20-rc1

Stephen Boyd <sboyd@codeaurora.org>
    clk: qcom: mdp_lut_clk is a child of mdp_src

Stephen Boyd <sboyd@codeaurora.org>
    clk: qcom: Fix MN frequency tables, parent map, and jpegd

Arnd Bergmann <arnd@arndb.de>
    staging/lustre: disable virtual block device for 64K pages

Gu Zheng <guz.fnst@cn.fujitsu.com>
    aio: block exit_aio() until all context requests are completed

Tero Kristo <t-kristo@ti.com>
    clk: prevent erronous parsing of children during rate change

Venkatesh Srinivas <venkateshs@google.com>
    perf/x86/intel: Use rdmsrl_safe() when initializing RAPL PMU

Dan Carpenter <dan.carpenter@oracle.com>
    partitions: aix.c: off by one bug

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    dmaengine: dw: don't perform DMA when dmaengine_submit is called

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    dmaengine: dw: introduce dwc_dostart_first_queued() helper

Heikki Krogerus <heikki.krogerus@linux.intel.com>
    serial: 8250_dma: check the result of TX buffer mapping

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PM / sleep: Use valid_state() for platform-dependent sleep states only

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PM / sleep: Add state field to pm_states[] entries

Julian Anastasov <ja@ssi.bg>
    ipvs: fix ipv6 hook registration for local replies

Daniel Borkmann <dborkman@redhat.com>
    netfilter: x_tables: allow to use default cgroup match

Alex Gartrell <agartrell@fb.com>
    ipvs: Maintain all DSCP and ECN bits for ipv6 tun forwarding

Eric Dumazet <edumazet@google.com>
    netfilter: xt_hashlimit: perform garbage collection from process context

Julian Anastasov <ja@ssi.bg>
    ipvs: avoid netns exit crash on ip_vs_conn_drop_conntrack

NeilBrown <neilb@suse.de>
    md/raid1: intialise start_next_window for READ case to avoid hang

NeilBrown <neilb@suse.de>
    md/raid1: fix_read_error should act on all non-faulty devices.

NeilBrown <neilb@suse.de>
    md/raid1: count resync requests in nr_pending.

NeilBrown <neilb@suse.de>
    md/raid1: update next_resync under resync_lock.

NeilBrown <neilb@suse.de>
    md/raid1: Don't use next_resync to determine how far resync has progressed

NeilBrown <neilb@suse.de>
    md/raid1: make sure resync waits for conflicting writes to complete.

NeilBrown <neilb@suse.de>
    md/raid1: be more cautious where we read-balance during resync.

NeilBrown <neilb@suse.de>
    md/raid1: clean up request counts properly in close_sync()

Hans Verkuil <hverkuil@xs4all.nl>
    media: adv7604: fix inverted condition

Hans Verkuil <hans.verkuil@cisco.com>
    media: cx18: fix kernel oops with tda8290 tuner

Malcolm Priestley <tvboxspy@gmail.com>
    media: af9035: new IDs: add support for PCTV 78e and PCTV 79e

Prarit Bhargava <prarit@redhat.com>
    cpufreq: release policy->rwsem on error

Johannes Berg <johannes.berg@intel.com>
    nl80211: clear skb cb before passing to netlink

Anton Altaparmakov <aia21@cam.ac.uk>
    Fix nasty 32-bit overflow bug in buffer i/o code.

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon/px: fix module unload

Alex Deucher <alexander.deucher@amd.com>
    drm/nouveau/runpm: fix module unload

Alex Deucher <alexander.deucher@amd.com>
    vgaswitcheroo: add vga_switcheroo_fini_domain_pm_ops

Cong Wang <cwang@twopensource.com>
    perf: Fix a race condition in perf_remove_from_context()

Matan Barak <matanb@mellanox.com>
    IB/core: When marshaling uverbs path, clear unused fields

Moni Shoua <monis@mellanox.com>
    IB/mlx4: Don't duplicate the default RoCE GID

Moni Shoua <monis@mellanox.com>
    IB/mlx4: Avoid null pointer dereference in mlx4_ib_scan_netdevs()

Mike Marciniszyn <mike.marciniszyn@intel.com>
    IB/qib: Correct reference counting in debugfs qp_stats

Al Viro <viro@ZenIV.linux.org.uk>
    GFS2: fix d_splice_alias() misuses

Richard Larocque <rlarocque@google.com>
    alarmtimer: Lock k_itimer during timer callback

Richard Larocque <rlarocque@google.com>
    alarmtimer: Do not signal SIGEV_NONE timers

Richard Larocque <rlarocque@google.com>
    alarmtimer: Return relative times in timer_gettime

John David Anglin <dave.anglin@bell.net>
    parisc: Only use -mfast-indirect-calls option for 32-bit kernel builds

Guy Martin <gmsoft@tuxicoman.be>
    parisc: Implement new LWS CAS supporting 64 bit operations.

Al Viro <viro@zeniv.linux.org.uk>
    don't bugger nd->seq on set_root_rcu() from follow_dotdot_rcu()

Michael Ellerman <mpe@ellerman.id.au>
    powerpc: Add smp_mb()s to arch_spin_unlock_wait()

Michael Ellerman <mpe@ellerman.id.au>
    powerpc: Add smp_mb() to arch_spin_is_locked()

Anton Blanchard <anton@samba.org>
    powerpc/perf: Fix ABIv2 kernel backtraces

Arend van Spriel <arend@broadcom.com>
    brcmfmac: handle IF event for P2P_DEVICE interface

Wanpeng Li <wanpeng.li@linux.intel.com>
    sched: Fix unreleased llc_shared_mask bit during CPU hotplug

Peter Feiner <pfeiner@google.com>
    mm: softdirty: keep bit when zapping file pte

David Rientjes <rientjes@google.com>
    mm, slab: initialize object alignment on cache creation

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

Nicolas Iooss <nicolas.iooss_linux@m4x.org>
    eventpoll: fix uninitialized variable in epoll_ctl

Johannes Berg <johannes.berg@intel.com>
    Revert "mac80211: disable uAPSD if all ACs are under ACM"

Felipe Balbi <balbi@ti.com>
    usb: dwc3: core: fix ordering for PHY suspend

Felipe Balbi <balbi@ti.com>
    usb: dwc3: core: fix order of PM runtime calls

Jens Axboe <axboe@fb.com>
    genhd: fix leftover might_sleep() in blk_free_devt()

Trond Myklebust <trond.myklebust@primarydata.com>
    lockdep: Revert lockdep check in raw_seqcount_begin()

J. Bruce Fields <bfields@redhat.com>
    lockd: fix rpcbind crash on lockd startup failure

Larry Finger <Larry.Finger@lwfinger.net>
    rtlwifi: rtl8192cu: Add new ID

Eliad Peller <eliad@wizery.com>
    regulatory: add NUL to alpha2

Tejun Heo <tj@kernel.org>
    percpu: perform tlb flush after pcpu_map_pages() failure

Tejun Heo <tj@kernel.org>
    percpu: fix pcpu_alloc_pages() failure path

Honggang Li <enjoymindful@gmail.com>
    percpu: free percpu allocation info for uniprocessor system

James Ralston <james.d.ralston@intel.com>
    ata_piix: Add Device IDs for Intel 9 Series PCH

Robert Coulson <rob.coulson@gmail.com>
    hwmon: (ds1621) Update zbits after conversion rate change

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

Anssi Hannula <anssi.hannula@iki.fi>
    dm cache: fix race causing dirty blocks to be marked as clean

Keith Busch <keith.busch@intel.com>
    block: Fix dev_t minor allocation lifetime

Thomas Gleixner <tglx@linutronix.de>
    futex: Unlock hb->lock in futex_wait_requeue_pi() error path

Tejun Heo <tj@kernel.org>
    workqueue: apply __WQ_ORDERED to create_singlethread_workqueue()

Eyal Shapira <eyal@wizery.com>
    iwlwifi: mvm: treat EAPOLs like mgmt frames wrt rate

Eliad Peller <eliad@wizery.com>
    iwlwifi: increase DEFAULT_MAX_TX_POWER

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    iwlwifi: mvm: fix endianity issues with Smart Fifo commands

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

Sebastian Herbszt <herbszt@gmx.de>
    target: Fix inverted logic in SE_DEV_ALUA_SUPPORT_STATE_STORE

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
    iio: hid_sensor_hub: Fix indio_dev->trig assignment

Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
    iio: accel: bma180: Fix indio_dev->trig assignment

Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
    iio:trigger: modify return value for iio_trigger_get

Steve French <smfrench@gmail.com>
    SMB3: Fix oops when creating symlinks on smb3

Peter Ujfalusi <peter.ujfalusi@ti.com>
    ASoC: davinci-mcasp: Correct rx format unit configuration

Miklos Szeredi <mszeredi@suse.cz>
    shmem: fix nlink for rename overwrite directory

Kees Cook <keescook@chromium.org>
    x86/kaslr: Avoid the setup_data area when picking location

Dave Young <dyoung@redhat.com>
    x86 early_ioremap: Increase FIX_BTMAPS_SLOTS to 8

Stefan Bader <stefan.bader@canonical.com>
    x86/xen: don't copy bogus duplicate entries into kernel page tables

Ross Lagerwall <ross.lagerwall@citrix.com>
    xen/manage: Always freeze/thaw processes when suspend/resuming

Christian Borntraeger <borntraeger@de.ibm.com>
    KVM: s390/mm: try a cow on read only pages for key ops

Zefan Li <lizefan@huawei.com>
    cgroup: fix unbalanced locking

Mark Brown <broonie@linaro.org>
    regmap: Don't attempt block writes when syncing cache on single_rw devices

Mark Brown <broonie@linaro.org>
    regmap: Fix handling of volatile registers for format_write() chips

Tang Chen <tangchen@cn.fujitsu.com>
    memblock, memhotplug: fix wrong type in memblock_find_in_range_node().

Mika Westerberg <mika.westerberg@linux.intel.com>
    ACPI / scan: Correct error return value of create_modalias()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI / hotplug: Generate online uevents for ACPI containers

Bob Moore <Robert.Moore@intel.com>
    ACPICA: Update to GPIO region handler interface.

Markos Chandras <markos.chandras@imgtec.com>
    MIPS: mcount: Adjust stack pointer for static trace in MIPS32

Aurelien Jarno <aurelien@aurel32.net>
    MIPS: ZBOOT: add missing <linux/string.h> include

Nathan Lynch <nathan_lynch@mentor.com>
    ARM: 8178/1: fix set_tls for !CONFIG_KUSER_HELPERS

Robin Murphy <robin.murphy@arm.com>
    ARM: 8165/1: alignment: don't break misaligned NEON load/store

Nathan Lynch <nathan_lynch@mentor.com>
    ARM: 8148/1: flush TLS and thumbee register state during exec

Sudeep Holla <sudeep.holla@arm.com>
    ARM: 8133/1: use irq_set_affinity with force=false when migrating irqs

Nishanth Menon <nm@ti.com>
    ARM: dts: dra7-evm: Fix spi1 mux documentation

Nishanth Menon <nm@ti.com>
    ARM: dts: DRA7: fix interrupt-cells for GPIO

Rajendra Nayak <rnayak@ti.com>
    ARM: DRA7: hwmod: Add dra74x and dra72x specific ocp interface lists

Mark Rutland <mark.rutland@arm.com>
    ARM: 8128/1: abort: don't clear the exclusive monitors

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    spi: dw-pci: fix bug when regs left uninitialized

Jorge A. Ventura <jorge.araujo.ventura@gmail.com>
    spi/omap-mcspi: Fix the spi task hangs waiting dma_rx

Trond Myklebust <trond.myklebust@primarydata.com>
    NFSv4: Fix another bug in the close/open_downgrade code

Steve Dickson <steved@redhat.com>
    NFSv4: nfs4_state_manager() vs. nfs_server_remove_lists()

Olav Haugan <ohaugan@codeaurora.org>
    iommu/arm-smmu: fix programming of SMMU_CBn_TCR for stage 1

Varun Sethi <Varun.Sethi@freescale.com>
    iommu/fsl: Fix warning resulting from adding PCI device twice

Lee, Chun-Yi <joeyli.kernel@gmail.com>
    ACPI / RTC: Fix CMOS RTC opregion handler accesses to wrong addresses

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

Felipe Balbi <balbi@ti.com>
    usb: host: xhci: fix compliance mode workaround

Thomas Pugliese <thomas.pugliese@gmail.com>
    uwb: init beacon cache entry before registering uwb device

Johan Hovold <johan@kernel.org>
    USB: zte_ev: fix removed PIDs

Johan Hovold <johan@kernel.org>
    USB: ftdi_sio: add support for NOVITUS Bono E thermal printer

Taylor Braun-Jones <taylor.braun-jones@ge.com>
    USB: ftdi_sio: Add support for GE Healthcare Nemo Tracker device

Ivan T. Ivanov <iivanov@mm-sol.com>
    usb: chipidea: msm: Initialize PHY on reset event

Ivan T. Ivanov <iivanov@mm-sol.com>
    usb: chipidea: msm: Use USB PHY API to control PHY state

Tony Lindgren <tony@atomide.com>
    usb: phy: twl4030-usb: Fix regressions to runtime PM on omaps

Tony Lindgren <tony@atomide.com>
    usb: phy: twl4030-usb: Fix lost interrupts after ID pin goes down

Thierry Reding <treding@nvidia.com>
    usb: phy: tegra: Avoid use of sizeof(void)

Bjørn Mork <bjorn@mork.no>
    USB: sierra: add 1199:68AA device ID

Bjørn Mork <bjorn@mork.no>
    USB: sierra: avoid CDC class functions on "68A3" devices

Karol Lewandowski <k.lewandowsk@samsung.com>
    usb: gadget: f_fs: drop duplicate usb_functionfs_descs_head declaration

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
    drm/radeon/cik: use a separate counter for CP init timeout

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: don't reset dma on r6xx-evergreen init

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: don't reset sdma on CIK init

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: don't reset dma on NI/SI init

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: add connector quirk for fujitsu board

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon/dpm: set the thermal type properly for special configs

Christian König <christian.koenig@amd.com>
    drm/radeon: fix semaphore value init

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: fix pm handling in radeon_gpu_reset

Oleg Chernovskiy <algonkvel@gmail.com>
    drm/radeon: Add missing lines to ci_set_thermal_temperature_range

Pali Rohár <pali.rohar@gmail.com>
    drm/radeon: Add ability to get and change dpm state when radeon PX card is turned off

Thomas Hellstrom <thellstrom@vmware.com>
    drm/vmwgfx: Fix a potential infinite spin waiting for fifo idle

Russell King <rmk+kernel@arm.linux.org.uk>
    imx-drm: ipuv3-plane: fix ipu_plane_dpms()

Y.C. Chen <yc_chen@aspeedtech.com>
    drm/ast: AST2000 cannot be detected correctly

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915: Wait for vblank before enabling the TV encoder

Daniel Vetter <daniel.vetter@ffwll.ch>
    drm/i915: Fix EIO/wedged handling in gem fault handler

Mathias Krause <minipli@googlemail.com>
    drm/i915: Remove bogus __init annotation from DMI callbacks

Filipe Brandenburger <filbranden@google.com>
    xattr: fix check for simultaneous glibc header inclusion

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

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Fix digital mic on Acer Aspire 3830TG

Clemens Ladisch <clemens@ladisch.de>
    ALSA: core: fix buffer overflow in snd_info_get_line()

Will Deacon <will.deacon@arm.com>
    arm64: ptrace: fix compat hardware watchpoint reporting

Josef Bacik <jbacik@fb.com>
    trace: Fix epoll hang when we race with new entries

Fan Du <fan.du@intel.com>
    i2c: ismt: use correct length when copy buffer

Simon Lindgren <simon@aqwary.com>
    i2c: at91: Fix a race condition during signal handling in at91_do_twi_xfer.

Marek Roszko <mark.roszko@gmail.com>
    i2c: at91: add bound checking on SMBus block length bytes

Chen-Yu Tsai <wens@csie.org>
    i2c: mv64xxx: continue probe when clock-frequency is missing

Pranavkumar Sawargaonkar <pranavkumar@linaro.org>
    ARM/ARM64: KVM: Nuke Hyp-mode tlbs before enabling MMU

Christoffer Dall <christoffer.dall@linaro.org>
    arm/arm64: KVM: Complete WFI/WFE instructions

Sudeep Holla <sudeep.holla@arm.com>
    arm64: use irq_set_affinity with force=false when migrating irqs

Will Deacon <will.deacon@arm.com>
    arm64: flush TLS registers during exec

Jeff Moyer <jmoyer@redhat.com>
    aio: add missing smp_rmb() in read_events_ring

Benjamin LaHaise <bcrl@kvack.org>
    aio: fix reqs_available handling

Anton Blanchard <anton@samba.org>
    ibmveth: Fix endian issues with rx_no_buffer statistic

Murali Karicheri <m-karicheri2@ti.com>
    ahci: add pcid for Marvel 0x9182 controller

James Ralston <james.d.ralston@intel.com>
    ahci: Add Device IDs for Intel 9 Series PCH

Arjun Sreedharan <arjun024@gmail.com>
    pata_scc: propagate return value of scc_wait_after_reset

Tejun Heo <tj@kernel.org>
    libata: widen Crucial M550 blacklist matching

Florian Fainelli <f.fainelli@gmail.com>
    of/irq: Fix lookup to use 'interrupts-extended' property first

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon/TN: only enable bapm on MSI systems

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: enable bapm by default on desktop TN/RL boards

Jiri Kosina <jkosina@suse.cz>
    drm/i915: read HEAD register back in init_ring_common() to enforce ordering

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: tweak ACCEL_WORKING2 query for hawaii

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon/atom: add new voltage fetch function for hawaii

Christian König <christian.koenig@amd.com>
    drm/radeon: set VM base addr using the PFP v2

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: load the lm63 driver for an lm64 thermal chip.

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: re-enable dpm by default on BTC

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: re-enable dpm by default on cayman

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon/dpm: handle voltage info fetching on hawaii

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    drm/ttm: Pass GFP flags in order to avoid deadlock.

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    drm/ttm: Fix possible stack overflow by recursive shrinker calls.

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    drm/ttm: Use mutex_trylock() to avoid deadlock inside shrinker functions.

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

 .../bindings/interrupt-controller/interrupts.txt   |  12 +-
 Makefile                                           |   4 +-
 arch/arm/boot/dts/dra7-evm.dts                     |  14 +-
 arch/arm/boot/dts/dra7.dtsi                        |  16 +-
 arch/arm/include/asm/tls.h                         |  64 ++++++
 arch/arm/kernel/irq.c                              |   2 +-
 arch/arm/kernel/process.c                          |   2 +
 arch/arm/kernel/thumbee.c                          |   2 +-
 arch/arm/kernel/traps.c                            |  17 +-
 arch/arm/kvm/handle_exit.c                         |   2 +
 arch/arm/kvm/init.S                                |   4 +
 arch/arm/mach-omap2/omap_hwmod.c                   |   3 +
 arch/arm/mach-omap2/omap_hwmod_7xx_data.c          |  22 +-
 arch/arm/mm/abort-ev6.S                            |   6 -
 arch/arm/mm/abort-ev7.S                            |   6 -
 arch/arm/mm/alignment.c                            |   3 +
 arch/arm64/include/asm/hw_breakpoint.h             |   1 -
 arch/arm64/kernel/irq.c                            |  12 +-
 arch/arm64/kernel/process.c                        |  18 ++
 arch/arm64/kernel/ptrace.c                         |   3 +-
 arch/arm64/kernel/sys_compat.c                     |   6 +
 arch/arm64/kvm/handle_exit.c                       |   2 +
 arch/arm64/kvm/hyp-init.S                          |   4 +
 arch/mips/boot/compressed/decompress.c             |   1 +
 arch/mips/kernel/mcount.S                          |  12 ++
 arch/parisc/Makefile                               |   7 +-
 arch/parisc/kernel/syscall.S                       | 233 ++++++++++++++++++++-
 arch/powerpc/include/asm/ptrace.h                  |   7 +
 arch/powerpc/include/asm/spinlock.h                |   1 +
 arch/powerpc/lib/locks.c                           |   4 +
 arch/powerpc/perf/callchain.c                      |   2 +-
 arch/s390/mm/pgtable.c                             |  10 +
 arch/x86/boot/compressed/aslr.c                    |  15 ++
 arch/x86/include/asm/fixmap.h                      |   6 +-
 arch/x86/include/asm/pgtable_64.h                  |   1 +
 arch/x86/kernel/cpu/perf_event_intel_rapl.c        |  12 +-
 arch/x86/kernel/smpboot.c                          |   3 +
 arch/x86/xen/mmu.c                                 |  27 ++-
 arch/xtensa/include/asm/pgtable.h                  |   7 +-
 arch/xtensa/include/asm/uaccess.h                  |   5 +
 arch/xtensa/include/uapi/asm/ioctls.h              |  19 +-
 arch/xtensa/kernel/entry.S                         |  26 +--
 arch/xtensa/kernel/pci-dma.c                       |  12 +-
 block/cfq-iosched.c                                |  11 +-
 block/genhd.c                                      |  26 +--
 block/partition-generic.c                          |   2 +-
 block/partitions/aix.c                             |   2 +-
 drivers/acpi/acpi_cmos_rtc.c                       |   2 +-
 drivers/acpi/acpica/aclocal.h                      |   1 +
 drivers/acpi/acpica/acobject.h                     |   1 +
 drivers/acpi/acpica/dsfield.c                      |   2 +
 drivers/acpi/acpica/evregion.c                     |  47 +++--
 drivers/acpi/acpica/exfield.c                      |  67 ++++++
 drivers/acpi/acpica/exprep.c                       |   2 +
 drivers/acpi/container.c                           |   8 +
 drivers/acpi/scan.c                                |   5 +-
 drivers/ata/ahci.c                                 |  10 +
 drivers/ata/ata_piix.c                             |   8 +
 drivers/ata/libata-core.c                          |   2 +-
 drivers/ata/pata_scc.c                             |  15 +-
 drivers/base/regmap/regcache.c                     |   2 +-
 drivers/base/regmap/regmap.c                       |   2 +-
 drivers/clk/clk.c                                  |   7 +-
 drivers/clk/qcom/mmcc-msm8960.c                    |  84 ++++----
 drivers/cpufreq/cpufreq.c                          |   2 +
 drivers/dma/TODO                                   |   1 -
 drivers/dma/dw/core.c                              |  38 ++--
 drivers/gpu/drm/ast/ast_main.c                     |   2 +-
 drivers/gpu/drm/i915/i915_gem.c                    |  11 +-
 drivers/gpu/drm/i915/intel_bios.c                  |   2 +-
 drivers/gpu/drm/i915/intel_crt.c                   |   2 +-
 drivers/gpu/drm/i915/intel_lvds.c                  |   2 +-
 drivers/gpu/drm/i915/intel_ringbuffer.c            |   3 +
 drivers/gpu/drm/i915/intel_tv.c                    |   4 +
 drivers/gpu/drm/nouveau/nouveau_vga.c              |   9 +
 drivers/gpu/drm/radeon/ci_dpm.c                    |  16 +-
 drivers/gpu/drm/radeon/cik.c                       |   9 +-
 drivers/gpu/drm/radeon/cik_sdma.c                  |   7 -
 drivers/gpu/drm/radeon/ni_dma.c                    |   6 -
 drivers/gpu/drm/radeon/r600_dma.c                  |   9 -
 drivers/gpu/drm/radeon/radeon.h                    |   3 +
 drivers/gpu/drm/radeon/radeon_atombios.c           |  72 ++++++-
 drivers/gpu/drm/radeon/radeon_device.c             |  29 ++-
 drivers/gpu/drm/radeon/radeon_kms.c                |   9 +-
 drivers/gpu/drm/radeon/radeon_pm.c                 |  24 +--
 drivers/gpu/drm/radeon/radeon_semaphore.c          |   2 +-
 drivers/gpu/drm/radeon/si.c                        |   2 +-
 drivers/gpu/drm/radeon/trinity_dpm.c               |  11 +-
 drivers/gpu/drm/tilcdc/tilcdc_drv.c                |   7 +-
 drivers/gpu/drm/tilcdc/tilcdc_panel.c              |   5 +-
 drivers/gpu/drm/tilcdc/tilcdc_slave.c              |   1 +
 drivers/gpu/drm/tilcdc/tilcdc_tfp410.c             |   1 +
 drivers/gpu/drm/ttm/ttm_page_alloc.c               |  29 +--
 drivers/gpu/drm/ttm/ttm_page_alloc_dma.c           |  34 +--
 drivers/gpu/drm/vmwgfx/vmwgfx_fifo.c               |   3 +-
 drivers/gpu/vga/vga_switcheroo.c                   |   6 +
 drivers/hid/hid-logitech-dj.c                      |  43 ++--
 drivers/hid/hid-logitech-dj.h                      |   1 +
 drivers/hid/hid-magicmouse.c                       |  10 +
 drivers/hid/hid-picolcd_core.c                     |   6 +
 drivers/hwmon/ds1621.c                             |   1 +
 drivers/i2c/busses/i2c-at91.c                      |  32 ++-
 drivers/i2c/busses/i2c-ismt.c                      |   4 +-
 drivers/i2c/busses/i2c-mv64xxx.c                   |   3 +-
 drivers/iio/accel/bma180.c                         |   2 +-
 drivers/iio/adc/ad_sigma_delta.c                   |   2 +-
 .../iio/common/hid-sensors/hid-sensor-trigger.c    |   3 +-
 drivers/iio/common/st_sensors/st_sensors_trigger.c |   2 +-
 drivers/iio/gyro/itg3200_buffer.c                  |   2 +-
 drivers/iio/imu/inv_mpu6050/inv_mpu_trigger.c      |   2 +-
 drivers/iio/inkern.c                               |   2 +-
 drivers/iio/magnetometer/st_magn_core.c            |  52 +++--
 drivers/infiniband/core/uverbs_marshall.c          |   4 +
 drivers/infiniband/hw/mlx4/main.c                  |  53 +++--
 drivers/infiniband/hw/qib/qib_debugfs.c            |   3 +-
 drivers/infiniband/hw/qib/qib_qp.c                 |   8 -
 drivers/infiniband/ulp/isert/ib_isert.c            |   7 +-
 drivers/input/keyboard/atkbd.c                     |   8 -
 drivers/input/mouse/elantech.c                     |   7 +
 drivers/input/mouse/synaptics.c                    |  68 ++++--
 drivers/input/mouse/synaptics.h                    |  11 +
 drivers/input/serio/i8042-x86ia64io.h              |  15 ++
 drivers/input/serio/serport.c                      |  45 +++-
 drivers/iommu/arm-smmu.c                           |   7 +-
 drivers/iommu/fsl_pamu_domain.c                    |  10 +-
 drivers/md/dm-cache-target.c                       |   4 +-
 drivers/md/dm-crypt.c                              |  20 +-
 drivers/md/raid1.c                                 |  40 ++--
 drivers/media/dvb-core/dvb-usb-ids.h               |   2 +
 drivers/media/i2c/adv7604.c                        |   2 +-
 drivers/media/pci/cx18/cx18-driver.c               |   1 +
 drivers/media/usb/dvb-usb-v2/af9035.c              |   4 +
 drivers/net/ethernet/ibm/ibmveth.c                 |  18 +-
 drivers/net/wireless/ath/carl9170/carl9170.h       |   1 +
 drivers/net/wireless/ath/carl9170/usb.c            |  31 ++-
 drivers/net/wireless/brcm80211/brcmfmac/fweh.c     |  12 +-
 drivers/net/wireless/brcm80211/brcmfmac/fweh.h     |   2 +
 drivers/net/wireless/iwlwifi/dvm/rxon.c            |  12 ++
 drivers/net/wireless/iwlwifi/iwl-config.h          |   2 +
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.c       |   4 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api.h          |   4 +-
 drivers/net/wireless/iwlwifi/mvm/sf.c              |   2 +-
 drivers/net/wireless/iwlwifi/mvm/tx.c              |   8 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/sw.c        |   1 +
 drivers/nfc/microread/microread.c                  |  16 +-
 drivers/of/irq.c                                   |  17 +-
 drivers/phy/phy-twl4030-usb.c                      | 121 ++++++-----
 drivers/scsi/libiscsi.c                            |  10 +
 drivers/spi/spi-dw-pci.c                           |   2 +
 drivers/spi/spi-omap2-mcspi.c                      |   3 +-
 drivers/staging/iio/meter/ade7758_trigger.c        |   2 +-
 drivers/staging/imx-drm/ipuv3-plane.c              |   3 +-
 drivers/staging/lustre/lustre/Kconfig              |   1 +
 drivers/target/iscsi/iscsi_target.c                |   4 +-
 drivers/target/iscsi/iscsi_target_parameters.c     |   2 +-
 drivers/target/target_core_configfs.c              |   2 +-
 drivers/tty/serial/8250/8250_dma.c                 |  17 +-
 drivers/usb/chipidea/ci_hdrc_msm.c                 |   7 +-
 drivers/usb/core/hub.c                             |   4 +-
 drivers/usb/dwc3/core.c                            |  13 +-
 drivers/usb/dwc3/dwc3-omap.c                       |   2 +-
 drivers/usb/host/ehci-hcd.c                        |   2 -
 drivers/usb/host/xhci-hub.c                        |   8 +-
 drivers/usb/host/xhci-mem.c                        |   2 +-
 drivers/usb/host/xhci.c                            |  12 +-
 drivers/usb/misc/sisusbvga/sisusb.c                |   1 +
 drivers/usb/phy/phy-tegra-usb.c                    |   4 +-
 drivers/usb/serial/ftdi_sio.c                      |   3 +
 drivers/usb/serial/ftdi_sio_ids.h                  |  12 ++
 drivers/usb/serial/option.c                        |  31 ++-
 drivers/usb/serial/pl2303.c                        |   1 +
 drivers/usb/serial/pl2303.h                        |   1 +
 drivers/usb/serial/sierra.c                        |   9 +-
 drivers/usb/serial/usb-serial.c                    |  37 +++-
 drivers/usb/serial/zte_ev.c                        |  24 +--
 drivers/usb/storage/unusual_devs.h                 |  38 ++++
 drivers/uwb/lc-dev.c                               |  13 +-
 drivers/xen/manage.c                               |   7 -
 fs/aio.c                                           |  91 +++++++-
 fs/buffer.c                                        |   6 +-
 fs/cifs/link.c                                     |   8 +-
 fs/eventpoll.c                                     |   3 +-
 fs/gfs2/inode.c                                    |   5 +-
 fs/lockd/svc.c                                     |   4 +-
 fs/namei.c                                         |  33 +--
 fs/nfs/nfs4client.c                                |  38 ++--
 fs/nfs/nfs4proc.c                                  |  30 +--
 fs/nilfs2/inode.c                                  |   7 +-
 fs/notify/fdinfo.c                                 |   4 +-
 fs/ocfs2/dlm/dlmmaster.c                           |  18 +-
 include/acpi/acpi_bus.h                            |   1 +
 include/linux/iio/trigger.h                        |   4 +-
 include/linux/seqlock.h                            |   2 -
 include/linux/vga_switcheroo.h                     |   2 +
 include/linux/workqueue.h                          |   2 +-
 include/net/regulatory.h                           |   2 +-
 include/uapi/linux/usb/functionfs.h                |  10 +-
 include/uapi/linux/xattr.h                         |   2 +-
 kernel/cgroup.c                                    |   1 -
 kernel/events/core.c                               |  10 +
 kernel/futex.c                                     |   1 +
 kernel/kcmp.c                                      |   7 +-
 kernel/power/main.c                                |  21 +-
 kernel/power/power.h                               |   9 +-
 kernel/power/suspend.c                             |  66 +++---
 kernel/power/suspend_test.c                        |  24 +--
 kernel/time/alarmtimer.c                           |  34 ++-
 kernel/trace/ring_buffer.c                         |  16 +-
 mm/memblock.c                                      |   3 +-
 mm/memory.c                                        |   2 +-
 mm/percpu-vm.c                                     |  22 +-
 mm/percpu.c                                        |   2 +
 mm/shmem.c                                         |   4 +-
 mm/slab.c                                          |  11 +-
 net/mac80211/mlme.c                                |   3 +-
 net/netfilter/ipvs/ip_vs_conn.c                    |   1 -
 net/netfilter/ipvs/ip_vs_core.c                    |   2 +-
 net/netfilter/ipvs/ip_vs_xmit.c                    |   2 +-
 net/netfilter/xt_cgroup.c                          |   2 +-
 net/netfilter/xt_hashlimit.c                       |  31 +--
 net/wireless/nl80211.c                             |   6 +
 sound/core/info.c                                  |   4 +-
 sound/core/pcm_lib.c                               |   8 +-
 sound/pci/hda/patch_conexant.c                     |   9 +-
 sound/pci/hda/patch_realtek.c                      |   2 +
 sound/pci/hda/patch_sigmatel.c                     |  17 +-
 sound/soc/davinci/davinci-mcasp.c                  |  11 +-
 227 files changed, 2066 insertions(+), 853 deletions(-)



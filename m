Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194AbaJEXQl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 19:16:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34720 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169AbaJEXQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 19:16:38 -0400
Date: Sun, 5 Oct 2014 16:16:36 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.10.56
Message-ID: <20141005231636.GA22184@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oyUTqETQ0mS9luUI"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.10.56 kernel.

All users of the 3.10 kernel series must upgrade.

The updated 3.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.10.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Makefile                                           |    2=20
 arch/arm/configs/multi_v7_defconfig                |    2=20
 arch/arm/kernel/entry-common.S                     |   42 ++++++++----
 arch/arm/kernel/irq.c                              |    2=20
 arch/arm/kernel/machine_kexec.c                    |   17 +++--
 arch/arm/kernel/relocate_kernel.S                  |    8 +-
 arch/arm/mm/abort-ev6.S                            |    6 -
 arch/arm/mm/abort-ev7.S                            |    6 -
 arch/arm/mm/alignment.c                            |    3=20
 arch/arm64/include/asm/hw_breakpoint.h             |    1=20
 arch/arm64/kernel/process.c                        |   18 +++++
 arch/arm64/kernel/ptrace.c                         |    3=20
 arch/arm64/kernel/sys_compat.c                     |    6 +
 arch/mips/boot/compressed/decompress.c             |    1=20
 arch/mips/kernel/mcount.S                          |   12 +++
 arch/parisc/Makefile                               |    7 +-
 arch/powerpc/include/asm/ptrace.h                  |    7 ++
 arch/powerpc/perf/callchain.c                      |    2=20
 arch/x86/include/asm/fixmap.h                      |    6 -
 arch/x86/kernel/smpboot.c                          |    3=20
 arch/x86/kvm/x86.c                                 |   23 ++++++-
 arch/xtensa/include/asm/pgtable.h                  |    7 +-
 arch/xtensa/include/asm/uaccess.h                  |    5 +
 arch/xtensa/include/uapi/asm/ioctls.h              |   19 +++--
 arch/xtensa/kernel/entry.S                         |   26 ++++----
 arch/xtensa/kernel/pci-dma.c                       |   12 +--
 block/cfq-iosched.c                                |   11 ++-
 block/genhd.c                                      |   26 ++++----
 block/partition-generic.c                          |    2=20
 drivers/acpi/acpica/aclocal.h                      |    1=20
 drivers/acpi/acpica/acobject.h                     |    1=20
 drivers/acpi/acpica/dsfield.c                      |    2=20
 drivers/acpi/acpica/evregion.c                     |   47 +++++++++-----
 drivers/acpi/acpica/exfield.c                      |   67 ++++++++++++++++=
++++
 drivers/acpi/acpica/exprep.c                       |    2=20
 drivers/ata/ahci.c                                 |   10 +++
 drivers/ata/ata_piix.c                             |    8 ++
 drivers/ata/pata_scc.c                             |   15 ++--
 drivers/base/regmap/regmap.c                       |    2=20
 drivers/gpu/drm/ast/ast_main.c                     |    2=20
 drivers/gpu/drm/i915/intel_bios.c                  |    2=20
 drivers/gpu/drm/i915/intel_crt.c                   |    2=20
 drivers/gpu/drm/i915/intel_lvds.c                  |    2=20
 drivers/gpu/drm/i915/intel_ringbuffer.c            |    3=20
 drivers/gpu/drm/i915/intel_tv.c                    |    4 +
 drivers/gpu/drm/radeon/radeon_atombios.c           |   11 ++-
 drivers/gpu/drm/tilcdc/tilcdc_drv.c                |    7 +-
 drivers/gpu/drm/tilcdc/tilcdc_panel.c              |    5 -
 drivers/gpu/drm/tilcdc/tilcdc_slave.c              |    1=20
 drivers/gpu/drm/tilcdc/tilcdc_tfp410.c             |    1=20
 drivers/gpu/drm/ttm/ttm_page_alloc_dma.c           |    9 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_fifo.c               |    3=20
 drivers/hid/hid-logitech-dj.c                      |   43 +++++++------
 drivers/hid/hid-logitech-dj.h                      |    1=20
 drivers/hid/hid-magicmouse.c                       |   10 +++
 drivers/hid/hid-picolcd_core.c                     |    6 +
 drivers/i2c/busses/i2c-at91.c                      |   32 ++++++++-
 drivers/iio/adc/ad_sigma_delta.c                   |    2=20
 drivers/iio/common/st_sensors/st_sensors_trigger.c |    2=20
 drivers/iio/gyro/itg3200_buffer.c                  |    2=20
 drivers/iio/imu/inv_mpu6050/inv_mpu_trigger.c      |    2=20
 drivers/iio/inkern.c                               |    2=20
 drivers/iio/magnetometer/st_magn_core.c            |   52 +++++++++-------
 drivers/infiniband/ulp/isert/ib_isert.c            |    7 +-
 drivers/input/keyboard/atkbd.c                     |    8 --
 drivers/input/mouse/elantech.c                     |    7 ++
 drivers/input/mouse/synaptics.c                    |   68 ++++++++++++++++=
-----
 drivers/input/mouse/synaptics.h                    |   11 +++
 drivers/input/serio/i8042-x86ia64io.h              |   15 ++++
 drivers/input/serio/serport.c                      |   45 +++++++++++--
 drivers/md/dm-crypt.c                              |   20 ++++--
 drivers/md/raid1.c                                 |    4 -
 drivers/media/pci/cx18/cx18-driver.c               |    1=20
 drivers/net/ethernet/ibm/ibmveth.c                 |   18 ++++-
 drivers/net/wireless/ath/carl9170/carl9170.h       |    1=20
 drivers/net/wireless/ath/carl9170/usb.c            |   31 ++++++++-
 drivers/net/wireless/iwlwifi/dvm/rxon.c            |   12 +++
 drivers/net/wireless/rtlwifi/rtl8192cu/sw.c        |    1=20
 drivers/nfc/microread/microread.c                  |   16 +++-
 drivers/scsi/libiscsi.c                            |   10 +++
 drivers/staging/iio/meter/ade7758_trigger.c        |    2=20
 drivers/target/iscsi/iscsi_target.c                |    4 -
 drivers/target/iscsi/iscsi_target_parameters.c     |    2=20
 drivers/tty/serial/8250/8250_dma.c                 |   17 +++--
 drivers/usb/core/hub.c                             |    7 +-
 drivers/usb/dwc3/core.c                            |   13 ++--
 drivers/usb/dwc3/dwc3-omap.c                       |    2=20
 drivers/usb/host/ehci-hcd.c                        |    2=20
 drivers/usb/host/xhci-hub.c                        |    8 +-
 drivers/usb/host/xhci-mem.c                        |    2=20
 drivers/usb/host/xhci.c                            |   12 +++
 drivers/usb/misc/sisusbvga/sisusb.c                |    1=20
 drivers/usb/serial/ftdi_sio.c                      |    1=20
 drivers/usb/serial/ftdi_sio_ids.h                  |    6 +
 drivers/usb/serial/option.c                        |   31 ++++++++-
 drivers/usb/serial/pl2303.c                        |    1=20
 drivers/usb/serial/pl2303.h                        |    1=20
 drivers/usb/serial/sierra.c                        |    9 ++
 drivers/usb/serial/usb-serial.c                    |   37 ++++++++---
 drivers/usb/serial/zte_ev.c                        |   24 +------
 drivers/usb/storage/unusual_devs.h                 |   38 +++++++++++
 fs/buffer.c                                        |    6 +
 fs/cifs/cifsglob.h                                 |    2=20
 fs/cifs/file.c                                     |    2=20
 fs/cifs/inode.c                                    |    5 +
 fs/cifs/readdir.c                                  |    2=20
 fs/cifs/smb1ops.c                                  |    7 ++
 fs/cifs/smb2maperror.c                             |    2=20
 fs/cifs/smb2ops.c                                  |    8 ++
 fs/cifs/smb2pdu.c                                  |    9 +-
 fs/ext2/inode.c                                    |    2=20
 fs/ext2/xip.c                                      |    1=20
 fs/lockd/svc.c                                     |    4 -
 fs/nfs/nfs4client.c                                |   38 ++++++-----
 fs/nfs/nfs4proc.c                                  |   30 ++++-----
 fs/nilfs2/inode.c                                  |    7 +-
 fs/notify/fdinfo.c                                 |    4 -
 fs/ocfs2/dlm/dlmmaster.c                           |   18 +++--
 include/linux/iio/trigger.h                        |    4 -
 include/linux/init_task.h                          |    2=20
 include/linux/sched.h                              |   12 +++
 include/linux/workqueue.h                          |    2=20
 kernel/events/core.c                               |   10 +++
 kernel/exit.c                                      |    1=20
 kernel/fork.c                                      |   22 ++++--
 kernel/kcmp.c                                      |    7 +-
 kernel/power/main.c                                |   21 +++---
 kernel/power/power.h                               |    9 +-
 kernel/power/suspend.c                             |   66 ++++++++++------=
----
 kernel/power/suspend_test.c                        |   24 +++----
 kernel/time/alarmtimer.c                           |   16 +++-
 kernel/trace/ring_buffer.c                         |   16 ++++
 mm/oom_kill.c                                      |   51 ++++++++-------
 mm/percpu-vm.c                                     |   22 ++++--
 mm/percpu.c                                        |    2=20
 mm/shmem.c                                         |    4 -
 mm/util.c                                          |    9 --
 net/mac80211/mlme.c                                |    3=20
 net/netfilter/ipvs/ip_vs_conn.c                    |    1=20
 net/netfilter/ipvs/ip_vs_core.c                    |    2=20
 net/netfilter/ipvs/ip_vs_xmit.c                    |    2=20
 net/netfilter/nf_conntrack_proto_tcp.c             |    6 +
 sound/core/info.c                                  |    4 -
 sound/core/pcm_lib.c                               |    8 +-
 sound/pci/hda/patch_realtek.c                      |    2=20
 sound/pci/hda/patch_sigmatel.c                     |   17 +++--
 sound/soc/davinci/davinci-mcasp.c                  |   11 +++
 tools/perf/builtin-kmem.c                          |    2=20
 148 files changed, 1167 insertions(+), 479 deletions(-)

Alan Douglas (1):
      xtensa: fix address checks in dma_{alloc,free}_coherent

Alan Stern (1):
      USB: EHCI: unlink QHs even after the controller has stopped

Alex Deucher (2):
      drm/radeon: load the lm63 driver for an lm64 thermal chip.
      drm/radeon: add connector quirk for fujitsu board

Alex Gartrell (1):
      ipvs: Maintain all DSCP and ECN bits for ipv6 tun forwarding

Andreas Rohner (1):
      nilfs2: fix data loss with mmap()

Andrey Vagin (2):
      fsnotify/fdinfo: use named constants instead of hardcoded values
      fs/notify: don't show f_handle if exportfs_encode_inode_fh failed

Anton Altaparmakov (1):
      Fix nasty 32-bit overflow bug in buffer i/o code.

Anton Blanchard (2):
      ibmveth: Fix endian issues with rx_no_buffer statistic
      powerpc/perf: Fix ABIv2 kernel backtraces

Arjun Sreedharan (1):
      pata_scc: propagate return value of scc_wait_after_reset

Aurelien Jarno (1):
      MIPS: ZBOOT: add missing <linux/string.h> include

Benjamin Tissoires (1):
      HID: logitech-dj: prevent false errors to be shown

Bj=F8rn Mork (2):
      USB: sierra: avoid CDC class functions on "68A3" devices
      USB: sierra: add 1199:68AA device ID

Bob Moore (1):
      ACPICA: Update to GPIO region handler interface.

Brennan Ashton (1):
      USB: option: add VIA Telecom CDS7 chipset device id

Clemens Ladisch (2):
      ALSA: core: fix buffer overflow in snd_info_get_line()
      ALSA: pcm: fix fifo_size frame calculation

Cong Wang (1):
      perf: Fix a race condition in perf_remove_from_context()

Dan Carpenter (1):
      NFC: microread: Potential overflows in microread_target_discovered()

Dave Martin (1):
      ARM: 7897/1: kexec: Use the right ISA for relocate_new_kernel

Dave Young (1):
      x86 early_ioremap: Increase FIX_BTMAPS_SLOTS to 8

Denis CIOCCA (1):
      iio:magnetometer: bugfix magnetometers gain values

Dmitry Torokhov (2):
      Input: synaptics - add support for ForcePads
      Input: atkbd - do not try 'deactivate' keyboard on any LG laptops

Emmanuel Grumbach (1):
      Revert "iwlwifi: dvm: don't enable CTS to self"

Felipe Balbi (4):
      usb: dwc3: omap: fix ordering for runtime pm calls
      usb: host: xhci: fix compliance mode workaround
      usb: dwc3: core: fix order of PM runtime calls
      usb: dwc3: core: fix ordering for PHY suspend

Florian Westphal (1):
      netfilter: nf_conntrack: avoid large timeout for mid-stream pickup

Greg KH (1):
      USB: serial: pl2303: add device id for ztek device

Greg Kroah-Hartman (1):
      Linux 3.10.56

Guido Mart=EDnez (6):
      drm/tilcdc: panel: fix dangling sysfs connector node
      drm/tilcdc: slave: fix dangling sysfs connector node
      drm/tilcdc: tfp410: fix dangling sysfs connector node
      drm/tilcdc: panel: fix leak when unloading the module
      drm/tilcdc: fix release order on exit
      drm/tilcdc: fix double kfree

Hans Verkuil (1):
      media: cx18: fix kernel oops with tda8290 tuner

Hans de Goede (3):
      Input: elantech - fix detection of touchpad on ASUS s301l
      Input: i8042 - add Fujitsu U574 to no_timeout dmi table
      Input: i8042 - add nomux quirk for Avatar AVIU-145A6

Heikki Krogerus (1):
      serial: 8250_dma: check the result of TX buffer mapping

Honggang Li (1):
      percpu: free percpu allocation info for uniprocessor system

J. Bruce Fields (1):
      lockd: fix rpcbind crash on lockd startup failure

James Ralston (2):
      ahci: Add Device IDs for Intel 9 Series PCH
      ata_piix: Add Device IDs for Intel 9 Series PCH

Jan Kara (1):
      ext2: Fix fs corruption in ext2_get_xip_mem()

Jens Axboe (1):
      genhd: fix leftover might_sleep() in blk_free_devt()

Jiri Kosina (3):
      drm/i915: read HEAD register back in init_ring_common() to enforce or=
dering
      HID: picolcd: sanity check report size in raw_event() callback
      HID: magicmouse: sanity check report size in raw_event() callback

Jiri Olsa (1):
      perf kmem: Make it work again on non NUMA machines

Joe Lawrence (1):
      usb: hub: take hub->hdev reference when processing from eventlist

Joern Engel (1):
      iscsi-target: avoid NULL pointer in iscsi_copy_param_list failure

Johan Hovold (8):
      USB: serial: fix potential stack buffer overflow
      USB: serial: fix potential heap buffer overflow
      USB: option: reduce interrupt-urb logging verbosity
      Revert "USB: option,zte_ev: move most ZTE CDMA devices to zte_ev"
      USB: zte_ev: remove duplicate Gobi PID
      USB: zte_ev: remove duplicate Qualcom PID
      USB: ftdi_sio: add support for NOVITUS Bono E thermal printer
      USB: zte_ev: fix removed PIDs

Johannes Berg (1):
      Revert "mac80211: disable uAPSD if all ACs are under ACM"

Johannes Pointner (1):
      iio:inkern: fix overwritten -EPROBE_DEFER in of_iio_channel_get_by_na=
me

John David Anglin (1):
      parisc: Only use -mfast-indirect-calls option for 32-bit kernel builds

John Sung (1):
      Input: serport - add compat handling for SPIOCSTYPE ioctl

Josef Bacik (1):
      trace: Fix epoll hang when we race with new entries

Joseph Qi (1):
      ocfs2/dlm: do not get resource spinlock if lockres is new

Julian Anastasov (2):
      ipvs: avoid netns exit crash on ip_vs_conn_drop_conntrack
      ipvs: fix ipv6 hook registration for local replies

Keith Busch (1):
      block: Fix dev_t minor allocation lifetime

Larry Finger (1):
      rtlwifi: rtl8192cu: Add new ID

Marcelo Tosatti (1):
      KVM: x86: handle idiv overflow at kvm_write_tsc

Marek Roszko (1):
      i2c: at91: add bound checking on SMBus block length bytes

Mark (4):
      storage: Add single-LUN quirk for Jaz USB Adapter
      USB: storage: Add quirk for Adaptec USBConnect 2000 USB-to-SCSI Adapt=
er
      USB: storage: Add quirk for Ariston Technologies iConnect USB to SCSI=
 adapter
      USB: storage: Add quirks for Entrega/Xircom USB to SCSI converters

Mark Brown (1):
      regmap: Fix handling of volatile registers for format_write() chips

Mark Rutland (1):
      ARM: 8128/1: abort: don't clear the exclusive monitors

Markos Chandras (1):
      MIPS: mcount: Adjust stack pointer for static trace in MIPS32

Mathias Krause (1):
      drm/i915: Remove bogus __init annotation from DMI callbacks

Mathias Nyman (2):
      xhci: Fix null pointer dereference if xhci initialization fails
      xhci: fix oops when xhci resumes from hibernate with hw lpm capable d=
evices

Max Filippov (4):
      xtensa: replace IOCTL code definitions with constants
      xtensa: fix access to THREAD_RA/THREAD_SP/THREAD_DS
      xtensa: fix TLBTEMP_BASE_2 region handling in fast_second_level_miss
      xtensa: fix a6 and a7 handling in fast_syscall_xtensa

Mike Christie (1):
      SCSI: libiscsi: fix potential buffer overrun in __iscsi_conn_send_pdu

Miklos Szeredi (1):
      shmem: fix nlink for rename overwrite directory

Mikulas Patocka (1):
      dm crypt: fix access beyond the end of allocated space

Murali Karicheri (1):
      ahci: add pcid for Marvel 0x9182 controller

NeilBrown (1):
      md/raid1: fix_read_error should act on all non-faulty devices.

Nicholas Bellinger (1):
      iscsi-target: Fix memory corruption in iscsit_logout_post_handler_dif=
fcid

Oleg Nesterov (6):
      kernel/fork.c:copy_process(): unify CLONE_THREAD-or-thread_group_lead=
er code
      introduce for_each_thread() to replace the buggy while_each_thread()
      oom_kill: change oom_kill.c to use for_each_thread()
      oom_kill: has_intersects_mems_allowed() needs rcu_read_lock()
      oom_kill: add rcu_read_lock() into find_lock_task_mm()
      vm_is_stack: use for_each_thread() rather then buggy while_each_threa=
d()

Pavel Shilovsky (2):
      CIFS: Fix directory rename error
      CIFS: Fix SMB2 readdir error handling

Peter Ujfalusi (1):
      ASoC: davinci-mcasp: Correct rx format unit configuration

Rafael J. Wysocki (2):
      PM / sleep: Add state field to pm_states[] entries
      PM / sleep: Use valid_state() for platform-dependent sleep states only

Rasmus Villemoes (1):
      kcmp: fix standard comparison bug

Richard Larocque (2):
      alarmtimer: Do not signal SIGEV_NONE timers
      alarmtimer: Lock k_itimer during timer callback

Robin Murphy (1):
      ARM: 8165/1: alignment: don't break misaligned NEON load/store

Ronald Wahl (1):
      carl9170: fix sending URBs with wrong type when using full-speed

Sagi Grimberg (2):
      Target/iser: Get isert_conn reference once got to connected_handler
      Target/iser: Don't put isert_conn inside disconnected handler

Shen Guang (1):
      usb:hub set hub->change_bits when over-current happens

Simon Lindgren (1):
      i2c: at91: Fix a race condition during signal handling in at91_do_twi=
_xfer.

Soren Brinkmann (1):
      arm: multi_v7_defconfig: Enable Zynq UART driver

Srinivas Pandruvada (6):
      iio:trigger: modify return value for iio_trigger_get
      iio: gyro: itg3200: Fix indio_dev->trig assignment
      iio: inv_mpu6050: Fix indio_dev->trig assignment
      iio: meter: ade7758: Fix indio_dev->trig assignment
      iio: st_sensors: Fix indio_dev->trig assignment
      iio: adc: ad_sigma_delta: Fix indio_dev->trig assignment

Stephen Hemminger (1):
      USB: sisusb: add device id for Magic Control USB video

Steve Dickson (1):
      NFSv4: nfs4_state_manager() vs. nfs_server_remove_lists()

Sudeep Holla (1):
      ARM: 8133/1: use irq_set_affinity with force=3Dfalse when migrating i=
rqs

Takashi Iwai (2):
      ALSA: hda - Fix COEF setups for ALC1150 codec
      ALSA: hda - Fix invalid pin powermap without jack detection

Tejun Heo (3):
      workqueue: apply __WQ_ORDERED to create_singlethread_workqueue()
      percpu: fix pcpu_alloc_pages() failure path
      percpu: perform tlb flush after pcpu_map_pages() failure

Tetsuo Handa (2):
      drm/ttm: Fix possible division by 0 in ttm_dma_pool_shrink_scan().
      drm/ttm: Choose a pool to shrink correctly in ttm_dma_pool_shrink_sca=
n().

Thomas Hellstrom (1):
      drm/vmwgfx: Fix a potential infinite spin waiting for fifo idle

Toshiaki Makita (1):
      cfq-iosched: Fix wrong children_weight calculation

Trond Myklebust (1):
      NFSv4: Fix another bug in the close/open_downgrade code

Ville Syrj=E4l=E4 (1):
      drm/i915: Wait for vblank before enabling the TV encoder

Wanpeng Li (1):
      sched: Fix unreleased llc_shared_mask bit during CPU hotplug

Will Deacon (3):
      arm64: flush TLS registers during exec
      arm64: ptrace: fix compat hardware watchpoint reporting
      ARM: 7748/1: oabi: handle faults when loading swi instruction from us=
erspace

Y.C. Chen (1):
      drm/ast: AST2000 cannot be detected correctly


--oyUTqETQ0mS9luUI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUMdFUAAoJEDjbvchgkmk+AzQP/2n4GM1/rWYMVOPy0CUgPIRQ
4wYG6e+FXAvv2r2FMS56vxteNJj73i42oJaKowg2HLUZzyjHn61KxqYuaqoNHV88
ilytzfefHEHgDs2yL2fjg8iAFp5S2wlC6/e5qXn14exvOLLXi5BcF50D0Auv7+TK
LA0gyrJeluxw2f2gDLfbZdh7TK7pGZ0I5x3aJSKm+/YFSFfCFN0+kvQ2+zwIuB+p
P8RmLz3p5HsChafVLeOQaxaoNXAxQLIvFriIerRg8Hnmmyb2Sg2VT4Y+6A/Z2sUQ
UxJ5wJ+DsBIU2xXetnlqCT7ZdAhmG/awf8fZJgtoeMchPhxZDe9nqrhJFaMQ74kt
n/3xbI5GViiotLRV5oI4sjGf5eGEmVzyH/tUdOs5FjvE4qUUAf0sdhA7EAdAr7iK
UqlFE8o3BWLVt9Z1NzikOUf9BrBCF18NDrRNI8Hn2MbATI7FHil8vaHLsiiLtWQ4
aOCwINB978OWRiIcvIDBjGM1GG6jbfiYELyioFfeVlGHrgUdIzBejUBhQlAW9+0m
yVQP37uJdoQWNcLRH0jQc2MWQkljfdQcManxERqxioMzxmgyaV1QxKAd/2gq/hjC
KEVX8p4mTus486CyVp2Y8KhNVyQXQOrMKAnSUi900OAwrinvyi+3ltNzC2rejl/7
tVsmnE5B9nA++/6rQZQQ
=ay1T
-----END PGP SIGNATURE-----

--oyUTqETQ0mS9luUI--

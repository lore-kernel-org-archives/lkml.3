Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932403Ab3LBVW5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 16:22:57 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38392 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843Ab3LBTMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:12:39 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [PATCH 3.10 000/173] 3.10.22-stable review
Date: Mon,  2 Dec 2013 11:09:43 -0800
Message-Id: <20131202191142.873808297@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
User-Agent: quilt/0.60-8.1.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.10.22 release.
There are 173 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed Dec  4 19:10:16 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.22-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.10.22-rc1

Wei Liu <wei.liu2@citrix.com>
    xen-netback: fix refcnt unbalance for 3.10

Stanislaw Gruszka <sgruszka@redhat.com>
    iwl4965: better skb management in rx path

Eric Dumazet <edumazet@google.com>
    iwl3945: better skb management in rx path

Johannes Koch <johannes@ortsraum.de>
    media: cx23885: Fix TeVii S471 regression since introduction of ts2020

Michal Kubecek <mkubecek@suse.cz>
    netfilter: nf_conntrack: use RCU safe kfree for conntrack extensions

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    iwlwifi: don't WARN on host commands sent when firmware is dead

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: re-enable sw ACR support on pre-DCE4

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: use hw generated CTS/N values for audio

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: fix N/CTS clock matching for audio

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: use 64-bit math to calculate CTS values for audio (v2)

Nanno Langstraat <langstr@gmail.com>
    HID: apple: option to swap the 'Option' ("Alt") and 'Command' ("Flag") keys.

Tristan Rice <rice@outerearth.net>
    HID: enable Mayflash USB Gamecube Adapter

Stefan Achatz <erazor_de@users.sourceforge.net>
    HID: roccat: add missing special driver declarations

Stefan Achatz <erazor_de@users.sourceforge.net>
    HID: roccat: fix Coverity CID 141438

Stefan Achatz <erazor_de@users.sourceforge.net>
    HID: roccat: add new device return value

David Howells <dhowells@redhat.com>
    X.509: Remove certificate date checks

Mauro Carvalho Chehab <m.chehab@samsung.com>
    media: s5h1420: Don't use dynamic static allocation

Mauro Carvalho Chehab <m.chehab@samsung.com>
    media: dvb-frontends: again, Don't use dynamic static allocation

Mauro Carvalho Chehab <m.chehab@samsung.com>
    media: dvb-frontends: Don't use dynamic static allocation

Mauro Carvalho Chehab <m.chehab@samsung.com>
    media: stb0899_drv: Don't use dynamic static allocation

Mauro Carvalho Chehab <m.chehab@samsung.com>
    media: stv0367: Don't use dynamic static allocation

Mauro Carvalho Chehab <m.chehab@samsung.com>
    media: stv090x: Don't use dynamic static allocation

Mauro Carvalho Chehab <m.chehab@samsung.com>
    media: tuners: Don't use dynamic static allocation

Mauro Carvalho Chehab <m.chehab@samsung.com>
    media: tuner-xc2028: Don't use dynamic static allocation

Mauro Carvalho Chehab <m.chehab@samsung.com>
    media: lirc_zilog: Don't use dynamic static allocation

Mauro Carvalho Chehab <m.chehab@samsung.com>
    media: cx18: struct i2c_client is too big for stack

Mauro Carvalho Chehab <m.chehab@samsung.com>
    media: cimax2: Don't use dynamic static allocation

Mauro Carvalho Chehab <m.chehab@samsung.com>
    media: av7110_hw: Don't use dynamic static allocation

Mauro Carvalho Chehab <m.chehab@samsung.com>
    media: cxusb: Don't use dynamic static allocation

Mauro Carvalho Chehab <m.chehab@samsung.com>
    media: dibusb-common: Don't use dynamic static allocation

Mauro Carvalho Chehab <m.chehab@samsung.com>
    media: dw2102: Don't use dynamic static allocation

Mauro Carvalho Chehab <m.chehab@samsung.com>
    media: af9015: Don't use dynamic static allocation

Mauro Carvalho Chehab <m.chehab@samsung.com>
    media: af9035: Don't use dynamic static allocation

Mauro Carvalho Chehab <m.chehab@samsung.com>
    media: mxl111sf: Don't use dynamic static allocation

Johannes Berg <johannes.berg@intel.com>
    cfg80211: fix scheduled scan pointer access

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon/vm: don't attempt to update ptes if ib allocation fails

Tejun Heo <tj@kernel.org>
    cgroup: use a dedicated workqueue for cgroup destruction

Linus Walleij <linus.walleij@linaro.org>
    gpio: pl061: move irqdomain initialization

Simon Wood <simon@mungewell.org>
    HID: lg: fix ReportDescriptor for Logitech Formula Vibration

Simon Wood <simon@mungewell.org>
    HID:hid-lg4ff: Initialize device properties before we touch autocentering.

Simon Wood <simon@mungewell.org>
    HID:hid-lg4ff: Switch autocentering off when strength is set to zero.

Simon Wood <simon@mungewell.org>
    HID:hid-lg4ff: Scale autocentering force properly on Logitech wheel

KaiChung Cheng <kenny_cheng@wistron.com>
    HID: multicouh: add PID VID to support 1 new Wistron optical touch device

Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
    HID: hid-sensor-hub: fix report size

Forest Bond <forest.bond@rapidrollout.com>
    HID: hid-multitouch: add support for SiS panels

Elias Vanderstuyft <Elias.vds@gmail.com>
    HID: logitech - lg2ff: Add IDs for Formula Vibration Feedback Wheel

Luosong <android@generaltouch.com>
    HID: multitouch: Fix GeneralTouch products and add more PIDs

Michael Marineau <michael.marineau@coreos.com>
    9p: send uevent after adding/removing mount_tag attribute

Simon Guinot <simon.guinot@sequanux.org>
    clk: armada-370: fix tclk frequencies

Mark Langsdorf <mark.langsdorf@calxeda.com>
    cpufreq: highbank-cpufreq: Enable Midway/ECX-2000

Forest Bond <forest.bond@rapidrollout.com>
    Input: usbtouchscreen: ignore eGalax/D-Wav/EETI HIDs

Forest Bond <forest.bond@rapidrollout.com>
    HID: don't ignore eGalax/D-Wav/EETI HIDs

Tom Gundersen <teg@jklm.no>
    Input: i8042 - add PNP modaliases

Joseph Salisbury <joseph.salisbury@canonical.com>
    Input: cypress_ps2 - do not consider data bad if palm is detected

Daniel Stone <daniel@fooishbar.org>
    Input: evdev - fall back to vmalloc for client event buffer

Steven Rostedt (Red Hat) <rostedt@goodmis.org>
    tracing: Allow events to have NULL strings

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Check leaf nodes to find aamix amps

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Initialize missing bass speaker pin for ASUS AIO ET2700

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Create Headhpone Mic Jack Mode when really needed

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Fix hp-mic mode without VREF bits

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - Add support of ALC231 codec

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - Set pcbeep amp for ALC668

Peter Zijlstra <peterz@infradead.org>
    cpuset: Fix memory allocator deadlock

Tejun Heo <tj@kernel.org>
    workqueue: fix ordered workqueues in NUMA setups

Heiko Carstens <heiko.carstens@de.ibm.com>
    s390/uaccess: add missing page table walk range check

Frank Zago <frank@zago.net>
    iio:accel:kxsd9 fix missing mutex unlock

Michael Neuling <mikey@neuling.org>
    powerpc/signals: Improved mark VSX not saved with small contexts fix

David Herrmann <dh.herrmann@gmail.com>
    HID: uhid: fix leak for 64/32 UHID_CREATE

NeilBrown <neilb@suse.de>
    md: fix calculation of stacking limits on level change.

Steve French <smfrench@gmail.com>
    setfacl removes part of ACL when setting POSIX ACLs to Samba

Robert Richter <robert.richter@linaro.org>
    edac, highbank: Fix interrupt setup of mem and l2 controller

Jerome Glisse <jglisse@redhat.com>
    radeon: workaround pinning failure on low ram gpu

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: don't share PPLLs on DCE4.1

Christian König <christian.koenig@amd.com>
    drm/radeon: activate UVD clocks before sending the destroy msg

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon/si: fix define for MC_SEQ_TRAIN_WAKEUP_CNTL

Ben Skeggs <bskeggs@redhat.com>
    drm/nouveau: when bailing out of a pushbuf ioctl, do not remove previous fence

Daniel Vetter <daniel.vetter@ffwll.ch>
    drm/i915: flush cursors harder

Thomas Hellstrom <thellstrom@vmware.com>
    drm/ttm: Fix ttm_bo_move_memcpy

Jakob Bornecrantz <jakob@vmware.com>
    drm/ttm: Handle in-memory region copies

Thomas Hellstrom <thellstrom@vmware.com>
    drm/ttm: Fix memory type compatibility check

Steven Rostedt (Red Hat) <rostedt@goodmis.org>
    ftrace: Fix function graph with loading of modules

Dan Williams <dcbw@redhat.com>
    prism54: set netdev type to "wlan"

Andreas Bießmann <andreas@biessmann.de>
    avr32: fix out-of-range jump in large kernels

Andreas Bießmann <andreas@biessmann.de>
    avr32: setup crt for early panic()

Paul Moore <pmoore@redhat.com>
    selinux: correct locking in selinux_netlbl_socket_connect)

Toshi Kani <toshi.kani@hp.com>
    ACPI / hotplug: Fix conflicted PCI bridge notify handlers

Yinghai Lu <yinghai@kernel.org>
    PCI: Remove duplicate pci_disable_device() from pcie_portdrv_remove()

Jeff Layton <jlayton@redhat.com>
    audit: log the audit_names record type

Jeff Layton <jlayton@redhat.com>
    audit: add child record before the create to handle case where create fails

Jeff Layton <jlayton@redhat.com>
    audit: fix mq_open and mq_unlink to add the MQ root as a hidden parent audit_names record

Mathias Krause <minipli@googlemail.com>
    audit: fix info leak in AUDIT_GET requests

Mathias Krause <minipli@googlemail.com>
    audit: use nlmsg_len() to get message payload length

Tyler Hicks <tyhicks@canonical.com>
    audit: printk USER_AVC messages when audit isn't enabled

Ujjal Roy <royujjal@gmail.com>
    mwifiex: fix wrong eth_hdr usage for bridged packets in AP mode

Avinash Patil <patila@marvell.com>
    mwifiex: correct packet length for packets from SDIO interface

Dave Airlie <airlied@redhat.com>
    qxl: avoid an oops in the deferred io code.

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PM / runtime: Use pm_runtime_put_sync() in __device_release_driver()

Aaron Lu <aaron.lu@intel.com>
    PM / hibernate: Avoid overflow in hibernate_preallocate_memory()

Mikulas Patocka <mpatocka@redhat.com>
    blk-core: Fix memory corruption if blkcg_init_queue fails

Dan Williams <dan.j.williams@intel.com>
    ioatdma: fix selection of 16 vs 8 source path

Dan Williams <dan.j.williams@intel.com>
    ioatdma: fix sed pool selection

Mikulas Patocka <mpatocka@redhat.com>
    dm: allocate buffer for messages with small number of arguments using GFP_NOIO

Joe Thornber <ejt@redhat.com>
    dm cache: fix a race condition between queuing new migrations and quiescing for a shutdown

Joe Thornber <ejt@redhat.com>
    dm array: fix bug in growing array

Shiva Krishna Merla <shivakrishna.merla@netapp.com>
    dm mpath: fix race condition between multipath_dtr and pg_init_done

Rodolfo Giometti <giometti@enneenne.com>
    mmc: atmel-mci: fix oops in atmci_tasklet_func

Ludovic Desroches <ludovic.desroches@atmel.com>
    mmc: atmel-mci: abort transfer on timeout error

Akira Takeuchi <takeuchi.akr@jp.panasonic.com>
    mm: ensure get_unmapped_area() returns higher address than mmap_min_addr

Stanislaw Gruszka <stf_xl@wp.pl>
    rt2400pci: fix RSSI read

Ursula Braun <ursula.braun@de.ibm.com>
    qeth: avoid buffer overflow in snmp ioctl

Larry Finger <Larry.Finger@lwfinger.net>
    rtlwifi: rtl8192cu: Fix incorrect signal strength for unassociated AP

Larry Finger <Larry.Finger@lwfinger.net>
    rtlwifi: rtl8192se: Fix incorrect signal strength for unassociated AP

Larry Finger <Larry.Finger@lwfinger.net>
    rtlwifi: rtl8192de: Fix incorrect signal strength for unassociated AP

Vegard Nossum <vegard.nossum@oracle.com>
    xen/blkback: fix reference counting

Theodore Ts'o <tytso@mit.edu>
    ext4: avoid bh leak in retry path of ext4_expand_extra_isize_ea()

Huang Shijie <b32955@freescale.com>
    mtd: gpmi: fix kernel BUG due to racing DMA operations

Wang Haitao <wang.haitao1@zte.com.cn>
    mtd: map: fixed bug in 64-bit systems

Brian Norris <computersforpeace@gmail.com>
    mtd: nand: hack ONFI for non-power-of-2 dimensions

Mikulas Patocka <mpatocka@redhat.com>
    loop: fix crash when using unassigned loop device

Mikulas Patocka <mpatocka@redhat.com>
    loop: fix crash if blk_alloc_queue fails

Bart Van Assche <bvanassche@acm.org>
    IB/srp: Report receive errors correctly

Mike Marciniszyn <mike.marciniszyn@intel.com>
    IB/qib: Fix txselect regression

Jan Kara <jack@suse.cz>
    IB/ipath: Convert ipath_user_sdma_pin_pages() to use get_user_pages_fast()

Eric Seppanen <eric@purestorage.com>
    iscsi-target: chap auth shouldn't match username with trailing garbage

Eric Seppanen <eric@purestorage.com>
    iscsi-target: fix extract_param to handle buffer length corner case

Nicholas Bellinger <nab@linux-iscsi.org>
    iscsi-target: Fix mutex_trylock usage in iscsit_increment_maxcmdsn

Samir Benmendil <samir.benmendil@gmail.com>
    ahci: add Marvell 9230 to the AHCI PCI device list

xiangliang yu <yxlraid@gmail.com>
    ahci: disabled FBS prior to issuing software reset

James Ralston <james.d.ralston@intel.com>
    ahci: Add Device IDs for Intel Wildcat Point-LP

Manfred Spraul <manfred@colorfullife.com>
    ipc/sem.c: synchronize semop and semctl with IPC_RMID

Davidlohr Bueso <davidlohr@hp.com>
    ipc: update locking scheme comments

Mathias Krause <minipli@googlemail.com>
    ipc, msg: forbid negative values for "msg{max,mnb,mni}"

Mathias Krause <minipli@googlemail.com>
    ipc, msg: fix message length check for negative values

Larry Finger <Larry.Finger@lwfinger.net>
    rtlwifi: rtl8192cu: Fix more pointer arithmetic errors

Felipe Pena <felipensp@gmail.com>
    rtlwifi: rtl8192se: Fix wrong assignment

Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>
    rtlwifi: Fix endian error in extracting packet type

Larry Finger <Larry.Finger@lwfinger.net>
    rtlwifi: rtl8188ee: Fix smatch warning in rtl8188ee/hw.c

Ryan Mallon <rmallon@gmail.com>
    vsprintf: check real user/group id for %pK

Shan Hai <shan.hai@windriver.com>
    drivers/libata: Set max sector to 65535 for Slimtype DVD A DS8A9SH drive

Gwendal Grignou <gwendal@google.com>
    libata: Fix display of sata speed

Dan Carpenter <dan.carpenter@oracle.com>
    gpio: rcar: NULL dereference on error in probe()

Dan Carpenter <dan.carpenter@oracle.com>
    gpio: mvebu: make mvchip->irqbase signed for error handling

Tony Lindgren <tony@atomide.com>
    gpio: twl4030: Fix regression for twl gpio output

Stephen Warren <swarren@wwwdotorg.org>
    ARM: bcm2835: add missing #xxx-cells to I2C nodes

Doug Anderson <dianders@chromium.org>
    ARM: dts: Add max77686 RTC interrupt to cros5250-common

Ionut Nicu <ioan.nicu.ext@nsn.com>
    i2c: mux: gpio: use gpio_set_value_cansleep()

Ionut Nicu <ioan.nicu.ext@nsn.com>
    i2c: mux: gpio: use reg value for i2c_add_mux_adapter

Marc Kleine-Budde <mkl@pengutronix.de>
    can: flexcan: fix flexcan_chip_start() on imx6

Helge Deller <deller@gmx.de>
    parisc: break out SOCK_NONBLOCK define to own asm header file

Ilija Hadzic <ihadzic@research.bell-labs.com>
    devpts: plug the memory leak in kill_sb

Roel Kluin <roel.kluin@gmail.com>
    pinctrl: dove: unset twsi option3 for gconfig as well

KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
    alarmtimer: return EINVAL instead of ENOTSUPP if rtcdev doesn't exist

Michael Hudson-Doyle <michael.hudson@linaro.org>
    perf tools: Remove cast of non-variadic function to variadic

Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
    ASoC: wm5110: Add post SYSCLK register patch for rev D chip

Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
    ASoC: arizona: Set FLL to free-run before disabling

Oskar Schirmer <oskar@scara.com>
    ASoC: fsl: imx-pcm-fiq: omit fiq counter to avoid harm in unbalanced situations

Takashi Iwai <tiwai@suse.de>
    ASoC: blackfin: Fix missing break

Nicolin Chen <b42378@freescale.com>
    ASoC: wm8962: Turn on regcache_cache_only before disabling regulator

Brian Austin <brian.austin@cirrus.com>
    ASoC: cs42l52: Correct MIC CTL mask

Phil Edworthy <phil.edworthy@renesas.com>
    ASoC: ak4642: prevent un-necessary changes to SG_SL1

Johan Hovold <jhovold@gmail.com>
    backlight: atmel-pwm-bl: fix reported brightness

Johan Hovold <jhovold@gmail.com>
    backlight: atmel-pwm-bl: fix gpio polarity in remove

Malcolm Priestley <tvboxspy@gmail.com>
    staging: vt6656: [BUG] Fix for TX USB resets from vendors driver.

Olav Haugan <ohaugan@codeaurora.org>
    staging: zsmalloc: Ensure handle is never 0 on success

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Staging: tidspbridge: disable driver

Jiada Wang <jiada_wang@mentor.com>
    ARM: i.MX6q: fix the wrong parent of can_root clock

Johan Hovold <jhovold@gmail.com>
    ARM: at91: fix hanged boot due to early rtt-interrupt

Johan Hovold <jhovold@gmail.com>
    ARM: at91: fix hanged boot due to early rtc-interrupt

Jonathan Austin <jonathan.austin@arm.com>
    ARM: integrator_cp: Set LCD{0,1} enable lines when turning on CLCD

Marc Zyngier <Marc.Zyngier@arm.com>
    ARM: 7876/1: clear Thumb-2 IT state on exception handling

Russell King <rmk+kernel@arm.linux.org.uk>
    ARM: sa11x0/assabet: ensure CS2 is configured appropriately

Markus Pargmann <mpa@pengutronix.de>
    ARM: OMAP2+: irq, AM33XX add missing register check

Helge Deller <deller@gmx.de>
    parisc: sticon - unbreak on 64bit kernel


-------------

Diffstat:

 Documentation/sysctl/kernel.txt               |  25 ++--
 Makefile                                      |   4 +-
 arch/arm/boot/dts/bcm2835.dtsi                |   4 +
 arch/arm/boot/dts/cros5250-common.dtsi        |  12 ++
 arch/arm/kernel/entry-armv.S                  |   1 +
 arch/arm/mach-at91/Makefile                   |   2 +-
 arch/arm/mach-at91/at91sam9260.c              |   2 +
 arch/arm/mach-at91/at91sam9261.c              |   2 +
 arch/arm/mach-at91/at91sam9263.c              |   3 +
 arch/arm/mach-at91/at91sam9g45.c              |   3 +
 arch/arm/mach-at91/at91sam9n12.c              |   6 +
 arch/arm/mach-at91/at91sam9rl.c               |   3 +
 arch/arm/mach-at91/at91sam9x5.c               |   6 +
 arch/arm/mach-at91/generic.h                  |   2 +
 arch/arm/mach-at91/include/mach/at91sam9n12.h |   5 +
 arch/arm/mach-at91/include/mach/at91sam9x5.h  |   5 +
 arch/arm/mach-at91/include/mach/sama5d3.h     |   5 +
 arch/arm/mach-at91/sama5d3.c                  |   6 +
 arch/arm/mach-at91/sysirq_mask.c              |  71 +++++++++++
 arch/arm/mach-imx/clk-imx6q.c                 |   2 +-
 arch/arm/mach-integrator/integrator_cp.c      |   3 +-
 arch/arm/mach-omap2/irq.c                     |   2 +-
 arch/arm/mach-sa1100/assabet.c                |   3 +
 arch/arm/mm/extable.c                         |   7 +-
 arch/avr32/boot/u-boot/head.S                 |  35 +++++-
 arch/avr32/kernel/entry-avr32b.S              |   3 +-
 arch/avr32/kernel/head.S                      |  20 ----
 arch/parisc/include/asm/socket.h              |  11 ++
 arch/parisc/include/uapi/asm/socket.h         |  11 +-
 arch/powerpc/kernel/signal_32.c               |  16 ++-
 arch/powerpc/kernel/signal_64.c               |   6 +
 arch/s390/lib/uaccess_pt.c                    |   3 +
 block/blk-core.c                              |   4 +-
 crypto/asymmetric_keys/x509_public_key.c      |  38 ------
 drivers/acpi/pci_root.c                       |   3 +
 drivers/acpi/scan.c                           |   2 +-
 drivers/ata/ahci.c                            |   6 +
 drivers/ata/libahci.c                         |  16 +++
 drivers/ata/libata-core.c                     |   1 +
 drivers/ata/libata-transport.c                |  16 +--
 drivers/base/dd.c                             |   2 +-
 drivers/block/loop.c                          |  19 +--
 drivers/block/xen-blkback/blkback.c           |   3 +-
 drivers/clk/mvebu/clk-core.c                  |   4 +-
 drivers/cpufreq/highbank-cpufreq.c            |   3 +-
 drivers/dma/ioat/dma_v3.c                     |  46 +++----
 drivers/edac/highbank_l2_edac.c               |  18 +--
 drivers/edac/highbank_mc_edac.c               |  18 +--
 drivers/gpio/gpio-mvebu.c                     |   2 +-
 drivers/gpio/gpio-pl061.c                     |  10 +-
 drivers/gpio/gpio-rcar.c                      |   2 +-
 drivers/gpio/gpio-twl4030.c                   |   5 +-
 drivers/gpu/drm/i915/intel_display.c          |   4 +
 drivers/gpu/drm/nouveau/nouveau_gem.c         |   3 +-
 drivers/gpu/drm/qxl/qxl_fb.c                  |   2 +-
 drivers/gpu/drm/radeon/atombios_crtc.c        |   2 +-
 drivers/gpu/drm/radeon/evergreen_hdmi.c       |   3 +-
 drivers/gpu/drm/radeon/r600_hdmi.c            |  21 ++--
 drivers/gpu/drm/radeon/radeon_gart.c          |   2 +
 drivers/gpu/drm/radeon/radeon_legacy_crtc.c   |  28 +++++
 drivers/gpu/drm/radeon/radeon_uvd.c           |   2 +
 drivers/gpu/drm/radeon/sid.h                  |   2 +-
 drivers/gpu/drm/ttm/ttm_bo.c                  |  32 +++--
 drivers/gpu/drm/ttm/ttm_bo_util.c             |  30 +++--
 drivers/hid/Kconfig                           |  10 +-
 drivers/hid/hid-apple.c                       |  22 ++++
 drivers/hid/hid-axff.c                        |   3 +-
 drivers/hid/hid-core.c                        |  17 ++-
 drivers/hid/hid-ids.h                         |  13 ++
 drivers/hid/hid-lg.c                          |  80 +++++++++++++
 drivers/hid/hid-lg2ff.c                       |   2 +-
 drivers/hid/hid-lg4ff.c                       |  62 +++++++---
 drivers/hid/hid-multitouch.c                  |  33 ++++-
 drivers/hid/hid-roccat-common.c               |  12 +-
 drivers/hid/hid-roccat-kovaplus.c             |   4 +
 drivers/hid/hid-sensor-hub.c                  |  13 +-
 drivers/hid/uhid.c                            |   2 +-
 drivers/hid/usbhid/hid-quirks.c               |   2 +
 drivers/i2c/muxes/i2c-mux-gpio.c              |   8 +-
 drivers/iio/accel/kxsd9.c                     |   7 +-
 drivers/infiniband/hw/ipath/ipath_user_sdma.c |   7 +-
 drivers/infiniband/hw/qib/qib_iba7322.c       |  11 +-
 drivers/infiniband/ulp/srp/ib_srp.c           |   9 +-
 drivers/input/evdev.c                         |  16 ++-
 drivers/input/mouse/cypress_ps2.c             |  19 +--
 drivers/input/serio/i8042-x86ia64io.h         |   2 +
 drivers/input/touchscreen/usbtouchscreen.c    |   4 +-
 drivers/md/dm-cache-target.c                  |  54 ++++++---
 drivers/md/dm-mpath.c                         |  18 ++-
 drivers/md/dm-table.c                         |  18 ++-
 drivers/md/md.c                               |   1 +
 drivers/md/persistent-data/dm-array.c         |   5 +-
 drivers/media/dvb-frontends/af9013.c          |  14 ++-
 drivers/media/dvb-frontends/af9033.c          |  23 +++-
 drivers/media/dvb-frontends/bcm3510.c         |  15 ++-
 drivers/media/dvb-frontends/cxd2820r_core.c   |  21 +++-
 drivers/media/dvb-frontends/itd1000.c         |  13 +-
 drivers/media/dvb-frontends/mt312.c           |  10 +-
 drivers/media/dvb-frontends/nxt200x.c         |  11 +-
 drivers/media/dvb-frontends/rtl2830.c         |  14 ++-
 drivers/media/dvb-frontends/rtl2832.c         |  14 ++-
 drivers/media/dvb-frontends/s5h1420.c         |  11 +-
 drivers/media/dvb-frontends/stb0899_drv.c     |  12 +-
 drivers/media/dvb-frontends/stb6100.c         |  11 +-
 drivers/media/dvb-frontends/stv0367.c         |  13 +-
 drivers/media/dvb-frontends/stv090x.c         |  12 +-
 drivers/media/dvb-frontends/stv6110.c         |  12 +-
 drivers/media/dvb-frontends/stv6110x.c        |  13 +-
 drivers/media/dvb-frontends/tda10071.c        |  25 +++-
 drivers/media/dvb-frontends/tda18271c2dd.c    |  14 ++-
 drivers/media/dvb-frontends/zl10039.c         |  12 +-
 drivers/media/pci/cx18/cx18-driver.c          |  20 ++--
 drivers/media/pci/cx23885/cimax2.c            |  13 +-
 drivers/media/pci/cx23885/cx23885-dvb.c       |   4 +
 drivers/media/pci/ttpci/av7110_hw.c           |  19 ++-
 drivers/media/tuners/e4000.c                  |  25 +++-
 drivers/media/tuners/fc2580.c                 |  25 +++-
 drivers/media/tuners/tda18212.c               |  25 +++-
 drivers/media/tuners/tda18218.c               |  23 +++-
 drivers/media/tuners/tuner-xc2028.c           |   8 +-
 drivers/media/usb/dvb-usb-v2/af9015.c         |   3 +-
 drivers/media/usb/dvb-usb-v2/af9035.c         |  29 ++++-
 drivers/media/usb/dvb-usb-v2/mxl111sf.c       |  10 +-
 drivers/media/usb/dvb-usb/cxusb.c             |  41 ++++++-
 drivers/media/usb/dvb-usb/dibusb-common.c     |  10 +-
 drivers/media/usb/dvb-usb/dw2102.c            |  90 ++++++++++++--
 drivers/mmc/host/atmel-mci.c                  |  21 +++-
 drivers/mtd/nand/gpmi-nand/gpmi-nand.c        |   4 +-
 drivers/mtd/nand/nand_base.c                  |  15 ++-
 drivers/net/can/flexcan.c                     |  12 --
 drivers/net/wireless/iwlegacy/3945.c          |  31 +++--
 drivers/net/wireless/iwlegacy/4965-mac.c      |  18 ++-
 drivers/net/wireless/iwlwifi/iwl-trans.h      |   6 +-
 drivers/net/wireless/mwifiex/sdio.c           |   3 +
 drivers/net/wireless/mwifiex/uap_txrx.c       |  29 ++++-
 drivers/net/wireless/prism54/islpci_dev.c     |   7 +-
 drivers/net/wireless/rt2x00/rt2400pci.c       |   2 +-
 drivers/net/wireless/rtlwifi/base.c           |  93 +++++++--------
 drivers/net/wireless/rtlwifi/rtl8188ee/hw.c   |   1 +
 drivers/net/wireless/rtlwifi/rtl8192cu/mac.c  |   6 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/trx.c  |   8 +-
 drivers/net/wireless/rtlwifi/rtl8192de/trx.c  |   2 +-
 drivers/net/wireless/rtlwifi/rtl8192se/rf.c   |   2 +-
 drivers/net/wireless/rtlwifi/rtl8192se/trx.c  |   2 +-
 drivers/net/wireless/rtlwifi/wifi.h           |   6 +-
 drivers/net/xen-netback/interface.c           |  10 +-
 drivers/pci/pcie/portdrv_pci.c                |   1 -
 drivers/pinctrl/mvebu/pinctrl-dove.c          |   2 +-
 drivers/s390/net/qeth_core_main.c             |   6 +-
 drivers/staging/media/lirc/lirc_zilog.c       |  12 +-
 drivers/staging/tidspbridge/Kconfig           |   2 +-
 drivers/staging/vt6656/baseband.c             |  11 ++
 drivers/staging/vt6656/rndis.h                |   2 +
 drivers/staging/zsmalloc/zsmalloc-main.c      |  17 ++-
 drivers/target/iscsi/iscsi_target_auth.c      |   5 +-
 drivers/target/iscsi/iscsi_target_configfs.c  |   5 +
 drivers/target/iscsi/iscsi_target_device.c    |   6 +-
 drivers/target/iscsi/iscsi_target_nego.c      |   2 +-
 drivers/video/backlight/atmel-pwm-bl.c        |  10 +-
 drivers/video/console/sticore.c               | 166 ++++++++++++++++----------
 drivers/video/sticore.h                       |  62 ++++++++--
 drivers/video/stifb.c                         |  10 +-
 fs/cifs/cifssmb.c                             |   8 +-
 fs/devpts/inode.c                             |   1 +
 fs/ext4/xattr.c                               |   1 +
 fs/namei.c                                    |   1 +
 include/acpi/acpi_bus.h                       |   1 +
 include/linux/audit.h                         |  26 +++-
 include/linux/ipc_namespace.h                 |   6 +-
 include/linux/msg.h                           |   6 +-
 include/linux/mtd/map.h                       |   4 +-
 include/net/netfilter/nf_conntrack_extend.h   |   2 +-
 include/trace/ftrace.h                        |   5 +-
 ipc/ipc_sysctl.c                              |  20 ++--
 ipc/mqueue.c                                  |   2 +
 ipc/msgutil.c                                 |  20 ++--
 ipc/sem.c                                     |  42 +++++--
 ipc/util.c                                    |  27 ++++-
 ipc/util.h                                    |   4 +-
 kernel/audit.c                                |  27 ++++-
 kernel/audit.h                                |   1 +
 kernel/auditsc.c                              |  12 +-
 kernel/cgroup.c                               |  28 ++++-
 kernel/cpuset.c                               |   8 +-
 kernel/power/snapshot.c                       |   6 +-
 kernel/time/alarmtimer.c                      |   4 +-
 kernel/trace/ftrace.c                         |  64 +++++-----
 kernel/workqueue.c                            |  24 +++-
 lib/vsprintf.c                                |  33 ++++-
 mm/mmap.c                                     |  10 +-
 net/9p/trans_virtio.c                         |   5 +
 net/wireless/scan.c                           |   4 +-
 security/selinux/netlabel.c                   |   6 +-
 sound/pci/hda/hda_generic.c                   |  79 ++++++++----
 sound/pci/hda/patch_realtek.c                 |  11 ++
 sound/soc/blackfin/bf5xx-i2s.c                |   1 +
 sound/soc/codecs/ak4642.c                     |   2 +-
 sound/soc/codecs/arizona.c                    |   4 +
 sound/soc/codecs/cs42l52.h                    |   2 +-
 sound/soc/codecs/wm5110.c                     |  43 ++++++-
 sound/soc/codecs/wm8962.c                     |   2 +
 sound/soc/fsl/imx-pcm-fiq.c                   |  29 +++--
 tools/perf/ui/hist.c                          |   2 +-
 tools/perf/util/color.c                       |  11 +-
 tools/perf/util/color.h                       |   2 +-
 205 files changed, 2129 insertions(+), 771 deletions(-)



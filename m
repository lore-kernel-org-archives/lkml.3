Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751271Ab3EaNGo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 09:06:44 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33382 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752012Ab3EaNGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 09:06:31 -0400
Message-ID: <1370005571.3469.505.camel@deadeye.wl.decadent.org.uk>
Subject: Linux 3.2.46
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, Jiri Slaby <jslaby@suse.cz>,
        stable@vger.kernel.org
Cc: lwn@lwn.net
Date: Fri, 31 May 2013 14:06:11 +0100
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-XQ5xUwkzSnDFCC5HbVNt"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-XQ5xUwkzSnDFCC5HbVNt
Content-Type: multipart/mixed; boundary="=-NzSG5hEl+5MQYDZWXvGS"


--=-NzSG5hEl+5MQYDZWXvGS
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.2.46 kernel.

All users of the 3.2 kernel series should upgrade.

The updated 3.2.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.2.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git

The diff from 3.2.45 is attached to this message.

Ben.

------------

 Documentation/kernel-parameters.txt          |    6 ++
 Makefile                                     |    2 +-
 arch/arm/configs/at91sam9g45_defconfig       |    1 -
 arch/arm/mach-kirkwood/ts219-setup.c         |    2 +-
 arch/arm/plat-orion/common.c                 |   12 +--
 arch/avr32/configs/favr-32_defconfig         |    1 -
 arch/avr32/configs/merisc_defconfig          |    1 -
 arch/avr32/kernel/module.c                   |    2 +-
 arch/powerpc/include/asm/rtas.h              |    2 +
 arch/powerpc/kernel/rtas.c                   |  118 ++++++++++++++++++++++=
+++-
 arch/powerpc/platforms/pseries/suspend.c     |   28 +++++-
 arch/um/include/asm/pgtable.h                |    2 +
 arch/x86/kernel/irq.c                        |    4 -
 arch/x86/kvm/vmx.c                           |    6 ++
 arch/x86/platform/efi/efi.c                  |   43 ++++++++++
 arch/x86/xen/enlighten.c                     |   15 ++++
 drivers/acpi/acpica/exfldio.c                |   14 ++-
 drivers/acpi/ec.c                            |    4 +-
 drivers/acpi/video_detect.c                  |    8 ++
 drivers/block/brd.c                          |    4 +-
 drivers/block/drbd/drbd_receiver.c           |    1 -
 drivers/char/ipmi/ipmi_bt_sm.c               |    4 +-
 drivers/char/ipmi/ipmi_devintf.c             |   14 ++-
 drivers/char/random.c                        |   24 ++++--
 drivers/dma/pch_dma.c                        |    2 +-
 drivers/firmware/efivars.c                   |   18 +---
 drivers/gpu/drm/i915/i915_dma.c              |   81 +++++++++---------
 drivers/gpu/drm/i915/i915_drv.h              |    1 -
 drivers/gpu/drm/radeon/r300_cmdbuf.c         |    2 +-
 drivers/hwmon/abituguru.c                    |   16 ++--
 drivers/i2c/busses/i2c-designware-core.c     |    3 +-
 drivers/md/dm-bufio.c                        |   26 +++++-
 drivers/md/dm-snap.c                         |    1 +
 drivers/media/dvb/mantis/mantis_dvb.c        |    6 +-
 drivers/mfd/adp5520.c                        |    8 +-
 drivers/mmc/core/mmc.c                       |    2 +-
 drivers/mmc/host/Kconfig                     |   10 ---
 drivers/mmc/host/atmel-mci.c                 |   16 ++--
 drivers/net/ethernet/3com/3c509.c            |    2 +
 drivers/net/ethernet/3com/3c59x.c            |   27 +++---
 drivers/net/ethernet/broadcom/tg3.c          |   32 +++++--
 drivers/net/ethernet/ibm/ibmveth.c           |   23 +++--
 drivers/net/macvlan.c                        |    7 +-
 drivers/net/wireless/ath/ath9k/main.c        |    6 +-
 drivers/net/wireless/b43/dma.c               |   19 +++++
 drivers/net/wireless/b43/dma.h               |    4 +-
 drivers/net/wireless/b43/main.c              |   43 ++++------
 drivers/net/wireless/mwifiex/cfg80211.c      |    3 -
 drivers/net/wireless/mwifiex/cmdevt.c        |    1 +
 drivers/net/wireless/mwifiex/main.c          |    1 +
 drivers/net/wireless/mwifiex/sta_ioctl.c     |   21 ++---
 drivers/platform/x86/hp_accel.c              |    3 +-
 drivers/rapidio/devices/tsi721.c             |   11 +++
 drivers/rtc/rtc-pcf2123.c                    |    1 +
 drivers/staging/comedi/comedi_fops.c         |    3 +
 drivers/staging/vt6656/hostap.c              |    2 +-
 drivers/target/iscsi/iscsi_target_erl1.c     |    7 +-
 drivers/tty/n_tty.c                          |    8 ++
 drivers/usb/atm/cxacru.c                     |    3 +-
 drivers/usb/core/quirks.c                    |    3 +
 drivers/usb/host/uhci-hub.c                  |    3 +-
 drivers/usb/host/xhci-mem.c                  |   17 ++--
 drivers/usb/host/xhci-ring.c                 |   23 +++--
 drivers/usb/serial/ftdi_sio.c                |    2 +
 drivers/usb/serial/ftdi_sio_ids.h            |    2 +
 drivers/usb/serial/option.c                  |   13 ++-
 fs/autofs4/expire.c                          |    9 --
 fs/btrfs/ioctl.c                             |   10 +--
 fs/cifs/inode.c                              |    3 +-
 fs/ext4/mballoc.c                            |    6 +-
 fs/fat/inode.c                               |   15 +++-
 fs/nfsd/nfs4proc.c                           |   15 +++-
 fs/nilfs2/inode.c                            |   27 +++++-
 fs/ocfs2/extent_map.c                        |    2 +-
 include/linux/efi.h                          |   11 ++-
 include/linux/if_cablemodem.h                |   12 +--
 include/linux/rculist.h                      |   17 ++++
 include/linux/virtio_console.h               |    2 +-
 include/linux/wait.h                         |   16 ++--
 include/net/sock.h                           |   12 +++
 include/net/tcp.h                            |    1 +
 kernel/kmod.c                                |    5 ++
 kernel/sched.c                               |   35 +++++---
 kernel/time/tick-sched.c                     |    2 +-
 kernel/timer.c                               |    2 +-
 kernel/trace/trace_events_filter.c           |    4 +
 mm/huge_memory.c                             |    7 +-
 mm/migrate.c                                 |    2 +-
 mm/mmu_notifier.c                            |   80 ++++++++---------
 mm/pagewalk.c                                |   70 +++++++--------
 net/bridge/br_stp_timer.c                    |    2 +-
 net/core/sock.c                              |   12 ---
 net/ipv6/tcp_ipv6.c                          |   12 +++
 net/ipv6/udp.c                               |   13 ++-
 net/ipv6/udp_impl.h                          |    2 +
 net/ipv6/udplite.c                           |    2 +-
 net/ipv6/xfrm6_policy.c                      |    4 +-
 net/netfilter/ipvs/ip_vs_pe_sip.c            |    6 +-
 net/packet/af_packet.c                       |   54 +++++-------
 net/sched/act_ipt.c                          |   33 ++++++-
 net/sunrpc/sched.c                           |   13 ++-
 sound/pci/hda/hda_codec.c                    |    3 +
 sound/soc/codecs/wm8994.c                    |    1 +
 tools/perf/scripts/python/net_dropmonitor.py |    8 +-
 104 files changed, 905 insertions(+), 425 deletions(-)

Alan Cox (1):
      [media] mantis: fix silly crash case

Alan Stern (2):
      USB: xHCI: override bogus bulk wMaxPacketSize values
      USB: UHCI: fix for suspend of virtual HP controller

Alexandre Bounine (1):
      rapidio/tsi721: fix bug in MSI interrupt handling

Amitkumar Karwar (1):
      mwifiex: fix memory leak issue when driver unload

Aneesh Kumar K.V (1):
      mm/THP: use pmd_populate() to update the pmd with pgtable_t pointer

Bastian Triller (1):
      ACPI / video: Add "Asus UL30A" to ACPI video detect blacklist

Ben Hutchings (4):
      Revert "drm/i915: Fix detection of base of stolen memory"
      perf: net_dropmonitor: Fix trace parameter order
      perf: net_dropmonitor: Fix symbol-relative addresses
      Linux 3.2.46

Benjamin Herrenschmidt (1):
      net/eth/ibmveth: Fixup retrieval of MAC address

Benjamin LaHaise (1):
      ipmi: ipmi_devintf: compat_ioctl method fails to take ipmi_mutex

Bing Zhao (1):
      mwifiex: clear is_suspended flag when interrupt is received early

Bob Moore (1):
      ACPICA: Fix possible buffer overflow during a field unit read operati=
on

Brian Behlendorf (1):
      drivers/block/brd.c: fix brd_lookup_page() race

Brian King (1):
      powerpc/pseries: Fix partition migration hang in stop_topology_update

Chen Gang (1):
      drivers/char/ipmi: memcpy, need additional 2 bytes to avoid memory ov=
erflow

Cliff Wickman (1):
      mm/pagewalk.c: walk_page_range should avoid VM_PFNMAP areas

Cong Wang (1):
      xfrm6: release dev before returning error

Dan Carpenter (2):
      ASoC: wm8994: missing break in wm8994_aif3_hw_params()
      USB: cxacru: potential underflow in cxacru_cm_get_array()

Dan Williams (1):
      USB: option: add device IDs for Dell 5804 (Novatel E371) WWAN card

Daniel Borkmann (1):
      packet: tpacket_v3: do not trigger bug() on wrong  header status

Daniel Drake (1):
      mwifiex: fix setting of multicast filter

David Jeffery (1):
      autofs - remove autofs dentry mount check

Eric Dumazet (2):
      tcp: force a dst refcount when prequeue packet
      ipv6: do not clear pinet6 field

Felix Fietkau (1):
      ath9k: fix key allocation error handling for powersave keys

Gabriel de Perthuis (1):
      btrfs: don't stop searching after encountering the wrong item

Gleb Natapov (1):
      KVM: VMX: fix halt emulation while emulating invalid guest sate

Gomella, Andrew (NIH/NHLBI) [F] (1):
      USB: ftdi_sio: Add support for Newport CONEX motor drivers

Gregory CLEMENT (1):
      ARM: plat-orion: Fix num_resources and id for ge10 and ge11

Hans Schillstrom (1):
      ipvs: ip_vs_sip_fill_param() BUG: bad check of return value

Hans-Christian Egtvedt (1):
      avr32: fix relocation check for signed 18-bit offset

Hema Prathaban (1):
      staging: vt6656: use free_netdev instead of kfree

Ian Abbott (1):
      staging: comedi: prevent auto-unconfig of manually configured devices

Imre Deak (1):
      wait: fix false timeouts when using wait_event_timeout()

J. Bruce Fields (1):
      nfsd4: don't allow owner override on 4.1 CLAIM_FH opens

Jamal Hadi Salim (1):
      net_sched: act_ipt forward compat with xtables

Jeff Layton (2):
      cifs: only set ops for inodes in I_NEW state
      sunrpc: clarify comments on rpc_make_runnable

Jiri Kosina (1):
      random: fix accounting race condition with lockless irq entropy_count=
 update

Jiri Pirko (1):
      macvlan: fix passthru mode race between dev removal  and rx path

Johan Hovold (1):
      mmc: at91/avr32/atmel-mci: fix DMA-channel leak on module unload

Joseph Qi (1):
      ocfs2: goto out_unlock if ocfs2_get_clusters_nocache() failed in ocfs=
2_fiemap()

Josh Boyer (1):
      if_cablemodem.h: Add parenthesis around ioctl macros

Kees Cook (1):
      drm/radeon: check incoming cliprects pointer

Konrad Rzeszutek Wilk (1):
      xen/vcpu/pvhvm: Fix vcpu hotplugging hanging.

Lachlan McIlroy (1):
      ext4: limit group search loop for non-extent files

Lan Tianyu (1):
      ACPI / EC: Restart transaction even when the IBF flag set

Lars-Peter Clausen (1):
      mfd: adp5520: Restore mode bits on resume

Leonid Yegoshin (1):
      mm compaction: fix of improper cache flush in migration code

Li Fei (1):
      x86: Eliminate irq_mis_count counted in arch_irq_stat

Martin Michlmayr (1):
      Kirkwood: Enable PCIe port 1 on QNAP TS-11x/TS-21x

Matt Fleming (1):
      x86, efivars: firmware bug workarounds should be in platform code

Matthew Whitehead (1):
      3c509.c: call SET_NETDEV_DEV for all device types  (ISA/ISAPnP/EISA)

Michael S. Tsirkin (1):
      virtio_console: fix uapi header

Mika Westerberg (1):
      i2c: designware: always clear interrupts before enabling them

Mikulas Patocka (1):
      dm bufio: avoid a possible __vmalloc deadlock

Namhyung Kim (1):
      sched/debug: Limit sd->*_idx range on sysctl

Nithin Sujir (1):
      tg3: Skip powering down function 0 on certain serdes devices

OGAWA Hirofumi (1):
      fat: fix possible overflow for fat_clusters

Oleg Nesterov (1):
      usermodehelper: check subprocess_info->path !=3D NULL

Oliver Neukum (1):
      USB: reset resume quirk needed by a hub

Philip Rakity (1):
      mmc: core: Fix bit width test failing on old eMMC cards

Philipp Reisner (1):
      drbd: fix for deadlock when using automatic split-brain-recovery

Richard Weinberger (3):
      x86,efi: Check max_size only if it is non-zero.
      x86,efi: Implement efi_no_storage_paranoia parameter
      um: Serve io_remap_pfn_range()

Robert Jennings (1):
      powerpc: Bring all threads online prior to migration/hibernation

Ryusuke Konishi (1):
      nilfs2: fix issue of nilfs_set_page_dirty() for page at EOF boundary

Sarah Sharp (1):
      xhci: Don't warn on empty ring for suspended devices.

Schemmel Hans-Christoph (1):
      USB: Blacklisted Cinterion's PLxx WWAN Interface

Sergei Shtylyov (2):
      3c59x: fix freeing nonexistent resource on driver  unload
      3c59x: fix PCI resource management

Sergey Vlasov (1):
      efi: Export efi_query_variable_store() for efivars.ko

Shlomo Pongratz (1):
      iscsi-target: Fix processing of OOO commands

Shuah Khan (1):
      hp_accel: Ignore the error from lis3lv02d_poweron() at resume

Steven Rostedt (Red Hat) (1):
      tracing: Fix leaks of filter preds

Teppo Kotilainen (1):
      usb: option: Add Telewell TW-LTE 4G

Terry Barnaby (1):
      mmc: atmel-mci: pio hang on block errors

Thomas Gleixner (1):
      tick: Cleanup NOHZ per cpu data on cpu down

Thommy Jakobsson (1):
      B43: Handle DMA RX descriptor underrun

Tirupathi Reddy (1):
      timer: Don't reinitialize the cpu base lock during CPU_UP_PREPARE

Tomoya MORINAGA (1):
      pch_dma: Use GFP_ATOMIC because called from interrupt context

Trond Myklebust (1):
      SUNRPC: Prevent an rpc_task wakeup race

Wang YanQing (2):
      ALSA: HDA: Fix Oops caused by dereference NULL pointer
      TTY: Fix tty miss restart after we turn off flow-control

Wei Yongjun (3):
      dm snapshot: fix error return code in snapshot_ctr
      hwmon: fix error return code in abituguru_probe()
      drivers/rtc/rtc-pcf2123.c: fix error return code in pcf2123_probe()

Xiao Guangrong (1):
      mm: mmu_notifier: re-fix freed page still mapped in secondary MMU

libin (1):
      sched/debug: Fix sd->*_idx limit range avoiding overflow

stephen hemminger (1):
      bridge: fix race with topology change timer


--=20
Ben Hutchings
If at first you don't succeed, you're doing about average.

--=-NzSG5hEl+5MQYDZWXvGS
Content-Type: text/x-diff; charset="UTF-8"; name="linux-3.2.46.patch"
Content-Disposition: attachment; filename="linux-3.2.46.patch"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL0RvY3VtZW50YXRpb24va2VybmVsLXBhcmFtZXRlcnMudHh0IGIvRG9jdW1l
bnRhdGlvbi9rZXJuZWwtcGFyYW1ldGVycy50eHQNCmluZGV4IDg5N2YyMjMuLjJiYTgyNzIgMTAw
NjQ0DQotLS0gYS9Eb2N1bWVudGF0aW9uL2tlcm5lbC1wYXJhbWV0ZXJzLnR4dA0KKysrIGIvRG9j
dW1lbnRhdGlvbi9rZXJuZWwtcGFyYW1ldGVycy50eHQNCkBAIC03MzQsNiArNzM0LDEyIEBAIGJ5
dGVzIHJlc3BlY3RpdmVseS4gU3VjaCBsZXR0ZXIgc3VmZml4ZXMgY2FuIGFsc28gYmUgZW50aXJl
bHkgb21pdHRlZC4NCiAJZWRkPQkJW0VERF0NCiAJCQlGb3JtYXQ6IHsib2ZmIiB8ICJvbiIgfCAi
c2tpcFttYnJdIn0NCiANCisJZWZpX25vX3N0b3JhZ2VfcGFyYW5vaWEgW0VGSTsgWDg2XQ0KKwkJ
CVVzaW5nIHRoaXMgcGFyYW1ldGVyIHlvdSBjYW4gdXNlIG1vcmUgdGhhbiA1MCUgb2YNCisJCQl5
b3VyIGVmaSB2YXJpYWJsZSBzdG9yYWdlLiBVc2UgdGhpcyBwYXJhbWV0ZXIgb25seSBpZg0KKwkJ
CXlvdSBhcmUgcmVhbGx5IHN1cmUgdGhhdCB5b3VyIFVFRkkgZG9lcyBzYW5lIGdjIGFuZA0KKwkJ
CWZ1bGZpbGxzIHRoZSBzcGVjIG90aGVyd2lzZSB5b3VyIGJvYXJkIG1heSBicmljay4NCisNCiAJ
ZWlzYV9pcnFfZWRnZT0JW1BBUklTQyxIV10NCiAJCQlTZWUgaGVhZGVyIG9mIGRyaXZlcnMvcGFy
aXNjL2Vpc2EuYy4NCiANCmRpZmYgLS1naXQgYS9NYWtlZmlsZSBiL01ha2VmaWxlDQppbmRleCA5
MDcyZmVlLi5mNjAwNTgyIDEwMDY0NA0KLS0tIGEvTWFrZWZpbGUNCisrKyBiL01ha2VmaWxlDQpA
QCAtMSw2ICsxLDYgQEANCiBWRVJTSU9OID0gMw0KIFBBVENITEVWRUwgPSAyDQotU1VCTEVWRUwg
PSA0NQ0KK1NVQkxFVkVMID0gNDYNCiBFWFRSQVZFUlNJT04gPQ0KIE5BTUUgPSBTYWJlci10b290
aGVkIFNxdWlycmVsDQogDQpkaWZmIC0tZ2l0IGEvYXJjaC9hcm0vY29uZmlncy9hdDkxc2FtOWc0
NV9kZWZjb25maWcgYi9hcmNoL2FybS9jb25maWdzL2F0OTFzYW05ZzQ1X2RlZmNvbmZpZw0KaW5k
ZXggNjA2ZDQ4Zi4uOGFhYjc4NiAxMDA2NDQNCi0tLSBhL2FyY2gvYXJtL2NvbmZpZ3MvYXQ5MXNh
bTlnNDVfZGVmY29uZmlnDQorKysgYi9hcmNoL2FybS9jb25maWdzL2F0OTFzYW05ZzQ1X2RlZmNv
bmZpZw0KQEAgLTE3Myw3ICsxNzMsNiBAQCBDT05GSUdfTU1DPXkNCiAjIENPTkZJR19NTUNfQkxP
Q0tfQk9VTkNFIGlzIG5vdCBzZXQNCiBDT05GSUdfU0RJT19VQVJUPW0NCiBDT05GSUdfTU1DX0FU
TUVMTUNJPXkNCi1DT05GSUdfTU1DX0FUTUVMTUNJX0RNQT15DQogQ09ORklHX0xFRFNfQVRNRUxf
UFdNPXkNCiBDT05GSUdfTEVEU19HUElPPXkNCiBDT05GSUdfTEVEU19UUklHR0VSX1RJTUVSPXkN
CmRpZmYgLS1naXQgYS9hcmNoL2FybS9tYWNoLWtpcmt3b29kL3RzMjE5LXNldHVwLmMgYi9hcmNo
L2FybS9tYWNoLWtpcmt3b29kL3RzMjE5LXNldHVwLmMNCmluZGV4IDI2MmMwMzQuLjNkMDczN2Ug
MTAwNjQ0DQotLS0gYS9hcmNoL2FybS9tYWNoLWtpcmt3b29kL3RzMjE5LXNldHVwLmMNCisrKyBi
L2FyY2gvYXJtL21hY2gta2lya3dvb2QvdHMyMTktc2V0dXAuYw0KQEAgLTEyNCw3ICsxMjQsNyBA
QCBzdGF0aWMgdm9pZCBfX2luaXQgcW5hcF90czIxOV9pbml0KHZvaWQpDQogc3RhdGljIGludCBf
X2luaXQgdHMyMTlfcGNpX2luaXQodm9pZCkNCiB7DQogCWlmIChtYWNoaW5lX2lzX3RzMjE5KCkp
DQotCQlraXJrd29vZF9wY2llX2luaXQoS1dfUENJRTApOw0KKwkJa2lya3dvb2RfcGNpZV9pbml0
KEtXX1BDSUUxIHwgS1dfUENJRTApOw0KIA0KIAlyZXR1cm4gMDsNCiB9DQpkaWZmIC0tZ2l0IGEv
YXJjaC9hcm0vcGxhdC1vcmlvbi9jb21tb24uYyBiL2FyY2gvYXJtL3BsYXQtb3Jpb24vY29tbW9u
LmMNCmluZGV4IDhhNjg4NmEuLmM3MmIwODMgMTAwNjQ0DQotLS0gYS9hcmNoL2FybS9wbGF0LW9y
aW9uL2NvbW1vbi5jDQorKysgYi9hcmNoL2FybS9wbGF0LW9yaW9uL2NvbW1vbi5jDQpAQCAtMzQ3
LDcgKzM0Nyw3IEBAIHN0YXRpYyBzdHJ1Y3QgcmVzb3VyY2Ugb3Jpb25fZ2UxMF9zaGFyZWRfcmVz
b3VyY2VzW10gPSB7DQogDQogc3RhdGljIHN0cnVjdCBwbGF0Zm9ybV9kZXZpY2Ugb3Jpb25fZ2Ux
MF9zaGFyZWQgPSB7DQogCS5uYW1lCQk9IE1WNjQzWFhfRVRIX1NIQVJFRF9OQU1FLA0KLQkuaWQJ
CT0gMSwNCisJLmlkCQk9IDIsDQogCS5kZXYJCT0gew0KIAkJLnBsYXRmb3JtX2RhdGEJPSAmb3Jp
b25fZ2UxMF9zaGFyZWRfZGF0YSwNCiAJfSwNCkBAIC0zNjIsOCArMzYyLDggQEAgc3RhdGljIHN0
cnVjdCByZXNvdXJjZSBvcmlvbl9nZTEwX3Jlc291cmNlc1tdID0gew0KIA0KIHN0YXRpYyBzdHJ1
Y3QgcGxhdGZvcm1fZGV2aWNlIG9yaW9uX2dlMTAgPSB7DQogCS5uYW1lCQk9IE1WNjQzWFhfRVRI
X05BTUUsDQotCS5pZAkJPSAxLA0KLQkubnVtX3Jlc291cmNlcwk9IDIsDQorCS5pZAkJPSAyLA0K
KwkubnVtX3Jlc291cmNlcwk9IDEsDQogCS5yZXNvdXJjZQk9IG9yaW9uX2dlMTBfcmVzb3VyY2Vz
LA0KIAkuZGV2CQk9IHsNCiAJCS5jb2hlcmVudF9kbWFfbWFzawk9IERNQV9CSVRfTUFTSygzMiks
DQpAQCAtNDAxLDcgKzQwMSw3IEBAIHN0YXRpYyBzdHJ1Y3QgcmVzb3VyY2Ugb3Jpb25fZ2UxMV9z
aGFyZWRfcmVzb3VyY2VzW10gPSB7DQogDQogc3RhdGljIHN0cnVjdCBwbGF0Zm9ybV9kZXZpY2Ug
b3Jpb25fZ2UxMV9zaGFyZWQgPSB7DQogCS5uYW1lCQk9IE1WNjQzWFhfRVRIX1NIQVJFRF9OQU1F
LA0KLQkuaWQJCT0gMSwNCisJLmlkCQk9IDMsDQogCS5kZXYJCT0gew0KIAkJLnBsYXRmb3JtX2Rh
dGEJPSAmb3Jpb25fZ2UxMV9zaGFyZWRfZGF0YSwNCiAJfSwNCkBAIC00MTYsOCArNDE2LDggQEAg
c3RhdGljIHN0cnVjdCByZXNvdXJjZSBvcmlvbl9nZTExX3Jlc291cmNlc1tdID0gew0KIA0KIHN0
YXRpYyBzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlIG9yaW9uX2dlMTEgPSB7DQogCS5uYW1lCQk9IE1W
NjQzWFhfRVRIX05BTUUsDQotCS5pZAkJPSAxLA0KLQkubnVtX3Jlc291cmNlcwk9IDIsDQorCS5p
ZAkJPSAzLA0KKwkubnVtX3Jlc291cmNlcwk9IDEsDQogCS5yZXNvdXJjZQk9IG9yaW9uX2dlMTFf
cmVzb3VyY2VzLA0KIAkuZGV2CQk9IHsNCiAJCS5jb2hlcmVudF9kbWFfbWFzawk9IERNQV9CSVRf
TUFTSygzMiksDQpkaWZmIC0tZ2l0IGEvYXJjaC9hdnIzMi9jb25maWdzL2ZhdnItMzJfZGVmY29u
ZmlnIGIvYXJjaC9hdnIzMi9jb25maWdzL2ZhdnItMzJfZGVmY29uZmlnDQppbmRleCAxOTk3M2Iw
Li41OWU0Y2M5IDEwMDY0NA0KLS0tIGEvYXJjaC9hdnIzMi9jb25maWdzL2ZhdnItMzJfZGVmY29u
ZmlnDQorKysgYi9hcmNoL2F2cjMyL2NvbmZpZ3MvZmF2ci0zMl9kZWZjb25maWcNCkBAIC0xMjIs
NyArMTIyLDYgQEAgQ09ORklHX1VTQl9HX1NFUklBTD1tDQogQ09ORklHX1VTQl9DRENfQ09NUE9T
SVRFPW0NCiBDT05GSUdfTU1DPXkNCiBDT05GSUdfTU1DX0FUTUVMTUNJPXkNCi1DT05GSUdfTU1D
X0FUTUVMTUNJX0RNQT15DQogQ09ORklHX05FV19MRURTPXkNCiBDT05GSUdfTEVEU19DTEFTUz15
DQogQ09ORklHX0xFRFNfQVRNRUxfUFdNPW0NCmRpZmYgLS1naXQgYS9hcmNoL2F2cjMyL2NvbmZp
Z3MvbWVyaXNjX2RlZmNvbmZpZyBiL2FyY2gvYXZyMzIvY29uZmlncy9tZXJpc2NfZGVmY29uZmln
DQppbmRleCAzYmVmYWI5Li42NWRlNDQzIDEwMDY0NA0KLS0tIGEvYXJjaC9hdnIzMi9jb25maWdz
L21lcmlzY19kZWZjb25maWcNCisrKyBiL2FyY2gvYXZyMzIvY29uZmlncy9tZXJpc2NfZGVmY29u
ZmlnDQpAQCAtMTAyLDcgKzEwMiw2IEBAIENPTkZJR19GUkFNRUJVRkZFUl9DT05TT0xFPXkNCiBD
T05GSUdfTE9HTz15DQogQ09ORklHX01NQz15DQogQ09ORklHX01NQ19BVE1FTE1DST15DQotQ09O
RklHX01NQ19BVE1FTE1DSV9ETUE9eQ0KIENPTkZJR19ORVdfTEVEUz15DQogQ09ORklHX0xFRFNf
Q0xBU1M9eQ0KIENPTkZJR19MRURTX0FUTUVMX1BXTT15DQpkaWZmIC0tZ2l0IGEvYXJjaC9hdnIz
Mi9rZXJuZWwvbW9kdWxlLmMgYi9hcmNoL2F2cjMyL2tlcm5lbC9tb2R1bGUuYw0KaW5kZXggNTk2
ZjczMC4uMmM5NDEyOSAxMDA2NDQNCi0tLSBhL2FyY2gvYXZyMzIva2VybmVsL21vZHVsZS5jDQor
KysgYi9hcmNoL2F2cjMyL2tlcm5lbC9tb2R1bGUuYw0KQEAgLTI2NCw3ICsyNjQsNyBAQCBpbnQg
YXBwbHlfcmVsb2NhdGVfYWRkKEVsZjMyX1NoZHIgKnNlY2hkcnMsIGNvbnN0IGNoYXIgKnN0cnRh
YiwNCiAJCQlicmVhazsNCiAJCWNhc2UgUl9BVlIzMl9HT1QxOFNXOg0KIAkJCWlmICgocmVsb2Nh
dGlvbiAmIDB4ZmZmZTAwMDMpICE9IDANCi0JCQkgICAgJiYgKHJlbG9jYXRpb24gJiAweGZmZmMw
MDAzKSAhPSAweGZmZmYwMDAwKQ0KKwkJCSAgICAmJiAocmVsb2NhdGlvbiAmIDB4ZmZmYzAwMDAp
ICE9IDB4ZmZmYzAwMDApDQogCQkJCXJldHVybiByZWxvY19vdmVyZmxvdyhtb2R1bGUsICJSX0FW
UjMyX0dPVDE4U1ciLA0KIAkJCQkJCSAgICAgcmVsb2NhdGlvbik7DQogCQkJcmVsb2NhdGlvbiA+
Pj0gMjsNCmRpZmYgLS1naXQgYS9hcmNoL3Bvd2VycGMvaW5jbHVkZS9hc20vcnRhcy5oIGIvYXJj
aC9wb3dlcnBjL2luY2x1ZGUvYXNtL3J0YXMuaA0KaW5kZXggNDFmNjlhZS4uOGMzZWZkMiAxMDA2
NDQNCi0tLSBhL2FyY2gvcG93ZXJwYy9pbmNsdWRlL2FzbS9ydGFzLmgNCisrKyBiL2FyY2gvcG93
ZXJwYy9pbmNsdWRlL2FzbS9ydGFzLmgNCkBAIC0yMzAsNiArMjMwLDggQEAgZXh0ZXJuIHZvaWQg
cnRhc19wcm9ncmVzcyhjaGFyICpzLCB1bnNpZ25lZCBzaG9ydCBoZXgpOw0KIGV4dGVybiB2b2lk
IHJ0YXNfaW5pdGlhbGl6ZSh2b2lkKTsNCiBleHRlcm4gaW50IHJ0YXNfc3VzcGVuZF9jcHUoc3Ry
dWN0IHJ0YXNfc3VzcGVuZF9tZV9kYXRhICpkYXRhKTsNCiBleHRlcm4gaW50IHJ0YXNfc3VzcGVu
ZF9sYXN0X2NwdShzdHJ1Y3QgcnRhc19zdXNwZW5kX21lX2RhdGEgKmRhdGEpOw0KK2V4dGVybiBp
bnQgcnRhc19vbmxpbmVfY3B1c19tYXNrKGNwdW1hc2tfdmFyX3QgY3B1cyk7DQorZXh0ZXJuIGlu
dCBydGFzX29mZmxpbmVfY3B1c19tYXNrKGNwdW1hc2tfdmFyX3QgY3B1cyk7DQogZXh0ZXJuIGlu
dCBydGFzX2libV9zdXNwZW5kX21lKHN0cnVjdCBydGFzX2FyZ3MgKik7DQogDQogc3RydWN0IHJ0
Y190aW1lOw0KZGlmZiAtLWdpdCBhL2FyY2gvcG93ZXJwYy9rZXJuZWwvcnRhcy5jIGIvYXJjaC9w
b3dlcnBjL2tlcm5lbC9ydGFzLmMNCmluZGV4IDUxN2IxZDguLjQzNGExODAgMTAwNjQ0DQotLS0g
YS9hcmNoL3Bvd2VycGMva2VybmVsL3J0YXMuYw0KKysrIGIvYXJjaC9wb3dlcnBjL2tlcm5lbC9y
dGFzLmMNCkBAIC0xOSw2ICsxOSw3IEBADQogI2luY2x1ZGUgPGxpbnV4L2luaXQuaD4NCiAjaW5j
bHVkZSA8bGludXgvY2FwYWJpbGl0eS5oPg0KICNpbmNsdWRlIDxsaW51eC9kZWxheS5oPg0KKyNp
bmNsdWRlIDxsaW51eC9jcHUuaD4NCiAjaW5jbHVkZSA8bGludXgvc21wLmg+DQogI2luY2x1ZGUg
PGxpbnV4L2NvbXBsZXRpb24uaD4NCiAjaW5jbHVkZSA8bGludXgvY3B1bWFzay5oPg0KQEAgLTcx
Niw3ICs3MTcsNiBAQCBzdGF0aWMgaW50IF9fcnRhc19zdXNwZW5kX2xhc3RfY3B1KHN0cnVjdCBy
dGFzX3N1c3BlbmRfbWVfZGF0YSAqZGF0YSwgaW50IHdha2Vfdw0KIAlpbnQgY3B1Ow0KIA0KIAlz
bGJfc2V0X3NpemUoU0xCX01JTl9TSVpFKTsNCi0Jc3RvcF90b3BvbG9neV91cGRhdGUoKTsNCiAJ
cHJpbnRrKEtFUk5fREVCVUcgImNhbGxpbmcgaWJtLHN1c3BlbmQtbWUgb24gY3B1ICVpXG4iLCBz
bXBfcHJvY2Vzc29yX2lkKCkpOw0KIA0KIAl3aGlsZSAocmMgPT0gSF9NVUxUSV9USFJFQURTX0FD
VElWRSAmJiAhYXRvbWljX3JlYWQoJmRhdGEtPmRvbmUpICYmDQpAQCAtNzMyLDcgKzczMiw2IEBA
IHN0YXRpYyBpbnQgX19ydGFzX3N1c3BlbmRfbGFzdF9jcHUoc3RydWN0IHJ0YXNfc3VzcGVuZF9t
ZV9kYXRhICpkYXRhLCBpbnQgd2FrZV93DQogCQlyYyA9IGF0b21pY19yZWFkKCZkYXRhLT5lcnJv
cik7DQogDQogCWF0b21pY19zZXQoJmRhdGEtPmVycm9yLCByYyk7DQotCXN0YXJ0X3RvcG9sb2d5
X3VwZGF0ZSgpOw0KIAlwU2VyaWVzX2NvYWxlc2NlX2luaXQoKTsNCiANCiAJaWYgKHdha2Vfd2hl
bl9kb25lKSB7DQpAQCAtODExLDYgKzgxMCw5NSBAQCBzdGF0aWMgdm9pZCBydGFzX3BlcmNwdV9z
dXNwZW5kX21lKHZvaWQgKmluZm8pDQogCV9fcnRhc19zdXNwZW5kX2NwdSgoc3RydWN0IHJ0YXNf
c3VzcGVuZF9tZV9kYXRhICopaW5mbywgMSk7DQogfQ0KIA0KK2VudW0gcnRhc19jcHVfc3RhdGUg
ew0KKwlET1dOLA0KKwlVUCwNCit9Ow0KKw0KKyNpZm5kZWYgQ09ORklHX1NNUA0KK3N0YXRpYyBp
bnQgcnRhc19jcHVfc3RhdGVfY2hhbmdlX21hc2soZW51bSBydGFzX2NwdV9zdGF0ZSBzdGF0ZSwN
CisJCQkJY3B1bWFza192YXJfdCBjcHVzKQ0KK3sNCisJaWYgKCFjcHVtYXNrX2VtcHR5KGNwdXMp
KSB7DQorCQljcHVtYXNrX2NsZWFyKGNwdXMpOw0KKwkJcmV0dXJuIC1FSU5WQUw7DQorCX0gZWxz
ZQ0KKwkJcmV0dXJuIDA7DQorfQ0KKyNlbHNlDQorLyogT24gcmV0dXJuIGNwdW1hc2sgd2lsbCBi
ZSBhbHRlcmVkIHRvIGluZGljYXRlIENQVXMgY2hhbmdlZC4NCisgKiBDUFVzIHdpdGggc3RhdGVz
IGNoYW5nZWQgd2lsbCBiZSBzZXQgaW4gdGhlIG1hc2ssDQorICogQ1BVcyB3aXRoIHN0YXR1cyB1
bmNoYW5nZWQgd2lsbCBiZSB1bnNldCBpbiB0aGUgbWFzay4gKi8NCitzdGF0aWMgaW50IHJ0YXNf
Y3B1X3N0YXRlX2NoYW5nZV9tYXNrKGVudW0gcnRhc19jcHVfc3RhdGUgc3RhdGUsDQorCQkJCWNw
dW1hc2tfdmFyX3QgY3B1cykNCit7DQorCWludCBjcHU7DQorCWludCBjcHVyZXQgPSAwOw0KKwlp
bnQgcmV0ID0gMDsNCisNCisJaWYgKGNwdW1hc2tfZW1wdHkoY3B1cykpDQorCQlyZXR1cm4gMDsN
CisNCisJZm9yX2VhY2hfY3B1KGNwdSwgY3B1cykgew0KKwkJc3dpdGNoIChzdGF0ZSkgew0KKwkJ
Y2FzZSBET1dOOg0KKwkJCWNwdXJldCA9IGNwdV9kb3duKGNwdSk7DQorCQkJYnJlYWs7DQorCQlj
YXNlIFVQOg0KKwkJCWNwdXJldCA9IGNwdV91cChjcHUpOw0KKwkJCWJyZWFrOw0KKwkJfQ0KKwkJ
aWYgKGNwdXJldCkgew0KKwkJCXByX2RlYnVnKCIlczogY3B1XyVzIGZvciBjcHUjJWQgcmV0dXJu
ZWQgJWQuXG4iLA0KKwkJCQkJX19mdW5jX18sDQorCQkJCQkoKHN0YXRlID09IFVQKSA/ICJ1cCIg
OiAiZG93biIpLA0KKwkJCQkJY3B1LCBjcHVyZXQpOw0KKwkJCWlmICghcmV0KQ0KKwkJCQlyZXQg
PSBjcHVyZXQ7DQorCQkJaWYgKHN0YXRlID09IFVQKSB7DQorCQkJCS8qIGNsZWFyIGJpdHMgZm9y
IHVuY2hhbmdlZCBjcHVzLCByZXR1cm4gKi8NCisJCQkJY3B1bWFza19zaGlmdF9yaWdodChjcHVz
LCBjcHVzLCBjcHUpOw0KKwkJCQljcHVtYXNrX3NoaWZ0X2xlZnQoY3B1cywgY3B1cywgY3B1KTsN
CisJCQkJYnJlYWs7DQorCQkJfSBlbHNlIHsNCisJCQkJLyogY2xlYXIgYml0IGZvciB1bmNoYW5n
ZWQgY3B1LCBjb250aW51ZSAqLw0KKwkJCQljcHVtYXNrX2NsZWFyX2NwdShjcHUsIGNwdXMpOw0K
KwkJCX0NCisJCX0NCisJfQ0KKw0KKwlyZXR1cm4gcmV0Ow0KK30NCisjZW5kaWYNCisNCitpbnQg
cnRhc19vbmxpbmVfY3B1c19tYXNrKGNwdW1hc2tfdmFyX3QgY3B1cykNCit7DQorCWludCByZXQ7
DQorDQorCXJldCA9IHJ0YXNfY3B1X3N0YXRlX2NoYW5nZV9tYXNrKFVQLCBjcHVzKTsNCisNCisJ
aWYgKHJldCkgew0KKwkJY3B1bWFza192YXJfdCB0bXBfbWFzazsNCisNCisJCWlmICghYWxsb2Nf
Y3B1bWFza192YXIoJnRtcF9tYXNrLCBHRlBfVEVNUE9SQVJZKSkNCisJCQlyZXR1cm4gcmV0Ow0K
Kw0KKwkJLyogVXNlIHRtcF9tYXNrIHRvIHByZXNlcnZlIGNwdXMgbWFzayBmcm9tIGZpcnN0IGZh
aWx1cmUgKi8NCisJCWNwdW1hc2tfY29weSh0bXBfbWFzaywgY3B1cyk7DQorCQlydGFzX29mZmxp
bmVfY3B1c19tYXNrKHRtcF9tYXNrKTsNCisJCWZyZWVfY3B1bWFza192YXIodG1wX21hc2spOw0K
Kwl9DQorDQorCXJldHVybiByZXQ7DQorfQ0KK0VYUE9SVF9TWU1CT0wocnRhc19vbmxpbmVfY3B1
c19tYXNrKTsNCisNCitpbnQgcnRhc19vZmZsaW5lX2NwdXNfbWFzayhjcHVtYXNrX3Zhcl90IGNw
dXMpDQorew0KKwlyZXR1cm4gcnRhc19jcHVfc3RhdGVfY2hhbmdlX21hc2soRE9XTiwgY3B1cyk7
DQorfQ0KK0VYUE9SVF9TWU1CT0wocnRhc19vZmZsaW5lX2NwdXNfbWFzayk7DQorDQogaW50IHJ0
YXNfaWJtX3N1c3BlbmRfbWUoc3RydWN0IHJ0YXNfYXJncyAqYXJncykNCiB7DQogCWxvbmcgc3Rh
dGU7DQpAQCAtODE4LDYgKzkwNiw4IEBAIGludCBydGFzX2libV9zdXNwZW5kX21lKHN0cnVjdCBy
dGFzX2FyZ3MgKmFyZ3MpDQogCXVuc2lnbmVkIGxvbmcgcmV0YnVmW1BMUEFSX0hDQUxMX0JVRlNJ
WkVdOw0KIAlzdHJ1Y3QgcnRhc19zdXNwZW5kX21lX2RhdGEgZGF0YTsNCiAJREVDTEFSRV9DT01Q
TEVUSU9OX09OU1RBQ0soZG9uZSk7DQorCWNwdW1hc2tfdmFyX3Qgb2ZmbGluZV9tYXNrOw0KKwlp
bnQgY3B1cmV0Ow0KIA0KIAlpZiAoIXJ0YXNfc2VydmljZV9wcmVzZW50KCJpYm0sc3VzcGVuZC1t
ZSIpKQ0KIAkJcmV0dXJuIC1FTk9TWVM7DQpAQCAtODQxLDEyICs5MzEsMjYgQEAgaW50IHJ0YXNf
aWJtX3N1c3BlbmRfbWUoc3RydWN0IHJ0YXNfYXJncyAqYXJncykNCiAJCXJldHVybiAwOw0KIAl9
DQogDQorCWlmICghYWxsb2NfY3B1bWFza192YXIoJm9mZmxpbmVfbWFzaywgR0ZQX1RFTVBPUkFS
WSkpDQorCQlyZXR1cm4gLUVOT01FTTsNCisNCiAJYXRvbWljX3NldCgmZGF0YS53b3JraW5nLCAw
KTsNCiAJYXRvbWljX3NldCgmZGF0YS5kb25lLCAwKTsNCiAJYXRvbWljX3NldCgmZGF0YS5lcnJv
ciwgMCk7DQogCWRhdGEudG9rZW4gPSBydGFzX3Rva2VuKCJpYm0sc3VzcGVuZC1tZSIpOw0KIAlk
YXRhLmNvbXBsZXRlID0gJmRvbmU7DQogDQorCS8qIEFsbCBwcmVzZW50IENQVXMgbXVzdCBiZSBv
bmxpbmUgKi8NCisJY3B1bWFza19hbmRub3Qob2ZmbGluZV9tYXNrLCBjcHVfcHJlc2VudF9tYXNr
LCBjcHVfb25saW5lX21hc2spOw0KKwljcHVyZXQgPSBydGFzX29ubGluZV9jcHVzX21hc2sob2Zm
bGluZV9tYXNrKTsNCisJaWYgKGNwdXJldCkgew0KKwkJcHJfZXJyKCIlczogQ291bGQgbm90IGJy
aW5nIHByZXNlbnQgQ1BVcyBvbmxpbmUuXG4iLCBfX2Z1bmNfXyk7DQorCQlhdG9taWNfc2V0KCZk
YXRhLmVycm9yLCBjcHVyZXQpOw0KKwkJZ290byBvdXQ7DQorCX0NCisNCisJc3RvcF90b3BvbG9n
eV91cGRhdGUoKTsNCisNCiAJLyogQ2FsbCBmdW5jdGlvbiBvbiBhbGwgQ1BVcy4gIE9uZSBvZiB1
cyB3aWxsIG1ha2UgdGhlDQogCSAqIHJ0YXMgY2FsbA0KIAkgKi8NCkBAIC04NTgsNiArOTYyLDE2
IEBAIGludCBydGFzX2libV9zdXNwZW5kX21lKHN0cnVjdCBydGFzX2FyZ3MgKmFyZ3MpDQogCWlm
IChhdG9taWNfcmVhZCgmZGF0YS5lcnJvcikgIT0gMCkNCiAJCXByaW50ayhLRVJOX0VSUiAiRXJy
b3IgZG9pbmcgZ2xvYmFsIGpvaW5cbiIpOw0KIA0KKwlzdGFydF90b3BvbG9neV91cGRhdGUoKTsN
CisNCisJLyogVGFrZSBkb3duIENQVXMgbm90IG9ubGluZSBwcmlvciB0byBzdXNwZW5kICovDQor
CWNwdXJldCA9IHJ0YXNfb2ZmbGluZV9jcHVzX21hc2sob2ZmbGluZV9tYXNrKTsNCisJaWYgKGNw
dXJldCkNCisJCXByX3dhcm4oIiVzOiBDb3VsZCBub3QgcmVzdG9yZSBDUFVzIHRvIG9mZmxpbmUg
c3RhdGUuXG4iLA0KKwkJCQlfX2Z1bmNfXyk7DQorDQorb3V0Og0KKwlmcmVlX2NwdW1hc2tfdmFy
KG9mZmxpbmVfbWFzayk7DQogCXJldHVybiBhdG9taWNfcmVhZCgmZGF0YS5lcnJvcik7DQogfQ0K
ICNlbHNlIC8qIENPTkZJR19QUENfUFNFUklFUyAqLw0KZGlmZiAtLWdpdCBhL2FyY2gvcG93ZXJw
Yy9wbGF0Zm9ybXMvcHNlcmllcy9zdXNwZW5kLmMgYi9hcmNoL3Bvd2VycGMvcGxhdGZvcm1zL3Bz
ZXJpZXMvc3VzcGVuZC5jDQppbmRleCBkM2RlMDg0Li41NWE0NzcxIDEwMDY0NA0KLS0tIGEvYXJj
aC9wb3dlcnBjL3BsYXRmb3Jtcy9wc2VyaWVzL3N1c3BlbmQuYw0KKysrIGIvYXJjaC9wb3dlcnBj
L3BsYXRmb3Jtcy9wc2VyaWVzL3N1c3BlbmQuYw0KQEAgLTE2LDYgKzE2LDcgQEANCiAgICogRm91
bmRhdGlvbiwgSW5jLiwgNTkgVGVtcGxlIFBsYWNlLCBTdWl0ZSAzMzAsIEJvc3RvbiwgTUEgIDAy
MTExLTEzMDcgVVNBDQogICAqLw0KIA0KKyNpbmNsdWRlIDxsaW51eC9jcHUuaD4NCiAjaW5jbHVk
ZSA8bGludXgvZGVsYXkuaD4NCiAjaW5jbHVkZSA8bGludXgvc3VzcGVuZC5oPg0KICNpbmNsdWRl
IDxsaW51eC9zdGF0Lmg+DQpAQCAtMjQsNiArMjUsNyBAQA0KICNpbmNsdWRlIDxhc20vbWFjaGRl
cC5oPg0KICNpbmNsdWRlIDxhc20vbW11Lmg+DQogI2luY2x1ZGUgPGFzbS9ydGFzLmg+DQorI2lu
Y2x1ZGUgPGFzbS90b3BvbG9neS5oPg0KIA0KIHN0YXRpYyB1NjQgc3RyZWFtX2lkOw0KIHN0YXRp
YyBzdHJ1Y3Qgc3lzX2RldmljZSBzdXNwZW5kX3N5c2RldjsNCkBAIC0xMjUsMTEgKzEyNywxNSBA
QCBzdGF0aWMgc3NpemVfdCBzdG9yZV9oaWJlcm5hdGUoc3RydWN0IHN5c2Rldl9jbGFzcyAqY2xh
c3NkZXYsDQogCQkJICAgICAgIHN0cnVjdCBzeXNkZXZfY2xhc3NfYXR0cmlidXRlICphdHRyLA0K
IAkJCSAgICAgICBjb25zdCBjaGFyICpidWYsIHNpemVfdCBjb3VudCkNCiB7DQorCWNwdW1hc2tf
dmFyX3Qgb2ZmbGluZV9tYXNrOw0KIAlpbnQgcmM7DQogDQogCWlmICghY2FwYWJsZShDQVBfU1lT
X0FETUlOKSkNCiAJCXJldHVybiAtRVBFUk07DQogDQorCWlmICghYWxsb2NfY3B1bWFza192YXIo
Jm9mZmxpbmVfbWFzaywgR0ZQX1RFTVBPUkFSWSkpDQorCQlyZXR1cm4gLUVOT01FTTsNCisNCiAJ
c3RyZWFtX2lkID0gc2ltcGxlX3N0cnRvdWwoYnVmLCBOVUxMLCAxNik7DQogDQogCWRvIHsNCkBA
IC0xMzgsMTMgKzE0NCwzMyBAQCBzdGF0aWMgc3NpemVfdCBzdG9yZV9oaWJlcm5hdGUoc3RydWN0
IHN5c2Rldl9jbGFzcyAqY2xhc3NkZXYsDQogCQkJc3NsZWVwKDEpOw0KIAl9IHdoaWxlIChyYyA9
PSAtRUFHQUlOKTsNCiANCi0JaWYgKCFyYykNCisJaWYgKCFyYykgew0KKwkJLyogQWxsIHByZXNl
bnQgQ1BVcyBtdXN0IGJlIG9ubGluZSAqLw0KKwkJY3B1bWFza19hbmRub3Qob2ZmbGluZV9tYXNr
LCBjcHVfcHJlc2VudF9tYXNrLA0KKwkJCQljcHVfb25saW5lX21hc2spOw0KKwkJcmMgPSBydGFz
X29ubGluZV9jcHVzX21hc2sob2ZmbGluZV9tYXNrKTsNCisJCWlmIChyYykgew0KKwkJCXByX2Vy
cigiJXM6IENvdWxkIG5vdCBicmluZyBwcmVzZW50IENQVXMgb25saW5lLlxuIiwNCisJCQkJCV9f
ZnVuY19fKTsNCisJCQlnb3RvIG91dDsNCisJCX0NCisNCisJCXN0b3BfdG9wb2xvZ3lfdXBkYXRl
KCk7DQogCQlyYyA9IHBtX3N1c3BlbmQoUE1fU1VTUEVORF9NRU0pOw0KKwkJc3RhcnRfdG9wb2xv
Z3lfdXBkYXRlKCk7DQorDQorCQkvKiBUYWtlIGRvd24gQ1BVcyBub3Qgb25saW5lIHByaW9yIHRv
IHN1c3BlbmQgKi8NCisJCWlmICghcnRhc19vZmZsaW5lX2NwdXNfbWFzayhvZmZsaW5lX21hc2sp
KQ0KKwkJCXByX3dhcm4oIiVzOiBDb3VsZCBub3QgcmVzdG9yZSBDUFVzIHRvIG9mZmxpbmUgIg0K
KwkJCQkJInN0YXRlLlxuIiwgX19mdW5jX18pOw0KKwl9DQogDQogCXN0cmVhbV9pZCA9IDA7DQog
DQogCWlmICghcmMpDQogCQlyYyA9IGNvdW50Ow0KK291dDoNCisJZnJlZV9jcHVtYXNrX3Zhcihv
ZmZsaW5lX21hc2spOw0KIAlyZXR1cm4gcmM7DQogfQ0KIA0KZGlmZiAtLWdpdCBhL2FyY2gvdW0v
aW5jbHVkZS9hc20vcGd0YWJsZS5oIGIvYXJjaC91bS9pbmNsdWRlL2FzbS9wZ3RhYmxlLmgNCmlu
ZGV4IGFhMzY1YzUuLjU4ODhmMWIgMTAwNjQ0DQotLS0gYS9hcmNoL3VtL2luY2x1ZGUvYXNtL3Bn
dGFibGUuaA0KKysrIGIvYXJjaC91bS9pbmNsdWRlL2FzbS9wZ3RhYmxlLmgNCkBAIC02OSw2ICs2
OSw4IEBAIGV4dGVybiB1bnNpZ25lZCBsb25nIGVuZF9pb21lbTsNCiAjZGVmaW5lIFBBR0VfS0VS
TkVMCV9fcGdwcm90KF9QQUdFX1BSRVNFTlQgfCBfUEFHRV9SVyB8IF9QQUdFX0RJUlRZIHwgX1BB
R0VfQUNDRVNTRUQpDQogI2RlZmluZSBQQUdFX0tFUk5FTF9FWEVDCV9fcGdwcm90KF9fUEFHRV9L
RVJORUxfRVhFQykNCiANCisjZGVmaW5lIGlvX3JlbWFwX3Bmbl9yYW5nZQlyZW1hcF9wZm5fcmFu
Z2UNCisNCiAvKg0KICAqIFRoZSBpMzg2IGNhbid0IGRvIHBhZ2UgcHJvdGVjdGlvbiBmb3IgZXhl
Y3V0ZSwgYW5kIGNvbnNpZGVycyB0aGF0IHRoZSBzYW1lDQogICogYXJlIHJlYWQuDQpkaWZmIC0t
Z2l0IGEvYXJjaC94ODYva2VybmVsL2lycS5jIGIvYXJjaC94ODYva2VybmVsL2lycS5jDQppbmRl
eCA0MjllMGM5Li5mYjJlYjMyIDEwMDY0NA0KLS0tIGEvYXJjaC94ODYva2VybmVsL2lycS5jDQor
KysgYi9hcmNoL3g4Ni9rZXJuZWwvaXJxLmMNCkBAIC0xNjAsMTAgKzE2MCw2IEBAIHU2NCBhcmNo
X2lycV9zdGF0X2NwdSh1bnNpZ25lZCBpbnQgY3B1KQ0KIHU2NCBhcmNoX2lycV9zdGF0KHZvaWQp
DQogew0KIAl1NjQgc3VtID0gYXRvbWljX3JlYWQoJmlycV9lcnJfY291bnQpOw0KLQ0KLSNpZmRl
ZiBDT05GSUdfWDg2X0lPX0FQSUMNCi0Jc3VtICs9IGF0b21pY19yZWFkKCZpcnFfbWlzX2NvdW50
KTsNCi0jZW5kaWYNCiAJcmV0dXJuIHN1bTsNCiB9DQogDQpkaWZmIC0tZ2l0IGEvYXJjaC94ODYv
a3ZtL3ZteC5jIGIvYXJjaC94ODYva3ZtL3ZteC5jDQppbmRleCA0MDc3ODliLi5hYWM1ZWE3IDEw
MDY0NA0KLS0tIGEvYXJjaC94ODYva3ZtL3ZteC5jDQorKysgYi9hcmNoL3g4Ni9rdm0vdm14LmMN
CkBAIC00ODgyLDYgKzQ4ODIsMTIgQEAgc3RhdGljIGludCBoYW5kbGVfaW52YWxpZF9ndWVzdF9z
dGF0ZShzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpDQogCQlpZiAoZXJyICE9IEVNVUxBVEVfRE9ORSkN
CiAJCQlyZXR1cm4gMDsNCiANCisJCWlmICh2Y3B1LT5hcmNoLmhhbHRfcmVxdWVzdCkgew0KKwkJ
CXZjcHUtPmFyY2guaGFsdF9yZXF1ZXN0ID0gMDsNCisJCQlyZXQgPSBrdm1fZW11bGF0ZV9oYWx0
KHZjcHUpOw0KKwkJCWdvdG8gb3V0Ow0KKwkJfQ0KKw0KIAkJaWYgKHNpZ25hbF9wZW5kaW5nKGN1
cnJlbnQpKQ0KIAkJCWdvdG8gb3V0Ow0KIAkJaWYgKG5lZWRfcmVzY2hlZCgpKQ0KZGlmZiAtLWdp
dCBhL2FyY2gveDg2L3BsYXRmb3JtL2VmaS9lZmkuYyBiL2FyY2gveDg2L3BsYXRmb3JtL2VmaS9l
ZmkuYw0KaW5kZXggMWRlNTQyYi4uMDdlZjdlOCAxMDA2NDQNCi0tLSBhL2FyY2gveDg2L3BsYXRm
b3JtL2VmaS9lZmkuYw0KKysrIGIvYXJjaC94ODYvcGxhdGZvcm0vZWZpL2VmaS5jDQpAQCAtMTAx
LDYgKzEwMSwxNSBAQCBzdGF0aWMgaW50IF9faW5pdCBzZXR1cF9hZGRfZWZpX21lbW1hcChjaGFy
ICphcmcpDQogfQ0KIGVhcmx5X3BhcmFtKCJhZGRfZWZpX21lbW1hcCIsIHNldHVwX2FkZF9lZmlf
bWVtbWFwKTsNCiANCitzdGF0aWMgYm9vbCBlZmlfbm9fc3RvcmFnZV9wYXJhbm9pYTsNCisNCitz
dGF0aWMgaW50IF9faW5pdCBzZXR1cF9zdG9yYWdlX3BhcmFub2lhKGNoYXIgKmFyZykNCit7DQor
CWVmaV9ub19zdG9yYWdlX3BhcmFub2lhID0gdHJ1ZTsNCisJcmV0dXJuIDA7DQorfQ0KK2Vhcmx5
X3BhcmFtKCJlZmlfbm9fc3RvcmFnZV9wYXJhbm9pYSIsIHNldHVwX3N0b3JhZ2VfcGFyYW5vaWEp
Ow0KKw0KIA0KIHN0YXRpYyBlZmlfc3RhdHVzX3QgdmlydF9lZmlfZ2V0X3RpbWUoZWZpX3RpbWVf
dCAqdG0sIGVmaV90aW1lX2NhcF90ICp0YykNCiB7DQpAQCAtODE1LDMgKzgyNCwzNyBAQCB1NjQg
ZWZpX21lbV9hdHRyaWJ1dGVzKHVuc2lnbmVkIGxvbmcgcGh5c19hZGRyKQ0KIAl9DQogCXJldHVy
biAwOw0KIH0NCisNCisvKg0KKyAqIFNvbWUgZmlybXdhcmUgaGFzIHNlcmlvdXMgcHJvYmxlbXMg
d2hlbiB1c2luZyBtb3JlIHRoYW4gNTAlIG9mIHRoZSBFRkkNCisgKiB2YXJpYWJsZSBzdG9yZSwg
aS5lLiBpdCB0cmlnZ2VycyBidWdzIHRoYXQgY2FuIGJyaWNrIG1hY2hpbmVzLiBFbnN1cmUgdGhh
dA0KKyAqIHdlIG5ldmVyIHVzZSBtb3JlIHRoYW4gdGhpcyBzYWZlIGxpbWl0Lg0KKyAqDQorICog
UmV0dXJuIEVGSV9TVUNDRVNTIGlmIGl0IGlzIHNhZmUgdG8gd3JpdGUgJ3NpemUnIGJ5dGVzIHRv
IHRoZSB2YXJpYWJsZQ0KKyAqIHN0b3JlLg0KKyAqLw0KK2VmaV9zdGF0dXNfdCBlZmlfcXVlcnlf
dmFyaWFibGVfc3RvcmUodTMyIGF0dHJpYnV0ZXMsIHVuc2lnbmVkIGxvbmcgc2l6ZSkNCit7DQor
CWVmaV9zdGF0dXNfdCBzdGF0dXM7DQorCXU2NCBzdG9yYWdlX3NpemUsIHJlbWFpbmluZ19zaXpl
LCBtYXhfc2l6ZTsNCisNCisJc3RhdHVzID0gZWZpLnF1ZXJ5X3ZhcmlhYmxlX2luZm8oYXR0cmli
dXRlcywgJnN0b3JhZ2Vfc2l6ZSwNCisJCQkJCSAmcmVtYWluaW5nX3NpemUsICZtYXhfc2l6ZSk7
DQorCWlmIChzdGF0dXMgIT0gRUZJX1NVQ0NFU1MpDQorCQlyZXR1cm4gc3RhdHVzOw0KKw0KKwlp
ZiAoIW1heF9zaXplICYmIHJlbWFpbmluZ19zaXplID4gc2l6ZSkNCisJCXByaW50a19vbmNlKEtF
Uk5fRVJSIEZXX0JVRyAiQnJva2VuIEVGSSBpbXBsZW1lbnRhdGlvbiINCisJCQkgICAgIiBpcyBy
ZXR1cm5pbmcgTWF4VmFyaWFibGVTaXplPTBcbiIpOw0KKw0KKwlpZiAoIXN0b3JhZ2Vfc2l6ZSB8
fCBzaXplID4gcmVtYWluaW5nX3NpemUgfHwNCisJICAgIChtYXhfc2l6ZSAmJiBzaXplID4gbWF4
X3NpemUpKQ0KKwkJcmV0dXJuIEVGSV9PVVRfT0ZfUkVTT1VSQ0VTOw0KKw0KKwlpZiAoIWVmaV9u
b19zdG9yYWdlX3BhcmFub2lhICYmDQorCSAgICAocmVtYWluaW5nX3NpemUgLSBzaXplKSA8IChz
dG9yYWdlX3NpemUgLyAyKSkNCisJCXJldHVybiBFRklfT1VUX09GX1JFU09VUkNFUzsNCisNCisJ
cmV0dXJuIEVGSV9TVUNDRVNTOw0KK30NCitFWFBPUlRfU1lNQk9MX0dQTChlZmlfcXVlcnlfdmFy
aWFibGVfc3RvcmUpOw0KZGlmZiAtLWdpdCBhL2FyY2gveDg2L3hlbi9lbmxpZ2h0ZW4uYyBiL2Fy
Y2gveDg2L3hlbi9lbmxpZ2h0ZW4uYw0KaW5kZXggMDQ0ZjVkOS4uNTE4OWZlOCAxMDA2NDQNCi0t
LSBhL2FyY2gveDg2L3hlbi9lbmxpZ2h0ZW4uYw0KKysrIGIvYXJjaC94ODYveGVuL2VubGlnaHRl
bi5jDQpAQCAtMTI5LDYgKzEyOSwyMSBAQCBzdGF0aWMgdm9pZCB4ZW5fdmNwdV9zZXR1cChpbnQg
Y3B1KQ0KIA0KIAlCVUdfT04oSFlQRVJWSVNPUl9zaGFyZWRfaW5mbyA9PSAmeGVuX2R1bW15X3No
YXJlZF9pbmZvKTsNCiANCisJLyoNCisJICogVGhpcyBwYXRoIGlzIGNhbGxlZCB0d2ljZSBvbiBQ
VkhWTSAtIGZpcnN0IGR1cmluZyBib290dXAgdmlhDQorCSAqIHNtcF9pbml0IC0+IHhlbl9odm1f
Y3B1X25vdGlmeSwgYW5kIHRoZW4gaWYgdGhlIFZDUFUgaXMgYmVpbmcNCisJICogaG90cGx1Z2dl
ZDogY3B1X3VwIC0+IHhlbl9odm1fY3B1X25vdGlmeS4NCisJICogQXMgd2UgY2FuIG9ubHkgZG8g
dGhlIFZDUFVPUF9yZWdpc3Rlcl92Y3B1X2luZm8gb25jZSBsZXRzDQorCSAqIG5vdCBvdmVyLXdy
aXRlIGl0cyByZXN1bHQuDQorCSAqDQorCSAqIEZvciBQViBpdCBpcyBjYWxsZWQgZHVyaW5nIHJl
c3RvcmUgKHhlbl92Y3B1X3Jlc3RvcmUpIGFuZCBib290dXANCisJICogKHhlbl9zZXR1cF92Y3B1
X2luZm9fcGxhY2VtZW50KS4gVGhlIGhvdHBsdWcgbWVjaGFuaXNtIGRvZXMgbm90DQorCSAqIHVz
ZSB0aGlzIGZ1bmN0aW9uLg0KKwkgKi8NCisJaWYgKHhlbl9odm1fZG9tYWluKCkpIHsNCisJCWlm
IChwZXJfY3B1KHhlbl92Y3B1LCBjcHUpID09ICZwZXJfY3B1KHhlbl92Y3B1X2luZm8sIGNwdSkp
DQorCQkJcmV0dXJuOw0KKwl9DQogCWlmIChjcHUgPCBNQVhfVklSVF9DUFVTKQ0KIAkJcGVyX2Nw
dSh4ZW5fdmNwdSxjcHUpID0gJkhZUEVSVklTT1Jfc2hhcmVkX2luZm8tPnZjcHVfaW5mb1tjcHVd
Ow0KIA0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvYWNwaS9hY3BpY2EvZXhmbGRpby5jIGIvZHJpdmVy
cy9hY3BpL2FjcGljYS9leGZsZGlvLmMNCmluZGV4IGY5MTVhN2YuLmIzMzRmNTQgMTAwNjQ0DQot
LS0gYS9kcml2ZXJzL2FjcGkvYWNwaWNhL2V4ZmxkaW8uYw0KKysrIGIvZHJpdmVycy9hY3BpL2Fj
cGljYS9leGZsZGlvLmMNCkBAIC03MDIsNyArNzAyLDE5IEBAIGFjcGlfZXhfZXh0cmFjdF9mcm9t
X2ZpZWxkKHVuaW9uIGFjcGlfb3BlcmFuZF9vYmplY3QgKm9ial9kZXNjLA0KIA0KIAlpZiAoKG9i
al9kZXNjLT5jb21tb25fZmllbGQuc3RhcnRfZmllbGRfYml0X29mZnNldCA9PSAwKSAmJg0KIAkg
ICAgKG9ial9kZXNjLT5jb21tb25fZmllbGQuYml0X2xlbmd0aCA9PSBhY2Nlc3NfYml0X3dpZHRo
KSkgew0KLQkJc3RhdHVzID0gYWNwaV9leF9maWVsZF9kYXR1bV9pbyhvYmpfZGVzYywgMCwgYnVm
ZmVyLCBBQ1BJX1JFQUQpOw0KKwkJaWYgKGJ1ZmZlcl9sZW5ndGggPj0gc2l6ZW9mKHU2NCkpIHsN
CisJCQlzdGF0dXMgPQ0KKwkJCSAgICBhY3BpX2V4X2ZpZWxkX2RhdHVtX2lvKG9ial9kZXNjLCAw
LCBidWZmZXIsDQorCQkJCQkJICAgQUNQSV9SRUFEKTsNCisJCX0gZWxzZSB7DQorCQkJLyogVXNl
IHJhd19kYXR1bSAodTY0KSB0byBoYW5kbGUgYnVmZmVycyA8IDY0IGJpdHMgKi8NCisNCisJCQlz
dGF0dXMgPQ0KKwkJCSAgICBhY3BpX2V4X2ZpZWxkX2RhdHVtX2lvKG9ial9kZXNjLCAwLCAmcmF3
X2RhdHVtLA0KKwkJCQkJCSAgIEFDUElfUkVBRCk7DQorCQkJQUNQSV9NRU1DUFkoYnVmZmVyLCAm
cmF3X2RhdHVtLCBidWZmZXJfbGVuZ3RoKTsNCisJCX0NCisNCiAJCXJldHVybl9BQ1BJX1NUQVRV
UyhzdGF0dXMpOw0KIAl9DQogDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9hY3BpL2VjLmMgYi9kcml2
ZXJzL2FjcGkvZWMuYw0KaW5kZXggZDI1MTliMi4uNTFkZTE4NiAxMDA2NDQNCi0tLSBhL2RyaXZl
cnMvYWNwaS9lYy5jDQorKysgYi9kcml2ZXJzL2FjcGkvZWMuYw0KQEAgLTIxNyw3ICsyMTcsNyBA
QCBzdGF0aWMgaW50IGVjX2NoZWNrX3NjaV9zeW5jKHN0cnVjdCBhY3BpX2VjICplYywgdTggc3Rh
dGUpDQogc3RhdGljIGludCBlY19wb2xsKHN0cnVjdCBhY3BpX2VjICplYykNCiB7DQogCXVuc2ln
bmVkIGxvbmcgZmxhZ3M7DQotCWludCByZXBlYXQgPSAyOyAvKiBudW1iZXIgb2YgY29tbWFuZCBy
ZXN0YXJ0cyAqLw0KKwlpbnQgcmVwZWF0ID0gNTsgLyogbnVtYmVyIG9mIGNvbW1hbmQgcmVzdGFy
dHMgKi8NCiAJd2hpbGUgKHJlcGVhdC0tKSB7DQogCQl1bnNpZ25lZCBsb25nIGRlbGF5ID0gamlm
ZmllcyArDQogCQkJbXNlY3NfdG9famlmZmllcyhlY19kZWxheSk7DQpAQCAtMjM1LDggKzIzNSw2
IEBAIHN0YXRpYyBpbnQgZWNfcG9sbChzdHJ1Y3QgYWNwaV9lYyAqZWMpDQogCQkJfQ0KIAkJCWFk
dmFuY2VfdHJhbnNhY3Rpb24oZWMsIGFjcGlfZWNfcmVhZF9zdGF0dXMoZWMpKTsNCiAJCX0gd2hp
bGUgKHRpbWVfYmVmb3JlKGppZmZpZXMsIGRlbGF5KSk7DQotCQlpZiAoYWNwaV9lY19yZWFkX3N0
YXR1cyhlYykgJiBBQ1BJX0VDX0ZMQUdfSUJGKQ0KLQkJCWJyZWFrOw0KIAkJcHJfZGVidWcoUFJF
RklYICJjb250cm9sbGVyIHJlc2V0LCByZXN0YXJ0IHRyYW5zYWN0aW9uXG4iKTsNCiAJCXNwaW5f
bG9ja19pcnFzYXZlKCZlYy0+Y3Vycl9sb2NrLCBmbGFncyk7DQogCQlzdGFydF90cmFuc2FjdGlv
bihlYyk7DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9hY3BpL3ZpZGVvX2RldGVjdC5jIGIvZHJpdmVy
cy9hY3BpL3ZpZGVvX2RldGVjdC5jDQppbmRleCBkOWMwMTk5Li41M2UyOGE5IDEwMDY0NA0KLS0t
IGEvZHJpdmVycy9hY3BpL3ZpZGVvX2RldGVjdC5jDQorKysgYi9kcml2ZXJzL2FjcGkvdmlkZW9f
ZGV0ZWN0LmMNCkBAIC0xNjQsNiArMTY0LDE0IEBAIHN0YXRpYyBzdHJ1Y3QgZG1pX3N5c3RlbV9p
ZCB2aWRlb19kZXRlY3RfZG1pX3RhYmxlW10gPSB7DQogCQlETUlfTUFUQ0goRE1JX1BST0RVQ1Rf
TkFNRSwgIlVMMzBWVCIpLA0KIAkJfSwNCiAJfSwNCisJew0KKwkuY2FsbGJhY2sgPSB2aWRlb19k
ZXRlY3RfZm9yY2VfdmVuZG9yLA0KKwkuaWRlbnQgPSAiQXN1cyBVTDMwQSIsDQorCS5tYXRjaGVz
ID0gew0KKwkJRE1JX01BVENIKERNSV9TWVNfVkVORE9SLCAiQVNVU1RlSyBDb21wdXRlciBJbmMu
IiksDQorCQlETUlfTUFUQ0goRE1JX1BST0RVQ1RfTkFNRSwgIlVMMzBBIiksDQorCQl9LA0KKwl9
LA0KIAl7IH0sDQogfTsNCiANCmRpZmYgLS1naXQgYS9kcml2ZXJzL2Jsb2NrL2JyZC5jIGIvZHJp
dmVycy9ibG9jay9icmQuYw0KaW5kZXggZDIyMTE5ZC4uOTY4YTBkNCAxMDA2NDQNCi0tLSBhL2Ry
aXZlcnMvYmxvY2svYnJkLmMNCisrKyBiL2RyaXZlcnMvYmxvY2svYnJkLmMNCkBAIC0xMTcsMTMg
KzExNywxMyBAQCBzdGF0aWMgc3RydWN0IHBhZ2UgKmJyZF9pbnNlcnRfcGFnZShzdHJ1Y3QgYnJk
X2RldmljZSAqYnJkLCBzZWN0b3JfdCBzZWN0b3IpDQogDQogCXNwaW5fbG9jaygmYnJkLT5icmRf
bG9jayk7DQogCWlkeCA9IHNlY3RvciA+PiBQQUdFX1NFQ1RPUlNfU0hJRlQ7DQorCXBhZ2UtPmlu
ZGV4ID0gaWR4Ow0KIAlpZiAocmFkaXhfdHJlZV9pbnNlcnQoJmJyZC0+YnJkX3BhZ2VzLCBpZHgs
IHBhZ2UpKSB7DQogCQlfX2ZyZWVfcGFnZShwYWdlKTsNCiAJCXBhZ2UgPSByYWRpeF90cmVlX2xv
b2t1cCgmYnJkLT5icmRfcGFnZXMsIGlkeCk7DQogCQlCVUdfT04oIXBhZ2UpOw0KIAkJQlVHX09O
KHBhZ2UtPmluZGV4ICE9IGlkeCk7DQotCX0gZWxzZQ0KLQkJcGFnZS0+aW5kZXggPSBpZHg7DQor
CX0NCiAJc3Bpbl91bmxvY2soJmJyZC0+YnJkX2xvY2spOw0KIA0KIAlyYWRpeF90cmVlX3ByZWxv
YWRfZW5kKCk7DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9ibG9jay9kcmJkL2RyYmRfcmVjZWl2ZXIu
YyBiL2RyaXZlcnMvYmxvY2svZHJiZC9kcmJkX3JlY2VpdmVyLmMNCmluZGV4IDQzYmVhY2EuLjEz
Y2JkZDMgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL2Jsb2NrL2RyYmQvZHJiZF9yZWNlaXZlci5jDQor
KysgYi9kcml2ZXJzL2Jsb2NrL2RyYmQvZHJiZF9yZWNlaXZlci5jDQpAQCAtMjIyNSw3ICsyMjI1
LDYgQEAgc3RhdGljIGludCBkcmJkX2FzYl9yZWNvdmVyXzFwKHN0cnVjdCBkcmJkX2NvbmYgKm1k
ZXYpIF9fbXVzdF9ob2xkKGxvY2FsKQ0KIAkJaWYgKGhnID09IC0xICYmIG1kZXYtPnN0YXRlLnJv
bGUgPT0gUl9QUklNQVJZKSB7DQogCQkJZW51bSBkcmJkX3N0YXRlX3J2IHJ2MjsNCiANCi0JCQlk
cmJkX3NldF9yb2xlKG1kZXYsIFJfU0VDT05EQVJZLCAwKTsNCiAJCQkgLyogZHJiZF9jaGFuZ2Vf
c3RhdGUoKSBkb2VzIG5vdCBzbGVlcCB3aGlsZSBpbiBTU19JTl9UUkFOU0lFTlRfU1RBVEUsDQog
CQkJICAqIHdlIG1pZ2h0IGJlIGhlcmUgaW4gQ19XRl9SRVBPUlRfUEFSQU1TIHdoaWNoIGlzIHRy
YW5zaWVudC4NCiAJCQkgICogd2UgZG8gbm90IG5lZWQgdG8gd2FpdCBmb3IgdGhlIGFmdGVyIHN0
YXRlIGNoYW5nZSB3b3JrIGVpdGhlci4gKi8NCmRpZmYgLS1naXQgYS9kcml2ZXJzL2NoYXIvaXBt
aS9pcG1pX2J0X3NtLmMgYi9kcml2ZXJzL2NoYXIvaXBtaS9pcG1pX2J0X3NtLmMNCmluZGV4IDNl
ZDIwZTguLjkyY2UzMDIgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL2NoYXIvaXBtaS9pcG1pX2J0X3Nt
LmMNCisrKyBiL2RyaXZlcnMvY2hhci9pcG1pL2lwbWlfYnRfc20uYw0KQEAgLTk1LDkgKzk1LDkg
QEAgc3RydWN0IHNpX3NtX2RhdGEgew0KIAllbnVtIGJ0X3N0YXRlcwlzdGF0ZTsNCiAJdW5zaWdu
ZWQgY2hhcglzZXE7CQkvKiBCVCBzZXF1ZW5jZSBudW1iZXIgKi8NCiAJc3RydWN0IHNpX3NtX2lv
CSppbzsNCi0JdW5zaWduZWQgY2hhcgl3cml0ZV9kYXRhW0lQTUlfTUFYX01TR19MRU5HVEhdOw0K
Kwl1bnNpZ25lZCBjaGFyCXdyaXRlX2RhdGFbSVBNSV9NQVhfTVNHX0xFTkdUSCArIDJdOyAvKiAr
MiBmb3IgbWVtY3B5ICovDQogCWludAkJd3JpdGVfY291bnQ7DQotCXVuc2lnbmVkIGNoYXIJcmVh
ZF9kYXRhW0lQTUlfTUFYX01TR19MRU5HVEhdOw0KKwl1bnNpZ25lZCBjaGFyCXJlYWRfZGF0YVtJ
UE1JX01BWF9NU0dfTEVOR1RIICsgMl07IC8qICsyIGZvciBtZW1jcHkgKi8NCiAJaW50CQlyZWFk
X2NvdW50Ow0KIAlpbnQJCXRydW5jYXRlZDsNCiAJbG9uZwkJdGltZW91dDsJLyogbWljcm9zZWNv
bmRzIGNvdW50ZG93biAqLw0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvY2hhci9pcG1pL2lwbWlfZGV2
aW50Zi5jIGIvZHJpdmVycy9jaGFyL2lwbWkvaXBtaV9kZXZpbnRmLmMNCmluZGV4IDJhYTM5Nzcu
LjhkZGUxZjUgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL2NoYXIvaXBtaS9pcG1pX2RldmludGYuYw0K
KysrIGIvZHJpdmVycy9jaGFyL2lwbWkvaXBtaV9kZXZpbnRmLmMNCkBAIC04MzgsMTMgKzgzOCwy
NSBAQCBzdGF0aWMgbG9uZyBjb21wYXRfaXBtaV9pb2N0bChzdHJ1Y3QgZmlsZSAqZmlsZXAsIHVu
c2lnbmVkIGludCBjbWQsDQogCQlyZXR1cm4gaXBtaV9pb2N0bChmaWxlcCwgY21kLCBhcmcpOw0K
IAl9DQogfQ0KKw0KK3N0YXRpYyBsb25nIHVubG9ja2VkX2NvbXBhdF9pcG1pX2lvY3RsKHN0cnVj
dCBmaWxlICpmaWxlcCwgdW5zaWduZWQgaW50IGNtZCwNCisJCQkJICAgICAgIHVuc2lnbmVkIGxv
bmcgYXJnKQ0KK3sNCisJaW50IHJldDsNCisNCisJbXV0ZXhfbG9jaygmaXBtaV9tdXRleCk7DQor
CXJldCA9IGNvbXBhdF9pcG1pX2lvY3RsKGZpbGVwLCBjbWQsIGFyZyk7DQorCW11dGV4X3VubG9j
aygmaXBtaV9tdXRleCk7DQorDQorCXJldHVybiByZXQ7DQorfQ0KICNlbmRpZg0KIA0KIHN0YXRp
YyBjb25zdCBzdHJ1Y3QgZmlsZV9vcGVyYXRpb25zIGlwbWlfZm9wcyA9IHsNCiAJLm93bmVyCQk9
IFRISVNfTU9EVUxFLA0KIAkudW5sb2NrZWRfaW9jdGwJPSBpcG1pX3VubG9ja2VkX2lvY3RsLA0K
ICNpZmRlZiBDT05GSUdfQ09NUEFUDQotCS5jb21wYXRfaW9jdGwgICA9IGNvbXBhdF9pcG1pX2lv
Y3RsLA0KKwkuY29tcGF0X2lvY3RsICAgPSB1bmxvY2tlZF9jb21wYXRfaXBtaV9pb2N0bCwNCiAj
ZW5kaWYNCiAJLm9wZW4JCT0gaXBtaV9vcGVuLA0KIAkucmVsZWFzZQk9IGlwbWlfcmVsZWFzZSwN
CmRpZmYgLS1naXQgYS9kcml2ZXJzL2NoYXIvcmFuZG9tLmMgYi9kcml2ZXJzL2NoYXIvcmFuZG9t
LmMNCmluZGV4IDhhZTkyMzUuLmI2NTE3MzMgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL2NoYXIvcmFu
ZG9tLmMNCisrKyBiL2RyaXZlcnMvY2hhci9yYW5kb20uYw0KQEAgLTg4OSwxNiArODg5LDI0IEBA
IHN0YXRpYyBzaXplX3QgYWNjb3VudChzdHJ1Y3QgZW50cm9weV9zdG9yZSAqciwgc2l6ZV90IG5i
eXRlcywgaW50IG1pbiwNCiAJaWYgKHItPmVudHJvcHlfY291bnQgLyA4IDwgbWluICsgcmVzZXJ2
ZWQpIHsNCiAJCW5ieXRlcyA9IDA7DQogCX0gZWxzZSB7DQorCQlpbnQgZW50cm9weV9jb3VudCwg
b3JpZzsNCityZXRyeToNCisJCWVudHJvcHlfY291bnQgPSBvcmlnID0gQUNDRVNTX09OQ0Uoci0+
ZW50cm9weV9jb3VudCk7DQogCQkvKiBJZiBsaW1pdGVkLCBuZXZlciBwdWxsIG1vcmUgdGhhbiBh
dmFpbGFibGUgKi8NCi0JCWlmIChyLT5saW1pdCAmJiBuYnl0ZXMgKyByZXNlcnZlZCA+PSByLT5l
bnRyb3B5X2NvdW50IC8gOCkNCi0JCQluYnl0ZXMgPSByLT5lbnRyb3B5X2NvdW50LzggLSByZXNl
cnZlZDsNCi0NCi0JCWlmIChyLT5lbnRyb3B5X2NvdW50IC8gOCA+PSBuYnl0ZXMgKyByZXNlcnZl
ZCkNCi0JCQlyLT5lbnRyb3B5X2NvdW50IC09IG5ieXRlcyo4Ow0KLQkJZWxzZQ0KLQkJCXItPmVu
dHJvcHlfY291bnQgPSByZXNlcnZlZDsNCisJCWlmIChyLT5saW1pdCAmJiBuYnl0ZXMgKyByZXNl
cnZlZCA+PSBlbnRyb3B5X2NvdW50IC8gOCkNCisJCQluYnl0ZXMgPSBlbnRyb3B5X2NvdW50Lzgg
LSByZXNlcnZlZDsNCisNCisJCWlmIChlbnRyb3B5X2NvdW50IC8gOCA+PSBuYnl0ZXMgKyByZXNl
cnZlZCkgew0KKwkJCWVudHJvcHlfY291bnQgLT0gbmJ5dGVzKjg7DQorCQkJaWYgKGNtcHhjaGco
JnItPmVudHJvcHlfY291bnQsIG9yaWcsIGVudHJvcHlfY291bnQpICE9IG9yaWcpDQorCQkJCWdv
dG8gcmV0cnk7DQorCQl9IGVsc2Ugew0KKwkJCWVudHJvcHlfY291bnQgPSByZXNlcnZlZDsNCisJ
CQlpZiAoY21weGNoZygmci0+ZW50cm9weV9jb3VudCwgb3JpZywgZW50cm9weV9jb3VudCkgIT0g
b3JpZykNCisJCQkJZ290byByZXRyeTsNCisJCX0NCiANCi0JCWlmIChyLT5lbnRyb3B5X2NvdW50
IDwgcmFuZG9tX3dyaXRlX3dha2V1cF90aHJlc2gpIHsNCisJCWlmIChlbnRyb3B5X2NvdW50IDwg
cmFuZG9tX3dyaXRlX3dha2V1cF90aHJlc2gpIHsNCiAJCQl3YWtlX3VwX2ludGVycnVwdGlibGUo
JnJhbmRvbV93cml0ZV93YWl0KTsNCiAJCQlraWxsX2Zhc3luYygmZmFzeW5jLCBTSUdJTywgUE9M
TF9PVVQpOw0KIAkJfQ0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvZG1hL3BjaF9kbWEuYyBiL2RyaXZl
cnMvZG1hL3BjaF9kbWEuYw0KaW5kZXggNjI5YzQzMC4uNDkxMzhlNyAxMDA2NDQNCi0tLSBhL2Ry
aXZlcnMvZG1hL3BjaF9kbWEuYw0KKysrIGIvZHJpdmVycy9kbWEvcGNoX2RtYS5jDQpAQCAtNDg5
LDcgKzQ4OSw3IEBAIHN0YXRpYyBzdHJ1Y3QgcGNoX2RtYV9kZXNjICpwZGNfZGVzY19nZXQoc3Ry
dWN0IHBjaF9kbWFfY2hhbiAqcGRfY2hhbikNCiAJZGV2X2RiZyhjaGFuMmRldigmcGRfY2hhbi0+
Y2hhbiksICJzY2FubmVkICVkIGRlc2NyaXB0b3JzXG4iLCBpKTsNCiANCiAJaWYgKCFyZXQpIHsN
Ci0JCXJldCA9IHBkY19hbGxvY19kZXNjKCZwZF9jaGFuLT5jaGFuLCBHRlBfTk9JTyk7DQorCQly
ZXQgPSBwZGNfYWxsb2NfZGVzYygmcGRfY2hhbi0+Y2hhbiwgR0ZQX0FUT01JQyk7DQogCQlpZiAo
cmV0KSB7DQogCQkJc3Bpbl9sb2NrKCZwZF9jaGFuLT5sb2NrKTsNCiAJCQlwZF9jaGFuLT5kZXNj
c19hbGxvY2F0ZWQrKzsNCmRpZmYgLS1naXQgYS9kcml2ZXJzL2Zpcm13YXJlL2VmaXZhcnMuYyBi
L2RyaXZlcnMvZmlybXdhcmUvZWZpdmFycy5jDQppbmRleCBiMTVjMGFhLi4yYTY0ZTY5IDEwMDY0
NA0KLS0tIGEvZHJpdmVycy9maXJtd2FyZS9lZml2YXJzLmMNCisrKyBiL2RyaXZlcnMvZmlybXdh
cmUvZWZpdmFycy5jDQpAQCAtNDI1LDI0ICs0MjUsMTIgQEAgc3RhdGljIGVmaV9zdGF0dXNfdA0K
IGNoZWNrX3Zhcl9zaXplX2xvY2tlZChzdHJ1Y3QgZWZpdmFycyAqZWZpdmFycywgdTMyIGF0dHJp
YnV0ZXMsDQogCQkJdW5zaWduZWQgbG9uZyBzaXplKQ0KIHsNCi0JdTY0IHN0b3JhZ2Vfc2l6ZSwg
cmVtYWluaW5nX3NpemUsIG1heF9zaXplOw0KLQllZmlfc3RhdHVzX3Qgc3RhdHVzOw0KIAljb25z
dCBzdHJ1Y3QgZWZpdmFyX29wZXJhdGlvbnMgKmZvcHMgPSBlZml2YXJzLT5vcHM7DQogDQotCWlm
ICghZWZpdmFycy0+b3BzLT5xdWVyeV92YXJpYWJsZV9pbmZvKQ0KKwlpZiAoIWVmaXZhcnMtPm9w
cy0+cXVlcnlfdmFyaWFibGVfc3RvcmUpDQogCQlyZXR1cm4gRUZJX1VOU1VQUE9SVEVEOw0KIA0K
LQlzdGF0dXMgPSBmb3BzLT5xdWVyeV92YXJpYWJsZV9pbmZvKGF0dHJpYnV0ZXMsICZzdG9yYWdl
X3NpemUsDQotCQkJCQkgICAmcmVtYWluaW5nX3NpemUsICZtYXhfc2l6ZSk7DQotDQotCWlmIChz
dGF0dXMgIT0gRUZJX1NVQ0NFU1MpDQotCQlyZXR1cm4gc3RhdHVzOw0KLQ0KLQlpZiAoIXN0b3Jh
Z2Vfc2l6ZSB8fCBzaXplID4gcmVtYWluaW5nX3NpemUgfHwgc2l6ZSA+IG1heF9zaXplIHx8DQot
CSAgICAocmVtYWluaW5nX3NpemUgLSBzaXplKSA8IChzdG9yYWdlX3NpemUgLyAyKSkNCi0JCXJl
dHVybiBFRklfT1VUX09GX1JFU09VUkNFUzsNCi0NCi0JcmV0dXJuIHN0YXR1czsNCisJcmV0dXJu
IGZvcHMtPnF1ZXJ5X3ZhcmlhYmxlX3N0b3JlKGF0dHJpYnV0ZXMsIHNpemUpOw0KIH0NCiANCiBz
dGF0aWMgc3NpemVfdA0KQEAgLTE0NTYsNyArMTQ0NCw3IEBAIGVmaXZhcnNfaW5pdCh2b2lkKQ0K
IAlvcHMuZ2V0X3ZhcmlhYmxlID0gZWZpLmdldF92YXJpYWJsZTsNCiAJb3BzLnNldF92YXJpYWJs
ZSA9IGVmaS5zZXRfdmFyaWFibGU7DQogCW9wcy5nZXRfbmV4dF92YXJpYWJsZSA9IGVmaS5nZXRf
bmV4dF92YXJpYWJsZTsNCi0Jb3BzLnF1ZXJ5X3ZhcmlhYmxlX2luZm8gPSBlZmkucXVlcnlfdmFy
aWFibGVfaW5mbzsNCisJb3BzLnF1ZXJ5X3ZhcmlhYmxlX3N0b3JlID0gZWZpX3F1ZXJ5X3Zhcmlh
YmxlX3N0b3JlOw0KIAllcnJvciA9IHJlZ2lzdGVyX2VmaXZhcnMoJl9fZWZpdmFycywgJm9wcywg
ZWZpX2tvYmopOw0KIAlpZiAoZXJyb3IpDQogCQlnb3RvIGVycl9wdXQ7DQpkaWZmIC0tZ2l0IGEv
ZHJpdmVycy9ncHUvZHJtL2k5MTUvaTkxNV9kbWEuYyBiL2RyaXZlcnMvZ3B1L2RybS9pOTE1L2k5
MTVfZG1hLmMNCmluZGV4IGM3N2ZjNjcuLmNhNjczMzggMTAwNjQ0DQotLS0gYS9kcml2ZXJzL2dw
dS9kcm0vaTkxNS9pOTE1X2RtYS5jDQorKysgYi9kcml2ZXJzL2dwdS9kcm0vaTkxNS9pOTE1X2Rt
YS5jDQpAQCAtMTAwNyw1MCArMTAwNyw1NiBAQCBpbnRlbF90ZWFyZG93bl9tY2hiYXIoc3RydWN0
IGRybV9kZXZpY2UgKmRldikNCiAJCXJlbGVhc2VfcmVzb3VyY2UoJmRldl9wcml2LT5tY2hfcmVz
KTsNCiB9DQogDQotc3RhdGljIHVuc2lnbmVkIGxvbmcgaTkxNV9zdG9sZW5fdG9fcGh5c2ljYWwo
c3RydWN0IGRybV9kZXZpY2UgKmRldikNCisjZGVmaW5lIFBURV9BRERSRVNTX01BU0sJCTB4ZmZm
ZmYwMDANCisjZGVmaW5lIFBURV9BRERSRVNTX01BU0tfSElHSAkJMHgwMDAwMDBmMCAvKiBpOTE1
KyAqLw0KKyNkZWZpbmUgUFRFX01BUFBJTkdfVFlQRV9VTkNBQ0hFRAkoMCA8PCAxKQ0KKyNkZWZp
bmUgUFRFX01BUFBJTkdfVFlQRV9EQ0FDSEUJCSgxIDw8IDEpIC8qIGk4MzAgb25seSAqLw0KKyNk
ZWZpbmUgUFRFX01BUFBJTkdfVFlQRV9DQUNIRUQJCSgzIDw8IDEpDQorI2RlZmluZSBQVEVfTUFQ
UElOR19UWVBFX01BU0sJCSgzIDw8IDEpDQorI2RlZmluZSBQVEVfVkFMSUQJCQkoMSA8PCAwKQ0K
Kw0KKy8qKg0KKyAqIGk5MTVfc3RvbGVuX3RvX3BoeXMgLSB0YWtlIGFuIG9mZnNldCBpbnRvIHN0
b2xlbiBtZW1vcnkgYW5kIHR1cm4gaXQgaW50bw0KKyAqICAgICAgICAgICAgICAgICAgICAgICBh
IHBoeXNpY2FsIG9uZQ0KKyAqIEBkZXY6IGRybSBkZXZpY2UNCisgKiBAb2Zmc2V0OiBhZGRyZXNz
IHRvIHRyYW5zbGF0ZQ0KKyAqDQorICogU29tZSBjaGlwIGZ1bmN0aW9ucyByZXF1aXJlIGFsbG9j
YXRpb25zIGZyb20gc3RvbGVuIHNwYWNlIGFuZCBuZWVkIHRoZQ0KKyAqIHBoeXNpY2FsIGFkZHJl
c3Mgb2YgdGhlIG1lbW9yeSBpbiBxdWVzdGlvbi4NCisgKi8NCitzdGF0aWMgdW5zaWduZWQgbG9u
ZyBpOTE1X3N0b2xlbl90b19waHlzKHN0cnVjdCBkcm1fZGV2aWNlICpkZXYsIHUzMiBvZmZzZXQp
DQogew0KIAlzdHJ1Y3QgZHJtX2k5MTVfcHJpdmF0ZSAqZGV2X3ByaXYgPSBkZXYtPmRldl9wcml2
YXRlOw0KIAlzdHJ1Y3QgcGNpX2RldiAqcGRldiA9IGRldl9wcml2LT5icmlkZ2VfZGV2Ow0KIAl1
MzIgYmFzZTsNCiANCisjaWYgMA0KIAkvKiBPbiB0aGUgbWFjaGluZXMgSSBoYXZlIHRlc3RlZCB0
aGUgR3JhcGhpY3MgQmFzZSBvZiBTdG9sZW4gTWVtb3J5DQotCSAqIGlzIHVucmVsaWFibGUsIHNv
IG9uIHRob3NlIGNvbXB1dGUgdGhlIGJhc2UgYnkgc3VidHJhY3RpbmcgdGhlDQotCSAqIHN0b2xl
biBtZW1vcnkgZnJvbSB0aGUgVG9wIG9mIExvdyBVc2FibGUgRFJBTSB3aGljaCBpcyB3aGVyZSB0
aGUNCi0JICogQklPUyBwbGFjZXMgdGhlIGdyYXBoaWNzIHN0b2xlbiBtZW1vcnkuDQotCSAqDQot
CSAqIE9uIGdlbjIsIHRoZSBsYXlvdXQgaXMgc2xpZ2h0bHkgZGlmZmVyZW50IHdpdGggdGhlIEdy
YXBoaWNzIFNlZ21lbnQNCi0JICogaW1tZWRpYXRlbHkgZm9sbG93aW5nIFRvcCBvZiBNZW1vcnkg
KG9yIFRvcCBvZiBVc2FibGUgRFJBTSkuIE5vdGUNCi0JICogaXQgYXBwZWFycyB0aGF0IFRPVUQg
aXMgb25seSByZXBvcnRlZCBieSA4NjVnLCBzbyB3ZSBqdXN0IHVzZSB0aGUNCi0JICogdG9wIG9m
IG1lbW9yeSBhcyBkZXRlcm1pbmVkIGJ5IHRoZSBlODIwIHByb2JlLg0KLQkgKg0KLQkgKiBYWFgg
Z2VuMiByZXF1aXJlcyBhbiB1bmF2YWlsYWJsZSBzeW1ib2wgYW5kIDk0NWdtIGZhaWxzIHdpdGgN
Ci0JICogaXRzIHZhbHVlIG9mIFRPTFVELg0KKwkgKiBpcyB1bnJlbGlhYmxlLCBzbyBjb21wdXRl
IHRoZSBiYXNlIGJ5IHN1YnRyYWN0aW5nIHRoZSBzdG9sZW4gbWVtb3J5DQorCSAqIGZyb20gdGhl
IFRvcCBvZiBMb3cgVXNhYmxlIERSQU0gd2hpY2ggaXMgd2hlcmUgdGhlIEJJT1MgcGxhY2VzDQor
CSAqIHRoZSBncmFwaGljcyBzdG9sZW4gbWVtb3J5Lg0KIAkgKi8NCi0JYmFzZSA9IDA7DQotCWlm
IChJTlRFTF9JTkZPKGRldiktPmdlbiA+PSA2KSB7DQotCQkvKiBSZWFkIEJhc2UgRGF0YSBvZiBT
dG9sZW4gTWVtb3J5IFJlZ2lzdGVyIChCRFNNKSBkaXJlY3RseS4NCi0JCSAqIE5vdGUgdGhhdCB0
aGVyZSBpcyBhbHNvIGEgTUNIQkFSIG1pcm9yIGF0IDB4MTA4MGMwIG9yDQotCQkgKiB3ZSBjb3Vs
ZCB1c2UgZGV2aWNlIDI6MHg1YyBpbnN0ZWFkLg0KLQkJKi8NCi0JCXBjaV9yZWFkX2NvbmZpZ19k
d29yZChwZGV2LCAweEIwLCAmYmFzZSk7DQotCQliYXNlICY9IH40MDk1OyAvKiBsb3dlciBiaXRz
IHVzZWQgZm9yIGxvY2tpbmcgcmVnaXN0ZXIgKi8NCi0JfSBlbHNlIGlmIChJTlRFTF9JTkZPKGRl
diktPmdlbiA+IDMgfHwgSVNfRzMzKGRldikpIHsNCi0JCS8qIFJlYWQgR3JhcGhpY3MgQmFzZSBv
ZiBTdG9sZW4gTWVtb3J5IGRpcmVjdGx5ICovDQorCWlmIChJTlRFTF9JTkZPKGRldiktPmdlbiA+
IDMgfHwgSVNfRzMzKGRldikpIHsNCisJCS8qIHRvcCAzMmJpdHMgYXJlIHJlc2VydmVkID0gMCAq
Lw0KIAkJcGNpX3JlYWRfY29uZmlnX2R3b3JkKHBkZXYsIDB4QTQsICZiYXNlKTsNCi0jaWYgMA0K
LQl9IGVsc2UgaWYgKElTX0dFTjMoZGV2KSkgew0KKwl9IGVsc2Ugew0KKwkJLyogWFhYIHByZXN1
bWUgOHh4IGlzIHRoZSBzYW1lIGFzIGk5MTUgKi8NCisJCXBjaV9idXNfcmVhZF9jb25maWdfZHdv
cmQocGRldi0+YnVzLCAyLCAweDVDLCAmYmFzZSk7DQorCX0NCisjZWxzZQ0KKwlpZiAoSU5URUxf
SU5GTyhkZXYpLT5nZW4gPiAzIHx8IElTX0czMyhkZXYpKSB7DQorCQl1MTYgdmFsOw0KKwkJcGNp
X3JlYWRfY29uZmlnX3dvcmQocGRldiwgMHhiMCwgJnZhbCk7DQorCQliYXNlID0gdmFsID4+IDQg
PDwgMjA7DQorCX0gZWxzZSB7DQogCQl1OCB2YWw7DQotCQkvKiBTdG9sZW4gaXMgaW1tZWRpYXRl
bHkgYmVsb3cgVG9wIG9mIExvdyBVc2FibGUgRFJBTSAqLw0KIAkJcGNpX3JlYWRfY29uZmlnX2J5
dGUocGRldiwgMHg5YywgJnZhbCk7DQogCQliYXNlID0gdmFsID4+IDMgPDwgMjc7DQotCQliYXNl
IC09IGRldl9wcml2LT5tbS5ndHQtPnN0b2xlbl9zaXplOw0KLQl9IGVsc2Ugew0KLQkJLyogU3Rv
bGVuIGlzIGltbWVkaWF0ZWx5IGFib3ZlIFRvcCBvZiBNZW1vcnkgKi8NCi0JCWJhc2UgPSBtYXhf
bG93X3Bmbl9tYXBwZWQgPDwgUEFHRV9TSElGVDsNCi0jZW5kaWYNCiAJfQ0KKwliYXNlIC09IGRl
dl9wcml2LT5tbS5ndHQtPnN0b2xlbl9zaXplOw0KKyNlbmRpZg0KIA0KLQlyZXR1cm4gYmFzZTsN
CisJcmV0dXJuIGJhc2UgKyBvZmZzZXQ7DQogfQ0KIA0KIHN0YXRpYyB2b2lkIGk5MTVfd2Fybl9z
dG9sZW4oc3RydWN0IGRybV9kZXZpY2UgKmRldikNCkBAIC0xMDc1LDcgKzEwODEsNyBAQCBzdGF0
aWMgdm9pZCBpOTE1X3NldHVwX2NvbXByZXNzaW9uKHN0cnVjdCBkcm1fZGV2aWNlICpkZXYsIGlu
dCBzaXplKQ0KIAlpZiAoIWNvbXByZXNzZWRfZmIpDQogCQlnb3RvIGVycjsNCiANCi0JY2ZiX2Jh
c2UgPSBkZXZfcHJpdi0+bW0uc3RvbGVuX2Jhc2UgKyBjb21wcmVzc2VkX2ZiLT5zdGFydDsNCisJ
Y2ZiX2Jhc2UgPSBpOTE1X3N0b2xlbl90b19waHlzKGRldiwgY29tcHJlc3NlZF9mYi0+c3RhcnQp
Ow0KIAlpZiAoIWNmYl9iYXNlKQ0KIAkJZ290byBlcnJfZmI7DQogDQpAQCAtMTA4OCw3ICsxMDk0
LDcgQEAgc3RhdGljIHZvaWQgaTkxNV9zZXR1cF9jb21wcmVzc2lvbihzdHJ1Y3QgZHJtX2Rldmlj
ZSAqZGV2LCBpbnQgc2l6ZSkNCiAJCWlmICghY29tcHJlc3NlZF9sbGIpDQogCQkJZ290byBlcnJf
ZmI7DQogDQotCQlsbF9iYXNlID0gZGV2X3ByaXYtPm1tLnN0b2xlbl9iYXNlICsgY29tcHJlc3Nl
ZF9sbGItPnN0YXJ0Ow0KKwkJbGxfYmFzZSA9IGk5MTVfc3RvbGVuX3RvX3BoeXMoZGV2LCBjb21w
cmVzc2VkX2xsYi0+c3RhcnQpOw0KIAkJaWYgKCFsbF9iYXNlKQ0KIAkJCWdvdG8gZXJyX2xsYjsN
CiAJfQ0KQEAgLTExMDcsNyArMTExMyw3IEBAIHN0YXRpYyB2b2lkIGk5MTVfc2V0dXBfY29tcHJl
c3Npb24oc3RydWN0IGRybV9kZXZpY2UgKmRldiwgaW50IHNpemUpDQogCX0NCiANCiAJRFJNX0RF
QlVHX0tNUygiRkJDIGJhc2UgMHglMDhseCwgbGwgYmFzZSAweCUwOGx4LCBzaXplICVkTVxuIiwN
Ci0JCSAgICAgIChsb25nKWNmYl9iYXNlLCAobG9uZylsbF9iYXNlLCBzaXplID4+IDIwKTsNCisJ
CSAgICAgIGNmYl9iYXNlLCBsbF9iYXNlLCBzaXplID4+IDIwKTsNCiAJcmV0dXJuOw0KIA0KIGVy
cl9sbGI6DQpAQCAtMTE4MSwxMyArMTE4Nyw2IEBAIHN0YXRpYyBpbnQgaTkxNV9sb2FkX2dlbV9p
bml0KHN0cnVjdCBkcm1fZGV2aWNlICpkZXYpDQogCWd0dF9zaXplID0gZGV2X3ByaXYtPm1tLmd0
dC0+Z3R0X3RvdGFsX2VudHJpZXMgPDwgUEFHRV9TSElGVDsNCiAJbWFwcGFibGVfc2l6ZSA9IGRl
dl9wcml2LT5tbS5ndHQtPmd0dF9tYXBwYWJsZV9lbnRyaWVzIDw8IFBBR0VfU0hJRlQ7DQogDQot
CWRldl9wcml2LT5tbS5zdG9sZW5fYmFzZSA9IGk5MTVfc3RvbGVuX3RvX3BoeXNpY2FsKGRldik7
DQotCWlmIChkZXZfcHJpdi0+bW0uc3RvbGVuX2Jhc2UgPT0gMCkNCi0JCXJldHVybiAwOw0KLQ0K
LQlEUk1fREVCVUdfS01TKCJmb3VuZCAlZCBieXRlcyBvZiBzdG9sZW4gbWVtb3J5IGF0ICUwOGx4
XG4iLA0KLQkJICAgICAgZGV2X3ByaXYtPm1tLmd0dC0+c3RvbGVuX3NpemUsIGRldl9wcml2LT5t
bS5zdG9sZW5fYmFzZSk7DQotDQogCS8qIEJhc2ljIG1lbXJhbmdlIGFsbG9jYXRvciBmb3Igc3Rv
bGVuIHNwYWNlICovDQogCWRybV9tbV9pbml0KCZkZXZfcHJpdi0+bW0uc3RvbGVuLCAwLCBwcmVh
bGxvY19zaXplKTsNCiANCmRpZmYgLS1naXQgYS9kcml2ZXJzL2dwdS9kcm0vaTkxNS9pOTE1X2Ry
di5oIGIvZHJpdmVycy9ncHUvZHJtL2k5MTUvaTkxNV9kcnYuaA0KaW5kZXggMjBjZDI5NS4uMTQ0
ZDM3YyAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvZ3B1L2RybS9pOTE1L2k5MTVfZHJ2LmgNCisrKyBi
L2RyaXZlcnMvZ3B1L2RybS9pOTE1L2k5MTVfZHJ2LmgNCkBAIC01ODEsNyArNTgxLDYgQEAgdHlw
ZWRlZiBzdHJ1Y3QgZHJtX2k5MTVfcHJpdmF0ZSB7DQogCQl1bnNpZ25lZCBsb25nIGd0dF9zdGFy
dDsNCiAJCXVuc2lnbmVkIGxvbmcgZ3R0X21hcHBhYmxlX2VuZDsNCiAJCXVuc2lnbmVkIGxvbmcg
Z3R0X2VuZDsNCi0JCXVuc2lnbmVkIGxvbmcgc3RvbGVuX2Jhc2U7IC8qIGxpbWl0ZWQgdG8gbG93
IG1lbW9yeSAoMzItYml0KSAqLw0KIA0KIAkJc3RydWN0IGlvX21hcHBpbmcgKmd0dF9tYXBwaW5n
Ow0KIAkJaW50IGd0dF9tdHJyOw0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24v
cjMwMF9jbWRidWYuYyBiL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vcjMwMF9jbWRidWYuYw0KaW5k
ZXggMWZlOThiNC4uOWFhMDJiZSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24v
cjMwMF9jbWRidWYuYw0KKysrIGIvZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9yMzAwX2NtZGJ1Zi5j
DQpAQCAtNzQsNyArNzQsNyBAQCBzdGF0aWMgaW50IHIzMDBfZW1pdF9jbGlwcmVjdHMoZHJtX3Jh
ZGVvbl9wcml2YXRlX3QgKmRldl9wcml2LA0KIAkJT1VUX1JJTkcoQ1BfUEFDS0VUMChSMzAwX1JF
X0NMSVBSRUNUX1RMXzAsIG5yICogMiAtIDEpKTsNCiANCiAJCWZvciAoaSA9IDA7IGkgPCBucjsg
KytpKSB7DQotCQkJaWYgKERSTV9DT1BZX0ZST01fVVNFUl9VTkNIRUNLRUQNCisJCQlpZiAoRFJN
X0NPUFlfRlJPTV9VU0VSDQogCQkJICAgICgmYm94LCAmY21kYnVmLT5ib3hlc1tuICsgaV0sIHNp
emVvZihib3gpKSkgew0KIAkJCQlEUk1fRVJST1IoImNvcHkgY2xpcHJlY3QgZmF1bHRlZFxuIik7
DQogCQkJCXJldHVybiAtRUZBVUxUOw0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvaHdtb24vYWJpdHVn
dXJ1LmMgYi9kcml2ZXJzL2h3bW9uL2FiaXR1Z3VydS5jDQppbmRleCA2NWEzNWNmLi42MWFiNjE1
IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9od21vbi9hYml0dWd1cnUuYw0KKysrIGIvZHJpdmVycy9o
d21vbi9hYml0dWd1cnUuYw0KQEAgLTEyODAsMTQgKzEyODAsMTggQEAgc3RhdGljIGludCBfX2Rl
dmluaXQgYWJpdHVndXJ1X3Byb2JlKHN0cnVjdCBwbGF0Zm9ybV9kZXZpY2UgKnBkZXYpDQogCXBy
X2luZm8oImZvdW5kIEFiaXQgdUd1cnVcbiIpOw0KIA0KIAkvKiBSZWdpc3RlciBzeXNmcyBob29r
cyAqLw0KLQlmb3IgKGkgPSAwOyBpIDwgc3lzZnNfYXR0cl9pOyBpKyspDQotCQlpZiAoZGV2aWNl
X2NyZWF0ZV9maWxlKCZwZGV2LT5kZXYsDQotCQkJCSZkYXRhLT5zeXNmc19hdHRyW2ldLmRldl9h
dHRyKSkNCisJZm9yIChpID0gMDsgaSA8IHN5c2ZzX2F0dHJfaTsgaSsrKSB7DQorCQlyZXMgPSBk
ZXZpY2VfY3JlYXRlX2ZpbGUoJnBkZXYtPmRldiwNCisJCQkJCSAmZGF0YS0+c3lzZnNfYXR0cltp
XS5kZXZfYXR0cik7DQorCQlpZiAocmVzKQ0KIAkJCWdvdG8gYWJpdHVndXJ1X3Byb2JlX2Vycm9y
Ow0KLQlmb3IgKGkgPSAwOyBpIDwgQVJSQVlfU0laRShhYml0dWd1cnVfc3lzZnNfYXR0cik7IGkr
KykNCi0JCWlmIChkZXZpY2VfY3JlYXRlX2ZpbGUoJnBkZXYtPmRldiwNCi0JCQkJJmFiaXR1Z3Vy
dV9zeXNmc19hdHRyW2ldLmRldl9hdHRyKSkNCisJfQ0KKwlmb3IgKGkgPSAwOyBpIDwgQVJSQVlf
U0laRShhYml0dWd1cnVfc3lzZnNfYXR0cik7IGkrKykgew0KKwkJcmVzID0gZGV2aWNlX2NyZWF0
ZV9maWxlKCZwZGV2LT5kZXYsDQorCQkJCQkgJmFiaXR1Z3VydV9zeXNmc19hdHRyW2ldLmRldl9h
dHRyKTsNCisJCWlmIChyZXMpDQogCQkJZ290byBhYml0dWd1cnVfcHJvYmVfZXJyb3I7DQorCX0N
CiANCiAJZGF0YS0+aHdtb25fZGV2ID0gaHdtb25fZGV2aWNlX3JlZ2lzdGVyKCZwZGV2LT5kZXYp
Ow0KIAlpZiAoIUlTX0VSUihkYXRhLT5od21vbl9kZXYpKQ0KZGlmZiAtLWdpdCBhL2RyaXZlcnMv
aTJjL2J1c3Nlcy9pMmMtZGVzaWdud2FyZS1jb3JlLmMgYi9kcml2ZXJzL2kyYy9idXNzZXMvaTJj
LWRlc2lnbndhcmUtY29yZS5jDQppbmRleCA2MTkzMzQ5Li4zYzI4MTJmIDEwMDY0NA0KLS0tIGEv
ZHJpdmVycy9pMmMvYnVzc2VzL2kyYy1kZXNpZ253YXJlLWNvcmUuYw0KKysrIGIvZHJpdmVycy9p
MmMvYnVzc2VzL2kyYy1kZXNpZ253YXJlLWNvcmUuYw0KQEAgLTM0OSw3ICszNDksOCBAQCBzdGF0
aWMgdm9pZCBpMmNfZHdfeGZlcl9pbml0KHN0cnVjdCBkd19pMmNfZGV2ICpkZXYpDQogCS8qIEVu
YWJsZSB0aGUgYWRhcHRlciAqLw0KIAlkd193cml0ZWwoZGV2LCAxLCBEV19JQ19FTkFCTEUpOw0K
IA0KLQkvKiBFbmFibGUgaW50ZXJydXB0cyAqLw0KKwkvKiBDbGVhciBhbmQgZW5hYmxlIGludGVy
cnVwdHMgKi8NCisJaTJjX2R3X2NsZWFyX2ludChkZXYpOw0KIAlkd193cml0ZWwoZGV2LCBEV19J
Q19JTlRSX0RFRkFVTFRfTUFTSywgRFdfSUNfSU5UUl9NQVNLKTsNCiB9DQogDQpkaWZmIC0tZ2l0
IGEvZHJpdmVycy9tZC9kbS1idWZpby5jIGIvZHJpdmVycy9tZC9kbS1idWZpby5jDQppbmRleCAw
YTY4MDZmLi5hNWRmY2MwIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9tZC9kbS1idWZpby5jDQorKysg
Yi9kcml2ZXJzL21kL2RtLWJ1ZmlvLmMNCkBAIC0zMjIsNiArMzIyLDkgQEAgc3RhdGljIHZvaWQg
X19jYWNoZV9zaXplX3JlZnJlc2godm9pZCkNCiBzdGF0aWMgdm9pZCAqYWxsb2NfYnVmZmVyX2Rh
dGEoc3RydWN0IGRtX2J1ZmlvX2NsaWVudCAqYywgZ2ZwX3QgZ2ZwX21hc2ssDQogCQkJICAgICAg
IGVudW0gZGF0YV9tb2RlICpkYXRhX21vZGUpDQogew0KKwl1bnNpZ25lZCBub2lvX2ZsYWc7DQor
CXZvaWQgKnB0cjsNCisNCiAJaWYgKGMtPmJsb2NrX3NpemUgPD0gRE1fQlVGSU9fQkxPQ0tfU0la
RV9TTEFCX0xJTUlUKSB7DQogCQkqZGF0YV9tb2RlID0gREFUQV9NT0RFX1NMQUI7DQogCQlyZXR1
cm4ga21lbV9jYWNoZV9hbGxvYyhETV9CVUZJT19DQUNIRShjKSwgZ2ZwX21hc2spOw0KQEAgLTMz
NSw3ICszMzgsMjggQEAgc3RhdGljIHZvaWQgKmFsbG9jX2J1ZmZlcl9kYXRhKHN0cnVjdCBkbV9i
dWZpb19jbGllbnQgKmMsIGdmcF90IGdmcF9tYXNrLA0KIAl9DQogDQogCSpkYXRhX21vZGUgPSBE
QVRBX01PREVfVk1BTExPQzsNCi0JcmV0dXJuIF9fdm1hbGxvYyhjLT5ibG9ja19zaXplLCBnZnBf
bWFzaywgUEFHRV9LRVJORUwpOw0KKw0KKwkvKg0KKwkgKiBfX3ZtYWxsb2MgYWxsb2NhdGVzIHRo
ZSBkYXRhIHBhZ2VzIGFuZCBhdXhpbGlhcnkgc3RydWN0dXJlcyB3aXRoDQorCSAqIGdmcF9mbGFn
cyB0aGF0IHdlcmUgc3BlY2lmaWVkLCBidXQgcGFnZXRhYmxlcyBhcmUgYWx3YXlzIGFsbG9jYXRl
ZA0KKwkgKiB3aXRoIEdGUF9LRVJORUwsIG5vIG1hdHRlciB3aGF0IHdhcyBzcGVjaWZpZWQgYXMg
Z2ZwX21hc2suDQorCSAqDQorCSAqIENvbnNlcXVlbnRseSwgd2UgbXVzdCBzZXQgcGVyLXByb2Nl
c3MgZmxhZyBQRl9NRU1BTExPQ19OT0lPIHNvIHRoYXQNCisJICogYWxsIGFsbG9jYXRpb25zIGRv
bmUgYnkgdGhpcyBwcm9jZXNzIChpbmNsdWRpbmcgcGFnZXRhYmxlcykgYXJlIGRvbmUNCisJICog
YXMgaWYgR0ZQX05PSU8gd2FzIHNwZWNpZmllZC4NCisJICovDQorDQorCWlmIChnZnBfbWFzayAm
IF9fR0ZQX05PUkVUUlkpIHsNCisJCW5vaW9fZmxhZyA9IGN1cnJlbnQtPmZsYWdzICYgUEZfTUVN
QUxMT0M7DQorCQljdXJyZW50LT5mbGFncyB8PSBQRl9NRU1BTExPQzsNCisJfQ0KKw0KKwlwdHIg
PSBfX3ZtYWxsb2MoYy0+YmxvY2tfc2l6ZSwgZ2ZwX21hc2ssIFBBR0VfS0VSTkVMKTsNCisNCisJ
aWYgKGdmcF9tYXNrICYgX19HRlBfTk9SRVRSWSkNCisJCWN1cnJlbnQtPmZsYWdzID0gKGN1cnJl
bnQtPmZsYWdzICYgflBGX01FTUFMTE9DKSB8IG5vaW9fZmxhZzsNCisNCisJcmV0dXJuIHB0cjsN
CiB9DQogDQogLyoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL21kL2RtLXNuYXAuYyBiL2RyaXZlcnMv
bWQvZG0tc25hcC5jDQppbmRleCAzNGVjMmI1Li5iNGFhYTdiIDEwMDY0NA0KLS0tIGEvZHJpdmVy
cy9tZC9kbS1zbmFwLmMNCisrKyBiL2RyaXZlcnMvbWQvZG0tc25hcC5jDQpAQCAtMTExNyw2ICsx
MTE3LDcgQEAgc3RhdGljIGludCBzbmFwc2hvdF9jdHIoc3RydWN0IGRtX3RhcmdldCAqdGksIHVu
c2lnbmVkIGludCBhcmdjLCBjaGFyICoqYXJndikNCiAJcy0+cGVuZGluZ19wb29sID0gbWVtcG9v
bF9jcmVhdGVfc2xhYl9wb29sKE1JTl9JT1MsIHBlbmRpbmdfY2FjaGUpOw0KIAlpZiAoIXMtPnBl
bmRpbmdfcG9vbCkgew0KIAkJdGktPmVycm9yID0gIkNvdWxkIG5vdCBhbGxvY2F0ZSBtZW1wb29s
IGZvciBwZW5kaW5nIGV4Y2VwdGlvbnMiOw0KKwkJciA9IC1FTk9NRU07DQogCQlnb3RvIGJhZF9w
ZW5kaW5nX3Bvb2w7DQogCX0NCiANCmRpZmYgLS1naXQgYS9kcml2ZXJzL21lZGlhL2R2Yi9tYW50
aXMvbWFudGlzX2R2Yi5jIGIvZHJpdmVycy9tZWRpYS9kdmIvbWFudGlzL21hbnRpc19kdmIuYw0K
aW5kZXggZTUxODBlNC4uNWQxNWM2YiAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbWVkaWEvZHZiL21h
bnRpcy9tYW50aXNfZHZiLmMNCisrKyBiL2RyaXZlcnMvbWVkaWEvZHZiL21hbnRpcy9tYW50aXNf
ZHZiLmMNCkBAIC0yNDgsOCArMjQ4LDEwIEBAIGludCBfX2RldmluaXQgbWFudGlzX2R2Yl9pbml0
KHN0cnVjdCBtYW50aXNfcGNpICptYW50aXMpDQogZXJyNToNCiAJdGFza2xldF9raWxsKCZtYW50
aXMtPnRhc2tsZXQpOw0KIAlkdmJfbmV0X3JlbGVhc2UoJm1hbnRpcy0+ZHZibmV0KTsNCi0JZHZi
X3VucmVnaXN0ZXJfZnJvbnRlbmQobWFudGlzLT5mZSk7DQotCWR2Yl9mcm9udGVuZF9kZXRhY2go
bWFudGlzLT5mZSk7DQorCWlmIChtYW50aXMtPmZlKSB7DQorCQlkdmJfdW5yZWdpc3Rlcl9mcm9u
dGVuZChtYW50aXMtPmZlKTsNCisJCWR2Yl9mcm9udGVuZF9kZXRhY2gobWFudGlzLT5mZSk7DQor
CX0NCiBlcnI0Og0KIAltYW50aXMtPmRlbXV4LmRteC5yZW1vdmVfZnJvbnRlbmQoJm1hbnRpcy0+
ZGVtdXguZG14LCAmbWFudGlzLT5mZV9tZW0pOw0KIA0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWZk
L2FkcDU1MjAuYyBiL2RyaXZlcnMvbWZkL2FkcDU1MjAuYw0KaW5kZXggOGQ4MTZjYy4uMTA1Zjgy
MCAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbWZkL2FkcDU1MjAuYw0KKysrIGIvZHJpdmVycy9tZmQv
YWRwNTUyMC5jDQpAQCAtMzYsNiArMzYsNyBAQCBzdHJ1Y3QgYWRwNTUyMF9jaGlwIHsNCiAJc3Ry
dWN0IGJsb2NraW5nX25vdGlmaWVyX2hlYWQgbm90aWZpZXJfbGlzdDsNCiAJaW50IGlycTsNCiAJ
dW5zaWduZWQgbG9uZyBpZDsNCisJdWludDhfdCBtb2RlOw0KIH07DQogDQogc3RhdGljIGludCBf
X2FkcDU1MjBfcmVhZChzdHJ1Y3QgaTJjX2NsaWVudCAqY2xpZW50LA0KQEAgLTMyNiw3ICszMjcs
MTAgQEAgc3RhdGljIGludCBhZHA1NTIwX3N1c3BlbmQoc3RydWN0IGRldmljZSAqZGV2KQ0KIAlz
dHJ1Y3QgaTJjX2NsaWVudCAqY2xpZW50ID0gdG9faTJjX2NsaWVudChkZXYpOw0KIAlzdHJ1Y3Qg
YWRwNTUyMF9jaGlwICpjaGlwID0gZGV2X2dldF9kcnZkYXRhKCZjbGllbnQtPmRldik7DQogDQot
CWFkcDU1MjBfY2xyX2JpdHMoY2hpcC0+ZGV2LCBBRFA1NTIwX01PREVfU1RBVFVTLCBBRFA1NTIw
X25TVE5CWSk7DQorCWFkcDU1MjBfcmVhZChjaGlwLT5kZXYsIEFEUDU1MjBfTU9ERV9TVEFUVVMs
ICZjaGlwLT5tb2RlKTsNCisJLyogQWxsIG90aGVyIGJpdHMgYXJlIFcxQyAqLw0KKwljaGlwLT5t
b2RlICY9IEFEUDU1MjBfQkxfRU4gfCBBRFA1NTIwX0RJTV9FTiB8IEFEUDU1MjBfblNUTkJZOw0K
KwlhZHA1NTIwX3dyaXRlKGNoaXAtPmRldiwgQURQNTUyMF9NT0RFX1NUQVRVUywgMCk7DQogCXJl
dHVybiAwOw0KIH0NCiANCkBAIC0zMzUsNyArMzM5LDcgQEAgc3RhdGljIGludCBhZHA1NTIwX3Jl
c3VtZShzdHJ1Y3QgZGV2aWNlICpkZXYpDQogCXN0cnVjdCBpMmNfY2xpZW50ICpjbGllbnQgPSB0
b19pMmNfY2xpZW50KGRldik7DQogCXN0cnVjdCBhZHA1NTIwX2NoaXAgKmNoaXAgPSBkZXZfZ2V0
X2RydmRhdGEoJmNsaWVudC0+ZGV2KTsNCiANCi0JYWRwNTUyMF9zZXRfYml0cyhjaGlwLT5kZXYs
IEFEUDU1MjBfTU9ERV9TVEFUVVMsIEFEUDU1MjBfblNUTkJZKTsNCisJYWRwNTUyMF93cml0ZShj
aGlwLT5kZXYsIEFEUDU1MjBfTU9ERV9TVEFUVVMsIGNoaXAtPm1vZGUpOw0KIAlyZXR1cm4gMDsN
CiB9DQogI2VuZGlmDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9tbWMvY29yZS9tbWMuYyBiL2RyaXZl
cnMvbW1jL2NvcmUvbW1jLmMNCmluZGV4IGZiN2MyN2YuLmMxYWVjMDYgMTAwNjQ0DQotLS0gYS9k
cml2ZXJzL21tYy9jb3JlL21tYy5jDQorKysgYi9kcml2ZXJzL21tYy9jb3JlL21tYy5jDQpAQCAt
MzYzLDEzICszNjMsMTMgQEAgc3RhdGljIGludCBtbWNfcmVhZF9leHRfY3NkKHN0cnVjdCBtbWNf
Y2FyZCAqY2FyZCwgdTggKmV4dF9jc2QpDQogCQlleHRfY3NkW0VYVF9DU0RfU0VDX0ZFQVRVUkVf
U1VQUE9SVF07DQogCWNhcmQtPmV4dF9jc2QucmF3X3RyaW1fbXVsdCA9DQogCQlleHRfY3NkW0VY
VF9DU0RfVFJJTV9NVUxUXTsNCisJY2FyZC0+ZXh0X2NzZC5yYXdfcGFydGl0aW9uX3N1cHBvcnQg
PSBleHRfY3NkW0VYVF9DU0RfUEFSVElUSU9OX1NVUFBPUlRdOw0KIAlpZiAoY2FyZC0+ZXh0X2Nz
ZC5yZXYgPj0gNCkgew0KIAkJLyoNCiAJCSAqIEVuaGFuY2VkIGFyZWEgZmVhdHVyZSBzdXBwb3J0
IC0tIGNoZWNrIHdoZXRoZXIgdGhlIGVNTUMNCiAJCSAqIGNhcmQgaGFzIHRoZSBFbmhhbmNlZCBh
cmVhIGVuYWJsZWQuICBJZiBzbywgZXhwb3J0IGVuaGFuY2VkDQogCQkgKiBhcmVhIG9mZnNldCBh
bmQgc2l6ZSB0byB1c2VyIGJ5IGFkZGluZyBzeXNmcyBpbnRlcmZhY2UuDQogCQkgKi8NCi0JCWNh
cmQtPmV4dF9jc2QucmF3X3BhcnRpdGlvbl9zdXBwb3J0ID0gZXh0X2NzZFtFWFRfQ1NEX1BBUlRJ
VElPTl9TVVBQT1JUXTsNCiAJCWlmICgoZXh0X2NzZFtFWFRfQ1NEX1BBUlRJVElPTl9TVVBQT1JU
XSAmIDB4MikgJiYNCiAJCSAgICAoZXh0X2NzZFtFWFRfQ1NEX1BBUlRJVElPTl9BVFRSSUJVVEVd
ICYgMHgxKSkgew0KIAkJCWhjX2VyYXNlX2dycF9zeiA9DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9t
bWMvaG9zdC9LY29uZmlnIGIvZHJpdmVycy9tbWMvaG9zdC9LY29uZmlnDQppbmRleCBjZjQ0NGIw
Li45MDIzM2FkIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9tbWMvaG9zdC9LY29uZmlnDQorKysgYi9k
cml2ZXJzL21tYy9ob3N0L0tjb25maWcNCkBAIC0yOTcsMTYgKzI5Nyw2IEBAIGNvbmZpZyBNTUNf
QVRNRUxNQ0kNCiANCiBlbmRjaG9pY2UNCiANCi1jb25maWcgTU1DX0FUTUVMTUNJX0RNQQ0KLQli
b29sICJBdG1lbCBNQ0kgRE1BIHN1cHBvcnQiDQotCWRlcGVuZHMgb24gTU1DX0FUTUVMTUNJICYm
IChBVlIzMiB8fCBBUkNIX0FUOTFTQU05RzQ1KSAmJiBETUFfRU5HSU5FDQotCWhlbHANCi0JICBT
YXkgWSBoZXJlIHRvIGhhdmUgdGhlIEF0bWVsIE1DSSBkcml2ZXIgdXNlIGEgRE1BIGVuZ2luZSB0
bw0KLQkgIGRvIGRhdGEgdHJhbnNmZXJzIGFuZCB0aHVzIGluY3JlYXNlIHRoZSB0aHJvdWdocHV0
IGFuZA0KLQkgIHJlZHVjZSB0aGUgQ1BVIHV0aWxpemF0aW9uLg0KLQ0KLQkgIElmIHVuc3VyZSwg
c2F5IE4uDQotDQogY29uZmlnIE1NQ19JTVgNCiAJdHJpc3RhdGUgIk1vdG9yb2xhIGkuTVggTXVs
dGltZWRpYSBDYXJkIEludGVyZmFjZSBzdXBwb3J0Ig0KIAlkZXBlbmRzIG9uIEFSQ0hfTVgxDQpk
aWZmIC0tZ2l0IGEvZHJpdmVycy9tbWMvaG9zdC9hdG1lbC1tY2kuYyBiL2RyaXZlcnMvbW1jL2hv
c3QvYXRtZWwtbWNpLmMNCmluZGV4IDA5MzIwMjQuLjgzNzkwZjIgMTAwNjQ0DQotLS0gYS9kcml2
ZXJzL21tYy9ob3N0L2F0bWVsLW1jaS5jDQorKysgYi9kcml2ZXJzL21tYy9ob3N0L2F0bWVsLW1j
aS5jDQpAQCAtMTYzLDYgKzE2Myw3IEBAIHN0cnVjdCBhdG1lbF9tY2kgew0KIAl2b2lkIF9faW9t
ZW0JCSpyZWdzOw0KIA0KIAlzdHJ1Y3Qgc2NhdHRlcmxpc3QJKnNnOw0KKwl1bnNpZ25lZCBpbnQJ
CXNnX2xlbjsNCiAJdW5zaWduZWQgaW50CQlwaW9fb2Zmc2V0Ow0KIA0KIAlzdHJ1Y3QgYXRtZWxf
bWNpX3Nsb3QJKmN1cl9zbG90Ow0KQEAgLTc1MSw2ICs3NTIsNyBAQCBzdGF0aWMgdTMyIGF0bWNp
X3ByZXBhcmVfZGF0YShzdHJ1Y3QgYXRtZWxfbWNpICpob3N0LCBzdHJ1Y3QgbW1jX2RhdGEgKmRh
dGEpDQogCWRhdGEtPmVycm9yID0gLUVJTlBST0dSRVNTOw0KIA0KIAlob3N0LT5zZyA9IGRhdGEt
PnNnOw0KKwlob3N0LT5zZ19sZW4gPSBkYXRhLT5zZ19sZW47DQogCWhvc3QtPmRhdGEgPSBkYXRh
Ow0KIAlob3N0LT5kYXRhX2NoYW4gPSBOVUxMOw0KIA0KQEAgLTE1NzMsNyArMTU3NSw4IEBAIHN0
YXRpYyB2b2lkIGF0bWNpX3JlYWRfZGF0YV9waW8oc3RydWN0IGF0bWVsX21jaSAqaG9zdCkNCiAJ
CQlpZiAob2Zmc2V0ID09IHNnLT5sZW5ndGgpIHsNCiAJCQkJZmx1c2hfZGNhY2hlX3BhZ2Uoc2df
cGFnZShzZykpOw0KIAkJCQlob3N0LT5zZyA9IHNnID0gc2dfbmV4dChzZyk7DQotCQkJCWlmICgh
c2cpDQorCQkJCWhvc3QtPnNnX2xlbi0tOw0KKwkJCQlpZiAoIXNnIHx8ICFob3N0LT5zZ19sZW4p
DQogCQkJCQlnb3RvIGRvbmU7DQogDQogCQkJCW9mZnNldCA9IDA7DQpAQCAtMTU4Niw3ICsxNTg5
LDggQEAgc3RhdGljIHZvaWQgYXRtY2lfcmVhZF9kYXRhX3BpbyhzdHJ1Y3QgYXRtZWxfbWNpICpo
b3N0KQ0KIA0KIAkJCWZsdXNoX2RjYWNoZV9wYWdlKHNnX3BhZ2Uoc2cpKTsNCiAJCQlob3N0LT5z
ZyA9IHNnID0gc2dfbmV4dChzZyk7DQotCQkJaWYgKCFzZykNCisJCQlob3N0LT5zZ19sZW4tLTsN
CisJCQlpZiAoIXNnIHx8ICFob3N0LT5zZ19sZW4pDQogCQkJCWdvdG8gZG9uZTsNCiANCiAJCQlv
ZmZzZXQgPSA0IC0gcmVtYWluaW5nOw0KQEAgLTE2NDAsNyArMTY0NCw4IEBAIHN0YXRpYyB2b2lk
IGF0bWNpX3dyaXRlX2RhdGFfcGlvKHN0cnVjdCBhdG1lbF9tY2kgKmhvc3QpDQogCQkJbmJ5dGVz
ICs9IDQ7DQogCQkJaWYgKG9mZnNldCA9PSBzZy0+bGVuZ3RoKSB7DQogCQkJCWhvc3QtPnNnID0g
c2cgPSBzZ19uZXh0KHNnKTsNCi0JCQkJaWYgKCFzZykNCisJCQkJaG9zdC0+c2dfbGVuLS07DQor
CQkJCWlmICghc2cgfHwgIWhvc3QtPnNnX2xlbikNCiAJCQkJCWdvdG8gZG9uZTsNCiANCiAJCQkJ
b2Zmc2V0ID0gMDsNCkBAIC0xNjU0LDcgKzE2NTksOCBAQCBzdGF0aWMgdm9pZCBhdG1jaV93cml0
ZV9kYXRhX3BpbyhzdHJ1Y3QgYXRtZWxfbWNpICpob3N0KQ0KIAkJCW5ieXRlcyArPSByZW1haW5p
bmc7DQogDQogCQkJaG9zdC0+c2cgPSBzZyA9IHNnX25leHQoc2cpOw0KLQkJCWlmICghc2cpIHsN
CisJCQlob3N0LT5zZ19sZW4tLTsNCisJCQlpZiAoIXNnIHx8ICFob3N0LT5zZ19sZW4pIHsNCiAJ
CQkJYXRtY2lfd3JpdGVsKGhvc3QsIEFUTUNJX1REUiwgdmFsdWUpOw0KIAkJCQlnb3RvIGRvbmU7
DQogCQkJfQ0KQEAgLTIxNjcsMTAgKzIxNzMsOCBAQCBzdGF0aWMgaW50IF9fZXhpdCBhdG1jaV9y
ZW1vdmUoc3RydWN0IHBsYXRmb3JtX2RldmljZSAqcGRldikNCiAJYXRtY2lfcmVhZGwoaG9zdCwg
QVRNQ0lfU1IpOw0KIAljbGtfZGlzYWJsZShob3N0LT5tY2spOw0KIA0KLSNpZmRlZiBDT05GSUdf
TU1DX0FUTUVMTUNJX0RNQQ0KIAlpZiAoaG9zdC0+ZG1hLmNoYW4pDQogCQlkbWFfcmVsZWFzZV9j
aGFubmVsKGhvc3QtPmRtYS5jaGFuKTsNCi0jZW5kaWYNCiANCiAJZnJlZV9pcnEocGxhdGZvcm1f
Z2V0X2lycShwZGV2LCAwKSwgaG9zdCk7DQogCWlvdW5tYXAoaG9zdC0+cmVncyk7DQpkaWZmIC0t
Z2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvM2NvbS8zYzUwOS5jIGIvZHJpdmVycy9uZXQvZXRo
ZXJuZXQvM2NvbS8zYzUwOS5jDQppbmRleCA5MjA1M2U2Li5jMTVkNmNlIDEwMDY0NA0KLS0tIGEv
ZHJpdmVycy9uZXQvZXRoZXJuZXQvM2NvbS8zYzUwOS5jDQorKysgYi9kcml2ZXJzL25ldC9ldGhl
cm5ldC8zY29tLzNjNTA5LmMNCkBAIC0zMDksNiArMzA5LDcgQEAgc3RhdGljIGludCBfX2Rldmlu
aXQgZWwzX2lzYV9tYXRjaChzdHJ1Y3QgZGV2aWNlICpwZGV2LA0KIAlpZiAoIWRldikNCiAJCXJl
dHVybiAtRU5PTUVNOw0KIA0KKwlTRVRfTkVUREVWX0RFVihkZXYsIHBkZXYpOw0KIAluZXRkZXZf
Ym9vdF9zZXR1cF9jaGVjayhkZXYpOw0KIA0KIAlpZiAoIXJlcXVlc3RfcmVnaW9uKGlvYWRkciwg
RUwzX0lPX0VYVEVOVCwgIjNjNTA5LWlzYSIpKSB7DQpAQCAtNzA0LDYgKzcwNSw3IEBAIHN0YXRp
YyBpbnQgX19pbml0IGVsM19laXNhX3Byb2JlIChzdHJ1Y3QgZGV2aWNlICpkZXZpY2UpDQogCQly
ZXR1cm4gLUVOT01FTTsNCiAJfQ0KIA0KKwlTRVRfTkVUREVWX0RFVihkZXYsIGRldmljZSk7DQog
CW5ldGRldl9ib290X3NldHVwX2NoZWNrKGRldik7DQogDQogCWVsM19kZXZfZmlsbChkZXYsIHBo
eXNfYWRkciwgaW9hZGRyLCBpcnEsIGlmX3BvcnQsIEVMM19FSVNBKTsNCmRpZmYgLS1naXQgYS9k
cml2ZXJzL25ldC9ldGhlcm5ldC8zY29tLzNjNTl4LmMgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC8z
Y29tLzNjNTl4LmMNCmluZGV4IGUwYzU1MjkuLmVmYzlkZWUgMTAwNjQ0DQotLS0gYS9kcml2ZXJz
L25ldC9ldGhlcm5ldC8zY29tLzNjNTl4LmMNCisrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0LzNj
b20vM2M1OXguYw0KQEAgLTYzMiw3ICs2MzIsNiBAQCBzdHJ1Y3Qgdm9ydGV4X3ByaXZhdGUgew0K
IAkJcG1fc3RhdGVfdmFsaWQ6MSwJCQkJLyogcGNpX2Rldi0+c2F2ZWRfY29uZmlnX3NwYWNlIGhh
cyBzYW5lIGNvbnRlbnRzICovDQogCQlvcGVuOjEsDQogCQltZWRpYWxvY2s6MSwNCi0JCW11c3Rf
ZnJlZV9yZWdpb246MSwJCQkJLyogRmxhZzogaWYgemVybywgQ2FyZGJ1cyBvd25zIHRoZSBJL08g
cmVnaW9uICovDQogCQlsYXJnZV9mcmFtZXM6MSwJCQkvKiBhY2NlcHQgbGFyZ2UgZnJhbWVzICov
DQogCQloYW5kbGluZ19pcnE6MTsJCQkvKiBwcml2YXRlIGluX2lycSBpbmRpY2F0b3IgKi8NCiAJ
Lyoge2dldHxzZXR9X3dvbCBvcGVyYXRpb25zIGFyZSBhbHJlYWR5IHNlcmlhbGl6ZWQgYnkgcnRu
bC4NCkBAIC05NTEsNyArOTUwLDcgQEAgc3RhdGljIGludCBfX2RldmV4aXQgdm9ydGV4X2Vpc2Ff
cmVtb3ZlKHN0cnVjdCBkZXZpY2UgKmRldmljZSkNCiANCiAJdW5yZWdpc3Rlcl9uZXRkZXYoZGV2
KTsNCiAJaW93cml0ZTE2KFRvdGFsUmVzZXR8MHgxNCwgaW9hZGRyICsgRUwzX0NNRCk7DQotCXJl
bGVhc2VfcmVnaW9uKGRldi0+YmFzZV9hZGRyLCBWT1JURVhfVE9UQUxfU0laRSk7DQorCXJlbGVh
c2VfcmVnaW9uKGVkZXYtPmJhc2VfYWRkciwgVk9SVEVYX1RPVEFMX1NJWkUpOw0KIA0KIAlmcmVl
X25ldGRldihkZXYpOw0KIAlyZXR1cm4gMDsNCkBAIC0xMDEyLDYgKzEwMTEsMTIgQEAgc3RhdGlj
IGludCBfX2RldmluaXQgdm9ydGV4X2luaXRfb25lKHN0cnVjdCBwY2lfZGV2ICpwZGV2LA0KIAlp
ZiAocmMgPCAwKQ0KIAkJZ290byBvdXQ7DQogDQorCXJjID0gcGNpX3JlcXVlc3RfcmVnaW9ucyhw
ZGV2LCBEUlZfTkFNRSk7DQorCWlmIChyYyA8IDApIHsNCisJCXBjaV9kaXNhYmxlX2RldmljZShw
ZGV2KTsNCisJCWdvdG8gb3V0Ow0KKwl9DQorDQogCXVuaXQgPSB2b3J0ZXhfY2FyZHNfZm91bmQ7
DQogDQogCWlmIChnbG9iYWxfdXNlX21taW8gPCAwICYmICh1bml0ID49IE1BWF9VTklUUyB8fCB1
c2VfbW1pb1t1bml0XSA8IDApKSB7DQpAQCAtMTAyNyw2ICsxMDMyLDcgQEAgc3RhdGljIGludCBf
X2RldmluaXQgdm9ydGV4X2luaXRfb25lKHN0cnVjdCBwY2lfZGV2ICpwZGV2LA0KIAlpZiAoIWlv
YWRkcikgLyogSWYgbWFwcGluZyBmYWlscywgZmFsbC1iYWNrIHRvIEJBUiAwLi4uICovDQogCQlp
b2FkZHIgPSBwY2lfaW9tYXAocGRldiwgMCwgMCk7DQogCWlmICghaW9hZGRyKSB7DQorCQlwY2lf
cmVsZWFzZV9yZWdpb25zKHBkZXYpOw0KIAkJcGNpX2Rpc2FibGVfZGV2aWNlKHBkZXYpOw0KIAkJ
cmMgPSAtRU5PTUVNOw0KIAkJZ290byBvdXQ7DQpAQCAtMTAzNiw2ICsxMDQyLDcgQEAgc3RhdGlj
IGludCBfX2RldmluaXQgdm9ydGV4X2luaXRfb25lKHN0cnVjdCBwY2lfZGV2ICpwZGV2LA0KIAkJ
CSAgIGVudC0+ZHJpdmVyX2RhdGEsIHVuaXQpOw0KIAlpZiAocmMgPCAwKSB7DQogCQlwY2lfaW91
bm1hcChwZGV2LCBpb2FkZHIpOw0KKwkJcGNpX3JlbGVhc2VfcmVnaW9ucyhwZGV2KTsNCiAJCXBj
aV9kaXNhYmxlX2RldmljZShwZGV2KTsNCiAJCWdvdG8gb3V0Ow0KIAl9DQpAQCAtMTE4MCwxMSAr
MTE4Nyw2IEBAIHN0YXRpYyBpbnQgX19kZXZpbml0IHZvcnRleF9wcm9iZTEoc3RydWN0IGRldmlj
ZSAqZ2VuZGV2LA0KIA0KIAkvKiBQQ0ktb25seSBzdGFydHVwIGxvZ2ljICovDQogCWlmIChwZGV2
KSB7DQotCQkvKiBFSVNBIHJlc291cmNlcyBhbHJlYWR5IG1hcmtlZCwgc28gb25seSBQQ0kgbmVl
ZHMgdG8gZG8gdGhpcyBoZXJlICovDQotCQkvKiBJZ25vcmUgcmV0dXJuIHZhbHVlLCBiZWNhdXNl
IENhcmRidXMgZHJpdmVycyBhbHJlYWR5IGFsbG9jYXRlIGZvciB1cyAqLw0KLQkJaWYgKHJlcXVl
c3RfcmVnaW9uKGRldi0+YmFzZV9hZGRyLCB2Y2ktPmlvX3NpemUsIHByaW50X25hbWUpICE9IE5V
TEwpDQotCQkJdnAtPm11c3RfZnJlZV9yZWdpb24gPSAxOw0KLQ0KIAkJLyogZW5hYmxlIGJ1cy1t
YXN0ZXJpbmcgaWYgbmVjZXNzYXJ5ICovDQogCQlpZiAodmNpLT5mbGFncyAmIFBDSV9VU0VTX01B
U1RFUikNCiAJCQlwY2lfc2V0X21hc3RlcihwZGV2KTsNCkBAIC0xMjIyLDcgKzEyMjQsNyBAQCBz
dGF0aWMgaW50IF9fZGV2aW5pdCB2b3J0ZXhfcHJvYmUxKHN0cnVjdCBkZXZpY2UgKmdlbmRldiwN
CiAJCQkJCSAgICZ2cC0+cnhfcmluZ19kbWEpOw0KIAlyZXR2YWwgPSAtRU5PTUVNOw0KIAlpZiAo
IXZwLT5yeF9yaW5nKQ0KLQkJZ290byBmcmVlX3JlZ2lvbjsNCisJCWdvdG8gZnJlZV9kZXZpY2U7
DQogDQogCXZwLT50eF9yaW5nID0gKHN0cnVjdCBib29tX3R4X2Rlc2MgKikodnAtPnJ4X3Jpbmcg
KyBSWF9SSU5HX1NJWkUpOw0KIAl2cC0+dHhfcmluZ19kbWEgPSB2cC0+cnhfcmluZ19kbWEgKyBz
aXplb2Yoc3RydWN0IGJvb21fcnhfZGVzYykgKiBSWF9SSU5HX1NJWkU7DQpAQCAtMTQ4Nyw5ICsx
NDg5LDcgQEAgZnJlZV9yaW5nOg0KIAkJCQkJCQkrIHNpemVvZihzdHJ1Y3QgYm9vbV90eF9kZXNj
KSAqIFRYX1JJTkdfU0laRSwNCiAJCQkJCQl2cC0+cnhfcmluZywNCiAJCQkJCQl2cC0+cnhfcmlu
Z19kbWEpOw0KLWZyZWVfcmVnaW9uOg0KLQlpZiAodnAtPm11c3RfZnJlZV9yZWdpb24pDQotCQly
ZWxlYXNlX3JlZ2lvbihkZXYtPmJhc2VfYWRkciwgdmNpLT5pb19zaXplKTsNCitmcmVlX2Rldmlj
ZToNCiAJZnJlZV9uZXRkZXYoZGV2KTsNCiAJcHJfZXJyKFBGWCAidm9ydGV4X3Byb2JlMSBmYWls
cy4gIFJldHVybnMgJWRcbiIsIHJldHZhbCk7DQogb3V0Og0KQEAgLTMyNTQsOCArMzI1NCw5IEBA
IHN0YXRpYyB2b2lkIF9fZGV2ZXhpdCB2b3J0ZXhfcmVtb3ZlX29uZShzdHJ1Y3QgcGNpX2RldiAq
cGRldikNCiAJCQkJCQkJKyBzaXplb2Yoc3RydWN0IGJvb21fdHhfZGVzYykgKiBUWF9SSU5HX1NJ
WkUsDQogCQkJCQkJdnAtPnJ4X3JpbmcsDQogCQkJCQkJdnAtPnJ4X3JpbmdfZG1hKTsNCi0JaWYg
KHZwLT5tdXN0X2ZyZWVfcmVnaW9uKQ0KLQkJcmVsZWFzZV9yZWdpb24oZGV2LT5iYXNlX2FkZHIs
IHZwLT5pb19zaXplKTsNCisNCisJcGNpX3JlbGVhc2VfcmVnaW9ucyhwZGV2KTsNCisNCiAJZnJl
ZV9uZXRkZXYoZGV2KTsNCiB9DQogDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQv
YnJvYWRjb20vdGczLmMgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9icm9hZGNvbS90ZzMuYw0KaW5k
ZXggYzZiOTkwMy4uZWMxM2E1OSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2Jy
b2FkY29tL3RnMy5jDQorKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9icm9hZGNvbS90ZzMuYw0K
QEAgLTI3NTIsNiArMjc1MiwzMSBAQCBzdGF0aWMgaW50IHRnM181NzAwX2xpbmtfcG9sYXJpdHko
c3RydWN0IHRnMyAqdHAsIHUzMiBzcGVlZCkNCiBzdGF0aWMgaW50IHRnM19zZXR1cF9waHkoc3Ry
dWN0IHRnMyAqLCBpbnQpOw0KIHN0YXRpYyBpbnQgdGczX2hhbHRfY3B1KHN0cnVjdCB0ZzMgKiwg
dTMyKTsNCiANCitzdGF0aWMgYm9vbCB0ZzNfcGh5X3Bvd2VyX2J1ZyhzdHJ1Y3QgdGczICp0cCkN
Cit7DQorCXN3aXRjaCAoR0VUX0FTSUNfUkVWKHRwLT5wY2lfY2hpcF9yZXZfaWQpKSB7DQorCWNh
c2UgQVNJQ19SRVZfNTcwMDoNCisJY2FzZSBBU0lDX1JFVl81NzA0Og0KKwkJcmV0dXJuIHRydWU7
DQorCWNhc2UgQVNJQ19SRVZfNTc4MDoNCisJCWlmICh0cC0+cGh5X2ZsYWdzICYgVEczX1BIWUZM
R19NSUlfU0VSREVTKQ0KKwkJCXJldHVybiB0cnVlOw0KKwkJcmV0dXJuIGZhbHNlOw0KKwljYXNl
IEFTSUNfUkVWXzU3MTc6DQorCQlpZiAoIXRwLT5wY2lfZm4pDQorCQkJcmV0dXJuIHRydWU7DQor
CQlyZXR1cm4gZmFsc2U7DQorCWNhc2UgQVNJQ19SRVZfNTcxOToNCisJY2FzZSBBU0lDX1JFVl81
NzIwOg0KKwkJaWYgKCh0cC0+cGh5X2ZsYWdzICYgVEczX1BIWUZMR19QSFlfU0VSREVTKSAmJg0K
KwkJICAgICF0cC0+cGNpX2ZuKQ0KKwkJCXJldHVybiB0cnVlOw0KKwkJcmV0dXJuIGZhbHNlOw0K
Kwl9DQorDQorCXJldHVybiBmYWxzZTsNCit9DQorDQogc3RhdGljIHZvaWQgdGczX3Bvd2VyX2Rv
d25fcGh5KHN0cnVjdCB0ZzMgKnRwLCBib29sIGRvX2xvd19wb3dlcikNCiB7DQogCXUzMiB2YWw7
DQpAQCAtMjgwOCwxMiArMjgzMyw3IEBAIHN0YXRpYyB2b2lkIHRnM19wb3dlcl9kb3duX3BoeShz
dHJ1Y3QgdGczICp0cCwgYm9vbCBkb19sb3dfcG93ZXIpDQogCS8qIFRoZSBQSFkgc2hvdWxkIG5v
dCBiZSBwb3dlcmVkIGRvd24gb24gc29tZSBjaGlwcyBiZWNhdXNlDQogCSAqIG9mIGJ1Z3MuDQog
CSAqLw0KLQlpZiAoR0VUX0FTSUNfUkVWKHRwLT5wY2lfY2hpcF9yZXZfaWQpID09IEFTSUNfUkVW
XzU3MDAgfHwNCi0JICAgIEdFVF9BU0lDX1JFVih0cC0+cGNpX2NoaXBfcmV2X2lkKSA9PSBBU0lD
X1JFVl81NzA0IHx8DQotCSAgICAoR0VUX0FTSUNfUkVWKHRwLT5wY2lfY2hpcF9yZXZfaWQpID09
IEFTSUNfUkVWXzU3ODAgJiYNCi0JICAgICAodHAtPnBoeV9mbGFncyAmIFRHM19QSFlGTEdfTUlJ
X1NFUkRFUykpIHx8DQotCSAgICAoR0VUX0FTSUNfUkVWKHRwLT5wY2lfY2hpcF9yZXZfaWQpID09
IEFTSUNfUkVWXzU3MTcgJiYNCi0JICAgICAhdHAtPnBjaV9mbikpDQorCWlmICh0ZzNfcGh5X3Bv
d2VyX2J1Zyh0cCkpDQogCQlyZXR1cm47DQogDQogCWlmIChHRVRfQ0hJUF9SRVYodHAtPnBjaV9j
aGlwX3Jldl9pZCkgPT0gQ0hJUFJFVl81Nzg0X0FYIHx8DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9u
ZXQvZXRoZXJuZXQvaWJtL2libXZldGguYyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2libS9pYm12
ZXRoLmMNCmluZGV4IDAyMTQ2M2IuLjU3ZTJkYTAgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL25ldC9l
dGhlcm5ldC9pYm0vaWJtdmV0aC5jDQorKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9pYm0vaWJt
dmV0aC5jDQpAQCAtMTMyNSw3ICsxMzI1LDcgQEAgc3RhdGljIGNvbnN0IHN0cnVjdCBuZXRfZGV2
aWNlX29wcyBpYm12ZXRoX25ldGRldl9vcHMgPSB7DQogc3RhdGljIGludCBfX2RldmluaXQgaWJt
dmV0aF9wcm9iZShzdHJ1Y3QgdmlvX2RldiAqZGV2LA0KIAkJCQkgICBjb25zdCBzdHJ1Y3Qgdmlv
X2RldmljZV9pZCAqaWQpDQogew0KLQlpbnQgcmMsIGk7DQorCWludCByYywgaSwgbWFjX2xlbjsN
CiAJc3RydWN0IG5ldF9kZXZpY2UgKm5ldGRldjsNCiAJc3RydWN0IGlibXZldGhfYWRhcHRlciAq
YWRhcHRlcjsNCiAJdW5zaWduZWQgY2hhciAqbWFjX2FkZHJfcDsNCkBAIC0xMzM1LDExICsxMzM1
LDE5IEBAIHN0YXRpYyBpbnQgX19kZXZpbml0IGlibXZldGhfcHJvYmUoc3RydWN0IHZpb19kZXYg
KmRldiwNCiAJCWRldi0+dW5pdF9hZGRyZXNzKTsNCiANCiAJbWFjX2FkZHJfcCA9ICh1bnNpZ25l
ZCBjaGFyICopdmlvX2dldF9hdHRyaWJ1dGUoZGV2LCBWRVRIX01BQ19BRERSLA0KLQkJCQkJCQlO
VUxMKTsNCisJCQkJCQkJJm1hY19sZW4pOw0KIAlpZiAoIW1hY19hZGRyX3ApIHsNCiAJCWRldl9l
cnIoJmRldi0+ZGV2LCAiQ2FuJ3QgZmluZCBWRVRIX01BQ19BRERSIGF0dHJpYnV0ZVxuIik7DQog
CQlyZXR1cm4gLUVJTlZBTDsNCiAJfQ0KKwkvKiBXb3JrYXJvdW5kIGZvciBvbGQvYnJva2VuIHBI
eXAgKi8NCisJaWYgKG1hY19sZW4gPT0gOCkNCisJCW1hY19hZGRyX3AgKz0gMjsNCisJZWxzZSBp
ZiAobWFjX2xlbiAhPSA2KSB7DQorCQlkZXZfZXJyKCZkZXYtPmRldiwgIlZFVEhfTUFDX0FERFIg
YXR0cmlidXRlIHdyb25nIGxlbiAlZFxuIiwNCisJCQltYWNfbGVuKTsNCisJCXJldHVybiAtRUlO
VkFMOw0KKwl9DQogDQogCW1jYXN0RmlsdGVyU2l6ZV9wID0gKHVuc2lnbmVkIGludCAqKXZpb19n
ZXRfYXR0cmlidXRlKGRldiwNCiAJCQkJCQlWRVRIX01DQVNUX0ZJTFRFUl9TSVpFLCBOVUxMKTsN
CkBAIC0xMzY0LDE3ICsxMzcyLDYgQEAgc3RhdGljIGludCBfX2RldmluaXQgaWJtdmV0aF9wcm9i
ZShzdHJ1Y3QgdmlvX2RldiAqZGV2LA0KIA0KIAluZXRpZl9uYXBpX2FkZChuZXRkZXYsICZhZGFw
dGVyLT5uYXBpLCBpYm12ZXRoX3BvbGwsIDE2KTsNCiANCi0JLyoNCi0JICogU29tZSBvbGRlciBi
b3hlcyBydW5uaW5nIFBIWVAgbm9uLW5hdGl2ZWx5IGhhdmUgYW4gT0YgdGhhdCByZXR1cm5zDQot
CSAqIGEgOC1ieXRlIGxvY2FsLW1hYy1hZGRyZXNzIGZpZWxkIChhbmQgdGhlIGZpcnN0IDIgYnl0
ZXMgaGF2ZSB0byBiZQ0KLQkgKiBpZ25vcmVkKSB3aGlsZSBuZXdlciBib3hlcycgT0YgcmV0dXJu
IGEgNi1ieXRlIGZpZWxkLiBOb3RlIHRoYXQNCi0JICogSUVFRSAxMjc1IHNwZWNpZmllcyB0aGF0
IGxvY2FsLW1hYy1hZGRyZXNzIG11c3QgYmUgYSA2LWJ5dGUgZmllbGQuDQotCSAqIFRoZSBSUEEg
ZG9jIHNwZWNpZmllcyB0aGF0IHRoZSBmaXJzdCBieXRlIG11c3QgYmUgMTBiLCBzbyB3ZSdsbA0K
LQkgKiBqdXN0IGxvb2sgZm9yIGl0IHRvIHNvbHZlIHRoaXMgOCB2cy4gNiBieXRlIGZpZWxkIGlz
c3VlDQotCSAqLw0KLQlpZiAoKCptYWNfYWRkcl9wICYgMHgzKSAhPSAweDAyKQ0KLQkJbWFjX2Fk
ZHJfcCArPSAyOw0KLQ0KIAlhZGFwdGVyLT5tYWNfYWRkciA9IDA7DQogCW1lbWNweSgmYWRhcHRl
ci0+bWFjX2FkZHIsIG1hY19hZGRyX3AsIDYpOw0KIA0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0
L21hY3ZsYW4uYyBiL2RyaXZlcnMvbmV0L21hY3ZsYW4uYw0KaW5kZXggNTQ0YWMwNi4uMzAxYjM5
ZSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0L21hY3ZsYW4uYw0KKysrIGIvZHJpdmVycy9uZXQv
bWFjdmxhbi5jDQpAQCAtMjA0LDcgKzIwNCw4IEBAIHN0YXRpYyByeF9oYW5kbGVyX3Jlc3VsdF90
IG1hY3ZsYW5faGFuZGxlX2ZyYW1lKHN0cnVjdCBza19idWZmICoqcHNrYikNCiAJfQ0KIA0KIAlp
ZiAocG9ydC0+cGFzc3RocnUpDQotCQl2bGFuID0gbGlzdF9maXJzdF9lbnRyeSgmcG9ydC0+dmxh
bnMsIHN0cnVjdCBtYWN2bGFuX2RldiwgbGlzdCk7DQorCQl2bGFuID0gbGlzdF9maXJzdF9vcl9u
dWxsX3JjdSgmcG9ydC0+dmxhbnMsDQorCQkJCQkgICAgICBzdHJ1Y3QgbWFjdmxhbl9kZXYsIGxp
c3QpOw0KIAllbHNlDQogCQl2bGFuID0gbWFjdmxhbl9oYXNoX2xvb2t1cChwb3J0LCBldGgtPmhf
ZGVzdCk7DQogCWlmICh2bGFuID09IE5VTEwpDQpAQCAtNzI1LDcgKzcyNiw3IEBAIGludCBtYWN2
bGFuX2NvbW1vbl9uZXdsaW5rKHN0cnVjdCBuZXQgKnNyY19uZXQsIHN0cnVjdCBuZXRfZGV2aWNl
ICpkZXYsDQogCWlmIChlcnIgPCAwKQ0KIAkJZ290byBkZXN0cm95X3BvcnQ7DQogDQotCWxpc3Rf
YWRkX3RhaWwoJnZsYW4tPmxpc3QsICZwb3J0LT52bGFucyk7DQorCWxpc3RfYWRkX3RhaWxfcmN1
KCZ2bGFuLT5saXN0LCAmcG9ydC0+dmxhbnMpOw0KIAluZXRpZl9zdGFja2VkX3RyYW5zZmVyX29w
ZXJzdGF0ZShsb3dlcmRldiwgZGV2KTsNCiANCiAJcmV0dXJuIDA7DQpAQCAtNzUxLDcgKzc1Miw3
IEBAIHZvaWQgbWFjdmxhbl9kZWxsaW5rKHN0cnVjdCBuZXRfZGV2aWNlICpkZXYsIHN0cnVjdCBs
aXN0X2hlYWQgKmhlYWQpDQogew0KIAlzdHJ1Y3QgbWFjdmxhbl9kZXYgKnZsYW4gPSBuZXRkZXZf
cHJpdihkZXYpOw0KIA0KLQlsaXN0X2RlbCgmdmxhbi0+bGlzdCk7DQorCWxpc3RfZGVsX3JjdSgm
dmxhbi0+bGlzdCk7DQogCXVucmVnaXN0ZXJfbmV0ZGV2aWNlX3F1ZXVlKGRldiwgaGVhZCk7DQog
fQ0KIEVYUE9SVF9TWU1CT0xfR1BMKG1hY3ZsYW5fZGVsbGluayk7DQpkaWZmIC0tZ2l0IGEvZHJp
dmVycy9uZXQvd2lyZWxlc3MvYXRoL2F0aDlrL21haW4uYyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNz
L2F0aC9hdGg5ay9tYWluLmMNCmluZGV4IDk1NDM3ZmMuLmRmM2UyN2MgMTAwNjQ0DQotLS0gYS9k
cml2ZXJzL25ldC93aXJlbGVzcy9hdGgvYXRoOWsvbWFpbi5jDQorKysgYi9kcml2ZXJzL25ldC93
aXJlbGVzcy9hdGgvYXRoOWsvbWFpbi5jDQpAQCAtMTc5Myw2ICsxNzkzLDcgQEAgc3RhdGljIGlu
dCBhdGg5a19zdGFfYWRkKHN0cnVjdCBpZWVlODAyMTFfaHcgKmh3LA0KIAlzdHJ1Y3QgYXRoX2Nv
bW1vbiAqY29tbW9uID0gYXRoOWtfaHdfY29tbW9uKHNjLT5zY19haCk7DQogCXN0cnVjdCBhdGhf
bm9kZSAqYW4gPSAoc3RydWN0IGF0aF9ub2RlICopIHN0YS0+ZHJ2X3ByaXY7DQogCXN0cnVjdCBp
ZWVlODAyMTFfa2V5X2NvbmYgcHNfa2V5ID0geyB9Ow0KKwlpbnQga2V5Ow0KIA0KIAlhdGhfbm9k
ZV9hdHRhY2goc2MsIHN0YSk7DQogDQpAQCAtMTgwMCw3ICsxODAxLDkgQEAgc3RhdGljIGludCBh
dGg5a19zdGFfYWRkKHN0cnVjdCBpZWVlODAyMTFfaHcgKmh3LA0KIAkgICAgdmlmLT50eXBlICE9
IE5MODAyMTFfSUZUWVBFX0FQX1ZMQU4pDQogCQlyZXR1cm4gMDsNCiANCi0JYW4tPnBzX2tleSA9
IGF0aF9rZXlfY29uZmlnKGNvbW1vbiwgdmlmLCBzdGEsICZwc19rZXkpOw0KKwlrZXkgPSBhdGhf
a2V5X2NvbmZpZyhjb21tb24sIHZpZiwgc3RhLCAmcHNfa2V5KTsNCisJaWYgKGtleSA+IDApDQor
CQlhbi0+cHNfa2V5ID0ga2V5Ow0KIA0KIAlyZXR1cm4gMDsNCiB9DQpAQCAtMTgxNyw2ICsxODIw
LDcgQEAgc3RhdGljIHZvaWQgYXRoOWtfZGVsX3BzX2tleShzdHJ1Y3QgYXRoX3NvZnRjICpzYywN
CiAJICAgIHJldHVybjsNCiANCiAJYXRoX2tleV9kZWxldGUoY29tbW9uLCAmcHNfa2V5KTsNCisJ
YW4tPnBzX2tleSA9IDA7DQogfQ0KIA0KIHN0YXRpYyBpbnQgYXRoOWtfc3RhX3JlbW92ZShzdHJ1
Y3QgaWVlZTgwMjExX2h3ICpodywNCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC93aXJlbGVzcy9i
NDMvZG1hLmMgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9iNDMvZG1hLmMNCmluZGV4IDEyOTc1YWQu
LmNhNzAyNjcgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9iNDMvZG1hLmMNCisr
KyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2I0My9kbWEuYw0KQEAgLTE3MTksNiArMTcxOSwyNSBA
QCBkcm9wX3JlY3ljbGVfYnVmZmVyOg0KIAlzeW5jX2Rlc2NidWZmZXJfZm9yX2RldmljZShyaW5n
LCBkbWFhZGRyLCByaW5nLT5yeF9idWZmZXJzaXplKTsNCiB9DQogDQordm9pZCBiNDNfZG1hX2hh
bmRsZV9yeF9vdmVyZmxvdyhzdHJ1Y3QgYjQzX2RtYXJpbmcgKnJpbmcpDQorew0KKwlpbnQgY3Vy
cmVudF9zbG90LCBwcmV2aW91c19zbG90Ow0KKw0KKwlCNDNfV0FSTl9PTihyaW5nLT50eCk7DQor
DQorCS8qIERldmljZSBoYXMgZmlsbGVkIGFsbCBidWZmZXJzLCBkcm9wIGFsbCBwYWNrZXRzIGFu
ZCBsZXQgVENQDQorCSAqIGRlY3JlYXNlIHNwZWVkLg0KKwkgKiBEZWNyZW1lbnQgUlggaW5kZXgg
Ynkgb25lIHdpbGwgbGV0IHRoZSBkZXZpY2UgdG8gc2VlIGFsbCBzbG90cw0KKwkgKiBhcyBmcmVl
IGFnYWluDQorCSAqLw0KKwkvKg0KKwkqVE9ETzogSG93IHRvIGluY3JlYXNlIHJ4X2Ryb3AgaW4g
bWFjODAyMTE/DQorCSovDQorCWN1cnJlbnRfc2xvdCA9IHJpbmctPm9wcy0+Z2V0X2N1cnJlbnRf
cnhzbG90KHJpbmcpOw0KKwlwcmV2aW91c19zbG90ID0gcHJldl9zbG90KHJpbmcsIGN1cnJlbnRf
c2xvdCk7DQorCXJpbmctPm9wcy0+c2V0X2N1cnJlbnRfcnhzbG90KHJpbmcsIHByZXZpb3VzX3Ns
b3QpOw0KK30NCisNCiB2b2lkIGI0M19kbWFfcngoc3RydWN0IGI0M19kbWFyaW5nICpyaW5nKQ0K
IHsNCiAJY29uc3Qgc3RydWN0IGI0M19kbWFfb3BzICpvcHMgPSByaW5nLT5vcHM7DQpkaWZmIC0t
Z2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvYjQzL2RtYS5oIGIvZHJpdmVycy9uZXQvd2lyZWxl
c3MvYjQzL2RtYS5oDQppbmRleCA5ZmRkMTk4Li5kZjhjOGNkIDEwMDY0NA0KLS0tIGEvZHJpdmVy
cy9uZXQvd2lyZWxlc3MvYjQzL2RtYS5oDQorKysgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9iNDMv
ZG1hLmgNCkBAIC05LDcgKzksNyBAQA0KIC8qIERNQS1JbnRlcnJ1cHQgcmVhc29ucy4gKi8NCiAj
ZGVmaW5lIEI0M19ETUFJUlFfRkFUQUxNQVNLCSgoMSA8PCAxMCkgfCAoMSA8PCAxMSkgfCAoMSA8
PCAxMikgXA0KIAkJCQkJIHwgKDEgPDwgMTQpIHwgKDEgPDwgMTUpKQ0KLSNkZWZpbmUgQjQzX0RN
QUlSUV9OT05GQVRBTE1BU0sJKDEgPDwgMTMpDQorI2RlZmluZSBCNDNfRE1BSVJRX1JERVNDX1VG
TE9XCQkoMSA8PCAxMykNCiAjZGVmaW5lIEI0M19ETUFJUlFfUlhfRE9ORQkJKDEgPDwgMTYpDQog
DQogLyoqKiAzMi1iaXQgRE1BIEVuZ2luZS4gKioqLw0KQEAgLTI5NSw2ICsyOTUsOCBAQCBpbnQg
YjQzX2RtYV90eChzdHJ1Y3QgYjQzX3dsZGV2ICpkZXYsDQogdm9pZCBiNDNfZG1hX2hhbmRsZV90
eHN0YXR1cyhzdHJ1Y3QgYjQzX3dsZGV2ICpkZXYsDQogCQkJICAgICBjb25zdCBzdHJ1Y3QgYjQz
X3R4c3RhdHVzICpzdGF0dXMpOw0KIA0KK3ZvaWQgYjQzX2RtYV9oYW5kbGVfcnhfb3ZlcmZsb3co
c3RydWN0IGI0M19kbWFyaW5nICpyaW5nKTsNCisNCiB2b2lkIGI0M19kbWFfcngoc3RydWN0IGI0
M19kbWFyaW5nICpyaW5nKTsNCiANCiB2b2lkIGI0M19kbWFfZGlyZWN0X2ZpZm9fcngoc3RydWN0
IGI0M193bGRldiAqZGV2LA0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2I0My9t
YWluLmMgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9iNDMvbWFpbi5jDQppbmRleCA2ODA3MDljLi5j
MGYyMDQxIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvYjQzL21haW4uYw0KKysr
IGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvYjQzL21haW4uYw0KQEAgLTE5MDEsMzAgKzE5MDEsMTgg
QEAgc3RhdGljIHZvaWQgYjQzX2RvX2ludGVycnVwdF90aHJlYWQoc3RydWN0IGI0M193bGRldiAq
ZGV2KQ0KIAkJfQ0KIAl9DQogDQotCWlmICh1bmxpa2VseShtZXJnZWRfZG1hX3JlYXNvbiAmIChC
NDNfRE1BSVJRX0ZBVEFMTUFTSyB8DQotCQkJCQkgIEI0M19ETUFJUlFfTk9ORkFUQUxNQVNLKSkp
IHsNCi0JCWlmIChtZXJnZWRfZG1hX3JlYXNvbiAmIEI0M19ETUFJUlFfRkFUQUxNQVNLKSB7DQot
CQkJYjQzZXJyKGRldi0+d2wsICJGYXRhbCBETUEgZXJyb3I6ICINCi0JCQkgICAgICAgIjB4JTA4
WCwgMHglMDhYLCAweCUwOFgsICINCi0JCQkgICAgICAgIjB4JTA4WCwgMHglMDhYLCAweCUwOFhc
biIsDQotCQkJICAgICAgIGRtYV9yZWFzb25bMF0sIGRtYV9yZWFzb25bMV0sDQotCQkJICAgICAg
IGRtYV9yZWFzb25bMl0sIGRtYV9yZWFzb25bM10sDQotCQkJICAgICAgIGRtYV9yZWFzb25bNF0s
IGRtYV9yZWFzb25bNV0pOw0KLQkJCWI0M2VycihkZXYtPndsLCAiVGhpcyBkZXZpY2UgZG9lcyBu
b3Qgc3VwcG9ydCBETUEgIg0KKwlpZiAodW5saWtlbHkobWVyZ2VkX2RtYV9yZWFzb24gJiAoQjQz
X0RNQUlSUV9GQVRBTE1BU0spKSkgew0KKwkJYjQzZXJyKGRldi0+d2wsDQorCQkJIkZhdGFsIERN
QSBlcnJvcjogMHglMDhYLCAweCUwOFgsIDB4JTA4WCwgMHglMDhYLCAweCUwOFgsIDB4JTA4WFxu
IiwNCisJCQlkbWFfcmVhc29uWzBdLCBkbWFfcmVhc29uWzFdLA0KKwkJCWRtYV9yZWFzb25bMl0s
IGRtYV9yZWFzb25bM10sDQorCQkJZG1hX3JlYXNvbls0XSwgZG1hX3JlYXNvbls1XSk7DQorCQli
NDNlcnIoZGV2LT53bCwgIlRoaXMgZGV2aWNlIGRvZXMgbm90IHN1cHBvcnQgRE1BICINCiAJCQkg
ICAgICAgIm9uIHlvdXIgc3lzdGVtLiBJdCB3aWxsIG5vdyBiZSBzd2l0Y2hlZCB0byBQSU8uXG4i
KTsNCi0JCQkvKiBGYWxsIGJhY2sgdG8gUElPIHRyYW5zZmVycyBpZiB3ZSBnZXQgZmF0YWwgRE1B
IGVycm9ycyEgKi8NCi0JCQlkZXYtPnVzZV9waW8gPSAxOw0KLQkJCWI0M19jb250cm9sbGVyX3Jl
c3RhcnQoZGV2LCAiRE1BIGVycm9yIik7DQotCQkJcmV0dXJuOw0KLQkJfQ0KLQkJaWYgKG1lcmdl
ZF9kbWFfcmVhc29uICYgQjQzX0RNQUlSUV9OT05GQVRBTE1BU0spIHsNCi0JCQliNDNlcnIoZGV2
LT53bCwgIkRNQSBlcnJvcjogIg0KLQkJCSAgICAgICAiMHglMDhYLCAweCUwOFgsIDB4JTA4WCwg
Ig0KLQkJCSAgICAgICAiMHglMDhYLCAweCUwOFgsIDB4JTA4WFxuIiwNCi0JCQkgICAgICAgZG1h
X3JlYXNvblswXSwgZG1hX3JlYXNvblsxXSwNCi0JCQkgICAgICAgZG1hX3JlYXNvblsyXSwgZG1h
X3JlYXNvblszXSwNCi0JCQkgICAgICAgZG1hX3JlYXNvbls0XSwgZG1hX3JlYXNvbls1XSk7DQot
CQl9DQorCQkvKiBGYWxsIGJhY2sgdG8gUElPIHRyYW5zZmVycyBpZiB3ZSBnZXQgZmF0YWwgRE1B
IGVycm9ycyEgKi8NCisJCWRldi0+dXNlX3BpbyA9IHRydWU7DQorCQliNDNfY29udHJvbGxlcl9y
ZXN0YXJ0KGRldiwgIkRNQSBlcnJvciIpOw0KKwkJcmV0dXJuOw0KIAl9DQogDQogCWlmICh1bmxp
a2VseShyZWFzb24gJiBCNDNfSVJRX1VDT0RFX0RFQlVHKSkNCkBAIC0xOTQzLDYgKzE5MzEsMTEg
QEAgc3RhdGljIHZvaWQgYjQzX2RvX2ludGVycnVwdF90aHJlYWQoc3RydWN0IGI0M193bGRldiAq
ZGV2KQ0KIAkJaGFuZGxlX2lycV9ub2lzZShkZXYpOw0KIA0KIAkvKiBDaGVjayB0aGUgRE1BIHJl
YXNvbiByZWdpc3RlcnMgZm9yIHJlY2VpdmVkIGRhdGEuICovDQorCWlmIChkbWFfcmVhc29uWzBd
ICYgQjQzX0RNQUlSUV9SREVTQ19VRkxPVykgew0KKwkJaWYgKEI0M19ERUJVRykNCisJCQliNDN3
YXJuKGRldi0+d2wsICJSWCBkZXNjcmlwdG9yIHVuZGVycnVuXG4iKTsNCisJCWI0M19kbWFfaGFu
ZGxlX3J4X292ZXJmbG93KGRldi0+ZG1hLnJ4X3JpbmcpOw0KKwl9DQogCWlmIChkbWFfcmVhc29u
WzBdICYgQjQzX0RNQUlSUV9SWF9ET05FKSB7DQogCQlpZiAoYjQzX3VzaW5nX3Bpb190cmFuc2Zl
cnMoZGV2KSkNCiAJCQliNDNfcGlvX3J4KGRldi0+cGlvLnJ4X3F1ZXVlKTsNCkBAIC0yMDAwLDcg
KzE5OTMsNyBAQCBzdGF0aWMgaXJxcmV0dXJuX3QgYjQzX2RvX2ludGVycnVwdChzdHJ1Y3QgYjQz
X3dsZGV2ICpkZXYpDQogCQlyZXR1cm4gSVJRX05PTkU7DQogDQogCWRldi0+ZG1hX3JlYXNvblsw
XSA9IGI0M19yZWFkMzIoZGV2LCBCNDNfTU1JT19ETUEwX1JFQVNPTikNCi0JICAgICYgMHgwMDAx
REMwMDsNCisJICAgICYgMHgwMDAxRkMwMDsNCiAJZGV2LT5kbWFfcmVhc29uWzFdID0gYjQzX3Jl
YWQzMihkZXYsIEI0M19NTUlPX0RNQTFfUkVBU09OKQ0KIAkgICAgJiAweDAwMDBEQzAwOw0KIAlk
ZXYtPmRtYV9yZWFzb25bMl0gPSBiNDNfcmVhZDMyKGRldiwgQjQzX01NSU9fRE1BMl9SRUFTT04p
DQpAQCAtMzEwMyw3ICszMDk2LDcgQEAgc3RhdGljIGludCBiNDNfY2hpcF9pbml0KHN0cnVjdCBi
NDNfd2xkZXYgKmRldikNCiAJCWI0M193cml0ZTMyKGRldiwgMHgwMThDLCAweDAyMDAwMDAwKTsN
CiAJfQ0KIAliNDNfd3JpdGUzMihkZXYsIEI0M19NTUlPX0dFTl9JUlFfUkVBU09OLCAweDAwMDA0
MDAwKTsNCi0JYjQzX3dyaXRlMzIoZGV2LCBCNDNfTU1JT19ETUEwX0lSUV9NQVNLLCAweDAwMDFE
QzAwKTsNCisJYjQzX3dyaXRlMzIoZGV2LCBCNDNfTU1JT19ETUEwX0lSUV9NQVNLLCAweDAwMDFG
QzAwKTsNCiAJYjQzX3dyaXRlMzIoZGV2LCBCNDNfTU1JT19ETUExX0lSUV9NQVNLLCAweDAwMDBE
QzAwKTsNCiAJYjQzX3dyaXRlMzIoZGV2LCBCNDNfTU1JT19ETUEyX0lSUV9NQVNLLCAweDAwMDBE
QzAwKTsNCiAJYjQzX3dyaXRlMzIoZGV2LCBCNDNfTU1JT19ETUEzX0lSUV9NQVNLLCAweDAwMDFE
QzAwKTsNCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC93aXJlbGVzcy9td2lmaWV4L2NmZzgwMjEx
LmMgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9td2lmaWV4L2NmZzgwMjExLmMNCmluZGV4IDcyN2Mx
MjkuLjQ1YWM0MDcgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9td2lmaWV4L2Nm
ZzgwMjExLmMNCisrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL213aWZpZXgvY2ZnODAyMTEuYw0K
QEAgLTEyODEsOSArMTI4MSw2IEBAIGludCBtd2lmaWV4X2RlbF92aXJ0dWFsX2ludGYoc3RydWN0
IHdpcGh5ICp3aXBoeSwgc3RydWN0IG5ldF9kZXZpY2UgKmRldikNCiAJaWYgKGRldi0+cmVnX3N0
YXRlID09IE5FVFJFR19SRUdJU1RFUkVEKQ0KIAkJdW5yZWdpc3Rlcl9uZXRkZXZpY2UoZGV2KTsN
CiANCi0JaWYgKGRldi0+cmVnX3N0YXRlID09IE5FVFJFR19VTlJFR0lTVEVSRUQpDQotCQlmcmVl
X25ldGRldihkZXYpOw0KLQ0KIAkvKiBDbGVhciB0aGUgcHJpdiBpbiBhZGFwdGVyICovDQogCXBy
aXYtPm5ldGRldiA9IE5VTEw7DQogDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3Mv
bXdpZmlleC9jbWRldnQuYyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL213aWZpZXgvY21kZXZ0LmMN
CmluZGV4IDVhMjVkZDIuLjkwZmZjNzYgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL25ldC93aXJlbGVz
cy9td2lmaWV4L2NtZGV2dC5jDQorKysgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9td2lmaWV4L2Nt
ZGV2dC5jDQpAQCAtMTA4Myw2ICsxMDgzLDcgQEAgbXdpZmlleF9wcm9jZXNzX2hzX2NvbmZpZyhz
dHJ1Y3QgbXdpZmlleF9hZGFwdGVyICphZGFwdGVyKQ0KIAlhZGFwdGVyLT5pZl9vcHMud2FrZXVw
KGFkYXB0ZXIpOw0KIAlhZGFwdGVyLT5oc19hY3RpdmF0ZWQgPSBmYWxzZTsNCiAJYWRhcHRlci0+
aXNfaHNfY29uZmlndXJlZCA9IGZhbHNlOw0KKwlhZGFwdGVyLT5pc19zdXNwZW5kZWQgPSBmYWxz
ZTsNCiAJbXdpZmlleF9oc19hY3RpdmF0ZWRfZXZlbnQobXdpZmlleF9nZXRfcHJpdihhZGFwdGVy
LA0KIAkJCQkgICBNV0lGSUVYX0JTU19ST0xFX0FOWSksIGZhbHNlKTsNCiB9DQpkaWZmIC0tZ2l0
IGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvbXdpZmlleC9tYWluLmMgYi9kcml2ZXJzL25ldC93aXJl
bGVzcy9td2lmaWV4L21haW4uYw0KaW5kZXggNjdlNmRiNy4uNWJhYTEyYSAxMDA2NDQNCi0tLSBh
L2RyaXZlcnMvbmV0L3dpcmVsZXNzL213aWZpZXgvbWFpbi5jDQorKysgYi9kcml2ZXJzL25ldC93
aXJlbGVzcy9td2lmaWV4L21haW4uYw0KQEAgLTU4MSw2ICs1ODEsNyBAQCB2b2lkIG13aWZpZXhf
aW5pdF9wcml2X3BhcmFtcyhzdHJ1Y3QgbXdpZmlleF9wcml2YXRlICpwcml2LA0KIAkJCQkJCXN0
cnVjdCBuZXRfZGV2aWNlICpkZXYpDQogew0KIAlkZXYtPm5ldGRldl9vcHMgPSAmbXdpZmlleF9u
ZXRkZXZfb3BzOw0KKwlkZXYtPmRlc3RydWN0b3IgPSBmcmVlX25ldGRldjsNCiAJLyogSW5pdGlh
bGl6ZSBwcml2YXRlIHN0cnVjdHVyZSAqLw0KIAlwcml2LT5jdXJyZW50X2tleV9pbmRleCA9IDA7
DQogCXByaXYtPm1lZGlhX2Nvbm5lY3RlZCA9IGZhbHNlOw0KZGlmZiAtLWdpdCBhL2RyaXZlcnMv
bmV0L3dpcmVsZXNzL213aWZpZXgvc3RhX2lvY3RsLmMgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9t
d2lmaWV4L3N0YV9pb2N0bC5jDQppbmRleCA1NmUxYzRhLi41YzNjNjJkIDEwMDY0NA0KLS0tIGEv
ZHJpdmVycy9uZXQvd2lyZWxlc3MvbXdpZmlleC9zdGFfaW9jdGwuYw0KKysrIGIvZHJpdmVycy9u
ZXQvd2lyZWxlc3MvbXdpZmlleC9zdGFfaW9jdGwuYw0KQEAgLTEwNSw3ICsxMDUsNyBAQCBpbnQg
bXdpZmlleF9yZXF1ZXN0X3NldF9tdWx0aWNhc3RfbGlzdChzdHJ1Y3QgbXdpZmlleF9wcml2YXRl
ICpwcml2LA0KIAl9IGVsc2Ugew0KIAkJLyogTXVsdGljYXN0ICovDQogCQlwcml2LT5jdXJyX3Br
dF9maWx0ZXIgJj0gfkhvc3RDbWRfQUNUX01BQ19QUk9NSVNDVU9VU19FTkFCTEU7DQotCQlpZiAo
bWNhc3RfbGlzdC0+bW9kZSA9PSBNV0lGSUVYX01VTFRJQ0FTVF9NT0RFKSB7DQorCQlpZiAobWNh
c3RfbGlzdC0+bW9kZSA9PSBNV0lGSUVYX0FMTF9NVUxUSV9NT0RFKSB7DQogCQkJZGV2X2RiZyhw
cml2LT5hZGFwdGVyLT5kZXYsDQogCQkJCSJpbmZvOiBFbmFibGluZyBBbGwgTXVsdGljYXN0IVxu
Iik7DQogCQkJcHJpdi0+Y3Vycl9wa3RfZmlsdGVyIHw9DQpAQCAtMTE3LDIwICsxMTcsMTEgQEAg
aW50IG13aWZpZXhfcmVxdWVzdF9zZXRfbXVsdGljYXN0X2xpc3Qoc3RydWN0IG13aWZpZXhfcHJp
dmF0ZSAqcHJpdiwNCiAJCQkJZGV2X2RiZyhwcml2LT5hZGFwdGVyLT5kZXYsDQogCQkJCQkiaW5m
bzogU2V0IG11bHRpY2FzdCBsaXN0PSVkXG4iLA0KIAkJCQkgICAgICAgbWNhc3RfbGlzdC0+bnVt
X211bHRpY2FzdF9hZGRyKTsNCi0JCQkJLyogU2V0IG11bHRpY2FzdCBhZGRyZXNzZXMgdG8gZmly
bXdhcmUgKi8NCi0JCQkJaWYgKG9sZF9wa3RfZmlsdGVyID09IHByaXYtPmN1cnJfcGt0X2ZpbHRl
cikgew0KLQkJCQkJLyogU2VuZCByZXF1ZXN0IHRvIGZpcm13YXJlICovDQotCQkJCQlyZXQgPSBt
d2lmaWV4X3NlbmRfY21kX2FzeW5jKHByaXYsDQotCQkJCQkJSG9zdENtZF9DTURfTUFDX01VTFRJ
Q0FTVF9BRFIsDQotCQkJCQkJSG9zdENtZF9BQ1RfR0VOX1NFVCwgMCwNCi0JCQkJCQltY2FzdF9s
aXN0KTsNCi0JCQkJfSBlbHNlIHsNCi0JCQkJCS8qIFNlbmQgcmVxdWVzdCB0byBmaXJtd2FyZSAq
Lw0KLQkJCQkJcmV0ID0gbXdpZmlleF9zZW5kX2NtZF9hc3luYyhwcml2LA0KLQkJCQkJCUhvc3RD
bWRfQ01EX01BQ19NVUxUSUNBU1RfQURSLA0KLQkJCQkJCUhvc3RDbWRfQUNUX0dFTl9TRVQsIDAs
DQotCQkJCQkJbWNhc3RfbGlzdCk7DQotCQkJCX0NCisJCQkJLyogU2VuZCBtdWx0aWNhc3QgYWRk
cmVzc2VzIHRvIGZpcm13YXJlICovDQorCQkJCXJldCA9IG13aWZpZXhfc2VuZF9jbWRfYXN5bmMo
cHJpdiwNCisJCQkJCUhvc3RDbWRfQ01EX01BQ19NVUxUSUNBU1RfQURSLA0KKwkJCQkJSG9zdENt
ZF9BQ1RfR0VOX1NFVCwgMCwNCisJCQkJCW1jYXN0X2xpc3QpOw0KIAkJCX0NCiAJCX0NCiAJfQ0K
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvcGxhdGZvcm0veDg2L2hwX2FjY2VsLmMgYi9kcml2ZXJzL3Bs
YXRmb3JtL3g4Ni9ocF9hY2NlbC5jDQppbmRleCAyMmIyZGZhLi5mZGFjZmNlIDEwMDY0NA0KLS0t
IGEvZHJpdmVycy9wbGF0Zm9ybS94ODYvaHBfYWNjZWwuYw0KKysrIGIvZHJpdmVycy9wbGF0Zm9y
bS94ODYvaHBfYWNjZWwuYw0KQEAgLTM2Miw3ICszNjIsOCBAQCBzdGF0aWMgaW50IGxpczNsdjAy
ZF9zdXNwZW5kKHN0cnVjdCBhY3BpX2RldmljZSAqZGV2aWNlLCBwbV9tZXNzYWdlX3Qgc3RhdGUp
DQogDQogc3RhdGljIGludCBsaXMzbHYwMmRfcmVzdW1lKHN0cnVjdCBhY3BpX2RldmljZSAqZGV2
aWNlKQ0KIHsNCi0JcmV0dXJuIGxpczNsdjAyZF9wb3dlcm9uKCZsaXMzX2Rldik7DQorCWxpczNs
djAyZF9wb3dlcm9uKCZsaXMzX2Rldik7DQorCXJldHVybiAwOw0KIH0NCiAjZWxzZQ0KICNkZWZp
bmUgbGlzM2x2MDJkX3N1c3BlbmQgTlVMTA0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvcmFwaWRpby9k
ZXZpY2VzL3RzaTcyMS5jIGIvZHJpdmVycy9yYXBpZGlvL2RldmljZXMvdHNpNzIxLmMNCmluZGV4
IDMzNDcxZTEuLjIzZWYxNmMgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3JhcGlkaW8vZGV2aWNlcy90
c2k3MjEuYw0KKysrIGIvZHJpdmVycy9yYXBpZGlvL2RldmljZXMvdHNpNzIxLmMNCkBAIC00NzUs
NiArNDc1LDEwIEBAIHN0YXRpYyBpcnFyZXR1cm5fdCB0c2k3MjFfaXJxaGFuZGxlcihpbnQgaXJx
LCB2b2lkICpwdHIpDQogCXUzMiBpbnR2YWw7DQogCXUzMiBjaF9pbnRlOw0KIA0KKwkvKiBGb3Ig
TVNJIG1vZGUgZGlzYWJsZSBhbGwgZGV2aWNlLWxldmVsIGludGVycnVwdHMgKi8NCisJaWYgKHBy
aXYtPmZsYWdzICYgVFNJNzIxX1VTSU5HX01TSSkNCisJCWlvd3JpdGUzMigwLCBwcml2LT5yZWdz
ICsgVFNJNzIxX0RFVl9JTlRFKTsNCisNCiAJZGV2X2ludCA9IGlvcmVhZDMyKHByaXYtPnJlZ3Mg
KyBUU0k3MjFfREVWX0lOVCk7DQogCWlmICghZGV2X2ludCkNCiAJCXJldHVybiBJUlFfTk9ORTsN
CkBAIC01NDgsNiArNTUyLDEzIEBAIHN0YXRpYyBpcnFyZXR1cm5fdCB0c2k3MjFfaXJxaGFuZGxl
cihpbnQgaXJxLCB2b2lkICpwdHIpDQogCQkJdHNpNzIxX3B3X2hhbmRsZXIobXBvcnQpOw0KIAl9
DQogDQorCS8qIEZvciBNU0kgbW9kZSByZS1lbmFibGUgZGV2aWNlLWxldmVsIGludGVycnVwdHMg
Ki8NCisJaWYgKHByaXYtPmZsYWdzICYgVFNJNzIxX1VTSU5HX01TSSkgew0KKwkJZGV2X2ludCA9
IFRTSTcyMV9ERVZfSU5UX1NSMlBDX0NIIHwgVFNJNzIxX0RFVl9JTlRfU1JJTyB8DQorCQkJVFNJ
NzIxX0RFVl9JTlRfU01TR19DSCB8IFRTSTcyMV9ERVZfSU5UX0JETUFfQ0g7DQorCQlpb3dyaXRl
MzIoZGV2X2ludCwgcHJpdi0+cmVncyArIFRTSTcyMV9ERVZfSU5URSk7DQorCX0NCisNCiAJcmV0
dXJuIElSUV9IQU5ETEVEOw0KIH0NCiANCmRpZmYgLS1naXQgYS9kcml2ZXJzL3J0Yy9ydGMtcGNm
MjEyMy5jIGIvZHJpdmVycy9ydGMvcnRjLXBjZjIxMjMuYw0KaW5kZXggMmVlM2JiZi4uNjJlMWIy
YyAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvcnRjL3J0Yy1wY2YyMTIzLmMNCisrKyBiL2RyaXZlcnMv
cnRjL3J0Yy1wY2YyMTIzLmMNCkBAIC0yNjQsNiArMjY0LDcgQEAgc3RhdGljIGludCBfX2Rldmlu
aXQgcGNmMjEyM19wcm9iZShzdHJ1Y3Qgc3BpX2RldmljZSAqc3BpKQ0KIA0KIAlpZiAoIShyeGJ1
ZlswXSAmIDB4MjApKSB7DQogCQlkZXZfZXJyKCZzcGktPmRldiwgImNoaXAgbm90IGZvdW5kXG4i
KTsNCisJCXJldCA9IC1FTk9ERVY7DQogCQlnb3RvIGtmcmVlX2V4aXQ7DQogCX0NCiANCmRpZmYg
LS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvY29tZWRpL2NvbWVkaV9mb3BzLmMgYi9kcml2ZXJzL3N0
YWdpbmcvY29tZWRpL2NvbWVkaV9mb3BzLmMNCmluZGV4IGEwMjNmNTIuLmZlNGRiZjMgMTAwNjQ0
DQotLS0gYS9kcml2ZXJzL3N0YWdpbmcvY29tZWRpL2NvbWVkaV9mb3BzLmMNCisrKyBiL2RyaXZl
cnMvc3RhZ2luZy9jb21lZGkvY29tZWRpX2ZvcHMuYw0KQEAgLTE0Myw2ICsxNDMsOSBAQCBzdGF0
aWMgbG9uZyBjb21lZGlfdW5sb2NrZWRfaW9jdGwoc3RydWN0IGZpbGUgKmZpbGUsIHVuc2lnbmVk
IGludCBjbWQsDQogCQl9DQogCQlyYyA9IGRvX2RldmNvbmZpZ19pb2N0bChkZXYsDQogCQkJCQko
c3RydWN0IGNvbWVkaV9kZXZjb25maWcgX191c2VyICopYXJnKTsNCisJCWlmIChyYyA9PSAwKQ0K
KwkJCS8qIEV2YWRlIGNvbWVkaV9hdXRvX3VuY29uZmlnKCkuICovDQorCQkJZGV2X2ZpbGVfaW5m
by0+aGFyZHdhcmVfZGV2aWNlID0gTlVMTDsNCiAJCWdvdG8gZG9uZTsNCiAJfQ0KIA0KZGlmZiAt
LWdpdCBhL2RyaXZlcnMvc3RhZ2luZy92dDY2NTYvaG9zdGFwLmMgYi9kcml2ZXJzL3N0YWdpbmcv
dnQ2NjU2L2hvc3RhcC5jDQppbmRleCA1MWI1YWRmLi5kZjhlYTI1IDEwMDY0NA0KLS0tIGEvZHJp
dmVycy9zdGFnaW5nL3Z0NjY1Ni9ob3N0YXAuYw0KKysrIGIvZHJpdmVycy9zdGFnaW5nL3Z0NjY1
Ni9ob3N0YXAuYw0KQEAgLTE1Myw3ICsxNTMsNyBAQCBzdGF0aWMgaW50IGhvc3RhcF9kaXNhYmxl
X2hvc3RhcGQoUFNEZXZpY2UgcERldmljZSwgaW50IHJ0bmxfbG9ja2VkKQ0KICAgICAgICAgICAg
IERCR19QUlQoTVNHX0xFVkVMX0RFQlVHLCBLRVJOX0lORk8gIiVzOiBOZXRkZXZpY2UgJXMgdW5y
ZWdpc3RlcmVkXG4iLA0KIAkJICAgICAgIHBEZXZpY2UtPmRldi0+bmFtZSwgcERldmljZS0+YXBk
ZXYtPm5hbWUpOw0KIAl9DQotCWtmcmVlKHBEZXZpY2UtPmFwZGV2KTsNCisJZnJlZV9uZXRkZXYo
cERldmljZS0+YXBkZXYpOw0KIAlwRGV2aWNlLT5hcGRldiA9IE5VTEw7DQogICAgIHBEZXZpY2Ut
PmJFbmFibGU4MDIxeCA9IEZBTFNFOw0KICAgICBwRGV2aWNlLT5iRW5hYmxlSG9zdFdFUCA9IEZB
TFNFOw0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvdGFyZ2V0L2lzY3NpL2lzY3NpX3RhcmdldF9lcmwx
LmMgYi9kcml2ZXJzL3RhcmdldC9pc2NzaS9pc2NzaV90YXJnZXRfZXJsMS5jDQppbmRleCAxMDFi
MWJlLi5kODY3OTFlIDEwMDY0NA0KLS0tIGEvZHJpdmVycy90YXJnZXQvaXNjc2kvaXNjc2lfdGFy
Z2V0X2VybDEuYw0KKysrIGIvZHJpdmVycy90YXJnZXQvaXNjc2kvaXNjc2lfdGFyZ2V0X2VybDEu
Yw0KQEAgLTgyNCw3ICs4MjQsNyBAQCBzdGF0aWMgaW50IGlzY3NpdF9hdHRhY2hfb29vX2NtZHNu
KA0KIAkJLyoNCiAJCSAqIENtZFNOIGlzIGdyZWF0ZXIgdGhhbiB0aGUgdGFpbCBvZiB0aGUgbGlz
dC4NCiAJCSAqLw0KLQkJaWYgKG9vb190YWlsLT5jbWRzbiA8IG9vb19jbWRzbi0+Y21kc24pDQor
CQlpZiAoaXNjc2lfc25hX2x0KG9vb190YWlsLT5jbWRzbiwgb29vX2NtZHNuLT5jbWRzbikpDQog
CQkJbGlzdF9hZGRfdGFpbCgmb29vX2NtZHNuLT5vb29fbGlzdCwNCiAJCQkJCSZzZXNzLT5zZXNz
X29vb19jbWRzbl9saXN0KTsNCiAJCWVsc2Ugew0KQEAgLTgzNCwxMSArODM0LDEyIEBAIHN0YXRp
YyBpbnQgaXNjc2l0X2F0dGFjaF9vb29fY21kc24oDQogCQkJICovDQogCQkJbGlzdF9mb3JfZWFj
aF9lbnRyeShvb29fdG1wLCAmc2Vzcy0+c2Vzc19vb29fY21kc25fbGlzdCwNCiAJCQkJCQlvb29f
bGlzdCkgew0KLQkJCQlpZiAob29vX3RtcC0+Y21kc24gPCBvb29fY21kc24tPmNtZHNuKQ0KKwkJ
CQlpZiAoaXNjc2lfc25hX2x0KG9vb190bXAtPmNtZHNuLCBvb29fY21kc24tPmNtZHNuKSkNCiAJ
CQkJCWNvbnRpbnVlOw0KIA0KKwkJCQkvKiBJbnNlcnQgYmVmb3JlIHRoaXMgZW50cnkgKi8NCiAJ
CQkJbGlzdF9hZGQoJm9vb19jbWRzbi0+b29vX2xpc3QsDQotCQkJCQkmb29vX3RtcC0+b29vX2xp
c3QpOw0KKwkJCQkJb29vX3RtcC0+b29vX2xpc3QucHJldik7DQogCQkJCWJyZWFrOw0KIAkJCX0N
CiAJCX0NCmRpZmYgLS1naXQgYS9kcml2ZXJzL3R0eS9uX3R0eS5jIGIvZHJpdmVycy90dHkvbl90
dHkuYw0KaW5kZXggODQ4MWFhZS4uMGY4YTc4NSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvdHR5L25f
dHR5LmMNCisrKyBiL2RyaXZlcnMvdHR5L25fdHR5LmMNCkBAIC0xNTMwLDYgKzE1MzAsMTQgQEAg
c3RhdGljIHZvaWQgbl90dHlfc2V0X3Rlcm1pb3Moc3RydWN0IHR0eV9zdHJ1Y3QgKnR0eSwgc3Ry
dWN0IGt0ZXJtaW9zICpvbGQpDQogCQkJdHR5LT5yZWFsX3JhdyA9IDA7DQogCX0NCiAJbl90dHlf
c2V0X3Jvb20odHR5KTsNCisJLyoNCisJICogRml4IHR0eSBoYW5nIHdoZW4gSV9JWE9OKHR0eSkg
aXMgY2xlYXJlZCwgYnV0IHRoZSB0dHkNCisJICogYmVlbiBzdG9wcGVkIGJ5IFNUT1BfQ0hBUih0
dHkpIGJlZm9yZSBpdC4NCisJICovDQorCWlmICghSV9JWE9OKHR0eSkgJiYgb2xkICYmIChvbGQt
PmNfaWZsYWcgJiBJWE9OKSAmJiAhdHR5LT5mbG93X3N0b3BwZWQpIHsNCisJCXN0YXJ0X3R0eSh0
dHkpOw0KKwl9DQorDQogCS8qIFRoZSB0ZXJtaW9zIGNoYW5nZSBtYWtlIHRoZSB0dHkgcmVhZHkg
Zm9yIEkvTyAqLw0KIAl3YWtlX3VwX2ludGVycnVwdGlibGUoJnR0eS0+d3JpdGVfd2FpdCk7DQog
CXdha2VfdXBfaW50ZXJydXB0aWJsZSgmdHR5LT5yZWFkX3dhaXQpOw0KZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvdXNiL2F0bS9jeGFjcnUuYyBiL2RyaXZlcnMvdXNiL2F0bS9jeGFjcnUuYw0KaW5kZXgg
YTg0NWY4Yi4uOTQ5NzE3MSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvdXNiL2F0bS9jeGFjcnUuYw0K
KysrIGIvZHJpdmVycy91c2IvYXRtL2N4YWNydS5jDQpAQCAtNjg2LDcgKzY4Niw4IEBAIHN0YXRp
YyBpbnQgY3hhY3J1X2NtX2dldF9hcnJheShzdHJ1Y3QgY3hhY3J1X2RhdGEgKmluc3RhbmNlLCBl
bnVtIGN4YWNydV9jbV9yZXF1DQogew0KIAlpbnQgcmV0LCBsZW47DQogCV9fbGUzMiAqYnVmOw0K
LQlpbnQgb2ZmYiwgb2ZmZDsNCisJaW50IG9mZmI7DQorCXVuc2lnbmVkIGludCBvZmZkOw0KIAlj
b25zdCBpbnQgc3RyaWRlID0gQ01EX1BBQ0tFVF9TSVpFIC8gKDQgKiAyKSAtIDE7DQogCWludCBi
dWZsZW4gPSAgKChzaXplIC0gMSkgLyBzdHJpZGUgKyAxICsgc2l6ZSAqIDIpICogNDsNCiANCmRp
ZmYgLS1naXQgYS9kcml2ZXJzL3VzYi9jb3JlL3F1aXJrcy5jIGIvZHJpdmVycy91c2IvY29yZS9x
dWlya3MuYw0KaW5kZXggMGFhYTRmMS4uMmZiY2I3NSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvdXNi
L2NvcmUvcXVpcmtzLmMNCisrKyBiL2RyaXZlcnMvdXNiL2NvcmUvcXVpcmtzLmMNCkBAIC04OCw2
ICs4OCw5IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3QgdXNiX2RldmljZV9pZCB1c2JfcXVpcmtfbGlz
dFtdID0gew0KIAkvKiBFZGlyb2wgU0QtMjAgKi8NCiAJeyBVU0JfREVWSUNFKDB4MDU4MiwgMHgw
MDI3KSwgLmRyaXZlcl9pbmZvID0gVVNCX1FVSVJLX1JFU0VUX1JFU1VNRSB9LA0KIA0KKwkvKiBB
bGNvciBNaWNybyBDb3JwLiBIdWIgKi8NCisJeyBVU0JfREVWSUNFKDB4MDU4ZiwgMHg5MjU0KSwg
LmRyaXZlcl9pbmZvID0gVVNCX1FVSVJLX1JFU0VUX1JFU1VNRSB9LA0KKw0KIAkvKiBhcHBsZXRv
dWNoICovDQogCXsgVVNCX0RFVklDRSgweDA1YWMsIDB4MDIxYSksIC5kcml2ZXJfaW5mbyA9IFVT
Ql9RVUlSS19SRVNFVF9SRVNVTUUgfSwNCiANCmRpZmYgLS1naXQgYS9kcml2ZXJzL3VzYi9ob3N0
L3VoY2ktaHViLmMgYi9kcml2ZXJzL3VzYi9ob3N0L3VoY2ktaHViLmMNCmluZGV4IDA0NWNkZTQu
Ljg1MDcyM2YgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3VzYi9ob3N0L3VoY2ktaHViLmMNCisrKyBi
L2RyaXZlcnMvdXNiL2hvc3QvdWhjaS1odWIuYw0KQEAgLTIyMSw3ICsyMjEsOCBAQCBzdGF0aWMg
aW50IHVoY2lfaHViX3N0YXR1c19kYXRhKHN0cnVjdCB1c2JfaGNkICpoY2QsIGNoYXIgKmJ1ZikN
CiAJCS8qIGF1dG8tc3RvcCBpZiBub3RoaW5nIGNvbm5lY3RlZCBmb3IgMSBzZWNvbmQgKi8NCiAJ
CWlmIChhbnlfcG9ydHNfYWN0aXZlKHVoY2kpKQ0KIAkJCXVoY2ktPnJoX3N0YXRlID0gVUhDSV9S
SF9SVU5OSU5HOw0KLQkJZWxzZSBpZiAodGltZV9hZnRlcl9lcShqaWZmaWVzLCB1aGNpLT5hdXRv
X3N0b3BfdGltZSkpDQorCQllbHNlIGlmICh0aW1lX2FmdGVyX2VxKGppZmZpZXMsIHVoY2ktPmF1
dG9fc3RvcF90aW1lKSAmJg0KKwkJCQkhdWhjaS0+d2FpdF9mb3JfaHApDQogCQkJc3VzcGVuZF9y
aCh1aGNpLCBVSENJX1JIX0FVVE9fU1RPUFBFRCk7DQogCQlicmVhazsNCiANCmRpZmYgLS1naXQg
YS9kcml2ZXJzL3VzYi9ob3N0L3hoY2ktbWVtLmMgYi9kcml2ZXJzL3VzYi9ob3N0L3hoY2ktbWVt
LmMNCmluZGV4IGVlNWVjMTEuLjQzMGMxZDUgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3VzYi9ob3N0
L3hoY2ktbWVtLmMNCisrKyBiL2RyaXZlcnMvdXNiL2hvc3QveGhjaS1tZW0uYw0KQEAgLTEzNTMs
MTUgKzEzNTMsMTcgQEAgaW50IHhoY2lfZW5kcG9pbnRfaW5pdChzdHJ1Y3QgeGhjaV9oY2QgKnho
Y2ksDQogCWVwX2N0eC0+ZXBfaW5mbzIgfD0gY3B1X3RvX2xlMzIoeGhjaV9nZXRfZW5kcG9pbnRf
dHlwZSh1ZGV2LCBlcCkpOw0KIA0KIAkvKiBTZXQgdGhlIG1heCBwYWNrZXQgc2l6ZSBhbmQgbWF4
IGJ1cnN0ICovDQorCW1heF9wYWNrZXQgPSBHRVRfTUFYX1BBQ0tFVCh1c2JfZW5kcG9pbnRfbWF4
cCgmZXAtPmRlc2MpKTsNCisJbWF4X2J1cnN0ID0gMDsNCiAJc3dpdGNoICh1ZGV2LT5zcGVlZCkg
ew0KIAljYXNlIFVTQl9TUEVFRF9TVVBFUjoNCi0JCW1heF9wYWNrZXQgPSB1c2JfZW5kcG9pbnRf
bWF4cCgmZXAtPmRlc2MpOw0KLQkJZXBfY3R4LT5lcF9pbmZvMiB8PSBjcHVfdG9fbGUzMihNQVhf
UEFDS0VUKG1heF9wYWNrZXQpKTsNCiAJCS8qIGRpZyBvdXQgbWF4IGJ1cnN0IGZyb20gZXAgY29t
cGFuaW9uIGRlc2MgKi8NCi0JCW1heF9wYWNrZXQgPSBlcC0+c3NfZXBfY29tcC5iTWF4QnVyc3Q7
DQotCQllcF9jdHgtPmVwX2luZm8yIHw9IGNwdV90b19sZTMyKE1BWF9CVVJTVChtYXhfcGFja2V0
KSk7DQorCQltYXhfYnVyc3QgPSBlcC0+c3NfZXBfY29tcC5iTWF4QnVyc3Q7DQogCQlicmVhazsN
CiAJY2FzZSBVU0JfU1BFRURfSElHSDoNCisJCS8qIFNvbWUgZGV2aWNlcyBnZXQgdGhpcyB3cm9u
ZyAqLw0KKwkJaWYgKHVzYl9lbmRwb2ludF94ZmVyX2J1bGsoJmVwLT5kZXNjKSkNCisJCQltYXhf
cGFja2V0ID0gNTEyOw0KIAkJLyogYml0cyAxMToxMiBzcGVjaWZ5IHRoZSBudW1iZXIgb2YgYWRk
aXRpb25hbCB0cmFuc2FjdGlvbg0KIAkJICogb3Bwb3J0dW5pdGllcyBwZXIgbWljcm9mcmFtZSAo
VVNCIDIuMCwgc2VjdGlvbiA5LjYuNikNCiAJCSAqLw0KQEAgLTEzNjksMTcgKzEzNzEsMTYgQEAg
aW50IHhoY2lfZW5kcG9pbnRfaW5pdChzdHJ1Y3QgeGhjaV9oY2QgKnhoY2ksDQogCQkJCXVzYl9l
bmRwb2ludF94ZmVyX2ludCgmZXAtPmRlc2MpKSB7DQogCQkJbWF4X2J1cnN0ID0gKHVzYl9lbmRw
b2ludF9tYXhwKCZlcC0+ZGVzYykNCiAJCQkJICAgICAmIDB4MTgwMCkgPj4gMTE7DQotCQkJZXBf
Y3R4LT5lcF9pbmZvMiB8PSBjcHVfdG9fbGUzMihNQVhfQlVSU1QobWF4X2J1cnN0KSk7DQogCQl9
DQotCQkvKiBGYWxsIHRocm91Z2ggKi8NCisJCWJyZWFrOw0KIAljYXNlIFVTQl9TUEVFRF9GVUxM
Og0KIAljYXNlIFVTQl9TUEVFRF9MT1c6DQotCQltYXhfcGFja2V0ID0gR0VUX01BWF9QQUNLRVQo
dXNiX2VuZHBvaW50X21heHAoJmVwLT5kZXNjKSk7DQotCQllcF9jdHgtPmVwX2luZm8yIHw9IGNw
dV90b19sZTMyKE1BWF9QQUNLRVQobWF4X3BhY2tldCkpOw0KIAkJYnJlYWs7DQogCWRlZmF1bHQ6
DQogCQlCVUcoKTsNCiAJfQ0KKwllcF9jdHgtPmVwX2luZm8yIHw9IGNwdV90b19sZTMyKE1BWF9Q
QUNLRVQobWF4X3BhY2tldCkgfA0KKwkJCU1BWF9CVVJTVChtYXhfYnVyc3QpKTsNCiAJbWF4X2Vz
aXRfcGF5bG9hZCA9IHhoY2lfZ2V0X21heF9lc2l0X3BheWxvYWQoeGhjaSwgdWRldiwgZXApOw0K
IAllcF9jdHgtPnR4X2luZm8gPSBjcHVfdG9fbGUzMihNQVhfRVNJVF9QQVlMT0FEX0ZPUl9FUCht
YXhfZXNpdF9wYXlsb2FkKSk7DQogDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy91c2IvaG9zdC94aGNp
LXJpbmcuYyBiL2RyaXZlcnMvdXNiL2hvc3QveGhjaS1yaW5nLmMNCmluZGV4IDM3YjJhODkuLmQw
OGE4MDQgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3VzYi9ob3N0L3hoY2ktcmluZy5jDQorKysgYi9k
cml2ZXJzL3VzYi9ob3N0L3hoY2ktcmluZy5jDQpAQCAtMjM3NiwxNCArMjM3NiwyMSBAQCBzdGF0
aWMgaW50IGhhbmRsZV90eF9ldmVudChzdHJ1Y3QgeGhjaV9oY2QgKnhoY2ksDQogCQkgKiBURCBs
aXN0Lg0KIAkJICovDQogCQlpZiAobGlzdF9lbXB0eSgmZXBfcmluZy0+dGRfbGlzdCkpIHsNCi0J
CQl4aGNpX3dhcm4oeGhjaSwgIldBUk4gRXZlbnQgVFJCIGZvciBzbG90ICVkIGVwICVkICINCi0J
CQkJCSJ3aXRoIG5vIFREcyBxdWV1ZWQ/XG4iLA0KLQkJCQkgIFRSQl9UT19TTE9UX0lEKGxlMzJf
dG9fY3B1KGV2ZW50LT5mbGFncykpLA0KLQkJCQkgIGVwX2luZGV4KTsNCi0JCQl4aGNpX2RiZyh4
aGNpLCAiRXZlbnQgVFJCIHdpdGggVFJCIHR5cGUgSUQgJXVcbiIsDQotCQkJCSAobGUzMl90b19j
cHUoZXZlbnQtPmZsYWdzKSAmDQotCQkJCSAgVFJCX1RZUEVfQklUTUFTSyk+PjEwKTsNCi0JCQl4
aGNpX3ByaW50X3RyYl9vZmZzZXRzKHhoY2ksICh1bmlvbiB4aGNpX3RyYiAqKSBldmVudCk7DQor
CQkJLyoNCisJCQkgKiBBIHN0b3BwZWQgZW5kcG9pbnQgbWF5IGdlbmVyYXRlIGFuIGV4dHJhIGNv
bXBsZXRpb24NCisJCQkgKiBldmVudCBpZiB0aGUgZGV2aWNlIHdhcyBzdXNwZW5kZWQuICBEb24n
dCBwcmludA0KKwkJCSAqIHdhcm5pbmdzLg0KKwkJCSAqLw0KKwkJCWlmICghKHRyYl9jb21wX2Nv
ZGUgPT0gQ09NUF9TVE9QIHx8DQorCQkJCQkJdHJiX2NvbXBfY29kZSA9PSBDT01QX1NUT1BfSU5W
QUwpKSB7DQorCQkJCXhoY2lfd2Fybih4aGNpLCAiV0FSTiBFdmVudCBUUkIgZm9yIHNsb3QgJWQg
ZXAgJWQgd2l0aCBubyBURHMgcXVldWVkP1xuIiwNCisJCQkJCQlUUkJfVE9fU0xPVF9JRChsZTMy
X3RvX2NwdShldmVudC0+ZmxhZ3MpKSwNCisJCQkJCQllcF9pbmRleCk7DQorCQkJCXhoY2lfZGJn
KHhoY2ksICJFdmVudCBUUkIgd2l0aCBUUkIgdHlwZSBJRCAldVxuIiwNCisJCQkJCQkobGUzMl90
b19jcHUoZXZlbnQtPmZsYWdzKSAmDQorCQkJCQkJIFRSQl9UWVBFX0JJVE1BU0spPj4xMCk7DQor
CQkJCXhoY2lfcHJpbnRfdHJiX29mZnNldHMoeGhjaSwgKHVuaW9uIHhoY2lfdHJiICopIGV2ZW50
KTsNCisJCQl9DQogCQkJaWYgKGVwLT5za2lwKSB7DQogCQkJCWVwLT5za2lwID0gZmFsc2U7DQog
CQkJCXhoY2lfZGJnKHhoY2ksICJ0ZF9saXN0IGlzIGVtcHR5IHdoaWxlIHNraXAgIg0KZGlmZiAt
LWdpdCBhL2RyaXZlcnMvdXNiL3NlcmlhbC9mdGRpX3Npby5jIGIvZHJpdmVycy91c2Ivc2VyaWFs
L2Z0ZGlfc2lvLmMNCmluZGV4IDUxZDE3MTIuLjkxOGVjOTggMTAwNjQ0DQotLS0gYS9kcml2ZXJz
L3VzYi9zZXJpYWwvZnRkaV9zaW8uYw0KKysrIGIvZHJpdmVycy91c2Ivc2VyaWFsL2Z0ZGlfc2lv
LmMNCkBAIC0xOTcsNiArMTk3LDggQEAgc3RhdGljIHN0cnVjdCB1c2JfZGV2aWNlX2lkIGlkX3Rh
YmxlX2NvbWJpbmVkIFtdID0gew0KIAl7IFVTQl9ERVZJQ0UoRlRESV9WSUQsIEZURElfT1BFTkRD
Q19HQk1fUElEKSB9LA0KIAl7IFVTQl9ERVZJQ0UoRlRESV9WSUQsIEZURElfT1BFTkRDQ19HQk1f
Qk9PU1RfUElEKSB9LA0KIAl7IFVTQl9ERVZJQ0UoTkVXUE9SVF9WSUQsIE5FV1BPUlRfQUdJTElT
X1BJRCkgfSwNCisJeyBVU0JfREVWSUNFKE5FV1BPUlRfVklELCBORVdQT1JUX0NPTkVYX0NDX1BJ
RCkgfSwNCisJeyBVU0JfREVWSUNFKE5FV1BPUlRfVklELCBORVdQT1JUX0NPTkVYX0FHUF9QSUQp
IH0sDQogCXsgVVNCX0RFVklDRShJTlRFUkJJT01FVFJJQ1NfVklELCBJTlRFUkJJT01FVFJJQ1Nf
SU9CT0FSRF9QSUQpIH0sDQogCXsgVVNCX0RFVklDRShJTlRFUkJJT01FVFJJQ1NfVklELCBJTlRF
UkJJT01FVFJJQ1NfTUlOSV9JT0JPQVJEX1BJRCkgfSwNCiAJeyBVU0JfREVWSUNFKEZURElfVklE
LCBGVERJX1NQUk9HX0lJKSB9LA0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvdXNiL3NlcmlhbC9mdGRp
X3Npb19pZHMuaCBiL2RyaXZlcnMvdXNiL3NlcmlhbC9mdGRpX3Npb19pZHMuaA0KaW5kZXggMmY4
NjAwOC4uNWQyNWUyNiAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvdXNiL3NlcmlhbC9mdGRpX3Npb19p
ZHMuaA0KKysrIGIvZHJpdmVycy91c2Ivc2VyaWFsL2Z0ZGlfc2lvX2lkcy5oDQpAQCAtNzcyLDYg
Kzc3Miw4IEBADQogICovDQogI2RlZmluZSBORVdQT1JUX1ZJRAkJCTB4MTA0RA0KICNkZWZpbmUg
TkVXUE9SVF9BR0lMSVNfUElECQkweDMwMDANCisjZGVmaW5lIE5FV1BPUlRfQ09ORVhfQ0NfUElE
CQkweDMwMDINCisjZGVmaW5lIE5FV1BPUlRfQ09ORVhfQUdQX1BJRAkJMHgzMDA2DQogDQogLyog
SW50ZXJiaW9tZXRyaWNzIFVTQiBJL08gQm9hcmQgKi8NCiAvKiBEZXZlbG9wZWQgZm9yIEludGVy
YmlvbWV0cmljcyBieSBSdWRvbGYgR3VnbGVyICovDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy91c2Iv
c2VyaWFsL29wdGlvbi5jIGIvZHJpdmVycy91c2Ivc2VyaWFsL29wdGlvbi5jDQppbmRleCA4NTEz
ZjUxLi41OWM0OTk3IDEwMDY0NA0KLS0tIGEvZHJpdmVycy91c2Ivc2VyaWFsL29wdGlvbi5jDQor
KysgYi9kcml2ZXJzL3VzYi9zZXJpYWwvb3B0aW9uLmMNCkBAIC0xOTYsNiArMTk2LDcgQEAgc3Rh
dGljIHZvaWQgb3B0aW9uX2luc3RhdF9jYWxsYmFjayhzdHJ1Y3QgdXJiICp1cmIpOw0KIA0KICNk
ZWZpbmUgREVMTF9QUk9EVUNUXzU4MDBfTUlOSUNBUkRfVlpXCQkweDgxOTUgIC8qIE5vdmF0ZWwg
RTM2MiAqLw0KICNkZWZpbmUgREVMTF9QUk9EVUNUXzU4MDBfVjJfTUlOSUNBUkRfVlpXCTB4ODE5
NiAgLyogTm92YXRlbCBFMzYyICovDQorI2RlZmluZSBERUxMX1BST0RVQ1RfNTgwNF9NSU5JQ0FS
RF9BVFQJCTB4ODE5YiAgLyogTm92YXRlbCBFMzcxICovDQogDQogI2RlZmluZSBLWU9DRVJBX1ZF
TkRPUl9JRAkJCTB4MGM4OA0KICNkZWZpbmUgS1lPQ0VSQV9QUk9EVUNUX0tQQzY1MAkJCTB4MTdk
YQ0KQEAgLTM0MSw4ICszNDIsOCBAQCBzdGF0aWMgdm9pZCBvcHRpb25faW5zdGF0X2NhbGxiYWNr
KHN0cnVjdCB1cmIgKnVyYik7DQogI2RlZmluZSBDSU5URVJJT05fUFJPRFVDVF9FVTNfRQkJCTB4
MDA1MQ0KICNkZWZpbmUgQ0lOVEVSSU9OX1BST0RVQ1RfRVUzX1AJCQkweDAwNTINCiAjZGVmaW5l
IENJTlRFUklPTl9QUk9EVUNUX1BIOAkJCTB4MDA1Mw0KLSNkZWZpbmUgQ0lOVEVSSU9OX1BST0RV
Q1RfQUg2CQkJMHgwMDU1DQotI2RlZmluZSBDSU5URVJJT05fUFJPRFVDVF9QTFM4CQkJMHgwMDYw
DQorI2RlZmluZSBDSU5URVJJT05fUFJPRFVDVF9BSFhYCQkJMHgwMDU1DQorI2RlZmluZSBDSU5U
RVJJT05fUFJPRFVDVF9QTFhYCQkJMHgwMDYwDQogDQogLyogT2xpdmV0dGkgcHJvZHVjdHMgKi8N
CiAjZGVmaW5lIE9MSVZFVFRJX1ZFTkRPUl9JRAkJCTB4MGIzYw0KQEAgLTc3MSw2ICs3NzIsNyBA
QCBzdGF0aWMgY29uc3Qgc3RydWN0IHVzYl9kZXZpY2VfaWQgb3B0aW9uX2lkc1tdID0gew0KIAl7
IFVTQl9ERVZJQ0UoREVMTF9WRU5ET1JfSUQsIERFTExfUFJPRFVDVF81NzMwX01JTklDQVJEX1Za
VykgfSwgCS8qIERlbGwgV2lyZWxlc3MgNTczMCBNb2JpbGUgQnJvYWRiYW5kIEVWRE8vSFNQQSBN
aW5pLUNhcmQgKi8NCiAJeyBVU0JfREVWSUNFX0FORF9JTlRFUkZBQ0VfSU5GTyhERUxMX1ZFTkRP
Ul9JRCwgREVMTF9QUk9EVUNUXzU4MDBfTUlOSUNBUkRfVlpXLCAweGZmLCAweGZmLCAweGZmKSB9
LA0KIAl7IFVTQl9ERVZJQ0VfQU5EX0lOVEVSRkFDRV9JTkZPKERFTExfVkVORE9SX0lELCBERUxM
X1BST0RVQ1RfNTgwMF9WMl9NSU5JQ0FSRF9WWlcsIDB4ZmYsIDB4ZmYsIDB4ZmYpIH0sDQorCXsg
VVNCX0RFVklDRV9BTkRfSU5URVJGQUNFX0lORk8oREVMTF9WRU5ET1JfSUQsIERFTExfUFJPRFVD
VF81ODA0X01JTklDQVJEX0FUVCwgMHhmZiwgMHhmZiwgMHhmZikgfSwNCiAJeyBVU0JfREVWSUNF
KEFOWURBVEFfVkVORE9SX0lELCBBTllEQVRBX1BST0RVQ1RfQURVX0UxMDBBKSB9LAkvKiBBRFUt
RTEwMCwgQURVLTMxMCAqLw0KIAl7IFVTQl9ERVZJQ0UoQU5ZREFUQV9WRU5ET1JfSUQsIEFOWURB
VEFfUFJPRFVDVF9BRFVfNTAwQSkgfSwNCiAJeyBVU0JfREVWSUNFKEFOWURBVEFfVkVORE9SX0lE
LCBBTllEQVRBX1BST0RVQ1RfQURVXzYyMFVXKSB9LA0KQEAgLTk2Niw2ICs5NjgsOCBAQCBzdGF0
aWMgY29uc3Qgc3RydWN0IHVzYl9kZXZpY2VfaWQgb3B0aW9uX2lkc1tdID0gew0KIAkgIC5kcml2
ZXJfaW5mbyA9IChrZXJuZWxfdWxvbmdfdCkmbmV0X2ludGY0X2JsYWNrbGlzdCB9LA0KIAl7IFVT
Ql9ERVZJQ0VfQU5EX0lOVEVSRkFDRV9JTkZPKFpURV9WRU5ET1JfSUQsIDB4MDMzMCwgMHhmZiwg
MHhmZiwgMHhmZikgfSwNCiAJeyBVU0JfREVWSUNFX0FORF9JTlRFUkZBQ0VfSU5GTyhaVEVfVkVO
RE9SX0lELCAweDAzOTUsIDB4ZmYsIDB4ZmYsIDB4ZmYpIH0sDQorCXsgVVNCX0RFVklDRV9BTkRf
SU5URVJGQUNFX0lORk8oWlRFX1ZFTkRPUl9JRCwgMHgwNDEyLCAweGZmLCAweGZmLCAweGZmKSwg
LyogVGVsZXdlbGwgVFctTFRFIDRHICovDQorCSAgLmRyaXZlcl9pbmZvID0gKGtlcm5lbF91bG9u
Z190KSZuZXRfaW50ZjRfYmxhY2tsaXN0IH0sDQogCXsgVVNCX0RFVklDRV9BTkRfSU5URVJGQUNF
X0lORk8oWlRFX1ZFTkRPUl9JRCwgMHgwNDE0LCAweGZmLCAweGZmLCAweGZmKSB9LA0KIAl7IFVT
Ql9ERVZJQ0VfQU5EX0lOVEVSRkFDRV9JTkZPKFpURV9WRU5ET1JfSUQsIDB4MDQxNywgMHhmZiwg
MHhmZiwgMHhmZikgfSwNCiAJeyBVU0JfREVWSUNFX0FORF9JTlRFUkZBQ0VfSU5GTyhaVEVfVkVO
RE9SX0lELCAweDEwMDgsIDB4ZmYsIDB4ZmYsIDB4ZmYpLA0KQEAgLTEyNjQsOCArMTI2OCw5IEBA
IHN0YXRpYyBjb25zdCBzdHJ1Y3QgdXNiX2RldmljZV9pZCBvcHRpb25faWRzW10gPSB7DQogCXsg
VVNCX0RFVklDRShDSU5URVJJT05fVkVORE9SX0lELCBDSU5URVJJT05fUFJPRFVDVF9FVTNfRSkg
fSwNCiAJeyBVU0JfREVWSUNFKENJTlRFUklPTl9WRU5ET1JfSUQsIENJTlRFUklPTl9QUk9EVUNU
X0VVM19QKSB9LA0KIAl7IFVTQl9ERVZJQ0UoQ0lOVEVSSU9OX1ZFTkRPUl9JRCwgQ0lOVEVSSU9O
X1BST0RVQ1RfUEg4KSB9LA0KLQl7IFVTQl9ERVZJQ0UoQ0lOVEVSSU9OX1ZFTkRPUl9JRCwgQ0lO
VEVSSU9OX1BST0RVQ1RfQUg2KSB9LA0KLQl7IFVTQl9ERVZJQ0UoQ0lOVEVSSU9OX1ZFTkRPUl9J
RCwgQ0lOVEVSSU9OX1BST0RVQ1RfUExTOCkgfSwNCisJeyBVU0JfREVWSUNFKENJTlRFUklPTl9W
RU5ET1JfSUQsIENJTlRFUklPTl9QUk9EVUNUX0FIWFgpIH0sDQorCXsgVVNCX0RFVklDRShDSU5U
RVJJT05fVkVORE9SX0lELCBDSU5URVJJT05fUFJPRFVDVF9QTFhYKSwNCisJCS5kcml2ZXJfaW5m
byA9IChrZXJuZWxfdWxvbmdfdCkmbmV0X2ludGY0X2JsYWNrbGlzdCB9LA0KIAl7IFVTQl9ERVZJ
Q0UoQ0lOVEVSSU9OX1ZFTkRPUl9JRCwgQ0lOVEVSSU9OX1BST0RVQ1RfSEMyOF9NRE0pIH0sIA0K
IAl7IFVTQl9ERVZJQ0UoQ0lOVEVSSU9OX1ZFTkRPUl9JRCwgQ0lOVEVSSU9OX1BST0RVQ1RfSEMy
OF9NRE1ORVQpIH0sDQogCXsgVVNCX0RFVklDRShTSUVNRU5TX1ZFTkRPUl9JRCwgQ0lOVEVSSU9O
X1BST0RVQ1RfSEMyNV9NRE0pIH0sDQpkaWZmIC0tZ2l0IGEvZnMvYXV0b2ZzNC9leHBpcmUuYyBi
L2ZzL2F1dG9mczQvZXhwaXJlLmMNCmluZGV4IDQ1MGY1MjkuLjJjNjlkMTIgMTAwNjQ0DQotLS0g
YS9mcy9hdXRvZnM0L2V4cGlyZS5jDQorKysgYi9mcy9hdXRvZnM0L2V4cGlyZS5jDQpAQCAtNjEs
MTUgKzYxLDYgQEAgc3RhdGljIGludCBhdXRvZnM0X21vdW50X2J1c3koc3RydWN0IHZmc21vdW50
ICptbnQsIHN0cnVjdCBkZW50cnkgKmRlbnRyeSkNCiAJCS8qIFRoaXMgaXMgYW4gYXV0b2ZzIHN1
Ym1vdW50LCB3ZSBjYW4ndCBleHBpcmUgaXQgKi8NCiAJCWlmIChhdXRvZnNfdHlwZV9pbmRpcmVj
dChzYmktPnR5cGUpKQ0KIAkJCWdvdG8gZG9uZTsNCi0NCi0JCS8qDQotCQkgKiBPdGhlcndpc2Ug
aXQncyBhbiBvZmZzZXQgbW91bnQgYW5kIHdlIG5lZWQgdG8gY2hlY2sNCi0JCSAqIGlmIHdlIGNh
biB1bW91bnQgaXRzIG1vdW50LCBpZiB0aGVyZSBpcyBvbmUuDQotCQkgKi8NCi0JCWlmICghZF9t
b3VudHBvaW50KHBhdGguZGVudHJ5KSkgew0KLQkJCXN0YXR1cyA9IDA7DQotCQkJZ290byBkb25l
Ow0KLQkJfQ0KIAl9DQogDQogCS8qIFVwZGF0ZSB0aGUgZXhwaXJ5IGNvdW50ZXIgaWYgZnMgaXMg
YnVzeSAqLw0KZGlmZiAtLWdpdCBhL2ZzL2J0cmZzL2lvY3RsLmMgYi9mcy9idHJmcy9pb2N0bC5j
DQppbmRleCBjMDRmMDJjLi42MThhZTZmIDEwMDY0NA0KLS0tIGEvZnMvYnRyZnMvaW9jdGwuYw0K
KysrIGIvZnMvYnRyZnMvaW9jdGwuYw0KQEAgLTE1NzEsNyArMTU3MSwxMSBAQCBzdGF0aWMgbm9p
bmxpbmUgaW50IGNvcHlfdG9fc2soc3RydWN0IGJ0cmZzX3Jvb3QgKnJvb3QsDQogCQlpdGVtX29m
ZiA9IGJ0cmZzX2l0ZW1fcHRyX29mZnNldChsZWFmLCBpKTsNCiAJCWl0ZW1fbGVuID0gYnRyZnNf
aXRlbV9zaXplX25yKGxlYWYsIGkpOw0KIA0KLQkJaWYgKGl0ZW1fbGVuID4gQlRSRlNfU0VBUkNI
X0FSR1NfQlVGU0laRSkNCisJCWJ0cmZzX2l0ZW1fa2V5X3RvX2NwdShsZWFmLCBrZXksIGkpOw0K
KwkJaWYgKCFrZXlfaW5fc2soa2V5LCBzaykpDQorCQkJY29udGludWU7DQorDQorCQlpZiAoc2l6
ZW9mKHNoKSArIGl0ZW1fbGVuID4gQlRSRlNfU0VBUkNIX0FSR1NfQlVGU0laRSkNCiAJCQlpdGVt
X2xlbiA9IDA7DQogDQogCQlpZiAoc2l6ZW9mKHNoKSArIGl0ZW1fbGVuICsgKnNrX29mZnNldCA+
DQpAQCAtMTU4MCwxMCArMTU4NCw2IEBAIHN0YXRpYyBub2lubGluZSBpbnQgY29weV90b19zayhz
dHJ1Y3QgYnRyZnNfcm9vdCAqcm9vdCwNCiAJCQlnb3RvIG92ZXJmbG93Ow0KIAkJfQ0KIA0KLQkJ
YnRyZnNfaXRlbV9rZXlfdG9fY3B1KGxlYWYsIGtleSwgaSk7DQotCQlpZiAoIWtleV9pbl9zayhr
ZXksIHNrKSkNCi0JCQljb250aW51ZTsNCi0NCiAJCXNoLm9iamVjdGlkID0ga2V5LT5vYmplY3Rp
ZDsNCiAJCXNoLm9mZnNldCA9IGtleS0+b2Zmc2V0Ow0KIAkJc2gudHlwZSA9IGtleS0+dHlwZTsN
CmRpZmYgLS1naXQgYS9mcy9jaWZzL2lub2RlLmMgYi9mcy9jaWZzL2lub2RlLmMNCmluZGV4IGU4
NTFkNWIuLjIwNDMxYjQgMTAwNjQ0DQotLS0gYS9mcy9jaWZzL2lub2RlLmMNCisrKyBiL2ZzL2Np
ZnMvaW5vZGUuYw0KQEAgLTE3Myw3ICsxNzMsOCBAQCBjaWZzX2ZhdHRyX3RvX2lub2RlKHN0cnVj
dCBpbm9kZSAqaW5vZGUsIHN0cnVjdCBjaWZzX2ZhdHRyICpmYXR0cikNCiANCiAJaWYgKGZhdHRy
LT5jZl9mbGFncyAmIENJRlNfRkFUVFJfREZTX1JFRkVSUkFMKQ0KIAkJaW5vZGUtPmlfZmxhZ3Mg
fD0gU19BVVRPTU9VTlQ7DQotCWNpZnNfc2V0X29wcyhpbm9kZSk7DQorCWlmIChpbm9kZS0+aV9z
dGF0ZSAmIElfTkVXKQ0KKwkJY2lmc19zZXRfb3BzKGlub2RlKTsNCiB9DQogDQogdm9pZA0KZGlm
ZiAtLWdpdCBhL2ZzL2V4dDQvbWJhbGxvYy5jIGIvZnMvZXh0NC9tYmFsbG9jLmMNCmluZGV4IDdi
MTg1NjMuLjkyNDMxMDMgMTAwNjQ0DQotLS0gYS9mcy9leHQ0L21iYWxsb2MuYw0KKysrIGIvZnMv
ZXh0NC9tYmFsbG9jLmMNCkBAIC0yMDI3LDcgKzIwMjcsMTEgQEAgcmVwZWF0Og0KIAkJZ3JvdXAg
PSBhYy0+YWNfZ19leC5mZV9ncm91cDsNCiANCiAJCWZvciAoaSA9IDA7IGkgPCBuZ3JvdXBzOyBn
cm91cCsrLCBpKyspIHsNCi0JCQlpZiAoZ3JvdXAgPT0gbmdyb3VwcykNCisJCQkvKg0KKwkJCSAq
IEFydGlmaWNpYWxseSByZXN0cmljdGVkIG5ncm91cHMgZm9yIG5vbi1leHRlbnQNCisJCQkgKiBm
aWxlcyBtYWtlcyBncm91cCA+IG5ncm91cHMgcG9zc2libGUgb24gZmlyc3QgbG9vcC4NCisJCQkg
Ki8NCisJCQlpZiAoZ3JvdXAgPj0gbmdyb3VwcykNCiAJCQkJZ3JvdXAgPSAwOw0KIA0KIAkJCS8q
IFRoaXMgbm93IGNoZWNrcyB3aXRob3V0IG5lZWRpbmcgdGhlIGJ1ZGR5IHBhZ2UgKi8NCmRpZmYg
LS1naXQgYS9mcy9mYXQvaW5vZGUuYyBiL2ZzL2ZhdC9pbm9kZS5jDQppbmRleCA4MDhjYWM3Li5m
YzMzY2ExIDEwMDY0NA0KLS0tIGEvZnMvZmF0L2lub2RlLmMNCisrKyBiL2ZzL2ZhdC9pbm9kZS5j
DQpAQCAtMTIzOCw2ICsxMjM4LDE5IEBAIHN0YXRpYyBpbnQgZmF0X3JlYWRfcm9vdChzdHJ1Y3Qg
aW5vZGUgKmlub2RlKQ0KIAlyZXR1cm4gMDsNCiB9DQogDQorc3RhdGljIHVuc2lnbmVkIGxvbmcg
Y2FsY19mYXRfY2x1c3RlcnMoc3RydWN0IHN1cGVyX2Jsb2NrICpzYikNCit7DQorCXN0cnVjdCBt
c2Rvc19zYl9pbmZvICpzYmkgPSBNU0RPU19TQihzYik7DQorDQorCS8qIERpdmlkZSBmaXJzdCB0
byBhdm9pZCBvdmVyZmxvdyAqLw0KKwlpZiAoc2JpLT5mYXRfYml0cyAhPSAxMikgew0KKwkJdW5z
aWduZWQgbG9uZyBlbnRfcGVyX3NlYyA9IHNiLT5zX2Jsb2Nrc2l6ZSAqIDggLyBzYmktPmZhdF9i
aXRzOw0KKwkJcmV0dXJuIGVudF9wZXJfc2VjICogc2JpLT5mYXRfbGVuZ3RoOw0KKwl9DQorDQor
CXJldHVybiBzYmktPmZhdF9sZW5ndGggKiBzYi0+c19ibG9ja3NpemUgKiA4IC8gc2JpLT5mYXRf
Yml0czsNCit9DQorDQogLyoNCiAgKiBSZWFkIHRoZSBzdXBlciBibG9jayBvZiBhbiBNUy1ET1Mg
RlMuDQogICovDQpAQCAtMTQzNCw3ICsxNDQ3LDcgQEAgaW50IGZhdF9maWxsX3N1cGVyKHN0cnVj
dCBzdXBlcl9ibG9jayAqc2IsIHZvaWQgKmRhdGEsIGludCBzaWxlbnQsIGludCBpc3ZmYXQsDQog
CQlzYmktPmZhdF9iaXRzID0gKHRvdGFsX2NsdXN0ZXJzID4gTUFYX0ZBVDEyKSA/IDE2IDogMTI7
DQogDQogCS8qIGNoZWNrIHRoYXQgRkFUIHRhYmxlIGRvZXMgbm90IG92ZXJmbG93ICovDQotCWZh
dF9jbHVzdGVycyA9IHNiaS0+ZmF0X2xlbmd0aCAqIHNiLT5zX2Jsb2Nrc2l6ZSAqIDggLyBzYmkt
PmZhdF9iaXRzOw0KKwlmYXRfY2x1c3RlcnMgPSBjYWxjX2ZhdF9jbHVzdGVycyhzYik7DQogCXRv
dGFsX2NsdXN0ZXJzID0gbWluKHRvdGFsX2NsdXN0ZXJzLCBmYXRfY2x1c3RlcnMgLSBGQVRfU1RB
UlRfRU5UKTsNCiAJaWYgKHRvdGFsX2NsdXN0ZXJzID4gTUFYX0ZBVChzYikpIHsNCiAJCWlmICgh
c2lsZW50KQ0KZGlmZiAtLWdpdCBhL2ZzL25mc2QvbmZzNHByb2MuYyBiL2ZzL25mc2QvbmZzNHBy
b2MuYw0KaW5kZXggMDg5MjFiOC4uZTA2NTQ5NyAxMDA2NDQNCi0tLSBhL2ZzL25mc2QvbmZzNHBy
b2MuYw0KKysrIGIvZnMvbmZzZC9uZnM0cHJvYy5jDQpAQCAtMjY3LDYgKzI2Nyw3IEBAIHN0YXRp
YyBfX2JlMzINCiBkb19vcGVuX2ZoYW5kbGUoc3RydWN0IHN2Y19ycXN0ICpycXN0cCwgc3RydWN0
IHN2Y19maCAqY3VycmVudF9maCwgc3RydWN0IG5mc2Q0X29wZW4gKm9wZW4pDQogew0KIAlfX2Jl
MzIgc3RhdHVzOw0KKwlpbnQgYWNjbW9kZSA9IDA7DQogDQogCS8qIE9ubHkgcmVjbGFpbXMgZnJv
bSBwcmV2aW91c2x5IGNvbmZpcm1lZCBjbGllbnRzIGFyZSB2YWxpZCAqLw0KIAlpZiAoKHN0YXR1
cyA9IG5mczRfY2hlY2tfb3Blbl9yZWNsYWltKCZvcGVuLT5vcF9jbGllbnRpZCkpKQ0KQEAgLTI4
NCw5ICsyODUsMTkgQEAgZG9fb3Blbl9maGFuZGxlKHN0cnVjdCBzdmNfcnFzdCAqcnFzdHAsIHN0
cnVjdCBzdmNfZmggKmN1cnJlbnRfZmgsIHN0cnVjdCBuZnNkNF8NCiANCiAJb3Blbi0+b3BfdHJ1
bmNhdGUgPSAob3Blbi0+b3BfaWF0dHIuaWFfdmFsaWQgJiBBVFRSX1NJWkUpICYmDQogCQkob3Bl
bi0+b3BfaWF0dHIuaWFfc2l6ZSA9PSAwKTsNCisJLyoNCisJICogSW4gdGhlIGRlbGVnYXRpb24g
Y2FzZSwgdGhlIGNsaWVudCBpcyB0ZWxsaW5nIHVzIGFib3V0IGFuDQorCSAqIG9wZW4gdGhhdCBp
dCAqYWxyZWFkeSogcGVyZm9ybWVkIGxvY2FsbHksIHNvbWUgdGltZSBhZ28uICBXZQ0KKwkgKiBz
aG91bGQgbGV0IGl0IHN1Y2NlZWQgbm93IGlmIHBvc3NpYmxlLg0KKwkgKg0KKwkgKiBJbiB0aGUg
Y2FzZSBvZiBhIENMQUlNX0ZIIG9wZW4sIG9uIHRoZSBvdGhlciBoYW5kLCB0aGUgY2xpZW50DQor
CSAqIG1heSBiZSBjb3VudGluZyBvbiB1cyB0byBlbmZvcmNlIHBlcm1pc3Npb25zICh0aGUgTGlu
dXggNC4xDQorCSAqIGNsaWVudCB1c2VzIHRoaXMgZm9yIG5vcm1hbCBvcGVucywgZm9yIGV4YW1w
bGUpLg0KKwkgKi8NCisJaWYgKG9wZW4tPm9wX2NsYWltX3R5cGUgPT0gTkZTNF9PUEVOX0NMQUlN
X0RFTEVHX0NVUl9GSCkNCisJCWFjY21vZGUgPSBORlNEX01BWV9PV05FUl9PVkVSUklERTsNCiAN
Ci0Jc3RhdHVzID0gZG9fb3Blbl9wZXJtaXNzaW9uKHJxc3RwLCBjdXJyZW50X2ZoLCBvcGVuLA0K
LQkJCQkgICAgTkZTRF9NQVlfT1dORVJfT1ZFUlJJREUpOw0KKwlzdGF0dXMgPSBkb19vcGVuX3Bl
cm1pc3Npb24ocnFzdHAsIGN1cnJlbnRfZmgsIG9wZW4sIGFjY21vZGUpOw0KIA0KIAlyZXR1cm4g
c3RhdHVzOw0KIH0NCmRpZmYgLS1naXQgYS9mcy9uaWxmczIvaW5vZGUuYyBiL2ZzL25pbGZzMi9p
bm9kZS5jDQppbmRleCBiNTBmZmI3Li5lZGViMjM5IDEwMDY0NA0KLS0tIGEvZnMvbmlsZnMyL2lu
b2RlLmMNCisrKyBiL2ZzL25pbGZzMi9pbm9kZS5jDQpAQCAtMTk1LDEzICsxOTUsMzIgQEAgc3Rh
dGljIGludCBuaWxmc193cml0ZXBhZ2Uoc3RydWN0IHBhZ2UgKnBhZ2UsIHN0cnVjdCB3cml0ZWJh
Y2tfY29udHJvbCAqd2JjKQ0KIA0KIHN0YXRpYyBpbnQgbmlsZnNfc2V0X3BhZ2VfZGlydHkoc3Ry
dWN0IHBhZ2UgKnBhZ2UpDQogew0KLQlpbnQgcmV0ID0gX19zZXRfcGFnZV9kaXJ0eV9idWZmZXJz
KHBhZ2UpOw0KKwlpbnQgcmV0ID0gX19zZXRfcGFnZV9kaXJ0eV9ub2J1ZmZlcnMocGFnZSk7DQog
DQotCWlmIChyZXQpIHsNCisJaWYgKHBhZ2VfaGFzX2J1ZmZlcnMocGFnZSkpIHsNCiAJCXN0cnVj
dCBpbm9kZSAqaW5vZGUgPSBwYWdlLT5tYXBwaW5nLT5ob3N0Ow0KLQkJdW5zaWduZWQgbnJfZGly
dHkgPSAxIDw8IChQQUdFX1NISUZUIC0gaW5vZGUtPmlfYmxrYml0cyk7DQorCQl1bnNpZ25lZCBu
cl9kaXJ0eSA9IDA7DQorCQlzdHJ1Y3QgYnVmZmVyX2hlYWQgKmJoLCAqaGVhZDsNCiANCi0JCW5p
bGZzX3NldF9maWxlX2RpcnR5KGlub2RlLCBucl9kaXJ0eSk7DQorCQkvKg0KKwkJICogVGhpcyBw
YWdlIGlzIGxvY2tlZCBieSBjYWxsZXJzLCBhbmQgbm8gb3RoZXIgdGhyZWFkDQorCQkgKiBjb25j
dXJyZW50bHkgbWFya3MgaXRzIGJ1ZmZlcnMgZGlydHkgc2luY2UgdGhleSBhcmUNCisJCSAqIG9u
bHkgZGlydGllZCB0aHJvdWdoIHJvdXRpbmVzIGluIGZzL2J1ZmZlci5jIGluDQorCQkgKiB3aGlj
aCBjYWxsIHNpdGVzIG9mIG1hcmtfYnVmZmVyX2RpcnR5IGFyZSBwcm90ZWN0ZWQNCisJCSAqIGJ5
IHBhZ2UgbG9jay4NCisJCSAqLw0KKwkJYmggPSBoZWFkID0gcGFnZV9idWZmZXJzKHBhZ2UpOw0K
KwkJZG8gew0KKwkJCS8qIERvIG5vdCBtYXJrIGhvbGUgYmxvY2tzIGRpcnR5ICovDQorCQkJaWYg
KGJ1ZmZlcl9kaXJ0eShiaCkgfHwgIWJ1ZmZlcl9tYXBwZWQoYmgpKQ0KKwkJCQljb250aW51ZTsN
CisNCisJCQlzZXRfYnVmZmVyX2RpcnR5KGJoKTsNCisJCQlucl9kaXJ0eSsrOw0KKwkJfSB3aGls
ZSAoYmggPSBiaC0+Yl90aGlzX3BhZ2UsIGJoICE9IGhlYWQpOw0KKw0KKwkJaWYgKG5yX2RpcnR5
KQ0KKwkJCW5pbGZzX3NldF9maWxlX2RpcnR5KGlub2RlLCBucl9kaXJ0eSk7DQogCX0NCiAJcmV0
dXJuIHJldDsNCiB9DQpkaWZmIC0tZ2l0IGEvZnMvb2NmczIvZXh0ZW50X21hcC5jIGIvZnMvb2Nm
czIvZXh0ZW50X21hcC5jDQppbmRleCAyZjViOTJlLi43ZWIxYzBjIDEwMDY0NA0KLS0tIGEvZnMv
b2NmczIvZXh0ZW50X21hcC5jDQorKysgYi9mcy9vY2ZzMi9leHRlbnRfbWFwLmMNCkBAIC03OTEs
NyArNzkxLDcgQEAgaW50IG9jZnMyX2ZpZW1hcChzdHJ1Y3QgaW5vZGUgKmlub2RlLCBzdHJ1Y3Qg
ZmllbWFwX2V4dGVudF9pbmZvICpmaWVpbmZvLA0KIAkJCQkJCSAmaG9sZV9zaXplLCAmcmVjLCAm
aXNfbGFzdCk7DQogCQlpZiAocmV0KSB7DQogCQkJbWxvZ19lcnJubyhyZXQpOw0KLQkJCWdvdG8g
b3V0Ow0KKwkJCWdvdG8gb3V0X3VubG9jazsNCiAJCX0NCiANCiAJCWlmIChyZWMuZV9ibGtubyA9
PSAwVUxMKSB7DQpkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC9lZmkuaCBiL2luY2x1ZGUvbGlu
dXgvZWZpLmgNCmluZGV4IDg0NjlmM2YuLjg4Yzk1M2QgMTAwNjQ0DQotLS0gYS9pbmNsdWRlL2xp
bnV4L2VmaS5oDQorKysgYi9pbmNsdWRlL2xpbnV4L2VmaS5oDQpAQCAtMjA0LDYgKzIwNCw3IEBA
IHR5cGVkZWYgZWZpX3N0YXR1c190IGVmaV9xdWVyeV9jYXBzdWxlX2NhcHNfdChlZmlfY2Fwc3Vs
ZV9oZWFkZXJfdCAqKmNhcHN1bGVzLA0KIAkJCQkJICAgICAgdW5zaWduZWQgbG9uZyBjb3VudCwN
CiAJCQkJCSAgICAgIHU2NCAqbWF4X3NpemUsDQogCQkJCQkgICAgICBpbnQgKnJlc2V0X3R5cGUp
Ow0KK3R5cGVkZWYgZWZpX3N0YXR1c190IGVmaV9xdWVyeV92YXJpYWJsZV9zdG9yZV90KHUzMiBh
dHRyaWJ1dGVzLCB1bnNpZ25lZCBsb25nIHNpemUpOw0KIA0KIC8qDQogICogIEVGSSBDb25maWd1
cmF0aW9uIFRhYmxlIGFuZCBHVUlEIGRlZmluaXRpb25zDQpAQCAtMzMxLDYgKzMzMiwxNCBAQCBl
eHRlcm4gdm9pZCBlZmlfbWFwX3BhbF9jb2RlICh2b2lkKTsNCiBleHRlcm4gdm9pZCBlZmlfbWVt
bWFwX3dhbGsgKGVmaV9mcmVlbWVtX2NhbGxiYWNrX3QgY2FsbGJhY2ssIHZvaWQgKmFyZyk7DQog
ZXh0ZXJuIHZvaWQgZWZpX2dldHRpbWVvZmRheSAoc3RydWN0IHRpbWVzcGVjICp0cyk7DQogZXh0
ZXJuIHZvaWQgZWZpX2VudGVyX3ZpcnR1YWxfbW9kZSAodm9pZCk7CS8qIHN3aXRjaCBFRkkgdG8g
dmlydHVhbCBtb2RlLCBpZiBwb3NzaWJsZSAqLw0KKyNpZmRlZiBDT05GSUdfWDg2DQorZXh0ZXJu
IGVmaV9zdGF0dXNfdCBlZmlfcXVlcnlfdmFyaWFibGVfc3RvcmUodTMyIGF0dHJpYnV0ZXMsIHVu
c2lnbmVkIGxvbmcgc2l6ZSk7DQorI2Vsc2UNCitzdGF0aWMgaW5saW5lIGVmaV9zdGF0dXNfdCBl
ZmlfcXVlcnlfdmFyaWFibGVfc3RvcmUodTMyIGF0dHJpYnV0ZXMsIHVuc2lnbmVkIGxvbmcgc2l6
ZSkNCit7DQorCXJldHVybiBFRklfU1VDQ0VTUzsNCit9DQorI2VuZGlmDQogZXh0ZXJuIHU2NCBl
ZmlfZ2V0X2lvYmFzZSAodm9pZCk7DQogZXh0ZXJuIHUzMiBlZmlfbWVtX3R5cGUgKHVuc2lnbmVk
IGxvbmcgcGh5c19hZGRyKTsNCiBleHRlcm4gdTY0IGVmaV9tZW1fYXR0cmlidXRlcyAodW5zaWdu
ZWQgbG9uZyBwaHlzX2FkZHIpOw0KQEAgLTQ3NSw3ICs0ODQsNyBAQCBzdHJ1Y3QgZWZpdmFyX29w
ZXJhdGlvbnMgew0KIAllZmlfZ2V0X3ZhcmlhYmxlX3QgKmdldF92YXJpYWJsZTsNCiAJZWZpX2dl
dF9uZXh0X3ZhcmlhYmxlX3QgKmdldF9uZXh0X3ZhcmlhYmxlOw0KIAllZmlfc2V0X3ZhcmlhYmxl
X3QgKnNldF92YXJpYWJsZTsNCi0JZWZpX3F1ZXJ5X3ZhcmlhYmxlX2luZm9fdCAqcXVlcnlfdmFy
aWFibGVfaW5mbzsNCisJZWZpX3F1ZXJ5X3ZhcmlhYmxlX3N0b3JlX3QgKnF1ZXJ5X3ZhcmlhYmxl
X3N0b3JlOw0KIH07DQogDQogc3RydWN0IGVmaXZhcnMgew0KZGlmZiAtLWdpdCBhL2luY2x1ZGUv
bGludXgvaWZfY2FibGVtb2RlbS5oIGIvaW5jbHVkZS9saW51eC9pZl9jYWJsZW1vZGVtLmgNCmlu
ZGV4IDljYTEwMDcuLmVlNmIzYzQgMTAwNjQ0DQotLS0gYS9pbmNsdWRlL2xpbnV4L2lmX2NhYmxl
bW9kZW0uaA0KKysrIGIvaW5jbHVkZS9saW51eC9pZl9jYWJsZW1vZGVtLmgNCkBAIC0xMiwxMSAr
MTIsMTEgQEANCiAgKi8NCiANCiAvKiBzb21lIHVzZWZ1bCBkZWZpbmVzIGZvciBzYjEwMDAuYyBl
IGNtY29uZmlnLmMgLSBmdiAqLw0KLSNkZWZpbmUgU0lPQ0dDTVNUQVRTCQlTSU9DREVWUFJJVkFU
RSswCS8qIGdldCBjYWJsZSBtb2RlbSBzdGF0cyAqLw0KLSNkZWZpbmUgU0lPQ0dDTUZJUk1XQVJF
CQlTSU9DREVWUFJJVkFURSsxCS8qIGdldCBjbSBmaXJtd2FyZSB2ZXJzaW9uICovDQotI2RlZmlu
ZSBTSU9DR0NNRlJFUVVFTkNZCVNJT0NERVZQUklWQVRFKzIJLyogZ2V0IGNhYmxlIG1vZGVtIGZy
ZXF1ZW5jeSAqLw0KLSNkZWZpbmUgU0lPQ1NDTUZSRVFVRU5DWQlTSU9DREVWUFJJVkFURSszCS8q
IHNldCBjYWJsZSBtb2RlbSBmcmVxdWVuY3kgKi8NCi0jZGVmaW5lIFNJT0NHQ01QSURTCQkJU0lP
Q0RFVlBSSVZBVEUrNAkvKiBnZXQgY2FibGUgbW9kZW0gUElEcyAqLw0KLSNkZWZpbmUgU0lPQ1ND
TVBJRFMJCQlTSU9DREVWUFJJVkFURSs1CS8qIHNldCBjYWJsZSBtb2RlbSBQSURzICovDQorI2Rl
ZmluZSBTSU9DR0NNU1RBVFMJCShTSU9DREVWUFJJVkFURSswKQkvKiBnZXQgY2FibGUgbW9kZW0g
c3RhdHMgKi8NCisjZGVmaW5lIFNJT0NHQ01GSVJNV0FSRQkJKFNJT0NERVZQUklWQVRFKzEpCS8q
IGdldCBjbSBmaXJtd2FyZSB2ZXJzaW9uICovDQorI2RlZmluZSBTSU9DR0NNRlJFUVVFTkNZCShT
SU9DREVWUFJJVkFURSsyKQkvKiBnZXQgY2FibGUgbW9kZW0gZnJlcXVlbmN5ICovDQorI2RlZmlu
ZSBTSU9DU0NNRlJFUVVFTkNZCShTSU9DREVWUFJJVkFURSszKQkvKiBzZXQgY2FibGUgbW9kZW0g
ZnJlcXVlbmN5ICovDQorI2RlZmluZSBTSU9DR0NNUElEUwkJCShTSU9DREVWUFJJVkFURSs0KQkv
KiBnZXQgY2FibGUgbW9kZW0gUElEcyAqLw0KKyNkZWZpbmUgU0lPQ1NDTVBJRFMJCQkoU0lPQ0RF
VlBSSVZBVEUrNSkJLyogc2V0IGNhYmxlIG1vZGVtIFBJRHMgKi8NCiANCiAjZW5kaWYNCmRpZmYg
LS1naXQgYS9pbmNsdWRlL2xpbnV4L3JjdWxpc3QuaCBiL2luY2x1ZGUvbGludXgvcmN1bGlzdC5o
DQppbmRleCBkMDc5MjkwLi42Zjk1ZTI0IDEwMDY0NA0KLS0tIGEvaW5jbHVkZS9saW51eC9yY3Vs
aXN0LmgNCisrKyBiL2luY2x1ZGUvbGludXgvcmN1bGlzdC5oDQpAQCAtMjQyLDYgKzI0MiwyMyBA
QCBzdGF0aWMgaW5saW5lIHZvaWQgbGlzdF9zcGxpY2VfaW5pdF9yY3Uoc3RydWN0IGxpc3RfaGVh
ZCAqbGlzdCwNCiAJbGlzdF9lbnRyeV9yY3UoKHB0ciktPm5leHQsIHR5cGUsIG1lbWJlcikNCiAN
CiAvKioNCisgKiBsaXN0X2ZpcnN0X29yX251bGxfcmN1IC0gZ2V0IHRoZSBmaXJzdCBlbGVtZW50
IGZyb20gYSBsaXN0DQorICogQHB0cjogICAgICAgIHRoZSBsaXN0IGhlYWQgdG8gdGFrZSB0aGUg
ZWxlbWVudCBmcm9tLg0KKyAqIEB0eXBlOiAgICAgICB0aGUgdHlwZSBvZiB0aGUgc3RydWN0IHRo
aXMgaXMgZW1iZWRkZWQgaW4uDQorICogQG1lbWJlcjogICAgIHRoZSBuYW1lIG9mIHRoZSBsaXN0
X3N0cnVjdCB3aXRoaW4gdGhlIHN0cnVjdC4NCisgKg0KKyAqIE5vdGUgdGhhdCBpZiB0aGUgbGlz
dCBpcyBlbXB0eSwgaXQgcmV0dXJucyBOVUxMLg0KKyAqDQorICogVGhpcyBwcmltaXRpdmUgbWF5
IHNhZmVseSBydW4gY29uY3VycmVudGx5IHdpdGggdGhlIF9yY3UgbGlzdC1tdXRhdGlvbg0KKyAq
IHByaW1pdGl2ZXMgc3VjaCBhcyBsaXN0X2FkZF9yY3UoKSBhcyBsb25nIGFzIGl0J3MgZ3VhcmRl
ZCBieSByY3VfcmVhZF9sb2NrKCkuDQorICovDQorI2RlZmluZSBsaXN0X2ZpcnN0X29yX251bGxf
cmN1KHB0ciwgdHlwZSwgbWVtYmVyKSBcDQorCSh7c3RydWN0IGxpc3RfaGVhZCAqX19wdHIgPSAo
cHRyKTsgXA0KKwkgIHN0cnVjdCBsaXN0X2hlYWQgX19yY3UgKl9fbmV4dCA9IGxpc3RfbmV4dF9y
Y3UoX19wdHIpOyBcDQorCSAgbGlrZWx5KF9fcHRyICE9IF9fbmV4dCkgPyBjb250YWluZXJfb2Yo
X19uZXh0LCB0eXBlLCBtZW1iZXIpIDogTlVMTDsgXA0KKwl9KQ0KKw0KKy8qKg0KICAqIGxpc3Rf
Zm9yX2VhY2hfZW50cnlfcmN1CS0JaXRlcmF0ZSBvdmVyIHJjdSBsaXN0IG9mIGdpdmVuIHR5cGUN
CiAgKiBAcG9zOgl0aGUgdHlwZSAqIHRvIHVzZSBhcyBhIGxvb3AgY3Vyc29yLg0KICAqIEBoZWFk
Ogl0aGUgaGVhZCBmb3IgeW91ciBsaXN0Lg0KZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgvdmly
dGlvX2NvbnNvbGUuaCBiL2luY2x1ZGUvbGludXgvdmlydGlvX2NvbnNvbGUuaA0KaW5kZXggYmRm
NGIwMC4uODJlMTJhZCAxMDA2NDQNCi0tLSBhL2luY2x1ZGUvbGludXgvdmlydGlvX2NvbnNvbGUu
aA0KKysrIGIvaW5jbHVkZS9saW51eC92aXJ0aW9fY29uc29sZS5oDQpAQCAtMzksNyArMzksNyBA
QA0KICNkZWZpbmUgVklSVElPX0NPTlNPTEVfRl9TSVpFCTAJLyogRG9lcyBob3N0IHByb3ZpZGUg
Y29uc29sZSBzaXplPyAqLw0KICNkZWZpbmUgVklSVElPX0NPTlNPTEVfRl9NVUxUSVBPUlQgMQkv
KiBEb2VzIGhvc3QgcHJvdmlkZSBtdWx0aXBsZSBwb3J0cz8gKi8NCiANCi0jZGVmaW5lIFZJUlRJ
T19DT05TT0xFX0JBRF9JRAkJKH4odTMyKTApDQorI2RlZmluZSBWSVJUSU9fQ09OU09MRV9CQURf
SUQJCSh+KF9fdTMyKTApDQogDQogc3RydWN0IHZpcnRpb19jb25zb2xlX2NvbmZpZyB7DQogCS8q
IGNvbHVtcyBvZiB0aGUgc2NyZWVucyAqLw0KZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgvd2Fp
dC5oIGIvaW5jbHVkZS9saW51eC93YWl0LmgNCmluZGV4IDNlZmM5ZjMuLmJlYTdhZDUgMTAwNjQ0
DQotLS0gYS9pbmNsdWRlL2xpbnV4L3dhaXQuaA0KKysrIGIvaW5jbHVkZS9saW51eC93YWl0LmgN
CkBAIC0yMzMsNiArMjMzLDggQEAgZG8gewkJCQkJCQkJCVwNCiAJCWlmICghcmV0KQkJCQkJCVwN
CiAJCQlicmVhazsJCQkJCQlcDQogCX0JCQkJCQkJCVwNCisJaWYgKCFyZXQgJiYgKGNvbmRpdGlv
bikpCQkJCQlcDQorCQlyZXQgPSAxOwkJCQkJCVwNCiAJZmluaXNoX3dhaXQoJndxLCAmX193YWl0
KTsJCQkJCVwNCiB9IHdoaWxlICgwKQ0KIA0KQEAgLTI0OSw4ICsyNTEsOSBAQCBkbyB7CQkJCQkJ
CQkJXA0KICAqIHdha2VfdXAoKSBoYXMgdG8gYmUgY2FsbGVkIGFmdGVyIGNoYW5naW5nIGFueSB2
YXJpYWJsZSB0aGF0IGNvdWxkDQogICogY2hhbmdlIHRoZSByZXN1bHQgb2YgdGhlIHdhaXQgY29u
ZGl0aW9uLg0KICAqDQotICogVGhlIGZ1bmN0aW9uIHJldHVybnMgMCBpZiB0aGUgQHRpbWVvdXQg
ZWxhcHNlZCwgYW5kIHRoZSByZW1haW5pbmcNCi0gKiBqaWZmaWVzIGlmIHRoZSBjb25kaXRpb24g
ZXZhbHVhdGVkIHRvIHRydWUgYmVmb3JlIHRoZSB0aW1lb3V0IGVsYXBzZWQuDQorICogVGhlIGZ1
bmN0aW9uIHJldHVybnMgMCBpZiB0aGUgQHRpbWVvdXQgZWxhcHNlZCwgb3IgdGhlIHJlbWFpbmlu
Zw0KKyAqIGppZmZpZXMgKGF0IGxlYXN0IDEpIGlmIHRoZSBAY29uZGl0aW9uIGV2YWx1YXRlZCB0
byAldHJ1ZSBiZWZvcmUNCisgKiB0aGUgQHRpbWVvdXQgZWxhcHNlZC4NCiAgKi8NCiAjZGVmaW5l
IHdhaXRfZXZlbnRfdGltZW91dCh3cSwgY29uZGl0aW9uLCB0aW1lb3V0KQkJCVwNCiAoewkJCQkJ
CQkJCVwNCkBAIC0zMTgsNiArMzIxLDggQEAgZG8gewkJCQkJCQkJCVwNCiAJCXJldCA9IC1FUkVT
VEFSVFNZUzsJCQkJCVwNCiAJCWJyZWFrOwkJCQkJCQlcDQogCX0JCQkJCQkJCVwNCisJaWYgKCFy
ZXQgJiYgKGNvbmRpdGlvbikpCQkJCQlcDQorCQlyZXQgPSAxOwkJCQkJCVwNCiAJZmluaXNoX3dh
aXQoJndxLCAmX193YWl0KTsJCQkJCVwNCiB9IHdoaWxlICgwKQ0KIA0KQEAgLTMzNCw5ICszMzks
MTAgQEAgZG8gewkJCQkJCQkJCVwNCiAgKiB3YWtlX3VwKCkgaGFzIHRvIGJlIGNhbGxlZCBhZnRl
ciBjaGFuZ2luZyBhbnkgdmFyaWFibGUgdGhhdCBjb3VsZA0KICAqIGNoYW5nZSB0aGUgcmVzdWx0
IG9mIHRoZSB3YWl0IGNvbmRpdGlvbi4NCiAgKg0KLSAqIFRoZSBmdW5jdGlvbiByZXR1cm5zIDAg
aWYgdGhlIEB0aW1lb3V0IGVsYXBzZWQsIC1FUkVTVEFSVFNZUyBpZiBpdA0KLSAqIHdhcyBpbnRl
cnJ1cHRlZCBieSBhIHNpZ25hbCwgYW5kIHRoZSByZW1haW5pbmcgamlmZmllcyBvdGhlcndpc2UN
Ci0gKiBpZiB0aGUgY29uZGl0aW9uIGV2YWx1YXRlZCB0byB0cnVlIGJlZm9yZSB0aGUgdGltZW91
dCBlbGFwc2VkLg0KKyAqIFJldHVybnM6DQorICogMCBpZiB0aGUgQHRpbWVvdXQgZWxhcHNlZCwg
LSVFUkVTVEFSVFNZUyBpZiBpdCB3YXMgaW50ZXJydXB0ZWQgYnkNCisgKiBhIHNpZ25hbCwgb3Ig
dGhlIHJlbWFpbmluZyBqaWZmaWVzIChhdCBsZWFzdCAxKSBpZiB0aGUgQGNvbmRpdGlvbg0KKyAq
IGV2YWx1YXRlZCB0byAldHJ1ZSBiZWZvcmUgdGhlIEB0aW1lb3V0IGVsYXBzZWQuDQogICovDQog
I2RlZmluZSB3YWl0X2V2ZW50X2ludGVycnVwdGlibGVfdGltZW91dCh3cSwgY29uZGl0aW9uLCB0
aW1lb3V0KQlcDQogKHsJCQkJCQkJCQlcDQpkaWZmIC0tZ2l0IGEvaW5jbHVkZS9uZXQvc29jay5o
IGIvaW5jbHVkZS9uZXQvc29jay5oDQppbmRleCBkZGY1MjNjLi5lNjQ1NGI2IDEwMDY0NA0KLS0t
IGEvaW5jbHVkZS9uZXQvc29jay5oDQorKysgYi9pbmNsdWRlL25ldC9zb2NrLmgNCkBAIC03MzQs
NiArNzM0LDE4IEBAIHN0cnVjdCBpbmV0X2hhc2hpbmZvOw0KIHN0cnVjdCByYXdfaGFzaGluZm87
DQogc3RydWN0IG1vZHVsZTsNCiANCisvKg0KKyAqIGNhY2hlcyB1c2luZyBTTEFCX0RFU1RST1lf
QllfUkNVIHNob3VsZCBsZXQgLm5leHQgcG9pbnRlciBmcm9tIG51bGxzIG5vZGVzDQorICogdW4t
bW9kaWZpZWQuIFNwZWNpYWwgY2FyZSBpcyB0YWtlbiB3aGVuIGluaXRpYWxpemluZyBvYmplY3Qg
dG8gemVyby4NCisgKi8NCitzdGF0aWMgaW5saW5lIHZvaWQgc2tfcHJvdF9jbGVhcl9udWxscyhz
dHJ1Y3Qgc29jayAqc2ssIGludCBzaXplKQ0KK3sNCisJaWYgKG9mZnNldG9mKHN0cnVjdCBzb2Nr
LCBza19ub2RlLm5leHQpICE9IDApDQorCQltZW1zZXQoc2ssIDAsIG9mZnNldG9mKHN0cnVjdCBz
b2NrLCBza19ub2RlLm5leHQpKTsNCisJbWVtc2V0KCZzay0+c2tfbm9kZS5wcHJldiwgMCwNCisJ
ICAgICAgIHNpemUgLSBvZmZzZXRvZihzdHJ1Y3Qgc29jaywgc2tfbm9kZS5wcHJldikpOw0KK30N
CisNCiAvKiBOZXR3b3JraW5nIHByb3RvY29sIGJsb2NrcyB3ZSBhdHRhY2ggdG8gc29ja2V0cy4N
CiAgKiBzb2NrZXQgbGF5ZXIgLT4gdHJhbnNwb3J0IGxheWVyIGludGVyZmFjZQ0KICAqIHRyYW5z
cG9ydCAtPiBuZXR3b3JrIGludGVyZmFjZSBpcyBkZWZpbmVkIGJ5IHN0cnVjdCBpbmV0X3Byb3Rv
DQpkaWZmIC0tZ2l0IGEvaW5jbHVkZS9uZXQvdGNwLmggYi9pbmNsdWRlL25ldC90Y3AuaA0KaW5k
ZXggMDc2ODcxNS4uZmU0NjAxOSAxMDA2NDQNCi0tLSBhL2luY2x1ZGUvbmV0L3RjcC5oDQorKysg
Yi9pbmNsdWRlL25ldC90Y3AuaA0KQEAgLTkzMSw2ICs5MzEsNyBAQCBzdGF0aWMgaW5saW5lIGlu
dCB0Y3BfcHJlcXVldWUoc3RydWN0IHNvY2sgKnNrLCBzdHJ1Y3Qgc2tfYnVmZiAqc2tiKQ0KIAlp
ZiAoc3lzY3RsX3RjcF9sb3dfbGF0ZW5jeSB8fCAhdHAtPnVjb3B5LnRhc2spDQogCQlyZXR1cm4g
MDsNCiANCisJc2tiX2RzdF9mb3JjZShza2IpOw0KIAlfX3NrYl9xdWV1ZV90YWlsKCZ0cC0+dWNv
cHkucHJlcXVldWUsIHNrYik7DQogCXRwLT51Y29weS5tZW1vcnkgKz0gc2tiLT50cnVlc2l6ZTsN
CiAJaWYgKHRwLT51Y29weS5tZW1vcnkgPiBzay0+c2tfcmN2YnVmKSB7DQpkaWZmIC0tZ2l0IGEv
a2VybmVsL2ttb2QuYyBiL2tlcm5lbC9rbW9kLmMNCmluZGV4IGQ2ZmUwOGEuLmExNmRhYzEgMTAw
NjQ0DQotLS0gYS9rZXJuZWwva21vZC5jDQorKysgYi9rZXJuZWwva21vZC5jDQpAQCAtNDY3LDYg
KzQ2NywxMSBAQCBpbnQgY2FsbF91c2VybW9kZWhlbHBlcl9leGVjKHN0cnVjdCBzdWJwcm9jZXNz
X2luZm8gKnN1Yl9pbmZvLA0KIAlpbnQgcmV0dmFsID0gMDsNCiANCiAJaGVscGVyX2xvY2soKTsN
CisJaWYgKCFzdWJfaW5mby0+cGF0aCkgew0KKwkJcmV0dmFsID0gLUVJTlZBTDsNCisJCWdvdG8g
b3V0Ow0KKwl9DQorDQogCWlmIChzdWJfaW5mby0+cGF0aFswXSA9PSAnXDAnKQ0KIAkJZ290byBv
dXQ7DQogDQpkaWZmIC0tZ2l0IGEva2VybmVsL3NjaGVkLmMgYi9rZXJuZWwvc2NoZWQuYw0KaW5k
ZXggZDA4YzlmNC4uZDkzMzY5YSAxMDA2NDQNCi0tLSBhL2tlcm5lbC9zY2hlZC5jDQorKysgYi9r
ZXJuZWwvc2NoZWQuYw0KQEAgLTY2NzIsMTYgKzY2NzIsMjUgQEAgc3RhdGljIHZvaWQgc2RfZnJl
ZV9jdGxfZW50cnkoc3RydWN0IGN0bF90YWJsZSAqKnRhYmxlcCkNCiAJKnRhYmxlcCA9IE5VTEw7
DQogfQ0KIA0KK3N0YXRpYyBpbnQgbWluX2xvYWRfaWR4ID0gMDsNCitzdGF0aWMgaW50IG1heF9s
b2FkX2lkeCA9IENQVV9MT0FEX0lEWF9NQVgtMTsNCisNCiBzdGF0aWMgdm9pZA0KIHNldF90YWJs
ZV9lbnRyeShzdHJ1Y3QgY3RsX3RhYmxlICplbnRyeSwNCiAJCWNvbnN0IGNoYXIgKnByb2NuYW1l
LCB2b2lkICpkYXRhLCBpbnQgbWF4bGVuLA0KLQkJbW9kZV90IG1vZGUsIHByb2NfaGFuZGxlciAq
cHJvY19oYW5kbGVyKQ0KKwkJbW9kZV90IG1vZGUsIHByb2NfaGFuZGxlciAqcHJvY19oYW5kbGVy
LA0KKwkJYm9vbCBsb2FkX2lkeCkNCiB7DQogCWVudHJ5LT5wcm9jbmFtZSA9IHByb2NuYW1lOw0K
IAllbnRyeS0+ZGF0YSA9IGRhdGE7DQogCWVudHJ5LT5tYXhsZW4gPSBtYXhsZW47DQogCWVudHJ5
LT5tb2RlID0gbW9kZTsNCiAJZW50cnktPnByb2NfaGFuZGxlciA9IHByb2NfaGFuZGxlcjsNCisN
CisJaWYgKGxvYWRfaWR4KSB7DQorCQllbnRyeS0+ZXh0cmExID0gJm1pbl9sb2FkX2lkeDsNCisJ
CWVudHJ5LT5leHRyYTIgPSAmbWF4X2xvYWRfaWR4Ow0KKwl9DQogfQ0KIA0KIHN0YXRpYyBzdHJ1
Y3QgY3RsX3RhYmxlICoNCkBAIC02NjkzLDMwICs2NzAyLDMwIEBAIHNkX2FsbG9jX2N0bF9kb21h
aW5fdGFibGUoc3RydWN0IHNjaGVkX2RvbWFpbiAqc2QpDQogCQlyZXR1cm4gTlVMTDsNCiANCiAJ
c2V0X3RhYmxlX2VudHJ5KCZ0YWJsZVswXSwgIm1pbl9pbnRlcnZhbCIsICZzZC0+bWluX2ludGVy
dmFsLA0KLQkJc2l6ZW9mKGxvbmcpLCAwNjQ0LCBwcm9jX2RvdWxvbmd2ZWNfbWlubWF4KTsNCisJ
CXNpemVvZihsb25nKSwgMDY0NCwgcHJvY19kb3Vsb25ndmVjX21pbm1heCwgZmFsc2UpOw0KIAlz
ZXRfdGFibGVfZW50cnkoJnRhYmxlWzFdLCAibWF4X2ludGVydmFsIiwgJnNkLT5tYXhfaW50ZXJ2
YWwsDQotCQlzaXplb2YobG9uZyksIDA2NDQsIHByb2NfZG91bG9uZ3ZlY19taW5tYXgpOw0KKwkJ
c2l6ZW9mKGxvbmcpLCAwNjQ0LCBwcm9jX2RvdWxvbmd2ZWNfbWlubWF4LCBmYWxzZSk7DQogCXNl
dF90YWJsZV9lbnRyeSgmdGFibGVbMl0sICJidXN5X2lkeCIsICZzZC0+YnVzeV9pZHgsDQotCQlz
aXplb2YoaW50KSwgMDY0NCwgcHJvY19kb2ludHZlY19taW5tYXgpOw0KKwkJc2l6ZW9mKGludCks
IDA2NDQsIHByb2NfZG9pbnR2ZWNfbWlubWF4LCB0cnVlKTsNCiAJc2V0X3RhYmxlX2VudHJ5KCZ0
YWJsZVszXSwgImlkbGVfaWR4IiwgJnNkLT5pZGxlX2lkeCwNCi0JCXNpemVvZihpbnQpLCAwNjQ0
LCBwcm9jX2RvaW50dmVjX21pbm1heCk7DQorCQlzaXplb2YoaW50KSwgMDY0NCwgcHJvY19kb2lu
dHZlY19taW5tYXgsIHRydWUpOw0KIAlzZXRfdGFibGVfZW50cnkoJnRhYmxlWzRdLCAibmV3aWRs
ZV9pZHgiLCAmc2QtPm5ld2lkbGVfaWR4LA0KLQkJc2l6ZW9mKGludCksIDA2NDQsIHByb2NfZG9p
bnR2ZWNfbWlubWF4KTsNCisJCXNpemVvZihpbnQpLCAwNjQ0LCBwcm9jX2RvaW50dmVjX21pbm1h
eCwgdHJ1ZSk7DQogCXNldF90YWJsZV9lbnRyeSgmdGFibGVbNV0sICJ3YWtlX2lkeCIsICZzZC0+
d2FrZV9pZHgsDQotCQlzaXplb2YoaW50KSwgMDY0NCwgcHJvY19kb2ludHZlY19taW5tYXgpOw0K
KwkJc2l6ZW9mKGludCksIDA2NDQsIHByb2NfZG9pbnR2ZWNfbWlubWF4LCB0cnVlKTsNCiAJc2V0
X3RhYmxlX2VudHJ5KCZ0YWJsZVs2XSwgImZvcmtleGVjX2lkeCIsICZzZC0+Zm9ya2V4ZWNfaWR4
LA0KLQkJc2l6ZW9mKGludCksIDA2NDQsIHByb2NfZG9pbnR2ZWNfbWlubWF4KTsNCisJCXNpemVv
ZihpbnQpLCAwNjQ0LCBwcm9jX2RvaW50dmVjX21pbm1heCwgdHJ1ZSk7DQogCXNldF90YWJsZV9l
bnRyeSgmdGFibGVbN10sICJidXN5X2ZhY3RvciIsICZzZC0+YnVzeV9mYWN0b3IsDQotCQlzaXpl
b2YoaW50KSwgMDY0NCwgcHJvY19kb2ludHZlY19taW5tYXgpOw0KKwkJc2l6ZW9mKGludCksIDA2
NDQsIHByb2NfZG9pbnR2ZWNfbWlubWF4LCBmYWxzZSk7DQogCXNldF90YWJsZV9lbnRyeSgmdGFi
bGVbOF0sICJpbWJhbGFuY2VfcGN0IiwgJnNkLT5pbWJhbGFuY2VfcGN0LA0KLQkJc2l6ZW9mKGlu
dCksIDA2NDQsIHByb2NfZG9pbnR2ZWNfbWlubWF4KTsNCisJCXNpemVvZihpbnQpLCAwNjQ0LCBw
cm9jX2RvaW50dmVjX21pbm1heCwgZmFsc2UpOw0KIAlzZXRfdGFibGVfZW50cnkoJnRhYmxlWzld
LCAiY2FjaGVfbmljZV90cmllcyIsDQogCQkmc2QtPmNhY2hlX25pY2VfdHJpZXMsDQotCQlzaXpl
b2YoaW50KSwgMDY0NCwgcHJvY19kb2ludHZlY19taW5tYXgpOw0KKwkJc2l6ZW9mKGludCksIDA2
NDQsIHByb2NfZG9pbnR2ZWNfbWlubWF4LCBmYWxzZSk7DQogCXNldF90YWJsZV9lbnRyeSgmdGFi
bGVbMTBdLCAiZmxhZ3MiLCAmc2QtPmZsYWdzLA0KLQkJc2l6ZW9mKGludCksIDA2NDQsIHByb2Nf
ZG9pbnR2ZWNfbWlubWF4KTsNCisJCXNpemVvZihpbnQpLCAwNjQ0LCBwcm9jX2RvaW50dmVjX21p
bm1heCwgZmFsc2UpOw0KIAlzZXRfdGFibGVfZW50cnkoJnRhYmxlWzExXSwgIm5hbWUiLCBzZC0+
bmFtZSwNCi0JCUNPUkVOQU1FX01BWF9TSVpFLCAwNDQ0LCBwcm9jX2Rvc3RyaW5nKTsNCisJCUNP
UkVOQU1FX01BWF9TSVpFLCAwNDQ0LCBwcm9jX2Rvc3RyaW5nLCBmYWxzZSk7DQogCS8qICZ0YWJs
ZVsxMl0gaXMgdGVybWluYXRvciAqLw0KIA0KIAlyZXR1cm4gdGFibGU7DQpkaWZmIC0tZ2l0IGEv
a2VybmVsL3RpbWUvdGljay1zY2hlZC5jIGIva2VybmVsL3RpbWUvdGljay1zY2hlZC5jDQppbmRl
eCA3OTM1NDhjLi5lOWE0NWYxIDEwMDY0NA0KLS0tIGEva2VybmVsL3RpbWUvdGljay1zY2hlZC5j
DQorKysgYi9rZXJuZWwvdGltZS90aWNrLXNjaGVkLmMNCkBAIC04MzMsNyArODMzLDcgQEAgdm9p
ZCB0aWNrX2NhbmNlbF9zY2hlZF90aW1lcihpbnQgY3B1KQ0KIAkJaHJ0aW1lcl9jYW5jZWwoJnRz
LT5zY2hlZF90aW1lcik7DQogIyBlbmRpZg0KIA0KLQl0cy0+bm9oel9tb2RlID0gTk9IWl9NT0RF
X0lOQUNUSVZFOw0KKwltZW1zZXQodHMsIDAsIHNpemVvZigqdHMpKTsNCiB9DQogI2VuZGlmDQog
DQpkaWZmIC0tZ2l0IGEva2VybmVsL3RpbWVyLmMgYi9rZXJuZWwvdGltZXIuYw0KaW5kZXggYzIx
OWRiNi4uZjJmNzFkNyAxMDA2NDQNCi0tLSBhL2tlcm5lbC90aW1lci5jDQorKysgYi9rZXJuZWwv
dGltZXIuYw0KQEAgLTE2MzAsMTIgKzE2MzAsMTIgQEAgc3RhdGljIGludCBfX2NwdWluaXQgaW5p
dF90aW1lcnNfY3B1KGludCBjcHUpDQogCQkJYm9vdF9kb25lID0gMTsNCiAJCQliYXNlID0gJmJv
b3RfdHZlY19iYXNlczsNCiAJCX0NCisJCXNwaW5fbG9ja19pbml0KCZiYXNlLT5sb2NrKTsNCiAJ
CXR2ZWNfYmFzZV9kb25lW2NwdV0gPSAxOw0KIAl9IGVsc2Ugew0KIAkJYmFzZSA9IHBlcl9jcHUo
dHZlY19iYXNlcywgY3B1KTsNCiAJfQ0KIA0KLQlzcGluX2xvY2tfaW5pdCgmYmFzZS0+bG9jayk7
DQogDQogCWZvciAoaiA9IDA7IGogPCBUVk5fU0laRTsgaisrKSB7DQogCQlJTklUX0xJU1RfSEVB
RChiYXNlLT50djUudmVjICsgaik7DQpkaWZmIC0tZ2l0IGEva2VybmVsL3RyYWNlL3RyYWNlX2V2
ZW50c19maWx0ZXIuYyBiL2tlcm5lbC90cmFjZS90cmFjZV9ldmVudHNfZmlsdGVyLmMNCmluZGV4
IDk1ZGMzMWUuLmIwOTk2YzEgMTAwNjQ0DQotLS0gYS9rZXJuZWwvdHJhY2UvdHJhY2VfZXZlbnRz
X2ZpbHRlci5jDQorKysgYi9rZXJuZWwvdHJhY2UvdHJhY2VfZXZlbnRzX2ZpbHRlci5jDQpAQCAt
NzY5LDcgKzc2OSwxMSBAQCBzdGF0aWMgaW50IGZpbHRlcl9zZXRfcHJlZChzdHJ1Y3QgZXZlbnRf
ZmlsdGVyICpmaWx0ZXIsDQogDQogc3RhdGljIHZvaWQgX19mcmVlX3ByZWRzKHN0cnVjdCBldmVu
dF9maWx0ZXIgKmZpbHRlcikNCiB7DQorCWludCBpOw0KKw0KIAlpZiAoZmlsdGVyLT5wcmVkcykg
ew0KKwkJZm9yIChpID0gMDsgaSA8IGZpbHRlci0+bl9wcmVkczsgaSsrKQ0KKwkJCWtmcmVlKGZp
bHRlci0+cHJlZHNbaV0ub3BzKTsNCiAJCWtmcmVlKGZpbHRlci0+cHJlZHMpOw0KIAkJZmlsdGVy
LT5wcmVkcyA9IE5VTEw7DQogCX0NCmRpZmYgLS1naXQgYS9tbS9odWdlX21lbW9yeS5jIGIvbW0v
aHVnZV9tZW1vcnkuYw0KaW5kZXggNDcwY2JiNC4uZDgwYWM0YiAxMDA2NDQNCi0tLSBhL21tL2h1
Z2VfbWVtb3J5LmMNCisrKyBiL21tL2h1Z2VfbWVtb3J5LmMNCkBAIC0xOTM3LDcgKzE5MzcsMTIg
QEAgc3RhdGljIHZvaWQgY29sbGFwc2VfaHVnZV9wYWdlKHN0cnVjdCBtbV9zdHJ1Y3QgKm1tLA0K
IAkJcHRlX3VubWFwKHB0ZSk7DQogCQlzcGluX2xvY2soJm1tLT5wYWdlX3RhYmxlX2xvY2spOw0K
IAkJQlVHX09OKCFwbWRfbm9uZSgqcG1kKSk7DQotCQlzZXRfcG1kX2F0KG1tLCBhZGRyZXNzLCBw
bWQsIF9wbWQpOw0KKwkJLyoNCisJCSAqIFdlIGNhbiBvbmx5IHVzZSBzZXRfcG1kX2F0IHdoZW4g
ZXN0YWJsaXNoaW5nDQorCQkgKiBodWdlcG1kcyBhbmQgbmV2ZXIgZm9yIGVzdGFibGlzaGluZyBy
ZWd1bGFyIHBtZHMgdGhhdA0KKwkJICogcG9pbnRzIHRvIHJlZ3VsYXIgcGFnZXRhYmxlcy4gVXNl
IHBtZF9wb3B1bGF0ZSBmb3IgdGhhdA0KKwkJICovDQorCQlwbWRfcG9wdWxhdGUobW0sIHBtZCwg
cG1kX3BndGFibGUoX3BtZCkpOw0KIAkJc3Bpbl91bmxvY2soJm1tLT5wYWdlX3RhYmxlX2xvY2sp
Ow0KIAkJYW5vbl92bWFfdW5sb2NrKHZtYS0+YW5vbl92bWEpOw0KIAkJZ290byBvdXQ7DQpkaWZm
IC0tZ2l0IGEvbW0vbWlncmF0ZS5jIGIvbW0vbWlncmF0ZS5jDQppbmRleCAxODBkOTdmLi5lMTA1
MmQxIDEwMDY0NA0KLS0tIGEvbW0vbWlncmF0ZS5jDQorKysgYi9tbS9taWdyYXRlLmMNCkBAIC0x
NDcsNyArMTQ3LDcgQEAgc3RhdGljIGludCByZW1vdmVfbWlncmF0aW9uX3B0ZShzdHJ1Y3QgcGFn
ZSAqbmV3LCBzdHJ1Y3Qgdm1fYXJlYV9zdHJ1Y3QgKnZtYSwNCiAJaWYgKFBhZ2VIdWdlKG5ldykp
DQogCQlwdGUgPSBwdGVfbWtodWdlKHB0ZSk7DQogI2VuZGlmDQotCWZsdXNoX2NhY2hlX3BhZ2Uo
dm1hLCBhZGRyLCBwdGVfcGZuKHB0ZSkpOw0KKwlmbHVzaF9kY2FjaGVfcGFnZShuZXcpOw0KIAlz
ZXRfcHRlX2F0KG1tLCBhZGRyLCBwdGVwLCBwdGUpOw0KIA0KIAlpZiAoUGFnZUh1Z2UobmV3KSkg
ew0KZGlmZiAtLWdpdCBhL21tL21tdV9ub3RpZmllci5jIGIvbW0vbW11X25vdGlmaWVyLmMNCmlu
ZGV4IDhkMWNhMmQuLmExNjBlYzggMTAwNjQ0DQotLS0gYS9tbS9tbXVfbm90aWZpZXIuYw0KKysr
IGIvbW0vbW11X25vdGlmaWVyLmMNCkBAIC0zNyw1MSArMzcsNDggQEAgc3RhdGljIHN0cnVjdCBz
cmN1X3N0cnVjdCBzcmN1Ow0KIHZvaWQgX19tbXVfbm90aWZpZXJfcmVsZWFzZShzdHJ1Y3QgbW1f
c3RydWN0ICptbSkNCiB7DQogCXN0cnVjdCBtbXVfbm90aWZpZXIgKm1uOw0KKwlzdHJ1Y3QgaGxp
c3Rfbm9kZSAqbjsNCiAJaW50IGlkOw0KIA0KIAkvKg0KLQkgKiBzcmN1X3JlYWRfbG9jaygpIGhl
cmUgd2lsbCBibG9jayBzeW5jaHJvbml6ZV9zcmN1KCkgaW4NCi0JICogbW11X25vdGlmaWVyX3Vu
cmVnaXN0ZXIoKSB1bnRpbCBhbGwgcmVnaXN0ZXJlZA0KLQkgKiAtPnJlbGVhc2UoKSBjYWxsb3V0
cyB0aGlzIGZ1bmN0aW9uIG1ha2VzIGhhdmUNCi0JICogcmV0dXJuZWQuDQorCSAqIFNSQ1UgaGVy
ZSB3aWxsIGJsb2NrIG1tdV9ub3RpZmllcl91bnJlZ2lzdGVyIHVudGlsDQorCSAqIC0+cmVsZWFz
ZSByZXR1cm5zLg0KIAkgKi8NCiAJaWQgPSBzcmN1X3JlYWRfbG9jaygmc3JjdSk7DQorCWhsaXN0
X2Zvcl9lYWNoX2VudHJ5X3JjdShtbiwgbiwgJm1tLT5tbXVfbm90aWZpZXJfbW0tPmxpc3QsIGhs
aXN0KQ0KKwkJLyoNCisJCSAqIElmIC0+cmVsZWFzZSBydW5zIGJlZm9yZSBtbXVfbm90aWZpZXJf
dW5yZWdpc3RlciBpdCBtdXN0IGJlDQorCQkgKiBoYW5kbGVkLCBhcyBpdCdzIHRoZSBvbmx5IHdh
eSBmb3IgdGhlIGRyaXZlciB0byBmbHVzaCBhbGwNCisJCSAqIGV4aXN0aW5nIHNwdGVzIGFuZCBz
dG9wIHRoZSBkcml2ZXIgZnJvbSBlc3RhYmxpc2hpbmcgYW55IG1vcmUNCisJCSAqIHNwdGVzIGJl
Zm9yZSBhbGwgdGhlIHBhZ2VzIGluIHRoZSBtbSBhcmUgZnJlZWQuDQorCQkgKi8NCisJCWlmICht
bi0+b3BzLT5yZWxlYXNlKQ0KKwkJCW1uLT5vcHMtPnJlbGVhc2UobW4sIG1tKTsNCisJc3JjdV9y
ZWFkX3VubG9jaygmc3JjdSwgaWQpOw0KKw0KIAlzcGluX2xvY2soJm1tLT5tbXVfbm90aWZpZXJf
bW0tPmxvY2spOw0KIAl3aGlsZSAodW5saWtlbHkoIWhsaXN0X2VtcHR5KCZtbS0+bW11X25vdGlm
aWVyX21tLT5saXN0KSkpIHsNCiAJCW1uID0gaGxpc3RfZW50cnkobW0tPm1tdV9ub3RpZmllcl9t
bS0+bGlzdC5maXJzdCwNCiAJCQkJIHN0cnVjdCBtbXVfbm90aWZpZXIsDQogCQkJCSBobGlzdCk7
DQotDQogCQkvKg0KLQkJICogVW5saW5rLiAgVGhpcyB3aWxsIHByZXZlbnQgbW11X25vdGlmaWVy
X3VucmVnaXN0ZXIoKQ0KLQkJICogZnJvbSBhbHNvIG1ha2luZyB0aGUgLT5yZWxlYXNlKCkgY2Fs
bG91dC4NCisJCSAqIFdlIGFycml2ZWQgYmVmb3JlIG1tdV9ub3RpZmllcl91bnJlZ2lzdGVyIHNv
DQorCQkgKiBtbXVfbm90aWZpZXJfdW5yZWdpc3RlciB3aWxsIGRvIG5vdGhpbmcgb3RoZXIgdGhh
biB0byB3YWl0DQorCQkgKiBmb3IgLT5yZWxlYXNlIHRvIGZpbmlzaCBhbmQgZm9yIG1tdV9ub3Rp
Zmllcl91bnJlZ2lzdGVyIHRvDQorCQkgKiByZXR1cm4uDQogCQkgKi8NCiAJCWhsaXN0X2RlbF9p
bml0X3JjdSgmbW4tPmhsaXN0KTsNCi0JCXNwaW5fdW5sb2NrKCZtbS0+bW11X25vdGlmaWVyX21t
LT5sb2NrKTsNCi0NCi0JCS8qDQotCQkgKiBDbGVhciBzcHRlcy4gKHNlZSAncmVsZWFzZScgZGVz
Y3JpcHRpb24gaW4gbW11X25vdGlmaWVyLmgpDQotCQkgKi8NCi0JCWlmIChtbi0+b3BzLT5yZWxl
YXNlKQ0KLQkJCW1uLT5vcHMtPnJlbGVhc2UobW4sIG1tKTsNCi0NCi0JCXNwaW5fbG9jaygmbW0t
Pm1tdV9ub3RpZmllcl9tbS0+bG9jayk7DQogCX0NCiAJc3Bpbl91bmxvY2soJm1tLT5tbXVfbm90
aWZpZXJfbW0tPmxvY2spOw0KIA0KIAkvKg0KLQkgKiBBbGwgY2FsbG91dHMgdG8gLT5yZWxlYXNl
KCkgd2hpY2ggd2UgaGF2ZSBkb25lIGFyZSBjb21wbGV0ZS4NCi0JICogQWxsb3cgc3luY2hyb25p
emVfc3JjdSgpIGluIG1tdV9ub3RpZmllcl91bnJlZ2lzdGVyKCkgdG8gY29tcGxldGUNCi0JICov
DQotCXNyY3VfcmVhZF91bmxvY2soJnNyY3UsIGlkKTsNCi0NCi0JLyoNCi0JICogbW11X25vdGlm
aWVyX3VucmVnaXN0ZXIoKSBtYXkgaGF2ZSB1bmxpbmtlZCBhIG5vdGlmaWVyIGFuZCBtYXkNCi0J
ICogc3RpbGwgYmUgY2FsbGluZyBvdXQgdG8gaXQuCUFkZGl0aW9uYWxseSwgb3RoZXIgbm90aWZp
ZXJzDQotCSAqIG1heSBoYXZlIGJlZW4gYWN0aXZlIHZpYSB2bXRydW5jYXRlKCkgZXQuIGFsLiBC
bG9jayBoZXJlDQotCSAqIHRvIGVuc3VyZSB0aGF0IGFsbCBub3RpZmllciBjYWxsb3V0cyBmb3Ig
dGhpcyBtbSBoYXZlIGJlZW4NCi0JICogY29tcGxldGVkIGFuZCB0aGUgc3B0ZXMgYXJlIHJlYWxs
eSBjbGVhbmVkIHVwIGJlZm9yZSByZXR1cm5pbmcNCi0JICogdG8gZXhpdF9tbWFwKCkuDQorCSAq
IHN5bmNocm9uaXplX3NyY3UgaGVyZSBwcmV2ZW50cyBtbXVfbm90aWZpZXJfcmVsZWFzZSBmcm9t
IHJldHVybmluZyB0bw0KKwkgKiBleGl0X21tYXAgKHdoaWNoIHdvdWxkIHByb2NlZWQgd2l0aCBm
cmVlaW5nIGFsbCBwYWdlcyBpbiB0aGUgbW0pDQorCSAqIHVudGlsIHRoZSAtPnJlbGVhc2UgbWV0
aG9kIHJldHVybnMsIGlmIGl0IHdhcyBpbnZva2VkIGJ5DQorCSAqIG1tdV9ub3RpZmllcl91bnJl
Z2lzdGVyLg0KKwkgKg0KKwkgKiBUaGUgbW11X25vdGlmaWVyX21tIGNhbid0IGdvIGF3YXkgZnJv
bSB1bmRlciB1cyBiZWNhdXNlIG9uZSBtbV9jb3VudA0KKwkgKiBpcyBoZWxkIGJ5IGV4aXRfbW1h
cC4NCiAJICovDQogCXN5bmNocm9uaXplX3NyY3UoJnNyY3UpOw0KIH0NCkBAIC0zMDIsMzEgKzI5
OSwzNCBAQCB2b2lkIG1tdV9ub3RpZmllcl91bnJlZ2lzdGVyKHN0cnVjdCBtbXVfbm90aWZpZXIg
Km1uLCBzdHJ1Y3QgbW1fc3RydWN0ICptbSkNCiB7DQogCUJVR19PTihhdG9taWNfcmVhZCgmbW0t
Pm1tX2NvdW50KSA8PSAwKTsNCiANCi0Jc3Bpbl9sb2NrKCZtbS0+bW11X25vdGlmaWVyX21tLT5s
b2NrKTsNCiAJaWYgKCFobGlzdF91bmhhc2hlZCgmbW4tPmhsaXN0KSkgew0KKwkJLyoNCisJCSAq
IFNSQ1UgaGVyZSB3aWxsIGZvcmNlIGV4aXRfbW1hcCB0byB3YWl0IGZvciAtPnJlbGVhc2UgdG8N
CisJCSAqIGZpbmlzaCBiZWZvcmUgZnJlZWluZyB0aGUgcGFnZXMuDQorCQkgKi8NCiAJCWludCBp
ZDsNCiANCisJCWlkID0gc3JjdV9yZWFkX2xvY2soJnNyY3UpOw0KIAkJLyoNCi0JCSAqIEVuc3Vy
ZSB3ZSBzeW5jaHJvbml6ZSB1cCB3aXRoIF9fbW11X25vdGlmaWVyX3JlbGVhc2UoKS4NCisJCSAq
IGV4aXRfbW1hcCB3aWxsIGJsb2NrIGluIG1tdV9ub3RpZmllcl9yZWxlYXNlIHRvIGd1YXJhbnRl
ZQ0KKwkJICogdGhhdCAtPnJlbGVhc2UgaXMgY2FsbGVkIGJlZm9yZSBmcmVlaW5nIHRoZSBwYWdl
cy4NCiAJCSAqLw0KLQkJaWQgPSBzcmN1X3JlYWRfbG9jaygmc3JjdSk7DQotDQotCQlobGlzdF9k
ZWxfcmN1KCZtbi0+aGxpc3QpOw0KLQkJc3Bpbl91bmxvY2soJm1tLT5tbXVfbm90aWZpZXJfbW0t
PmxvY2spOw0KLQ0KIAkJaWYgKG1uLT5vcHMtPnJlbGVhc2UpDQogCQkJbW4tPm9wcy0+cmVsZWFz
ZShtbiwgbW0pOw0KKwkJc3JjdV9yZWFkX3VubG9jaygmc3JjdSwgaWQpOw0KIA0KKwkJc3Bpbl9s
b2NrKCZtbS0+bW11X25vdGlmaWVyX21tLT5sb2NrKTsNCiAJCS8qDQotCQkgKiBBbGxvdyBfX21t
dV9ub3RpZmllcl9yZWxlYXNlKCkgdG8gY29tcGxldGUuDQorCQkgKiBDYW4gbm90IHVzZSBsaXN0
X2RlbF9yY3UoKSBzaW5jZSBfX21tdV9ub3RpZmllcl9yZWxlYXNlDQorCQkgKiBjYW4gZGVsZXRl
IGl0IGJlZm9yZSB3ZSBob2xkIHRoZSBsb2NrLg0KIAkJICovDQotCQlzcmN1X3JlYWRfdW5sb2Nr
KCZzcmN1LCBpZCk7DQotCX0gZWxzZQ0KKwkJaGxpc3RfZGVsX2luaXRfcmN1KCZtbi0+aGxpc3Qp
Ow0KIAkJc3Bpbl91bmxvY2soJm1tLT5tbXVfbm90aWZpZXJfbW0tPmxvY2spOw0KKwl9DQogDQog
CS8qDQotCSAqIFdhaXQgZm9yIGFueSBydW5uaW5nIG1ldGhvZCB0byBmaW5pc2gsIGluY2x1ZGlu
ZyAtPnJlbGVhc2UoKSBpZiBpdA0KLQkgKiB3YXMgcnVuIGJ5IF9fbW11X25vdGlmaWVyX3JlbGVh
c2UoKSBpbnN0ZWFkIG9mIHVzLg0KKwkgKiBXYWl0IGZvciBhbnkgcnVubmluZyBtZXRob2QgdG8g
ZmluaXNoLCBvZiBjb3Vyc2UgaW5jbHVkaW5nDQorCSAqIC0+cmVsZWFzZSBpZiBpdCB3YXMgcnVu
IGJ5IG1tdV9ub3RpZmllcl9yZWxhc2UgaW5zdGVhZCBvZiB1cy4NCiAJICovDQogCXN5bmNocm9u
aXplX3NyY3UoJnNyY3UpOw0KIA0KZGlmZiAtLWdpdCBhL21tL3BhZ2V3YWxrLmMgYi9tbS9wYWdl
d2Fsay5jDQppbmRleCBhYTk3MDFlLi4xMDkwZTc3IDEwMDY0NA0KLS0tIGEvbW0vcGFnZXdhbGsu
Yw0KKysrIGIvbW0vcGFnZXdhbGsuYw0KQEAgLTEyNywyOCArMTI3LDcgQEAgc3RhdGljIGludCB3
YWxrX2h1Z2V0bGJfcmFuZ2Uoc3RydWN0IHZtX2FyZWFfc3RydWN0ICp2bWEsDQogCXJldHVybiAw
Ow0KIH0NCiANCi1zdGF0aWMgc3RydWN0IHZtX2FyZWFfc3RydWN0KiBodWdldGxiX3ZtYSh1bnNp
Z25lZCBsb25nIGFkZHIsIHN0cnVjdCBtbV93YWxrICp3YWxrKQ0KLXsNCi0Jc3RydWN0IHZtX2Fy
ZWFfc3RydWN0ICp2bWE7DQotDQotCS8qIFdlIGRvbid0IG5lZWQgdm1hIGxvb2t1cCBhdCBhbGwu
ICovDQotCWlmICghd2Fsay0+aHVnZXRsYl9lbnRyeSkNCi0JCXJldHVybiBOVUxMOw0KLQ0KLQlW
TV9CVUdfT04oIXJ3c2VtX2lzX2xvY2tlZCgmd2Fsay0+bW0tPm1tYXBfc2VtKSk7DQotCXZtYSA9
IGZpbmRfdm1hKHdhbGstPm1tLCBhZGRyKTsNCi0JaWYgKHZtYSAmJiB2bWEtPnZtX3N0YXJ0IDw9
IGFkZHIgJiYgaXNfdm1faHVnZXRsYl9wYWdlKHZtYSkpDQotCQlyZXR1cm4gdm1hOw0KLQ0KLQly
ZXR1cm4gTlVMTDsNCi19DQotDQogI2Vsc2UgLyogQ09ORklHX0hVR0VUTEJfUEFHRSAqLw0KLXN0
YXRpYyBzdHJ1Y3Qgdm1fYXJlYV9zdHJ1Y3QqIGh1Z2V0bGJfdm1hKHVuc2lnbmVkIGxvbmcgYWRk
ciwgc3RydWN0IG1tX3dhbGsgKndhbGspDQotew0KLQlyZXR1cm4gTlVMTDsNCi19DQotDQogc3Rh
dGljIGludCB3YWxrX2h1Z2V0bGJfcmFuZ2Uoc3RydWN0IHZtX2FyZWFfc3RydWN0ICp2bWEsDQog
CQkJICAgICAgdW5zaWduZWQgbG9uZyBhZGRyLCB1bnNpZ25lZCBsb25nIGVuZCwNCiAJCQkgICAg
ICBzdHJ1Y3QgbW1fd2FsayAqd2FsaykNCkBAIC0xOTksMzAgKzE3OCw1MyBAQCBpbnQgd2Fsa19w
YWdlX3JhbmdlKHVuc2lnbmVkIGxvbmcgYWRkciwgdW5zaWduZWQgbG9uZyBlbmQsDQogCWlmICgh
d2Fsay0+bW0pDQogCQlyZXR1cm4gLUVJTlZBTDsNCiANCisJVk1fQlVHX09OKCFyd3NlbV9pc19s
b2NrZWQoJndhbGstPm1tLT5tbWFwX3NlbSkpOw0KKw0KIAlwZ2QgPSBwZ2Rfb2Zmc2V0KHdhbGst
Pm1tLCBhZGRyKTsNCiAJZG8gew0KLQkJc3RydWN0IHZtX2FyZWFfc3RydWN0ICp2bWE7DQorCQlz
dHJ1Y3Qgdm1fYXJlYV9zdHJ1Y3QgKnZtYSA9IE5VTEw7DQogDQogCQluZXh0ID0gcGdkX2FkZHJf
ZW5kKGFkZHIsIGVuZCk7DQogDQogCQkvKg0KLQkJICogaGFuZGxlIGh1Z2V0bGIgdm1hIGluZGl2
aWR1YWxseSBiZWNhdXNlIHBhZ2V0YWJsZSB3YWxrIGZvcg0KLQkJICogdGhlIGh1Z2V0bGIgcGFn
ZSBpcyBkZXBlbmRlbnQgb24gdGhlIGFyY2hpdGVjdHVyZSBhbmQNCi0JCSAqIHdlIGNhbid0IGhh
bmRsZWQgaXQgaW4gdGhlIHNhbWUgbWFubmVyIGFzIG5vbi1odWdlIHBhZ2VzLg0KKwkJICogVGhp
cyBmdW5jdGlvbiB3YXMgbm90IGludGVuZGVkIHRvIGJlIHZtYSBiYXNlZC4NCisJCSAqIEJ1dCB0
aGVyZSBhcmUgdm1hIHNwZWNpYWwgY2FzZXMgdG8gYmUgaGFuZGxlZDoNCisJCSAqIC0gaHVnZXRs
YiB2bWEncw0KKwkJICogLSBWTV9QRk5NQVAgdm1hJ3MNCiAJCSAqLw0KLQkJdm1hID0gaHVnZXRs
Yl92bWEoYWRkciwgd2Fsayk7DQorCQl2bWEgPSBmaW5kX3ZtYSh3YWxrLT5tbSwgYWRkcik7DQog
CQlpZiAodm1hKSB7DQotCQkJaWYgKHZtYS0+dm1fZW5kIDwgbmV4dCkNCisJCQkvKg0KKwkJCSAq
IFRoZXJlIGFyZSBubyBwYWdlIHN0cnVjdHVyZXMgYmFja2luZyBhIFZNX1BGTk1BUA0KKwkJCSAq
IHJhbmdlLCBzbyBkbyBub3QgYWxsb3cgc3BsaXRfaHVnZV9wYWdlX3BtZCgpLg0KKwkJCSAqLw0K
KwkJCWlmICgodm1hLT52bV9zdGFydCA8PSBhZGRyKSAmJg0KKwkJCSAgICAodm1hLT52bV9mbGFn
cyAmIFZNX1BGTk1BUCkpIHsNCiAJCQkJbmV4dCA9IHZtYS0+dm1fZW5kOw0KKwkJCQlwZ2QgPSBw
Z2Rfb2Zmc2V0KHdhbGstPm1tLCBuZXh0KTsNCisJCQkJY29udGludWU7DQorCQkJfQ0KIAkJCS8q
DQotCQkJICogSHVnZXBhZ2UgaXMgdmVyeSB0aWdodGx5IGNvdXBsZWQgd2l0aCB2bWEsIHNvDQot
CQkJICogd2FsayB0aHJvdWdoIGh1Z2V0bGIgZW50cmllcyB3aXRoaW4gYSBnaXZlbiB2bWEuDQor
CQkJICogSGFuZGxlIGh1Z2V0bGIgdm1hIGluZGl2aWR1YWxseSBiZWNhdXNlIHBhZ2V0YWJsZQ0K
KwkJCSAqIHdhbGsgZm9yIHRoZSBodWdldGxiIHBhZ2UgaXMgZGVwZW5kZW50IG9uIHRoZQ0KKwkJ
CSAqIGFyY2hpdGVjdHVyZSBhbmQgd2UgY2FuJ3QgaGFuZGxlZCBpdCBpbiB0aGUgc2FtZQ0KKwkJ
CSAqIG1hbm5lciBhcyBub24taHVnZSBwYWdlcy4NCiAJCQkgKi8NCi0JCQllcnIgPSB3YWxrX2h1
Z2V0bGJfcmFuZ2Uodm1hLCBhZGRyLCBuZXh0LCB3YWxrKTsNCi0JCQlpZiAoZXJyKQ0KLQkJCQli
cmVhazsNCi0JCQlwZ2QgPSBwZ2Rfb2Zmc2V0KHdhbGstPm1tLCBuZXh0KTsNCi0JCQljb250aW51
ZTsNCisJCQlpZiAod2Fsay0+aHVnZXRsYl9lbnRyeSAmJiAodm1hLT52bV9zdGFydCA8PSBhZGRy
KSAmJg0KKwkJCSAgICBpc192bV9odWdldGxiX3BhZ2Uodm1hKSkgew0KKwkJCQlpZiAodm1hLT52
bV9lbmQgPCBuZXh0KQ0KKwkJCQkJbmV4dCA9IHZtYS0+dm1fZW5kOw0KKwkJCQkvKg0KKwkJCQkg
KiBIdWdlcGFnZSBpcyB2ZXJ5IHRpZ2h0bHkgY291cGxlZCB3aXRoIHZtYSwNCisJCQkJICogc28g
d2FsayB0aHJvdWdoIGh1Z2V0bGIgZW50cmllcyB3aXRoaW4gYQ0KKwkJCQkgKiBnaXZlbiB2bWEu
DQorCQkJCSAqLw0KKwkJCQllcnIgPSB3YWxrX2h1Z2V0bGJfcmFuZ2Uodm1hLCBhZGRyLCBuZXh0
LCB3YWxrKTsNCisJCQkJaWYgKGVycikNCisJCQkJCWJyZWFrOw0KKwkJCQlwZ2QgPSBwZ2Rfb2Zm
c2V0KHdhbGstPm1tLCBuZXh0KTsNCisJCQkJY29udGludWU7DQorCQkJfQ0KIAkJfQ0KIA0KIAkJ
aWYgKHBnZF9ub25lX29yX2NsZWFyX2JhZChwZ2QpKSB7DQpkaWZmIC0tZ2l0IGEvbmV0L2JyaWRn
ZS9icl9zdHBfdGltZXIuYyBiL25ldC9icmlkZ2UvYnJfc3RwX3RpbWVyLmMNCmluZGV4IDU4ZGUy
YTAuLmM4M2VlNzkgMTAwNjQ0DQotLS0gYS9uZXQvYnJpZGdlL2JyX3N0cF90aW1lci5jDQorKysg
Yi9uZXQvYnJpZGdlL2JyX3N0cF90aW1lci5jDQpAQCAtMTA3LDcgKzEwNyw3IEBAIHN0YXRpYyB2
b2lkIGJyX3Rjbl90aW1lcl9leHBpcmVkKHVuc2lnbmVkIGxvbmcgYXJnKQ0KIA0KIAlicl9kZWJ1
ZyhiciwgInRjbiB0aW1lciBleHBpcmVkXG4iKTsNCiAJc3Bpbl9sb2NrKCZici0+bG9jayk7DQot
CWlmIChici0+ZGV2LT5mbGFncyAmIElGRl9VUCkgew0KKwlpZiAoIWJyX2lzX3Jvb3RfYnJpZGdl
KGJyKSAmJiAoYnItPmRldi0+ZmxhZ3MgJiBJRkZfVVApKSB7DQogCQlicl90cmFuc21pdF90Y24o
YnIpOw0KIA0KIAkJbW9kX3RpbWVyKCZici0+dGNuX3RpbWVyLGppZmZpZXMgKyBici0+YnJpZGdl
X2hlbGxvX3RpbWUpOw0KZGlmZiAtLWdpdCBhL25ldC9jb3JlL3NvY2suYyBiL25ldC9jb3JlL3Nv
Y2suYw0KaW5kZXggMmM3M2FkZi4uOGEyYzJkZCAxMDA2NDQNCi0tLSBhL25ldC9jb3JlL3NvY2su
Yw0KKysrIGIvbmV0L2NvcmUvc29jay5jDQpAQCAtMTAyMSwxOCArMTAyMSw2IEBAIHN0YXRpYyB2
b2lkIHNvY2tfY29weShzdHJ1Y3Qgc29jayAqbnNrLCBjb25zdCBzdHJ1Y3Qgc29jayAqb3NrKQ0K
ICNlbmRpZg0KIH0NCiANCi0vKg0KLSAqIGNhY2hlcyB1c2luZyBTTEFCX0RFU1RST1lfQllfUkNV
IHNob3VsZCBsZXQgLm5leHQgcG9pbnRlciBmcm9tIG51bGxzIG5vZGVzDQotICogdW4tbW9kaWZp
ZWQuIFNwZWNpYWwgY2FyZSBpcyB0YWtlbiB3aGVuIGluaXRpYWxpemluZyBvYmplY3QgdG8gemVy
by4NCi0gKi8NCi1zdGF0aWMgaW5saW5lIHZvaWQgc2tfcHJvdF9jbGVhcl9udWxscyhzdHJ1Y3Qg
c29jayAqc2ssIGludCBzaXplKQ0KLXsNCi0JaWYgKG9mZnNldG9mKHN0cnVjdCBzb2NrLCBza19u
b2RlLm5leHQpICE9IDApDQotCQltZW1zZXQoc2ssIDAsIG9mZnNldG9mKHN0cnVjdCBzb2NrLCBz
a19ub2RlLm5leHQpKTsNCi0JbWVtc2V0KCZzay0+c2tfbm9kZS5wcHJldiwgMCwNCi0JICAgICAg
IHNpemUgLSBvZmZzZXRvZihzdHJ1Y3Qgc29jaywgc2tfbm9kZS5wcHJldikpOw0KLX0NCi0NCiB2
b2lkIHNrX3Byb3RfY2xlYXJfcG9ydGFkZHJfbnVsbHMoc3RydWN0IHNvY2sgKnNrLCBpbnQgc2l6
ZSkNCiB7DQogCXVuc2lnbmVkIGxvbmcgbnVsbHMxLCBudWxsczI7DQpkaWZmIC0tZ2l0IGEvbmV0
L2lwdjYvdGNwX2lwdjYuYyBiL25ldC9pcHY2L3RjcF9pcHY2LmMNCmluZGV4IGRiMTA4MDUuLmM2
OTM1OGMgMTAwNjQ0DQotLS0gYS9uZXQvaXB2Ni90Y3BfaXB2Ni5jDQorKysgYi9uZXQvaXB2Ni90
Y3BfaXB2Ni5jDQpAQCAtMjE5Niw2ICsyMTk2LDE3IEBAIHZvaWQgdGNwNl9wcm9jX2V4aXQoc3Ry
dWN0IG5ldCAqbmV0KQ0KIH0NCiAjZW5kaWYNCiANCitzdGF0aWMgdm9pZCB0Y3BfdjZfY2xlYXJf
c2soc3RydWN0IHNvY2sgKnNrLCBpbnQgc2l6ZSkNCit7DQorCXN0cnVjdCBpbmV0X3NvY2sgKmlu
ZXQgPSBpbmV0X3NrKHNrKTsNCisNCisJLyogd2UgZG8gbm90IHdhbnQgdG8gY2xlYXIgcGluZXQ2
IGZpZWxkLCBiZWNhdXNlIG9mIFJDVSBsb29rdXBzICovDQorCXNrX3Byb3RfY2xlYXJfbnVsbHMo
c2ssIG9mZnNldG9mKHN0cnVjdCBpbmV0X3NvY2ssIHBpbmV0NikpOw0KKw0KKwlzaXplIC09IG9m
ZnNldG9mKHN0cnVjdCBpbmV0X3NvY2ssIHBpbmV0NikgKyBzaXplb2YoaW5ldC0+cGluZXQ2KTsN
CisJbWVtc2V0KCZpbmV0LT5waW5ldDYgKyAxLCAwLCBzaXplKTsNCit9DQorDQogc3RydWN0IHBy
b3RvIHRjcHY2X3Byb3QgPSB7DQogCS5uYW1lCQkJPSAiVENQdjYiLA0KIAkub3duZXIJCQk9IFRI
SVNfTU9EVUxFLA0KQEAgLTIyMzUsNiArMjI0Niw3IEBAIHN0cnVjdCBwcm90byB0Y3B2Nl9wcm90
ID0gew0KIAkuY29tcGF0X3NldHNvY2tvcHQJPSBjb21wYXRfdGNwX3NldHNvY2tvcHQsDQogCS5j
b21wYXRfZ2V0c29ja29wdAk9IGNvbXBhdF90Y3BfZ2V0c29ja29wdCwNCiAjZW5kaWYNCisJLmNs
ZWFyX3NrCQk9IHRjcF92Nl9jbGVhcl9zaywNCiB9Ow0KIA0KIHN0YXRpYyBjb25zdCBzdHJ1Y3Qg
aW5ldDZfcHJvdG9jb2wgdGNwdjZfcHJvdG9jb2wgPSB7DQpkaWZmIC0tZ2l0IGEvbmV0L2lwdjYv
dWRwLmMgYi9uZXQvaXB2Ni91ZHAuYw0KaW5kZXggOGMyNTQxOS4uMjBmMDgxMiAxMDA2NDQNCi0t
LSBhL25ldC9pcHY2L3VkcC5jDQorKysgYi9uZXQvaXB2Ni91ZHAuYw0KQEAgLTE0NTMsNiArMTQ1
MywxNyBAQCB2b2lkIHVkcDZfcHJvY19leGl0KHN0cnVjdCBuZXQgKm5ldCkgew0KIH0NCiAjZW5k
aWYgLyogQ09ORklHX1BST0NfRlMgKi8NCiANCit2b2lkIHVkcF92Nl9jbGVhcl9zayhzdHJ1Y3Qg
c29jayAqc2ssIGludCBzaXplKQ0KK3sNCisJc3RydWN0IGluZXRfc29jayAqaW5ldCA9IGluZXRf
c2soc2spOw0KKw0KKwkvKiB3ZSBkbyBub3Qgd2FudCB0byBjbGVhciBwaW5ldDYgZmllbGQsIGJl
Y2F1c2Ugb2YgUkNVIGxvb2t1cHMgKi8NCisJc2tfcHJvdF9jbGVhcl9wb3J0YWRkcl9udWxscyhz
aywgb2Zmc2V0b2Yoc3RydWN0IGluZXRfc29jaywgcGluZXQ2KSk7DQorDQorCXNpemUgLT0gb2Zm
c2V0b2Yoc3RydWN0IGluZXRfc29jaywgcGluZXQ2KSArIHNpemVvZihpbmV0LT5waW5ldDYpOw0K
KwltZW1zZXQoJmluZXQtPnBpbmV0NiArIDEsIDAsIHNpemUpOw0KK30NCisNCiAvKiAtLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0gKi8NCiANCiBzdHJ1Y3QgcHJvdG8gdWRwdjZfcHJvdCA9IHsNCkBAIC0xNDgzLDcg
KzE0OTQsNyBAQCBzdHJ1Y3QgcHJvdG8gdWRwdjZfcHJvdCA9IHsNCiAJLmNvbXBhdF9zZXRzb2Nr
b3B0ID0gY29tcGF0X3VkcHY2X3NldHNvY2tvcHQsDQogCS5jb21wYXRfZ2V0c29ja29wdCA9IGNv
bXBhdF91ZHB2Nl9nZXRzb2Nrb3B0LA0KICNlbmRpZg0KLQkuY2xlYXJfc2sJICAgPSBza19wcm90
X2NsZWFyX3BvcnRhZGRyX251bGxzLA0KKwkuY2xlYXJfc2sJICAgPSB1ZHBfdjZfY2xlYXJfc2ss
DQogfTsNCiANCiBzdGF0aWMgc3RydWN0IGluZXRfcHJvdG9zdyB1ZHB2Nl9wcm90b3N3ID0gew0K
ZGlmZiAtLWdpdCBhL25ldC9pcHY2L3VkcF9pbXBsLmggYi9uZXQvaXB2Ni91ZHBfaW1wbC5oDQpp
bmRleCBkNzU3MTA0Li40NjkxZWQ1IDEwMDY0NA0KLS0tIGEvbmV0L2lwdjYvdWRwX2ltcGwuaA0K
KysrIGIvbmV0L2lwdjYvdWRwX2ltcGwuaA0KQEAgLTMxLDYgKzMxLDggQEAgZXh0ZXJuIGludAl1
ZHB2Nl9yZWN2bXNnKHN0cnVjdCBraW9jYiAqaW9jYiwgc3RydWN0IHNvY2sgKnNrLA0KIGV4dGVy
biBpbnQJdWRwdjZfcXVldWVfcmN2X3NrYihzdHJ1Y3Qgc29jayAqIHNrLCBzdHJ1Y3Qgc2tfYnVm
ZiAqc2tiKTsNCiBleHRlcm4gdm9pZAl1ZHB2Nl9kZXN0cm95X3NvY2soc3RydWN0IHNvY2sgKnNr
KTsNCiANCitleHRlcm4gdm9pZCB1ZHBfdjZfY2xlYXJfc2soc3RydWN0IHNvY2sgKnNrLCBpbnQg
c2l6ZSk7DQorDQogI2lmZGVmIENPTkZJR19QUk9DX0ZTDQogZXh0ZXJuIGludAl1ZHA2X3NlcV9z
aG93KHN0cnVjdCBzZXFfZmlsZSAqc2VxLCB2b2lkICp2KTsNCiAjZW5kaWYNCmRpZmYgLS1naXQg
YS9uZXQvaXB2Ni91ZHBsaXRlLmMgYi9uZXQvaXB2Ni91ZHBsaXRlLmMNCmluZGV4IDFkMDhlMjEu
LmRmY2M0YmUgMTAwNjQ0DQotLS0gYS9uZXQvaXB2Ni91ZHBsaXRlLmMNCisrKyBiL25ldC9pcHY2
L3VkcGxpdGUuYw0KQEAgLTU2LDcgKzU2LDcgQEAgc3RydWN0IHByb3RvIHVkcGxpdGV2Nl9wcm90
ID0gew0KIAkuY29tcGF0X3NldHNvY2tvcHQgPSBjb21wYXRfdWRwdjZfc2V0c29ja29wdCwNCiAJ
LmNvbXBhdF9nZXRzb2Nrb3B0ID0gY29tcGF0X3VkcHY2X2dldHNvY2tvcHQsDQogI2VuZGlmDQot
CS5jbGVhcl9zawkgICA9IHNrX3Byb3RfY2xlYXJfcG9ydGFkZHJfbnVsbHMsDQorCS5jbGVhcl9z
awkgICA9IHVkcF92Nl9jbGVhcl9zaywNCiB9Ow0KIA0KIHN0YXRpYyBzdHJ1Y3QgaW5ldF9wcm90
b3N3IHVkcGxpdGU2X3Byb3Rvc3cgPSB7DQpkaWZmIC0tZ2l0IGEvbmV0L2lwdjYveGZybTZfcG9s
aWN5LmMgYi9uZXQvaXB2Ni94ZnJtNl9wb2xpY3kuYw0KaW5kZXggZDg3OWY3ZS4uZGI3OGU3ZCAx
MDA2NDQNCi0tLSBhL25ldC9pcHY2L3hmcm02X3BvbGljeS5jDQorKysgYi9uZXQvaXB2Ni94ZnJt
Nl9wb2xpY3kuYw0KQEAgLTk2LDggKzk2LDEwIEBAIHN0YXRpYyBpbnQgeGZybTZfZmlsbF9kc3Qo
c3RydWN0IHhmcm1fZHN0ICp4ZHN0LCBzdHJ1Y3QgbmV0X2RldmljZSAqZGV2LA0KIAlkZXZfaG9s
ZChkZXYpOw0KIA0KIAl4ZHN0LT51LnJ0Ni5ydDZpX2lkZXYgPSBpbjZfZGV2X2dldChkZXYpOw0K
LQlpZiAoIXhkc3QtPnUucnQ2LnJ0NmlfaWRldikNCisJaWYgKCF4ZHN0LT51LnJ0Ni5ydDZpX2lk
ZXYpIHsNCisJCWRldl9wdXQoZGV2KTsNCiAJCXJldHVybiAtRU5PREVWOw0KKwl9DQogDQogCXhk
c3QtPnUucnQ2LnJ0NmlfcGVlciA9IHJ0LT5ydDZpX3BlZXI7DQogCWlmIChydC0+cnQ2aV9wZWVy
KQ0KZGlmZiAtLWdpdCBhL25ldC9uZXRmaWx0ZXIvaXB2cy9pcF92c19wZV9zaXAuYyBiL25ldC9u
ZXRmaWx0ZXIvaXB2cy9pcF92c19wZV9zaXAuYw0KaW5kZXggMTNkNjA3YS4uODdlY2Y3NSAxMDA2
NDQNCi0tLSBhL25ldC9uZXRmaWx0ZXIvaXB2cy9pcF92c19wZV9zaXAuYw0KKysrIGIvbmV0L25l
dGZpbHRlci9pcHZzL2lwX3ZzX3BlX3NpcC5jDQpAQCAtMzcsMTQgKzM3LDEwIEBAIHN0YXRpYyBp
bnQgZ2V0X2NhbGxpZChjb25zdCBjaGFyICpkcHRyLCB1bnNpZ25lZCBpbnQgZGF0YW9mZiwNCiAJ
CWlmIChyZXQgPiAwKQ0KIAkJCWJyZWFrOw0KIAkJaWYgKCFyZXQpDQotCQkJcmV0dXJuIDA7DQor
CQkJcmV0dXJuIC1FSU5WQUw7DQogCQlkYXRhb2ZmICs9ICptYXRjaG9mZjsNCiAJfQ0KIA0KLQkv
KiBFbXB0eSBjYWxsaWQgaXMgdXNlbGVzcyAqLw0KLQlpZiAoISptYXRjaGxlbikNCi0JCXJldHVy
biAtRUlOVkFMOw0KLQ0KIAkvKiBUb28gbGFyZ2UgaXMgdXNlbGVzcyAqLw0KIAlpZiAoKm1hdGNo
bGVuID4gSVBfVlNfUEVEQVRBX01BWExFTikNCiAJCXJldHVybiAtRUlOVkFMOw0KZGlmZiAtLWdp
dCBhL25ldC9wYWNrZXQvYWZfcGFja2V0LmMgYi9uZXQvcGFja2V0L2FmX3BhY2tldC5jDQppbmRl
eCA4MzVmY2VhLi41YTcwMjE1IDEwMDY0NA0KLS0tIGEvbmV0L3BhY2tldC9hZl9wYWNrZXQuYw0K
KysrIGIvbmV0L3BhY2tldC9hZl9wYWNrZXQuYw0KQEAgLTgxMywzNyArODEzLDI3IEBAIHN0YXRp
YyB2b2lkIHByYl9vcGVuX2Jsb2NrKHN0cnVjdCB0cGFja2V0X2tiZHFfY29yZSAqcGtjMSwNCiAN
CiAJc21wX3JtYigpOw0KIA0KLQlpZiAobGlrZWx5KFRQX1NUQVRVU19LRVJORUwgPT0gQkxPQ0tf
U1RBVFVTKHBiZDEpKSkgew0KLQ0KLQkJLyogV2UgY291bGQgaGF2ZSBqdXN0IG1lbXNldCB0aGlz
IGJ1dCB3ZSB3aWxsIGxvc2UgdGhlDQotCQkgKiBmbGV4aWJpbGl0eSBvZiBtYWtpbmcgdGhlIHBy
aXYgYXJlYSBzdGlja3kNCi0JCSAqLw0KLQkJQkxPQ0tfU05VTShwYmQxKSA9IHBrYzEtPmtueHRf
c2VxX251bSsrOw0KLQkJQkxPQ0tfTlVNX1BLVFMocGJkMSkgPSAwOw0KLQkJQkxPQ0tfTEVOKHBi
ZDEpID0gQkxLX1BMVVNfUFJJVihwa2MxLT5ibGtfc2l6ZW9mX3ByaXYpOw0KLQkJZ2V0bnN0aW1l
b2ZkYXkoJnRzKTsNCi0JCWgxLT50c19maXJzdF9wa3QudHNfc2VjID0gdHMudHZfc2VjOw0KLQkJ
aDEtPnRzX2ZpcnN0X3BrdC50c19uc2VjID0gdHMudHZfbnNlYzsNCi0JCXBrYzEtPnBrYmxrX3N0
YXJ0ID0gKGNoYXIgKilwYmQxOw0KLQkJcGtjMS0+bnh0X29mZnNldCA9IChjaGFyICopKHBrYzEt
PnBrYmxrX3N0YXJ0ICsNCi0JCUJMS19QTFVTX1BSSVYocGtjMS0+YmxrX3NpemVvZl9wcml2KSk7
DQotCQlCTE9DS19PMkZQKHBiZDEpID0gKF9fdTMyKUJMS19QTFVTX1BSSVYocGtjMS0+YmxrX3Np
emVvZl9wcml2KTsNCi0JCUJMT0NLX08yUFJJVihwYmQxKSA9IEJMS19IRFJfTEVOOw0KLQkJcGJk
MS0+dmVyc2lvbiA9IHBrYzEtPnZlcnNpb247DQotCQlwa2MxLT5wcmV2ID0gcGtjMS0+bnh0X29m
ZnNldDsNCi0JCXBrYzEtPnBrYmxrX2VuZCA9IHBrYzEtPnBrYmxrX3N0YXJ0ICsgcGtjMS0+a2Js
a19zaXplOw0KLQkJcHJiX3RoYXdfcXVldWUocGtjMSk7DQotCQlfcHJiX3JlZnJlc2hfcnhfcmV0
aXJlX2Jsa190aW1lcihwa2MxKTsNCi0NCi0JCXNtcF93bWIoKTsNCi0NCi0JCXJldHVybjsNCi0J
fQ0KKwkvKiBXZSBjb3VsZCBoYXZlIGp1c3QgbWVtc2V0IHRoaXMgYnV0IHdlIHdpbGwgbG9zZSB0
aGUNCisJICogZmxleGliaWxpdHkgb2YgbWFraW5nIHRoZSBwcml2IGFyZWEgc3RpY2t5DQorCSAq
Lw0KKwlCTE9DS19TTlVNKHBiZDEpID0gcGtjMS0+a254dF9zZXFfbnVtKys7DQorCUJMT0NLX05V
TV9QS1RTKHBiZDEpID0gMDsNCisJQkxPQ0tfTEVOKHBiZDEpID0gQkxLX1BMVVNfUFJJVihwa2Mx
LT5ibGtfc2l6ZW9mX3ByaXYpOw0KKwlnZXRuc3RpbWVvZmRheSgmdHMpOw0KKwloMS0+dHNfZmly
c3RfcGt0LnRzX3NlYyA9IHRzLnR2X3NlYzsNCisJaDEtPnRzX2ZpcnN0X3BrdC50c19uc2VjID0g
dHMudHZfbnNlYzsNCisJcGtjMS0+cGtibGtfc3RhcnQgPSAoY2hhciAqKXBiZDE7DQorCXBrYzEt
Pm54dF9vZmZzZXQgPSAoY2hhciAqKShwa2MxLT5wa2Jsa19zdGFydCArDQorCQkJCSAgICBCTEtf
UExVU19QUklWKHBrYzEtPmJsa19zaXplb2ZfcHJpdikpOw0KKwlCTE9DS19PMkZQKHBiZDEpID0g
KF9fdTMyKUJMS19QTFVTX1BSSVYocGtjMS0+YmxrX3NpemVvZl9wcml2KTsNCisJQkxPQ0tfTzJQ
UklWKHBiZDEpID0gQkxLX0hEUl9MRU47DQorCXBiZDEtPnZlcnNpb24gPSBwa2MxLT52ZXJzaW9u
Ow0KKwlwa2MxLT5wcmV2ID0gcGtjMS0+bnh0X29mZnNldDsNCisJcGtjMS0+cGtibGtfZW5kID0g
cGtjMS0+cGtibGtfc3RhcnQgKyBwa2MxLT5rYmxrX3NpemU7DQorCXByYl90aGF3X3F1ZXVlKHBr
YzEpOw0KKwlfcHJiX3JlZnJlc2hfcnhfcmV0aXJlX2Jsa190aW1lcihwa2MxKTsNCiANCi0JV0FS
TigxLCAiRVJST1IgYmxvY2s6JXAgaXMgTk9UIEZSRUUgc3RhdHVzOiVkIGthY3RpdmVfYmxrX251
bTolZFxuIiwNCi0JCXBiZDEsIEJMT0NLX1NUQVRVUyhwYmQxKSwgcGtjMS0+a2FjdGl2ZV9ibGtf
bnVtKTsNCi0JZHVtcF9zdGFjaygpOw0KLQlCVUcoKTsNCisJc21wX3dtYigpOw0KIH0NCiANCiAv
Kg0KQEAgLTkzNCwxMCArOTI0LDYgQEAgc3RhdGljIHZvaWQgcHJiX3JldGlyZV9jdXJyZW50X2Js
b2NrKHN0cnVjdCB0cGFja2V0X2tiZHFfY29yZSAqcGtjLA0KIAkJcHJiX2Nsb3NlX2Jsb2NrKHBr
YywgcGJkLCBwbywgc3RhdHVzKTsNCiAJCXJldHVybjsNCiAJfQ0KLQ0KLQlXQVJOKDEsICJFUlJP
Ui1wYmRbJWRdOiVwXG4iLCBwa2MtPmthY3RpdmVfYmxrX251bSwgcGJkKTsNCi0JZHVtcF9zdGFj
aygpOw0KLQlCVUcoKTsNCiB9DQogDQogc3RhdGljIGludCBwcmJfY3Vycl9ibGtfaW5fdXNlKHN0
cnVjdCB0cGFja2V0X2tiZHFfY29yZSAqcGtjLA0KZGlmZiAtLWdpdCBhL25ldC9zY2hlZC9hY3Rf
aXB0LmMgYi9uZXQvc2NoZWQvYWN0X2lwdC5jDQppbmRleCA2MGY4ZjYxLi41NzgyN2JmIDEwMDY0
NA0KLS0tIGEvbmV0L3NjaGVkL2FjdF9pcHQuYw0KKysrIGIvbmV0L3NjaGVkL2FjdF9pcHQuYw0K
QEAgLTgsNyArOCw3IEBADQogICoJCWFzIHB1Ymxpc2hlZCBieSB0aGUgRnJlZSBTb2Z0d2FyZSBG
b3VuZGF0aW9uOyBlaXRoZXIgdmVyc2lvbg0KICAqCQkyIG9mIHRoZSBMaWNlbnNlLCBvciAoYXQg
eW91ciBvcHRpb24pIGFueSBsYXRlciB2ZXJzaW9uLg0KICAqDQotICogQ29weXJpZ2h0OglKYW1h
bCBIYWRpIFNhbGltICgyMDAyLTQpDQorICogQ29weXJpZ2h0OglKYW1hbCBIYWRpIFNhbGltICgy
MDAyLTEzKQ0KICAqLw0KIA0KICNpbmNsdWRlIDxsaW51eC90eXBlcy5oPg0KQEAgLTI5OSwxNyAr
Mjk5LDQ0IEBAIHN0YXRpYyBzdHJ1Y3QgdGNfYWN0aW9uX29wcyBhY3RfaXB0X29wcyA9IHsNCiAJ
LndhbGsJCT0JdGNmX2dlbmVyaWNfd2Fsa2VyDQogfTsNCiANCi1NT0RVTEVfQVVUSE9SKCJKYW1h
bCBIYWRpIFNhbGltKDIwMDItNCkiKTsNCitzdGF0aWMgc3RydWN0IHRjX2FjdGlvbl9vcHMgYWN0
X3h0X29wcyA9IHsNCisJLmtpbmQJCT0JInh0IiwNCisJLmhpbmZvCQk9CSZpcHRfaGFzaF9pbmZv
LA0KKwkudHlwZQkJPQlUQ0FfQUNUX0lQVCwNCisJLmNhcGFiCQk9CVRDQV9DQVBfTk9ORSwNCisJ
Lm93bmVyCQk9CVRISVNfTU9EVUxFLA0KKwkuYWN0CQk9CXRjZl9pcHQsDQorCS5kdW1wCQk9CXRj
Zl9pcHRfZHVtcCwNCisJLmNsZWFudXAJPQl0Y2ZfaXB0X2NsZWFudXAsDQorCS5sb29rdXAJCT0J
dGNmX2hhc2hfc2VhcmNoLA0KKwkuaW5pdAkJPQl0Y2ZfaXB0X2luaXQsDQorCS53YWxrCQk9CXRj
Zl9nZW5lcmljX3dhbGtlcg0KK307DQorDQorTU9EVUxFX0FVVEhPUigiSmFtYWwgSGFkaSBTYWxp
bSgyMDAyLTEzKSIpOw0KIE1PRFVMRV9ERVNDUklQVElPTigiSXB0YWJsZXMgdGFyZ2V0IGFjdGlv
bnMiKTsNCiBNT0RVTEVfTElDRU5TRSgiR1BMIik7DQorTU9EVUxFX0FMSUFTKCJhY3RfeHQiKTsN
CiANCiBzdGF0aWMgaW50IF9faW5pdCBpcHRfaW5pdF9tb2R1bGUodm9pZCkNCiB7DQotCXJldHVy
biB0Y2ZfcmVnaXN0ZXJfYWN0aW9uKCZhY3RfaXB0X29wcyk7DQorCWludCByZXQxLCByZXQyOw0K
KwlyZXQxID0gdGNmX3JlZ2lzdGVyX2FjdGlvbigmYWN0X3h0X29wcyk7DQorCWlmIChyZXQxIDwg
MCkNCisJCXByaW50aygiRmFpbGVkIHRvIGxvYWQgeHQgYWN0aW9uXG4iKTsNCisJcmV0MiA9IHRj
Zl9yZWdpc3Rlcl9hY3Rpb24oJmFjdF9pcHRfb3BzKTsNCisJaWYgKHJldDIgPCAwKQ0KKwkJcHJp
bnRrKCJGYWlsZWQgdG8gbG9hZCBpcHQgYWN0aW9uXG4iKTsNCisNCisJaWYgKHJldDEgPCAwICYm
IHJldDIgPCAwKQ0KKwkJcmV0dXJuIHJldDE7DQorCWVsc2UNCisJCXJldHVybiAwOw0KIH0NCiAN
CiBzdGF0aWMgdm9pZCBfX2V4aXQgaXB0X2NsZWFudXBfbW9kdWxlKHZvaWQpDQogew0KKwl0Y2Zf
dW5yZWdpc3Rlcl9hY3Rpb24oJmFjdF94dF9vcHMpOw0KIAl0Y2ZfdW5yZWdpc3Rlcl9hY3Rpb24o
JmFjdF9pcHRfb3BzKTsNCiB9DQogDQpkaWZmIC0tZ2l0IGEvbmV0L3N1bnJwYy9zY2hlZC5jIGIv
bmV0L3N1bnJwYy9zY2hlZC5jDQppbmRleCBkYzZhZjI3Li4yMDZjNjFlIDEwMDY0NA0KLS0tIGEv
bmV0L3N1bnJwYy9zY2hlZC5jDQorKysgYi9uZXQvc3VucnBjL3NjaGVkLmMNCkBAIC0yOTYsMTMg
KzI5NiwyMCBAQCBFWFBPUlRfU1lNQk9MX0dQTChfX3JwY193YWl0X2Zvcl9jb21wbGV0aW9uX3Rh
c2spOw0KIC8qDQogICogTWFrZSBhbiBSUEMgdGFzayBydW5uYWJsZS4NCiAgKg0KLSAqIE5vdGU6
IElmIHRoZSB0YXNrIGlzIEFTWU5DLCB0aGlzIG11c3QgYmUgY2FsbGVkIHdpdGgNCi0gKiB0aGUg
c3BpbmxvY2sgaGVsZCB0byBwcm90ZWN0IHRoZSB3YWl0IHF1ZXVlIG9wZXJhdGlvbi4NCisgKiBO
b3RlOiBJZiB0aGUgdGFzayBpcyBBU1lOQywgYW5kIGlzIGJlaW5nIG1hZGUgcnVubmFibGUgYWZ0
ZXIgc2l0dGluZyBvbiBhbg0KKyAqIHJwY193YWl0X3F1ZXVlLCB0aGlzIG11c3QgYmUgY2FsbGVk
IHdpdGggdGhlIHF1ZXVlIHNwaW5sb2NrIGhlbGQgdG8gcHJvdGVjdA0KKyAqIHRoZSB3YWl0IHF1
ZXVlIG9wZXJhdGlvbi4NCisgKiBOb3RlIHRoZSBvcmRlcmluZyBvZiBycGNfdGVzdF9hbmRfc2V0
X3J1bm5pbmcoKSBhbmQgcnBjX2NsZWFyX3F1ZXVlZCgpLA0KKyAqIHdoaWNoIGlzIG5lZWRlZCB0
byBlbnN1cmUgdGhhdCBfX3JwY19leGVjdXRlKCkgZG9lc24ndCBsb29wIChkdWUgdG8gdGhlDQor
ICogbG9ja2xlc3MgUlBDX0lTX1FVRVVFRCgpIHRlc3QpIGJlZm9yZSB3ZSd2ZSBoYWQgYSBjaGFu
Y2UgdG8gdGVzdA0KKyAqIHRoZSBSUENfVEFTS19SVU5OSU5HIGZsYWcuDQogICovDQogc3RhdGlj
IHZvaWQgcnBjX21ha2VfcnVubmFibGUoc3RydWN0IHJwY190YXNrICp0YXNrKQ0KIHsNCisJYm9v
bCBuZWVkX3dha2V1cCA9ICFycGNfdGVzdF9hbmRfc2V0X3J1bm5pbmcodGFzayk7DQorDQogCXJw
Y19jbGVhcl9xdWV1ZWQodGFzayk7DQotCWlmIChycGNfdGVzdF9hbmRfc2V0X3J1bm5pbmcodGFz
aykpDQorCWlmICghbmVlZF93YWtldXApDQogCQlyZXR1cm47DQogCWlmIChSUENfSVNfQVNZTkMo
dGFzaykpIHsNCiAJCUlOSVRfV09SSygmdGFzay0+dS50a193b3JrLCBycGNfYXN5bmNfc2NoZWR1
bGUpOw0KZGlmZiAtLWdpdCBhL3NvdW5kL3BjaS9oZGEvaGRhX2NvZGVjLmMgYi9zb3VuZC9wY2kv
aGRhL2hkYV9jb2RlYy5jDQppbmRleCA0NzA3YjZjLi5mYWFiYWE1IDEwMDY0NA0KLS0tIGEvc291
bmQvcGNpL2hkYS9oZGFfY29kZWMuYw0KKysrIGIvc291bmQvcGNpL2hkYS9oZGFfY29kZWMuYw0K
QEAgLTYxNSw2ICs2MTUsOSBAQCBpbnQgc25kX2hkYV9xdWV1ZV91bnNvbF9ldmVudChzdHJ1Y3Qg
aGRhX2J1cyAqYnVzLCB1MzIgcmVzLCB1MzIgcmVzX2V4KQ0KIAlzdHJ1Y3QgaGRhX2J1c191bnNv
bGljaXRlZCAqdW5zb2w7DQogCXVuc2lnbmVkIGludCB3cDsNCiANCisJaWYgKCFidXMgfHwgIWJ1
cy0+d29ya3EpDQorCQlyZXR1cm4gMDsNCisNCiAJdHJhY2VfaGRhX3Vuc29sX2V2ZW50KGJ1cywg
cmVzLCByZXNfZXgpOw0KIAl1bnNvbCA9IGJ1cy0+dW5zb2w7DQogCWlmICghdW5zb2wpDQpkaWZm
IC0tZ2l0IGEvc291bmQvc29jL2NvZGVjcy93bTg5OTQuYyBiL3NvdW5kL3NvYy9jb2RlY3Mvd204
OTk0LmMNCmluZGV4IDk4YzU3NzQuLmI3M2YyMjYgMTAwNjQ0DQotLS0gYS9zb3VuZC9zb2MvY29k
ZWNzL3dtODk5NC5jDQorKysgYi9zb3VuZC9zb2MvY29kZWNzL3dtODk5NC5jDQpAQCAtMjYzNiw2
ICsyNjM2LDcgQEAgc3RhdGljIGludCB3bTg5OTRfYWlmM19od19wYXJhbXMoc3RydWN0IHNuZF9w
Y21fc3Vic3RyZWFtICpzdWJzdHJlYW0sDQogCQlkZWZhdWx0Og0KIAkJCXJldHVybiAwOw0KIAkJ
fQ0KKwkJYnJlYWs7DQogCWRlZmF1bHQ6DQogCQlyZXR1cm4gMDsNCiAJfQ0KZGlmZiAtLWdpdCBh
L3Rvb2xzL3BlcmYvc2NyaXB0cy9weXRob24vbmV0X2Ryb3Btb25pdG9yLnB5IGIvdG9vbHMvcGVy
Zi9zY3JpcHRzL3B5dGhvbi9uZXRfZHJvcG1vbml0b3IucHkNCmluZGV4IGE0ZmZjOTUuLjRjMTE2
MDUgMTAwNzU1DQotLS0gYS90b29scy9wZXJmL3NjcmlwdHMvcHl0aG9uL25ldF9kcm9wbW9uaXRv
ci5weQ0KKysrIGIvdG9vbHMvcGVyZi9zY3JpcHRzL3B5dGhvbi9uZXRfZHJvcG1vbml0b3IucHkN
CkBAIC00MCw5ICs0MCw5IEBAIGRlZiBnZXRfa2FsbHN5bXNfdGFibGUoKToNCiANCiBkZWYgZ2V0
X3N5bShzbG9jKToNCiAJbG9jID0gaW50KHNsb2MpDQotCWZvciBpIGluIGthbGxzeW1zOg0KLQkJ
aWYgKGlbJ2xvYyddID49IGxvYyk6DQotCQkJcmV0dXJuIChpWyduYW1lJ10sIGlbJ2xvYyddLWxv
YykNCisJZm9yIGkgaW4ga2FsbHN5bXNbOjotMV06DQorCQlpZiBsb2MgPj0gaVsnbG9jJ106DQor
CQkJcmV0dXJuIChpWyduYW1lJ10sIGxvYyAtIGlbJ2xvYyddKQ0KIAlyZXR1cm4gKE5vbmUsIDAp
DQogDQogZGVmIHByaW50X2Ryb3BfdGFibGUoKToNCkBAIC02NCw3ICs2NCw3IEBAIGRlZiB0cmFj
ZV9lbmQoKToNCiANCiAjIGNhbGxlZCBmcm9tIHBlcmYsIHdoZW4gaXQgZmluZHMgYSBjb3JyZXNw
b2luZGluZyBldmVudA0KIGRlZiBza2JfX2tmcmVlX3NrYihuYW1lLCBjb250ZXh0LCBjcHUsIHNl
YywgbnNlYywgcGlkLCBjb21tLA0KLQkJCXNrYmFkZHIsIHByb3RvY29sLCBsb2NhdGlvbik6DQor
CQkgICBza2JhZGRyLCBsb2NhdGlvbiwgcHJvdG9jb2wpOg0KIAlzbG9jYXRpb24gPSBzdHIobG9j
YXRpb24pDQogCXRyeToNCiAJCWRyb3BfbG9nW3Nsb2NhdGlvbl0gPSBkcm9wX2xvZ1tzbG9jYXRp
b25dICsgMQ0K


--=-NzSG5hEl+5MQYDZWXvGS--

--=-XQ5xUwkzSnDFCC5HbVNt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUaigQ+e/yOyVhhEJAQruYRAAoXEaOUrsg8G/c7exQgS5d2t4gB76RnUI
2M9/SiEJPqpUKR/FaJ8mMMqSzjQwcj6YnuqkAZ+Jl2mUJuOuvW1vR2jHgleKlP/t
tm4IZkcKp60jQ1oQhEL5PdyOZQOvUmke3kwBVplrgwtDscP6FOLWSNdx85Kni2yP
9NHbTdY70zvjPjq2ykupuV/Gkmiz95jninb1+Jx0Y5jZ6oB8ppElwDG4FjrWD8u5
Yn82iaK9FZstwj5IE4tkEQYm5G1Ps2W1noYbDXqfThIJmWTdNd7c4lIPAlCaSmLW
QIpNGnpURI37YvPWJ38uf+29nLEeASXQbzZE7AMrtOW/3UsncEIJ6GadvCoPffhf
YReljNKADG0UkWSTeNAOyCRr3lvRKPYBTwnSSn0qY+P04mt0JdLuz3X+xupi89hJ
cEuNdGaHmHVaBbV+TLBOBzcBVim2rMOSWabc4KJhzagJmeUQyAOZe3KDjzV1SqFG
/1hUs29vsxeEFLMV9fJyYr/mR/CxRWyqPWt4gsjuqET6HwjVVPLOaUJrXR6l3OuC
CS98lbLjG+mzbVVnrE6jfxI4A025hBYthl6g3eJQPpiLiy+nE3AZsNmI6MjxHZ4r
z2aL6deE5fUVkAWehrt4ZJPacgBUJ0awnfsFjJ6G6lGKBG74RmBUTAlDbiNdrXOC
nZPfECyLBTo=
=Rpky
-----END PGP SIGNATURE-----

--=-XQ5xUwkzSnDFCC5HbVNt--

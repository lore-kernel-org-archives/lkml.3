Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751419Ab3K2FZX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 00:25:23 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42640 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750929Ab3K2FZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 00:25:12 -0500
Message-ID: <1385702683.23855.92.camel@deadeye.wl.decadent.org.uk>
Subject: Linux 3.2.53
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, Jiri Slaby <jslaby@suse.cz>,
        stable@vger.kernel.org
Cc: lwn@lwn.net
Date: Fri, 29 Nov 2013 05:24:43 +0000
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-5Xbi80ZiWw58YThGko/+"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.215
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-5Xbi80ZiWw58YThGko/+
Content-Type: multipart/mixed; boundary="=-7U4VAK7Vn306YuVIShpD"


--=-7U4VAK7Vn306YuVIShpD
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.2.53 kernel.

All users of the 3.2 kernel series should upgrade.

The updated 3.2.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.2.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git

The diff from 3.2.52 is attached to this message.

Ben.

------------

 Makefile                                        |   2 +-
 arch/mips/include/asm/jump_label.h              |   2 +-
 arch/parisc/kernel/head.S                       |   4 +
 arch/parisc/kernel/traps.c                      |   6 +-
 arch/powerpc/include/asm/jump_label.h           |   2 +-
 arch/powerpc/kvm/book3s_hv_rmhandlers.S         |   2 +-
 arch/s390/include/asm/jump_label.h              |   2 +-
 arch/sparc/include/asm/jump_label.h             |   2 +-
 arch/tile/include/asm/percpu.h                  |  34 +++-
 arch/um/kernel/exitcode.c                       |   4 +-
 arch/x86/include/asm/cpufeature.h               |   2 +-
 arch/x86/include/asm/jump_label.h               |   2 +-
 arch/xtensa/kernel/signal.c                     |   2 +-
 drivers/ata/libata-eh.c                         |   6 +-
 drivers/char/random.c                           |  11 +-
 drivers/connector/cn_proc.c                     |  16 ++
 drivers/connector/connector.c                   |   7 +-
 drivers/gpu/drm/drm_drv.c                       |   9 +-
 drivers/gpu/drm/radeon/atombios_encoders.c      |   2 +-
 drivers/gpu/drm/radeon/evergreen.c              |   2 +-
 drivers/hwmon/applesmc.c                        |  13 ++
 drivers/md/dm-snap-persistent.c                 |  18 +-
 drivers/net/can/dev.c                           |  10 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c |   1 +
 drivers/net/ethernet/realtek/8139cp.c           |   1 +
 drivers/net/ethernet/ti/davinci_emac.c          |   3 +-
 drivers/net/wan/farsync.c                       |   1 +
 drivers/net/wan/wanxl.c                         |   1 +
 drivers/net/wireless/iwlwifi/iwl-2000.c         |  20 ---
 drivers/net/wireless/iwlwifi/iwl-6000.c         |  23 ++-
 drivers/net/wireless/iwlwifi/iwl-cfg.h          |   9 +-
 drivers/net/wireless/iwlwifi/iwl-pci.c          |  34 ++--
 drivers/net/wireless/rtlwifi/rtl8192cu/trx.c    |   3 +-
 drivers/net/xen-netback/common.h                |   1 +
 drivers/net/xen-netback/interface.c             |   3 +-
 drivers/net/xen-netback/netback.c               |  10 +-
 drivers/pci/setup-res.c                         |   3 +-
 drivers/scsi/aacraid/linit.c                    |   2 +
 drivers/staging/bcm/Bcmchar.c                   |   1 +
 drivers/staging/wlags49_h2/wl_priv.c            |   9 +-
 drivers/staging/zram/zram_drv.c                 |   2 +-
 drivers/target/target_core_pscsi.c              |   8 +-
 drivers/uio/uio.c                               |  16 +-
 drivers/usb/core/quirks.c                       |   6 +
 drivers/usb/host/xhci-hub.c                     |  28 ---
 drivers/usb/host/xhci-pci.c                     |  25 +++
 drivers/usb/host/xhci.c                         |  14 +-
 drivers/usb/host/xhci.h                         |   2 +
 drivers/usb/serial/option.c                     | 225 ++++++++++++++++++++=
+++-
 drivers/video/au1100fb.c                        |  28 +--
 drivers/video/au1200fb.c                        |  27 +--
 fs/ecryptfs/keystore.c                          |   3 +-
 fs/ext3/dir.c                                   | 167 +++++++++++++-----
 fs/ext3/hash.c                                  |   4 +-
 fs/ext4/dir.c                                   | 214 +++++++++++++++++---=
--
 fs/ext4/ext4.h                                  |   6 +-
 fs/ext4/hash.c                                  |   4 +-
 fs/ext4/xattr.c                                 |   2 +
 fs/jfs/jfs_inode.c                              |   3 +-
 fs/nfsd/vfs.c                                   |  33 ++--
 fs/nfsd/vfs.h                                   |   2 +
 fs/statfs.c                                     |   2 +-
 include/drm/drm_mode.h                          |   2 +
 include/linux/compiler-gcc.h                    |   3 +
 include/linux/compiler-gcc4.h                   |  15 ++
 include/linux/ext3_fs.h                         |   6 +-
 include/linux/fs.h                              |   6 +
 include/linux/perf_event.h                      |  12 +-
 include/linux/random.h                          |   1 +
 include/linux/skbuff.h                          |  15 ++
 include/linux/timex.h                           |  14 ++
 include/net/cipso_ipv4.h                        |   6 +-
 include/net/dst.h                               |  12 ++
 init/main.c                                     |   2 +
 kernel/events/ring_buffer.c                     |  31 +++-
 kernel/trace/trace.c                            |   5 +-
 lib/scatterlist.c                               |   3 +-
 net/8021q/vlan_netlink.c                        |   2 +-
 net/compat.c                                    |   2 +
 net/ipv4/inet_hashtables.c                      |   2 +-
 net/ipv4/ip_output.c                            |   2 +-
 net/ipv4/route.c                                |   2 +-
 net/ipv4/tcp_input.c                            |   5 +-
 net/ipv4/tcp_output.c                           |   9 +-
 net/ipv6/inet6_hashtables.c                     |   2 +-
 net/ipv6/ip6_output.c                           |   2 +-
 net/ipv6/route.c                                |  11 +-
 net/l2tp/l2tp_ppp.c                             |   4 +
 net/mac80211/ieee80211_i.h                      |   3 +
 net/mac80211/rx.c                               |   3 +
 net/mac80211/scan.c                             |  19 ++
 net/mac80211/status.c                           |   3 +
 net/netfilter/nf_conntrack_sip.c                |   2 +-
 net/sctp/output.c                               |   3 +-
 net/socket.c                                    |  24 ++-
 net/unix/af_unix.c                              |  10 ++
 net/wireless/radiotap.c                         |   7 +-
 sound/pci/hda/patch_realtek.c                   |   2 +
 sound/soc/codecs/wm_hubs.c                      |   1 +
 sound/soc/soc-dapm.c                            |   2 +-
 sound/usb/usx2y/usbusx2yaudio.c                 |  22 +--
 sound/usb/usx2y/usx2yhwdeppcm.c                 |   7 +-
 tools/perf/builtin-sched.c                      |   1 +
 103 files changed, 1022 insertions(+), 369 deletions(-)

Alex Deucher (1):
      drm/radeon/atom: workaround vbios bug in transmitter table on rs780

Baruch Siach (1):
      xtensa: don't use alternate signal stack on threads

Ben Hutchings (1):
      Linux 3.2.53

Bernd Schubert (3):
      fs: add new FMODE flags: FMODE_32bithash and FMODE_64bithash
      nfsd: rename 'int access' to 'int may_flags' in nfsd_open()
      nfsd: vfs_llseek() with 32 or 64 bit offsets (hashes)

Chris Metcalf (1):
      tile: use a more conservative __my_cpu_offset in CONFIG_PREEMPT

Chris Wilson (2):
      drm: Prevent overwriting from userspace underallocating core ioctl st=
ructs
      drm: Pad drm_mode_get_connector to 64-bit boundary

Dan Carpenter (5):
      net: heap overflow in __audit_sockaddr()
      uml: check length in exitcode_proc_write()
      aacraid: missing capable() check in compat ioctl
      staging: wlags49_h2: buffer overflow setting station name
      Staging: bcm: info leak in ioctl

Daniel Borkmann (1):
      net: unix: inherit SOCK_PASS{CRED, SEC} flags from socket to fix race

Daniel Mack (1):
      ALSA: snd-usb-usx2y: remove bogus frame checks

Daniel Santos (1):
      compiler-gcc.h: Add gcc-recommended GCC_VERSION macro

Dave Jones (1):
      ext4: fix memory leak in xattr

Dave Kleikamp (1):
      jfs: fix error path in ialloc

David Woodhouse (1):
      8139cp: re-enable interrupts after tx timeout

Emmanuel Grumbach (2):
      iwlwifi: pcie: add SKUs for 6000, 6005 and 6235 series
      mac80211: correctly close cancelled scans

Enrico Mioso (1):
      usb: serial: option: blacklist Olivetti Olicard200

Eric Dumazet (5):
      tcp: must unclone packets before mangling them
      tcp: do not forget FIN in tcp_shifted_skb()
      net: do not call sock_put() on TIMEWAIT sockets
      l2tp: must disable bh before calling l2tp_xmit_skb()
      bnx2x: record rx queue for LRO packets

Eric Sandeen (1):
      ext3: return 32/64-bit dir name hash according to usage type

Fan Du (2):
      sctp: Use software crc32 checksum when xfrm transform will happen.
      include/linux/fs.h: disable preempt when acquire i_size_seqcount writ=
e lock

Fan Yong (1):
      ext4: return 32/64-bit dir name hash according to usage type

Fangxiaozhi (Franko) (1):
      USB: support new huawei devices in option.c

Felix Fietkau (2):
      mac80211: drop spoofed packets in ad-hoc mode
      mac80211: update sta->last_rx on acked tx frames

Geyslan G. Bem (1):
      ecryptfs: Fix memory leakage in keystore.c

Greg Kroah-Hartman (1):
      USB: serial: option: add support for Inovia SEW858 device

Gwendal Grignou (1):
      libata: make ata_eh_qc_retry() bump scmd->allowed on bogus failures

Hannes Frederic Sowa (1):
      inet: fix possible memory corruption with UDP_CORK and UFO

Helge Deller (2):
      parisc: fix interruption handler to respect pagefault_disable()
      parisc: Do not crash 64bit SMP kernels on machines with >=3D 4GB RAM

Henrik Rydberg (1):
      hwmon: (applesmc) Always read until end of data

Ingo Molnar (1):
      compiler/gcc4: Add quirk for 'asm goto' miscompilation bug

Jiri Benc (1):
      ipv4: fix ineffective source address selection

Johannes Berg (1):
      wireless: radiotap: fix parsing buffer overrun

Linus Torvalds (2):
      vfs: allow O_PATH file descriptors for fstatfs()
      Fix a few incorrectly checked [io_]remap_pfn_range() calls

Marc Kleine-Budde (2):
      can: dev: fix nlmsg size calculation in can_get_size()
      net: vlan: fix nlmsg size calculation in vlan_get_size()

Marcelo Ricardo Leitner (1):
      ipv6: restrict neighbor entry creation to output flow

Mariusz Ceier (1):
      davinci_emac.c: Fix IFF_ALLMULTI setup

Mark Cave-Ayland (1):
      rtlwifi: rtl8192cu: Fix error in pointer arithmetic

Markus Trippelsdorf (1):
      perf tools: Fix getrusage() related build failure on glibc trunk

Mathias Krause (2):
      proc connector: fix info leaks
      connector: use nlmsg_len() to check message length

Mikulas Patocka (1):
      dm snapshot: fix data corruption

Ming Lei (1):
      lib/scatterlist.c: don't flush_kernel_dcache_page on slab page

Nikhil P Rao (1):
      PCI: fix truncation of resource size to 32 bits

Oliver Neukum (3):
      xhci: quirk for extra long delay for S4
      USB: quirks.c: add one device that cannot deal with suspension
      USB: quirks: add touchscreen that is dazzeled by remote wakeup

Patrick McHardy (1):
      netfilter: nf_ct_sip: don't drop packets with offsets pointing outsid=
e the packet

Paul Mackerras (1):
      KVM: PPC: Book3S HV: Fix typo in saving DSCR

Peter Zijlstra (1):
      perf: Fix perf ring buffer memory ordering

Salva Peir=C3=B3 (2):
      farsync: fix info leak in ioctl
      wanxl: fix info leak in ioctl

Sarah Sharp (1):
      xhci: Don't enable/disable RWE on bus suspend/resume.

Seif Mazareeb (1):
      net: fix cipso packet validation when !NETLABEL

Sergey Senozhatsky (1):
      zram: allow request end to coincide with disksize

Shuduo Sang (1):
      iwlwifi: add new pci id for 6x35 series

Steven Rostedt (1):
      tracing: Fix potential out-of-bounds in trace_get_user()

Takashi Iwai (5):
      ALSA: hda - Add fixup for ASUS N56VZ
      xhci: Fix spurious wakeups after S5 on Haswell
      ASoC: dapm: Fix source list debugfs outputs
      ALSA: hda - Add a fixup for ASUS N76VZ
      ASoC: wm_hubs: Add missing break in hp_supply_event()

Theodore Ts'o (2):
      random: run random_int_secret_init() run after all late_initcalls
      random: allow architectures to optionally define random_get_entropy()

Vlad Yasevich (2):
      net: dst: provide accessor function to dst->xfrm
      sctp: Perform software checksum if packet has to be fragmented.

Wei Liu (1):
      xen-netback: use jiffies_64 value to calculate credit timeout

Wei Yongjun (1):
      target/pscsi: fix return value check

Wey-Yi Guy (4):
      iwlwifi: two more SKUs for 6x05 series
      iwlwifi: remove un-supported SKUs
      iwlwifi: update pci subsystem id
      iwlwifi: one more sku added to 6x35 series

wojciech kapuscinski (1):
      drm/radeon: fix hw contexts for SUMO2 asics


--=20
Ben Hutchings
Usenet is essentially a HUGE group of people passing notes in class.
                      - Rachel Kadel, `A Quick Guide to Newsgroup Etiquette=
'

--=-7U4VAK7Vn306YuVIShpD
Content-Type: text/x-diff; charset="UTF-8"; name="linux-3.2.53.patch"
Content-Disposition: attachment; filename="linux-3.2.53.patch"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL01ha2VmaWxlIGIvTWFrZWZpbGUNCmluZGV4IDFkZDJjMDkuLjkwZjU3ZGMg
MTAwNjQ0DQotLS0gYS9NYWtlZmlsZQ0KKysrIGIvTWFrZWZpbGUNCkBAIC0xLDYgKzEsNiBAQA0K
IFZFUlNJT04gPSAzDQogUEFUQ0hMRVZFTCA9IDINCi1TVUJMRVZFTCA9IDUyDQorU1VCTEVWRUwg
PSA1Mw0KIEVYVFJBVkVSU0lPTiA9DQogTkFNRSA9IFNhYmVyLXRvb3RoZWQgU3F1aXJyZWwNCiAN
CmRpZmYgLS1naXQgYS9hcmNoL21pcHMvaW5jbHVkZS9hc20vanVtcF9sYWJlbC5oIGIvYXJjaC9t
aXBzL2luY2x1ZGUvYXNtL2p1bXBfbGFiZWwuaA0KaW5kZXggMTg4MWIzMS4uYjE5NTU5YyAxMDA2
NDQNCi0tLSBhL2FyY2gvbWlwcy9pbmNsdWRlL2FzbS9qdW1wX2xhYmVsLmgNCisrKyBiL2FyY2gv
bWlwcy9pbmNsdWRlL2FzbS9qdW1wX2xhYmVsLmgNCkBAIC0yMiw3ICsyMiw3IEBADQogDQogc3Rh
dGljIF9fYWx3YXlzX2lubGluZSBib29sIGFyY2hfc3RhdGljX2JyYW5jaChzdHJ1Y3QganVtcF9s
YWJlbF9rZXkgKmtleSkNCiB7DQotCWFzbSBnb3RvKCIxOlx0bm9wXG5cdCINCisJYXNtX3ZvbGF0
aWxlX2dvdG8oIjE6XHRub3Bcblx0Ig0KIAkJIm5vcFxuXHQiDQogCQkiLnB1c2hzZWN0aW9uIF9f
anVtcF90YWJsZSwgIFwiYXdcIlxuXHQiDQogCQlXT1JEX0lOU04gIiAxYiwgJWxbbF95ZXNdLCAl
MFxuXHQiDQpkaWZmIC0tZ2l0IGEvYXJjaC9wYXJpc2Mva2VybmVsL2hlYWQuUyBiL2FyY2gvcGFy
aXNjL2tlcm5lbC9oZWFkLlMNCmluZGV4IDM3YWFiZDcuLmQyZDU4MjUgMTAwNjQ0DQotLS0gYS9h
cmNoL3BhcmlzYy9rZXJuZWwvaGVhZC5TDQorKysgYi9hcmNoL3BhcmlzYy9rZXJuZWwvaGVhZC5T
DQpAQCAtMTk1LDYgKzE5NSw4IEBAIGNvbW1vbl9zdGV4dDoNCiAJbGR3ICAgICAgICAgICAgIE1F
TV9QRENfSEkoJXIwKSwlcjYNCiAJZGVwZCAgICAgICAgICAgICVyNiwgMzEsIDMyLCAlcjMgICAg
ICAgIC8qIG1vdmUgdG8gdXBwZXIgd29yZCAqLw0KIA0KKwltZmN0bAkJJWNyMzAsJXI2CQkvKiBQ
Q1gtVzIgZmlybXdhcmUgYnVnICovDQorDQogCWxkbyAgICAgICAgICAgICBQRENfUFNXKCVyMCks
JWFyZzAgICAgICAgICAgICAgIC8qIDIxICovDQogCWxkbyAgICAgICAgICAgICBQRENfUFNXX1NF
VF9ERUZBVUxUUyglcjApLCVhcmcxIC8qIDIgKi8NCiAJbGRvICAgICAgICAgICAgIFBEQ19QU1df
V0lERV9CSVQoJXIwKSwlYXJnMiAgICAgLyogMiAqLw0KQEAgLTIwMyw2ICsyMDUsOCBAQCBjb21t
b25fc3RleHQ6DQogCWNvcHkgICAgICAgICAgICAlcjAsJWFyZzMNCiANCiBzdGV4dF9wZGNfcmV0
Og0KKwltdGN0bAkJJXI2LCVjcjMwCQkvKiByZXN0b3JlIHRhc2sgdGhyZWFkIGluZm8gKi8NCisN
CiAJLyogcmVzdG9yZSByZmkgdGFyZ2V0IGFkZHJlc3MqLw0KIAlsZGQgICAgICAgICAgICAgVElf
VEFTSy1USFJFQURfU1pfQUxHTiglc3ApLCAlcjEwDQogCXRvcGh5c19yMSAgICAgICAlcjEwDQpk
aWZmIC0tZ2l0IGEvYXJjaC9wYXJpc2Mva2VybmVsL3RyYXBzLmMgYi9hcmNoL3BhcmlzYy9rZXJu
ZWwvdHJhcHMuYw0KaW5kZXggZjE5ZTY2MC4uY2Q4YjAyZiAxMDA2NDQNCi0tLSBhL2FyY2gvcGFy
aXNjL2tlcm5lbC90cmFwcy5jDQorKysgYi9hcmNoL3BhcmlzYy9rZXJuZWwvdHJhcHMuYw0KQEAg
LTgxMSwxNCArODExLDE0IEBAIHZvaWQgbm90cmFjZSBoYW5kbGVfaW50ZXJydXB0aW9uKGludCBj
b2RlLCBzdHJ1Y3QgcHRfcmVncyAqcmVncykNCiAJZWxzZSB7DQogDQogCSAgICAvKg0KLQkgICAg
ICogVGhlIGtlcm5lbCBzaG91bGQgbmV2ZXIgZmF1bHQgb24gaXRzIG93biBhZGRyZXNzIHNwYWNl
Lg0KKwkgICAgICogVGhlIGtlcm5lbCBzaG91bGQgbmV2ZXIgZmF1bHQgb24gaXRzIG93biBhZGRy
ZXNzIHNwYWNlLA0KKwkgICAgICogdW5sZXNzIHBhZ2VmYXVsdF9kaXNhYmxlKCkgd2FzIGNhbGxl
ZCBiZWZvcmUuDQogCSAgICAgKi8NCiANCi0JICAgIGlmIChmYXVsdF9zcGFjZSA9PSAwKSANCisJ
ICAgIGlmIChmYXVsdF9zcGFjZSA9PSAwICYmICFpbl9hdG9taWMoKSkNCiAJICAgIHsNCiAJCXBk
Y19jaGFzc2lzX3NlbmRfc3RhdHVzKFBEQ19DSEFTU0lTX0RJUkVDVF9QQU5JQyk7DQogCQlwYXJp
c2NfdGVybWluYXRlKCJLZXJuZWwgRmF1bHQiLCByZWdzLCBjb2RlLCBmYXVsdF9hZGRyZXNzKTsN
Ci0JDQogCSAgICB9DQogCX0NCiANCmRpZmYgLS1naXQgYS9hcmNoL3Bvd2VycGMvaW5jbHVkZS9h
c20vanVtcF9sYWJlbC5oIGIvYXJjaC9wb3dlcnBjL2luY2x1ZGUvYXNtL2p1bXBfbGFiZWwuaA0K
aW5kZXggOTM4OTg2ZS4uZWUzMzg4OCAxMDA2NDQNCi0tLSBhL2FyY2gvcG93ZXJwYy9pbmNsdWRl
L2FzbS9qdW1wX2xhYmVsLmgNCisrKyBiL2FyY2gvcG93ZXJwYy9pbmNsdWRlL2FzbS9qdW1wX2xh
YmVsLmgNCkBAIC0xOSw3ICsxOSw3IEBADQogDQogc3RhdGljIF9fYWx3YXlzX2lubGluZSBib29s
IGFyY2hfc3RhdGljX2JyYW5jaChzdHJ1Y3QganVtcF9sYWJlbF9rZXkgKmtleSkNCiB7DQotCWFz
bSBnb3RvKCIxOlxuXHQiDQorCWFzbV92b2xhdGlsZV9nb3RvKCIxOlxuXHQiDQogCQkgIm5vcFxu
XHQiDQogCQkgIi5wdXNoc2VjdGlvbiBfX2p1bXBfdGFibGUsICBcImF3XCJcblx0Ig0KIAkJIEpV
TVBfRU5UUllfVFlQRSAiMWIsICVsW2xfeWVzXSwgJWMwXG5cdCINCmRpZmYgLS1naXQgYS9hcmNo
L3Bvd2VycGMva3ZtL2Jvb2szc19odl9ybWhhbmRsZXJzLlMgYi9hcmNoL3Bvd2VycGMva3ZtL2Jv
b2szc19odl9ybWhhbmRsZXJzLlMNCmluZGV4IDVlOGRjMDguLmUzYjNjZjkgMTAwNjQ0DQotLS0g
YS9hcmNoL3Bvd2VycGMva3ZtL2Jvb2szc19odl9ybWhhbmRsZXJzLlMNCisrKyBiL2FyY2gvcG93
ZXJwYy9rdm0vYm9vazNzX2h2X3JtaGFuZGxlcnMuUw0KQEAgLTkyMiw3ICs5MjIsNyBAQCBFTkRf
RlRSX1NFQ1RJT05fSUZTRVQoQ1BVX0ZUUl9BUkNIXzIwNikNCiBCRUdJTl9GVFJfU0VDVElPTg0K
IAltZnNwcglyOCwgU1BSTl9EU0NSDQogCWxkCXI3LCBIU1RBVEVfRFNDUihyMTMpDQotCXN0ZAly
OCwgVkNQVV9EU0NSKHI3KQ0KKwlzdGQJcjgsIFZDUFVfRFNDUihyOSkNCiAJbXRzcHIJU1BSTl9E
U0NSLCByNw0KIEVORF9GVFJfU0VDVElPTl9JRlNFVChDUFVfRlRSX0FSQ0hfMjA2KQ0KIA0KZGlm
ZiAtLWdpdCBhL2FyY2gvczM5MC9pbmNsdWRlL2FzbS9qdW1wX2xhYmVsLmggYi9hcmNoL3MzOTAv
aW5jbHVkZS9hc20vanVtcF9sYWJlbC5oDQppbmRleCA5NWE2Y2YyLi44NTEyZDBhIDEwMDY0NA0K
LS0tIGEvYXJjaC9zMzkwL2luY2x1ZGUvYXNtL2p1bXBfbGFiZWwuaA0KKysrIGIvYXJjaC9zMzkw
L2luY2x1ZGUvYXNtL2p1bXBfbGFiZWwuaA0KQEAgLTE1LDcgKzE1LDcgQEANCiANCiBzdGF0aWMg
X19hbHdheXNfaW5saW5lIGJvb2wgYXJjaF9zdGF0aWNfYnJhbmNoKHN0cnVjdCBqdW1wX2xhYmVs
X2tleSAqa2V5KQ0KIHsNCi0JYXNtIGdvdG8oIjA6CWJyY2wgMCwwXG4iDQorCWFzbV92b2xhdGls
ZV9nb3RvKCIwOglicmNsIDAsMFxuIg0KIAkJIi5wdXNoc2VjdGlvbiBfX2p1bXBfdGFibGUsIFwi
YXdcIlxuIg0KIAkJQVNNX0FMSUdOICJcbiINCiAJCUFTTV9QVFIgIiAwYiwgJWxbbGFiZWxdLCAl
MFxuIg0KZGlmZiAtLWdpdCBhL2FyY2gvc3BhcmMvaW5jbHVkZS9hc20vanVtcF9sYWJlbC5oIGIv
YXJjaC9zcGFyYy9pbmNsdWRlL2FzbS9qdW1wX2xhYmVsLmgNCmluZGV4IGZjNzNhODIuLmUxN2I2
NWIgMTAwNjQ0DQotLS0gYS9hcmNoL3NwYXJjL2luY2x1ZGUvYXNtL2p1bXBfbGFiZWwuaA0KKysr
IGIvYXJjaC9zcGFyYy9pbmNsdWRlL2FzbS9qdW1wX2xhYmVsLmgNCkBAIC05LDcgKzksNyBAQA0K
IA0KIHN0YXRpYyBfX2Fsd2F5c19pbmxpbmUgYm9vbCBhcmNoX3N0YXRpY19icmFuY2goc3RydWN0
IGp1bXBfbGFiZWxfa2V5ICprZXkpDQogew0KLQkJYXNtIGdvdG8oIjE6XG5cdCINCisJCWFzbV92
b2xhdGlsZV9nb3RvKCIxOlxuXHQiDQogCQkJICJub3Bcblx0Ig0KIAkJCSAibm9wXG5cdCINCiAJ
CQkgIi5wdXNoc2VjdGlvbiBfX2p1bXBfdGFibGUsICBcImF3XCJcblx0Ig0KZGlmZiAtLWdpdCBh
L2FyY2gvdGlsZS9pbmNsdWRlL2FzbS9wZXJjcHUuaCBiL2FyY2gvdGlsZS9pbmNsdWRlL2FzbS9w
ZXJjcHUuaA0KaW5kZXggNjMyOTRmNS4uNGY3YWUzOSAxMDA2NDQNCi0tLSBhL2FyY2gvdGlsZS9p
bmNsdWRlL2FzbS9wZXJjcHUuaA0KKysrIGIvYXJjaC90aWxlL2luY2x1ZGUvYXNtL3BlcmNwdS5o
DQpAQCAtMTUsOSArMTUsMzcgQEANCiAjaWZuZGVmIF9BU01fVElMRV9QRVJDUFVfSA0KICNkZWZp
bmUgX0FTTV9USUxFX1BFUkNQVV9IDQogDQotcmVnaXN0ZXIgdW5zaWduZWQgbG9uZyBfX215X2Nw
dV9vZmZzZXQgX19hc21fXygidHAiKTsNCi0jZGVmaW5lIF9fbXlfY3B1X29mZnNldCBfX215X2Nw
dV9vZmZzZXQNCi0jZGVmaW5lIHNldF9teV9jcHVfb2Zmc2V0KHRwKSAoX19teV9jcHVfb2Zmc2V0
ID0gKHRwKSkNCityZWdpc3RlciB1bnNpZ25lZCBsb25nIG15X2NwdV9vZmZzZXRfcmVnIGFzbSgi
dHAiKTsNCisNCisjaWZkZWYgQ09ORklHX1BSRUVNUFQNCisvKg0KKyAqIEZvciBmdWxsIHByZWVt
cHRpb24sIHdlIGNhbid0IGp1c3QgdXNlIHRoZSByZWdpc3RlciB2YXJpYWJsZQ0KKyAqIGRpcmVj
dGx5LCBzaW5jZSB3ZSBuZWVkIGJhcnJpZXIoKSB0byBoYXphcmQgYWdhaW5zdCBpdCwgY2F1c2lu
ZyB0aGUNCisgKiBjb21waWxlciB0byByZWxvYWQgYW55dGhpbmcgY29tcHV0ZWQgZnJvbSBhIHBy
ZXZpb3VzICJ0cCIgdmFsdWUuDQorICogQnV0IHdlIGFsc28gZG9uJ3Qgd2FudCB0byB1c2Ugdm9s
YXRpbGUgYXNtLCBzaW5jZSB3ZSdkIGxpa2UgdGhlDQorICogY29tcGlsZXIgdG8gYmUgYWJsZSB0
byBjYWNoZSB0aGUgdmFsdWUgYWNyb3NzIG11bHRpcGxlIHBlcmNwdSByZWFkcy4NCisgKiBTbyB3
ZSB1c2UgYSBmYWtlIHN0YWNrIHJlYWQgYXMgYSBoYXphcmQgYWdhaW5zdCBiYXJyaWVyKCkuDQor
ICogVGhlICdVJyBjb25zdHJhaW50IGlzIGxpa2UgJ20nIGJ1dCBkaXNhbGxvd3MgcG9zdGluY3Jl
bWVudC4NCisgKi8NCitzdGF0aWMgaW5saW5lIHVuc2lnbmVkIGxvbmcgX19teV9jcHVfb2Zmc2V0
KHZvaWQpDQorew0KKwl1bnNpZ25lZCBsb25nIHRwOw0KKwlyZWdpc3RlciB1bnNpZ25lZCBsb25n
ICpzcCBhc20oInNwIik7DQorCWFzbSgibW92ZSAlMCwgdHAiIDogIj1yIiAodHApIDogIlUiICgq
c3ApKTsNCisJcmV0dXJuIHRwOw0KK30NCisjZGVmaW5lIF9fbXlfY3B1X29mZnNldCBfX215X2Nw
dV9vZmZzZXQoKQ0KKyNlbHNlDQorLyoNCisgKiBXZSBkb24ndCBuZWVkIHRvIGhhemFyZCBhZ2Fp
bnN0IGJhcnJpZXIoKSBzaW5jZSAidHAiIGRvZXNuJ3QgZXZlcg0KKyAqIGNoYW5nZSB3aXRoIFBS
RUVNUFRfTk9ORSwgYW5kIHdpdGggUFJFRU1QVF9WT0xVTlRBUlkgaXQgb25seQ0KKyAqIGNoYW5n
ZXMgYXQgZnVuY3Rpb24gY2FsbCBwb2ludHMsIGF0IHdoaWNoIHdlIGFyZSBhbHJlYWR5IHJlLXJl
YWRpbmcNCisgKiB0aGUgdmFsdWUgb2YgInRwIiBkdWUgdG8gIm15X2NwdV9vZmZzZXRfcmVnIiBi
ZWluZyBhIGdsb2JhbCB2YXJpYWJsZS4NCisgKi8NCisjZGVmaW5lIF9fbXlfY3B1X29mZnNldCBt
eV9jcHVfb2Zmc2V0X3JlZw0KKyNlbmRpZg0KKw0KKyNkZWZpbmUgc2V0X215X2NwdV9vZmZzZXQo
dHApIChteV9jcHVfb2Zmc2V0X3JlZyA9ICh0cCkpDQogDQogI2luY2x1ZGUgPGFzbS1nZW5lcmlj
L3BlcmNwdS5oPg0KIA0KZGlmZiAtLWdpdCBhL2FyY2gvdW0va2VybmVsL2V4aXRjb2RlLmMgYi9h
cmNoL3VtL2tlcm5lbC9leGl0Y29kZS5jDQppbmRleCA4MjlkZjQ5Li40MWViYmZlIDEwMDY0NA0K
LS0tIGEvYXJjaC91bS9rZXJuZWwvZXhpdGNvZGUuYw0KKysrIGIvYXJjaC91bS9rZXJuZWwvZXhp
dGNvZGUuYw0KQEAgLTQwLDkgKzQwLDExIEBAIHN0YXRpYyBzc2l6ZV90IGV4aXRjb2RlX3Byb2Nf
d3JpdGUoc3RydWN0IGZpbGUgKmZpbGUsDQogCQljb25zdCBjaGFyIF9fdXNlciAqYnVmZmVyLCBz
aXplX3QgY291bnQsIGxvZmZfdCAqcG9zKQ0KIHsNCiAJY2hhciAqZW5kLCBidWZbc2l6ZW9mKCJu
bm5ublwwIildOw0KKwlzaXplX3Qgc2l6ZTsNCiAJaW50IHRtcDsNCiANCi0JaWYgKGNvcHlfZnJv
bV91c2VyKGJ1ZiwgYnVmZmVyLCBjb3VudCkpDQorCXNpemUgPSBtaW4oY291bnQsIHNpemVvZihi
dWYpKTsNCisJaWYgKGNvcHlfZnJvbV91c2VyKGJ1ZiwgYnVmZmVyLCBzaXplKSkNCiAJCXJldHVy
biAtRUZBVUxUOw0KIA0KIAl0bXAgPSBzaW1wbGVfc3RydG9sKGJ1ZiwgJmVuZCwgMCk7DQpkaWZm
IC0tZ2l0IGEvYXJjaC94ODYvaW5jbHVkZS9hc20vY3B1ZmVhdHVyZS5oIGIvYXJjaC94ODYvaW5j
bHVkZS9hc20vY3B1ZmVhdHVyZS5oDQppbmRleCAwYzNiNzc1Li5hMzE1ZjFjIDEwMDY0NA0KLS0t
IGEvYXJjaC94ODYvaW5jbHVkZS9hc20vY3B1ZmVhdHVyZS5oDQorKysgYi9hcmNoL3g4Ni9pbmNs
dWRlL2FzbS9jcHVmZWF0dXJlLmgNCkBAIC0zMzQsNyArMzM0LDcgQEAgZXh0ZXJuIGNvbnN0IGNo
YXIgKiBjb25zdCB4ODZfcG93ZXJfZmxhZ3NbMzJdOw0KIHN0YXRpYyBfX2Fsd2F5c19pbmxpbmUg
X19wdXJlIGJvb2wgX19zdGF0aWNfY3B1X2hhcyh1MTYgYml0KQ0KIHsNCiAjaWYgX19HTlVDX18g
PiA0IHx8IF9fR05VQ19NSU5PUl9fID49IDUNCi0JCWFzbSBnb3RvKCIxOiBqbXAgJWxbdF9ub11c
biINCisJCWFzbV92b2xhdGlsZV9nb3RvKCIxOiBqbXAgJWxbdF9ub11cbiINCiAJCQkgIjI6XG4i
DQogCQkJICIuc2VjdGlvbiAuYWx0aW5zdHJ1Y3Rpb25zLFwiYVwiXG4iDQogCQkJICIgLmxvbmcg
MWIgLSAuXG4iDQpkaWZmIC0tZ2l0IGEvYXJjaC94ODYvaW5jbHVkZS9hc20vanVtcF9sYWJlbC5o
IGIvYXJjaC94ODYvaW5jbHVkZS9hc20vanVtcF9sYWJlbC5oDQppbmRleCBhMzJiMThjLi5lMTJj
MWJjIDEwMDY0NA0KLS0tIGEvYXJjaC94ODYvaW5jbHVkZS9hc20vanVtcF9sYWJlbC5oDQorKysg
Yi9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9qdW1wX2xhYmVsLmgNCkBAIC0xMyw3ICsxMyw3IEBADQog
DQogc3RhdGljIF9fYWx3YXlzX2lubGluZSBib29sIGFyY2hfc3RhdGljX2JyYW5jaChzdHJ1Y3Qg
anVtcF9sYWJlbF9rZXkgKmtleSkNCiB7DQotCWFzbSBnb3RvKCIxOiINCisJYXNtX3ZvbGF0aWxl
X2dvdG8oIjE6Ig0KIAkJSlVNUF9MQUJFTF9JTklUSUFMX05PUA0KIAkJIi5wdXNoc2VjdGlvbiBf
X2p1bXBfdGFibGUsICBcImF3XCIgXG5cdCINCiAJCV9BU01fQUxJR04gIlxuXHQiDQpkaWZmIC0t
Z2l0IGEvYXJjaC94dGVuc2Eva2VybmVsL3NpZ25hbC5jIGIvYXJjaC94dGVuc2Eva2VybmVsL3Np
Z25hbC5jDQppbmRleCBmMjIyMGI1Li5jZjNlOWNiIDEwMDY0NA0KLS0tIGEvYXJjaC94dGVuc2Ev
a2VybmVsL3NpZ25hbC5jDQorKysgYi9hcmNoL3h0ZW5zYS9rZXJuZWwvc2lnbmFsLmMNCkBAIC0z
NDYsNyArMzQ2LDcgQEAgc3RhdGljIHZvaWQgc2V0dXBfZnJhbWUoaW50IHNpZywgc3RydWN0IGtf
c2lnYWN0aW9uICprYSwgc2lnaW5mb190ICppbmZvLA0KIA0KIAlzcCA9IHJlZ3MtPmFyZWdbMV07
DQogDQotCWlmICgoa2EtPnNhLnNhX2ZsYWdzICYgU0FfT05TVEFDSykgIT0gMCAmJiAhIG9uX3Np
Z19zdGFjayhzcCkpIHsNCisJaWYgKChrYS0+c2Euc2FfZmxhZ3MgJiBTQV9PTlNUQUNLKSAhPSAw
ICYmIHNhc19zc19mbGFncyhzcCkgPT0gMCkgew0KIAkJc3AgPSBjdXJyZW50LT5zYXNfc3Nfc3Ag
KyBjdXJyZW50LT5zYXNfc3Nfc2l6ZTsNCiAJfQ0KIA0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvYXRh
L2xpYmF0YS1laC5jIGIvZHJpdmVycy9hdGEvbGliYXRhLWVoLmMNCmluZGV4IGFlYTYyN2UuLjdk
MWE0NzggMTAwNjQ0DQotLS0gYS9kcml2ZXJzL2F0YS9saWJhdGEtZWguYw0KKysrIGIvZHJpdmVy
cy9hdGEvbGliYXRhLWVoLmMNCkBAIC0xMjg2LDE0ICsxMjg2LDE0IEBAIHZvaWQgYXRhX2VoX3Fj
X2NvbXBsZXRlKHN0cnVjdCBhdGFfcXVldWVkX2NtZCAqcWMpDQogICoJc2hvdWxkIGJlIHJldHJp
ZWQuICBUbyBiZSB1c2VkIGZyb20gRUguDQogICoNCiAgKglTQ1NJIG1pZGxheWVyIGxpbWl0cyB0
aGUgbnVtYmVyIG9mIHJldHJpZXMgdG8gc2NtZC0+YWxsb3dlZC4NCi0gKglzY21kLT5yZXRyaWVz
IGlzIGRlY3JlbWVudGVkIGZvciBjb21tYW5kcyB3aGljaCBnZXQgcmV0cmllZA0KKyAqCXNjbWQt
PmFsbG93ZWQgaXMgaW5jcmVtZW50ZWQgZm9yIGNvbW1hbmRzIHdoaWNoIGdldCByZXRyaWVkDQog
ICoJZHVlIHRvIHVucmVsYXRlZCBmYWlsdXJlcyAocWMtPmVycl9tYXNrIGlzIHplcm8pLg0KICAq
Lw0KIHZvaWQgYXRhX2VoX3FjX3JldHJ5KHN0cnVjdCBhdGFfcXVldWVkX2NtZCAqcWMpDQogew0K
IAlzdHJ1Y3Qgc2NzaV9jbW5kICpzY21kID0gcWMtPnNjc2ljbWQ7DQotCWlmICghcWMtPmVycl9t
YXNrICYmIHNjbWQtPnJldHJpZXMpDQotCQlzY21kLT5yZXRyaWVzLS07DQorCWlmICghcWMtPmVy
cl9tYXNrKQ0KKwkJc2NtZC0+YWxsb3dlZCsrOw0KIAlfX2F0YV9laF9xY19jb21wbGV0ZShxYyk7
DQogfQ0KIA0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvY2hhci9yYW5kb20uYyBiL2RyaXZlcnMvY2hh
ci9yYW5kb20uYw0KaW5kZXggYjY1MTczMy4uYzI0NGYwZSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMv
Y2hhci9yYW5kb20uYw0KKysrIGIvZHJpdmVycy9jaGFyL3JhbmRvbS5jDQpAQCAtNjY4LDcgKzY2
OCw3IEBAIHN0YXRpYyB2b2lkIHNldF90aW1lcl9yYW5kX3N0YXRlKHVuc2lnbmVkIGludCBpcnEs
DQogICovDQogdm9pZCBhZGRfZGV2aWNlX3JhbmRvbW5lc3MoY29uc3Qgdm9pZCAqYnVmLCB1bnNp
Z25lZCBpbnQgc2l6ZSkNCiB7DQotCXVuc2lnbmVkIGxvbmcgdGltZSA9IGdldF9jeWNsZXMoKSBe
IGppZmZpZXM7DQorCXVuc2lnbmVkIGxvbmcgdGltZSA9IHJhbmRvbV9nZXRfZW50cm9weSgpIF4g
amlmZmllczsNCiANCiAJbWl4X3Bvb2xfYnl0ZXMoJmlucHV0X3Bvb2wsIGJ1Ziwgc2l6ZSwgTlVM
TCk7DQogCW1peF9wb29sX2J5dGVzKCZpbnB1dF9wb29sLCAmdGltZSwgc2l6ZW9mKHRpbWUpLCBO
VUxMKTsNCkBAIC03MDUsNyArNzA1LDcgQEAgc3RhdGljIHZvaWQgYWRkX3RpbWVyX3JhbmRvbW5l
c3Moc3RydWN0IHRpbWVyX3JhbmRfc3RhdGUgKnN0YXRlLCB1bnNpZ25lZCBudW0pDQogCQlnb3Rv
IG91dDsNCiANCiAJc2FtcGxlLmppZmZpZXMgPSBqaWZmaWVzOw0KLQlzYW1wbGUuY3ljbGVzID0g
Z2V0X2N5Y2xlcygpOw0KKwlzYW1wbGUuY3ljbGVzID0gcmFuZG9tX2dldF9lbnRyb3B5KCk7DQog
CXNhbXBsZS5udW0gPSBudW07DQogCW1peF9wb29sX2J5dGVzKCZpbnB1dF9wb29sLCAmc2FtcGxl
LCBzaXplb2Yoc2FtcGxlKSwgTlVMTCk7DQogDQpAQCAtNzcyLDcgKzc3Miw3IEBAIHZvaWQgYWRk
X2ludGVycnVwdF9yYW5kb21uZXNzKGludCBpcnEsIGludCBpcnFfZmxhZ3MpDQogCXN0cnVjdCBm
YXN0X3Bvb2wJKmZhc3RfcG9vbCA9ICZfX2dldF9jcHVfdmFyKGlycV9yYW5kb21uZXNzKTsNCiAJ
c3RydWN0IHB0X3JlZ3MJCSpyZWdzID0gZ2V0X2lycV9yZWdzKCk7DQogCXVuc2lnbmVkIGxvbmcJ
CW5vdyA9IGppZmZpZXM7DQotCV9fdTMyCQkJaW5wdXRbNF0sIGN5Y2xlcyA9IGdldF9jeWNsZXMo
KTsNCisJX191MzIJCQlpbnB1dFs0XSwgY3ljbGVzID0gcmFuZG9tX2dldF9lbnRyb3B5KCk7DQog
DQogCWlucHV0WzBdID0gY3ljbGVzIF4gamlmZmllczsNCiAJaW5wdXRbMV0gPSBpcnE7DQpAQCAt
MTQ4MCwxMiArMTQ4MCwxMSBAQCBjdGxfdGFibGUgcmFuZG9tX3RhYmxlW10gPSB7DQogDQogc3Rh
dGljIHUzMiByYW5kb21faW50X3NlY3JldFtNRDVfTUVTU0FHRV9CWVRFUyAvIDRdIF9fX19jYWNo
ZWxpbmVfYWxpZ25lZDsNCiANCi1zdGF0aWMgaW50IF9faW5pdCByYW5kb21faW50X3NlY3JldF9p
bml0KHZvaWQpDQoraW50IHJhbmRvbV9pbnRfc2VjcmV0X2luaXQodm9pZCkNCiB7DQogCWdldF9y
YW5kb21fYnl0ZXMocmFuZG9tX2ludF9zZWNyZXQsIHNpemVvZihyYW5kb21faW50X3NlY3JldCkp
Ow0KIAlyZXR1cm4gMDsNCiB9DQotbGF0ZV9pbml0Y2FsbChyYW5kb21faW50X3NlY3JldF9pbml0
KTsNCiANCiAvKg0KICAqIEdldCBhIHJhbmRvbSB3b3JkIGZvciBpbnRlcm5hbCBrZXJuZWwgdXNl
IG9ubHkuIFNpbWlsYXIgdG8gdXJhbmRvbSBidXQNCkBAIC0xNTA0LDcgKzE1MDMsNyBAQCB1bnNp
Z25lZCBpbnQgZ2V0X3JhbmRvbV9pbnQodm9pZCkNCiANCiAJaGFzaCA9IGdldF9jcHVfdmFyKGdl
dF9yYW5kb21faW50X2hhc2gpOw0KIA0KLQloYXNoWzBdICs9IGN1cnJlbnQtPnBpZCArIGppZmZp
ZXMgKyBnZXRfY3ljbGVzKCk7DQorCWhhc2hbMF0gKz0gY3VycmVudC0+cGlkICsgamlmZmllcyAr
IHJhbmRvbV9nZXRfZW50cm9weSgpOw0KIAltZDVfdHJhbnNmb3JtKGhhc2gsIHJhbmRvbV9pbnRf
c2VjcmV0KTsNCiAJcmV0ID0gaGFzaFswXTsNCiAJcHV0X2NwdV92YXIoZ2V0X3JhbmRvbV9pbnRf
aGFzaCk7DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9jb25uZWN0b3IvY25fcHJvYy5jIGIvZHJpdmVy
cy9jb25uZWN0b3IvY25fcHJvYy5jDQppbmRleCA0NmJiZjQzLi42NmQ1Mzg0IDEwMDY0NA0KLS0t
IGEvZHJpdmVycy9jb25uZWN0b3IvY25fcHJvYy5jDQorKysgYi9kcml2ZXJzL2Nvbm5lY3Rvci9j
bl9wcm9jLmMNCkBAIC02NCw2ICs2NCw3IEBAIHZvaWQgcHJvY19mb3JrX2Nvbm5lY3RvcihzdHJ1
Y3QgdGFza19zdHJ1Y3QgKnRhc2spDQogDQogCW1zZyA9IChzdHJ1Y3QgY25fbXNnKilidWZmZXI7
DQogCWV2ID0gKHN0cnVjdCBwcm9jX2V2ZW50Kiltc2ctPmRhdGE7DQorCW1lbXNldCgmZXYtPmV2
ZW50X2RhdGEsIDAsIHNpemVvZihldi0+ZXZlbnRfZGF0YSkpOw0KIAlnZXRfc2VxKCZtc2ctPnNl
cSwgJmV2LT5jcHUpOw0KIAlrdGltZV9nZXRfdHMoJnRzKTsgLyogZ2V0IGhpZ2ggcmVzIG1vbm90
b25pYyB0aW1lc3RhbXAgKi8NCiAJcHV0X3VuYWxpZ25lZCh0aW1lc3BlY190b19ucygmdHMpLCAo
X191NjQgKikmZXYtPnRpbWVzdGFtcF9ucyk7DQpAQCAtNzksNiArODAsNyBAQCB2b2lkIHByb2Nf
Zm9ya19jb25uZWN0b3Ioc3RydWN0IHRhc2tfc3RydWN0ICp0YXNrKQ0KIAltZW1jcHkoJm1zZy0+
aWQsICZjbl9wcm9jX2V2ZW50X2lkLCBzaXplb2YobXNnLT5pZCkpOw0KIAltc2ctPmFjayA9IDA7
IC8qIG5vdCB1c2VkICovDQogCW1zZy0+bGVuID0gc2l6ZW9mKCpldik7DQorCW1zZy0+ZmxhZ3Mg
PSAwOyAvKiBub3QgdXNlZCAqLw0KIAkvKiAgSWYgY25fbmV0bGlua19zZW5kKCkgZmFpbGVkLCB0
aGUgZGF0YSBpcyBub3Qgc2VudCAqLw0KIAljbl9uZXRsaW5rX3NlbmQobXNnLCBDTl9JRFhfUFJP
QywgR0ZQX0tFUk5FTCk7DQogfQ0KQEAgLTk1LDYgKzk3LDcgQEAgdm9pZCBwcm9jX2V4ZWNfY29u
bmVjdG9yKHN0cnVjdCB0YXNrX3N0cnVjdCAqdGFzaykNCiANCiAJbXNnID0gKHN0cnVjdCBjbl9t
c2cqKWJ1ZmZlcjsNCiAJZXYgPSAoc3RydWN0IHByb2NfZXZlbnQqKW1zZy0+ZGF0YTsNCisJbWVt
c2V0KCZldi0+ZXZlbnRfZGF0YSwgMCwgc2l6ZW9mKGV2LT5ldmVudF9kYXRhKSk7DQogCWdldF9z
ZXEoJm1zZy0+c2VxLCAmZXYtPmNwdSk7DQogCWt0aW1lX2dldF90cygmdHMpOyAvKiBnZXQgaGln
aCByZXMgbW9ub3RvbmljIHRpbWVzdGFtcCAqLw0KIAlwdXRfdW5hbGlnbmVkKHRpbWVzcGVjX3Rv
X25zKCZ0cyksIChfX3U2NCAqKSZldi0+dGltZXN0YW1wX25zKTsNCkBAIC0xMDUsNiArMTA4LDcg
QEAgdm9pZCBwcm9jX2V4ZWNfY29ubmVjdG9yKHN0cnVjdCB0YXNrX3N0cnVjdCAqdGFzaykNCiAJ
bWVtY3B5KCZtc2ctPmlkLCAmY25fcHJvY19ldmVudF9pZCwgc2l6ZW9mKG1zZy0+aWQpKTsNCiAJ
bXNnLT5hY2sgPSAwOyAvKiBub3QgdXNlZCAqLw0KIAltc2ctPmxlbiA9IHNpemVvZigqZXYpOw0K
Kwltc2ctPmZsYWdzID0gMDsgLyogbm90IHVzZWQgKi8NCiAJY25fbmV0bGlua19zZW5kKG1zZywg
Q05fSURYX1BST0MsIEdGUF9LRVJORUwpOw0KIH0NCiANCkBAIC0xMjEsNiArMTI1LDcgQEAgdm9p
ZCBwcm9jX2lkX2Nvbm5lY3RvcihzdHJ1Y3QgdGFza19zdHJ1Y3QgKnRhc2ssIGludCB3aGljaF9p
ZCkNCiANCiAJbXNnID0gKHN0cnVjdCBjbl9tc2cqKWJ1ZmZlcjsNCiAJZXYgPSAoc3RydWN0IHBy
b2NfZXZlbnQqKW1zZy0+ZGF0YTsNCisJbWVtc2V0KCZldi0+ZXZlbnRfZGF0YSwgMCwgc2l6ZW9m
KGV2LT5ldmVudF9kYXRhKSk7DQogCWV2LT53aGF0ID0gd2hpY2hfaWQ7DQogCWV2LT5ldmVudF9k
YXRhLmlkLnByb2Nlc3NfcGlkID0gdGFzay0+cGlkOw0KIAlldi0+ZXZlbnRfZGF0YS5pZC5wcm9j
ZXNzX3RnaWQgPSB0YXNrLT50Z2lkOw0KQEAgLTE0NCw2ICsxNDksNyBAQCB2b2lkIHByb2NfaWRf
Y29ubmVjdG9yKHN0cnVjdCB0YXNrX3N0cnVjdCAqdGFzaywgaW50IHdoaWNoX2lkKQ0KIAltZW1j
cHkoJm1zZy0+aWQsICZjbl9wcm9jX2V2ZW50X2lkLCBzaXplb2YobXNnLT5pZCkpOw0KIAltc2ct
PmFjayA9IDA7IC8qIG5vdCB1c2VkICovDQogCW1zZy0+bGVuID0gc2l6ZW9mKCpldik7DQorCW1z
Zy0+ZmxhZ3MgPSAwOyAvKiBub3QgdXNlZCAqLw0KIAljbl9uZXRsaW5rX3NlbmQobXNnLCBDTl9J
RFhfUFJPQywgR0ZQX0tFUk5FTCk7DQogfQ0KIA0KQEAgLTE1OSw2ICsxNjUsNyBAQCB2b2lkIHBy
b2Nfc2lkX2Nvbm5lY3RvcihzdHJ1Y3QgdGFza19zdHJ1Y3QgKnRhc2spDQogDQogCW1zZyA9IChz
dHJ1Y3QgY25fbXNnICopYnVmZmVyOw0KIAlldiA9IChzdHJ1Y3QgcHJvY19ldmVudCAqKW1zZy0+
ZGF0YTsNCisJbWVtc2V0KCZldi0+ZXZlbnRfZGF0YSwgMCwgc2l6ZW9mKGV2LT5ldmVudF9kYXRh
KSk7DQogCWdldF9zZXEoJm1zZy0+c2VxLCAmZXYtPmNwdSk7DQogCWt0aW1lX2dldF90cygmdHMp
OyAvKiBnZXQgaGlnaCByZXMgbW9ub3RvbmljIHRpbWVzdGFtcCAqLw0KIAlwdXRfdW5hbGlnbmVk
KHRpbWVzcGVjX3RvX25zKCZ0cyksIChfX3U2NCAqKSZldi0+dGltZXN0YW1wX25zKTsNCkBAIC0x
NjksNiArMTc2LDcgQEAgdm9pZCBwcm9jX3NpZF9jb25uZWN0b3Ioc3RydWN0IHRhc2tfc3RydWN0
ICp0YXNrKQ0KIAltZW1jcHkoJm1zZy0+aWQsICZjbl9wcm9jX2V2ZW50X2lkLCBzaXplb2YobXNn
LT5pZCkpOw0KIAltc2ctPmFjayA9IDA7IC8qIG5vdCB1c2VkICovDQogCW1zZy0+bGVuID0gc2l6
ZW9mKCpldik7DQorCW1zZy0+ZmxhZ3MgPSAwOyAvKiBub3QgdXNlZCAqLw0KIAljbl9uZXRsaW5r
X3NlbmQobXNnLCBDTl9JRFhfUFJPQywgR0ZQX0tFUk5FTCk7DQogfQ0KIA0KQEAgLTE4NCw2ICsx
OTIsNyBAQCB2b2lkIHByb2NfcHRyYWNlX2Nvbm5lY3RvcihzdHJ1Y3QgdGFza19zdHJ1Y3QgKnRh
c2ssIGludCBwdHJhY2VfaWQpDQogDQogCW1zZyA9IChzdHJ1Y3QgY25fbXNnICopYnVmZmVyOw0K
IAlldiA9IChzdHJ1Y3QgcHJvY19ldmVudCAqKW1zZy0+ZGF0YTsNCisJbWVtc2V0KCZldi0+ZXZl
bnRfZGF0YSwgMCwgc2l6ZW9mKGV2LT5ldmVudF9kYXRhKSk7DQogCWdldF9zZXEoJm1zZy0+c2Vx
LCAmZXYtPmNwdSk7DQogCWt0aW1lX2dldF90cygmdHMpOyAvKiBnZXQgaGlnaCByZXMgbW9ub3Rv
bmljIHRpbWVzdGFtcCAqLw0KIAlwdXRfdW5hbGlnbmVkKHRpbWVzcGVjX3RvX25zKCZ0cyksIChf
X3U2NCAqKSZldi0+dGltZXN0YW1wX25zKTsNCkBAIC0yMDIsNiArMjExLDcgQEAgdm9pZCBwcm9j
X3B0cmFjZV9jb25uZWN0b3Ioc3RydWN0IHRhc2tfc3RydWN0ICp0YXNrLCBpbnQgcHRyYWNlX2lk
KQ0KIAltZW1jcHkoJm1zZy0+aWQsICZjbl9wcm9jX2V2ZW50X2lkLCBzaXplb2YobXNnLT5pZCkp
Ow0KIAltc2ctPmFjayA9IDA7IC8qIG5vdCB1c2VkICovDQogCW1zZy0+bGVuID0gc2l6ZW9mKCpl
dik7DQorCW1zZy0+ZmxhZ3MgPSAwOyAvKiBub3QgdXNlZCAqLw0KIAljbl9uZXRsaW5rX3NlbmQo
bXNnLCBDTl9JRFhfUFJPQywgR0ZQX0tFUk5FTCk7DQogfQ0KIA0KQEAgLTIxNyw2ICsyMjcsNyBA
QCB2b2lkIHByb2NfY29tbV9jb25uZWN0b3Ioc3RydWN0IHRhc2tfc3RydWN0ICp0YXNrKQ0KIA0K
IAltc2cgPSAoc3RydWN0IGNuX21zZyAqKWJ1ZmZlcjsNCiAJZXYgPSAoc3RydWN0IHByb2NfZXZl
bnQgKiltc2ctPmRhdGE7DQorCW1lbXNldCgmZXYtPmV2ZW50X2RhdGEsIDAsIHNpemVvZihldi0+
ZXZlbnRfZGF0YSkpOw0KIAlnZXRfc2VxKCZtc2ctPnNlcSwgJmV2LT5jcHUpOw0KIAlrdGltZV9n
ZXRfdHMoJnRzKTsgLyogZ2V0IGhpZ2ggcmVzIG1vbm90b25pYyB0aW1lc3RhbXAgKi8NCiAJcHV0
X3VuYWxpZ25lZCh0aW1lc3BlY190b19ucygmdHMpLCAoX191NjQgKikmZXYtPnRpbWVzdGFtcF9u
cyk7DQpAQCAtMjI4LDYgKzIzOSw3IEBAIHZvaWQgcHJvY19jb21tX2Nvbm5lY3RvcihzdHJ1Y3Qg
dGFza19zdHJ1Y3QgKnRhc2spDQogCW1lbWNweSgmbXNnLT5pZCwgJmNuX3Byb2NfZXZlbnRfaWQs
IHNpemVvZihtc2ctPmlkKSk7DQogCW1zZy0+YWNrID0gMDsgLyogbm90IHVzZWQgKi8NCiAJbXNn
LT5sZW4gPSBzaXplb2YoKmV2KTsNCisJbXNnLT5mbGFncyA9IDA7IC8qIG5vdCB1c2VkICovDQog
CWNuX25ldGxpbmtfc2VuZChtc2csIENOX0lEWF9QUk9DLCBHRlBfS0VSTkVMKTsNCiB9DQogDQpA
QCAtMjQzLDYgKzI1NSw3IEBAIHZvaWQgcHJvY19leGl0X2Nvbm5lY3RvcihzdHJ1Y3QgdGFza19z
dHJ1Y3QgKnRhc2spDQogDQogCW1zZyA9IChzdHJ1Y3QgY25fbXNnKilidWZmZXI7DQogCWV2ID0g
KHN0cnVjdCBwcm9jX2V2ZW50Kiltc2ctPmRhdGE7DQorCW1lbXNldCgmZXYtPmV2ZW50X2RhdGEs
IDAsIHNpemVvZihldi0+ZXZlbnRfZGF0YSkpOw0KIAlnZXRfc2VxKCZtc2ctPnNlcSwgJmV2LT5j
cHUpOw0KIAlrdGltZV9nZXRfdHMoJnRzKTsgLyogZ2V0IGhpZ2ggcmVzIG1vbm90b25pYyB0aW1l
c3RhbXAgKi8NCiAJcHV0X3VuYWxpZ25lZCh0aW1lc3BlY190b19ucygmdHMpLCAoX191NjQgKikm
ZXYtPnRpbWVzdGFtcF9ucyk7DQpAQCAtMjU1LDYgKzI2OCw3IEBAIHZvaWQgcHJvY19leGl0X2Nv
bm5lY3RvcihzdHJ1Y3QgdGFza19zdHJ1Y3QgKnRhc2spDQogCW1lbWNweSgmbXNnLT5pZCwgJmNu
X3Byb2NfZXZlbnRfaWQsIHNpemVvZihtc2ctPmlkKSk7DQogCW1zZy0+YWNrID0gMDsgLyogbm90
IHVzZWQgKi8NCiAJbXNnLT5sZW4gPSBzaXplb2YoKmV2KTsNCisJbXNnLT5mbGFncyA9IDA7IC8q
IG5vdCB1c2VkICovDQogCWNuX25ldGxpbmtfc2VuZChtc2csIENOX0lEWF9QUk9DLCBHRlBfS0VS
TkVMKTsNCiB9DQogDQpAQCAtMjc4LDYgKzI5Miw3IEBAIHN0YXRpYyB2b2lkIGNuX3Byb2NfYWNr
KGludCBlcnIsIGludCByY3ZkX3NlcSwgaW50IHJjdmRfYWNrKQ0KIA0KIAltc2cgPSAoc3RydWN0
IGNuX21zZyopYnVmZmVyOw0KIAlldiA9IChzdHJ1Y3QgcHJvY19ldmVudCopbXNnLT5kYXRhOw0K
KwltZW1zZXQoJmV2LT5ldmVudF9kYXRhLCAwLCBzaXplb2YoZXYtPmV2ZW50X2RhdGEpKTsNCiAJ
bXNnLT5zZXEgPSByY3ZkX3NlcTsNCiAJa3RpbWVfZ2V0X3RzKCZ0cyk7IC8qIGdldCBoaWdoIHJl
cyBtb25vdG9uaWMgdGltZXN0YW1wICovDQogCXB1dF91bmFsaWduZWQodGltZXNwZWNfdG9fbnMo
JnRzKSwgKF9fdTY0ICopJmV2LT50aW1lc3RhbXBfbnMpOw0KQEAgLTI4Nyw2ICszMDIsNyBAQCBz
dGF0aWMgdm9pZCBjbl9wcm9jX2FjayhpbnQgZXJyLCBpbnQgcmN2ZF9zZXEsIGludCByY3ZkX2Fj
aykNCiAJbWVtY3B5KCZtc2ctPmlkLCAmY25fcHJvY19ldmVudF9pZCwgc2l6ZW9mKG1zZy0+aWQp
KTsNCiAJbXNnLT5hY2sgPSByY3ZkX2FjayArIDE7DQogCW1zZy0+bGVuID0gc2l6ZW9mKCpldik7
DQorCW1zZy0+ZmxhZ3MgPSAwOyAvKiBub3QgdXNlZCAqLw0KIAljbl9uZXRsaW5rX3NlbmQobXNn
LCBDTl9JRFhfUFJPQywgR0ZQX0tFUk5FTCk7DQogfQ0KIA0KZGlmZiAtLWdpdCBhL2RyaXZlcnMv
Y29ubmVjdG9yL2Nvbm5lY3Rvci5jIGIvZHJpdmVycy9jb25uZWN0b3IvY29ubmVjdG9yLmMNCmlu
ZGV4IGRkZTZhMGYuLmVhNmVmZTggMTAwNjQ0DQotLS0gYS9kcml2ZXJzL2Nvbm5lY3Rvci9jb25u
ZWN0b3IuYw0KKysrIGIvZHJpdmVycy9jb25uZWN0b3IvY29ubmVjdG9yLmMNCkBAIC0xNTcsMTcg
KzE1NywxOCBAQCBzdGF0aWMgaW50IGNuX2NhbGxfY2FsbGJhY2soc3RydWN0IHNrX2J1ZmYgKnNr
YikNCiBzdGF0aWMgdm9pZCBjbl9yeF9za2Ioc3RydWN0IHNrX2J1ZmYgKl9fc2tiKQ0KIHsNCiAJ
c3RydWN0IG5sbXNnaGRyICpubGg7DQotCWludCBlcnI7DQogCXN0cnVjdCBza19idWZmICpza2I7
DQorCWludCBsZW4sIGVycjsNCiANCiAJc2tiID0gc2tiX2dldChfX3NrYik7DQogDQogCWlmIChz
a2ItPmxlbiA+PSBOTE1TR19TUEFDRSgwKSkgew0KIAkJbmxoID0gbmxtc2dfaGRyKHNrYik7DQor
CQlsZW4gPSBubG1zZ19sZW4obmxoKTsNCiANCi0JCWlmIChubGgtPm5sbXNnX2xlbiA8IHNpemVv
ZihzdHJ1Y3QgY25fbXNnKSB8fA0KKwkJaWYgKGxlbiA8IChpbnQpc2l6ZW9mKHN0cnVjdCBjbl9t
c2cpIHx8DQogCQkgICAgc2tiLT5sZW4gPCBubGgtPm5sbXNnX2xlbiB8fA0KLQkJICAgIG5saC0+
bmxtc2dfbGVuID4gQ09OTkVDVE9SX01BWF9NU0dfU0laRSkgew0KKwkJICAgIGxlbiA+IENPTk5F
Q1RPUl9NQVhfTVNHX1NJWkUpIHsNCiAJCQlrZnJlZV9za2Ioc2tiKTsNCiAJCQlyZXR1cm47DQog
CQl9DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9ncHUvZHJtL2RybV9kcnYuYyBiL2RyaXZlcnMvZ3B1
L2RybS9kcm1fZHJ2LmMNCmluZGV4IDQwYzE4N2MuLmFjZmU1NjcgMTAwNjQ0DQotLS0gYS9kcml2
ZXJzL2dwdS9kcm0vZHJtX2Rydi5jDQorKysgYi9kcml2ZXJzL2dwdS9kcm0vZHJtX2Rydi5jDQpA
QCAtNDA4LDkgKzQwOCwxNiBAQCBsb25nIGRybV9pb2N0bChzdHJ1Y3QgZmlsZSAqZmlscCwNCiAJ
CQlhc2l6ZSA9IGRydl9zaXplOw0KIAl9DQogCWVsc2UgaWYgKChuciA+PSBEUk1fQ09NTUFORF9F
TkQpIHx8IChuciA8IERSTV9DT01NQU5EX0JBU0UpKSB7DQorCQl1MzIgZHJ2X3NpemU7DQorDQog
CQlpb2N0bCA9ICZkcm1faW9jdGxzW25yXTsNCi0JCWNtZCA9IGlvY3RsLT5jbWQ7DQorDQorCQlk
cnZfc2l6ZSA9IF9JT0NfU0laRShpb2N0bC0+Y21kKTsNCiAJCXVzaXplID0gYXNpemUgPSBfSU9D
X1NJWkUoY21kKTsNCisJCWlmIChkcnZfc2l6ZSA+IGFzaXplKQ0KKwkJCWFzaXplID0gZHJ2X3Np
emU7DQorDQorCQljbWQgPSBpb2N0bC0+Y21kOw0KIAl9IGVsc2UNCiAJCWdvdG8gZXJyX2kxOw0K
IA0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vYXRvbWJpb3NfZW5jb2RlcnMu
YyBiL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vYXRvbWJpb3NfZW5jb2RlcnMuYw0KaW5kZXggMzE3
MTI5NC4uNDc1YTI3NSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vYXRvbWJp
b3NfZW5jb2RlcnMuYw0KKysrIGIvZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9hdG9tYmlvc19lbmNv
ZGVycy5jDQpAQCAtMTM5MCw3ICsxMzkwLDcgQEAgcmFkZW9uX2F0b21fZW5jb2Rlcl9kcG1zX2Rp
ZyhzdHJ1Y3QgZHJtX2VuY29kZXIgKmVuY29kZXIsIGludCBtb2RlKQ0KIAkJCSAqIGRvZXMgdGhl
IHNhbWUgdGhpbmcgYW5kIG1vcmUuDQogCQkJICovDQogCQkJaWYgKChyZGV2LT5mYW1pbHkgIT0g
Q0hJUF9SVjcxMCkgJiYgKHJkZXYtPmZhbWlseSAhPSBDSElQX1JWNzMwKSAmJg0KLQkJCSAgICAo
cmRldi0+ZmFtaWx5ICE9IENISVBfUlM4ODApKQ0KKwkJCSAgICAocmRldi0+ZmFtaWx5ICE9IENI
SVBfUlM3ODApICYmIChyZGV2LT5mYW1pbHkgIT0gQ0hJUF9SUzg4MCkpDQogCQkJCWF0b21iaW9z
X2RpZ190cmFuc21pdHRlcl9zZXR1cChlbmNvZGVyLCBBVE9NX1RSQU5TTUlUVEVSX0FDVElPTl9F
TkFCTEVfT1VUUFVULCAwLCAwKTsNCiAJCX0NCiAJCWlmIChFTkNPREVSX01PREVfSVNfRFAoYXRv
bWJpb3NfZ2V0X2VuY29kZXJfbW9kZShlbmNvZGVyKSkgJiYgY29ubmVjdG9yKSB7DQpkaWZmIC0t
Z2l0IGEvZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9ldmVyZ3JlZW4uYyBiL2RyaXZlcnMvZ3B1L2Ry
bS9yYWRlb24vZXZlcmdyZWVuLmMNCmluZGV4IGE2ODA1N2EuLjVlZmJhNDcgMTAwNjQ0DQotLS0g
YS9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL2V2ZXJncmVlbi5jDQorKysgYi9kcml2ZXJzL2dwdS9k
cm0vcmFkZW9uL2V2ZXJncmVlbi5jDQpAQCAtMTc5Nyw3ICsxNzk3LDcgQEAgc3RhdGljIHZvaWQg
ZXZlcmdyZWVuX2dwdV9pbml0KHN0cnVjdCByYWRlb25fZGV2aWNlICpyZGV2KQ0KIAkJcmRldi0+
Y29uZmlnLmV2ZXJncmVlbi5zeF9tYXhfZXhwb3J0X3NpemUgPSAyNTY7DQogCQlyZGV2LT5jb25m
aWcuZXZlcmdyZWVuLnN4X21heF9leHBvcnRfcG9zX3NpemUgPSA2NDsNCiAJCXJkZXYtPmNvbmZp
Zy5ldmVyZ3JlZW4uc3hfbWF4X2V4cG9ydF9zbXhfc2l6ZSA9IDE5MjsNCi0JCXJkZXYtPmNvbmZp
Zy5ldmVyZ3JlZW4ubWF4X2h3X2NvbnRleHRzID0gODsNCisJCXJkZXYtPmNvbmZpZy5ldmVyZ3Jl
ZW4ubWF4X2h3X2NvbnRleHRzID0gNDsNCiAJCXJkZXYtPmNvbmZpZy5ldmVyZ3JlZW4uc3FfbnVt
X2NmX2luc3RzID0gMjsNCiANCiAJCXJkZXYtPmNvbmZpZy5ldmVyZ3JlZW4uc2NfcHJpbV9maWZv
X3NpemUgPSAweDQwOw0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvaHdtb24vYXBwbGVzbWMuYyBiL2Ry
aXZlcnMvaHdtb24vYXBwbGVzbWMuYw0KaW5kZXggMzBjYWM1OC4uMGI4NmQ0NyAxMDA2NDQNCi0t
LSBhL2RyaXZlcnMvaHdtb24vYXBwbGVzbWMuYw0KKysrIGIvZHJpdmVycy9od21vbi9hcHBsZXNt
Yy5jDQpAQCAtMjEyLDYgKzIxMiw3IEBAIHN0YXRpYyBpbnQgc2VuZF9hcmd1bWVudChjb25zdCBj
aGFyICprZXkpDQogDQogc3RhdGljIGludCByZWFkX3NtYyh1OCBjbWQsIGNvbnN0IGNoYXIgKmtl
eSwgdTggKmJ1ZmZlciwgdTggbGVuKQ0KIHsNCisJdTggc3RhdHVzLCBkYXRhID0gMDsNCiAJaW50
IGk7DQogDQogCWlmIChzZW5kX2NvbW1hbmQoY21kKSB8fCBzZW5kX2FyZ3VtZW50KGtleSkpIHsN
CkBAIC0yMTksNiArMjIwLDcgQEAgc3RhdGljIGludCByZWFkX3NtYyh1OCBjbWQsIGNvbnN0IGNo
YXIgKmtleSwgdTggKmJ1ZmZlciwgdTggbGVuKQ0KIAkJcmV0dXJuIC1FSU87DQogCX0NCiANCisJ
LyogVGhpcyBoYXMgbm8gZWZmZWN0IG9uIG5ld2VyICgyMDEyKSBTTUNzICovDQogCW91dGIobGVu
LCBBUFBMRVNNQ19EQVRBX1BPUlQpOw0KIA0KIAlmb3IgKGkgPSAwOyBpIDwgbGVuOyBpKyspIHsN
CkBAIC0yMjksNiArMjMxLDE3IEBAIHN0YXRpYyBpbnQgcmVhZF9zbWModTggY21kLCBjb25zdCBj
aGFyICprZXksIHU4ICpidWZmZXIsIHU4IGxlbikNCiAJCWJ1ZmZlcltpXSA9IGluYihBUFBMRVNN
Q19EQVRBX1BPUlQpOw0KIAl9DQogDQorCS8qIFJlYWQgdGhlIGRhdGEgcG9ydCB1bnRpbCBiaXQw
IGlzIGNsZWFyZWQgKi8NCisJZm9yIChpID0gMDsgaSA8IDE2OyBpKyspIHsNCisJCXVkZWxheShB
UFBMRVNNQ19NSU5fV0FJVCk7DQorCQlzdGF0dXMgPSBpbmIoQVBQTEVTTUNfQ01EX1BPUlQpOw0K
KwkJaWYgKCEoc3RhdHVzICYgMHgwMSkpDQorCQkJYnJlYWs7DQorCQlkYXRhID0gaW5iKEFQUExF
U01DX0RBVEFfUE9SVCk7DQorCX0NCisJaWYgKGkpDQorCQlwcl93YXJuKCJmbHVzaGVkICVkIGJ5
dGVzLCBsYXN0IHZhbHVlIGlzOiAlZFxuIiwgaSwgZGF0YSk7DQorDQogCXJldHVybiAwOw0KIH0N
CiANCmRpZmYgLS1naXQgYS9kcml2ZXJzL21kL2RtLXNuYXAtcGVyc2lzdGVudC5jIGIvZHJpdmVy
cy9tZC9kbS1zbmFwLXBlcnNpc3RlbnQuYw0KaW5kZXggM2FjNDE1Ni4uNzVjMTgyYiAxMDA2NDQN
Ci0tLSBhL2RyaXZlcnMvbWQvZG0tc25hcC1wZXJzaXN0ZW50LmMNCisrKyBiL2RyaXZlcnMvbWQv
ZG0tc25hcC1wZXJzaXN0ZW50LmMNCkBAIC0yNjksNiArMjY5LDE0IEBAIHN0YXRpYyBjaHVua190
IGFyZWFfbG9jYXRpb24oc3RydWN0IHBzdG9yZSAqcHMsIGNodW5rX3QgYXJlYSkNCiAJcmV0dXJu
IE5VTV9TTkFQU0hPVF9IRFJfQ0hVTktTICsgKChwcy0+ZXhjZXB0aW9uc19wZXJfYXJlYSArIDEp
ICogYXJlYSk7DQogfQ0KIA0KK3N0YXRpYyB2b2lkIHNraXBfbWV0YWRhdGEoc3RydWN0IHBzdG9y
ZSAqcHMpDQorew0KKwl1aW50MzJfdCBzdHJpZGUgPSBwcy0+ZXhjZXB0aW9uc19wZXJfYXJlYSAr
IDE7DQorCWNodW5rX3QgbmV4dF9mcmVlID0gcHMtPm5leHRfZnJlZTsNCisJaWYgKHNlY3Rvcl9k
aXYobmV4dF9mcmVlLCBzdHJpZGUpID09IE5VTV9TTkFQU0hPVF9IRFJfQ0hVTktTKQ0KKwkJcHMt
Pm5leHRfZnJlZSsrOw0KK30NCisNCiAvKg0KICAqIFJlYWQgb3Igd3JpdGUgYSBtZXRhZGF0YSBh
cmVhLiAgUmVtZW1iZXJpbmcgdG8gc2tpcCB0aGUgZmlyc3QNCiAgKiBjaHVuayB3aGljaCBob2xk
cyB0aGUgaGVhZGVyLg0KQEAgLTUwMiw2ICs1MTAsOCBAQCBzdGF0aWMgaW50IHJlYWRfZXhjZXB0
aW9ucyhzdHJ1Y3QgcHN0b3JlICpwcywNCiANCiAJcHMtPmN1cnJlbnRfYXJlYS0tOw0KIA0KKwlz
a2lwX21ldGFkYXRhKHBzKTsNCisNCiAJcmV0dXJuIDA7DQogfQ0KIA0KQEAgLTYxNiw4ICs2MjYs
NiBAQCBzdGF0aWMgaW50IHBlcnNpc3RlbnRfcHJlcGFyZV9leGNlcHRpb24oc3RydWN0IGRtX2V4
Y2VwdGlvbl9zdG9yZSAqc3RvcmUsDQogCQkJCQlzdHJ1Y3QgZG1fZXhjZXB0aW9uICplKQ0KIHsN
CiAJc3RydWN0IHBzdG9yZSAqcHMgPSBnZXRfaW5mbyhzdG9yZSk7DQotCXVpbnQzMl90IHN0cmlk
ZTsNCi0JY2h1bmtfdCBuZXh0X2ZyZWU7DQogCXNlY3Rvcl90IHNpemUgPSBnZXRfZGV2X3NpemUo
ZG1fc25hcF9jb3coc3RvcmUtPnNuYXApLT5iZGV2KTsNCiANCiAJLyogSXMgdGhlcmUgZW5vdWdo
IHJvb20gPyAqLw0KQEAgLTYzMCwxMCArNjM4LDggQEAgc3RhdGljIGludCBwZXJzaXN0ZW50X3By
ZXBhcmVfZXhjZXB0aW9uKHN0cnVjdCBkbV9leGNlcHRpb25fc3RvcmUgKnN0b3JlLA0KIAkgKiBN
b3ZlIG9udG8gdGhlIG5leHQgZnJlZSBwZW5kaW5nLCBtYWtpbmcgc3VyZSB0byB0YWtlDQogCSAq
IGludG8gYWNjb3VudCB0aGUgbG9jYXRpb24gb2YgdGhlIG1ldGFkYXRhIGNodW5rcy4NCiAJICov
DQotCXN0cmlkZSA9IChwcy0+ZXhjZXB0aW9uc19wZXJfYXJlYSArIDEpOw0KLQluZXh0X2ZyZWUg
PSArK3BzLT5uZXh0X2ZyZWU7DQotCWlmIChzZWN0b3JfZGl2KG5leHRfZnJlZSwgc3RyaWRlKSA9
PSAxKQ0KLQkJcHMtPm5leHRfZnJlZSsrOw0KKwlwcy0+bmV4dF9mcmVlKys7DQorCXNraXBfbWV0
YWRhdGEocHMpOw0KIA0KIAlhdG9taWNfaW5jKCZwcy0+cGVuZGluZ19jb3VudCk7DQogCXJldHVy
biAwOw0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2Nhbi9kZXYuYyBiL2RyaXZlcnMvbmV0L2Nh
bi9kZXYuYw0KaW5kZXggYTMxOTA1Ny4uZGU4N2Y4MiAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0
L2Nhbi9kZXYuYw0KKysrIGIvZHJpdmVycy9uZXQvY2FuL2Rldi5jDQpAQCAtNjU4LDE0ICs2NTgs
MTQgQEAgc3RhdGljIHNpemVfdCBjYW5fZ2V0X3NpemUoY29uc3Qgc3RydWN0IG5ldF9kZXZpY2Ug
KmRldikNCiAJc2l6ZV90IHNpemU7DQogDQogCXNpemUgPSBubGFfdG90YWxfc2l6ZShzaXplb2Yo
dTMyKSk7ICAgLyogSUZMQV9DQU5fU1RBVEUgKi8NCi0Jc2l6ZSArPSBzaXplb2Yoc3RydWN0IGNh
bl9jdHJsbW9kZSk7ICAvKiBJRkxBX0NBTl9DVFJMTU9ERSAqLw0KKwlzaXplICs9IG5sYV90b3Rh
bF9zaXplKHNpemVvZihzdHJ1Y3QgY2FuX2N0cmxtb2RlKSk7ICAvKiBJRkxBX0NBTl9DVFJMTU9E
RSAqLw0KIAlzaXplICs9IG5sYV90b3RhbF9zaXplKHNpemVvZih1MzIpKTsgIC8qIElGTEFfQ0FO
X1JFU1RBUlRfTVMgKi8NCi0Jc2l6ZSArPSBzaXplb2Yoc3RydWN0IGNhbl9iaXR0aW1pbmcpOyAv
KiBJRkxBX0NBTl9CSVRUSU1JTkcgKi8NCi0Jc2l6ZSArPSBzaXplb2Yoc3RydWN0IGNhbl9jbG9j
ayk7ICAgICAvKiBJRkxBX0NBTl9DTE9DSyAqLw0KKwlzaXplICs9IG5sYV90b3RhbF9zaXplKHNp
emVvZihzdHJ1Y3QgY2FuX2JpdHRpbWluZykpOyAvKiBJRkxBX0NBTl9CSVRUSU1JTkcgKi8NCisJ
c2l6ZSArPSBubGFfdG90YWxfc2l6ZShzaXplb2Yoc3RydWN0IGNhbl9jbG9jaykpOyAgICAgLyog
SUZMQV9DQU5fQ0xPQ0sgKi8NCiAJaWYgKHByaXYtPmRvX2dldF9iZXJyX2NvdW50ZXIpICAgICAg
ICAvKiBJRkxBX0NBTl9CRVJSX0NPVU5URVIgKi8NCi0JCXNpemUgKz0gc2l6ZW9mKHN0cnVjdCBj
YW5fYmVycl9jb3VudGVyKTsNCisJCXNpemUgKz0gbmxhX3RvdGFsX3NpemUoc2l6ZW9mKHN0cnVj
dCBjYW5fYmVycl9jb3VudGVyKSk7DQogCWlmIChwcml2LT5iaXR0aW1pbmdfY29uc3QpCSAgICAg
IC8qIElGTEFfQ0FOX0JJVFRJTUlOR19DT05TVCAqLw0KLQkJc2l6ZSArPSBzaXplb2Yoc3RydWN0
IGNhbl9iaXR0aW1pbmdfY29uc3QpOw0KKwkJc2l6ZSArPSBubGFfdG90YWxfc2l6ZShzaXplb2Yo
c3RydWN0IGNhbl9iaXR0aW1pbmdfY29uc3QpKTsNCiANCiAJcmV0dXJuIHNpemU7DQogfQ0KZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2Jyb2FkY29tL2JueDJ4L2JueDJ4X2Ntbi5j
IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvYnJvYWRjb20vYm54MngvYm54MnhfY21uLmMNCmluZGV4
IDRjNTBhYzAuLmJiYjY2OTIgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9icm9h
ZGNvbS9ibngyeC9ibngyeF9jbW4uYw0KKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvYnJvYWRj
b20vYm54MngvYm54MnhfY21uLmMNCkBAIC01MTYsNiArNTE2LDcgQEAgc3RhdGljIHZvaWQgYm54
MnhfdHBhX3N0b3Aoc3RydWN0IGJueDJ4ICpicCwgc3RydWN0IGJueDJ4X2Zhc3RwYXRoICpmcCwN
CiAJCWlmICghYm54MnhfZmlsbF9mcmFnX3NrYihicCwgZnAsIHF1ZXVlLCBza2IsIGNxZSwgY3Fl
X2lkeCkpIHsNCiAJCQlpZiAodHBhX2luZm8tPnBhcnNpbmdfZmxhZ3MgJiBQQVJTSU5HX0ZMQUdT
X1ZMQU4pDQogCQkJCV9fdmxhbl9od2FjY2VsX3B1dF90YWcoc2tiLCB0cGFfaW5mby0+dmxhbl90
YWcpOw0KKwkJCXNrYl9yZWNvcmRfcnhfcXVldWUoc2tiLCBmcC0+aW5kZXgpOw0KIAkJCW5hcGlf
Z3JvX3JlY2VpdmUoJmZwLT5uYXBpLCBza2IpOw0KIAkJfSBlbHNlIHsNCiAJCQlEUChORVRJRl9N
U0dfUlhfU1RBVFVTLCAiRmFpbGVkIHRvIGFsbG9jYXRlIG5ldyBwYWdlcyINCmRpZmYgLS1naXQg
YS9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZWFsdGVrLzgxMzljcC5jIGIvZHJpdmVycy9uZXQvZXRo
ZXJuZXQvcmVhbHRlay84MTM5Y3AuYw0KaW5kZXggNDIzNmI4Mi4uNGFhODMwZiAxMDA2NDQNCi0t
LSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlYWx0ZWsvODEzOWNwLmMNCisrKyBiL2RyaXZlcnMv
bmV0L2V0aGVybmV0L3JlYWx0ZWsvODEzOWNwLmMNCkBAIC0xMjM0LDYgKzEyMzQsNyBAQCBzdGF0
aWMgdm9pZCBjcF90eF90aW1lb3V0KHN0cnVjdCBuZXRfZGV2aWNlICpkZXYpDQogCWNwX2NsZWFu
X3JpbmdzKGNwKTsNCiAJcmMgPSBjcF9pbml0X3JpbmdzKGNwKTsNCiAJY3Bfc3RhcnRfaHcoY3Ap
Ow0KKwljcF9lbmFibGVfaXJxKGNwKTsNCiANCiAJbmV0aWZfd2FrZV9xdWV1ZShkZXYpOw0KIA0K
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3RpL2RhdmluY2lfZW1hYy5jIGIvZHJp
dmVycy9uZXQvZXRoZXJuZXQvdGkvZGF2aW5jaV9lbWFjLmMNCmluZGV4IGZkODExNWUuLjEwNjY4
ZWIgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC90aS9kYXZpbmNpX2VtYWMuYw0K
KysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvdGkvZGF2aW5jaV9lbWFjLmMNCkBAIC04NzMsOCAr
ODczLDcgQEAgc3RhdGljIHZvaWQgZW1hY19kZXZfbWNhc3Rfc2V0KHN0cnVjdCBuZXRfZGV2aWNl
ICpuZGV2KQ0KIAkJICAgIG5ldGRldl9tY19jb3VudChuZGV2KSA+IEVNQUNfREVGX01BWF9NVUxU
SUNBU1RfQUREUkVTU0VTKSB7DQogCQkJbWJwX2VuYWJsZSA9IChtYnBfZW5hYmxlIHwgRU1BQ19N
QlBfUlhNQ0FTVCk7DQogCQkJZW1hY19hZGRfbWNhc3QocHJpdiwgRU1BQ19BTExfTVVMVElfU0VU
LCBOVUxMKTsNCi0JCX0NCi0JCWlmICghbmV0ZGV2X21jX2VtcHR5KG5kZXYpKSB7DQorCQl9IGVs
c2UgaWYgKCFuZXRkZXZfbWNfZW1wdHkobmRldikpIHsNCiAJCQlzdHJ1Y3QgbmV0ZGV2X2h3X2Fk
ZHIgKmhhOw0KIA0KIAkJCW1icF9lbmFibGUgPSAobWJwX2VuYWJsZSB8IEVNQUNfTUJQX1JYTUNB
U1QpOw0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dhbi9mYXJzeW5jLmMgYi9kcml2ZXJzL25l
dC93YW4vZmFyc3luYy5jDQppbmRleCBlYmI5ZjI0Li43YTRjNDkxIDEwMDY0NA0KLS0tIGEvZHJp
dmVycy9uZXQvd2FuL2ZhcnN5bmMuYw0KKysrIGIvZHJpdmVycy9uZXQvd2FuL2ZhcnN5bmMuYw0K
QEAgLTE5NzIsNiArMTk3Miw3IEBAIGZzdF9nZXRfaWZhY2Uoc3RydWN0IGZzdF9jYXJkX2luZm8g
KmNhcmQsIHN0cnVjdCBmc3RfcG9ydF9pbmZvICpwb3J0LA0KIAl9DQogDQogCWkgPSBwb3J0LT5p
bmRleDsNCisJbWVtc2V0KCZzeW5jLCAwLCBzaXplb2Yoc3luYykpOw0KIAlzeW5jLmNsb2NrX3Jh
dGUgPSBGU1RfUkRMKGNhcmQsIHBvcnRDb25maWdbaV0ubGluZVNwZWVkKTsNCiAJLyogTHVja3kg
Y2FyZCBhbmQgbGludXggdXNlIHNhbWUgZW5jb2RpbmcgaGVyZSAqLw0KIAlzeW5jLmNsb2NrX3R5
cGUgPSBGU1RfUkRCKGNhcmQsIHBvcnRDb25maWdbaV0uaW50ZXJuYWxDbG9jaykgPT0NCmRpZmYg
LS1naXQgYS9kcml2ZXJzL25ldC93YW4vd2FueGwuYyBiL2RyaXZlcnMvbmV0L3dhbi93YW54bC5j
DQppbmRleCA0NGI3MDcxLi5jNjQzZDc3IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvd2FuL3dh
bnhsLmMNCisrKyBiL2RyaXZlcnMvbmV0L3dhbi93YW54bC5jDQpAQCAtMzU1LDYgKzM1NSw3IEBA
IHN0YXRpYyBpbnQgd2FueGxfaW9jdGwoc3RydWN0IG5ldF9kZXZpY2UgKmRldiwgc3RydWN0IGlm
cmVxICppZnIsIGludCBjbWQpDQogCQkJaWZyLT5pZnJfc2V0dGluZ3Muc2l6ZSA9IHNpemU7IC8q
IGRhdGEgc2l6ZSB3YW50ZWQgKi8NCiAJCQlyZXR1cm4gLUVOT0JVRlM7DQogCQl9DQorCQltZW1z
ZXQoJmxpbmUsIDAsIHNpemVvZihsaW5lKSk7DQogCQlsaW5lLmNsb2NrX3R5cGUgPSBnZXRfc3Rh
dHVzKHBvcnQpLT5jbG9ja2luZzsNCiAJCWxpbmUuY2xvY2tfcmF0ZSA9IDA7DQogCQlsaW5lLmxv
b3BiYWNrID0gMDsNCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC93aXJlbGVzcy9pd2x3aWZpL2l3
bC0yMDAwLmMgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9pd2x3aWZpL2l3bC0yMDAwLmMNCmluZGV4
IGE5N2E1MmEuLjQwODQ3N2QgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9pd2x3
aWZpL2l3bC0yMDAwLmMNCisrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2l3bHdpZmkvaXdsLTIw
MDAuYw0KQEAgLTI3MCwxMSArMjcwLDYgQEAgc3RydWN0IGl3bF9jZmcgaXdsMjAwMF8yYmduX2Nm
ZyA9IHsNCiAJLmh0X3BhcmFtcyA9ICZpd2wyMDAwX2h0X3BhcmFtcywNCiB9Ow0KIA0KLXN0cnVj
dCBpd2xfY2ZnIGl3bDIwMDBfMmJnX2NmZyA9IHsNCi0JLm5hbWUgPSAiMjAwMCBTZXJpZXMgMngy
IEJHIiwNCi0JSVdMX0RFVklDRV8yMDAwLA0KLX07DQotDQogc3RydWN0IGl3bF9jZmcgaXdsMjAw
MF8yYmduX2RfY2ZnID0gew0KIAkubmFtZSA9ICIyMDAwRCBTZXJpZXMgMngyIEJHTiIsDQogCUlX
TF9ERVZJQ0VfMjAwMCwNCkBAIC0zMDQsMTEgKzI5OSw2IEBAIHN0cnVjdCBpd2xfY2ZnIGl3bDIw
MzBfMmJnbl9jZmcgPSB7DQogCS5odF9wYXJhbXMgPSAmaXdsMjAwMF9odF9wYXJhbXMsDQogfTsN
CiANCi1zdHJ1Y3QgaXdsX2NmZyBpd2wyMDMwXzJiZ19jZmcgPSB7DQotCS5uYW1lID0gIjIwMDAg
U2VyaWVzIDJ4MiBCRy9CVCIsDQotCUlXTF9ERVZJQ0VfMjAzMCwNCi19Ow0KLQ0KICNkZWZpbmUg
SVdMX0RFVklDRV8xMDUJCQkJCQlcDQogCS5md19uYW1lX3ByZSA9IElXTDEwNV9GV19QUkUsCQkJ
CVwNCiAJLnVjb2RlX2FwaV9tYXggPSBJV0wxMDVfVUNPREVfQVBJX01BWCwJCQlcDQpAQCAtMzI2
LDExICszMTYsNiBAQCBzdHJ1Y3QgaXdsX2NmZyBpd2wyMDMwXzJiZ19jZmcgPSB7DQogCS5yeF93
aXRoX3Npc29fZGl2ZXJzaXR5ID0gdHJ1ZSwJCQkJXA0KIAkuaXFfaW52ZXJ0ID0gdHJ1ZQkJCQkJ
XA0KIA0KLXN0cnVjdCBpd2xfY2ZnIGl3bDEwNV9iZ19jZmcgPSB7DQotCS5uYW1lID0gIjEwNSBT
ZXJpZXMgMXgxIEJHIiwNCi0JSVdMX0RFVklDRV8xMDUsDQotfTsNCi0NCiBzdHJ1Y3QgaXdsX2Nm
ZyBpd2wxMDVfYmduX2NmZyA9IHsNCiAJLm5hbWUgPSAiMTA1IFNlcmllcyAxeDEgQkdOIiwNCiAJ
SVdMX0RFVklDRV8xMDUsDQpAQCAtMzYxLDExICszNDYsNiBAQCBzdHJ1Y3QgaXdsX2NmZyBpd2wx
MDVfYmduX2RfY2ZnID0gew0KIAkucnhfd2l0aF9zaXNvX2RpdmVyc2l0eSA9IHRydWUsCQkJCVwN
CiAJLmlxX2ludmVydCA9IHRydWUJCQkJCVwNCiANCi1zdHJ1Y3QgaXdsX2NmZyBpd2wxMzVfYmdf
Y2ZnID0gew0KLQkubmFtZSA9ICIxMzUgU2VyaWVzIDF4MSBCRy9CVCIsDQotCUlXTF9ERVZJQ0Vf
MTM1LA0KLX07DQotDQogc3RydWN0IGl3bF9jZmcgaXdsMTM1X2Jnbl9jZmcgPSB7DQogCS5uYW1l
ID0gIjEzNSBTZXJpZXMgMXgxIEJHTi9CVCIsDQogCUlXTF9ERVZJQ0VfMTM1LA0KZGlmZiAtLWdp
dCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2l3bHdpZmkvaXdsLTYwMDAuYyBiL2RyaXZlcnMvbmV0
L3dpcmVsZXNzL2l3bHdpZmkvaXdsLTYwMDAuYw0KaW5kZXggNGFjNGVmMC4uZTFhNDNjNCAxMDA2
NDQNCi0tLSBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2l3bHdpZmkvaXdsLTYwMDAuYw0KKysrIGIv
ZHJpdmVycy9uZXQvd2lyZWxlc3MvaXdsd2lmaS9pd2wtNjAwMC5jDQpAQCAtNDExLDYgKzQxMSwx
NyBAQCBzdHJ1Y3QgaXdsX2NmZyBpd2w2MDA1XzJhZ25fZF9jZmcgPSB7DQogCS5odF9wYXJhbXMg
PSAmaXdsNjAwMF9odF9wYXJhbXMsDQogfTsNCiANCitzdHJ1Y3QgaXdsX2NmZyBpd2w2MDA1XzJh
Z25fbW93MV9jZmcgPSB7DQorCS5uYW1lID0gIkludGVsKFIpIENlbnRyaW5vKFIpIEFkdmFuY2Vk
LU4gNjIwNiBBR04iLA0KKwlJV0xfREVWSUNFXzYwMDUsDQorCS5odF9wYXJhbXMgPSAmaXdsNjAw
MF9odF9wYXJhbXMsDQorfTsNCitzdHJ1Y3QgaXdsX2NmZyBpd2w2MDA1XzJhZ25fbW93Ml9jZmcg
PSB7DQorCS5uYW1lID0gIkludGVsKFIpIENlbnRyaW5vKFIpIEFkdmFuY2VkLU4gNjIwNyBBR04i
LA0KKwlJV0xfREVWSUNFXzYwMDUsDQorCS5odF9wYXJhbXMgPSAmaXdsNjAwMF9odF9wYXJhbXMs
DQorfTsNCisNCiAjZGVmaW5lIElXTF9ERVZJQ0VfNjAzMAkJCQkJCVwNCiAJLmZ3X25hbWVfcHJl
ID0gSVdMNjAzMF9GV19QUkUsCQkJCVwNCiAJLnVjb2RlX2FwaV9tYXggPSBJV0w2MDAwRzJfVUNP
REVfQVBJX01BWCwJCVwNCkBAIC00NjksMTQgKzQ4MCwxMCBAQCBzdHJ1Y3QgaXdsX2NmZyBpd2w2
MDM1XzJhZ25fY2ZnID0gew0KIAkuaHRfcGFyYW1zID0gJml3bDYwMDBfaHRfcGFyYW1zLA0KIH07
DQogDQotc3RydWN0IGl3bF9jZmcgaXdsNjAzNV8yYWJnX2NmZyA9IHsNCi0JLm5hbWUgPSAiNjAz
NSBTZXJpZXMgMngyIEFCRy9CVCIsDQotCUlXTF9ERVZJQ0VfNjAzMCwNCi19Ow0KLQ0KLXN0cnVj
dCBpd2xfY2ZnIGl3bDYwMzVfMmJnX2NmZyA9IHsNCi0JLm5hbWUgPSAiNjAzNSBTZXJpZXMgMngy
IEJHL0JUIiwNCi0JSVdMX0RFVklDRV82MDMwLA0KK3N0cnVjdCBpd2xfY2ZnIGl3bDYwMzVfMmFn
bl9zZmZfY2ZnID0gew0KKwkubmFtZSA9ICJJbnRlbChSKSBDZW50cmlubyhSKSBVbHRpbWF0ZS1O
IDYyMzUgQUdOIiwNCisJSVdMX0RFVklDRV82MDM1LA0KKwkuaHRfcGFyYW1zID0gJml3bDYwMDBf
aHRfcGFyYW1zLA0KIH07DQogDQogc3RydWN0IGl3bF9jZmcgaXdsMTAzMF9iZ25fY2ZnID0gew0K
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2l3bHdpZmkvaXdsLWNmZy5oIGIvZHJp
dmVycy9uZXQvd2lyZWxlc3MvaXdsd2lmaS9pd2wtY2ZnLmgNCmluZGV4IDJhMmRjNDUuLmU3ODY0
OTcgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9pd2x3aWZpL2l3bC1jZmcuaA0K
KysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvaXdsd2lmaS9pd2wtY2ZnLmgNCkBAIC04MCw2ICs4
MCw4IEBAIGV4dGVybiBzdHJ1Y3QgaXdsX2NmZyBpd2w2MDA1XzJhYmdfY2ZnOw0KIGV4dGVybiBz
dHJ1Y3QgaXdsX2NmZyBpd2w2MDA1XzJiZ19jZmc7DQogZXh0ZXJuIHN0cnVjdCBpd2xfY2ZnIGl3
bDYwMDVfMmFnbl9zZmZfY2ZnOw0KIGV4dGVybiBzdHJ1Y3QgaXdsX2NmZyBpd2w2MDA1XzJhZ25f
ZF9jZmc7DQorZXh0ZXJuIHN0cnVjdCBpd2xfY2ZnIGl3bDYwMDVfMmFnbl9tb3cxX2NmZzsNCitl
eHRlcm4gc3RydWN0IGl3bF9jZmcgaXdsNjAwNV8yYWduX21vdzJfY2ZnOw0KIGV4dGVybiBzdHJ1
Y3QgaXdsX2NmZyBpd2wxMDMwX2Jnbl9jZmc7DQogZXh0ZXJuIHN0cnVjdCBpd2xfY2ZnIGl3bDEw
MzBfYmdfY2ZnOw0KIGV4dGVybiBzdHJ1Y3QgaXdsX2NmZyBpd2w2MDMwXzJhZ25fY2ZnOw0KQEAg
LTEwMSwxNyArMTAzLDEyIEBAIGV4dGVybiBzdHJ1Y3QgaXdsX2NmZyBpd2wxMDBfYmdfY2ZnOw0K
IGV4dGVybiBzdHJ1Y3QgaXdsX2NmZyBpd2wxMzBfYmduX2NmZzsNCiBleHRlcm4gc3RydWN0IGl3
bF9jZmcgaXdsMTMwX2JnX2NmZzsNCiBleHRlcm4gc3RydWN0IGl3bF9jZmcgaXdsMjAwMF8yYmdu
X2NmZzsNCi1leHRlcm4gc3RydWN0IGl3bF9jZmcgaXdsMjAwMF8yYmdfY2ZnOw0KIGV4dGVybiBz
dHJ1Y3QgaXdsX2NmZyBpd2wyMDAwXzJiZ25fZF9jZmc7DQogZXh0ZXJuIHN0cnVjdCBpd2xfY2Zn
IGl3bDIwMzBfMmJnbl9jZmc7DQotZXh0ZXJuIHN0cnVjdCBpd2xfY2ZnIGl3bDIwMzBfMmJnX2Nm
ZzsNCiBleHRlcm4gc3RydWN0IGl3bF9jZmcgaXdsNjAzNV8yYWduX2NmZzsNCi1leHRlcm4gc3Ry
dWN0IGl3bF9jZmcgaXdsNjAzNV8yYWJnX2NmZzsNCi1leHRlcm4gc3RydWN0IGl3bF9jZmcgaXds
NjAzNV8yYmdfY2ZnOw0KLWV4dGVybiBzdHJ1Y3QgaXdsX2NmZyBpd2wxMDVfYmdfY2ZnOw0KK2V4
dGVybiBzdHJ1Y3QgaXdsX2NmZyBpd2w2MDM1XzJhZ25fc2ZmX2NmZzsNCiBleHRlcm4gc3RydWN0
IGl3bF9jZmcgaXdsMTA1X2Jnbl9jZmc7DQogZXh0ZXJuIHN0cnVjdCBpd2xfY2ZnIGl3bDEwNV9i
Z25fZF9jZmc7DQotZXh0ZXJuIHN0cnVjdCBpd2xfY2ZnIGl3bDEzNV9iZ19jZmc7DQogZXh0ZXJu
IHN0cnVjdCBpd2xfY2ZnIGl3bDEzNV9iZ25fY2ZnOw0KIA0KICNlbmRpZiAvKiBfX2l3bF9wY2lf
aF9fICovDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvaXdsd2lmaS9pd2wtcGNp
LmMgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9pd2x3aWZpL2l3bC1wY2kuYw0KaW5kZXggMzQ2ZGM5
Yi4uNjJhMGY4MSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2l3bHdpZmkvaXds
LXBjaS5jDQorKysgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9pd2x3aWZpL2l3bC1wY2kuYw0KQEAg
LTIzNiwxMyArMjM2LDE2IEBAIHN0YXRpYyBERUZJTkVfUENJX0RFVklDRV9UQUJMRShpd2xfaHdf
Y2FyZF9pZHMpID0gew0KIA0KIC8qIDZ4MDAgU2VyaWVzICovDQogCXtJV0xfUENJX0RFVklDRSgw
eDQyMkIsIDB4MTEwMSwgaXdsNjAwMF8zYWduX2NmZyl9LA0KKwl7SVdMX1BDSV9ERVZJQ0UoMHg0
MjJCLCAweDExMDgsIGl3bDYwMDBfM2Fnbl9jZmcpfSwNCiAJe0lXTF9QQ0lfREVWSUNFKDB4NDIy
QiwgMHgxMTIxLCBpd2w2MDAwXzNhZ25fY2ZnKX0sDQorCXtJV0xfUENJX0RFVklDRSgweDQyMkIs
IDB4MTEyOCwgaXdsNjAwMF8zYWduX2NmZyl9LA0KIAl7SVdMX1BDSV9ERVZJQ0UoMHg0MjJDLCAw
eDEzMDEsIGl3bDYwMDBpXzJhZ25fY2ZnKX0sDQogCXtJV0xfUENJX0RFVklDRSgweDQyMkMsIDB4
MTMwNiwgaXdsNjAwMGlfMmFiZ19jZmcpfSwNCiAJe0lXTF9QQ0lfREVWSUNFKDB4NDIyQywgMHgx
MzA3LCBpd2w2MDAwaV8yYmdfY2ZnKX0sDQogCXtJV0xfUENJX0RFVklDRSgweDQyMkMsIDB4MTMy
MSwgaXdsNjAwMGlfMmFnbl9jZmcpfSwNCiAJe0lXTF9QQ0lfREVWSUNFKDB4NDIyQywgMHgxMzI2
LCBpd2w2MDAwaV8yYWJnX2NmZyl9LA0KIAl7SVdMX1BDSV9ERVZJQ0UoMHg0MjM4LCAweDExMTEs
IGl3bDYwMDBfM2Fnbl9jZmcpfSwNCisJe0lXTF9QQ0lfREVWSUNFKDB4NDIzOCwgMHgxMTE4LCBp
d2w2MDAwXzNhZ25fY2ZnKX0sDQogCXtJV0xfUENJX0RFVklDRSgweDQyMzksIDB4MTMxMSwgaXds
NjAwMGlfMmFnbl9jZmcpfSwNCiAJe0lXTF9QQ0lfREVWSUNFKDB4NDIzOSwgMHgxMzE2LCBpd2w2
MDAwaV8yYWJnX2NmZyl9LA0KIA0KQEAgLTI1MCwxMyArMjUzLDE5IEBAIHN0YXRpYyBERUZJTkVf
UENJX0RFVklDRV9UQUJMRShpd2xfaHdfY2FyZF9pZHMpID0gew0KIAl7SVdMX1BDSV9ERVZJQ0Uo
MHgwMDgyLCAweDEzMDEsIGl3bDYwMDVfMmFnbl9jZmcpfSwNCiAJe0lXTF9QQ0lfREVWSUNFKDB4
MDA4MiwgMHgxMzA2LCBpd2w2MDA1XzJhYmdfY2ZnKX0sDQogCXtJV0xfUENJX0RFVklDRSgweDAw
ODIsIDB4MTMwNywgaXdsNjAwNV8yYmdfY2ZnKX0sDQorCXtJV0xfUENJX0RFVklDRSgweDAwODIs
IDB4MTMwOCwgaXdsNjAwNV8yYWduX2NmZyl9LA0KIAl7SVdMX1BDSV9ERVZJQ0UoMHgwMDgyLCAw
eDEzMjEsIGl3bDYwMDVfMmFnbl9jZmcpfSwNCiAJe0lXTF9QQ0lfREVWSUNFKDB4MDA4MiwgMHgx
MzI2LCBpd2w2MDA1XzJhYmdfY2ZnKX0sDQorCXtJV0xfUENJX0RFVklDRSgweDAwODIsIDB4MTMy
OCwgaXdsNjAwNV8yYWduX2NmZyl9LA0KIAl7SVdMX1BDSV9ERVZJQ0UoMHgwMDg1LCAweDEzMTEs
IGl3bDYwMDVfMmFnbl9jZmcpfSwNCisJe0lXTF9QQ0lfREVWSUNFKDB4MDA4NSwgMHgxMzE4LCBp
d2w2MDA1XzJhZ25fY2ZnKX0sDQogCXtJV0xfUENJX0RFVklDRSgweDAwODUsIDB4MTMxNiwgaXds
NjAwNV8yYWJnX2NmZyl9LA0KIAl7SVdMX1BDSV9ERVZJQ0UoMHgwMDgyLCAweEMwMjAsIGl3bDYw
MDVfMmFnbl9zZmZfY2ZnKX0sDQogCXtJV0xfUENJX0RFVklDRSgweDAwODUsIDB4QzIyMCwgaXds
NjAwNV8yYWduX3NmZl9jZmcpfSwNCi0Je0lXTF9QQ0lfREVWSUNFKDB4MDA4MiwgMHgxMzQxLCBp
d2w2MDA1XzJhZ25fZF9jZmcpfSwNCisJe0lXTF9QQ0lfREVWSUNFKDB4MDA4NSwgMHhDMjI4LCBp
d2w2MDA1XzJhZ25fc2ZmX2NmZyl9LA0KKwl7SVdMX1BDSV9ERVZJQ0UoMHgwMDgyLCAweDQ4MjAs
IGl3bDYwMDVfMmFnbl9kX2NmZyl9LA0KKwl7SVdMX1BDSV9ERVZJQ0UoMHgwMDgyLCAweDEzMDQs
IGl3bDYwMDVfMmFnbl9tb3cxX2NmZyl9LC8qIGxvdyA1R0h6IGFjdGl2ZSAqLw0KKwl7SVdMX1BD
SV9ERVZJQ0UoMHgwMDgyLCAweDEzMDUsIGl3bDYwMDVfMmFnbl9tb3cyX2NmZyl9LC8qIGhpZ2gg
NUdIeiBhY3RpdmUgKi8NCiANCiAvKiA2eDMwIFNlcmllcyAqLw0KIAl7SVdMX1BDSV9ERVZJQ0Uo
MHgwMDhBLCAweDUzMDUsIGl3bDEwMzBfYmduX2NmZyl9LA0KQEAgLTMyNiw0NiArMzM1LDMzIEBA
IHN0YXRpYyBERUZJTkVfUENJX0RFVklDRV9UQUJMRShpd2xfaHdfY2FyZF9pZHMpID0gew0KIAl7
SVdMX1BDSV9ERVZJQ0UoMHgwODkwLCAweDQwMjIsIGl3bDIwMDBfMmJnbl9jZmcpfSwNCiAJe0lX
TF9QQ0lfREVWSUNFKDB4MDg5MSwgMHg0MjIyLCBpd2wyMDAwXzJiZ25fY2ZnKX0sDQogCXtJV0xf
UENJX0RFVklDRSgweDA4OTAsIDB4NDQyMiwgaXdsMjAwMF8yYmduX2NmZyl9LA0KLQl7SVdMX1BD
SV9ERVZJQ0UoMHgwODkwLCAweDQwMjYsIGl3bDIwMDBfMmJnX2NmZyl9LA0KLQl7SVdMX1BDSV9E
RVZJQ0UoMHgwODkxLCAweDQyMjYsIGl3bDIwMDBfMmJnX2NmZyl9LA0KLQl7SVdMX1BDSV9ERVZJ
Q0UoMHgwODkwLCAweDQ0MjYsIGl3bDIwMDBfMmJnX2NmZyl9LA0KIAl7SVdMX1BDSV9ERVZJQ0Uo
MHgwODkwLCAweDQ4MjIsIGl3bDIwMDBfMmJnbl9kX2NmZyl9LA0KIA0KIC8qIDJ4MzAgU2VyaWVz
ICovDQogCXtJV0xfUENJX0RFVklDRSgweDA4ODcsIDB4NDA2MiwgaXdsMjAzMF8yYmduX2NmZyl9
LA0KIAl7SVdMX1BDSV9ERVZJQ0UoMHgwODg4LCAweDQyNjIsIGl3bDIwMzBfMmJnbl9jZmcpfSwN
CiAJe0lXTF9QQ0lfREVWSUNFKDB4MDg4NywgMHg0NDYyLCBpd2wyMDMwXzJiZ25fY2ZnKX0sDQot
CXtJV0xfUENJX0RFVklDRSgweDA4ODcsIDB4NDA2NiwgaXdsMjAzMF8yYmdfY2ZnKX0sDQotCXtJ
V0xfUENJX0RFVklDRSgweDA4ODgsIDB4NDI2NiwgaXdsMjAzMF8yYmdfY2ZnKX0sDQotCXtJV0xf
UENJX0RFVklDRSgweDA4ODcsIDB4NDQ2NiwgaXdsMjAzMF8yYmdfY2ZnKX0sDQogDQogLyogNngz
NSBTZXJpZXMgKi8NCiAJe0lXTF9QQ0lfREVWSUNFKDB4MDg4RSwgMHg0MDYwLCBpd2w2MDM1XzJh
Z25fY2ZnKX0sDQorCXtJV0xfUENJX0RFVklDRSgweDA4OEUsIDB4NDA2QSwgaXdsNjAzNV8yYWdu
X3NmZl9jZmcpfSwNCiAJe0lXTF9QQ0lfREVWSUNFKDB4MDg4RiwgMHg0MjYwLCBpd2w2MDM1XzJh
Z25fY2ZnKX0sDQorCXtJV0xfUENJX0RFVklDRSgweDA4OEYsIDB4NDI2QSwgaXdsNjAzNV8yYWdu
X3NmZl9jZmcpfSwNCiAJe0lXTF9QQ0lfREVWSUNFKDB4MDg4RSwgMHg0NDYwLCBpd2w2MDM1XzJh
Z25fY2ZnKX0sDQotCXtJV0xfUENJX0RFVklDRSgweDA4OEUsIDB4NDA2NCwgaXdsNjAzNV8yYWJn
X2NmZyl9LA0KLQl7SVdMX1BDSV9ERVZJQ0UoMHgwODhGLCAweDQyNjQsIGl3bDYwMzVfMmFiZ19j
ZmcpfSwNCi0Je0lXTF9QQ0lfREVWSUNFKDB4MDg4RSwgMHg0NDY0LCBpd2w2MDM1XzJhYmdfY2Zn
KX0sDQotCXtJV0xfUENJX0RFVklDRSgweDA4OEUsIDB4NDA2NiwgaXdsNjAzNV8yYmdfY2ZnKX0s
DQotCXtJV0xfUENJX0RFVklDRSgweDA4OEYsIDB4NDI2NiwgaXdsNjAzNV8yYmdfY2ZnKX0sDQot
CXtJV0xfUENJX0RFVklDRSgweDA4OEUsIDB4NDQ2NiwgaXdsNjAzNV8yYmdfY2ZnKX0sDQorCXtJ
V0xfUENJX0RFVklDRSgweDA4OEUsIDB4NDQ2QSwgaXdsNjAzNV8yYWduX3NmZl9jZmcpfSwNCisJ
e0lXTF9QQ0lfREVWSUNFKDB4MDg4RSwgMHg0ODYwLCBpd2w2MDM1XzJhZ25fY2ZnKX0sDQorCXtJ
V0xfUENJX0RFVklDRSgweDA4OEYsIDB4NTI2MCwgaXdsNjAzNV8yYWduX2NmZyl9LA0KIA0KIC8q
IDEwNSBTZXJpZXMgKi8NCiAJe0lXTF9QQ0lfREVWSUNFKDB4MDg5NCwgMHgwMDIyLCBpd2wxMDVf
YmduX2NmZyl9LA0KIAl7SVdMX1BDSV9ERVZJQ0UoMHgwODk1LCAweDAyMjIsIGl3bDEwNV9iZ25f
Y2ZnKX0sDQogCXtJV0xfUENJX0RFVklDRSgweDA4OTQsIDB4MDQyMiwgaXdsMTA1X2Jnbl9jZmcp
fSwNCi0Je0lXTF9QQ0lfREVWSUNFKDB4MDg5NCwgMHgwMDI2LCBpd2wxMDVfYmdfY2ZnKX0sDQot
CXtJV0xfUENJX0RFVklDRSgweDA4OTUsIDB4MDIyNiwgaXdsMTA1X2JnX2NmZyl9LA0KLQl7SVdM
X1BDSV9ERVZJQ0UoMHgwODk0LCAweDA0MjYsIGl3bDEwNV9iZ19jZmcpfSwNCiAJe0lXTF9QQ0lf
REVWSUNFKDB4MDg5NCwgMHgwODIyLCBpd2wxMDVfYmduX2RfY2ZnKX0sDQogDQogLyogMTM1IFNl
cmllcyAqLw0KIAl7SVdMX1BDSV9ERVZJQ0UoMHgwODkyLCAweDAwNjIsIGl3bDEzNV9iZ25fY2Zn
KX0sDQogCXtJV0xfUENJX0RFVklDRSgweDA4OTMsIDB4MDI2MiwgaXdsMTM1X2Jnbl9jZmcpfSwN
CiAJe0lXTF9QQ0lfREVWSUNFKDB4MDg5MiwgMHgwNDYyLCBpd2wxMzVfYmduX2NmZyl9LA0KLQl7
SVdMX1BDSV9ERVZJQ0UoMHgwODkyLCAweDAwNjYsIGl3bDEzNV9iZ19jZmcpfSwNCi0Je0lXTF9Q
Q0lfREVWSUNFKDB4MDg5MywgMHgwMjY2LCBpd2wxMzVfYmdfY2ZnKX0sDQotCXtJV0xfUENJX0RF
VklDRSgweDA4OTIsIDB4MDQ2NiwgaXdsMTM1X2JnX2NmZyl9LA0KIA0KIAl7MH0NCiB9Ow0KZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3J0bHdpZmkvcnRsODE5MmN1L3RyeC5jIGIv
ZHJpdmVycy9uZXQvd2lyZWxlc3MvcnRsd2lmaS9ydGw4MTkyY3UvdHJ4LmMNCmluZGV4IGJjMzNi
MTQuLmE3ZTFhMmMgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9ydGx3aWZpL3J0
bDgxOTJjdS90cnguYw0KKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvcnRsd2lmaS9ydGw4MTky
Y3UvdHJ4LmMNCkBAIC0zNDMsNyArMzQzLDggQEAgYm9vbCBydGw5MmN1X3J4X3F1ZXJ5X2Rlc2Mo
c3RydWN0IGllZWU4MDIxMV9odyAqaHcsDQogCQkJCQkoYm9vbClHRVRfUlhfREVTQ19QQUdHUihw
ZGVzYykpOw0KIAlyeF9zdGF0dXMtPm1hY3RpbWUgPSBHRVRfUlhfREVTQ19UU0ZMKHBkZXNjKTsN
CiAJaWYgKHBoeXN0YXR1cykgew0KLQkJcF9kcnZpbmZvID0gKHN0cnVjdCByeF9md2luZm9fOTJj
ICopKHBkZXNjICsgUlRMX1JYX0RFU0NfU0laRSk7DQorCQlwX2RydmluZm8gPSAoc3RydWN0IHJ4
X2Z3aW5mb185MmMgKikoc2tiLT5kYXRhICsNCisJCQkJCQkgICAgIHN0YXRzLT5yeF9idWZzaGlm
dCk7DQogCQlydGw5MmNfdHJhbnNsYXRlX3J4X3NpZ25hbF9zdHVmZihodywgc2tiLCBzdGF0cywg
cGRlc2MsDQogCQkJCQkJIHBfZHJ2aW5mbyk7DQogCX0NCmRpZmYgLS1naXQgYS9kcml2ZXJzL25l
dC94ZW4tbmV0YmFjay9jb21tb24uaCBiL2RyaXZlcnMvbmV0L3hlbi1uZXRiYWNrL2NvbW1vbi5o
DQppbmRleCA5ZDdmMTcyLi4wOTNiZjBhIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQveGVuLW5l
dGJhY2svY29tbW9uLmgNCisrKyBiL2RyaXZlcnMvbmV0L3hlbi1uZXRiYWNrL2NvbW1vbi5oDQpA
QCAtODgsNiArODgsNyBAQCBzdHJ1Y3QgeGVudmlmIHsNCiAJdW5zaWduZWQgbG9uZyAgIGNyZWRp
dF91c2VjOw0KIAl1bnNpZ25lZCBsb25nICAgcmVtYWluaW5nX2NyZWRpdDsNCiAJc3RydWN0IHRp
bWVyX2xpc3QgY3JlZGl0X3RpbWVvdXQ7DQorCXU2NCBjcmVkaXRfd2luZG93X3N0YXJ0Ow0KIA0K
IAkvKiBTdGF0aXN0aWNzICovDQogCXVuc2lnbmVkIGxvbmcgcnhfZ3NvX2NoZWNrc3VtX2ZpeHVw
Ow0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3hlbi1uZXRiYWNrL2ludGVyZmFjZS5jIGIvZHJp
dmVycy9uZXQveGVuLW5ldGJhY2svaW50ZXJmYWNlLmMNCmluZGV4IDhlYWYwZTIuLjJjYjljOTIg
MTAwNjQ0DQotLS0gYS9kcml2ZXJzL25ldC94ZW4tbmV0YmFjay9pbnRlcmZhY2UuYw0KKysrIGIv
ZHJpdmVycy9uZXQveGVuLW5ldGJhY2svaW50ZXJmYWNlLmMNCkBAIC0yNzIsOCArMjcyLDcgQEAg
c3RydWN0IHhlbnZpZiAqeGVudmlmX2FsbG9jKHN0cnVjdCBkZXZpY2UgKnBhcmVudCwgZG9taWRf
dCBkb21pZCwNCiAJdmlmLT5jcmVkaXRfYnl0ZXMgPSB2aWYtPnJlbWFpbmluZ19jcmVkaXQgPSB+
MFVMOw0KIAl2aWYtPmNyZWRpdF91c2VjICA9IDBVTDsNCiAJaW5pdF90aW1lcigmdmlmLT5jcmVk
aXRfdGltZW91dCk7DQotCS8qIEluaXRpYWxpemUgJ2V4cGlyZXMnIG5vdzogaXQncyB1c2VkIHRv
IHRyYWNrIHRoZSBjcmVkaXQgd2luZG93LiAqLw0KLQl2aWYtPmNyZWRpdF90aW1lb3V0LmV4cGly
ZXMgPSBqaWZmaWVzOw0KKwl2aWYtPmNyZWRpdF93aW5kb3dfc3RhcnQgPSBnZXRfamlmZmllc182
NCgpOw0KIA0KIAlkZXYtPm5ldGRldl9vcHMJPSAmeGVudmlmX25ldGRldl9vcHM7DQogCWRldi0+
aHdfZmVhdHVyZXMgPSBORVRJRl9GX1NHIHwgTkVUSUZfRl9JUF9DU1VNIHwgTkVUSUZfRl9UU087
DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQveGVuLW5ldGJhY2svbmV0YmFjay5jIGIvZHJpdmVy
cy9uZXQveGVuLW5ldGJhY2svbmV0YmFjay5jDQppbmRleCBmZDJiOTJkLi45YTQ2MjZjIDEwMDY0
NA0KLS0tIGEvZHJpdmVycy9uZXQveGVuLW5ldGJhY2svbmV0YmFjay5jDQorKysgYi9kcml2ZXJz
L25ldC94ZW4tbmV0YmFjay9uZXRiYWNrLmMNCkBAIC0xMzY1LDkgKzEzNjUsOCBAQCBvdXQ6DQog
DQogc3RhdGljIGJvb2wgdHhfY3JlZGl0X2V4Y2VlZGVkKHN0cnVjdCB4ZW52aWYgKnZpZiwgdW5z
aWduZWQgc2l6ZSkNCiB7DQotCXVuc2lnbmVkIGxvbmcgbm93ID0gamlmZmllczsNCi0JdW5zaWdu
ZWQgbG9uZyBuZXh0X2NyZWRpdCA9DQotCQl2aWYtPmNyZWRpdF90aW1lb3V0LmV4cGlyZXMgKw0K
Kwl1NjQgbm93ID0gZ2V0X2ppZmZpZXNfNjQoKTsNCisJdTY0IG5leHRfY3JlZGl0ID0gdmlmLT5j
cmVkaXRfd2luZG93X3N0YXJ0ICsNCiAJCW1zZWNzX3RvX2ppZmZpZXModmlmLT5jcmVkaXRfdXNl
YyAvIDEwMDApOw0KIA0KIAkvKiBUaW1lciBjb3VsZCBhbHJlYWR5IGJlIHBlbmRpbmcgaW4gcmFy
ZSBjYXNlcy4gKi8NCkBAIC0xMzc1LDggKzEzNzQsOCBAQCBzdGF0aWMgYm9vbCB0eF9jcmVkaXRf
ZXhjZWVkZWQoc3RydWN0IHhlbnZpZiAqdmlmLCB1bnNpZ25lZCBzaXplKQ0KIAkJcmV0dXJuIHRy
dWU7DQogDQogCS8qIFBhc3NlZCB0aGUgcG9pbnQgd2hlcmUgd2UgY2FuIHJlcGxlbmlzaCBjcmVk
aXQ/ICovDQotCWlmICh0aW1lX2FmdGVyX2VxKG5vdywgbmV4dF9jcmVkaXQpKSB7DQotCQl2aWYt
PmNyZWRpdF90aW1lb3V0LmV4cGlyZXMgPSBub3c7DQorCWlmICh0aW1lX2FmdGVyX2VxNjQobm93
LCBuZXh0X2NyZWRpdCkpIHsNCisJCXZpZi0+Y3JlZGl0X3dpbmRvd19zdGFydCA9IG5vdzsNCiAJ
CXR4X2FkZF9jcmVkaXQodmlmKTsNCiAJfQ0KIA0KQEAgLTEzODgsNiArMTM4Nyw3IEBAIHN0YXRp
YyBib29sIHR4X2NyZWRpdF9leGNlZWRlZChzdHJ1Y3QgeGVudmlmICp2aWYsIHVuc2lnbmVkIHNp
emUpDQogCQkJdHhfY3JlZGl0X2NhbGxiYWNrOw0KIAkJbW9kX3RpbWVyKCZ2aWYtPmNyZWRpdF90
aW1lb3V0LA0KIAkJCSAgbmV4dF9jcmVkaXQpOw0KKwkJdmlmLT5jcmVkaXRfd2luZG93X3N0YXJ0
ID0gbmV4dF9jcmVkaXQ7DQogDQogCQlyZXR1cm4gdHJ1ZTsNCiAJfQ0KZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvcGNpL3NldHVwLXJlcy5jIGIvZHJpdmVycy9wY2kvc2V0dXAtcmVzLmMNCmluZGV4IDhi
MjVmOWMuLjQxZjA4ZTUgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3BjaS9zZXR1cC1yZXMuYw0KKysr
IGIvZHJpdmVycy9wY2kvc2V0dXAtcmVzLmMNCkBAIC0xODgsNyArMTg4LDggQEAgc3RhdGljIGlu
dCBwY2lfcmV2ZXJ0X2Z3X2FkZHJlc3Moc3RydWN0IHJlc291cmNlICpyZXMsIHN0cnVjdCBwY2lf
ZGV2ICpkZXYsDQogCXJldHVybiByZXQ7DQogfQ0KIA0KLXN0YXRpYyBpbnQgX3BjaV9hc3NpZ25f
cmVzb3VyY2Uoc3RydWN0IHBjaV9kZXYgKmRldiwgaW50IHJlc25vLCBpbnQgc2l6ZSwgcmVzb3Vy
Y2Vfc2l6ZV90IG1pbl9hbGlnbikNCitzdGF0aWMgaW50IF9wY2lfYXNzaWduX3Jlc291cmNlKHN0
cnVjdCBwY2lfZGV2ICpkZXYsIGludCByZXNubywNCisJCQkJcmVzb3VyY2Vfc2l6ZV90IHNpemUs
IHJlc291cmNlX3NpemVfdCBtaW5fYWxpZ24pDQogew0KIAlzdHJ1Y3QgcmVzb3VyY2UgKnJlcyA9
IGRldi0+cmVzb3VyY2UgKyByZXNubzsNCiAJc3RydWN0IHBjaV9idXMgKmJ1czsNCmRpZmYgLS1n
aXQgYS9kcml2ZXJzL3Njc2kvYWFjcmFpZC9saW5pdC5jIGIvZHJpdmVycy9zY3NpL2FhY3JhaWQv
bGluaXQuYw0KaW5kZXggNzA1ZTEzZS4uMmU2NThkMiAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvc2Nz
aS9hYWNyYWlkL2xpbml0LmMNCisrKyBiL2RyaXZlcnMvc2NzaS9hYWNyYWlkL2xpbml0LmMNCkBA
IC03NzEsNiArNzcxLDggQEAgc3RhdGljIGxvbmcgYWFjX2NvbXBhdF9kb19pb2N0bChzdHJ1Y3Qg
YWFjX2RldiAqZGV2LCB1bnNpZ25lZCBjbWQsIHVuc2lnbmVkIGxvbmcNCiBzdGF0aWMgaW50IGFh
Y19jb21wYXRfaW9jdGwoc3RydWN0IHNjc2lfZGV2aWNlICpzZGV2LCBpbnQgY21kLCB2b2lkIF9f
dXNlciAqYXJnKQ0KIHsNCiAJc3RydWN0IGFhY19kZXYgKmRldiA9IChzdHJ1Y3QgYWFjX2RldiAq
KXNkZXYtPmhvc3QtPmhvc3RkYXRhOw0KKwlpZiAoIWNhcGFibGUoQ0FQX1NZU19SQVdJTykpDQor
CQlyZXR1cm4gLUVQRVJNOw0KIAlyZXR1cm4gYWFjX2NvbXBhdF9kb19pb2N0bChkZXYsIGNtZCwg
KHVuc2lnbmVkIGxvbmcpYXJnKTsNCiB9DQogDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5n
L2JjbS9CY21jaGFyLmMgYi9kcml2ZXJzL3N0YWdpbmcvYmNtL0JjbWNoYXIuYw0KaW5kZXggMmZh
NjU4ZS4uMzkxYjc2OCAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvc3RhZ2luZy9iY20vQmNtY2hhci5j
DQorKysgYi9kcml2ZXJzL3N0YWdpbmcvYmNtL0JjbWNoYXIuYw0KQEAgLTE5MzIsNiArMTkzMiw3
IEBAIGNudHJsRW5kOg0KIA0KIAkJQkNNX0RFQlVHX1BSSU5UKEFkYXB0ZXIsIERCR19UWVBFX09U
SEVSUywgT1NBTF9EQkcsIERCR19MVkxfQUxMLCAiQ2FsbGVkIElPQ1RMX0JDTV9HRVRfREVWSUNF
X0RSSVZFUl9JTkZPXG4iKTsNCiANCisJCW1lbXNldCgmRGV2SW5mbywgMCwgc2l6ZW9mKERldklu
Zm8pKTsNCiAJCURldkluZm8uTWF4UkRNQnVmZmVyU2l6ZSA9IEJVRkZFUl80SzsNCiAJCURldklu
Zm8udTMyRFNEU3RhcnRPZmZzZXQgPSBFRVBST01fQ0FMUEFSQU1fU1RBUlQ7DQogCQlEZXZJbmZv
LnUzMlJ4QWxpZ25tZW50Q29ycmVjdGlvbiA9IDA7DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFn
aW5nL3dsYWdzNDlfaDIvd2xfcHJpdi5jIGIvZHJpdmVycy9zdGFnaW5nL3dsYWdzNDlfaDIvd2xf
cHJpdi5jDQppbmRleCAyNjBkNGYwLi5iM2QyZTE3IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9zdGFn
aW5nL3dsYWdzNDlfaDIvd2xfcHJpdi5jDQorKysgYi9kcml2ZXJzL3N0YWdpbmcvd2xhZ3M0OV9o
Mi93bF9wcml2LmMNCkBAIC01NzAsNiArNTcwLDcgQEAgaW50IHd2bGFuX3VpbF9wdXRfaW5mbygg
c3RydWN0IHVpbHJlcSAqdXJxLCBzdHJ1Y3Qgd2xfcHJpdmF0ZSAqbHAgKQ0KIAlsdHZfdCAgICAg
ICAgICAgICAgICAgICAqcEx0djsNCiAJYm9vbF90ICAgICAgICAgICAgICAgICAgbHR2QWxsb2Nh
dGVkID0gRkFMU0U7DQogCUVOQ1NUUkNUICAgICAgICAgICAgICAgIHNFbmNyeXB0aW9uOw0KKwlz
aXplX3QJCQlsZW47DQogDQogI2lmZGVmIFVTRV9XRFMNCiAJaGNmXzE2ICAgICAgICAgICAgICAg
ICAgaGNmUG9ydCAgPSBIQ0ZfUE9SVF8wOw0KQEAgLTY4Niw3ICs2ODcsOCBAQCBpbnQgd3ZsYW5f
dWlsX3B1dF9pbmZvKCBzdHJ1Y3QgdWlscmVxICp1cnEsIHN0cnVjdCB3bF9wcml2YXRlICpscCAp
DQogCQkJCQlicmVhazsNCiAJCQkJY2FzZSBDRkdfQ05GX09XTl9OQU1FOg0KIAkJCQkJbWVtc2V0
KCBscC0+U3RhdGlvbk5hbWUsIDAsIHNpemVvZiggbHAtPlN0YXRpb25OYW1lICkpOw0KLQkJCQkJ
bWVtY3B5KCAodm9pZCAqKWxwLT5TdGF0aW9uTmFtZSwgKHZvaWQgKikmcEx0di0+dS51OFsyXSwg
KHNpemVfdClwTHR2LT51LnUxNlswXSk7DQorCQkJCQlsZW4gPSBtaW5fdChzaXplX3QsIHBMdHYt
PnUudTE2WzBdLCBzaXplb2YobHAtPlN0YXRpb25OYW1lKSk7DQorCQkJCQlzdHJsY3B5KGxwLT5T
dGF0aW9uTmFtZSwgJnBMdHYtPnUudThbMl0sIGxlbik7DQogCQkJCQlwTHR2LT51LnUxNlswXSA9
IENOVl9JTlRfVE9fTElUVExFKCBwTHR2LT51LnUxNlswXSApOw0KIAkJCQkJYnJlYWs7DQogCQkJ
CWNhc2UgQ0ZHX0NORl9MT0FEX0JBTEFOQ0lORzoNCkBAIC0xODAwLDYgKzE4MDIsNyBAQCBpbnQg
d3ZsYW5fc2V0X3N0YXRpb25fbmlja25hbWUoc3RydWN0IG5ldF9kZXZpY2UgKmRldiwNCiB7DQog
ICAgICAgICBzdHJ1Y3Qgd2xfcHJpdmF0ZSAqbHAgPSB3bF9wcml2KGRldik7DQogICAgICAgICB1
bnNpZ25lZCBsb25nIGZsYWdzOw0KKwlzaXplX3QgbGVuOw0KICAgICAgICAgaW50ICAgICAgICAg
cmV0ID0gMDsNCiAJLyotLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0qLw0KIA0KQEAgLTE4MTAsOCArMTgxMyw4IEBA
IGludCB3dmxhbl9zZXRfc3RhdGlvbl9uaWNrbmFtZShzdHJ1Y3QgbmV0X2RldmljZSAqZGV2LA0K
ICAgICAgICAgd2xfbG9jayhscCwgJmZsYWdzKTsNCiANCiAgICAgICAgIG1lbXNldCggbHAtPlN0
YXRpb25OYW1lLCAwLCBzaXplb2YoIGxwLT5TdGF0aW9uTmFtZSApKTsNCi0NCi0gICAgICAgIG1l
bWNweSggbHAtPlN0YXRpb25OYW1lLCBleHRyYSwgd3JxdS0+ZGF0YS5sZW5ndGgpOw0KKwlsZW4g
PSBtaW5fdChzaXplX3QsIHdycXUtPmRhdGEubGVuZ3RoLCBzaXplb2YobHAtPlN0YXRpb25OYW1l
KSk7DQorCXN0cmxjcHkobHAtPlN0YXRpb25OYW1lLCBleHRyYSwgbGVuKTsNCiANCiAgICAgICAg
IC8qIENvbW1pdCB0aGUgYWRhcHRlciBwYXJhbWV0ZXJzICovDQogICAgICAgICB3bF9hcHBseSgg
bHAgKTsNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvenJhbS96cmFtX2Rydi5jIGIvZHJp
dmVycy9zdGFnaW5nL3pyYW0venJhbV9kcnYuYw0KaW5kZXggZDE5N2IzZS4uZTFhNDk5NCAxMDA2
NDQNCi0tLSBhL2RyaXZlcnMvc3RhZ2luZy96cmFtL3pyYW1fZHJ2LmMNCisrKyBiL2RyaXZlcnMv
c3RhZ2luZy96cmFtL3pyYW1fZHJ2LmMNCkBAIC01NTMsNyArNTUzLDcgQEAgc3RhdGljIGlubGlu
ZSBpbnQgdmFsaWRfaW9fcmVxdWVzdChzdHJ1Y3QgenJhbSAqenJhbSwgc3RydWN0IGJpbyAqYmlv
KQ0KIAllbmQgPSBzdGFydCArIChiaW8tPmJpX3NpemUgPj4gU0VDVE9SX1NISUZUKTsNCiAJYm91
bmQgPSB6cmFtLT5kaXNrc2l6ZSA+PiBTRUNUT1JfU0hJRlQ7DQogCS8qIG91dCBvZiByYW5nZSBy
YW5nZSAqLw0KLQlpZiAodW5saWtlbHkoc3RhcnQgPj0gYm91bmQgfHwgZW5kID49IGJvdW5kIHx8
IHN0YXJ0ID4gZW5kKSkNCisJaWYgKHVubGlrZWx5KHN0YXJ0ID49IGJvdW5kIHx8IGVuZCA+IGJv
dW5kIHx8IHN0YXJ0ID4gZW5kKSkNCiAJCXJldHVybiAwOw0KIA0KIAkvKiBJL08gcmVxdWVzdCBp
cyB2YWxpZCAqLw0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvdGFyZ2V0L3RhcmdldF9jb3JlX3BzY3Np
LmMgYi9kcml2ZXJzL3RhcmdldC90YXJnZXRfY29yZV9wc2NzaS5jDQppbmRleCA1YzEyMTM3Li5l
ODEzMjI3IDEwMDY0NA0KLS0tIGEvZHJpdmVycy90YXJnZXQvdGFyZ2V0X2NvcmVfcHNjc2kuYw0K
KysrIGIvZHJpdmVycy90YXJnZXQvdGFyZ2V0X2NvcmVfcHNjc2kuYw0KQEAgLTEyOSwxMCArMTI5
LDEwIEBAIHN0YXRpYyBpbnQgcHNjc2lfcG1vZGVfZW5hYmxlX2hiYShzdHJ1Y3Qgc2VfaGJhICpo
YmEsIHVuc2lnbmVkIGxvbmcgbW9kZV9mbGFnKQ0KIAkgKiBwU0NTSSBIb3N0IElEIGFuZCBlbmFi
bGUgZm9yIHBoYmEgbW9kZQ0KIAkgKi8NCiAJc2ggPSBzY3NpX2hvc3RfbG9va3VwKHBodi0+cGh2
X2hvc3RfaWQpOw0KLQlpZiAoSVNfRVJSKHNoKSkgew0KKwlpZiAoIXNoKSB7DQogCQlwcl9lcnIo
InBTQ1NJOiBVbmFibGUgdG8gbG9jYXRlIFNDU0kgSG9zdCBmb3IiDQogCQkJIiBwaHZfaG9zdF9p
ZDogJWRcbiIsIHBodi0+cGh2X2hvc3RfaWQpOw0KLQkJcmV0dXJuIFBUUl9FUlIoc2gpOw0KKwkJ
cmV0dXJuIC1FSU5WQUw7DQogCX0NCiANCiAJcGh2LT5waHZfbGxkX2hvc3QgPSBzaDsNCkBAIC01
NjQsMTAgKzU2NCwxMCBAQCBzdGF0aWMgc3RydWN0IHNlX2RldmljZSAqcHNjc2lfY3JlYXRlX3Zp
cnRkZXZpY2UoDQogCQkJc2ggPSBwaHYtPnBodl9sbGRfaG9zdDsNCiAJCX0gZWxzZSB7DQogCQkJ
c2ggPSBzY3NpX2hvc3RfbG9va3VwKHBkdi0+cGR2X2hvc3RfaWQpOw0KLQkJCWlmIChJU19FUlIo
c2gpKSB7DQorCQkJaWYgKCFzaCkgew0KIAkJCQlwcl9lcnIoInBTQ1NJOiBVbmFibGUgdG8gbG9j
YXRlIg0KIAkJCQkJIiBwZHZfaG9zdF9pZDogJWRcbiIsIHBkdi0+cGR2X2hvc3RfaWQpOw0KLQkJ
CQlyZXR1cm4gRVJSX0NBU1Qoc2gpOw0KKwkJCQlyZXR1cm4gRVJSX1BUUigtRUlOVkFMKTsNCiAJ
CQl9DQogCQl9DQogCX0gZWxzZSB7DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy91aW8vdWlvLmMgYi9k
cml2ZXJzL3Vpby91aW8uYw0KaW5kZXggYTc4M2Q1My4uYWY1NzY0OCAxMDA2NDQNCi0tLSBhL2Ry
aXZlcnMvdWlvL3Vpby5jDQorKysgYi9kcml2ZXJzL3Vpby91aW8uYw0KQEAgLTY1MCwxNiArNjUw
LDI4IEBAIHN0YXRpYyBpbnQgdWlvX21tYXBfcGh5c2ljYWwoc3RydWN0IHZtX2FyZWFfc3RydWN0
ICp2bWEpDQogew0KIAlzdHJ1Y3QgdWlvX2RldmljZSAqaWRldiA9IHZtYS0+dm1fcHJpdmF0ZV9k
YXRhOw0KIAlpbnQgbWkgPSB1aW9fZmluZF9tZW1faW5kZXgodm1hKTsNCisJc3RydWN0IHVpb19t
ZW0gKm1lbTsNCiAJaWYgKG1pIDwgMCkNCiAJCXJldHVybiAtRUlOVkFMOw0KKwltZW0gPSBpZGV2
LT5pbmZvLT5tZW0gKyBtaTsNCiANCi0Jdm1hLT52bV9mbGFncyB8PSBWTV9JTyB8IFZNX1JFU0VS
VkVEOw0KKwlpZiAodm1hLT52bV9lbmQgLSB2bWEtPnZtX3N0YXJ0ID4gbWVtLT5zaXplKQ0KKwkJ
cmV0dXJuIC1FSU5WQUw7DQogDQogCXZtYS0+dm1fcGFnZV9wcm90ID0gcGdwcm90X25vbmNhY2hl
ZCh2bWEtPnZtX3BhZ2VfcHJvdCk7DQogDQorCS8qDQorCSAqIFdlIGNhbm5vdCB1c2UgdGhlIHZt
X2lvbWFwX21lbW9yeSgpIGhlbHBlciBoZXJlLA0KKwkgKiBiZWNhdXNlIHZtYS0+dm1fcGdvZmYg
aXMgdGhlIG1hcCBpbmRleCB3ZSBsb29rZWQNCisJICogdXAgYWJvdmUgaW4gdWlvX2ZpbmRfbWVt
X2luZGV4KCksIHJhdGhlciB0aGFuIGFuDQorCSAqIGFjdHVhbCBwYWdlIG9mZnNldCBpbnRvIHRo
ZSBtbWFwLg0KKwkgKg0KKwkgKiBTbyB3ZSBqdXN0IGRvIHRoZSBwaHlzaWNhbCBtbWFwIHdpdGhv
dXQgYSBwYWdlDQorCSAqIG9mZnNldC4NCisJICovDQogCXJldHVybiByZW1hcF9wZm5fcmFuZ2Uo
dm1hLA0KIAkJCSAgICAgICB2bWEtPnZtX3N0YXJ0LA0KLQkJCSAgICAgICBpZGV2LT5pbmZvLT5t
ZW1bbWldLmFkZHIgPj4gUEFHRV9TSElGVCwNCisJCQkgICAgICAgbWVtLT5hZGRyID4+IFBBR0Vf
U0hJRlQsDQogCQkJICAgICAgIHZtYS0+dm1fZW5kIC0gdm1hLT52bV9zdGFydCwNCiAJCQkgICAg
ICAgdm1hLT52bV9wYWdlX3Byb3QpOw0KIH0NCmRpZmYgLS1naXQgYS9kcml2ZXJzL3VzYi9jb3Jl
L3F1aXJrcy5jIGIvZHJpdmVycy91c2IvY29yZS9xdWlya3MuYw0KaW5kZXggZjUyMTgyZC4uYmNk
ZTZmNiAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvdXNiL2NvcmUvcXVpcmtzLmMNCisrKyBiL2RyaXZl
cnMvdXNiL2NvcmUvcXVpcmtzLmMNCkBAIC05Nyw2ICs5Nyw5IEBAIHN0YXRpYyBjb25zdCBzdHJ1
Y3QgdXNiX2RldmljZV9pZCB1c2JfcXVpcmtfbGlzdFtdID0gew0KIAkvKiBBbGNvciBNaWNybyBD
b3JwLiBIdWIgKi8NCiAJeyBVU0JfREVWSUNFKDB4MDU4ZiwgMHg5MjU0KSwgLmRyaXZlcl9pbmZv
ID0gVVNCX1FVSVJLX1JFU0VUX1JFU1VNRSB9LA0KIA0KKwkvKiBNaWNyb1RvdWNoIFN5c3RlbXMg
dG91Y2hzY3JlZW4gKi8NCisJeyBVU0JfREVWSUNFKDB4MDU5NiwgMHgwNTFlKSwgLmRyaXZlcl9p
bmZvID0gVVNCX1FVSVJLX1JFU0VUX1JFU1VNRSB9LA0KKw0KIAkvKiBhcHBsZXRvdWNoICovDQog
CXsgVVNCX0RFVklDRSgweDA1YWMsIDB4MDIxYSksIC5kcml2ZXJfaW5mbyA9IFVTQl9RVUlSS19S
RVNFVF9SRVNVTUUgfSwNCiANCkBAIC0xMzAsNiArMTMzLDkgQEAgc3RhdGljIGNvbnN0IHN0cnVj
dCB1c2JfZGV2aWNlX2lkIHVzYl9xdWlya19saXN0W10gPSB7DQogCS8qIEJyb2FkY29tIEJDTTky
MDM1REdST00gQlQgZG9uZ2xlICovDQogCXsgVVNCX0RFVklDRSgweDBhNWMsIDB4MjAyMSksIC5k
cml2ZXJfaW5mbyA9IFVTQl9RVUlSS19SRVNFVF9SRVNVTUUgfSwNCiANCisJLyogTUFZQTQ0VVNC
IHNvdW5kIGRldmljZSAqLw0KKwl7IFVTQl9ERVZJQ0UoMHgwYTkyLCAweDAwOTEpLCAuZHJpdmVy
X2luZm8gPSBVU0JfUVVJUktfUkVTRVRfUkVTVU1FIH0sDQorDQogCS8qIEFjdGlvbiBTZW1pY29u
ZHVjdG9yIGZsYXNoIGRpc2sgKi8NCiAJeyBVU0JfREVWSUNFKDB4MTBkNiwgMHgyMjAwKSwgLmRy
aXZlcl9pbmZvID0NCiAJCQlVU0JfUVVJUktfU1RSSU5HX0ZFVENIXzI1NSB9LA0KZGlmZiAtLWdp
dCBhL2RyaXZlcnMvdXNiL2hvc3QveGhjaS1odWIuYyBiL2RyaXZlcnMvdXNiL2hvc3QveGhjaS1o
dWIuYw0KaW5kZXggMjQxMDdhNy4uMTA3ZTZiNCAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvdXNiL2hv
c3QveGhjaS1odWIuYw0KKysrIGIvZHJpdmVycy91c2IvaG9zdC94aGNpLWh1Yi5jDQpAQCAtMTAw
NywyMCArMTAwNyw2IEBAIGludCB4aGNpX2J1c19zdXNwZW5kKHN0cnVjdCB1c2JfaGNkICpoY2Qp
DQogCQl0MSA9IHhoY2lfcG9ydF9zdGF0ZV90b19uZXV0cmFsKHQxKTsNCiAJCWlmICh0MSAhPSB0
MikNCiAJCQl4aGNpX3dyaXRlbCh4aGNpLCB0MiwgcG9ydF9hcnJheVtwb3J0X2luZGV4XSk7DQot
DQotCQlpZiAoaGNkLT5zcGVlZCAhPSBIQ0RfVVNCMykgew0KLQkJCS8qIGVuYWJsZSByZW1vdGUg
d2FrZSB1cCBmb3IgVVNCIDIuMCAqLw0KLQkJCV9fbGUzMiBfX2lvbWVtICphZGRyOw0KLQkJCXUz
MiB0bXA7DQotDQotCQkJLyogQWRkIG9uZSB0byB0aGUgcG9ydCBzdGF0dXMgcmVnaXN0ZXIgYWRk
cmVzcyB0byBnZXQNCi0JCQkgKiB0aGUgcG9ydCBwb3dlciBjb250cm9sIHJlZ2lzdGVyIGFkZHJl
c3MuDQotCQkJICovDQotCQkJYWRkciA9IHBvcnRfYXJyYXlbcG9ydF9pbmRleF0gKyAxOw0KLQkJ
CXRtcCA9IHhoY2lfcmVhZGwoeGhjaSwgYWRkcik7DQotCQkJdG1wIHw9IFBPUlRfUldFOw0KLQkJ
CXhoY2lfd3JpdGVsKHhoY2ksIHRtcCwgYWRkcik7DQotCQl9DQogCX0NCiAJaGNkLT5zdGF0ZSA9
IEhDX1NUQVRFX1NVU1BFTkRFRDsNCiAJYnVzX3N0YXRlLT5uZXh0X3N0YXRlY2hhbmdlID0gamlm
ZmllcyArIG1zZWNzX3RvX2ppZmZpZXMoMTApOw0KQEAgLTEwOTksMjAgKzEwODUsNiBAQCBpbnQg
eGhjaV9idXNfcmVzdW1lKHN0cnVjdCB1c2JfaGNkICpoY2QpDQogCQkJCXhoY2lfcmluZ19kZXZp
Y2UoeGhjaSwgc2xvdF9pZCk7DQogCQl9IGVsc2UNCiAJCQl4aGNpX3dyaXRlbCh4aGNpLCB0ZW1w
LCBwb3J0X2FycmF5W3BvcnRfaW5kZXhdKTsNCi0NCi0JCWlmIChoY2QtPnNwZWVkICE9IEhDRF9V
U0IzKSB7DQotCQkJLyogZGlzYWJsZSByZW1vdGUgd2FrZSB1cCBmb3IgVVNCIDIuMCAqLw0KLQkJ
CV9fbGUzMiBfX2lvbWVtICphZGRyOw0KLQkJCXUzMiB0bXA7DQotDQotCQkJLyogQWRkIG9uZSB0
byB0aGUgcG9ydCBzdGF0dXMgcmVnaXN0ZXIgYWRkcmVzcyB0byBnZXQNCi0JCQkgKiB0aGUgcG9y
dCBwb3dlciBjb250cm9sIHJlZ2lzdGVyIGFkZHJlc3MuDQotCQkJICovDQotCQkJYWRkciA9IHBv
cnRfYXJyYXlbcG9ydF9pbmRleF0gKyAxOw0KLQkJCXRtcCA9IHhoY2lfcmVhZGwoeGhjaSwgYWRk
cik7DQotCQkJdG1wICY9IH5QT1JUX1JXRTsNCi0JCQl4aGNpX3dyaXRlbCh4aGNpLCB0bXAsIGFk
ZHIpOw0KLQkJfQ0KIAl9DQogDQogCSh2b2lkKSB4aGNpX3JlYWRsKHhoY2ksICZ4aGNpLT5vcF9y
ZWdzLT5jb21tYW5kKTsNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3VzYi9ob3N0L3hoY2ktcGNpLmMg
Yi9kcml2ZXJzL3VzYi9ob3N0L3hoY2ktcGNpLmMNCmluZGV4IDYxYjA2NjguLjgyN2Y5MzMgMTAw
NjQ0DQotLS0gYS9kcml2ZXJzL3VzYi9ob3N0L3hoY2ktcGNpLmMNCisrKyBiL2RyaXZlcnMvdXNi
L2hvc3QveGhjaS1wY2kuYw0KQEAgLTM0LDYgKzM0LDkgQEANCiAjZGVmaW5lIFBDSV9WRU5ET1Jf
SURfRVRST04JCTB4MWI2Zg0KICNkZWZpbmUgUENJX0RFVklDRV9JRF9BU1JPQ0tfUDY3CTB4NzAy
Mw0KIA0KKyNkZWZpbmUgUENJX0RFVklDRV9JRF9JTlRFTF9MWU5YUE9JTlRfWEhDSQkweDhjMzEN
CisjZGVmaW5lIFBDSV9ERVZJQ0VfSURfSU5URUxfTFlOWFBPSU5UX0xQX1hIQ0kJMHg5YzMxDQor
DQogc3RhdGljIGNvbnN0IGNoYXIgaGNkX25hbWVbXSA9ICJ4aGNpX2hjZCI7DQogDQogLyogY2Fs
bGVkIGFmdGVyIHBvd2VydXAsIGJ5IHByb2JlIG9yIHN5c3RlbS1wbSAid2FrZXVwIiAqLw0KQEAg
LTY3LDYgKzcwLDE0IEBAIHN0YXRpYyB2b2lkIHhoY2lfcGNpX3F1aXJrcyhzdHJ1Y3QgZGV2aWNl
ICpkZXYsIHN0cnVjdCB4aGNpX2hjZCAqeGhjaSkNCiAJCQl4aGNpX2RiZyh4aGNpLCAiUVVJUks6
IEZyZXNjbyBMb2dpYyB4SEMgbmVlZHMgY29uZmlndXJlIg0KIAkJCQkJIiBlbmRwb2ludCBjbWQg
YWZ0ZXIgcmVzZXQgZW5kcG9pbnRcbiIpOw0KIAkJfQ0KKwkJaWYgKHBkZXYtPmRldmljZSA9PSBQ
Q0lfREVWSUNFX0lEX0ZSRVNDT19MT0dJQ19QREsgJiYNCisJCQkJcGRldi0+cmV2aXNpb24gPT0g
MHg0KSB7DQorCQkJeGhjaS0+cXVpcmtzIHw9IFhIQ0lfU0xPV19TVVNQRU5EOw0KKwkJCXhoY2lf
ZGJnKHhoY2ksDQorCQkJCSJRVUlSSzogRnJlc2NvIExvZ2ljIHhIQyByZXZpc2lvbiAldSINCisJ
CQkJIm11c3QgYmUgc3VzcGVuZGVkIGV4dHJhIHNsb3dseSIsDQorCQkJCXBkZXYtPnJldmlzaW9u
KTsNCisJCX0NCiAJCS8qIEZyZXNjbyBMb2dpYyBjb25maXJtczogYWxsIHJldmlzaW9ucyBvZiB0
aGlzIGNoaXAgZG8gbm90DQogCQkgKiBzdXBwb3J0IE1TSSwgZXZlbiB0aG91Z2ggc29tZSBvZiB0
aGVtIGNsYWltIHRvIGluIHRoZWlyIFBDSQ0KIAkJICogY2FwYWJpbGl0aWVzLg0KQEAgLTEwMyw2
ICsxMTQsMTUgQEAgc3RhdGljIHZvaWQgeGhjaV9wY2lfcXVpcmtzKHN0cnVjdCBkZXZpY2UgKmRl
diwgc3RydWN0IHhoY2lfaGNkICp4aGNpKQ0KIAkJeGhjaS0+cXVpcmtzIHw9IFhIQ0lfU1BVUklP
VVNfUkVCT09UOw0KIAkJeGhjaS0+cXVpcmtzIHw9IFhIQ0lfQVZPSURfQkVJOw0KIAl9DQorCWlm
IChwZGV2LT52ZW5kb3IgPT0gUENJX1ZFTkRPUl9JRF9JTlRFTCAmJg0KKwkgICAgKHBkZXYtPmRl
dmljZSA9PSBQQ0lfREVWSUNFX0lEX0lOVEVMX0xZTlhQT0lOVF9YSENJIHx8DQorCSAgICAgcGRl
di0+ZGV2aWNlID09IFBDSV9ERVZJQ0VfSURfSU5URUxfTFlOWFBPSU5UX0xQX1hIQ0kpKSB7DQor
CQkvKiBXb3JrYXJvdW5kIGZvciBvY2Nhc2lvbmFsIHNwdXJpb3VzIHdha2V1cHMgZnJvbSBTNSAo
b3INCisJCSAqIGFueSBvdGhlciBzbGVlcCkgb24gSGFzd2VsbCBtYWNoaW5lcyB3aXRoIExQVCBh
bmQgTFBULUxQDQorCQkgKiB3aXRoIHRoZSBuZXcgSW50ZWwgQklPUw0KKwkJICovDQorCQl4aGNp
LT5xdWlya3MgfD0gWEhDSV9TUFVSSU9VU19XQUtFVVA7DQorCX0NCiAJaWYgKHBkZXYtPnZlbmRv
ciA9PSBQQ0lfVkVORE9SX0lEX0VUUk9OICYmDQogCQkJcGRldi0+ZGV2aWNlID09IFBDSV9ERVZJ
Q0VfSURfQVNST0NLX1A2Nykgew0KIAkJeGhjaS0+cXVpcmtzIHw9IFhIQ0lfUkVTRVRfT05fUkVT
VU1FOw0KQEAgLTIwMiw2ICsyMjIsMTEgQEAgc3RhdGljIHZvaWQgeGhjaV9wY2lfcmVtb3ZlKHN0
cnVjdCBwY2lfZGV2ICpkZXYpDQogCQl1c2JfcHV0X2hjZCh4aGNpLT5zaGFyZWRfaGNkKTsNCiAJ
fQ0KIAl1c2JfaGNkX3BjaV9yZW1vdmUoZGV2KTsNCisNCisJLyogV29ya2Fyb3VuZCBmb3Igc3B1
cmlvdXMgd2FrZXVwcyBhdCBzaHV0ZG93biB3aXRoIEhTVyAqLw0KKwlpZiAoeGhjaS0+cXVpcmtz
ICYgWEhDSV9TUFVSSU9VU19XQUtFVVApDQorCQlwY2lfc2V0X3Bvd2VyX3N0YXRlKGRldiwgUENJ
X0QzaG90KTsNCisNCiAJa2ZyZWUoeGhjaSk7DQogfQ0KIA0KZGlmZiAtLWdpdCBhL2RyaXZlcnMv
dXNiL2hvc3QveGhjaS5jIGIvZHJpdmVycy91c2IvaG9zdC94aGNpLmMNCmluZGV4IDYyOWFhNzQu
LjAzYzM1ZGEgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3VzYi9ob3N0L3hoY2kuYw0KKysrIGIvZHJp
dmVycy91c2IvaG9zdC94aGNpLmMNCkBAIC03NjMsMTIgKzc2MywxOSBAQCB2b2lkIHhoY2lfc2h1
dGRvd24oc3RydWN0IHVzYl9oY2QgKmhjZCkNCiANCiAJc3Bpbl9sb2NrX2lycSgmeGhjaS0+bG9j
ayk7DQogCXhoY2lfaGFsdCh4aGNpKTsNCisJLyogV29ya2Fyb3VuZCBmb3Igc3B1cmlvdXMgd2Fr
ZXVwcyBhdCBzaHV0ZG93biB3aXRoIEhTVyAqLw0KKwlpZiAoeGhjaS0+cXVpcmtzICYgWEhDSV9T
UFVSSU9VU19XQUtFVVApDQorCQl4aGNpX3Jlc2V0KHhoY2kpOw0KIAlzcGluX3VubG9ja19pcnEo
JnhoY2ktPmxvY2spOw0KIA0KIAl4aGNpX2NsZWFudXBfbXNpeCh4aGNpKTsNCiANCiAJeGhjaV9k
YmcoeGhjaSwgInhoY2lfc2h1dGRvd24gY29tcGxldGVkIC0gc3RhdHVzID0gJXhcbiIsDQogCQkg
ICAgeGhjaV9yZWFkbCh4aGNpLCAmeGhjaS0+b3BfcmVncy0+c3RhdHVzKSk7DQorDQorCS8qIFll
dCBhbm90aGVyIHdvcmthcm91bmQgZm9yIHNwdXJpb3VzIHdha2V1cHMgYXQgc2h1dGRvd24gd2l0
aCBIU1cgKi8NCisJaWYgKHhoY2ktPnF1aXJrcyAmIFhIQ0lfU1BVUklPVVNfV0FLRVVQKQ0KKwkJ
cGNpX3NldF9wb3dlcl9zdGF0ZSh0b19wY2lfZGV2KGhjZC0+c2VsZi5jb250cm9sbGVyKSwgUENJ
X0QzaG90KTsNCiB9DQogDQogI2lmZGVmIENPTkZJR19QTQ0KQEAgLTg2OSw2ICs4NzYsNyBAQCBz
dGF0aWMgdm9pZCB4aGNpX2NsZWFyX2NvbW1hbmRfcmluZyhzdHJ1Y3QgeGhjaV9oY2QgKnhoY2kp
DQogaW50IHhoY2lfc3VzcGVuZChzdHJ1Y3QgeGhjaV9oY2QgKnhoY2kpDQogew0KIAlpbnQJCQly
YyA9IDA7DQorCXVuc2lnbmVkIGludAkJZGVsYXkgPSBYSENJX01BWF9IQUxUX1VTRUM7DQogCXN0
cnVjdCB1c2JfaGNkCQkqaGNkID0geGhjaV90b19oY2QoeGhjaSk7DQogCXUzMgkJCWNvbW1hbmQ7
DQogDQpAQCAtODg3LDggKzg5NSwxMiBAQCBpbnQgeGhjaV9zdXNwZW5kKHN0cnVjdCB4aGNpX2hj
ZCAqeGhjaSkNCiAJY29tbWFuZCA9IHhoY2lfcmVhZGwoeGhjaSwgJnhoY2ktPm9wX3JlZ3MtPmNv
bW1hbmQpOw0KIAljb21tYW5kICY9IH5DTURfUlVOOw0KIAl4aGNpX3dyaXRlbCh4aGNpLCBjb21t
YW5kLCAmeGhjaS0+b3BfcmVncy0+Y29tbWFuZCk7DQorDQorCS8qIFNvbWUgY2hpcHMgZnJvbSBG
cmVzY28gTG9naWMgbmVlZCBhbiBleHRyYW9yZGluYXJ5IGRlbGF5ICovDQorCWRlbGF5ICo9ICh4
aGNpLT5xdWlya3MgJiBYSENJX1NMT1dfU1VTUEVORCkgPyAxMCA6IDE7DQorDQogCWlmIChoYW5k
c2hha2UoeGhjaSwgJnhoY2ktPm9wX3JlZ3MtPnN0YXR1cywNCi0JCSAgICAgIFNUU19IQUxULCBT
VFNfSEFMVCwgWEhDSV9NQVhfSEFMVF9VU0VDKSkgew0KKwkJICAgICAgU1RTX0hBTFQsIFNUU19I
QUxULCBkZWxheSkpIHsNCiAJCXhoY2lfd2Fybih4aGNpLCAiV0FSTjogeEhDIENNRF9SVU4gdGlt
ZW91dFxuIik7DQogCQlzcGluX3VubG9ja19pcnEoJnhoY2ktPmxvY2spOw0KIAkJcmV0dXJuIC1F
VElNRURPVVQ7DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy91c2IvaG9zdC94aGNpLmggYi9kcml2ZXJz
L3VzYi9ob3N0L3hoY2kuaA0KaW5kZXggOGI0Y2NlNDUuLmNmNGZkMjQgMTAwNjQ0DQotLS0gYS9k
cml2ZXJzL3VzYi9ob3N0L3hoY2kuaA0KKysrIGIvZHJpdmVycy91c2IvaG9zdC94aGNpLmgNCkBA
IC0xNDkzLDYgKzE0OTMsOCBAQCBzdHJ1Y3QgeGhjaV9oY2Qgew0KICNkZWZpbmUgWEhDSV9TUFVS
SU9VU19SRUJPT1QJKDEgPDwgMTMpDQogI2RlZmluZSBYSENJX0NPTVBfTU9ERV9RVUlSSwkoMSA8
PCAxNCkNCiAjZGVmaW5lIFhIQ0lfQVZPSURfQkVJCQkoMSA8PCAxNSkNCisjZGVmaW5lIFhIQ0lf
U0xPV19TVVNQRU5ECSgxIDw8IDE3KQ0KKyNkZWZpbmUgWEhDSV9TUFVSSU9VU19XQUtFVVAJKDEg
PDwgMTgpDQogCXVuc2lnbmVkIGludAkJbnVtX2FjdGl2ZV9lcHM7DQogCXVuc2lnbmVkIGludAkJ
bGltaXRfYWN0aXZlX2VwczsNCiAJLyogVGhlcmUgYXJlIHR3byByb290aHVicyB0byBrZWVwIHRy
YWNrIG9mIGJ1cyBzdXNwZW5kIGluZm8gZm9yICovDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy91c2Iv
c2VyaWFsL29wdGlvbi5jIGIvZHJpdmVycy91c2Ivc2VyaWFsL29wdGlvbi5jDQppbmRleCA1MzZj
NGFkLi5kOGFjZTgyIDEwMDY0NA0KLS0tIGEvZHJpdmVycy91c2Ivc2VyaWFsL29wdGlvbi5jDQor
KysgYi9kcml2ZXJzL3VzYi9zZXJpYWwvb3B0aW9uLmMNCkBAIC00NTcsNiArNDU3LDEwIEBAIHN0
YXRpYyB2b2lkIG9wdGlvbl9pbnN0YXRfY2FsbGJhY2soc3RydWN0IHVyYiAqdXJiKTsNCiAjZGVm
aW5lIENIQU5HSE9OR19WRU5ET1JfSUQJCQkweDIwNzcNCiAjZGVmaW5lIENIQU5HSE9OR19QUk9E
VUNUX0NINjkwCQkJMHg3MDAxDQogDQorLyogSW5vdmlhICovDQorI2RlZmluZSBJTk9WSUFfVkVO
RE9SX0lECQkJMHgyMGE2DQorI2RlZmluZSBJTk9WSUFfU0VXODU4CQkJCTB4MTEwNQ0KKw0KIC8q
IHNvbWUgZGV2aWNlcyBpbnRlcmZhY2VzIG5lZWQgc3BlY2lhbCBoYW5kbGluZyBkdWUgdG8gYSBu
dW1iZXIgb2YgcmVhc29ucyAqLw0KIGVudW0gb3B0aW9uX2JsYWNrbGlzdF9yZWFzb24gew0KIAkJ
T1BUSU9OX0JMQUNLTElTVF9OT05FID0gMCwNCkBAIC03MDMsNiArNzA3LDIyMiBAQCBzdGF0aWMg
Y29uc3Qgc3RydWN0IHVzYl9kZXZpY2VfaWQgb3B0aW9uX2lkc1tdID0gew0KIAl7IFVTQl9WRU5E
T1JfQU5EX0lOVEVSRkFDRV9JTkZPKEhVQVdFSV9WRU5ET1JfSUQsIDB4ZmYsIDB4MDIsIDB4N0Ep
IH0sDQogCXsgVVNCX1ZFTkRPUl9BTkRfSU5URVJGQUNFX0lORk8oSFVBV0VJX1ZFTkRPUl9JRCwg
MHhmZiwgMHgwMiwgMHg3QikgfSwNCiAJeyBVU0JfVkVORE9SX0FORF9JTlRFUkZBQ0VfSU5GTyhI
VUFXRUlfVkVORE9SX0lELCAweGZmLCAweDAyLCAweDdDKSB9LA0KKwl7IFVTQl9WRU5ET1JfQU5E
X0lOVEVSRkFDRV9JTkZPKEhVQVdFSV9WRU5ET1JfSUQsIDB4ZmYsIDB4MDMsIDB4MDEpIH0sDQor
CXsgVVNCX1ZFTkRPUl9BTkRfSU5URVJGQUNFX0lORk8oSFVBV0VJX1ZFTkRPUl9JRCwgMHhmZiwg
MHgwMywgMHgwMikgfSwNCisJeyBVU0JfVkVORE9SX0FORF9JTlRFUkZBQ0VfSU5GTyhIVUFXRUlf
VkVORE9SX0lELCAweGZmLCAweDAzLCAweDAzKSB9LA0KKwl7IFVTQl9WRU5ET1JfQU5EX0lOVEVS
RkFDRV9JTkZPKEhVQVdFSV9WRU5ET1JfSUQsIDB4ZmYsIDB4MDMsIDB4MDQpIH0sDQorCXsgVVNC
X1ZFTkRPUl9BTkRfSU5URVJGQUNFX0lORk8oSFVBV0VJX1ZFTkRPUl9JRCwgMHhmZiwgMHgwMywg
MHgwNSkgfSwNCisJeyBVU0JfVkVORE9SX0FORF9JTlRFUkZBQ0VfSU5GTyhIVUFXRUlfVkVORE9S
X0lELCAweGZmLCAweDAzLCAweDA2KSB9LA0KKwl7IFVTQl9WRU5ET1JfQU5EX0lOVEVSRkFDRV9J
TkZPKEhVQVdFSV9WRU5ET1JfSUQsIDB4ZmYsIDB4MDMsIDB4MEEpIH0sDQorCXsgVVNCX1ZFTkRP
Ul9BTkRfSU5URVJGQUNFX0lORk8oSFVBV0VJX1ZFTkRPUl9JRCwgMHhmZiwgMHgwMywgMHgwQikg
fSwNCisJeyBVU0JfVkVORE9SX0FORF9JTlRFUkZBQ0VfSU5GTyhIVUFXRUlfVkVORE9SX0lELCAw
eGZmLCAweDAzLCAweDBEKSB9LA0KKwl7IFVTQl9WRU5ET1JfQU5EX0lOVEVSRkFDRV9JTkZPKEhV
QVdFSV9WRU5ET1JfSUQsIDB4ZmYsIDB4MDMsIDB4MEUpIH0sDQorCXsgVVNCX1ZFTkRPUl9BTkRf
SU5URVJGQUNFX0lORk8oSFVBV0VJX1ZFTkRPUl9JRCwgMHhmZiwgMHgwMywgMHgwRikgfSwNCisJ
eyBVU0JfVkVORE9SX0FORF9JTlRFUkZBQ0VfSU5GTyhIVUFXRUlfVkVORE9SX0lELCAweGZmLCAw
eDAzLCAweDEwKSB9LA0KKwl7IFVTQl9WRU5ET1JfQU5EX0lOVEVSRkFDRV9JTkZPKEhVQVdFSV9W
RU5ET1JfSUQsIDB4ZmYsIDB4MDMsIDB4MTIpIH0sDQorCXsgVVNCX1ZFTkRPUl9BTkRfSU5URVJG
QUNFX0lORk8oSFVBV0VJX1ZFTkRPUl9JRCwgMHhmZiwgMHgwMywgMHgxMykgfSwNCisJeyBVU0Jf
VkVORE9SX0FORF9JTlRFUkZBQ0VfSU5GTyhIVUFXRUlfVkVORE9SX0lELCAweGZmLCAweDAzLCAw
eDE0KSB9LA0KKwl7IFVTQl9WRU5ET1JfQU5EX0lOVEVSRkFDRV9JTkZPKEhVQVdFSV9WRU5ET1Jf
SUQsIDB4ZmYsIDB4MDMsIDB4MTUpIH0sDQorCXsgVVNCX1ZFTkRPUl9BTkRfSU5URVJGQUNFX0lO
Rk8oSFVBV0VJX1ZFTkRPUl9JRCwgMHhmZiwgMHgwMywgMHgxNykgfSwNCisJeyBVU0JfVkVORE9S
X0FORF9JTlRFUkZBQ0VfSU5GTyhIVUFXRUlfVkVORE9SX0lELCAweGZmLCAweDAzLCAweDE4KSB9
LA0KKwl7IFVTQl9WRU5ET1JfQU5EX0lOVEVSRkFDRV9JTkZPKEhVQVdFSV9WRU5ET1JfSUQsIDB4
ZmYsIDB4MDMsIDB4MTkpIH0sDQorCXsgVVNCX1ZFTkRPUl9BTkRfSU5URVJGQUNFX0lORk8oSFVB
V0VJX1ZFTkRPUl9JRCwgMHhmZiwgMHgwMywgMHgxQSkgfSwNCisJeyBVU0JfVkVORE9SX0FORF9J
TlRFUkZBQ0VfSU5GTyhIVUFXRUlfVkVORE9SX0lELCAweGZmLCAweDAzLCAweDFCKSB9LA0KKwl7
IFVTQl9WRU5ET1JfQU5EX0lOVEVSRkFDRV9JTkZPKEhVQVdFSV9WRU5ET1JfSUQsIDB4ZmYsIDB4
MDMsIDB4MUMpIH0sDQorCXsgVVNCX1ZFTkRPUl9BTkRfSU5URVJGQUNFX0lORk8oSFVBV0VJX1ZF
TkRPUl9JRCwgMHhmZiwgMHgwMywgMHgzMSkgfSwNCisJeyBVU0JfVkVORE9SX0FORF9JTlRFUkZB
Q0VfSU5GTyhIVUFXRUlfVkVORE9SX0lELCAweGZmLCAweDAzLCAweDMyKSB9LA0KKwl7IFVTQl9W
RU5ET1JfQU5EX0lOVEVSRkFDRV9JTkZPKEhVQVdFSV9WRU5ET1JfSUQsIDB4ZmYsIDB4MDMsIDB4
MzMpIH0sDQorCXsgVVNCX1ZFTkRPUl9BTkRfSU5URVJGQUNFX0lORk8oSFVBV0VJX1ZFTkRPUl9J
RCwgMHhmZiwgMHgwMywgMHgzNCkgfSwNCisJeyBVU0JfVkVORE9SX0FORF9JTlRFUkZBQ0VfSU5G
TyhIVUFXRUlfVkVORE9SX0lELCAweGZmLCAweDAzLCAweDM1KSB9LA0KKwl7IFVTQl9WRU5ET1Jf
QU5EX0lOVEVSRkFDRV9JTkZPKEhVQVdFSV9WRU5ET1JfSUQsIDB4ZmYsIDB4MDMsIDB4MzYpIH0s
DQorCXsgVVNCX1ZFTkRPUl9BTkRfSU5URVJGQUNFX0lORk8oSFVBV0VJX1ZFTkRPUl9JRCwgMHhm
ZiwgMHgwMywgMHgzQSkgfSwNCisJeyBVU0JfVkVORE9SX0FORF9JTlRFUkZBQ0VfSU5GTyhIVUFX
RUlfVkVORE9SX0lELCAweGZmLCAweDAzLCAweDNCKSB9LA0KKwl7IFVTQl9WRU5ET1JfQU5EX0lO
VEVSRkFDRV9JTkZPKEhVQVdFSV9WRU5ET1JfSUQsIDB4ZmYsIDB4MDMsIDB4M0QpIH0sDQorCXsg
VVNCX1ZFTkRPUl9BTkRfSU5URVJGQUNFX0lORk8oSFVBV0VJX1ZFTkRPUl9JRCwgMHhmZiwgMHgw
MywgMHgzRSkgfSwNCisJeyBVU0JfVkVORE9SX0FORF9JTlRFUkZBQ0VfSU5GTyhIVUFXRUlfVkVO
RE9SX0lELCAweGZmLCAweDAzLCAweDNGKSB9LA0KKwl7IFVTQl9WRU5ET1JfQU5EX0lOVEVSRkFD
RV9JTkZPKEhVQVdFSV9WRU5ET1JfSUQsIDB4ZmYsIDB4MDMsIDB4NDgpIH0sDQorCXsgVVNCX1ZF
TkRPUl9BTkRfSU5URVJGQUNFX0lORk8oSFVBV0VJX1ZFTkRPUl9JRCwgMHhmZiwgMHgwMywgMHg0
OSkgfSwNCisJeyBVU0JfVkVORE9SX0FORF9JTlRFUkZBQ0VfSU5GTyhIVUFXRUlfVkVORE9SX0lE
LCAweGZmLCAweDAzLCAweDRBKSB9LA0KKwl7IFVTQl9WRU5ET1JfQU5EX0lOVEVSRkFDRV9JTkZP
KEhVQVdFSV9WRU5ET1JfSUQsIDB4ZmYsIDB4MDMsIDB4NEIpIH0sDQorCXsgVVNCX1ZFTkRPUl9B
TkRfSU5URVJGQUNFX0lORk8oSFVBV0VJX1ZFTkRPUl9JRCwgMHhmZiwgMHgwMywgMHg0QykgfSwN
CisJeyBVU0JfVkVORE9SX0FORF9JTlRFUkZBQ0VfSU5GTyhIVUFXRUlfVkVORE9SX0lELCAweGZm
LCAweDAzLCAweDYxKSB9LA0KKwl7IFVTQl9WRU5ET1JfQU5EX0lOVEVSRkFDRV9JTkZPKEhVQVdF
SV9WRU5ET1JfSUQsIDB4ZmYsIDB4MDMsIDB4NjIpIH0sDQorCXsgVVNCX1ZFTkRPUl9BTkRfSU5U
RVJGQUNFX0lORk8oSFVBV0VJX1ZFTkRPUl9JRCwgMHhmZiwgMHgwMywgMHg2MykgfSwNCisJeyBV
U0JfVkVORE9SX0FORF9JTlRFUkZBQ0VfSU5GTyhIVUFXRUlfVkVORE9SX0lELCAweGZmLCAweDAz
LCAweDY0KSB9LA0KKwl7IFVTQl9WRU5ET1JfQU5EX0lOVEVSRkFDRV9JTkZPKEhVQVdFSV9WRU5E
T1JfSUQsIDB4ZmYsIDB4MDMsIDB4NjUpIH0sDQorCXsgVVNCX1ZFTkRPUl9BTkRfSU5URVJGQUNF
X0lORk8oSFVBV0VJX1ZFTkRPUl9JRCwgMHhmZiwgMHgwMywgMHg2NikgfSwNCisJeyBVU0JfVkVO
RE9SX0FORF9JTlRFUkZBQ0VfSU5GTyhIVUFXRUlfVkVORE9SX0lELCAweGZmLCAweDAzLCAweDZB
KSB9LA0KKwl7IFVTQl9WRU5ET1JfQU5EX0lOVEVSRkFDRV9JTkZPKEhVQVdFSV9WRU5ET1JfSUQs
IDB4ZmYsIDB4MDMsIDB4NkIpIH0sDQorCXsgVVNCX1ZFTkRPUl9BTkRfSU5URVJGQUNFX0lORk8o
SFVBV0VJX1ZFTkRPUl9JRCwgMHhmZiwgMHgwMywgMHg2RCkgfSwNCisJeyBVU0JfVkVORE9SX0FO
RF9JTlRFUkZBQ0VfSU5GTyhIVUFXRUlfVkVORE9SX0lELCAweGZmLCAweDAzLCAweDZFKSB9LA0K
Kwl7IFVTQl9WRU5ET1JfQU5EX0lOVEVSRkFDRV9JTkZPKEhVQVdFSV9WRU5ET1JfSUQsIDB4ZmYs
IDB4MDMsIDB4NkYpIH0sDQorCXsgVVNCX1ZFTkRPUl9BTkRfSU5URVJGQUNFX0lORk8oSFVBV0VJ
X1ZFTkRPUl9JRCwgMHhmZiwgMHgwMywgMHg3OCkgfSwNCisJeyBVU0JfVkVORE9SX0FORF9JTlRF
UkZBQ0VfSU5GTyhIVUFXRUlfVkVORE9SX0lELCAweGZmLCAweDAzLCAweDc5KSB9LA0KKwl7IFVT
Ql9WRU5ET1JfQU5EX0lOVEVSRkFDRV9JTkZPKEhVQVdFSV9WRU5ET1JfSUQsIDB4ZmYsIDB4MDMs
IDB4N0EpIH0sDQorCXsgVVNCX1ZFTkRPUl9BTkRfSU5URVJGQUNFX0lORk8oSFVBV0VJX1ZFTkRP
Ul9JRCwgMHhmZiwgMHgwMywgMHg3QikgfSwNCisJeyBVU0JfVkVORE9SX0FORF9JTlRFUkZBQ0Vf
SU5GTyhIVUFXRUlfVkVORE9SX0lELCAweGZmLCAweDAzLCAweDdDKSB9LA0KKwl7IFVTQl9WRU5E
T1JfQU5EX0lOVEVSRkFDRV9JTkZPKEhVQVdFSV9WRU5ET1JfSUQsIDB4ZmYsIDB4MDQsIDB4MDEp
IH0sDQorCXsgVVNCX1ZFTkRPUl9BTkRfSU5URVJGQUNFX0lORk8oSFVBV0VJX1ZFTkRPUl9JRCwg
MHhmZiwgMHgwNCwgMHgwMikgfSwNCisJeyBVU0JfVkVORE9SX0FORF9JTlRFUkZBQ0VfSU5GTyhI
VUFXRUlfVkVORE9SX0lELCAweGZmLCAweDA0LCAweDAzKSB9LA0KKwl7IFVTQl9WRU5ET1JfQU5E
X0lOVEVSRkFDRV9JTkZPKEhVQVdFSV9WRU5ET1JfSUQsIDB4ZmYsIDB4MDQsIDB4MDQpIH0sDQor
CXsgVVNCX1ZFTkRPUl9BTkRfSU5URVJGQUNFX0lORk8oSFVBV0VJX1ZFTkRPUl9JRCwgMHhmZiwg
MHgwNCwgMHgwNSkgfSwNCisJeyBVU0JfVkVORE9SX0FORF9JTlRFUkZBQ0VfSU5GTyhIVUFXRUlf
VkVORE9SX0lELCAweGZmLCAweDA0LCAweDA2KSB9LA0KKwl7IFVTQl9WRU5ET1JfQU5EX0lOVEVS
RkFDRV9JTkZPKEhVQVdFSV9WRU5ET1JfSUQsIDB4ZmYsIDB4MDQsIDB4MEEpIH0sDQorCXsgVVNC
X1ZFTkRPUl9BTkRfSU5URVJGQUNFX0lORk8oSFVBV0VJX1ZFTkRPUl9JRCwgMHhmZiwgMHgwNCwg
MHgwQikgfSwNCisJeyBVU0JfVkVORE9SX0FORF9JTlRFUkZBQ0VfSU5GTyhIVUFXRUlfVkVORE9S
X0lELCAweGZmLCAweDA0LCAweDBEKSB9LA0KKwl7IFVTQl9WRU5ET1JfQU5EX0lOVEVSRkFDRV9J
TkZPKEhVQVdFSV9WRU5ET1JfSUQsIDB4ZmYsIDB4MDQsIDB4MEUpIH0sDQorCXsgVVNCX1ZFTkRP
Ul9BTkRfSU5URVJGQUNFX0lORk8oSFVBV0VJX1ZFTkRPUl9JRCwgMHhmZiwgMHgwNCwgMHgwRikg
fSwNCisJeyBVU0JfVkVORE9SX0FORF9JTlRFUkZBQ0VfSU5GTyhIVUFXRUlfVkVORE9SX0lELCAw
eGZmLCAweDA0LCAweDEwKSB9LA0KKwl7IFVTQl9WRU5ET1JfQU5EX0lOVEVSRkFDRV9JTkZPKEhV
QVdFSV9WRU5ET1JfSUQsIDB4ZmYsIDB4MDQsIDB4MTIpIH0sDQorCXsgVVNCX1ZFTkRPUl9BTkRf
SU5URVJGQUNFX0lORk8oSFVBV0VJX1ZFTkRPUl9JRCwgMHhmZiwgMHgwNCwgMHgxMykgfSwNCisJ
eyBVU0JfVkVORE9SX0FORF9JTlRFUkZBQ0VfSU5GTyhIVUFXRUlfVkVORE9SX0lELCAweGZmLCAw
eDA0LCAweDE0KSB9LA0KKwl7IFVTQl9WRU5ET1JfQU5EX0lOVEVSRkFDRV9JTkZPKEhVQVdFSV9W
RU5ET1JfSUQsIDB4ZmYsIDB4MDQsIDB4MTUpIH0sDQorCXsgVVNCX1ZFTkRPUl9BTkRfSU5URVJG
QUNFX0lORk8oSFVBV0VJX1ZFTkRPUl9JRCwgMHhmZiwgMHgwNCwgMHgxNykgfSwNCisJeyBVU0Jf
VkVORE9SX0FORF9JTlRFUkZBQ0VfSU5GTyhIVUFXRUlfVkVORE9SX0lELCAweGZmLCAweDA0LCAw
eDE4KSB9LA0KKwl7IFVTQl9WRU5ET1JfQU5EX0lOVEVSRkFDRV9JTkZPKEhVQVdFSV9WRU5ET1Jf
SUQsIDB4ZmYsIDB4MDQsIDB4MTkpIH0sDQorCXsgVVNCX1ZFTkRPUl9BTkRfSU5URVJGQUNFX0lO
Rk8oSFVBV0VJX1ZFTkRPUl9JRCwgMHhmZiwgMHgwNCwgMHgxQSkgfSwNCisJeyBVU0JfVkVORE9S
X0FORF9JTlRFUkZBQ0VfSU5GTyhIVUFXRUlfVkVORE9SX0lELCAweGZmLCAweDA0LCAweDFCKSB9
LA0KKwl7IFVTQl9WRU5ET1JfQU5EX0lOVEVSRkFDRV9JTkZPKEhVQVdFSV9WRU5ET1JfSUQsIDB4
ZmYsIDB4MDQsIDB4MUMpIH0sDQorCXsgVVNCX1ZFTkRPUl9BTkRfSU5URVJGQUNFX0lORk8oSFVB
V0VJX1ZFTkRPUl9JRCwgMHhmZiwgMHgwNCwgMHgzMSkgfSwNCisJeyBVU0JfVkVORE9SX0FORF9J
TlRFUkZBQ0VfSU5GTyhIVUFXRUlfVkVORE9SX0lELCAweGZmLCAweDA0LCAweDMyKSB9LA0KKwl7
IFVTQl9WRU5ET1JfQU5EX0lOVEVSRkFDRV9JTkZPKEhVQVdFSV9WRU5ET1JfSUQsIDB4ZmYsIDB4
MDQsIDB4MzMpIH0sDQorCXsgVVNCX1ZFTkRPUl9BTkRfSU5URVJGQUNFX0lORk8oSFVBV0VJX1ZF
TkRPUl9JRCwgMHhmZiwgMHgwNCwgMHgzNCkgfSwNCisJeyBVU0JfVkVORE9SX0FORF9JTlRFUkZB
Q0VfSU5GTyhIVUFXRUlfVkVORE9SX0lELCAweGZmLCAweDA0LCAweDM1KSB9LA0KKwl7IFVTQl9W
RU5ET1JfQU5EX0lOVEVSRkFDRV9JTkZPKEhVQVdFSV9WRU5ET1JfSUQsIDB4ZmYsIDB4MDQsIDB4
MzYpIH0sDQorCXsgVVNCX1ZFTkRPUl9BTkRfSU5URVJGQUNFX0lORk8oSFVBV0VJX1ZFTkRPUl9J
RCwgMHhmZiwgMHgwNCwgMHgzQSkgfSwNCisJeyBVU0JfVkVORE9SX0FORF9JTlRFUkZBQ0VfSU5G
TyhIVUFXRUlfVkVORE9SX0lELCAweGZmLCAweDA0LCAweDNCKSB9LA0KKwl7IFVTQl9WRU5ET1Jf
QU5EX0lOVEVSRkFDRV9JTkZPKEhVQVdFSV9WRU5ET1JfSUQsIDB4ZmYsIDB4MDQsIDB4M0QpIH0s
DQorCXsgVVNCX1ZFTkRPUl9BTkRfSU5URVJGQUNFX0lORk8oSFVBV0VJX1ZFTkRPUl9JRCwgMHhm
ZiwgMHgwNCwgMHgzRSkgfSwNCisJeyBVU0JfVkVORE9SX0FORF9JTlRFUkZBQ0VfSU5GTyhIVUFX
RUlfVkVORE9SX0lELCAweGZmLCAweDA0LCAweDNGKSB9LA0KKwl7IFVTQl9WRU5ET1JfQU5EX0lO
VEVSRkFDRV9JTkZPKEhVQVdFSV9WRU5ET1JfSUQsIDB4ZmYsIDB4MDQsIDB4NDgpIH0sDQorCXsg
VVNCX1ZFTkRPUl9BTkRfSU5URVJGQUNFX0lORk8oSFVBV0VJX1ZFTkRPUl9JRCwgMHhmZiwgMHgw
NCwgMHg0OSkgfSwNCisJeyBVU0JfVkVORE9SX0FORF9JTlRFUkZBQ0VfSU5GTyhIVUFXRUlfVkVO
RE9SX0lELCAweGZmLCAweDA0LCAweDRBKSB9LA0KKwl7IFVTQl9WRU5ET1JfQU5EX0lOVEVSRkFD
RV9JTkZPKEhVQVdFSV9WRU5ET1JfSUQsIDB4ZmYsIDB4MDQsIDB4NEIpIH0sDQorCXsgVVNCX1ZF
TkRPUl9BTkRfSU5URVJGQUNFX0lORk8oSFVBV0VJX1ZFTkRPUl9JRCwgMHhmZiwgMHgwNCwgMHg0
QykgfSwNCisJeyBVU0JfVkVORE9SX0FORF9JTlRFUkZBQ0VfSU5GTyhIVUFXRUlfVkVORE9SX0lE
LCAweGZmLCAweDA0LCAweDYxKSB9LA0KKwl7IFVTQl9WRU5ET1JfQU5EX0lOVEVSRkFDRV9JTkZP
KEhVQVdFSV9WRU5ET1JfSUQsIDB4ZmYsIDB4MDQsIDB4NjIpIH0sDQorCXsgVVNCX1ZFTkRPUl9B
TkRfSU5URVJGQUNFX0lORk8oSFVBV0VJX1ZFTkRPUl9JRCwgMHhmZiwgMHgwNCwgMHg2MykgfSwN
CisJeyBVU0JfVkVORE9SX0FORF9JTlRFUkZBQ0VfSU5GTyhIVUFXRUlfVkVORE9SX0lELCAweGZm
LCAweDA0LCAweDY0KSB9LA0KKwl7IFVTQl9WRU5ET1JfQU5EX0lOVEVSRkFDRV9JTkZPKEhVQVdF
SV9WRU5ET1JfSUQsIDB4ZmYsIDB4MDQsIDB4NjUpIH0sDQorCXsgVVNCX1ZFTkRPUl9BTkRfSU5U
RVJGQUNFX0lORk8oSFVBV0VJX1ZFTkRPUl9JRCwgMHhmZiwgMHgwNCwgMHg2NikgfSwNCisJeyBV
U0JfVkVORE9SX0FORF9JTlRFUkZBQ0VfSU5GTyhIVUFXRUlfVkVORE9SX0lELCAweGZmLCAweDA0
LCAweDZBKSB9LA0KKwl7IFVTQl9WRU5ET1JfQU5EX0lOVEVSRkFDRV9JTkZPKEhVQVdFSV9WRU5E
T1JfSUQsIDB4ZmYsIDB4MDQsIDB4NkIpIH0sDQorCXsgVVNCX1ZFTkRPUl9BTkRfSU5URVJGQUNF
X0lORk8oSFVBV0VJX1ZFTkRPUl9JRCwgMHhmZiwgMHgwNCwgMHg2RCkgfSwNCisJeyBVU0JfVkVO
RE9SX0FORF9JTlRFUkZBQ0VfSU5GTyhIVUFXRUlfVkVORE9SX0lELCAweGZmLCAweDA0LCAweDZF
KSB9LA0KKwl7IFVTQl9WRU5ET1JfQU5EX0lOVEVSRkFDRV9JTkZPKEhVQVdFSV9WRU5ET1JfSUQs
IDB4ZmYsIDB4MDQsIDB4NkYpIH0sDQorCXsgVVNCX1ZFTkRPUl9BTkRfSU5URVJGQUNFX0lORk8o
SFVBV0VJX1ZFTkRPUl9JRCwgMHhmZiwgMHgwNCwgMHg3OCkgfSwNCisJeyBVU0JfVkVORE9SX0FO
RF9JTlRFUkZBQ0VfSU5GTyhIVUFXRUlfVkVORE9SX0lELCAweGZmLCAweDA0LCAweDc5KSB9LA0K
Kwl7IFVTQl9WRU5ET1JfQU5EX0lOVEVSRkFDRV9JTkZPKEhVQVdFSV9WRU5ET1JfSUQsIDB4ZmYs
IDB4MDQsIDB4N0EpIH0sDQorCXsgVVNCX1ZFTkRPUl9BTkRfSU5URVJGQUNFX0lORk8oSFVBV0VJ
X1ZFTkRPUl9JRCwgMHhmZiwgMHgwNCwgMHg3QikgfSwNCisJeyBVU0JfVkVORE9SX0FORF9JTlRF
UkZBQ0VfSU5GTyhIVUFXRUlfVkVORE9SX0lELCAweGZmLCAweDA0LCAweDdDKSB9LA0KKwl7IFVT
Ql9WRU5ET1JfQU5EX0lOVEVSRkFDRV9JTkZPKEhVQVdFSV9WRU5ET1JfSUQsIDB4ZmYsIDB4MDUs
IDB4MDEpIH0sDQorCXsgVVNCX1ZFTkRPUl9BTkRfSU5URVJGQUNFX0lORk8oSFVBV0VJX1ZFTkRP
Ul9JRCwgMHhmZiwgMHgwNSwgMHgwMikgfSwNCisJeyBVU0JfVkVORE9SX0FORF9JTlRFUkZBQ0Vf
SU5GTyhIVUFXRUlfVkVORE9SX0lELCAweGZmLCAweDA1LCAweDAzKSB9LA0KKwl7IFVTQl9WRU5E
T1JfQU5EX0lOVEVSRkFDRV9JTkZPKEhVQVdFSV9WRU5ET1JfSUQsIDB4ZmYsIDB4MDUsIDB4MDQp
IH0sDQorCXsgVVNCX1ZFTkRPUl9BTkRfSU5URVJGQUNFX0lORk8oSFVBV0VJX1ZFTkRPUl9JRCwg
MHhmZiwgMHgwNSwgMHgwNSkgfSwNCisJeyBVU0JfVkVORE9SX0FORF9JTlRFUkZBQ0VfSU5GTyhI
VUFXRUlfVkVORE9SX0lELCAweGZmLCAweDA1LCAweDA2KSB9LA0KKwl7IFVTQl9WRU5ET1JfQU5E
X0lOVEVSRkFDRV9JTkZPKEhVQVdFSV9WRU5ET1JfSUQsIDB4ZmYsIDB4MDUsIDB4MEEpIH0sDQor
CXsgVVNCX1ZFTkRPUl9BTkRfSU5URVJGQUNFX0lORk8oSFVBV0VJX1ZFTkRPUl9JRCwgMHhmZiwg
MHgwNSwgMHgwQikgfSwNCisJeyBVU0JfVkVORE9SX0FORF9JTlRFUkZBQ0VfSU5GTyhIVUFXRUlf
VkVORE9SX0lELCAweGZmLCAweDA1LCAweDBEKSB9LA0KKwl7IFVTQl9WRU5ET1JfQU5EX0lOVEVS
RkFDRV9JTkZPKEhVQVdFSV9WRU5ET1JfSUQsIDB4ZmYsIDB4MDUsIDB4MEUpIH0sDQorCXsgVVNC
X1ZFTkRPUl9BTkRfSU5URVJGQUNFX0lORk8oSFVBV0VJX1ZFTkRPUl9JRCwgMHhmZiwgMHgwNSwg
MHgwRikgfSwNCisJeyBVU0JfVkVORE9SX0FORF9JTlRFUkZBQ0VfSU5GTyhIVUFXRUlfVkVORE9S
X0lELCAweGZmLCAweDA1LCAweDEwKSB9LA0KKwl7IFVTQl9WRU5ET1JfQU5EX0lOVEVSRkFDRV9J
TkZPKEhVQVdFSV9WRU5ET1JfSUQsIDB4ZmYsIDB4MDUsIDB4MTIpIH0sDQorCXsgVVNCX1ZFTkRP
Ul9BTkRfSU5URVJGQUNFX0lORk8oSFVBV0VJX1ZFTkRPUl9JRCwgMHhmZiwgMHgwNSwgMHgxMykg
fSwNCisJeyBVU0JfVkVORE9SX0FORF9JTlRFUkZBQ0VfSU5GTyhIVUFXRUlfVkVORE9SX0lELCAw
eGZmLCAweDA1LCAweDE0KSB9LA0KKwl7IFVTQl9WRU5ET1JfQU5EX0lOVEVSRkFDRV9JTkZPKEhV
QVdFSV9WRU5ET1JfSUQsIDB4ZmYsIDB4MDUsIDB4MTUpIH0sDQorCXsgVVNCX1ZFTkRPUl9BTkRf
SU5URVJGQUNFX0lORk8oSFVBV0VJX1ZFTkRPUl9JRCwgMHhmZiwgMHgwNSwgMHgxNykgfSwNCisJ
eyBVU0JfVkVORE9SX0FORF9JTlRFUkZBQ0VfSU5GTyhIVUFXRUlfVkVORE9SX0lELCAweGZmLCAw
eDA1LCAweDE4KSB9LA0KKwl7IFVTQl9WRU5ET1JfQU5EX0lOVEVSRkFDRV9JTkZPKEhVQVdFSV9W
RU5ET1JfSUQsIDB4ZmYsIDB4MDUsIDB4MTkpIH0sDQorCXsgVVNCX1ZFTkRPUl9BTkRfSU5URVJG
QUNFX0lORk8oSFVBV0VJX1ZFTkRPUl9JRCwgMHhmZiwgMHgwNSwgMHgxQSkgfSwNCisJeyBVU0Jf
VkVORE9SX0FORF9JTlRFUkZBQ0VfSU5GTyhIVUFXRUlfVkVORE9SX0lELCAweGZmLCAweDA1LCAw
eDFCKSB9LA0KKwl7IFVTQl9WRU5ET1JfQU5EX0lOVEVSRkFDRV9JTkZPKEhVQVdFSV9WRU5ET1Jf
SUQsIDB4ZmYsIDB4MDUsIDB4MUMpIH0sDQorCXsgVVNCX1ZFTkRPUl9BTkRfSU5URVJGQUNFX0lO
Rk8oSFVBV0VJX1ZFTkRPUl9JRCwgMHhmZiwgMHgwNSwgMHgzMSkgfSwNCisJeyBVU0JfVkVORE9S
X0FORF9JTlRFUkZBQ0VfSU5GTyhIVUFXRUlfVkVORE9SX0lELCAweGZmLCAweDA1LCAweDMyKSB9
LA0KKwl7IFVTQl9WRU5ET1JfQU5EX0lOVEVSRkFDRV9JTkZPKEhVQVdFSV9WRU5ET1JfSUQsIDB4
ZmYsIDB4MDUsIDB4MzMpIH0sDQorCXsgVVNCX1ZFTkRPUl9BTkRfSU5URVJGQUNFX0lORk8oSFVB
V0VJX1ZFTkRPUl9JRCwgMHhmZiwgMHgwNSwgMHgzNCkgfSwNCisJeyBVU0JfVkVORE9SX0FORF9J
TlRFUkZBQ0VfSU5GTyhIVUFXRUlfVkVORE9SX0lELCAweGZmLCAweDA1LCAweDM1KSB9LA0KKwl7
IFVTQl9WRU5ET1JfQU5EX0lOVEVSRkFDRV9JTkZPKEhVQVdFSV9WRU5ET1JfSUQsIDB4ZmYsIDB4
MDUsIDB4MzYpIH0sDQorCXsgVVNCX1ZFTkRPUl9BTkRfSU5URVJGQUNFX0lORk8oSFVBV0VJX1ZF
TkRPUl9JRCwgMHhmZiwgMHgwNSwgMHgzQSkgfSwNCisJeyBVU0JfVkVORE9SX0FORF9JTlRFUkZB
Q0VfSU5GTyhIVUFXRUlfVkVORE9SX0lELCAweGZmLCAweDA1LCAweDNCKSB9LA0KKwl7IFVTQl9W
RU5ET1JfQU5EX0lOVEVSRkFDRV9JTkZPKEhVQVdFSV9WRU5ET1JfSUQsIDB4ZmYsIDB4MDUsIDB4
M0QpIH0sDQorCXsgVVNCX1ZFTkRPUl9BTkRfSU5URVJGQUNFX0lORk8oSFVBV0VJX1ZFTkRPUl9J
RCwgMHhmZiwgMHgwNSwgMHgzRSkgfSwNCisJeyBVU0JfVkVORE9SX0FORF9JTlRFUkZBQ0VfSU5G
TyhIVUFXRUlfVkVORE9SX0lELCAweGZmLCAweDA1LCAweDNGKSB9LA0KKwl7IFVTQl9WRU5ET1Jf
QU5EX0lOVEVSRkFDRV9JTkZPKEhVQVdFSV9WRU5ET1JfSUQsIDB4ZmYsIDB4MDUsIDB4NDgpIH0s
DQorCXsgVVNCX1ZFTkRPUl9BTkRfSU5URVJGQUNFX0lORk8oSFVBV0VJX1ZFTkRPUl9JRCwgMHhm
ZiwgMHgwNSwgMHg0OSkgfSwNCisJeyBVU0JfVkVORE9SX0FORF9JTlRFUkZBQ0VfSU5GTyhIVUFX
RUlfVkVORE9SX0lELCAweGZmLCAweDA1LCAweDRBKSB9LA0KKwl7IFVTQl9WRU5ET1JfQU5EX0lO
VEVSRkFDRV9JTkZPKEhVQVdFSV9WRU5ET1JfSUQsIDB4ZmYsIDB4MDUsIDB4NEIpIH0sDQorCXsg
VVNCX1ZFTkRPUl9BTkRfSU5URVJGQUNFX0lORk8oSFVBV0VJX1ZFTkRPUl9JRCwgMHhmZiwgMHgw
NSwgMHg0QykgfSwNCisJeyBVU0JfVkVORE9SX0FORF9JTlRFUkZBQ0VfSU5GTyhIVUFXRUlfVkVO
RE9SX0lELCAweGZmLCAweDA1LCAweDYxKSB9LA0KKwl7IFVTQl9WRU5ET1JfQU5EX0lOVEVSRkFD
RV9JTkZPKEhVQVdFSV9WRU5ET1JfSUQsIDB4ZmYsIDB4MDUsIDB4NjIpIH0sDQorCXsgVVNCX1ZF
TkRPUl9BTkRfSU5URVJGQUNFX0lORk8oSFVBV0VJX1ZFTkRPUl9JRCwgMHhmZiwgMHgwNSwgMHg2
MykgfSwNCisJeyBVU0JfVkVORE9SX0FORF9JTlRFUkZBQ0VfSU5GTyhIVUFXRUlfVkVORE9SX0lE
LCAweGZmLCAweDA1LCAweDY0KSB9LA0KKwl7IFVTQl9WRU5ET1JfQU5EX0lOVEVSRkFDRV9JTkZP
KEhVQVdFSV9WRU5ET1JfSUQsIDB4ZmYsIDB4MDUsIDB4NjUpIH0sDQorCXsgVVNCX1ZFTkRPUl9B
TkRfSU5URVJGQUNFX0lORk8oSFVBV0VJX1ZFTkRPUl9JRCwgMHhmZiwgMHgwNSwgMHg2NikgfSwN
CisJeyBVU0JfVkVORE9SX0FORF9JTlRFUkZBQ0VfSU5GTyhIVUFXRUlfVkVORE9SX0lELCAweGZm
LCAweDA1LCAweDZBKSB9LA0KKwl7IFVTQl9WRU5ET1JfQU5EX0lOVEVSRkFDRV9JTkZPKEhVQVdF
SV9WRU5ET1JfSUQsIDB4ZmYsIDB4MDUsIDB4NkIpIH0sDQorCXsgVVNCX1ZFTkRPUl9BTkRfSU5U
RVJGQUNFX0lORk8oSFVBV0VJX1ZFTkRPUl9JRCwgMHhmZiwgMHgwNSwgMHg2RCkgfSwNCisJeyBV
U0JfVkVORE9SX0FORF9JTlRFUkZBQ0VfSU5GTyhIVUFXRUlfVkVORE9SX0lELCAweGZmLCAweDA1
LCAweDZFKSB9LA0KKwl7IFVTQl9WRU5ET1JfQU5EX0lOVEVSRkFDRV9JTkZPKEhVQVdFSV9WRU5E
T1JfSUQsIDB4ZmYsIDB4MDUsIDB4NkYpIH0sDQorCXsgVVNCX1ZFTkRPUl9BTkRfSU5URVJGQUNF
X0lORk8oSFVBV0VJX1ZFTkRPUl9JRCwgMHhmZiwgMHgwNSwgMHg3OCkgfSwNCisJeyBVU0JfVkVO
RE9SX0FORF9JTlRFUkZBQ0VfSU5GTyhIVUFXRUlfVkVORE9SX0lELCAweGZmLCAweDA1LCAweDc5
KSB9LA0KKwl7IFVTQl9WRU5ET1JfQU5EX0lOVEVSRkFDRV9JTkZPKEhVQVdFSV9WRU5ET1JfSUQs
IDB4ZmYsIDB4MDUsIDB4N0EpIH0sDQorCXsgVVNCX1ZFTkRPUl9BTkRfSU5URVJGQUNFX0lORk8o
SFVBV0VJX1ZFTkRPUl9JRCwgMHhmZiwgMHgwNSwgMHg3QikgfSwNCisJeyBVU0JfVkVORE9SX0FO
RF9JTlRFUkZBQ0VfSU5GTyhIVUFXRUlfVkVORE9SX0lELCAweGZmLCAweDA1LCAweDdDKSB9LA0K
Kwl7IFVTQl9WRU5ET1JfQU5EX0lOVEVSRkFDRV9JTkZPKEhVQVdFSV9WRU5ET1JfSUQsIDB4ZmYs
IDB4MDYsIDB4MDEpIH0sDQorCXsgVVNCX1ZFTkRPUl9BTkRfSU5URVJGQUNFX0lORk8oSFVBV0VJ
X1ZFTkRPUl9JRCwgMHhmZiwgMHgwNiwgMHgwMikgfSwNCisJeyBVU0JfVkVORE9SX0FORF9JTlRF
UkZBQ0VfSU5GTyhIVUFXRUlfVkVORE9SX0lELCAweGZmLCAweDA2LCAweDAzKSB9LA0KKwl7IFVT
Ql9WRU5ET1JfQU5EX0lOVEVSRkFDRV9JTkZPKEhVQVdFSV9WRU5ET1JfSUQsIDB4ZmYsIDB4MDYs
IDB4MDQpIH0sDQorCXsgVVNCX1ZFTkRPUl9BTkRfSU5URVJGQUNFX0lORk8oSFVBV0VJX1ZFTkRP
Ul9JRCwgMHhmZiwgMHgwNiwgMHgwNSkgfSwNCisJeyBVU0JfVkVORE9SX0FORF9JTlRFUkZBQ0Vf
SU5GTyhIVUFXRUlfVkVORE9SX0lELCAweGZmLCAweDA2LCAweDA2KSB9LA0KKwl7IFVTQl9WRU5E
T1JfQU5EX0lOVEVSRkFDRV9JTkZPKEhVQVdFSV9WRU5ET1JfSUQsIDB4ZmYsIDB4MDYsIDB4MEEp
IH0sDQorCXsgVVNCX1ZFTkRPUl9BTkRfSU5URVJGQUNFX0lORk8oSFVBV0VJX1ZFTkRPUl9JRCwg
MHhmZiwgMHgwNiwgMHgwQikgfSwNCisJeyBVU0JfVkVORE9SX0FORF9JTlRFUkZBQ0VfSU5GTyhI
VUFXRUlfVkVORE9SX0lELCAweGZmLCAweDA2LCAweDBEKSB9LA0KKwl7IFVTQl9WRU5ET1JfQU5E
X0lOVEVSRkFDRV9JTkZPKEhVQVdFSV9WRU5ET1JfSUQsIDB4ZmYsIDB4MDYsIDB4MEUpIH0sDQor
CXsgVVNCX1ZFTkRPUl9BTkRfSU5URVJGQUNFX0lORk8oSFVBV0VJX1ZFTkRPUl9JRCwgMHhmZiwg
MHgwNiwgMHgwRikgfSwNCisJeyBVU0JfVkVORE9SX0FORF9JTlRFUkZBQ0VfSU5GTyhIVUFXRUlf
VkVORE9SX0lELCAweGZmLCAweDA2LCAweDEwKSB9LA0KKwl7IFVTQl9WRU5ET1JfQU5EX0lOVEVS
RkFDRV9JTkZPKEhVQVdFSV9WRU5ET1JfSUQsIDB4ZmYsIDB4MDYsIDB4MTIpIH0sDQorCXsgVVNC
X1ZFTkRPUl9BTkRfSU5URVJGQUNFX0lORk8oSFVBV0VJX1ZFTkRPUl9JRCwgMHhmZiwgMHgwNiwg
MHgxMykgfSwNCisJeyBVU0JfVkVORE9SX0FORF9JTlRFUkZBQ0VfSU5GTyhIVUFXRUlfVkVORE9S
X0lELCAweGZmLCAweDA2LCAweDE0KSB9LA0KKwl7IFVTQl9WRU5ET1JfQU5EX0lOVEVSRkFDRV9J
TkZPKEhVQVdFSV9WRU5ET1JfSUQsIDB4ZmYsIDB4MDYsIDB4MTUpIH0sDQorCXsgVVNCX1ZFTkRP
Ul9BTkRfSU5URVJGQUNFX0lORk8oSFVBV0VJX1ZFTkRPUl9JRCwgMHhmZiwgMHgwNiwgMHgxNykg
fSwNCisJeyBVU0JfVkVORE9SX0FORF9JTlRFUkZBQ0VfSU5GTyhIVUFXRUlfVkVORE9SX0lELCAw
eGZmLCAweDA2LCAweDE4KSB9LA0KKwl7IFVTQl9WRU5ET1JfQU5EX0lOVEVSRkFDRV9JTkZPKEhV
QVdFSV9WRU5ET1JfSUQsIDB4ZmYsIDB4MDYsIDB4MTkpIH0sDQorCXsgVVNCX1ZFTkRPUl9BTkRf
SU5URVJGQUNFX0lORk8oSFVBV0VJX1ZFTkRPUl9JRCwgMHhmZiwgMHgwNiwgMHgxQSkgfSwNCisJ
eyBVU0JfVkVORE9SX0FORF9JTlRFUkZBQ0VfSU5GTyhIVUFXRUlfVkVORE9SX0lELCAweGZmLCAw
eDA2LCAweDFCKSB9LA0KKwl7IFVTQl9WRU5ET1JfQU5EX0lOVEVSRkFDRV9JTkZPKEhVQVdFSV9W
RU5ET1JfSUQsIDB4ZmYsIDB4MDYsIDB4MUMpIH0sDQorCXsgVVNCX1ZFTkRPUl9BTkRfSU5URVJG
QUNFX0lORk8oSFVBV0VJX1ZFTkRPUl9JRCwgMHhmZiwgMHgwNiwgMHgzMSkgfSwNCisJeyBVU0Jf
VkVORE9SX0FORF9JTlRFUkZBQ0VfSU5GTyhIVUFXRUlfVkVORE9SX0lELCAweGZmLCAweDA2LCAw
eDMyKSB9LA0KKwl7IFVTQl9WRU5ET1JfQU5EX0lOVEVSRkFDRV9JTkZPKEhVQVdFSV9WRU5ET1Jf
SUQsIDB4ZmYsIDB4MDYsIDB4MzMpIH0sDQorCXsgVVNCX1ZFTkRPUl9BTkRfSU5URVJGQUNFX0lO
Rk8oSFVBV0VJX1ZFTkRPUl9JRCwgMHhmZiwgMHgwNiwgMHgzNCkgfSwNCisJeyBVU0JfVkVORE9S
X0FORF9JTlRFUkZBQ0VfSU5GTyhIVUFXRUlfVkVORE9SX0lELCAweGZmLCAweDA2LCAweDM1KSB9
LA0KKwl7IFVTQl9WRU5ET1JfQU5EX0lOVEVSRkFDRV9JTkZPKEhVQVdFSV9WRU5ET1JfSUQsIDB4
ZmYsIDB4MDYsIDB4MzYpIH0sDQorCXsgVVNCX1ZFTkRPUl9BTkRfSU5URVJGQUNFX0lORk8oSFVB
V0VJX1ZFTkRPUl9JRCwgMHhmZiwgMHgwNiwgMHgzQSkgfSwNCisJeyBVU0JfVkVORE9SX0FORF9J
TlRFUkZBQ0VfSU5GTyhIVUFXRUlfVkVORE9SX0lELCAweGZmLCAweDA2LCAweDNCKSB9LA0KKwl7
IFVTQl9WRU5ET1JfQU5EX0lOVEVSRkFDRV9JTkZPKEhVQVdFSV9WRU5ET1JfSUQsIDB4ZmYsIDB4
MDYsIDB4M0QpIH0sDQorCXsgVVNCX1ZFTkRPUl9BTkRfSU5URVJGQUNFX0lORk8oSFVBV0VJX1ZF
TkRPUl9JRCwgMHhmZiwgMHgwNiwgMHgzRSkgfSwNCisJeyBVU0JfVkVORE9SX0FORF9JTlRFUkZB
Q0VfSU5GTyhIVUFXRUlfVkVORE9SX0lELCAweGZmLCAweDA2LCAweDNGKSB9LA0KKwl7IFVTQl9W
RU5ET1JfQU5EX0lOVEVSRkFDRV9JTkZPKEhVQVdFSV9WRU5ET1JfSUQsIDB4ZmYsIDB4MDYsIDB4
NDgpIH0sDQorCXsgVVNCX1ZFTkRPUl9BTkRfSU5URVJGQUNFX0lORk8oSFVBV0VJX1ZFTkRPUl9J
RCwgMHhmZiwgMHgwNiwgMHg0OSkgfSwNCisJeyBVU0JfVkVORE9SX0FORF9JTlRFUkZBQ0VfSU5G
TyhIVUFXRUlfVkVORE9SX0lELCAweGZmLCAweDA2LCAweDRBKSB9LA0KKwl7IFVTQl9WRU5ET1Jf
QU5EX0lOVEVSRkFDRV9JTkZPKEhVQVdFSV9WRU5ET1JfSUQsIDB4ZmYsIDB4MDYsIDB4NEIpIH0s
DQorCXsgVVNCX1ZFTkRPUl9BTkRfSU5URVJGQUNFX0lORk8oSFVBV0VJX1ZFTkRPUl9JRCwgMHhm
ZiwgMHgwNiwgMHg0QykgfSwNCisJeyBVU0JfVkVORE9SX0FORF9JTlRFUkZBQ0VfSU5GTyhIVUFX
RUlfVkVORE9SX0lELCAweGZmLCAweDA2LCAweDYxKSB9LA0KKwl7IFVTQl9WRU5ET1JfQU5EX0lO
VEVSRkFDRV9JTkZPKEhVQVdFSV9WRU5ET1JfSUQsIDB4ZmYsIDB4MDYsIDB4NjIpIH0sDQorCXsg
VVNCX1ZFTkRPUl9BTkRfSU5URVJGQUNFX0lORk8oSFVBV0VJX1ZFTkRPUl9JRCwgMHhmZiwgMHgw
NiwgMHg2MykgfSwNCisJeyBVU0JfVkVORE9SX0FORF9JTlRFUkZBQ0VfSU5GTyhIVUFXRUlfVkVO
RE9SX0lELCAweGZmLCAweDA2LCAweDY0KSB9LA0KKwl7IFVTQl9WRU5ET1JfQU5EX0lOVEVSRkFD
RV9JTkZPKEhVQVdFSV9WRU5ET1JfSUQsIDB4ZmYsIDB4MDYsIDB4NjUpIH0sDQorCXsgVVNCX1ZF
TkRPUl9BTkRfSU5URVJGQUNFX0lORk8oSFVBV0VJX1ZFTkRPUl9JRCwgMHhmZiwgMHgwNiwgMHg2
NikgfSwNCisJeyBVU0JfVkVORE9SX0FORF9JTlRFUkZBQ0VfSU5GTyhIVUFXRUlfVkVORE9SX0lE
LCAweGZmLCAweDA2LCAweDZBKSB9LA0KKwl7IFVTQl9WRU5ET1JfQU5EX0lOVEVSRkFDRV9JTkZP
KEhVQVdFSV9WRU5ET1JfSUQsIDB4ZmYsIDB4MDYsIDB4NkIpIH0sDQorCXsgVVNCX1ZFTkRPUl9B
TkRfSU5URVJGQUNFX0lORk8oSFVBV0VJX1ZFTkRPUl9JRCwgMHhmZiwgMHgwNiwgMHg2RCkgfSwN
CisJeyBVU0JfVkVORE9SX0FORF9JTlRFUkZBQ0VfSU5GTyhIVUFXRUlfVkVORE9SX0lELCAweGZm
LCAweDA2LCAweDZFKSB9LA0KKwl7IFVTQl9WRU5ET1JfQU5EX0lOVEVSRkFDRV9JTkZPKEhVQVdF
SV9WRU5ET1JfSUQsIDB4ZmYsIDB4MDYsIDB4NkYpIH0sDQorCXsgVVNCX1ZFTkRPUl9BTkRfSU5U
RVJGQUNFX0lORk8oSFVBV0VJX1ZFTkRPUl9JRCwgMHhmZiwgMHgwNiwgMHg3OCkgfSwNCisJeyBV
U0JfVkVORE9SX0FORF9JTlRFUkZBQ0VfSU5GTyhIVUFXRUlfVkVORE9SX0lELCAweGZmLCAweDA2
LCAweDc5KSB9LA0KKwl7IFVTQl9WRU5ET1JfQU5EX0lOVEVSRkFDRV9JTkZPKEhVQVdFSV9WRU5E
T1JfSUQsIDB4ZmYsIDB4MDYsIDB4N0EpIH0sDQorCXsgVVNCX1ZFTkRPUl9BTkRfSU5URVJGQUNF
X0lORk8oSFVBV0VJX1ZFTkRPUl9JRCwgMHhmZiwgMHgwNiwgMHg3QikgfSwNCisJeyBVU0JfVkVO
RE9SX0FORF9JTlRFUkZBQ0VfSU5GTyhIVUFXRUlfVkVORE9SX0lELCAweGZmLCAweDA2LCAweDdD
KSB9LA0KIA0KIA0KIAl7IFVTQl9ERVZJQ0UoTk9WQVRFTFdJUkVMRVNTX1ZFTkRPUl9JRCwgTk9W
QVRFTFdJUkVMRVNTX1BST0RVQ1RfVjY0MCkgfSwNCkBAIC0xMjc5LDcgKzE0OTksOSBAQCBzdGF0
aWMgY29uc3Qgc3RydWN0IHVzYl9kZXZpY2VfaWQgb3B0aW9uX2lkc1tdID0gew0KIA0KIAl7IFVT
Ql9ERVZJQ0UoT0xJVkVUVElfVkVORE9SX0lELCBPTElWRVRUSV9QUk9EVUNUX09MSUNBUkQxMDAp
IH0sDQogCXsgVVNCX0RFVklDRShPTElWRVRUSV9WRU5ET1JfSUQsIE9MSVZFVFRJX1BST0RVQ1Rf
T0xJQ0FSRDE0NSkgfSwNCi0JeyBVU0JfREVWSUNFKE9MSVZFVFRJX1ZFTkRPUl9JRCwgT0xJVkVU
VElfUFJPRFVDVF9PTElDQVJEMjAwKSB9LA0KKwl7IFVTQl9ERVZJQ0UoT0xJVkVUVElfVkVORE9S
X0lELCBPTElWRVRUSV9QUk9EVUNUX09MSUNBUkQyMDApLA0KKwkJLmRyaXZlcl9pbmZvID0gKGtl
cm5lbF91bG9uZ190KSZuZXRfaW50ZjZfYmxhY2tsaXN0DQorCX0sDQogCXsgVVNCX0RFVklDRShD
RUxPVF9WRU5ET1JfSUQsIENFTE9UX1BST0RVQ1RfQ1Q2ODBNKSB9LCAvKiBDVC02NTAgQ0RNQSA0
NTAgMXhFVkRPIG1vZGVtICovDQogCXsgVVNCX0RFVklDRV9BTkRfSU5URVJGQUNFX0lORk8oU0FN
U1VOR19WRU5ET1JfSUQsIFNBTVNVTkdfUFJPRFVDVF9HVF9CMzczMCwgVVNCX0NMQVNTX0NEQ19E
QVRBLCAweDAwLCAweDAwKSB9LCAvKiBTYW1zdW5nIEdULUIzNzMwIExURSBVU0IgbW9kZW0uKi8N
CiAJeyBVU0JfREVWSUNFKFlVR0FfVkVORE9SX0lELCBZVUdBX1BST0RVQ1RfQ0VNNjAwKSB9LA0K
QEAgLTEzNjcsNiArMTU4OSw3IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3QgdXNiX2RldmljZV9pZCBv
cHRpb25faWRzW10gPSB7DQogCXsgVVNCX0RFVklDRV9BTkRfSU5URVJGQUNFX0lORk8oMHgyMDAx
LCAweDdkMDMsIDB4ZmYsIDB4MDAsIDB4MDApIH0sDQogCXsgVVNCX0RFVklDRV9BTkRfSU5URVJG
QUNFX0lORk8oMHgwN2QxLCAweDNlMDEsIDB4ZmYsIDB4ZmYsIDB4ZmYpIH0sIC8qIEQtTGluayBE
V00tMTUyL0MxICovDQogCXsgVVNCX0RFVklDRV9BTkRfSU5URVJGQUNFX0lORk8oMHgwN2QxLCAw
eDNlMDIsIDB4ZmYsIDB4ZmYsIDB4ZmYpIH0sIC8qIEQtTGluayBEV00tMTU2L0MxICovDQorCXsg
VVNCX0RFVklDRShJTk9WSUFfVkVORE9SX0lELCBJTk9WSUFfU0VXODU4KSB9LA0KIAl7IH0gLyog
VGVybWluYXRpbmcgZW50cnkgKi8NCiB9Ow0KIE1PRFVMRV9ERVZJQ0VfVEFCTEUodXNiLCBvcHRp
b25faWRzKTsNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3ZpZGVvL2F1MTEwMGZiLmMgYi9kcml2ZXJz
L3ZpZGVvL2F1MTEwMGZiLmMNCmluZGV4IDY0OWNiMzUuLjFiZThiNWQgMTAwNjQ0DQotLS0gYS9k
cml2ZXJzL3ZpZGVvL2F1MTEwMGZiLmMNCisrKyBiL2RyaXZlcnMvdmlkZW8vYXUxMTAwZmIuYw0K
QEAgLTM4NywzOSArMzg3LDEzIEBAIHZvaWQgYXUxMTAwZmJfZmJfcm90YXRlKHN0cnVjdCBmYl9p
bmZvICpmYmksIGludCBhbmdsZSkNCiBpbnQgYXUxMTAwZmJfZmJfbW1hcChzdHJ1Y3QgZmJfaW5m
byAqZmJpLCBzdHJ1Y3Qgdm1fYXJlYV9zdHJ1Y3QgKnZtYSkNCiB7DQogCXN0cnVjdCBhdTExMDBm
Yl9kZXZpY2UgKmZiZGV2Ow0KLQl1bnNpZ25lZCBpbnQgbGVuOw0KLQl1bnNpZ25lZCBsb25nIHN0
YXJ0PTAsIG9mZjsNCiANCiAJZmJkZXYgPSB0b19hdTExMDBmYl9kZXZpY2UoZmJpKTsNCiANCi0J
aWYgKHZtYS0+dm1fcGdvZmYgPiAofjBVTCA+PiBQQUdFX1NISUZUKSkgew0KLQkJcmV0dXJuIC1F
SU5WQUw7DQotCX0NCi0NCi0Jc3RhcnQgPSBmYmRldi0+ZmJfcGh5cyAmIFBBR0VfTUFTSzsNCi0J
bGVuID0gUEFHRV9BTElHTigoc3RhcnQgJiB+UEFHRV9NQVNLKSArIGZiZGV2LT5mYl9sZW4pOw0K
LQ0KLQlvZmYgPSB2bWEtPnZtX3Bnb2ZmIDw8IFBBR0VfU0hJRlQ7DQotDQotCWlmICgodm1hLT52
bV9lbmQgLSB2bWEtPnZtX3N0YXJ0ICsgb2ZmKSA+IGxlbikgew0KLQkJcmV0dXJuIC1FSU5WQUw7
DQotCX0NCi0NCi0Jb2ZmICs9IHN0YXJ0Ow0KLQl2bWEtPnZtX3Bnb2ZmID0gb2ZmID4+IFBBR0Vf
U0hJRlQ7DQotDQogCXZtYS0+dm1fcGFnZV9wcm90ID0gcGdwcm90X25vbmNhY2hlZCh2bWEtPnZt
X3BhZ2VfcHJvdCk7DQogCXBncHJvdF92YWwodm1hLT52bV9wYWdlX3Byb3QpIHw9ICg2IDw8IDkp
OyAvL0NDQT02DQogDQotCXZtYS0+dm1fZmxhZ3MgfD0gVk1fSU87DQotDQotCWlmIChpb19yZW1h
cF9wZm5fcmFuZ2Uodm1hLCB2bWEtPnZtX3N0YXJ0LCBvZmYgPj4gUEFHRV9TSElGVCwNCi0JCQkJ
dm1hLT52bV9lbmQgLSB2bWEtPnZtX3N0YXJ0LA0KLQkJCQl2bWEtPnZtX3BhZ2VfcHJvdCkpIHsN
Ci0JCXJldHVybiAtRUFHQUlOOw0KLQl9DQotDQotCXJldHVybiAwOw0KKwlyZXR1cm4gdm1faW9t
YXBfbWVtb3J5KHZtYSwgZmJkZXYtPmZiX3BoeXMsIGZiZGV2LT5mYl9sZW4pOw0KIH0NCiANCiBz
dGF0aWMgc3RydWN0IGZiX29wcyBhdTExMDBmYl9vcHMgPQ0KZGlmZiAtLWdpdCBhL2RyaXZlcnMv
dmlkZW8vYXUxMjAwZmIuYyBiL2RyaXZlcnMvdmlkZW8vYXUxMjAwZmIuYw0KaW5kZXggNzIwMDU1
OS4uNWJkN2Q4OCAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvdmlkZW8vYXUxMjAwZmIuYw0KKysrIGIv
ZHJpdmVycy92aWRlby9hdTEyMDBmYi5jDQpAQCAtMTIxNiwzOCArMTIxNiwxMyBAQCBzdGF0aWMg
aW50IGF1MTIwMGZiX2ZiX2JsYW5rKGludCBibGFua19tb2RlLCBzdHJ1Y3QgZmJfaW5mbyAqZmJp
KQ0KICAqIG1ldGhvZCBtYWlubHkgdG8gYWxsb3cgdGhlIHVzZSBvZiB0aGUgVExCIHN0cmVhbWlu
ZyBmbGFnIChDQ0E9NikNCiAgKi8NCiBzdGF0aWMgaW50IGF1MTIwMGZiX2ZiX21tYXAoc3RydWN0
IGZiX2luZm8gKmluZm8sIHN0cnVjdCB2bV9hcmVhX3N0cnVjdCAqdm1hKQ0KLQ0KIHsNCi0JdW5z
aWduZWQgaW50IGxlbjsNCi0JdW5zaWduZWQgbG9uZyBzdGFydD0wLCBvZmY7DQogCXN0cnVjdCBh
dTEyMDBmYl9kZXZpY2UgKmZiZGV2ID0gaW5mby0+cGFyOw0KIA0KLQlpZiAodm1hLT52bV9wZ29m
ZiA+ICh+MFVMID4+IFBBR0VfU0hJRlQpKSB7DQotCQlyZXR1cm4gLUVJTlZBTDsNCi0JfQ0KLQ0K
LQlzdGFydCA9IGZiZGV2LT5mYl9waHlzICYgUEFHRV9NQVNLOw0KLQlsZW4gPSBQQUdFX0FMSUdO
KChzdGFydCAmIH5QQUdFX01BU0spICsgZmJkZXYtPmZiX2xlbik7DQotDQotCW9mZiA9IHZtYS0+
dm1fcGdvZmYgPDwgUEFHRV9TSElGVDsNCi0NCi0JaWYgKCh2bWEtPnZtX2VuZCAtIHZtYS0+dm1f
c3RhcnQgKyBvZmYpID4gbGVuKSB7DQotCQlyZXR1cm4gLUVJTlZBTDsNCi0JfQ0KLQ0KLQlvZmYg
Kz0gc3RhcnQ7DQotCXZtYS0+dm1fcGdvZmYgPSBvZmYgPj4gUEFHRV9TSElGVDsNCi0NCiAJdm1h
LT52bV9wYWdlX3Byb3QgPSBwZ3Byb3Rfbm9uY2FjaGVkKHZtYS0+dm1fcGFnZV9wcm90KTsNCiAJ
cGdwcm90X3ZhbCh2bWEtPnZtX3BhZ2VfcHJvdCkgfD0gX0NBQ0hFX01BU0s7IC8qIENDQT03ICov
DQogDQotCXZtYS0+dm1fZmxhZ3MgfD0gVk1fSU87DQotDQotCXJldHVybiBpb19yZW1hcF9wZm5f
cmFuZ2Uodm1hLCB2bWEtPnZtX3N0YXJ0LCBvZmYgPj4gUEFHRV9TSElGVCwNCi0JCQkJICB2bWEt
PnZtX2VuZCAtIHZtYS0+dm1fc3RhcnQsDQotCQkJCSAgdm1hLT52bV9wYWdlX3Byb3QpOw0KLQ0K
LQlyZXR1cm4gMDsNCisJcmV0dXJuIHZtX2lvbWFwX21lbW9yeSh2bWEsIGZiZGV2LT5mYl9waHlz
LCBmYmRldi0+ZmJfbGVuKTsNCiB9DQogDQogc3RhdGljIHZvaWQgc2V0X2dsb2JhbCh1X2ludCBj
bWQsIHN0cnVjdCBhdTEyMDBfbGNkX2dsb2JhbF9yZWdzX3QgKnBkYXRhKQ0KZGlmZiAtLWdpdCBh
L2ZzL2VjcnlwdGZzL2tleXN0b3JlLmMgYi9mcy9lY3J5cHRmcy9rZXlzdG9yZS5jDQppbmRleCBh
YzFhZDQ4Li41Y2U1NmU3IDEwMDY0NA0KLS0tIGEvZnMvZWNyeXB0ZnMva2V5c3RvcmUuYw0KKysr
IGIvZnMvZWNyeXB0ZnMva2V5c3RvcmUuYw0KQEAgLTExNTEsNyArMTE1MSw3IEBAIGRlY3J5cHRf
cGtpX2VuY3J5cHRlZF9zZXNzaW9uX2tleShzdHJ1Y3QgZWNyeXB0ZnNfYXV0aF90b2sgKmF1dGhf
dG9rLA0KIAlzdHJ1Y3QgZWNyeXB0ZnNfbXNnX2N0eCAqbXNnX2N0eDsNCiAJc3RydWN0IGVjcnlw
dGZzX21lc3NhZ2UgKm1zZyA9IE5VTEw7DQogCWNoYXIgKmF1dGhfdG9rX3NpZzsNCi0JY2hhciAq
cGF5bG9hZDsNCisJY2hhciAqcGF5bG9hZCA9IE5VTEw7DQogCXNpemVfdCBwYXlsb2FkX2xlbjsN
CiAJaW50IHJjOw0KIA0KQEAgLTEyMDYsNiArMTIwNiw3IEBAIGRlY3J5cHRfcGtpX2VuY3J5cHRl
ZF9zZXNzaW9uX2tleShzdHJ1Y3QgZWNyeXB0ZnNfYXV0aF90b2sgKmF1dGhfdG9rLA0KIG91dDoN
CiAJaWYgKG1zZykNCiAJCWtmcmVlKG1zZyk7DQorCWtmcmVlKHBheWxvYWQpOw0KIAlyZXR1cm4g
cmM7DQogfQ0KIA0KZGlmZiAtLWdpdCBhL2ZzL2V4dDMvZGlyLmMgYi9mcy9leHQzL2Rpci5jDQpp
bmRleCAzNGYwYTA3Li4zMjY4Njk3IDEwMDY0NA0KLS0tIGEvZnMvZXh0My9kaXIuYw0KKysrIGIv
ZnMvZXh0My9kaXIuYw0KQEAgLTI1LDYgKzI1LDcgQEANCiAjaW5jbHVkZSA8bGludXgvamJkLmg+
DQogI2luY2x1ZGUgPGxpbnV4L2V4dDNfZnMuaD4NCiAjaW5jbHVkZSA8bGludXgvYnVmZmVyX2hl
YWQuaD4NCisjaW5jbHVkZSA8bGludXgvY29tcGF0Lmg+DQogI2luY2x1ZGUgPGxpbnV4L3NsYWIu
aD4NCiAjaW5jbHVkZSA8bGludXgvcmJ0cmVlLmg+DQogDQpAQCAtMzIsMjQgKzMzLDggQEAgc3Rh
dGljIHVuc2lnbmVkIGNoYXIgZXh0M19maWxldHlwZV90YWJsZVtdID0gew0KIAlEVF9VTktOT1dO
LCBEVF9SRUcsIERUX0RJUiwgRFRfQ0hSLCBEVF9CTEssIERUX0ZJRk8sIERUX1NPQ0ssIERUX0xO
Sw0KIH07DQogDQotc3RhdGljIGludCBleHQzX3JlYWRkaXIoc3RydWN0IGZpbGUgKiwgdm9pZCAq
LCBmaWxsZGlyX3QpOw0KIHN0YXRpYyBpbnQgZXh0M19keF9yZWFkZGlyKHN0cnVjdCBmaWxlICog
ZmlscCwNCiAJCQkgICB2b2lkICogZGlyZW50LCBmaWxsZGlyX3QgZmlsbGRpcik7DQotc3RhdGlj
IGludCBleHQzX3JlbGVhc2VfZGlyIChzdHJ1Y3QgaW5vZGUgKiBpbm9kZSwNCi0JCQkJc3RydWN0
IGZpbGUgKiBmaWxwKTsNCi0NCi1jb25zdCBzdHJ1Y3QgZmlsZV9vcGVyYXRpb25zIGV4dDNfZGly
X29wZXJhdGlvbnMgPSB7DQotCS5sbHNlZWsJCT0gZ2VuZXJpY19maWxlX2xsc2VlaywNCi0JLnJl
YWQJCT0gZ2VuZXJpY19yZWFkX2RpciwNCi0JLnJlYWRkaXIJPSBleHQzX3JlYWRkaXIsCQkvKiB3
ZSB0YWtlIEJLTC4gbmVlZGVkPyovDQotCS51bmxvY2tlZF9pb2N0bAk9IGV4dDNfaW9jdGwsDQot
I2lmZGVmIENPTkZJR19DT01QQVQNCi0JLmNvbXBhdF9pb2N0bAk9IGV4dDNfY29tcGF0X2lvY3Rs
LA0KLSNlbmRpZg0KLQkuZnN5bmMJCT0gZXh0M19zeW5jX2ZpbGUsCS8qIEJLTCBoZWxkICovDQot
CS5yZWxlYXNlCT0gZXh0M19yZWxlYXNlX2RpciwNCi19Ow0KLQ0KIA0KIHN0YXRpYyB1bnNpZ25l
ZCBjaGFyIGdldF9kdHlwZShzdHJ1Y3Qgc3VwZXJfYmxvY2sgKnNiLCBpbnQgZmlsZXR5cGUpDQog
ew0KQEAgLTYwLDYgKzQ1LDI1IEBAIHN0YXRpYyB1bnNpZ25lZCBjaGFyIGdldF9kdHlwZShzdHJ1
Y3Qgc3VwZXJfYmxvY2sgKnNiLCBpbnQgZmlsZXR5cGUpDQogCXJldHVybiAoZXh0M19maWxldHlw
ZV90YWJsZVtmaWxldHlwZV0pOw0KIH0NCiANCisvKioNCisgKiBDaGVjayBpZiB0aGUgZ2l2ZW4g
ZGlyLWlub2RlIHJlZmVycyB0byBhbiBodHJlZS1pbmRleGVkIGRpcmVjdG9yeQ0KKyAqIChvciBh
IGRpcmVjdG9yeSB3aGljaCBjaG91bGQgcG90ZW50aWFsbHkgZ2V0IGNvdmVydGVkIHRvIHVzZSBo
dHJlZQ0KKyAqIGluZGV4aW5nKS4NCisgKg0KKyAqIFJldHVybiAxIGlmIGl0IGlzIGEgZHggZGly
LCAwIGlmIG5vdA0KKyAqLw0KK3N0YXRpYyBpbnQgaXNfZHhfZGlyKHN0cnVjdCBpbm9kZSAqaW5v
ZGUpDQorew0KKwlzdHJ1Y3Qgc3VwZXJfYmxvY2sgKnNiID0gaW5vZGUtPmlfc2I7DQorDQorCWlm
IChFWFQzX0hBU19DT01QQVRfRkVBVFVSRShpbm9kZS0+aV9zYiwNCisJCSAgICAgRVhUM19GRUFU
VVJFX0NPTVBBVF9ESVJfSU5ERVgpICYmDQorCSAgICAoKEVYVDNfSShpbm9kZSktPmlfZmxhZ3Mg
JiBFWFQzX0lOREVYX0ZMKSB8fA0KKwkgICAgICgoaW5vZGUtPmlfc2l6ZSA+PiBzYi0+c19ibG9j
a3NpemVfYml0cykgPT0gMSkpKQ0KKwkJcmV0dXJuIDE7DQorDQorCXJldHVybiAwOw0KK30NCiAN
CiBpbnQgZXh0M19jaGVja19kaXJfZW50cnkgKGNvbnN0IGNoYXIgKiBmdW5jdGlvbiwgc3RydWN0
IGlub2RlICogZGlyLA0KIAkJCSAgc3RydWN0IGV4dDNfZGlyX2VudHJ5XzIgKiBkZSwNCkBAIC05
OSwxOCArMTAzLDEzIEBAIHN0YXRpYyBpbnQgZXh0M19yZWFkZGlyKHN0cnVjdCBmaWxlICogZmls
cCwNCiAJdW5zaWduZWQgbG9uZyBvZmZzZXQ7DQogCWludCBpLCBzdG9yZWQ7DQogCXN0cnVjdCBl
eHQzX2Rpcl9lbnRyeV8yICpkZTsNCi0Jc3RydWN0IHN1cGVyX2Jsb2NrICpzYjsNCiAJaW50IGVy
cjsNCiAJc3RydWN0IGlub2RlICppbm9kZSA9IGZpbHAtPmZfcGF0aC5kZW50cnktPmRfaW5vZGU7
DQorCXN0cnVjdCBzdXBlcl9ibG9jayAqc2IgPSBpbm9kZS0+aV9zYjsNCiAJaW50IHJldCA9IDA7
DQogCWludCBkaXJfaGFzX2Vycm9yID0gMDsNCiANCi0Jc2IgPSBpbm9kZS0+aV9zYjsNCi0NCi0J
aWYgKEVYVDNfSEFTX0NPTVBBVF9GRUFUVVJFKGlub2RlLT5pX3NiLA0KLQkJCQkgICAgRVhUM19G
RUFUVVJFX0NPTVBBVF9ESVJfSU5ERVgpICYmDQotCSAgICAoKEVYVDNfSShpbm9kZSktPmlfZmxh
Z3MgJiBFWFQzX0lOREVYX0ZMKSB8fA0KLQkgICAgICgoaW5vZGUtPmlfc2l6ZSA+PiBzYi0+c19i
bG9ja3NpemVfYml0cykgPT0gMSkpKSB7DQorCWlmIChpc19keF9kaXIoaW5vZGUpKSB7DQogCQll
cnIgPSBleHQzX2R4X3JlYWRkaXIoZmlscCwgZGlyZW50LCBmaWxsZGlyKTsNCiAJCWlmIChlcnIg
IT0gRVJSX0JBRF9EWF9ESVIpIHsNCiAJCQlyZXQgPSBlcnI7DQpAQCAtMjMyLDIyICsyMzEsODcg
QEAgb3V0Og0KIAlyZXR1cm4gcmV0Ow0KIH0NCiANCitzdGF0aWMgaW5saW5lIGludCBpc18zMmJp
dF9hcGkodm9pZCkNCit7DQorI2lmZGVmIENPTkZJR19DT01QQVQNCisJcmV0dXJuIGlzX2NvbXBh
dF90YXNrKCk7DQorI2Vsc2UNCisJcmV0dXJuIChCSVRTX1BFUl9MT05HID09IDMyKTsNCisjZW5k
aWYNCit9DQorDQogLyoNCiAgKiBUaGVzZSBmdW5jdGlvbnMgY29udmVydCBmcm9tIHRoZSBtYWpv
ci9taW5vciBoYXNoIHRvIGFuIGZfcG9zDQotICogdmFsdWUuDQorICogdmFsdWUgZm9yIGR4IGRp
cmVjdG9yaWVzDQogICoNCi0gKiBDdXJyZW50bHkgd2Ugb25seSB1c2UgbWFqb3IgaGFzaCBudW1l
ci4gIFRoaXMgaXMgdW5mb3J0dW5hdGUsIGJ1dA0KLSAqIG9uIDMyLWJpdCBtYWNoaW5lcywgdGhl
IHNhbWUgVkZTIGludGVyZmFjZSBpcyB1c2VkIGZvciBsc2VlayBhbmQNCi0gKiBsbHNlZWssIHNv
IGlmIHdlIHVzZSB0aGUgNjQgYml0IG9mZnNldCwgdGhlbiB0aGUgMzItYml0IHZlcnNpb25zIG9m
DQotICogbHNlZWsvdGVsbGRpci9zZWVrZGlyIHdpbGwgYmxvdyBvdXQgc3BlY3RhY3VsYXJseSwg
YW5kIGZyb20gd2l0aGluDQotICogdGhlIGV4dDIgbG93LWxldmVsIHJvdXRpbmUsIHdlIGRvbid0
IGtub3cgaWYgd2UncmUgYmVpbmcgY2FsbGVkIGJ5DQotICogYSA2NC1iaXQgdmVyc2lvbiBvZiB0
aGUgc3lzdGVtIGNhbGwgb3IgdGhlIDMyLWJpdCB2ZXJzaW9uIG9mIHRoZQ0KLSAqIHN5c3RlbSBj
YWxsLiAgV29yc2UgeWV0LCBORlN2MiBvbmx5IGFsbG93cyBmb3IgYSAzMi1iaXQgcmVhZGRpcg0K
LSAqIGNvb2tpZS4gIFNpZ2guDQorICogVXBwZXIgbGF5ZXIgKGZvciBleGFtcGxlIE5GUykgc2hv
dWxkIHNwZWNpZnkgRk1PREVfMzJCSVRIQVNIIG9yDQorICogRk1PREVfNjRCSVRIQVNIIGV4cGxp
Y2l0bHkuIE9uIHRoZSBvdGhlciBoYW5kLCB3ZSBhbGxvdyBleHQzIHRvIGJlIG1vdW50ZWQNCisg
KiBkaXJlY3RseSBvbiBib3RoIDMyLWJpdCBhbmQgNjQtYml0IG5vZGVzLCB1bmRlciBzdWNoIGNh
c2UsIG5laXRoZXINCisgKiBGTU9ERV8zMkJJVEhBU0ggbm9yIEZNT0RFXzY0QklUSEFTSCBpcyBz
cGVjaWZpZWQuDQogICovDQotI2RlZmluZSBoYXNoMnBvcyhtYWpvciwgbWlub3IpCShtYWpvciA+
PiAxKQ0KLSNkZWZpbmUgcG9zMm1hal9oYXNoKHBvcykJKChwb3MgPDwgMSkgJiAweGZmZmZmZmZm
KQ0KLSNkZWZpbmUgcG9zMm1pbl9oYXNoKHBvcykJKDApDQorc3RhdGljIGlubGluZSBsb2ZmX3Qg
aGFzaDJwb3Moc3RydWN0IGZpbGUgKmZpbHAsIF9fdTMyIG1ham9yLCBfX3UzMiBtaW5vcikNCit7
DQorCWlmICgoZmlscC0+Zl9tb2RlICYgRk1PREVfMzJCSVRIQVNIKSB8fA0KKwkgICAgKCEoZmls
cC0+Zl9tb2RlICYgRk1PREVfNjRCSVRIQVNIKSAmJiBpc18zMmJpdF9hcGkoKSkpDQorCQlyZXR1
cm4gbWFqb3IgPj4gMTsNCisJZWxzZQ0KKwkJcmV0dXJuICgoX191NjQpKG1ham9yID4+IDEpIDw8
IDMyKSB8IChfX3U2NCltaW5vcjsNCit9DQorDQorc3RhdGljIGlubGluZSBfX3UzMiBwb3MybWFq
X2hhc2goc3RydWN0IGZpbGUgKmZpbHAsIGxvZmZfdCBwb3MpDQorew0KKwlpZiAoKGZpbHAtPmZf
bW9kZSAmIEZNT0RFXzMyQklUSEFTSCkgfHwNCisJICAgICghKGZpbHAtPmZfbW9kZSAmIEZNT0RF
XzY0QklUSEFTSCkgJiYgaXNfMzJiaXRfYXBpKCkpKQ0KKwkJcmV0dXJuIChwb3MgPDwgMSkgJiAw
eGZmZmZmZmZmOw0KKwllbHNlDQorCQlyZXR1cm4gKChwb3MgPj4gMzIpIDw8IDEpICYgMHhmZmZm
ZmZmZjsNCit9DQorDQorc3RhdGljIGlubGluZSBfX3UzMiBwb3MybWluX2hhc2goc3RydWN0IGZp
bGUgKmZpbHAsIGxvZmZfdCBwb3MpDQorew0KKwlpZiAoKGZpbHAtPmZfbW9kZSAmIEZNT0RFXzMy
QklUSEFTSCkgfHwNCisJICAgICghKGZpbHAtPmZfbW9kZSAmIEZNT0RFXzY0QklUSEFTSCkgJiYg
aXNfMzJiaXRfYXBpKCkpKQ0KKwkJcmV0dXJuIDA7DQorCWVsc2UNCisJCXJldHVybiBwb3MgJiAw
eGZmZmZmZmZmOw0KK30NCisNCisvKg0KKyAqIFJldHVybiAzMi0gb3IgNjQtYml0IGVuZC1vZi1m
aWxlIGZvciBkeCBkaXJlY3Rvcmllcw0KKyAqLw0KK3N0YXRpYyBpbmxpbmUgbG9mZl90IGV4dDNf
Z2V0X2h0cmVlX2VvZihzdHJ1Y3QgZmlsZSAqZmlscCkNCit7DQorCWlmICgoZmlscC0+Zl9tb2Rl
ICYgRk1PREVfMzJCSVRIQVNIKSB8fA0KKwkgICAgKCEoZmlscC0+Zl9tb2RlICYgRk1PREVfNjRC
SVRIQVNIKSAmJiBpc18zMmJpdF9hcGkoKSkpDQorCQlyZXR1cm4gRVhUM19IVFJFRV9FT0ZfMzJC
SVQ7DQorCWVsc2UNCisJCXJldHVybiBFWFQzX0hUUkVFX0VPRl82NEJJVDsNCit9DQorDQorDQor
LyoNCisgKiBleHQzX2Rpcl9sbHNlZWsoKSBjYWxscyBnZW5lcmljX2ZpbGVfbGxzZWVrW19zaXpl
XSgpIHRvIGhhbmRsZSBib3RoDQorICogbm9uLWh0cmVlIGFuZCBodHJlZSBkaXJlY3Rvcmllcywg
d2hlcmUgdGhlICJvZmZzZXQiIGlzIGluIHRlcm1zDQorICogb2YgdGhlIGZpbGVuYW1lIGhhc2gg
dmFsdWUgaW5zdGVhZCBvZiB0aGUgYnl0ZSBvZmZzZXQuDQorICoNCisgKiBCZWNhdXNlIHdlIG1h
eSByZXR1cm4gYSA2NC1iaXQgaGFzaCB0aGF0IGlzIHdlbGwgYmV5b25kIHNfbWF4Ynl0ZXMsDQor
ICogd2UgbmVlZCB0byBwYXNzIHRoZSBtYXggaGFzaCBhcyB0aGUgbWF4aW11bSBhbGxvd2FibGUg
b2Zmc2V0IGluDQorICogdGhlIGh0cmVlIGRpcmVjdG9yeSBjYXNlLg0KKyAqDQorICogTk9URTog
b2Zmc2V0cyBvYnRhaW5lZCAqYmVmb3JlKiBleHQzX3NldF9pbm9kZV9mbGFnKGRpciwgRVhUM19J
Tk9ERV9JTkRFWCkNCisgKiAgICAgICB3aWxsIGJlIGludmFsaWQgb25jZSB0aGUgZGlyZWN0b3J5
IHdhcyBjb252ZXJ0ZWQgaW50byBhIGR4IGRpcmVjdG9yeQ0KKyAqLw0KK2xvZmZfdCBleHQzX2Rp
cl9sbHNlZWsoc3RydWN0IGZpbGUgKmZpbGUsIGxvZmZfdCBvZmZzZXQsIGludCBvcmlnaW4pDQor
ew0KKwlzdHJ1Y3QgaW5vZGUgKmlub2RlID0gZmlsZS0+Zl9tYXBwaW5nLT5ob3N0Ow0KKwlpbnQg
ZHhfZGlyID0gaXNfZHhfZGlyKGlub2RlKTsNCisNCisJaWYgKGxpa2VseShkeF9kaXIpKQ0KKwkJ
cmV0dXJuIGdlbmVyaWNfZmlsZV9sbHNlZWtfc2l6ZShmaWxlLCBvZmZzZXQsIG9yaWdpbiwNCisJ
CQkJCSAgICAgICAgZXh0M19nZXRfaHRyZWVfZW9mKGZpbGUpKTsNCisJZWxzZQ0KKwkJcmV0dXJu
IGdlbmVyaWNfZmlsZV9sbHNlZWsoZmlsZSwgb2Zmc2V0LCBvcmlnaW4pOw0KK30NCiANCiAvKg0K
ICAqIFRoaXMgc3RydWN0dXJlIGhvbGRzIHRoZSBub2RlcyBvZiB0aGUgcmVkLWJsYWNrIHRyZWUg
dXNlZCB0byBzdG9yZQ0KQEAgLTMwOCwxNSArMzcyLDE2IEBAIHN0YXRpYyB2b2lkIGZyZWVfcmJf
dHJlZV9mbmFtZShzdHJ1Y3QgcmJfcm9vdCAqcm9vdCkNCiB9DQogDQogDQotc3RhdGljIHN0cnVj
dCBkaXJfcHJpdmF0ZV9pbmZvICpleHQzX2h0cmVlX2NyZWF0ZV9kaXJfaW5mbyhsb2ZmX3QgcG9z
KQ0KK3N0YXRpYyBzdHJ1Y3QgZGlyX3ByaXZhdGVfaW5mbyAqZXh0M19odHJlZV9jcmVhdGVfZGly
X2luZm8oc3RydWN0IGZpbGUgKmZpbHAsDQorCQkJCQkJCSAgIGxvZmZfdCBwb3MpDQogew0KIAlz
dHJ1Y3QgZGlyX3ByaXZhdGVfaW5mbyAqcDsNCiANCiAJcCA9IGt6YWxsb2Moc2l6ZW9mKHN0cnVj
dCBkaXJfcHJpdmF0ZV9pbmZvKSwgR0ZQX0tFUk5FTCk7DQogCWlmICghcCkNCiAJCXJldHVybiBO
VUxMOw0KLQlwLT5jdXJyX2hhc2ggPSBwb3MybWFqX2hhc2gocG9zKTsNCi0JcC0+Y3Vycl9taW5v
cl9oYXNoID0gcG9zMm1pbl9oYXNoKHBvcyk7DQorCXAtPmN1cnJfaGFzaCA9IHBvczJtYWpfaGFz
aChmaWxwLCBwb3MpOw0KKwlwLT5jdXJyX21pbm9yX2hhc2ggPSBwb3MybWluX2hhc2goZmlscCwg
cG9zKTsNCiAJcmV0dXJuIHA7DQogfQ0KIA0KQEAgLTQwNiw3ICs0NzEsNyBAQCBzdGF0aWMgaW50
IGNhbGxfZmlsbGRpcihzdHJ1Y3QgZmlsZSAqIGZpbHAsIHZvaWQgKiBkaXJlbnQsDQogCQlwcmlu
dGsoImNhbGxfZmlsbGRpcjogY2FsbGVkIHdpdGggbnVsbCBmbmFtZT8hP1xuIik7DQogCQlyZXR1
cm4gMDsNCiAJfQ0KLQljdXJyX3BvcyA9IGhhc2gycG9zKGZuYW1lLT5oYXNoLCBmbmFtZS0+bWlu
b3JfaGFzaCk7DQorCWN1cnJfcG9zID0gaGFzaDJwb3MoZmlscCwgZm5hbWUtPmhhc2gsIGZuYW1l
LT5taW5vcl9oYXNoKTsNCiAJd2hpbGUgKGZuYW1lKSB7DQogCQllcnJvciA9IGZpbGxkaXIoZGly
ZW50LCBmbmFtZS0+bmFtZSwNCiAJCQkJZm5hbWUtPm5hbWVfbGVuLCBjdXJyX3BvcywNCkBAIC00
MzEsMTMgKzQ5NiwxMyBAQCBzdGF0aWMgaW50IGV4dDNfZHhfcmVhZGRpcihzdHJ1Y3QgZmlsZSAq
IGZpbHAsDQogCWludAlyZXQ7DQogDQogCWlmICghaW5mbykgew0KLQkJaW5mbyA9IGV4dDNfaHRy
ZWVfY3JlYXRlX2Rpcl9pbmZvKGZpbHAtPmZfcG9zKTsNCisJCWluZm8gPSBleHQzX2h0cmVlX2Ny
ZWF0ZV9kaXJfaW5mbyhmaWxwLCBmaWxwLT5mX3Bvcyk7DQogCQlpZiAoIWluZm8pDQogCQkJcmV0
dXJuIC1FTk9NRU07DQogCQlmaWxwLT5wcml2YXRlX2RhdGEgPSBpbmZvOw0KIAl9DQogDQotCWlm
IChmaWxwLT5mX3BvcyA9PSBFWFQzX0hUUkVFX0VPRikNCisJaWYgKGZpbHAtPmZfcG9zID09IGV4
dDNfZ2V0X2h0cmVlX2VvZihmaWxwKSkNCiAJCXJldHVybiAwOwkvKiBFT0YgKi8NCiANCiAJLyog
U29tZSBvbmUgaGFzIG1lc3NlZCB3aXRoIGZfcG9zOyByZXNldCB0aGUgd29ybGQgKi8NCkBAIC00
NDUsOCArNTEwLDggQEAgc3RhdGljIGludCBleHQzX2R4X3JlYWRkaXIoc3RydWN0IGZpbGUgKiBm
aWxwLA0KIAkJZnJlZV9yYl90cmVlX2ZuYW1lKCZpbmZvLT5yb290KTsNCiAJCWluZm8tPmN1cnJf
bm9kZSA9IE5VTEw7DQogCQlpbmZvLT5leHRyYV9mbmFtZSA9IE5VTEw7DQotCQlpbmZvLT5jdXJy
X2hhc2ggPSBwb3MybWFqX2hhc2goZmlscC0+Zl9wb3MpOw0KLQkJaW5mby0+Y3Vycl9taW5vcl9o
YXNoID0gcG9zMm1pbl9oYXNoKGZpbHAtPmZfcG9zKTsNCisJCWluZm8tPmN1cnJfaGFzaCA9IHBv
czJtYWpfaGFzaChmaWxwLCBmaWxwLT5mX3Bvcyk7DQorCQlpbmZvLT5jdXJyX21pbm9yX2hhc2gg
PSBwb3MybWluX2hhc2goZmlscCwgZmlscC0+Zl9wb3MpOw0KIAl9DQogDQogCS8qDQpAQCAtNDc4
LDcgKzU0Myw3IEBAIHN0YXRpYyBpbnQgZXh0M19keF9yZWFkZGlyKHN0cnVjdCBmaWxlICogZmls
cCwNCiAJCQlpZiAocmV0IDwgMCkNCiAJCQkJcmV0dXJuIHJldDsNCiAJCQlpZiAocmV0ID09IDAp
IHsNCi0JCQkJZmlscC0+Zl9wb3MgPSBFWFQzX0hUUkVFX0VPRjsNCisJCQkJZmlscC0+Zl9wb3Mg
PSBleHQzX2dldF9odHJlZV9lb2YoZmlscCk7DQogCQkJCWJyZWFrOw0KIAkJCX0NCiAJCQlpbmZv
LT5jdXJyX25vZGUgPSByYl9maXJzdCgmaW5mby0+cm9vdCk7DQpAQCAtNDk4LDcgKzU2Myw3IEBA
IHN0YXRpYyBpbnQgZXh0M19keF9yZWFkZGlyKHN0cnVjdCBmaWxlICogZmlscCwNCiAJCQlpbmZv
LT5jdXJyX21pbm9yX2hhc2ggPSBmbmFtZS0+bWlub3JfaGFzaDsNCiAJCX0gZWxzZSB7DQogCQkJ
aWYgKGluZm8tPm5leHRfaGFzaCA9PSB+MCkgew0KLQkJCQlmaWxwLT5mX3BvcyA9IEVYVDNfSFRS
RUVfRU9GOw0KKwkJCQlmaWxwLT5mX3BvcyA9IGV4dDNfZ2V0X2h0cmVlX2VvZihmaWxwKTsNCiAJ
CQkJYnJlYWs7DQogCQkJfQ0KIAkJCWluZm8tPmN1cnJfaGFzaCA9IGluZm8tPm5leHRfaGFzaDsN
CkBAIC01MTcsMyArNTgyLDE1IEBAIHN0YXRpYyBpbnQgZXh0M19yZWxlYXNlX2RpciAoc3RydWN0
IGlub2RlICogaW5vZGUsIHN0cnVjdCBmaWxlICogZmlscCkNCiANCiAJcmV0dXJuIDA7DQogfQ0K
Kw0KK2NvbnN0IHN0cnVjdCBmaWxlX29wZXJhdGlvbnMgZXh0M19kaXJfb3BlcmF0aW9ucyA9IHsN
CisJLmxsc2VlawkJPSBleHQzX2Rpcl9sbHNlZWssDQorCS5yZWFkCQk9IGdlbmVyaWNfcmVhZF9k
aXIsDQorCS5yZWFkZGlyCT0gZXh0M19yZWFkZGlyLA0KKwkudW5sb2NrZWRfaW9jdGwgPSBleHQz
X2lvY3RsLA0KKyNpZmRlZiBDT05GSUdfQ09NUEFUDQorCS5jb21wYXRfaW9jdGwJPSBleHQzX2Nv
bXBhdF9pb2N0bCwNCisjZW5kaWYNCisJLmZzeW5jCQk9IGV4dDNfc3luY19maWxlLA0KKwkucmVs
ZWFzZQk9IGV4dDNfcmVsZWFzZV9kaXIsDQorfTsNCmRpZmYgLS1naXQgYS9mcy9leHQzL2hhc2gu
YyBiL2ZzL2V4dDMvaGFzaC5jDQppbmRleCA3ZDIxNWI0Li5kNGQzYWRlIDEwMDY0NA0KLS0tIGEv
ZnMvZXh0My9oYXNoLmMNCisrKyBiL2ZzL2V4dDMvaGFzaC5jDQpAQCAtMjAwLDggKzIwMCw4IEBA
IGludCBleHQzZnNfZGlyaGFzaChjb25zdCBjaGFyICpuYW1lLCBpbnQgbGVuLCBzdHJ1Y3QgZHhf
aGFzaF9pbmZvICpoaW5mbykNCiAJCXJldHVybiAtMTsNCiAJfQ0KIAloYXNoID0gaGFzaCAmIH4x
Ow0KLQlpZiAoaGFzaCA9PSAoRVhUM19IVFJFRV9FT0YgPDwgMSkpDQotCQloYXNoID0gKEVYVDNf
SFRSRUVfRU9GLTEpIDw8IDE7DQorCWlmIChoYXNoID09IChFWFQzX0hUUkVFX0VPRl8zMkJJVCA8
PCAxKSkNCisJCWhhc2ggPSAoRVhUM19IVFJFRV9FT0ZfMzJCSVQgLSAxKSA8PCAxOw0KIAloaW5m
by0+aGFzaCA9IGhhc2g7DQogCWhpbmZvLT5taW5vcl9oYXNoID0gbWlub3JfaGFzaDsNCiAJcmV0
dXJuIDA7DQpkaWZmIC0tZ2l0IGEvZnMvZXh0NC9kaXIuYyBiL2ZzL2V4dDQvZGlyLmMNCmluZGV4
IDE2NGM1NjAuLjY4OWQxYjEgMTAwNjQ0DQotLS0gYS9mcy9leHQ0L2Rpci5jDQorKysgYi9mcy9l
eHQ0L2Rpci5jDQpAQCAtMzIsMjQgKzMyLDggQEAgc3RhdGljIHVuc2lnbmVkIGNoYXIgZXh0NF9m
aWxldHlwZV90YWJsZVtdID0gew0KIAlEVF9VTktOT1dOLCBEVF9SRUcsIERUX0RJUiwgRFRfQ0hS
LCBEVF9CTEssIERUX0ZJRk8sIERUX1NPQ0ssIERUX0xOSw0KIH07DQogDQotc3RhdGljIGludCBl
eHQ0X3JlYWRkaXIoc3RydWN0IGZpbGUgKiwgdm9pZCAqLCBmaWxsZGlyX3QpOw0KIHN0YXRpYyBp
bnQgZXh0NF9keF9yZWFkZGlyKHN0cnVjdCBmaWxlICpmaWxwLA0KIAkJCSAgIHZvaWQgKmRpcmVu
dCwgZmlsbGRpcl90IGZpbGxkaXIpOw0KLXN0YXRpYyBpbnQgZXh0NF9yZWxlYXNlX2RpcihzdHJ1
Y3QgaW5vZGUgKmlub2RlLA0KLQkJCQlzdHJ1Y3QgZmlsZSAqZmlscCk7DQotDQotY29uc3Qgc3Ry
dWN0IGZpbGVfb3BlcmF0aW9ucyBleHQ0X2Rpcl9vcGVyYXRpb25zID0gew0KLQkubGxzZWVrCQk9
IGV4dDRfbGxzZWVrLA0KLQkucmVhZAkJPSBnZW5lcmljX3JlYWRfZGlyLA0KLQkucmVhZGRpcgk9
IGV4dDRfcmVhZGRpciwJCS8qIHdlIHRha2UgQktMLiBuZWVkZWQ/Ki8NCi0JLnVubG9ja2VkX2lv
Y3RsID0gZXh0NF9pb2N0bCwNCi0jaWZkZWYgQ09ORklHX0NPTVBBVA0KLQkuY29tcGF0X2lvY3Rs
CT0gZXh0NF9jb21wYXRfaW9jdGwsDQotI2VuZGlmDQotCS5mc3luYwkJPSBleHQ0X3N5bmNfZmls
ZSwNCi0JLnJlbGVhc2UJPSBleHQ0X3JlbGVhc2VfZGlyLA0KLX07DQotDQogDQogc3RhdGljIHVu
c2lnbmVkIGNoYXIgZ2V0X2R0eXBlKHN0cnVjdCBzdXBlcl9ibG9jayAqc2IsIGludCBmaWxldHlw
ZSkNCiB7DQpAQCAtNjAsNiArNDQsMjYgQEAgc3RhdGljIHVuc2lnbmVkIGNoYXIgZ2V0X2R0eXBl
KHN0cnVjdCBzdXBlcl9ibG9jayAqc2IsIGludCBmaWxldHlwZSkNCiAJcmV0dXJuIChleHQ0X2Zp
bGV0eXBlX3RhYmxlW2ZpbGV0eXBlXSk7DQogfQ0KIA0KKy8qKg0KKyAqIENoZWNrIGlmIHRoZSBn
aXZlbiBkaXItaW5vZGUgcmVmZXJzIHRvIGFuIGh0cmVlLWluZGV4ZWQgZGlyZWN0b3J5DQorICog
KG9yIGEgZGlyZWN0b3J5IHdoaWNoIGNob3VsZCBwb3RlbnRpYWxseSBnZXQgY292ZXJ0ZWQgdG8g
dXNlIGh0cmVlDQorICogaW5kZXhpbmcpLg0KKyAqDQorICogUmV0dXJuIDEgaWYgaXQgaXMgYSBk
eCBkaXIsIDAgaWYgbm90DQorICovDQorc3RhdGljIGludCBpc19keF9kaXIoc3RydWN0IGlub2Rl
ICppbm9kZSkNCit7DQorCXN0cnVjdCBzdXBlcl9ibG9jayAqc2IgPSBpbm9kZS0+aV9zYjsNCisN
CisJaWYgKEVYVDRfSEFTX0NPTVBBVF9GRUFUVVJFKGlub2RlLT5pX3NiLA0KKwkJICAgICBFWFQ0
X0ZFQVRVUkVfQ09NUEFUX0RJUl9JTkRFWCkgJiYNCisJICAgICgoZXh0NF90ZXN0X2lub2RlX2Zs
YWcoaW5vZGUsIEVYVDRfSU5PREVfSU5ERVgpKSB8fA0KKwkgICAgICgoaW5vZGUtPmlfc2l6ZSA+
PiBzYi0+c19ibG9ja3NpemVfYml0cykgPT0gMSkpKQ0KKwkJcmV0dXJuIDE7DQorDQorCXJldHVy
biAwOw0KK30NCisNCiAvKg0KICAqIFJldHVybiAwIGlmIHRoZSBkaXJlY3RvcnkgZW50cnkgaXMg
T0ssIGFuZCAxIGlmIHRoZXJlIGlzIGEgcHJvYmxlbQ0KICAqDQpAQCAtMTE1LDE4ICsxMTksMTMg
QEAgc3RhdGljIGludCBleHQ0X3JlYWRkaXIoc3RydWN0IGZpbGUgKmZpbHAsDQogCXVuc2lnbmVk
IGludCBvZmZzZXQ7DQogCWludCBpLCBzdG9yZWQ7DQogCXN0cnVjdCBleHQ0X2Rpcl9lbnRyeV8y
ICpkZTsNCi0Jc3RydWN0IHN1cGVyX2Jsb2NrICpzYjsNCiAJaW50IGVycjsNCiAJc3RydWN0IGlu
b2RlICppbm9kZSA9IGZpbHAtPmZfcGF0aC5kZW50cnktPmRfaW5vZGU7DQorCXN0cnVjdCBzdXBl
cl9ibG9jayAqc2IgPSBpbm9kZS0+aV9zYjsNCiAJaW50IHJldCA9IDA7DQogCWludCBkaXJfaGFz
X2Vycm9yID0gMDsNCiANCi0Jc2IgPSBpbm9kZS0+aV9zYjsNCi0NCi0JaWYgKEVYVDRfSEFTX0NP
TVBBVF9GRUFUVVJFKGlub2RlLT5pX3NiLA0KLQkJCQkgICAgRVhUNF9GRUFUVVJFX0NPTVBBVF9E
SVJfSU5ERVgpICYmDQotCSAgICAoKGV4dDRfdGVzdF9pbm9kZV9mbGFnKGlub2RlLCBFWFQ0X0lO
T0RFX0lOREVYKSkgfHwNCi0JICAgICAoKGlub2RlLT5pX3NpemUgPj4gc2ItPnNfYmxvY2tzaXpl
X2JpdHMpID09IDEpKSkgew0KKwlpZiAoaXNfZHhfZGlyKGlub2RlKSkgew0KIAkJZXJyID0gZXh0
NF9keF9yZWFkZGlyKGZpbHAsIGRpcmVudCwgZmlsbGRpcik7DQogCQlpZiAoZXJyICE9IEVSUl9C
QURfRFhfRElSKSB7DQogCQkJcmV0ID0gZXJyOw0KQEAgLTI1NCwyMiArMjUzLDEzNCBAQCBvdXQ6
DQogCXJldHVybiByZXQ7DQogfQ0KIA0KK3N0YXRpYyBpbmxpbmUgaW50IGlzXzMyYml0X2FwaSh2
b2lkKQ0KK3sNCisjaWZkZWYgQ09ORklHX0NPTVBBVA0KKwlyZXR1cm4gaXNfY29tcGF0X3Rhc2so
KTsNCisjZWxzZQ0KKwlyZXR1cm4gKEJJVFNfUEVSX0xPTkcgPT0gMzIpOw0KKyNlbmRpZg0KK30N
CisNCiAvKg0KICAqIFRoZXNlIGZ1bmN0aW9ucyBjb252ZXJ0IGZyb20gdGhlIG1ham9yL21pbm9y
IGhhc2ggdG8gYW4gZl9wb3MNCi0gKiB2YWx1ZS4NCisgKiB2YWx1ZSBmb3IgZHggZGlyZWN0b3Jp
ZXMNCisgKg0KKyAqIFVwcGVyIGxheWVyIChmb3IgZXhhbXBsZSBORlMpIHNob3VsZCBzcGVjaWZ5
IEZNT0RFXzMyQklUSEFTSCBvcg0KKyAqIEZNT0RFXzY0QklUSEFTSCBleHBsaWNpdGx5LiBPbiB0
aGUgb3RoZXIgaGFuZCwgd2UgYWxsb3cgZXh0NCB0byBiZSBtb3VudGVkDQorICogZGlyZWN0bHkg
b24gYm90aCAzMi1iaXQgYW5kIDY0LWJpdCBub2RlcywgdW5kZXIgc3VjaCBjYXNlLCBuZWl0aGVy
DQorICogRk1PREVfMzJCSVRIQVNIIG5vciBGTU9ERV82NEJJVEhBU0ggaXMgc3BlY2lmaWVkLg0K
KyAqLw0KK3N0YXRpYyBpbmxpbmUgbG9mZl90IGhhc2gycG9zKHN0cnVjdCBmaWxlICpmaWxwLCBf
X3UzMiBtYWpvciwgX191MzIgbWlub3IpDQorew0KKwlpZiAoKGZpbHAtPmZfbW9kZSAmIEZNT0RF
XzMyQklUSEFTSCkgfHwNCisJICAgICghKGZpbHAtPmZfbW9kZSAmIEZNT0RFXzY0QklUSEFTSCkg
JiYgaXNfMzJiaXRfYXBpKCkpKQ0KKwkJcmV0dXJuIG1ham9yID4+IDE7DQorCWVsc2UNCisJCXJl
dHVybiAoKF9fdTY0KShtYWpvciA+PiAxKSA8PCAzMikgfCAoX191NjQpbWlub3I7DQorfQ0KKw0K
K3N0YXRpYyBpbmxpbmUgX191MzIgcG9zMm1hal9oYXNoKHN0cnVjdCBmaWxlICpmaWxwLCBsb2Zm
X3QgcG9zKQ0KK3sNCisJaWYgKChmaWxwLT5mX21vZGUgJiBGTU9ERV8zMkJJVEhBU0gpIHx8DQor
CSAgICAoIShmaWxwLT5mX21vZGUgJiBGTU9ERV82NEJJVEhBU0gpICYmIGlzXzMyYml0X2FwaSgp
KSkNCisJCXJldHVybiAocG9zIDw8IDEpICYgMHhmZmZmZmZmZjsNCisJZWxzZQ0KKwkJcmV0dXJu
ICgocG9zID4+IDMyKSA8PCAxKSAmIDB4ZmZmZmZmZmY7DQorfQ0KKw0KK3N0YXRpYyBpbmxpbmUg
X191MzIgcG9zMm1pbl9oYXNoKHN0cnVjdCBmaWxlICpmaWxwLCBsb2ZmX3QgcG9zKQ0KK3sNCisJ
aWYgKChmaWxwLT5mX21vZGUgJiBGTU9ERV8zMkJJVEhBU0gpIHx8DQorCSAgICAoIShmaWxwLT5m
X21vZGUgJiBGTU9ERV82NEJJVEhBU0gpICYmIGlzXzMyYml0X2FwaSgpKSkNCisJCXJldHVybiAw
Ow0KKwllbHNlDQorCQlyZXR1cm4gcG9zICYgMHhmZmZmZmZmZjsNCit9DQorDQorLyoNCisgKiBS
ZXR1cm4gMzItIG9yIDY0LWJpdCBlbmQtb2YtZmlsZSBmb3IgZHggZGlyZWN0b3JpZXMNCisgKi8N
CitzdGF0aWMgaW5saW5lIGxvZmZfdCBleHQ0X2dldF9odHJlZV9lb2Yoc3RydWN0IGZpbGUgKmZp
bHApDQorew0KKwlpZiAoKGZpbHAtPmZfbW9kZSAmIEZNT0RFXzMyQklUSEFTSCkgfHwNCisJICAg
ICghKGZpbHAtPmZfbW9kZSAmIEZNT0RFXzY0QklUSEFTSCkgJiYgaXNfMzJiaXRfYXBpKCkpKQ0K
KwkJcmV0dXJuIEVYVDRfSFRSRUVfRU9GXzMyQklUOw0KKwllbHNlDQorCQlyZXR1cm4gRVhUNF9I
VFJFRV9FT0ZfNjRCSVQ7DQorfQ0KKw0KKw0KKy8qDQorICogZXh0NF9kaXJfbGxzZWVrKCkgYmFz
ZWQgb24gZ2VuZXJpY19maWxlX2xsc2VlaygpIHRvIGhhbmRsZSBib3RoDQorICogbm9uLWh0cmVl
IGFuZCBodHJlZSBkaXJlY3Rvcmllcywgd2hlcmUgdGhlICJvZmZzZXQiIGlzIGluIHRlcm1zDQor
ICogb2YgdGhlIGZpbGVuYW1lIGhhc2ggdmFsdWUgaW5zdGVhZCBvZiB0aGUgYnl0ZSBvZmZzZXQu
DQogICoNCi0gKiBDdXJyZW50bHkgd2Ugb25seSB1c2UgbWFqb3IgaGFzaCBudW1lci4gIFRoaXMg
aXMgdW5mb3J0dW5hdGUsIGJ1dA0KLSAqIG9uIDMyLWJpdCBtYWNoaW5lcywgdGhlIHNhbWUgVkZT
IGludGVyZmFjZSBpcyB1c2VkIGZvciBsc2VlayBhbmQNCi0gKiBsbHNlZWssIHNvIGlmIHdlIHVz
ZSB0aGUgNjQgYml0IG9mZnNldCwgdGhlbiB0aGUgMzItYml0IHZlcnNpb25zIG9mDQotICogbHNl
ZWsvdGVsbGRpci9zZWVrZGlyIHdpbGwgYmxvdyBvdXQgc3BlY3RhY3VsYXJseSwgYW5kIGZyb20g
d2l0aGluDQotICogdGhlIGV4dDIgbG93LWxldmVsIHJvdXRpbmUsIHdlIGRvbid0IGtub3cgaWYg
d2UncmUgYmVpbmcgY2FsbGVkIGJ5DQotICogYSA2NC1iaXQgdmVyc2lvbiBvZiB0aGUgc3lzdGVt
IGNhbGwgb3IgdGhlIDMyLWJpdCB2ZXJzaW9uIG9mIHRoZQ0KLSAqIHN5c3RlbSBjYWxsLiAgV29y
c2UgeWV0LCBORlN2MiBvbmx5IGFsbG93cyBmb3IgYSAzMi1iaXQgcmVhZGRpcg0KLSAqIGNvb2tp
ZS4gIFNpZ2guDQorICogTk9URTogb2Zmc2V0cyBvYnRhaW5lZCAqYmVmb3JlKiBleHQ0X3NldF9p
bm9kZV9mbGFnKGRpciwgRVhUNF9JTk9ERV9JTkRFWCkNCisgKiAgICAgICB3aWxsIGJlIGludmFs
aWQgb25jZSB0aGUgZGlyZWN0b3J5IHdhcyBjb252ZXJ0ZWQgaW50byBhIGR4IGRpcmVjdG9yeQ0K
ICAqLw0KLSNkZWZpbmUgaGFzaDJwb3MobWFqb3IsIG1pbm9yKQkobWFqb3IgPj4gMSkNCi0jZGVm
aW5lIHBvczJtYWpfaGFzaChwb3MpCSgocG9zIDw8IDEpICYgMHhmZmZmZmZmZikNCi0jZGVmaW5l
IHBvczJtaW5faGFzaChwb3MpCSgwKQ0KK2xvZmZfdCBleHQ0X2Rpcl9sbHNlZWsoc3RydWN0IGZp
bGUgKmZpbGUsIGxvZmZfdCBvZmZzZXQsIGludCBvcmlnaW4pDQorew0KKwlzdHJ1Y3QgaW5vZGUg
Kmlub2RlID0gZmlsZS0+Zl9tYXBwaW5nLT5ob3N0Ow0KKwlsb2ZmX3QgcmV0ID0gLUVJTlZBTDsN
CisJaW50IGR4X2RpciA9IGlzX2R4X2Rpcihpbm9kZSk7DQorDQorCW11dGV4X2xvY2soJmlub2Rl
LT5pX211dGV4KTsNCisNCisJLyogTk9URTogcmVsYXRpdmUgb2Zmc2V0cyB3aXRoIGR4IGRpcmVj
dG9yaWVzIG1pZ2h0IG5vdCB3b3JrDQorCSAqICAgICAgIGFzIGV4cGVjdGVkLCBhcyBpdCBpcyBk
aWZmaWN1bHQgdG8gZmlndXJlIG91dCB0aGUNCisJICogICAgICAgY29ycmVjdCBvZmZzZXQgYmV0
d2VlbiBkeCBoYXNoZXMgKi8NCisNCisJc3dpdGNoIChvcmlnaW4pIHsNCisJY2FzZSBTRUVLX0VO
RDoNCisJCWlmICh1bmxpa2VseShvZmZzZXQgPiAwKSkNCisJCQlnb3RvIG91dF9lcnI7IC8qIG5v
dCBzdXBwb3J0ZWQgZm9yIGRpcmVjdG9yaWVzICovDQorDQorCQkvKiBzbyBvbmx5IG5lZ2F0aXZl
IG9mZnNldHMgYXJlIGxlZnQsIGRvZXMgdGhhdCBoYXZlIGENCisJCSAqIG1lYW5pbmcgZm9yIGRp
cmVjdG9yaWVzIGF0IGFsbD8gKi8NCisJCWlmIChkeF9kaXIpDQorCQkJb2Zmc2V0ICs9IGV4dDRf
Z2V0X2h0cmVlX2VvZihmaWxlKTsNCisJCWVsc2UNCisJCQlvZmZzZXQgKz0gaW5vZGUtPmlfc2l6
ZTsNCisJCWJyZWFrOw0KKwljYXNlIFNFRUtfQ1VSOg0KKwkJLyoNCisJCSAqIEhlcmUgd2Ugc3Bl
Y2lhbC1jYXNlIHRoZSBsc2VlayhmZCwgMCwgU0VFS19DVVIpDQorCQkgKiBwb3NpdGlvbi1xdWVy
eWluZyBvcGVyYXRpb24uICBBdm9pZCByZXdyaXRpbmcgdGhlICJzYW1lIg0KKwkJICogZl9wb3Mg
dmFsdWUgYmFjayB0byB0aGUgZmlsZSBiZWNhdXNlIGEgY29uY3VycmVudCByZWFkKCksDQorCQkg
KiB3cml0ZSgpIG9yIGxzZWVrKCkgbWlnaHQgaGF2ZSBhbHRlcmVkIGl0DQorCQkgKi8NCisJCWlm
IChvZmZzZXQgPT0gMCkgew0KKwkJCW9mZnNldCA9IGZpbGUtPmZfcG9zOw0KKwkJCWdvdG8gb3V0
X29rOw0KKwkJfQ0KKw0KKwkJb2Zmc2V0ICs9IGZpbGUtPmZfcG9zOw0KKwkJYnJlYWs7DQorCX0N
CisNCisJaWYgKHVubGlrZWx5KG9mZnNldCA8IDApKQ0KKwkJZ290byBvdXRfZXJyOw0KKw0KKwlp
ZiAoIWR4X2Rpcikgew0KKwkJaWYgKG9mZnNldCA+IGlub2RlLT5pX3NiLT5zX21heGJ5dGVzKQ0K
KwkJCWdvdG8gb3V0X2VycjsNCisJfSBlbHNlIGlmIChvZmZzZXQgPiBleHQ0X2dldF9odHJlZV9l
b2YoZmlsZSkpDQorCQlnb3RvIG91dF9lcnI7DQorDQorCS8qIFNwZWNpYWwgbG9jayBuZWVkZWQg
aGVyZT8gKi8NCisJaWYgKG9mZnNldCAhPSBmaWxlLT5mX3Bvcykgew0KKwkJZmlsZS0+Zl9wb3Mg
PSBvZmZzZXQ7DQorCQlmaWxlLT5mX3ZlcnNpb24gPSAwOw0KKwl9DQorDQorb3V0X29rOg0KKwly
ZXQgPSBvZmZzZXQ7DQorb3V0X2VycjoNCisJbXV0ZXhfdW5sb2NrKCZpbm9kZS0+aV9tdXRleCk7
DQorDQorCXJldHVybiByZXQ7DQorfQ0KIA0KIC8qDQogICogVGhpcyBzdHJ1Y3R1cmUgaG9sZHMg
dGhlIG5vZGVzIG9mIHRoZSByZWQtYmxhY2sgdHJlZSB1c2VkIHRvIHN0b3JlDQpAQCAtMzMwLDE1
ICs0NDEsMTYgQEAgc3RhdGljIHZvaWQgZnJlZV9yYl90cmVlX2ZuYW1lKHN0cnVjdCByYl9yb290
ICpyb290KQ0KIH0NCiANCiANCi1zdGF0aWMgc3RydWN0IGRpcl9wcml2YXRlX2luZm8gKmV4dDRf
aHRyZWVfY3JlYXRlX2Rpcl9pbmZvKGxvZmZfdCBwb3MpDQorc3RhdGljIHN0cnVjdCBkaXJfcHJp
dmF0ZV9pbmZvICpleHQ0X2h0cmVlX2NyZWF0ZV9kaXJfaW5mbyhzdHJ1Y3QgZmlsZSAqZmlscCwN
CisJCQkJCQkJICAgbG9mZl90IHBvcykNCiB7DQogCXN0cnVjdCBkaXJfcHJpdmF0ZV9pbmZvICpw
Ow0KIA0KIAlwID0ga3phbGxvYyhzaXplb2Yoc3RydWN0IGRpcl9wcml2YXRlX2luZm8pLCBHRlBf
S0VSTkVMKTsNCiAJaWYgKCFwKQ0KIAkJcmV0dXJuIE5VTEw7DQotCXAtPmN1cnJfaGFzaCA9IHBv
czJtYWpfaGFzaChwb3MpOw0KLQlwLT5jdXJyX21pbm9yX2hhc2ggPSBwb3MybWluX2hhc2gocG9z
KTsNCisJcC0+Y3Vycl9oYXNoID0gcG9zMm1hal9oYXNoKGZpbHAsIHBvcyk7DQorCXAtPmN1cnJf
bWlub3JfaGFzaCA9IHBvczJtaW5faGFzaChmaWxwLCBwb3MpOw0KIAlyZXR1cm4gcDsNCiB9DQog
DQpAQCAtNDI5LDcgKzU0MSw3IEBAIHN0YXRpYyBpbnQgY2FsbF9maWxsZGlyKHN0cnVjdCBmaWxl
ICpmaWxwLCB2b2lkICpkaXJlbnQsDQogCQkgICAgICAgIm51bGwgZm5hbWU/IT9cbiIpOw0KIAkJ
cmV0dXJuIDA7DQogCX0NCi0JY3Vycl9wb3MgPSBoYXNoMnBvcyhmbmFtZS0+aGFzaCwgZm5hbWUt
Pm1pbm9yX2hhc2gpOw0KKwljdXJyX3BvcyA9IGhhc2gycG9zKGZpbHAsIGZuYW1lLT5oYXNoLCBm
bmFtZS0+bWlub3JfaGFzaCk7DQogCXdoaWxlIChmbmFtZSkgew0KIAkJZXJyb3IgPSBmaWxsZGly
KGRpcmVudCwgZm5hbWUtPm5hbWUsDQogCQkJCWZuYW1lLT5uYW1lX2xlbiwgY3Vycl9wb3MsDQpA
QCAtNDU0LDEzICs1NjYsMTMgQEAgc3RhdGljIGludCBleHQ0X2R4X3JlYWRkaXIoc3RydWN0IGZp
bGUgKmZpbHAsDQogCWludAlyZXQ7DQogDQogCWlmICghaW5mbykgew0KLQkJaW5mbyA9IGV4dDRf
aHRyZWVfY3JlYXRlX2Rpcl9pbmZvKGZpbHAtPmZfcG9zKTsNCisJCWluZm8gPSBleHQ0X2h0cmVl
X2NyZWF0ZV9kaXJfaW5mbyhmaWxwLCBmaWxwLT5mX3Bvcyk7DQogCQlpZiAoIWluZm8pDQogCQkJ
cmV0dXJuIC1FTk9NRU07DQogCQlmaWxwLT5wcml2YXRlX2RhdGEgPSBpbmZvOw0KIAl9DQogDQot
CWlmIChmaWxwLT5mX3BvcyA9PSBFWFQ0X0hUUkVFX0VPRikNCisJaWYgKGZpbHAtPmZfcG9zID09
IGV4dDRfZ2V0X2h0cmVlX2VvZihmaWxwKSkNCiAJCXJldHVybiAwOwkvKiBFT0YgKi8NCiANCiAJ
LyogU29tZSBvbmUgaGFzIG1lc3NlZCB3aXRoIGZfcG9zOyByZXNldCB0aGUgd29ybGQgKi8NCkBA
IC00NjgsOCArNTgwLDggQEAgc3RhdGljIGludCBleHQ0X2R4X3JlYWRkaXIoc3RydWN0IGZpbGUg
KmZpbHAsDQogCQlmcmVlX3JiX3RyZWVfZm5hbWUoJmluZm8tPnJvb3QpOw0KIAkJaW5mby0+Y3Vy
cl9ub2RlID0gTlVMTDsNCiAJCWluZm8tPmV4dHJhX2ZuYW1lID0gTlVMTDsNCi0JCWluZm8tPmN1
cnJfaGFzaCA9IHBvczJtYWpfaGFzaChmaWxwLT5mX3Bvcyk7DQotCQlpbmZvLT5jdXJyX21pbm9y
X2hhc2ggPSBwb3MybWluX2hhc2goZmlscC0+Zl9wb3MpOw0KKwkJaW5mby0+Y3Vycl9oYXNoID0g
cG9zMm1hal9oYXNoKGZpbHAsIGZpbHAtPmZfcG9zKTsNCisJCWluZm8tPmN1cnJfbWlub3JfaGFz
aCA9IHBvczJtaW5faGFzaChmaWxwLCBmaWxwLT5mX3Bvcyk7DQogCX0NCiANCiAJLyoNCkBAIC01
MDEsNyArNjEzLDcgQEAgc3RhdGljIGludCBleHQ0X2R4X3JlYWRkaXIoc3RydWN0IGZpbGUgKmZp
bHAsDQogCQkJaWYgKHJldCA8IDApDQogCQkJCXJldHVybiByZXQ7DQogCQkJaWYgKHJldCA9PSAw
KSB7DQotCQkJCWZpbHAtPmZfcG9zID0gRVhUNF9IVFJFRV9FT0Y7DQorCQkJCWZpbHAtPmZfcG9z
ID0gZXh0NF9nZXRfaHRyZWVfZW9mKGZpbHApOw0KIAkJCQlicmVhazsNCiAJCQl9DQogCQkJaW5m
by0+Y3Vycl9ub2RlID0gcmJfZmlyc3QoJmluZm8tPnJvb3QpOw0KQEAgLTUyMSw3ICs2MzMsNyBA
QCBzdGF0aWMgaW50IGV4dDRfZHhfcmVhZGRpcihzdHJ1Y3QgZmlsZSAqZmlscCwNCiAJCQlpbmZv
LT5jdXJyX21pbm9yX2hhc2ggPSBmbmFtZS0+bWlub3JfaGFzaDsNCiAJCX0gZWxzZSB7DQogCQkJ
aWYgKGluZm8tPm5leHRfaGFzaCA9PSB+MCkgew0KLQkJCQlmaWxwLT5mX3BvcyA9IEVYVDRfSFRS
RUVfRU9GOw0KKwkJCQlmaWxwLT5mX3BvcyA9IGV4dDRfZ2V0X2h0cmVlX2VvZihmaWxwKTsNCiAJ
CQkJYnJlYWs7DQogCQkJfQ0KIAkJCWluZm8tPmN1cnJfaGFzaCA9IGluZm8tPm5leHRfaGFzaDsN
CkBAIC01NDAsMyArNjUyLDE1IEBAIHN0YXRpYyBpbnQgZXh0NF9yZWxlYXNlX2RpcihzdHJ1Y3Qg
aW5vZGUgKmlub2RlLCBzdHJ1Y3QgZmlsZSAqZmlscCkNCiANCiAJcmV0dXJuIDA7DQogfQ0KKw0K
K2NvbnN0IHN0cnVjdCBmaWxlX29wZXJhdGlvbnMgZXh0NF9kaXJfb3BlcmF0aW9ucyA9IHsNCisJ
Lmxsc2VlawkJPSBleHQ0X2Rpcl9sbHNlZWssDQorCS5yZWFkCQk9IGdlbmVyaWNfcmVhZF9kaXIs
DQorCS5yZWFkZGlyCT0gZXh0NF9yZWFkZGlyLA0KKwkudW5sb2NrZWRfaW9jdGwgPSBleHQ0X2lv
Y3RsLA0KKyNpZmRlZiBDT05GSUdfQ09NUEFUDQorCS5jb21wYXRfaW9jdGwJPSBleHQ0X2NvbXBh
dF9pb2N0bCwNCisjZW5kaWYNCisJLmZzeW5jCQk9IGV4dDRfc3luY19maWxlLA0KKwkucmVsZWFz
ZQk9IGV4dDRfcmVsZWFzZV9kaXIsDQorfTsNCmRpZmYgLS1naXQgYS9mcy9leHQ0L2V4dDQuaCBi
L2ZzL2V4dDQvZXh0NC5oDQppbmRleCA2MGI2Y2E1Li4yMmM3MWI5IDEwMDY0NA0KLS0tIGEvZnMv
ZXh0NC9leHQ0LmgNCisrKyBiL2ZzL2V4dDQvZXh0NC5oDQpAQCAtMTU5Nyw3ICsxNTk3LDExIEBA
IHN0cnVjdCBkeF9oYXNoX2luZm8NCiAJdTMyCQkqc2VlZDsNCiB9Ow0KIA0KLSNkZWZpbmUgRVhU
NF9IVFJFRV9FT0YJMHg3ZmZmZmZmZg0KKw0KKy8qIDMyIGFuZCA2NCBiaXQgc2lnbmVkIEVPRiBm
b3IgZHggZGlyZWN0b3JpZXMgKi8NCisjZGVmaW5lIEVYVDRfSFRSRUVfRU9GXzMyQklUICAgKCgx
VUwgIDw8ICgzMiAtIDEpKSAtIDEpDQorI2RlZmluZSBFWFQ0X0hUUkVFX0VPRl82NEJJVCAgICgo
MVVMTCA8PCAoNjQgLSAxKSkgLSAxKQ0KKw0KIA0KIC8qDQogICogQ29udHJvbCBwYXJhbWV0ZXJz
IHVzZWQgYnkgZXh0NF9odHJlZV9uZXh0X2Jsb2NrDQpkaWZmIC0tZ2l0IGEvZnMvZXh0NC9oYXNo
LmMgYi9mcy9leHQ0L2hhc2guYw0KaW5kZXggYWM4ZjE2OC4uZmE4ZTQ5MSAxMDA2NDQNCi0tLSBh
L2ZzL2V4dDQvaGFzaC5jDQorKysgYi9mcy9leHQ0L2hhc2guYw0KQEAgLTIwMCw4ICsyMDAsOCBA
QCBpbnQgZXh0NGZzX2Rpcmhhc2goY29uc3QgY2hhciAqbmFtZSwgaW50IGxlbiwgc3RydWN0IGR4
X2hhc2hfaW5mbyAqaGluZm8pDQogCQlyZXR1cm4gLTE7DQogCX0NCiAJaGFzaCA9IGhhc2ggJiB+
MTsNCi0JaWYgKGhhc2ggPT0gKEVYVDRfSFRSRUVfRU9GIDw8IDEpKQ0KLQkJaGFzaCA9IChFWFQ0
X0hUUkVFX0VPRi0xKSA8PCAxOw0KKwlpZiAoaGFzaCA9PSAoRVhUNF9IVFJFRV9FT0ZfMzJCSVQg
PDwgMSkpDQorCQloYXNoID0gKEVYVDRfSFRSRUVfRU9GXzMyQklUIC0gMSkgPDwgMTsNCiAJaGlu
Zm8tPmhhc2ggPSBoYXNoOw0KIAloaW5mby0+bWlub3JfaGFzaCA9IG1pbm9yX2hhc2g7DQogCXJl
dHVybiAwOw0KZGlmZiAtLWdpdCBhL2ZzL2V4dDQveGF0dHIuYyBiL2ZzL2V4dDQveGF0dHIuYw0K
aW5kZXggZDU0OThiMi4uYjRlOWYzZiAxMDA2NDQNCi0tLSBhL2ZzL2V4dDQveGF0dHIuYw0KKysr
IGIvZnMvZXh0NC94YXR0ci5jDQpAQCAtMTI2OSw2ICsxMjY5LDggQEAgcmV0cnk6DQogCQkJCSAg
ICBzX21pbl9leHRyYV9pc2l6ZSkgew0KIAkJCQkJdHJpZWRfbWluX2V4dHJhX2lzaXplKys7DQog
CQkJCQluZXdfZXh0cmFfaXNpemUgPSBzX21pbl9leHRyYV9pc2l6ZTsNCisJCQkJCWtmcmVlKGlz
KTsgaXMgPSBOVUxMOw0KKwkJCQkJa2ZyZWUoYnMpOyBicyA9IE5VTEw7DQogCQkJCQlnb3RvIHJl
dHJ5Ow0KIAkJCQl9DQogCQkJCWVycm9yID0gLTE7DQpkaWZmIC0tZ2l0IGEvZnMvamZzL2pmc19p
bm9kZS5jIGIvZnMvamZzL2pmc19pbm9kZS5jDQppbmRleCBjMWEzZTYwLi43ZjQ2NGM1IDEwMDY0
NA0KLS0tIGEvZnMvamZzL2pmc19pbm9kZS5jDQorKysgYi9mcy9qZnMvamZzX2lub2RlLmMNCkBA
IC05NSw3ICs5NSw3IEBAIHN0cnVjdCBpbm9kZSAqaWFsbG9jKHN0cnVjdCBpbm9kZSAqcGFyZW50
LCB1bW9kZV90IG1vZGUpDQogDQogCWlmIChpbnNlcnRfaW5vZGVfbG9ja2VkKGlub2RlKSA8IDAp
IHsNCiAJCXJjID0gLUVJTlZBTDsNCi0JCWdvdG8gZmFpbF91bmxvY2s7DQorCQlnb3RvIGZhaWxf
cHV0Ow0KIAl9DQogDQogCWlub2RlX2luaXRfb3duZXIoaW5vZGUsIHBhcmVudCwgbW9kZSk7DQpA
QCAtMTU2LDcgKzE1Niw2IEBAIHN0cnVjdCBpbm9kZSAqaWFsbG9jKHN0cnVjdCBpbm9kZSAqcGFy
ZW50LCB1bW9kZV90IG1vZGUpDQogZmFpbF9kcm9wOg0KIAlkcXVvdF9kcm9wKGlub2RlKTsNCiAJ
aW5vZGUtPmlfZmxhZ3MgfD0gU19OT1FVT1RBOw0KLWZhaWxfdW5sb2NrOg0KIAljbGVhcl9ubGlu
ayhpbm9kZSk7DQogCXVubG9ja19uZXdfaW5vZGUoaW5vZGUpOw0KIGZhaWxfcHV0Og0KZGlmZiAt
LWdpdCBhL2ZzL25mc2QvdmZzLmMgYi9mcy9uZnNkL3Zmcy5jDQppbmRleCA1NjFhM2RjLi42MWI2
OTdlIDEwMDY0NA0KLS0tIGEvZnMvbmZzZC92ZnMuYw0KKysrIGIvZnMvbmZzZC92ZnMuYw0KQEAg
LTcyNiwxMiArNzI2LDEzIEBAIHN0YXRpYyBpbnQgbmZzZF9vcGVuX2JyZWFrX2xlYXNlKHN0cnVj
dCBpbm9kZSAqaW5vZGUsIGludCBhY2Nlc3MpDQogDQogLyoNCiAgKiBPcGVuIGFuIGV4aXN0aW5n
IGZpbGUgb3IgZGlyZWN0b3J5Lg0KLSAqIFRoZSBhY2Nlc3MgYXJndW1lbnQgaW5kaWNhdGVzIHRo
ZSB0eXBlIG9mIG9wZW4gKHJlYWQvd3JpdGUvbG9jaykNCisgKiBUaGUgbWF5X2ZsYWdzIGFyZ3Vt
ZW50IGluZGljYXRlcyB0aGUgdHlwZSBvZiBvcGVuIChyZWFkL3dyaXRlL2xvY2spDQorICogYW5k
IGFkZGl0aW9uYWwgZmxhZ3MuDQogICogTi5CLiBBZnRlciB0aGlzIGNhbGwgZmhwIG5lZWRzIGFu
IGZoX3B1dA0KICAqLw0KIF9fYmUzMg0KIG5mc2Rfb3BlbihzdHJ1Y3Qgc3ZjX3Jxc3QgKnJxc3Rw
LCBzdHJ1Y3Qgc3ZjX2ZoICpmaHAsIGludCB0eXBlLA0KLQkJCWludCBhY2Nlc3MsIHN0cnVjdCBm
aWxlICoqZmlscCkNCisJCQlpbnQgbWF5X2ZsYWdzLCBzdHJ1Y3QgZmlsZSAqKmZpbHApDQogew0K
IAlzdHJ1Y3QgZGVudHJ5CSpkZW50cnk7DQogCXN0cnVjdCBpbm9kZQkqaW5vZGU7DQpAQCAtNzQ2
LDcgKzc0Nyw3IEBAIG5mc2Rfb3BlbihzdHJ1Y3Qgc3ZjX3Jxc3QgKnJxc3RwLCBzdHJ1Y3Qgc3Zj
X2ZoICpmaHAsIGludCB0eXBlLA0KIAkgKiBhbmQgKGhvcGVmdWxseSkgY2hlY2tlZCBwZXJtaXNz
aW9uIC0gc28gYWxsb3cgT1dORVJfT1ZFUlJJREUNCiAJICogaW4gY2FzZSBhIGNobW9kIGhhcyBu
b3cgcmV2b2tlZCBwZXJtaXNzaW9uLg0KIAkgKi8NCi0JZXJyID0gZmhfdmVyaWZ5KHJxc3RwLCBm
aHAsIHR5cGUsIGFjY2VzcyB8IE5GU0RfTUFZX09XTkVSX09WRVJSSURFKTsNCisJZXJyID0gZmhf
dmVyaWZ5KHJxc3RwLCBmaHAsIHR5cGUsIG1heV9mbGFncyB8IE5GU0RfTUFZX09XTkVSX09WRVJS
SURFKTsNCiAJaWYgKGVycikNCiAJCWdvdG8gb3V0Ow0KIA0KQEAgLTc1Nyw3ICs3NTgsNyBAQCBu
ZnNkX29wZW4oc3RydWN0IHN2Y19ycXN0ICpycXN0cCwgc3RydWN0IHN2Y19maCAqZmhwLCBpbnQg
dHlwZSwNCiAJICogb3IgYW55IGFjY2VzcyB3aGVuIG1hbmRhdG9yeSBsb2NraW5nIGVuYWJsZWQN
CiAJICovDQogCWVyciA9IG5mc2Vycl9wZXJtOw0KLQlpZiAoSVNfQVBQRU5EKGlub2RlKSAmJiAo
YWNjZXNzICYgTkZTRF9NQVlfV1JJVEUpKQ0KKwlpZiAoSVNfQVBQRU5EKGlub2RlKSAmJiAobWF5
X2ZsYWdzICYgTkZTRF9NQVlfV1JJVEUpKQ0KIAkJZ290byBvdXQ7DQogCS8qDQogCSAqIFdlIG11
c3QgaWdub3JlIGZpbGVzIChidXQgb25seSBmaWxlcykgd2hpY2ggbWlnaHQgaGF2ZSBtYW5kYXRv
cnkNCkBAIC03NzAsMTIgKzc3MSwxMiBAQCBuZnNkX29wZW4oc3RydWN0IHN2Y19ycXN0ICpycXN0
cCwgc3RydWN0IHN2Y19maCAqZmhwLCBpbnQgdHlwZSwNCiAJaWYgKCFpbm9kZS0+aV9mb3ApDQog
CQlnb3RvIG91dDsNCiANCi0JaG9zdF9lcnIgPSBuZnNkX29wZW5fYnJlYWtfbGVhc2UoaW5vZGUs
IGFjY2Vzcyk7DQorCWhvc3RfZXJyID0gbmZzZF9vcGVuX2JyZWFrX2xlYXNlKGlub2RlLCBtYXlf
ZmxhZ3MpOw0KIAlpZiAoaG9zdF9lcnIpIC8qIE5PTUVNIG9yIFdPVUxEQkxPQ0sgKi8NCiAJCWdv
dG8gb3V0X25mc2VycjsNCiANCi0JaWYgKGFjY2VzcyAmIE5GU0RfTUFZX1dSSVRFKSB7DQotCQlp
ZiAoYWNjZXNzICYgTkZTRF9NQVlfUkVBRCkNCisJaWYgKG1heV9mbGFncyAmIE5GU0RfTUFZX1dS
SVRFKSB7DQorCQlpZiAobWF5X2ZsYWdzICYgTkZTRF9NQVlfUkVBRCkNCiAJCQlmbGFncyA9IE9f
UkRXUnxPX0xBUkdFRklMRTsNCiAJCWVsc2UNCiAJCQlmbGFncyA9IE9fV1JPTkxZfE9fTEFSR0VG
SUxFOw0KQEAgLTc4NSw4ICs3ODYsMTUgQEAgbmZzZF9vcGVuKHN0cnVjdCBzdmNfcnFzdCAqcnFz
dHAsIHN0cnVjdCBzdmNfZmggKmZocCwgaW50IHR5cGUsDQogCWlmIChJU19FUlIoKmZpbHApKSB7
DQogCQlob3N0X2VyciA9IFBUUl9FUlIoKmZpbHApOw0KIAkJKmZpbHAgPSBOVUxMOw0KLQl9IGVs
c2UNCi0JCWhvc3RfZXJyID0gaW1hX2ZpbGVfY2hlY2soKmZpbHAsIGFjY2Vzcyk7DQorCX0gZWxz
ZSB7DQorCQlob3N0X2VyciA9IGltYV9maWxlX2NoZWNrKCpmaWxwLCBtYXlfZmxhZ3MpOw0KKw0K
KwkJaWYgKG1heV9mbGFncyAmIE5GU0RfTUFZXzY0QklUX0NPT0tJRSkNCisJCQkoKmZpbHApLT5m
X21vZGUgfD0gRk1PREVfNjRCSVRIQVNIOw0KKwkJZWxzZQ0KKwkJCSgqZmlscCktPmZfbW9kZSB8
PSBGTU9ERV8zMkJJVEhBU0g7DQorCX0NCisNCiBvdXRfbmZzZXJyOg0KIAllcnIgPSBuZnNlcnJu
byhob3N0X2Vycik7DQogb3V0Og0KQEAgLTIwMTYsOCArMjAyNCwxMyBAQCBuZnNkX3JlYWRkaXIo
c3RydWN0IHN2Y19ycXN0ICpycXN0cCwgc3RydWN0IHN2Y19maCAqZmhwLCBsb2ZmX3QgKm9mZnNl
dHAsDQogCV9fYmUzMgkJZXJyOw0KIAlzdHJ1Y3QgZmlsZQkqZmlsZTsNCiAJbG9mZl90CQlvZmZz
ZXQgPSAqb2Zmc2V0cDsNCisJaW50ICAgICAgICAgICAgIG1heV9mbGFncyA9IE5GU0RfTUFZX1JF
QUQ7DQorDQorCS8qIE5GU3YyIG9ubHkgc3VwcG9ydHMgMzIgYml0IGNvb2tpZXMgKi8NCisJaWYg
KHJxc3RwLT5ycV92ZXJzID4gMikNCisJCW1heV9mbGFncyB8PSBORlNEX01BWV82NEJJVF9DT09L
SUU7DQogDQotCWVyciA9IG5mc2Rfb3BlbihycXN0cCwgZmhwLCBTX0lGRElSLCBORlNEX01BWV9S
RUFELCAmZmlsZSk7DQorCWVyciA9IG5mc2Rfb3BlbihycXN0cCwgZmhwLCBTX0lGRElSLCBtYXlf
ZmxhZ3MsICZmaWxlKTsNCiAJaWYgKGVycikNCiAJCWdvdG8gb3V0Ow0KIA0KZGlmZiAtLWdpdCBh
L2ZzL25mc2QvdmZzLmggYi9mcy9uZnNkL3Zmcy5oDQppbmRleCAzZjU0YWQwLi44NWQ0ZDQyIDEw
MDY0NA0KLS0tIGEvZnMvbmZzZC92ZnMuaA0KKysrIGIvZnMvbmZzZC92ZnMuaA0KQEAgLTI3LDYg
KzI3LDggQEANCiAjZGVmaW5lIE5GU0RfTUFZX0JZUEFTU19HU1MJCTB4NDAwDQogI2RlZmluZSBO
RlNEX01BWV9SRUFEX0lGX0VYRUMJCTB4ODAwDQogDQorI2RlZmluZSBORlNEX01BWV82NEJJVF9D
T09LSUUJCTB4MTAwMCAvKiA2NCBiaXQgcmVhZGRpciBjb29raWVzIGZvciA+PSBORlN2MyAqLw0K
Kw0KICNkZWZpbmUgTkZTRF9NQVlfQ1JFQVRFCQkoTkZTRF9NQVlfRVhFQ3xORlNEX01BWV9XUklU
RSkNCiAjZGVmaW5lIE5GU0RfTUFZX1JFTU9WRQkJKE5GU0RfTUFZX0VYRUN8TkZTRF9NQVlfV1JJ
VEV8TkZTRF9NQVlfVFJVTkMpDQogDQpkaWZmIC0tZ2l0IGEvZnMvc3RhdGZzLmMgYi9mcy9zdGF0
ZnMuYw0KaW5kZXggOWNmMDRhMS4uYTEzM2MzZSAxMDA2NDQNCi0tLSBhL2ZzL3N0YXRmcy5jDQor
KysgYi9mcy9zdGF0ZnMuYw0KQEAgLTg2LDcgKzg2LDcgQEAgaW50IHVzZXJfc3RhdGZzKGNvbnN0
IGNoYXIgX191c2VyICpwYXRobmFtZSwgc3RydWN0IGtzdGF0ZnMgKnN0KQ0KIA0KIGludCBmZF9z
dGF0ZnMoaW50IGZkLCBzdHJ1Y3Qga3N0YXRmcyAqc3QpDQogew0KLQlzdHJ1Y3QgZmlsZSAqZmls
ZSA9IGZnZXQoZmQpOw0KKwlzdHJ1Y3QgZmlsZSAqZmlsZSA9IGZnZXRfcmF3KGZkKTsNCiAJaW50
IGVycm9yID0gLUVCQURGOw0KIAlpZiAoZmlsZSkgew0KIAkJZXJyb3IgPSB2ZnNfc3RhdGZzKCZm
aWxlLT5mX3BhdGgsIHN0KTsNCmRpZmYgLS1naXQgYS9pbmNsdWRlL2RybS9kcm1fbW9kZS5oIGIv
aW5jbHVkZS9kcm0vZHJtX21vZGUuaA0KaW5kZXggNzYzOWYxOC4uOGY0YWU2OCAxMDA2NDQNCi0t
LSBhL2luY2x1ZGUvZHJtL2RybV9tb2RlLmgNCisrKyBiL2luY2x1ZGUvZHJtL2RybV9tb2RlLmgN
CkBAIC0xODQsNiArMTg0LDggQEAgc3RydWN0IGRybV9tb2RlX2dldF9jb25uZWN0b3Igew0KIAlf
X3UzMiBjb25uZWN0aW9uOw0KIAlfX3UzMiBtbV93aWR0aCwgbW1faGVpZ2h0OyAvKio8IEh4VyBp
biBtaWxsaW1ldGVycyAqLw0KIAlfX3UzMiBzdWJwaXhlbDsNCisNCisJX191MzIgcGFkOw0KIH07
DQogDQogI2RlZmluZSBEUk1fTU9ERV9QUk9QX1BFTkRJTkcJKDE8PDApDQpkaWZmIC0tZ2l0IGEv
aW5jbHVkZS9saW51eC9jb21waWxlci1nY2MuaCBiL2luY2x1ZGUvbGludXgvY29tcGlsZXItZ2Nj
LmgNCmluZGV4IDNmZDE3YzIuLjU2MzMwNTMgMTAwNjQ0DQotLS0gYS9pbmNsdWRlL2xpbnV4L2Nv
bXBpbGVyLWdjYy5oDQorKysgYi9pbmNsdWRlL2xpbnV4L2NvbXBpbGVyLWdjYy5oDQpAQCAtNSw2
ICs1LDkgQEANCiAvKg0KICAqIENvbW1vbiBkZWZpbml0aW9ucyBmb3IgYWxsIGdjYyB2ZXJzaW9u
cyBnbyBoZXJlLg0KICAqLw0KKyNkZWZpbmUgR0NDX1ZFUlNJT04gKF9fR05VQ19fICogMTAwMDAg
XA0KKwkJICAgKyBfX0dOVUNfTUlOT1JfXyAqIDEwMCBcDQorCQkgICArIF9fR05VQ19QQVRDSExF
VkVMX18pDQogDQogDQogLyogT3B0aW1pemF0aW9uIGJhcnJpZXIgKi8NCmRpZmYgLS1naXQgYS9p
bmNsdWRlL2xpbnV4L2NvbXBpbGVyLWdjYzQuaCBiL2luY2x1ZGUvbGludXgvY29tcGlsZXItZ2Nj
NC5oDQppbmRleCBkZmFkYzk2Li42NDNkNmM0IDEwMDY0NA0KLS0tIGEvaW5jbHVkZS9saW51eC9j
b21waWxlci1nY2M0LmgNCisrKyBiL2luY2x1ZGUvbGludXgvY29tcGlsZXItZ2NjNC5oDQpAQCAt
MjksNiArMjksMjEgQEANCiAgICB0aGUga2VybmVsIGNvbnRleHQgKi8NCiAjZGVmaW5lIF9fY29s
ZAkJCV9fYXR0cmlidXRlX18oKF9fY29sZF9fKSkNCiANCisvKg0KKyAqIEdDQyAnYXNtIGdvdG8n
IG1pc2NvbXBpbGVzIGNlcnRhaW4gY29kZSBzZXF1ZW5jZXM6DQorICoNCisgKiAgIGh0dHA6Ly9n
Y2MuZ251Lm9yZy9idWd6aWxsYS9zaG93X2J1Zy5jZ2k/aWQ9NTg2NzANCisgKg0KKyAqIFdvcmsg
aXQgYXJvdW5kIHZpYSBhIGNvbXBpbGVyIGJhcnJpZXIgcXVpcmsgc3VnZ2VzdGVkIGJ5IEpha3Vi
IEplbGluZWsuDQorICogRml4ZWQgaW4gR0NDIDQuOC4yIGFuZCBsYXRlciB2ZXJzaW9ucy4NCisg
Kg0KKyAqIChhc20gZ290byBpcyBhdXRvbWF0aWNhbGx5IHZvbGF0aWxlIC0gdGhlIG5hbWluZyBy
ZWZsZWN0cyB0aGlzLikNCisgKi8NCisjaWYgR0NDX1ZFUlNJT04gPD0gNDA4MDENCisjIGRlZmlu
ZSBhc21fdm9sYXRpbGVfZ290byh4Li4uKQlkbyB7IGFzbSBnb3RvKHgpOyBhc20gKCIiKTsgfSB3
aGlsZSAoMCkNCisjZWxzZQ0KKyMgZGVmaW5lIGFzbV92b2xhdGlsZV9nb3RvKHguLi4pCWRvIHsg
YXNtIGdvdG8oeCk7IH0gd2hpbGUgKDApDQorI2VuZGlmDQogDQogI2lmIF9fR05VQ19NSU5PUl9f
ID49IDUNCiAvKg0KZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgvZXh0M19mcy5oIGIvaW5jbHVk
ZS9saW51eC9leHQzX2ZzLmgNCmluZGV4IGRlYzk5MTEuLmQ1OWFiMTIgMTAwNjQ0DQotLS0gYS9p
bmNsdWRlL2xpbnV4L2V4dDNfZnMuaA0KKysrIGIvaW5jbHVkZS9saW51eC9leHQzX2ZzLmgNCkBA
IC03ODEsNyArNzgxLDExIEBAIHN0cnVjdCBkeF9oYXNoX2luZm8NCiAJdTMyCQkqc2VlZDsNCiB9
Ow0KIA0KLSNkZWZpbmUgRVhUM19IVFJFRV9FT0YJMHg3ZmZmZmZmZg0KKw0KKy8qIDMyIGFuZCA2
NCBiaXQgc2lnbmVkIEVPRiBmb3IgZHggZGlyZWN0b3JpZXMgKi8NCisjZGVmaW5lIEVYVDNfSFRS
RUVfRU9GXzMyQklUICAgKCgxVUwgIDw8ICgzMiAtIDEpKSAtIDEpDQorI2RlZmluZSBFWFQzX0hU
UkVFX0VPRl82NEJJVCAgICgoMVVMTCA8PCAoNjQgLSAxKSkgLSAxKQ0KKw0KIA0KIC8qDQogICog
Q29udHJvbCBwYXJhbWV0ZXJzIHVzZWQgYnkgZXh0M19odHJlZV9uZXh0X2Jsb2NrDQpkaWZmIC0t
Z2l0IGEvaW5jbHVkZS9saW51eC9mcy5oIGIvaW5jbHVkZS9saW51eC9mcy5oDQppbmRleCBhMjc2
ODE3Li5kZDc0Mzg1IDEwMDY0NA0KLS0tIGEvaW5jbHVkZS9saW51eC9mcy5oDQorKysgYi9pbmNs
dWRlL2xpbnV4L2ZzLmgNCkBAIC05Miw2ICs5MiwxMCBAQCBzdHJ1Y3QgaW5vZGVzX3N0YXRfdCB7
DQogLyogRmlsZSBpcyBvcGVuZWQgdXNpbmcgb3BlbiguLiwgMywgLi4pIGFuZCBpcyB3cml0ZWFi
bGUgb25seSBmb3IgaW9jdGxzDQogICAgKHNwZWNpYWx5IGhhY2sgZm9yIGZsb3BweS5jKSAqLw0K
ICNkZWZpbmUgRk1PREVfV1JJVEVfSU9DVEwJKChfX2ZvcmNlIGZtb2RlX3QpMHgxMDApDQorLyog
MzJiaXQgaGFzaGVzIGFzIGxsc2VlaygpIG9mZnNldCAoZm9yIGRpcmVjdG9yaWVzKSAqLw0KKyNk
ZWZpbmUgRk1PREVfMzJCSVRIQVNIICAgICAgICAgKChfX2ZvcmNlIGZtb2RlX3QpMHgyMDApDQor
LyogNjRiaXQgaGFzaGVzIGFzIGxsc2VlaygpIG9mZnNldCAoZm9yIGRpcmVjdG9yaWVzKSAqLw0K
KyNkZWZpbmUgRk1PREVfNjRCSVRIQVNIICAgICAgICAgKChfX2ZvcmNlIGZtb2RlX3QpMHg0MDAp
DQogDQogLyoNCiAgKiBEb24ndCB1cGRhdGUgY3RpbWUgYW5kIG10aW1lLg0KQEAgLTkwNyw5ICs5
MTEsMTEgQEAgc3RhdGljIGlubGluZSBsb2ZmX3QgaV9zaXplX3JlYWQoY29uc3Qgc3RydWN0IGlu
b2RlICppbm9kZSkNCiBzdGF0aWMgaW5saW5lIHZvaWQgaV9zaXplX3dyaXRlKHN0cnVjdCBpbm9k
ZSAqaW5vZGUsIGxvZmZfdCBpX3NpemUpDQogew0KICNpZiBCSVRTX1BFUl9MT05HPT0zMiAmJiBk
ZWZpbmVkKENPTkZJR19TTVApDQorCXByZWVtcHRfZGlzYWJsZSgpOw0KIAl3cml0ZV9zZXFjb3Vu
dF9iZWdpbigmaW5vZGUtPmlfc2l6ZV9zZXFjb3VudCk7DQogCWlub2RlLT5pX3NpemUgPSBpX3Np
emU7DQogCXdyaXRlX3NlcWNvdW50X2VuZCgmaW5vZGUtPmlfc2l6ZV9zZXFjb3VudCk7DQorCXBy
ZWVtcHRfZW5hYmxlKCk7DQogI2VsaWYgQklUU19QRVJfTE9ORz09MzIgJiYgZGVmaW5lZChDT05G
SUdfUFJFRU1QVCkNCiAJcHJlZW1wdF9kaXNhYmxlKCk7DQogCWlub2RlLT5pX3NpemUgPSBpX3Np
emU7DQpkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC9wZXJmX2V2ZW50LmggYi9pbmNsdWRlL2xp
bnV4L3BlcmZfZXZlbnQuaA0KaW5kZXggZWViNmEyOS4uOGQ1YjkxZSAxMDA2NDQNCi0tLSBhL2lu
Y2x1ZGUvbGludXgvcGVyZl9ldmVudC5oDQorKysgYi9pbmNsdWRlL2xpbnV4L3BlcmZfZXZlbnQu
aA0KQEAgLTMwMCwxMyArMzAwLDE1IEBAIHN0cnVjdCBwZXJmX2V2ZW50X21tYXBfcGFnZSB7DQog
CS8qDQogCSAqIENvbnRyb2wgZGF0YSBmb3IgdGhlIG1tYXAoKSBkYXRhIGJ1ZmZlci4NCiAJICoN
Ci0JICogVXNlci1zcGFjZSByZWFkaW5nIHRoZSBAZGF0YV9oZWFkIHZhbHVlIHNob3VsZCBpc3N1
ZSBhbiBybWIoKSwgb24NCi0JICogU01QIGNhcGFibGUgcGxhdGZvcm1zLCBhZnRlciByZWFkaW5n
IHRoaXMgdmFsdWUgLS0gc2VlDQotCSAqIHBlcmZfZXZlbnRfd2FrZXVwKCkuDQorCSAqIFVzZXIt
c3BhY2UgcmVhZGluZyB0aGUgQGRhdGFfaGVhZCB2YWx1ZSBzaG91bGQgaXNzdWUgYW4gc21wX3Jt
YigpLA0KKwkgKiBhZnRlciByZWFkaW5nIHRoaXMgdmFsdWUuDQogCSAqDQogCSAqIFdoZW4gdGhl
IG1hcHBpbmcgaXMgUFJPVF9XUklURSB0aGUgQGRhdGFfdGFpbCB2YWx1ZSBzaG91bGQgYmUNCi0J
ICogd3JpdHRlbiBieSB1c2Vyc3BhY2UgdG8gcmVmbGVjdCB0aGUgbGFzdCByZWFkIGRhdGEuIElu
IHRoaXMgY2FzZQ0KLQkgKiB0aGUga2VybmVsIHdpbGwgbm90IG92ZXItd3JpdGUgdW5yZWFkIGRh
dGEuDQorCSAqIHdyaXR0ZW4gYnkgdXNlcnNwYWNlIHRvIHJlZmxlY3QgdGhlIGxhc3QgcmVhZCBk
YXRhLCBhZnRlciBpc3N1ZWluZw0KKwkgKiBhbiBzbXBfbWIoKSB0byBzZXBhcmF0ZSB0aGUgZGF0
YSByZWFkIGZyb20gdGhlIC0+ZGF0YV90YWlsIHN0b3JlLg0KKwkgKiBJbiB0aGlzIGNhc2UgdGhl
IGtlcm5lbCB3aWxsIG5vdCBvdmVyLXdyaXRlIHVucmVhZCBkYXRhLg0KKwkgKg0KKwkgKiBTZWUg
cGVyZl9vdXRwdXRfcHV0X2hhbmRsZSgpIGZvciB0aGUgZGF0YSBvcmRlcmluZy4NCiAJICovDQog
CV9fdTY0ICAgZGF0YV9oZWFkOwkJLyogaGVhZCBpbiB0aGUgZGF0YSBzZWN0aW9uICovDQogCV9f
dTY0CWRhdGFfdGFpbDsJCS8qIHVzZXItc3BhY2Ugd3JpdHRlbiB0YWlsICovDQpkaWZmIC0tZ2l0
IGEvaW5jbHVkZS9saW51eC9yYW5kb20uaCBiL2luY2x1ZGUvbGludXgvcmFuZG9tLmgNCmluZGV4
IDI5ZTIxN2EuLjdlNzdjZWUgMTAwNjQ0DQotLS0gYS9pbmNsdWRlL2xpbnV4L3JhbmRvbS5oDQor
KysgYi9pbmNsdWRlL2xpbnV4L3JhbmRvbS5oDQpAQCAtNTgsNiArNTgsNyBAQCBleHRlcm4gdm9p
ZCBhZGRfaW50ZXJydXB0X3JhbmRvbW5lc3MoaW50IGlycSwgaW50IGlycV9mbGFncyk7DQogZXh0
ZXJuIHZvaWQgZ2V0X3JhbmRvbV9ieXRlcyh2b2lkICpidWYsIGludCBuYnl0ZXMpOw0KIGV4dGVy
biB2b2lkIGdldF9yYW5kb21fYnl0ZXNfYXJjaCh2b2lkICpidWYsIGludCBuYnl0ZXMpOw0KIHZv
aWQgZ2VuZXJhdGVfcmFuZG9tX3V1aWQodW5zaWduZWQgY2hhciB1dWlkX291dFsxNl0pOw0KK2V4
dGVybiBpbnQgcmFuZG9tX2ludF9zZWNyZXRfaW5pdCh2b2lkKTsNCiANCiAjaWZuZGVmIE1PRFVM
RQ0KIGV4dGVybiBjb25zdCBzdHJ1Y3QgZmlsZV9vcGVyYXRpb25zIHJhbmRvbV9mb3BzLCB1cmFu
ZG9tX2ZvcHM7DQpkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC9za2J1ZmYuaCBiL2luY2x1ZGUv
bGludXgvc2tidWZmLmgNCmluZGV4IGVmZTUwYWYuLjg1MTgwYmYgMTAwNjQ0DQotLS0gYS9pbmNs
dWRlL2xpbnV4L3NrYnVmZi5oDQorKysgYi9pbmNsdWRlL2xpbnV4L3NrYnVmZi5oDQpAQCAtNzM3
LDYgKzczNywxNiBAQCBzdGF0aWMgaW5saW5lIGludCBza2JfY2xvbmVkKGNvbnN0IHN0cnVjdCBz
a19idWZmICpza2IpDQogCSAgICAgICAoYXRvbWljX3JlYWQoJnNrYl9zaGluZm8oc2tiKS0+ZGF0
YXJlZikgJiBTS0JfREFUQVJFRl9NQVNLKSAhPSAxOw0KIH0NCiANCitzdGF0aWMgaW5saW5lIGlu
dCBza2JfdW5jbG9uZShzdHJ1Y3Qgc2tfYnVmZiAqc2tiLCBnZnBfdCBwcmkpDQorew0KKwltaWdo
dF9zbGVlcF9pZihwcmkgJiBfX0dGUF9XQUlUKTsNCisNCisJaWYgKHNrYl9jbG9uZWQoc2tiKSkN
CisJCXJldHVybiBwc2tiX2V4cGFuZF9oZWFkKHNrYiwgMCwgMCwgcHJpKTsNCisNCisJcmV0dXJu
IDA7DQorfQ0KKw0KIC8qKg0KICAqCXNrYl9oZWFkZXJfY2xvbmVkIC0gaXMgdGhlIGhlYWRlciBh
IGNsb25lDQogICoJQHNrYjogYnVmZmVyIHRvIGNoZWNrDQpAQCAtMTE1Nyw2ICsxMTY3LDExIEBA
IHN0YXRpYyBpbmxpbmUgaW50IHNrYl9wYWdlbGVuKGNvbnN0IHN0cnVjdCBza19idWZmICpza2Ip
DQogCXJldHVybiBsZW4gKyBza2JfaGVhZGxlbihza2IpOw0KIH0NCiANCitzdGF0aWMgaW5saW5l
IGJvb2wgc2tiX2hhc19mcmFncyhjb25zdCBzdHJ1Y3Qgc2tfYnVmZiAqc2tiKQ0KK3sNCisJcmV0
dXJuIHNrYl9zaGluZm8oc2tiKS0+bnJfZnJhZ3M7DQorfQ0KKw0KIC8qKg0KICAqIF9fc2tiX2Zp
bGxfcGFnZV9kZXNjIC0gaW5pdGlhbGlzZSBhIHBhZ2VkIGZyYWdtZW50IGluIGFuIHNrYg0KICAq
IEBza2I6IGJ1ZmZlciBjb250YWluaW5nIGZyYWdtZW50IHRvIGJlIGluaXRpYWxpc2VkDQpkaWZm
IC0tZ2l0IGEvaW5jbHVkZS9saW51eC90aW1leC5oIGIvaW5jbHVkZS9saW51eC90aW1leC5oDQpp
bmRleCAwOGU5MGZiLi41ZmVlNTc1IDEwMDY0NA0KLS0tIGEvaW5jbHVkZS9saW51eC90aW1leC5o
DQorKysgYi9pbmNsdWRlL2xpbnV4L3RpbWV4LmgNCkBAIC0xNzMsNiArMTczLDIwIEBAIHN0cnVj
dCB0aW1leCB7DQogDQogI2luY2x1ZGUgPGFzbS90aW1leC5oPg0KIA0KKyNpZm5kZWYgcmFuZG9t
X2dldF9lbnRyb3B5DQorLyoNCisgKiBUaGUgcmFuZG9tX2dldF9lbnRyb3B5KCkgZnVuY3Rpb24g
aXMgdXNlZCBieSB0aGUgL2Rldi9yYW5kb20gZHJpdmVyDQorICogaW4gb3JkZXIgdG8gZXh0cmFj
dCBlbnRyb3B5IHZpYSB0aGUgcmVsYXRpdmUgdW5wcmVkaWN0YWJpbGl0eSBvZg0KKyAqIHdoZW4g
YW4gaW50ZXJydXB0IHRha2VzIHBsYWNlcyB2ZXJzdXMgYSBoaWdoIHNwZWVkLCBmaW5lLWdyYWlu
ZWQNCisgKiB0aW1pbmcgc291cmNlIG9yIGN5Y2xlIGNvdW50ZXIuICBTaW5jZSBpdCB3aWxsIGJl
IG9jY3VycmVkIG9uIGV2ZXJ5DQorICogc2luZ2xlIGludGVycnVwdCwgaXQgbXVzdCBoYXZlIGEg
dmVyeSBsb3cgY29zdC9vdmVyaGVhZC4NCisgKg0KKyAqIEJ5IGRlZmF1bHQgd2UgdXNlIGdldF9j
eWNsZXMoKSBmb3IgdGhpcyBwdXJwb3NlLCBidXQgaW5kaXZpZHVhbA0KKyAqIGFyY2hpdGVjdHVy
ZXMgbWF5IG92ZXJyaWRlIHRoaXMgaW4gdGhlaXIgYXNtL3RpbWV4LmggaGVhZGVyIGZpbGUuDQor
ICovDQorI2RlZmluZSByYW5kb21fZ2V0X2VudHJvcHkoKQlnZXRfY3ljbGVzKCkNCisjZW5kaWYN
CisNCiAvKg0KICAqIFNISUZUX1BMTCBpcyB1c2VkIGFzIGEgZGFtcGVuaW5nIGZhY3RvciB0byBk
ZWZpbmUgaG93IG11Y2ggd2UNCiAgKiBhZGp1c3QgdGhlIGZyZXF1ZW5jeSBjb3JyZWN0aW9uIGZv
ciBhIGdpdmVuIG9mZnNldCBpbiBQTEwgbW9kZS4NCmRpZmYgLS1naXQgYS9pbmNsdWRlL25ldC9j
aXBzb19pcHY0LmggYi9pbmNsdWRlL25ldC9jaXBzb19pcHY0LmgNCmluZGV4IGE3YTY4M2UuLmE4
YzJlZjYgMTAwNjQ0DQotLS0gYS9pbmNsdWRlL25ldC9jaXBzb19pcHY0LmgNCisrKyBiL2luY2x1
ZGUvbmV0L2NpcHNvX2lwdjQuaA0KQEAgLTI5MCw2ICsyOTAsNyBAQCBzdGF0aWMgaW5saW5lIGlu
dCBjaXBzb192NF92YWxpZGF0ZShjb25zdCBzdHJ1Y3Qgc2tfYnVmZiAqc2tiLA0KIAl1bnNpZ25l
ZCBjaGFyIGVycl9vZmZzZXQgPSAwOw0KIAl1OCBvcHRfbGVuID0gb3B0WzFdOw0KIAl1OCBvcHRf
aXRlcjsNCisJdTggdGFnX2xlbjsNCiANCiAJaWYgKG9wdF9sZW4gPCA4KSB7DQogCQllcnJfb2Zm
c2V0ID0gMTsNCkBAIC0zMDIsMTEgKzMwMywxMiBAQCBzdGF0aWMgaW5saW5lIGludCBjaXBzb192
NF92YWxpZGF0ZShjb25zdCBzdHJ1Y3Qgc2tfYnVmZiAqc2tiLA0KIAl9DQogDQogCWZvciAob3B0
X2l0ZXIgPSA2OyBvcHRfaXRlciA8IG9wdF9sZW47KSB7DQotCQlpZiAob3B0W29wdF9pdGVyICsg
MV0gPiAob3B0X2xlbiAtIG9wdF9pdGVyKSkgew0KKwkJdGFnX2xlbiA9IG9wdFtvcHRfaXRlciAr
IDFdOw0KKwkJaWYgKCh0YWdfbGVuID09IDApIHx8IChvcHRbb3B0X2l0ZXIgKyAxXSA+IChvcHRf
bGVuIC0gb3B0X2l0ZXIpKSkgew0KIAkJCWVycl9vZmZzZXQgPSBvcHRfaXRlciArIDE7DQogCQkJ
Z290byBvdXQ7DQogCQl9DQotCQlvcHRfaXRlciArPSBvcHRbb3B0X2l0ZXIgKyAxXTsNCisJCW9w
dF9pdGVyICs9IHRhZ19sZW47DQogCX0NCiANCiBvdXQ6DQpkaWZmIC0tZ2l0IGEvaW5jbHVkZS9u
ZXQvZHN0LmggYi9pbmNsdWRlL25ldC9kc3QuaA0KaW5kZXggMTYwMTBkMS4uODZlZjc4ZCAxMDA2
NDQNCi0tLSBhL2luY2x1ZGUvbmV0L2RzdC5oDQorKysgYi9pbmNsdWRlL25ldC9kc3QuaA0KQEAg
LTQ1OSwxMCArNDU5LDIyIEBAIHN0YXRpYyBpbmxpbmUgc3RydWN0IGRzdF9lbnRyeSAqeGZybV9s
b29rdXAoc3RydWN0IG5ldCAqbmV0LA0KIHsNCiAJcmV0dXJuIGRzdF9vcmlnOw0KIH0gDQorDQor
c3RhdGljIGlubGluZSBzdHJ1Y3QgeGZybV9zdGF0ZSAqZHN0X3hmcm0oY29uc3Qgc3RydWN0IGRz
dF9lbnRyeSAqZHN0KQ0KK3sNCisJcmV0dXJuIE5VTEw7DQorfQ0KKw0KICNlbHNlDQogZXh0ZXJu
IHN0cnVjdCBkc3RfZW50cnkgKnhmcm1fbG9va3VwKHN0cnVjdCBuZXQgKm5ldCwgc3RydWN0IGRz
dF9lbnRyeSAqZHN0X29yaWcsDQogCQkJCSAgICAgY29uc3Qgc3RydWN0IGZsb3dpICpmbCwgc3Ry
dWN0IHNvY2sgKnNrLA0KIAkJCQkgICAgIGludCBmbGFncyk7DQorDQorLyogc2tiIGF0dGFjaGVk
IHdpdGggdGhpcyBkc3QgbmVlZHMgdHJhbnNmb3JtYXRpb24gaWYgZHN0LT54ZnJtIGlzIHZhbGlk
ICovDQorc3RhdGljIGlubGluZSBzdHJ1Y3QgeGZybV9zdGF0ZSAqZHN0X3hmcm0oY29uc3Qgc3Ry
dWN0IGRzdF9lbnRyeSAqZHN0KQ0KK3sNCisJcmV0dXJuIGRzdC0+eGZybTsNCit9DQogI2VuZGlm
DQogDQogI2VuZGlmIC8qIF9ORVRfRFNUX0ggKi8NCmRpZmYgLS1naXQgYS9pbml0L21haW4uYyBi
L2luaXQvbWFpbi5jDQppbmRleCA1ZDBlYjFkLi43NDc0NDUwIDEwMDY0NA0KLS0tIGEvaW5pdC9t
YWluLmMNCisrKyBiL2luaXQvbWFpbi5jDQpAQCAtNjgsNiArNjgsNyBAQA0KICNpbmNsdWRlIDxs
aW51eC9zaG1lbV9mcy5oPg0KICNpbmNsdWRlIDxsaW51eC9zbGFiLmg+DQogI2luY2x1ZGUgPGxp
bnV4L3BlcmZfZXZlbnQuaD4NCisjaW5jbHVkZSA8bGludXgvcmFuZG9tLmg+DQogDQogI2luY2x1
ZGUgPGFzbS9pby5oPg0KICNpbmNsdWRlIDxhc20vYnVncy5oPg0KQEAgLTczMiw2ICs3MzMsNyBA
QCBzdGF0aWMgdm9pZCBfX2luaXQgZG9fYmFzaWNfc2V0dXAodm9pZCkNCiAJZG9fY3RvcnMoKTsN
CiAJdXNlcm1vZGVoZWxwZXJfZW5hYmxlKCk7DQogCWRvX2luaXRjYWxscygpOw0KKwlyYW5kb21f
aW50X3NlY3JldF9pbml0KCk7DQogfQ0KIA0KIHN0YXRpYyB2b2lkIF9faW5pdCBkb19wcmVfc21w
X2luaXRjYWxscyh2b2lkKQ0KZGlmZiAtLWdpdCBhL2tlcm5lbC9ldmVudHMvcmluZ19idWZmZXIu
YyBiL2tlcm5lbC9ldmVudHMvcmluZ19idWZmZXIuYw0KaW5kZXggN2YzMDExYy4uNThjM2I1MSAx
MDA2NDQNCi0tLSBhL2tlcm5lbC9ldmVudHMvcmluZ19idWZmZXIuYw0KKysrIGIva2VybmVsL2V2
ZW50cy9yaW5nX2J1ZmZlci5jDQpAQCAtNzUsMTAgKzc1LDMxIEBAIGFnYWluOg0KIAkJZ290byBv
dXQ7DQogDQogCS8qDQotCSAqIFB1Ymxpc2ggdGhlIGtub3duIGdvb2QgaGVhZC4gUmVseSBvbiB0
aGUgZnVsbCBiYXJyaWVyIGltcGxpZWQNCi0JICogYnkgYXRvbWljX2RlY19hbmRfdGVzdCgpIG9y
ZGVyIHRoZSByYi0+aGVhZCByZWFkIGFuZCB0aGlzDQotCSAqIHdyaXRlLg0KKwkgKiBTaW5jZSB0
aGUgbW1hcCgpIGNvbnN1bWVyICh1c2Vyc3BhY2UpIGNhbiBydW4gb24gYSBkaWZmZXJlbnQgQ1BV
Og0KKwkgKg0KKwkgKiAgIGtlcm5lbAkJCQl1c2VyDQorCSAqDQorCSAqICAgUkVBRCAtPmRhdGFf
dGFpbAkJCVJFQUQgLT5kYXRhX2hlYWQNCisJICogICBzbXBfbWIoKQkoQSkJCQlzbXBfcm1iKCkJ
KEMpDQorCSAqICAgV1JJVEUgJGRhdGEJCQlSRUFEICRkYXRhDQorCSAqICAgc21wX3dtYigpCShC
KQkJCXNtcF9tYigpCShEKQ0KKwkgKiAgIFNUT1JFIC0+ZGF0YV9oZWFkCQkJV1JJVEUgLT5kYXRh
X3RhaWwNCisJICoNCisJICogV2hlcmUgQSBwYWlycyB3aXRoIEQsIGFuZCBCIHBhaXJzIHdpdGgg
Qy4NCisJICoNCisJICogSSBkb24ndCB0aGluayBBIG5lZWRzIHRvIGJlIGEgZnVsbCBiYXJyaWVy
IGJlY2F1c2Ugd2Ugd29uJ3QgaW4gZmFjdA0KKwkgKiB3cml0ZSBkYXRhIHVudGlsIHdlIHNlZSB0
aGUgc3RvcmUgZnJvbSB1c2Vyc3BhY2UuIFNvIHdlIHNpbXBseSBkb24ndA0KKwkgKiBpc3N1ZSB0
aGUgZGF0YSBXUklURSB1bnRpbCB3ZSBvYnNlcnZlIGl0LiBCZSBjb25zZXJ2YXRpdmUgZm9yIG5v
dy4NCisJICoNCisJICogT1RPSCwgRCBuZWVkcyB0byBiZSBhIGZ1bGwgYmFycmllciBzaW5jZSBp
dCBzZXBhcmF0ZXMgdGhlIGRhdGEgUkVBRA0KKwkgKiBmcm9tIHRoZSB0YWlsIFdSSVRFLg0KKwkg
Kg0KKwkgKiBGb3IgQiBhIFdNQiBpcyBzdWZmaWNpZW50IHNpbmNlIGl0IHNlcGFyYXRlcyB0d28g
V1JJVEVzLCBhbmQgZm9yIEMNCisJICogYW4gUk1CIGlzIHN1ZmZpY2llbnQgc2luY2UgaXQgc2Vw
YXJhdGVzIHR3byBSRUFEcy4NCisJICoNCisJICogU2VlIHBlcmZfb3V0cHV0X2JlZ2luKCkuDQog
CSAqLw0KKwlzbXBfd21iKCk7DQogCXJiLT51c2VyX3BhZ2UtPmRhdGFfaGVhZCA9IGhlYWQ7DQog
DQogCS8qDQpAQCAtMTQyLDkgKzE2MywxMSBAQCBpbnQgcGVyZl9vdXRwdXRfYmVnaW4oc3RydWN0
IHBlcmZfb3V0cHV0X2hhbmRsZSAqaGFuZGxlLA0KIAkJICogVXNlcnNwYWNlIGNvdWxkIGNob29z
ZSB0byBpc3N1ZSBhIG1iKCkgYmVmb3JlIHVwZGF0aW5nIHRoZQ0KIAkJICogdGFpbCBwb2ludGVy
LiBTbyB0aGF0IGFsbCByZWFkcyB3aWxsIGJlIGNvbXBsZXRlZCBiZWZvcmUgdGhlDQogCQkgKiB3
cml0ZSBpcyBpc3N1ZWQuDQorCQkgKg0KKwkJICogU2VlIHBlcmZfb3V0cHV0X3B1dF9oYW5kbGUo
KS4NCiAJCSAqLw0KIAkJdGFpbCA9IEFDQ0VTU19PTkNFKHJiLT51c2VyX3BhZ2UtPmRhdGFfdGFp
bCk7DQotCQlzbXBfcm1iKCk7DQorCQlzbXBfbWIoKTsNCiAJCW9mZnNldCA9IGhlYWQgPSBsb2Nh
bF9yZWFkKCZyYi0+aGVhZCk7DQogCQloZWFkICs9IHNpemU7DQogCQlpZiAodW5saWtlbHkoIXBl
cmZfb3V0cHV0X3NwYWNlKHJiLCB0YWlsLCBvZmZzZXQsIGhlYWQpKSkNCmRpZmYgLS1naXQgYS9r
ZXJuZWwvdHJhY2UvdHJhY2UuYyBiL2tlcm5lbC90cmFjZS90cmFjZS5jDQppbmRleCBjZTEwNjdm
Li5jNWExMmE3IDEwMDY0NA0KLS0tIGEva2VybmVsL3RyYWNlL3RyYWNlLmMNCisrKyBiL2tlcm5l
bC90cmFjZS90cmFjZS5jDQpAQCAtNTM0LDkgKzUzNCwxMiBAQCBpbnQgdHJhY2VfZ2V0X3VzZXIo
c3RydWN0IHRyYWNlX3BhcnNlciAqcGFyc2VyLCBjb25zdCBjaGFyIF9fdXNlciAqdWJ1ZiwNCiAJ
aWYgKGlzc3BhY2UoY2gpKSB7DQogCQlwYXJzZXItPmJ1ZmZlcltwYXJzZXItPmlkeF0gPSAwOw0K
IAkJcGFyc2VyLT5jb250ID0gZmFsc2U7DQotCX0gZWxzZSB7DQorCX0gZWxzZSBpZiAocGFyc2Vy
LT5pZHggPCBwYXJzZXItPnNpemUgLSAxKSB7DQogCQlwYXJzZXItPmNvbnQgPSB0cnVlOw0KIAkJ
cGFyc2VyLT5idWZmZXJbcGFyc2VyLT5pZHgrK10gPSBjaDsNCisJfSBlbHNlIHsNCisJCXJldCA9
IC1FSU5WQUw7DQorCQlnb3RvIG91dDsNCiAJfQ0KIA0KIAkqcHBvcyArPSByZWFkOw0KZGlmZiAt
LWdpdCBhL2xpYi9zY2F0dGVybGlzdC5jIGIvbGliL3NjYXR0ZXJsaXN0LmMNCmluZGV4IDRjZWIw
NWQuLjJmZmNiM2MgMTAwNjQ0DQotLS0gYS9saWIvc2NhdHRlcmxpc3QuYw0KKysrIGIvbGliL3Nj
YXR0ZXJsaXN0LmMNCkBAIC00MTksNyArNDE5LDggQEAgdm9pZCBzZ19taXRlcl9zdG9wKHN0cnVj
dCBzZ19tYXBwaW5nX2l0ZXIgKm1pdGVyKQ0KIAlpZiAobWl0ZXItPmFkZHIpIHsNCiAJCW1pdGVy
LT5fX29mZnNldCArPSBtaXRlci0+Y29uc3VtZWQ7DQogDQotCQlpZiAobWl0ZXItPl9fZmxhZ3Mg
JiBTR19NSVRFUl9UT19TRykNCisJCWlmICgobWl0ZXItPl9fZmxhZ3MgJiBTR19NSVRFUl9UT19T
RykgJiYNCisJCSAgICAhUGFnZVNsYWIobWl0ZXItPnBhZ2UpKQ0KIAkJCWZsdXNoX2tlcm5lbF9k
Y2FjaGVfcGFnZShtaXRlci0+cGFnZSk7DQogDQogCQlpZiAobWl0ZXItPl9fZmxhZ3MgJiBTR19N
SVRFUl9BVE9NSUMpIHsNCmRpZmYgLS1naXQgYS9uZXQvODAyMXEvdmxhbl9uZXRsaW5rLmMgYi9u
ZXQvODAyMXEvdmxhbl9uZXRsaW5rLmMNCmluZGV4IDIzNWMyMTkuLmM3MDU2MTIgMTAwNjQ0DQot
LS0gYS9uZXQvODAyMXEvdmxhbl9uZXRsaW5rLmMNCisrKyBiL25ldC84MDIxcS92bGFuX25ldGxp
bmsuYw0KQEAgLTE1Miw3ICsxNTIsNyBAQCBzdGF0aWMgc2l6ZV90IHZsYW5fZ2V0X3NpemUoY29u
c3Qgc3RydWN0IG5ldF9kZXZpY2UgKmRldikNCiAJc3RydWN0IHZsYW5fZGV2X2luZm8gKnZsYW4g
PSB2bGFuX2Rldl9pbmZvKGRldik7DQogDQogCXJldHVybiBubGFfdG90YWxfc2l6ZSgyKSArCS8q
IElGTEFfVkxBTl9JRCAqLw0KLQkgICAgICAgc2l6ZW9mKHN0cnVjdCBpZmxhX3ZsYW5fZmxhZ3Mp
ICsgLyogSUZMQV9WTEFOX0ZMQUdTICovDQorCSAgICAgICBubGFfdG90YWxfc2l6ZShzaXplb2Yo
c3RydWN0IGlmbGFfdmxhbl9mbGFncykpICsgLyogSUZMQV9WTEFOX0ZMQUdTICovDQogCSAgICAg
ICB2bGFuX3Fvc19tYXBfc2l6ZSh2bGFuLT5ucl9pbmdyZXNzX21hcHBpbmdzKSArDQogCSAgICAg
ICB2bGFuX3Fvc19tYXBfc2l6ZSh2bGFuLT5ucl9lZ3Jlc3NfbWFwcGluZ3MpOw0KIH0NCmRpZmYg
LS1naXQgYS9uZXQvY29tcGF0LmMgYi9uZXQvY29tcGF0LmMNCmluZGV4IDhjOTc5Y2MuLjMxMzll
ZjIgMTAwNjQ0DQotLS0gYS9uZXQvY29tcGF0LmMNCisrKyBiL25ldC9jb21wYXQuYw0KQEAgLTcx
LDYgKzcxLDggQEAgaW50IGdldF9jb21wYXRfbXNnaGRyKHN0cnVjdCBtc2doZHIgKmttc2csIHN0
cnVjdCBjb21wYXRfbXNnaGRyIF9fdXNlciAqdW1zZykNCiAJICAgIF9fZ2V0X3VzZXIoa21zZy0+
bXNnX2NvbnRyb2xsZW4sICZ1bXNnLT5tc2dfY29udHJvbGxlbikgfHwNCiAJICAgIF9fZ2V0X3Vz
ZXIoa21zZy0+bXNnX2ZsYWdzLCAmdW1zZy0+bXNnX2ZsYWdzKSkNCiAJCXJldHVybiAtRUZBVUxU
Ow0KKwlpZiAoa21zZy0+bXNnX25hbWVsZW4gPiBzaXplb2Yoc3RydWN0IHNvY2thZGRyX3N0b3Jh
Z2UpKQ0KKwkJcmV0dXJuIC1FSU5WQUw7DQogCWttc2ctPm1zZ19uYW1lID0gY29tcGF0X3B0cih0
bXAxKTsNCiAJa21zZy0+bXNnX2lvdiA9IGNvbXBhdF9wdHIodG1wMik7DQogCWttc2ctPm1zZ19j
b250cm9sID0gY29tcGF0X3B0cih0bXAzKTsNCmRpZmYgLS1naXQgYS9uZXQvaXB2NC9pbmV0X2hh
c2h0YWJsZXMuYyBiL25ldC9pcHY0L2luZXRfaGFzaHRhYmxlcy5jDQppbmRleCA5ODRlYzY1Li40
YWZjZjMxIDEwMDY0NA0KLS0tIGEvbmV0L2lwdjQvaW5ldF9oYXNodGFibGVzLmMNCisrKyBiL25l
dC9pcHY0L2luZXRfaGFzaHRhYmxlcy5jDQpAQCAtMjY4LDcgKzI2OCw3IEBAIGJlZ2ludHc6DQog
CQkJfQ0KIAkJCWlmICh1bmxpa2VseSghSU5FVF9UV19NQVRDSChzaywgbmV0LCBoYXNoLCBhY29v
a2llLA0KIAkJCQkgc2FkZHIsIGRhZGRyLCBwb3J0cywgZGlmKSkpIHsNCi0JCQkJc29ja19wdXQo
c2spOw0KKwkJCQlpbmV0X3R3c2tfcHV0KGluZXRfdHdzayhzaykpOw0KIAkJCQlnb3RvIGJlZ2lu
dHc7DQogCQkJfQ0KIAkJCWdvdG8gb3V0Ow0KZGlmZiAtLWdpdCBhL25ldC9pcHY0L2lwX291dHB1
dC5jIGIvbmV0L2lwdjQvaXBfb3V0cHV0LmMNCmluZGV4IGRhZjQwOGUuLjE2MTkxZjAgMTAwNjQ0
DQotLS0gYS9uZXQvaXB2NC9pcF9vdXRwdXQuYw0KKysrIGIvbmV0L2lwdjQvaXBfb3V0cHV0LmMN
CkBAIC04MzMsNyArODMzLDcgQEAgc3RhdGljIGludCBfX2lwX2FwcGVuZF9kYXRhKHN0cnVjdCBz
b2NrICpzaywNCiAJCWNzdW1tb2RlID0gQ0hFQ0tTVU1fUEFSVElBTDsNCiANCiAJY29yay0+bGVu
Z3RoICs9IGxlbmd0aDsNCi0JaWYgKCgobGVuZ3RoID4gbXR1KSB8fCAoc2tiICYmIHNrYl9pc19n
c28oc2tiKSkpICYmDQorCWlmICgoKGxlbmd0aCA+IG10dSkgfHwgKHNrYiAmJiBza2JfaGFzX2Zy
YWdzKHNrYikpKSAmJg0KIAkgICAgKHNrLT5za19wcm90b2NvbCA9PSBJUFBST1RPX1VEUCkgJiYN
CiAJICAgIChydC0+ZHN0LmRldi0+ZmVhdHVyZXMgJiBORVRJRl9GX1VGTykgJiYgIXJ0LT5kc3Qu
aGVhZGVyX2xlbikgew0KIAkJZXJyID0gaXBfdWZvX2FwcGVuZF9kYXRhKHNrLCBxdWV1ZSwgZ2V0
ZnJhZywgZnJvbSwgbGVuZ3RoLA0KZGlmZiAtLWdpdCBhL25ldC9pcHY0L3JvdXRlLmMgYi9uZXQv
aXB2NC9yb3V0ZS5jDQppbmRleCBjNDVhMTU1YTMuLjY3NjhjZTIgMTAwNjQ0DQotLS0gYS9uZXQv
aXB2NC9yb3V0ZS5jDQorKysgYi9uZXQvaXB2NC9yb3V0ZS5jDQpAQCAtMjcyNyw3ICsyNzI3LDcg
QEAgc3RhdGljIHN0cnVjdCBydGFibGUgKmlwX3JvdXRlX291dHB1dF9zbG93KHN0cnVjdCBuZXQg
Km5ldCwgc3RydWN0IGZsb3dpNCAqZmw0KQ0KIAkJCQkJCQkgICAgICBSVF9TQ09QRV9MSU5LKTsN
CiAJCQlnb3RvIG1ha2Vfcm91dGU7DQogCQl9DQotCQlpZiAoZmw0LT5zYWRkcikgew0KKwkJaWYg
KCFmbDQtPnNhZGRyKSB7DQogCQkJaWYgKGlwdjRfaXNfbXVsdGljYXN0KGZsNC0+ZGFkZHIpKQ0K
IAkJCQlmbDQtPnNhZGRyID0gaW5ldF9zZWxlY3RfYWRkcihkZXZfb3V0LCAwLA0KIAkJCQkJCQkg
ICAgICBmbDQtPmZsb3dpNF9zY29wZSk7DQpkaWZmIC0tZ2l0IGEvbmV0L2lwdjQvdGNwX2lucHV0
LmMgYi9uZXQvaXB2NC90Y3BfaW5wdXQuYw0KaW5kZXggODcyYjQxZC4uYzFlZDAxZSAxMDA2NDQN
Ci0tLSBhL25ldC9pcHY0L3RjcF9pbnB1dC5jDQorKysgYi9uZXQvaXB2NC90Y3BfaW5wdXQuYw0K
QEAgLTE0NjksNyArMTQ2OSwxMCBAQCBzdGF0aWMgaW50IHRjcF9zaGlmdGVkX3NrYihzdHJ1Y3Qg
c29jayAqc2ssIHN0cnVjdCBza19idWZmICpza2IsDQogCQl0cC0+bG9zdF9jbnRfaGludCAtPSB0
Y3Bfc2tiX3Bjb3VudChwcmV2KTsNCiAJfQ0KIA0KLQlUQ1BfU0tCX0NCKHNrYiktPnRjcF9mbGFn
cyB8PSBUQ1BfU0tCX0NCKHByZXYpLT50Y3BfZmxhZ3M7DQorCVRDUF9TS0JfQ0IocHJldiktPnRj
cF9mbGFncyB8PSBUQ1BfU0tCX0NCKHNrYiktPnRjcF9mbGFnczsNCisJaWYgKFRDUF9TS0JfQ0Io
c2tiKS0+dGNwX2ZsYWdzICYgVENQSERSX0ZJTikNCisJCVRDUF9TS0JfQ0IocHJldiktPmVuZF9z
ZXErKzsNCisNCiAJaWYgKHNrYiA9PSB0Y3BfaGlnaGVzdF9zYWNrKHNrKSkNCiAJCXRjcF9hZHZh
bmNlX2hpZ2hlc3Rfc2Fjayhzaywgc2tiKTsNCiANCmRpZmYgLS1naXQgYS9uZXQvaXB2NC90Y3Bf
b3V0cHV0LmMgYi9uZXQvaXB2NC90Y3Bfb3V0cHV0LmMNCmluZGV4IDNhZGQ0ODYuLjBkNWExMTgg
MTAwNjQ0DQotLS0gYS9uZXQvaXB2NC90Y3Bfb3V0cHV0LmMNCisrKyBiL25ldC9pcHY0L3RjcF9v
dXRwdXQuYw0KQEAgLTkzMyw2ICs5MzMsOSBAQCBzdGF0aWMgdm9pZCB0Y3BfcXVldWVfc2tiKHN0
cnVjdCBzb2NrICpzaywgc3RydWN0IHNrX2J1ZmYgKnNrYikNCiBzdGF0aWMgdm9pZCB0Y3Bfc2V0
X3NrYl90c29fc2Vncyhjb25zdCBzdHJ1Y3Qgc29jayAqc2ssIHN0cnVjdCBza19idWZmICpza2Is
DQogCQkJCSB1bnNpZ25lZCBpbnQgbXNzX25vdykNCiB7DQorCS8qIE1ha2Ugc3VyZSB3ZSBvd24g
dGhpcyBza2IgYmVmb3JlIG1lc3NpbmcgZ3NvX3NpemUvZ3NvX3NlZ3MgKi8NCisJV0FSTl9PTl9P
TkNFKHNrYl9jbG9uZWQoc2tiKSk7DQorDQogCWlmIChza2ItPmxlbiA8PSBtc3Nfbm93IHx8ICFz
a19jYW5fZ3NvKHNrKSB8fA0KIAkgICAgc2tiLT5pcF9zdW1tZWQgPT0gQ0hFQ0tTVU1fTk9ORSkg
ew0KIAkJLyogQXZvaWQgdGhlIGNvc3RseSBkaXZpZGUgaW4gdGhlIG5vcm1hbA0KQEAgLTEwMTQs
OSArMTAxNyw3IEBAIGludCB0Y3BfZnJhZ21lbnQoc3RydWN0IHNvY2sgKnNrLCBzdHJ1Y3Qgc2tf
YnVmZiAqc2tiLCB1MzIgbGVuLA0KIAlpZiAobnNpemUgPCAwKQ0KIAkJbnNpemUgPSAwOw0KIA0K
LQlpZiAoc2tiX2Nsb25lZChza2IpICYmDQotCSAgICBza2JfaXNfbm9ubGluZWFyKHNrYikgJiYN
Ci0JICAgIHBza2JfZXhwYW5kX2hlYWQoc2tiLCAwLCAwLCBHRlBfQVRPTUlDKSkNCisJaWYgKHNr
Yl91bmNsb25lKHNrYiwgR0ZQX0FUT01JQykpDQogCQlyZXR1cm4gLUVOT01FTTsNCiANCiAJLyog
R2V0IGEgbmV3IHNrYi4uLiBmb3JjZSBmbGFnIG9uLiAqLw0KQEAgLTIxMjksNiArMjEzMCw4IEBA
IGludCB0Y3BfcmV0cmFuc21pdF9za2Ioc3RydWN0IHNvY2sgKnNrLCBzdHJ1Y3Qgc2tfYnVmZiAq
c2tiKQ0KIAkJaW50IG9sZHBjb3VudCA9IHRjcF9za2JfcGNvdW50KHNrYik7DQogDQogCQlpZiAo
dW5saWtlbHkob2xkcGNvdW50ID4gMSkpIHsNCisJCQlpZiAoc2tiX3VuY2xvbmUoc2tiLCBHRlBf
QVRPTUlDKSkNCisJCQkJcmV0dXJuIC1FTk9NRU07DQogCQkJdGNwX2luaXRfdHNvX3NlZ3Moc2ss
IHNrYiwgY3VyX21zcyk7DQogCQkJdGNwX2FkanVzdF9wY291bnQoc2ssIHNrYiwgb2xkcGNvdW50
IC0gdGNwX3NrYl9wY291bnQoc2tiKSk7DQogCQl9DQpkaWZmIC0tZ2l0IGEvbmV0L2lwdjYvaW5l
dDZfaGFzaHRhYmxlcy5jIGIvbmV0L2lwdjYvaW5ldDZfaGFzaHRhYmxlcy5jDQppbmRleCA3M2Yx
YTAwLi5lMzgyOTBiIDEwMDY0NA0KLS0tIGEvbmV0L2lwdjYvaW5ldDZfaGFzaHRhYmxlcy5jDQor
KysgYi9uZXQvaXB2Ni9pbmV0Nl9oYXNodGFibGVzLmMNCkBAIC0xMTAsNyArMTEwLDcgQEAgYmVn
aW50dzoNCiAJCQkJZ290byBvdXQ7DQogCQkJfQ0KIAkJCWlmICghSU5FVDZfVFdfTUFUQ0goc2ss
IG5ldCwgaGFzaCwgc2FkZHIsIGRhZGRyLCBwb3J0cywgZGlmKSkgew0KLQkJCQlzb2NrX3B1dChz
ayk7DQorCQkJCWluZXRfdHdza19wdXQoaW5ldF90d3NrKHNrKSk7DQogCQkJCWdvdG8gYmVnaW50
dzsNCiAJCQl9DQogCQkJZ290byBvdXQ7DQpkaWZmIC0tZ2l0IGEvbmV0L2lwdjYvaXA2X291dHB1
dC5jIGIvbmV0L2lwdjYvaXA2X291dHB1dC5jDQppbmRleCA5MWQwNzExLi45NzY3NWJmIDEwMDY0
NA0KLS0tIGEvbmV0L2lwdjYvaXA2X291dHB1dC5jDQorKysgYi9uZXQvaXB2Ni9pcDZfb3V0cHV0
LmMNCkBAIC0xMzQyLDcgKzEzNDIsNyBAQCBpbnQgaXA2X2FwcGVuZF9kYXRhKHN0cnVjdCBzb2Nr
ICpzaywgaW50IGdldGZyYWcodm9pZCAqZnJvbSwgY2hhciAqdG8sDQogCXNrYiA9IHNrYl9wZWVr
X3RhaWwoJnNrLT5za193cml0ZV9xdWV1ZSk7DQogCWNvcmstPmxlbmd0aCArPSBsZW5ndGg7DQog
CWlmICgoKGxlbmd0aCA+IG10dSkgfHwNCi0JICAgICAoc2tiICYmIHNrYl9pc19nc28oc2tiKSkp
ICYmDQorCSAgICAgKHNrYiAmJiBza2JfaGFzX2ZyYWdzKHNrYikpKSAmJg0KIAkgICAgKHNrLT5z
a19wcm90b2NvbCA9PSBJUFBST1RPX1VEUCkgJiYNCiAJICAgIChydC0+ZHN0LmRldi0+ZmVhdHVy
ZXMgJiBORVRJRl9GX1VGTykpIHsNCiAJCWVyciA9IGlwNl91Zm9fYXBwZW5kX2RhdGEoc2ssIGdl
dGZyYWcsIGZyb20sIGxlbmd0aCwNCmRpZmYgLS1naXQgYS9uZXQvaXB2Ni9yb3V0ZS5jIGIvbmV0
L2lwdjYvcm91dGUuYw0KaW5kZXggMThlYTczYy4uYmM5MTAzZCAxMDA2NDQNCi0tLSBhL25ldC9p
cHY2L3JvdXRlLmMNCisrKyBiL25ldC9pcHY2L3JvdXRlLmMNCkBAIC03OTEsNyArNzkxLDcgQEAg
c3RhdGljIHN0cnVjdCBydDZfaW5mbyAqcnQ2X2FsbG9jX2Nsb25lKHN0cnVjdCBydDZfaW5mbyAq
b3J0LA0KIH0NCiANCiBzdGF0aWMgc3RydWN0IHJ0Nl9pbmZvICppcDZfcG9sX3JvdXRlKHN0cnVj
dCBuZXQgKm5ldCwgc3RydWN0IGZpYjZfdGFibGUgKnRhYmxlLCBpbnQgb2lmLA0KLQkJCQkgICAg
ICBzdHJ1Y3QgZmxvd2k2ICpmbDYsIGludCBmbGFncykNCisJCQkJICAgICAgc3RydWN0IGZsb3dp
NiAqZmw2LCBpbnQgZmxhZ3MsIGJvb2wgaW5wdXQpDQogew0KIAlzdHJ1Y3QgZmliNl9ub2RlICpm
bjsNCiAJc3RydWN0IHJ0Nl9pbmZvICpydCwgKm5ydDsNCkBAIC03OTksOCArNzk5LDExIEBAIHN0
YXRpYyBzdHJ1Y3QgcnQ2X2luZm8gKmlwNl9wb2xfcm91dGUoc3RydWN0IG5ldCAqbmV0LCBzdHJ1
Y3QgZmliNl90YWJsZSAqdGFibGUsDQogCWludCBhdHRlbXB0cyA9IDM7DQogCWludCBlcnI7DQog
CWludCByZWFjaGFibGUgPSBuZXQtPmlwdjYuZGV2Y29uZl9hbGwtPmZvcndhcmRpbmcgPyAwIDog
UlQ2X0xPT0tVUF9GX1JFQUNIQUJMRTsNCisJaW50IGxvY2FsID0gUlRGX05PTkVYVEhPUDsNCiAN
CiAJc3RyaWN0IHw9IGZsYWdzICYgUlQ2X0xPT0tVUF9GX0lGQUNFOw0KKwlpZiAoaW5wdXQpDQor
CQlsb2NhbCB8PSBSVEZfTE9DQUw7DQogDQogcmVsb29rdXA6DQogCXJlYWRfbG9ja19iaCgmdGFi
bGUtPnRiNl9sb2NrKTsNCkBAIC04MjAsNyArODIzLDcgQEAgcmVzdGFydDoNCiAJcmVhZF91bmxv
Y2tfYmgoJnRhYmxlLT50YjZfbG9jayk7DQogDQogCWlmICghZHN0X2dldF9uZWlnaGJvdXJfcmF3
KCZydC0+ZHN0KQ0KLQkgICAgJiYgIShydC0+cnQ2aV9mbGFncyAmIChSVEZfTk9ORVhUSE9QIHwg
UlRGX0xPQ0FMKSkpDQorCSAgICAmJiAhKHJ0LT5ydDZpX2ZsYWdzICYgbG9jYWwpKQ0KIAkJbnJ0
ID0gcnQ2X2FsbG9jX2NvdyhydCwgJmZsNi0+ZGFkZHIsICZmbDYtPnNhZGRyKTsNCiAJZWxzZSBp
ZiAoIShydC0+ZHN0LmZsYWdzICYgRFNUX0hPU1QpKQ0KIAkJbnJ0ID0gcnQ2X2FsbG9jX2Nsb25l
KHJ0LCAmZmw2LT5kYWRkcik7DQpAQCAtODY0LDcgKzg2Nyw3IEBAIG91dDI6DQogc3RhdGljIHN0
cnVjdCBydDZfaW5mbyAqaXA2X3BvbF9yb3V0ZV9pbnB1dChzdHJ1Y3QgbmV0ICpuZXQsIHN0cnVj
dCBmaWI2X3RhYmxlICp0YWJsZSwNCiAJCQkJCSAgICBzdHJ1Y3QgZmxvd2k2ICpmbDYsIGludCBm
bGFncykNCiB7DQotCXJldHVybiBpcDZfcG9sX3JvdXRlKG5ldCwgdGFibGUsIGZsNi0+Zmxvd2k2
X2lpZiwgZmw2LCBmbGFncyk7DQorCXJldHVybiBpcDZfcG9sX3JvdXRlKG5ldCwgdGFibGUsIGZs
Ni0+Zmxvd2k2X2lpZiwgZmw2LCBmbGFncywgdHJ1ZSk7DQogfQ0KIA0KIHZvaWQgaXA2X3JvdXRl
X2lucHV0KHN0cnVjdCBza19idWZmICpza2IpDQpAQCAtODkwLDcgKzg5Myw3IEBAIHZvaWQgaXA2
X3JvdXRlX2lucHV0KHN0cnVjdCBza19idWZmICpza2IpDQogc3RhdGljIHN0cnVjdCBydDZfaW5m
byAqaXA2X3BvbF9yb3V0ZV9vdXRwdXQoc3RydWN0IG5ldCAqbmV0LCBzdHJ1Y3QgZmliNl90YWJs
ZSAqdGFibGUsDQogCQkJCQkgICAgIHN0cnVjdCBmbG93aTYgKmZsNiwgaW50IGZsYWdzKQ0KIHsN
Ci0JcmV0dXJuIGlwNl9wb2xfcm91dGUobmV0LCB0YWJsZSwgZmw2LT5mbG93aTZfb2lmLCBmbDYs
IGZsYWdzKTsNCisJcmV0dXJuIGlwNl9wb2xfcm91dGUobmV0LCB0YWJsZSwgZmw2LT5mbG93aTZf
b2lmLCBmbDYsIGZsYWdzLCBmYWxzZSk7DQogfQ0KIA0KIHN0cnVjdCBkc3RfZW50cnkgKiBpcDZf
cm91dGVfb3V0cHV0KHN0cnVjdCBuZXQgKm5ldCwgY29uc3Qgc3RydWN0IHNvY2sgKnNrLA0KZGlm
ZiAtLWdpdCBhL25ldC9sMnRwL2wydHBfcHBwLmMgYi9uZXQvbDJ0cC9sMnRwX3BwcC5jDQppbmRl
eCBlNTc5MDA2Li44NTcwMDc5IDEwMDY0NA0KLS0tIGEvbmV0L2wydHAvbDJ0cF9wcHAuYw0KKysr
IGIvbmV0L2wydHAvbDJ0cF9wcHAuYw0KQEAgLTM1Nyw3ICszNTcsOSBAQCBzdGF0aWMgaW50IHBw
cG9sMnRwX3NlbmRtc2coc3RydWN0IGtpb2NiICppb2NiLCBzdHJ1Y3Qgc29ja2V0ICpzb2NrLCBz
dHJ1Y3QgbXNnaA0KIAkJZ290byBlcnJvcl9wdXRfc2Vzc190dW47DQogCX0NCiANCisJbG9jYWxf
YmhfZGlzYWJsZSgpOw0KIAlsMnRwX3htaXRfc2tiKHNlc3Npb24sIHNrYiwgc2Vzc2lvbi0+aGRy
X2xlbik7DQorCWxvY2FsX2JoX2VuYWJsZSgpOw0KIA0KIAlzb2NrX3B1dChwcy0+dHVubmVsX3Nv
Y2spOw0KIAlzb2NrX3B1dChzayk7DQpAQCAtNDMyLDcgKzQzNCw5IEBAIHN0YXRpYyBpbnQgcHBw
b2wydHBfeG1pdChzdHJ1Y3QgcHBwX2NoYW5uZWwgKmNoYW4sIHN0cnVjdCBza19idWZmICpza2Ip
DQogCXNrYi0+ZGF0YVswXSA9IHBwcGhbMF07DQogCXNrYi0+ZGF0YVsxXSA9IHBwcGhbMV07DQog
DQorCWxvY2FsX2JoX2Rpc2FibGUoKTsNCiAJbDJ0cF94bWl0X3NrYihzZXNzaW9uLCBza2IsIHNl
c3Npb24tPmhkcl9sZW4pOw0KKwlsb2NhbF9iaF9lbmFibGUoKTsNCiANCiAJc29ja19wdXQoc2tf
dHVuKTsNCiAJc29ja19wdXQoc2spOw0KZGlmZiAtLWdpdCBhL25ldC9tYWM4MDIxMS9pZWVlODAy
MTFfaS5oIGIvbmV0L21hYzgwMjExL2llZWU4MDIxMV9pLmgNCmluZGV4IDczNDk1ZjEuLmE5Y2Y1
OTMgMTAwNjQ0DQotLS0gYS9uZXQvbWFjODAyMTEvaWVlZTgwMjExX2kuaA0KKysrIGIvbmV0L21h
YzgwMjExL2llZWU4MDIxMV9pLmgNCkBAIC03MDgsNiArNzA4LDggQEAgc3RydWN0IHRwdF9sZWRf
dHJpZ2dlciB7DQogICoJdGhhdCB0aGUgc2NhbiBjb21wbGV0ZWQuDQogICogQFNDQU5fQUJPUlRF
RDogU2V0IGZvciBvdXIgc2NhbiB3b3JrIGZ1bmN0aW9uIHdoZW4gdGhlIGRyaXZlciByZXBvcnRl
ZA0KICAqCWEgc2NhbiBjb21wbGV0ZSBmb3IgYW4gYWJvcnRlZCBzY2FuLg0KKyAqIEBTQ0FOX0hX
X0NBTkNFTExFRDogU2V0IGZvciBvdXIgc2NhbiB3b3JrIGZ1bmN0aW9uIHdoZW4gdGhlIHNjYW4g
aXMgYmVpbmcNCisgKgljYW5jZWxsZWQuDQogICovDQogZW51bSB7DQogCVNDQU5fU1dfU0NBTk5J
TkcsDQpAQCAtNzE1LDYgKzcxNyw3IEBAIGVudW0gew0KIAlTQ0FOX09GRl9DSEFOTkVMLA0KIAlT
Q0FOX0NPTVBMRVRFRCwNCiAJU0NBTl9BQk9SVEVELA0KKwlTQ0FOX0hXX0NBTkNFTExFRCwNCiB9
Ow0KIA0KIC8qKg0KZGlmZiAtLWdpdCBhL25ldC9tYWM4MDIxMS9yeC5jIGIvbmV0L21hYzgwMjEx
L3J4LmMNCmluZGV4IDdkODgyZmMuLmRiMDFkMDIgMTAwNjQ0DQotLS0gYS9uZXQvbWFjODAyMTEv
cnguYw0KKysrIGIvbmV0L21hYzgwMjExL3J4LmMNCkBAIC0yNzgwLDYgKzI3ODAsOSBAQCBzdGF0
aWMgaW50IHByZXBhcmVfZm9yX2hhbmRsZXJzKHN0cnVjdCBpZWVlODAyMTFfcnhfZGF0YSAqcngs
DQogCWNhc2UgTkw4MDIxMV9JRlRZUEVfQURIT0M6DQogCQlpZiAoIWJzc2lkKQ0KIAkJCXJldHVy
biAwOw0KKwkJaWYgKGNvbXBhcmVfZXRoZXJfYWRkcihzZGF0YS0+dmlmLmFkZHIsIGhkci0+YWRk
cjIpID09IDAgfHwNCisJCSAgICBjb21wYXJlX2V0aGVyX2FkZHIoc2RhdGEtPnUuaWJzcy5ic3Np
ZCwgaGRyLT5hZGRyMikgPT0gMCkNCisJCQlyZXR1cm4gMDsNCiAJCWlmIChpZWVlODAyMTFfaXNf
YmVhY29uKGhkci0+ZnJhbWVfY29udHJvbCkpIHsNCiAJCQlyZXR1cm4gMTsNCiAJCX0NCmRpZmYg
LS1naXQgYS9uZXQvbWFjODAyMTEvc2Nhbi5jIGIvbmV0L21hYzgwMjExL3NjYW4uYw0KaW5kZXgg
NTI3OTMwMC4uMGFlZWE0OSAxMDA2NDQNCi0tLSBhL25ldC9tYWM4MDIxMS9zY2FuLmMNCisrKyBi
L25ldC9tYWM4MDIxMS9zY2FuLmMNCkBAIC0yMjQsNiArMjI0LDkgQEAgc3RhdGljIGJvb2wgaWVl
ZTgwMjExX3ByZXBfaHdfc2NhbihzdHJ1Y3QgaWVlZTgwMjExX2xvY2FsICpsb2NhbCkNCiAJZW51
bSBpZWVlODAyMTFfYmFuZCBiYW5kOw0KIAlpbnQgaSwgaWVsZW4sIG5fY2hhbnM7DQogDQorCWlm
ICh0ZXN0X2JpdChTQ0FOX0hXX0NBTkNFTExFRCwgJmxvY2FsLT5zY2FubmluZykpDQorCQlyZXR1
cm4gZmFsc2U7DQorDQogCWRvIHsNCiAJCWlmIChsb2NhbC0+aHdfc2Nhbl9iYW5kID09IElFRUU4
MDIxMV9OVU1fQkFORFMpDQogCQkJcmV0dXJuIGZhbHNlOw0KQEAgLTgxNSw3ICs4MTgsMjMgQEAg
dm9pZCBpZWVlODAyMTFfc2Nhbl9jYW5jZWwoc3RydWN0IGllZWU4MDIxMV9sb2NhbCAqbG9jYWwp
DQogCWlmICghbG9jYWwtPnNjYW5fcmVxKQ0KIAkJZ290byBvdXQ7DQogDQorCS8qDQorCSAqIFdl
IGhhdmUgYSBzY2FuIHJ1bm5pbmcgYW5kIHRoZSBkcml2ZXIgYWxyZWFkeSByZXBvcnRlZCBjb21w
bGV0aW9uLA0KKwkgKiBidXQgdGhlIHdvcmtlciBoYXNuJ3QgcnVuIHlldCBvciBpcyBzdHVjayBv
biB0aGUgbXV0ZXggLSBtYXJrIGl0IGFzDQorCSAqIGNhbmNlbGxlZC4NCisJICovDQorCWlmICh0
ZXN0X2JpdChTQ0FOX0hXX1NDQU5OSU5HLCAmbG9jYWwtPnNjYW5uaW5nKSAmJg0KKwkgICAgdGVz
dF9iaXQoU0NBTl9DT01QTEVURUQsICZsb2NhbC0+c2Nhbm5pbmcpKSB7DQorCQlzZXRfYml0KFND
QU5fSFdfQ0FOQ0VMTEVELCAmbG9jYWwtPnNjYW5uaW5nKTsNCisJCWdvdG8gb3V0Ow0KKwl9DQor
DQogCWlmICh0ZXN0X2JpdChTQ0FOX0hXX1NDQU5OSU5HLCAmbG9jYWwtPnNjYW5uaW5nKSkgew0K
KwkJLyoNCisJCSAqIE1ha2Ugc3VyZSB0aGF0IF9faWVlZTgwMjExX3NjYW5fY29tcGxldGVkIGRv
ZXNuJ3QgdHJpZ2dlciBhDQorCQkgKiBzY2FuIG9uIGFub3RoZXIgYmFuZC4NCisJCSAqLw0KKwkJ
c2V0X2JpdChTQ0FOX0hXX0NBTkNFTExFRCwgJmxvY2FsLT5zY2FubmluZyk7DQogCQlpZiAobG9j
YWwtPm9wcy0+Y2FuY2VsX2h3X3NjYW4pDQogCQkJZHJ2X2NhbmNlbF9od19zY2FuKGxvY2FsLCBs
b2NhbC0+c2Nhbl9zZGF0YSk7DQogCQlnb3RvIG91dDsNCmRpZmYgLS1naXQgYS9uZXQvbWFjODAy
MTEvc3RhdHVzLmMgYi9uZXQvbWFjODAyMTEvc3RhdHVzLmMNCmluZGV4IDY3ZGY1MGUuLjFhNDkz
NTQgMTAwNjQ0DQotLS0gYS9uZXQvbWFjODAyMTEvc3RhdHVzLmMNCisrKyBiL25ldC9tYWM4MDIx
MS9zdGF0dXMuYw0KQEAgLTE4MSw2ICsxODEsOSBAQCBzdGF0aWMgdm9pZCBpZWVlODAyMTFfZnJh
bWVfYWNrZWQoc3RydWN0IHN0YV9pbmZvICpzdGEsIHN0cnVjdCBza19idWZmICpza2IpDQogCXN0
cnVjdCBpZWVlODAyMTFfbG9jYWwgKmxvY2FsID0gc3RhLT5sb2NhbDsNCiAJc3RydWN0IGllZWU4
MDIxMV9zdWJfaWZfZGF0YSAqc2RhdGEgPSBzdGEtPnNkYXRhOw0KIA0KKwlpZiAobG9jYWwtPmh3
LmZsYWdzICYgSUVFRTgwMjExX0hXX1JFUE9SVFNfVFhfQUNLX1NUQVRVUykNCisJCXN0YS0+bGFz
dF9yeCA9IGppZmZpZXM7DQorDQogCWlmIChpZWVlODAyMTFfaXNfZGF0YV9xb3MobWdtdC0+ZnJh
bWVfY29udHJvbCkpIHsNCiAJCXN0cnVjdCBpZWVlODAyMTFfaGRyICpoZHIgPSAodm9pZCAqKSBz
a2ItPmRhdGE7DQogCQl1OCAqcWMgPSBpZWVlODAyMTFfZ2V0X3Fvc19jdGwoaGRyKTsNCmRpZmYg
LS1naXQgYS9uZXQvbmV0ZmlsdGVyL25mX2Nvbm50cmFja19zaXAuYyBiL25ldC9uZXRmaWx0ZXIv
bmZfY29ubnRyYWNrX3NpcC5jDQppbmRleCA5M2ZhZjZhLi40YThjNTViIDEwMDY0NA0KLS0tIGEv
bmV0L25ldGZpbHRlci9uZl9jb25udHJhY2tfc2lwLmMNCisrKyBiL25ldC9uZXRmaWx0ZXIvbmZf
Y29ubnRyYWNrX3NpcC5jDQpAQCAtMTQ2OCw3ICsxNDY4LDcgQEAgc3RhdGljIGludCBzaXBfaGVs
cF90Y3Aoc3RydWN0IHNrX2J1ZmYgKnNrYiwgdW5zaWduZWQgaW50IHByb3RvZmYsDQogDQogCQlt
c2dsZW4gPSBvcmlnbGVuID0gZW5kIC0gZHB0cjsNCiAJCWlmIChtc2dsZW4gPiBkYXRhbGVuKQ0K
LQkJCXJldHVybiBORl9EUk9QOw0KKwkJCXJldHVybiBORl9BQ0NFUFQ7DQogDQogCQlyZXQgPSBw
cm9jZXNzX3NpcF9tc2coc2tiLCBjdCwgZGF0YW9mZiwgJmRwdHIsICZtc2dsZW4pOw0KIAkJaWYg
KHJldCAhPSBORl9BQ0NFUFQpDQpkaWZmIC0tZ2l0IGEvbmV0L3NjdHAvb3V0cHV0LmMgYi9uZXQv
c2N0cC9vdXRwdXQuYw0KaW5kZXggMzJiYThkMC4uY2YzZTIyYyAxMDA2NDQNCi0tLSBhL25ldC9z
Y3RwL291dHB1dC5jDQorKysgYi9uZXQvc2N0cC9vdXRwdXQuYw0KQEAgLTUxOCw3ICs1MTgsOCBA
QCBpbnQgc2N0cF9wYWNrZXRfdHJhbnNtaXQoc3RydWN0IHNjdHBfcGFja2V0ICpwYWNrZXQpDQog
CSAqIGJ5IENSQzMyLUMgYXMgZGVzY3JpYmVkIGluIDxkcmFmdC1pZXRmLXRzdndnLXNjdHBjc3Vt
LTAyLnR4dD4uDQogCSAqLw0KIAlpZiAoIXNjdHBfY2hlY2tzdW1fZGlzYWJsZSkgew0KLQkJaWYg
KCEoZHN0LT5kZXYtPmZlYXR1cmVzICYgTkVUSUZfRl9TQ1RQX0NTVU0pKSB7DQorCQlpZiAoIShk
c3QtPmRldi0+ZmVhdHVyZXMgJiBORVRJRl9GX1NDVFBfQ1NVTSkgfHwNCisJCSAgICAoZHN0X3hm
cm0oZHN0KSAhPSBOVUxMKSB8fCBwYWNrZXQtPmlwZnJhZ29rKSB7DQogCQkJX191MzIgY3JjMzIg
PSBzY3RwX3N0YXJ0X2Nrc3VtKChfX3U4ICopc2gsIGNrc3VtX2J1Zl9sZW4pOw0KIA0KIAkJCS8q
IDMpIFB1dCB0aGUgcmVzdWx0YW50IHZhbHVlIGludG8gdGhlIGNoZWNrc3VtIGZpZWxkIGluIHRo
ZQ0KZGlmZiAtLWdpdCBhL25ldC9zb2NrZXQuYyBiL25ldC9zb2NrZXQuYw0KaW5kZXggY2Y1NDZh
My4uYmY3YWRhYSAxMDA2NDQNCi0tLSBhL25ldC9zb2NrZXQuYw0KKysrIGIvbmV0L3NvY2tldC5j
DQpAQCAtMTg3Niw2ICsxODc2LDE2IEBAIHN0cnVjdCB1c2VkX2FkZHJlc3Mgew0KIAl1bnNpZ25l
ZCBpbnQgbmFtZV9sZW47DQogfTsNCiANCitzdGF0aWMgaW50IGNvcHlfbXNnaGRyX2Zyb21fdXNl
cihzdHJ1Y3QgbXNnaGRyICprbXNnLA0KKwkJCQkgc3RydWN0IG1zZ2hkciBfX3VzZXIgKnVtc2cp
DQorew0KKwlpZiAoY29weV9mcm9tX3VzZXIoa21zZywgdW1zZywgc2l6ZW9mKHN0cnVjdCBtc2do
ZHIpKSkNCisJCXJldHVybiAtRUZBVUxUOw0KKwlpZiAoa21zZy0+bXNnX25hbWVsZW4gPiBzaXpl
b2Yoc3RydWN0IHNvY2thZGRyX3N0b3JhZ2UpKQ0KKwkJcmV0dXJuIC1FSU5WQUw7DQorCXJldHVy
biAwOw0KK30NCisNCiBzdGF0aWMgaW50IF9fX3N5c19zZW5kbXNnKHN0cnVjdCBzb2NrZXQgKnNv
Y2ssIHN0cnVjdCBtc2doZHIgX191c2VyICptc2csDQogCQkJICBzdHJ1Y3QgbXNnaGRyICptc2df
c3lzLCB1bnNpZ25lZCBmbGFncywNCiAJCQkgIHN0cnVjdCB1c2VkX2FkZHJlc3MgKnVzZWRfYWRk
cmVzcykNCkBAIC0xODk0LDggKzE5MDQsMTEgQEAgc3RhdGljIGludCBfX19zeXNfc2VuZG1zZyhz
dHJ1Y3Qgc29ja2V0ICpzb2NrLCBzdHJ1Y3QgbXNnaGRyIF9fdXNlciAqbXNnLA0KIAlpZiAoTVNH
X0NNU0dfQ09NUEFUICYgZmxhZ3MpIHsNCiAJCWlmIChnZXRfY29tcGF0X21zZ2hkcihtc2dfc3lz
LCBtc2dfY29tcGF0KSkNCiAJCQlyZXR1cm4gLUVGQVVMVDsNCi0JfSBlbHNlIGlmIChjb3B5X2Zy
b21fdXNlcihtc2dfc3lzLCBtc2csIHNpemVvZihzdHJ1Y3QgbXNnaGRyKSkpDQotCQlyZXR1cm4g
LUVGQVVMVDsNCisJfSBlbHNlIHsNCisJCWVyciA9IGNvcHlfbXNnaGRyX2Zyb21fdXNlcihtc2df
c3lzLCBtc2cpOw0KKwkJaWYgKGVycikNCisJCQlyZXR1cm4gZXJyOw0KKwl9DQogDQogCS8qIGRv
IG5vdCBtb3ZlIGJlZm9yZSBtc2dfc3lzIGlzIHZhbGlkICovDQogCWVyciA9IC1FTVNHU0laRTsN
CkBAIC0yMTEwLDggKzIxMjMsMTEgQEAgc3RhdGljIGludCBfX19zeXNfcmVjdm1zZyhzdHJ1Y3Qg
c29ja2V0ICpzb2NrLCBzdHJ1Y3QgbXNnaGRyIF9fdXNlciAqbXNnLA0KIAlpZiAoTVNHX0NNU0df
Q09NUEFUICYgZmxhZ3MpIHsNCiAJCWlmIChnZXRfY29tcGF0X21zZ2hkcihtc2dfc3lzLCBtc2df
Y29tcGF0KSkNCiAJCQlyZXR1cm4gLUVGQVVMVDsNCi0JfSBlbHNlIGlmIChjb3B5X2Zyb21fdXNl
cihtc2dfc3lzLCBtc2csIHNpemVvZihzdHJ1Y3QgbXNnaGRyKSkpDQotCQlyZXR1cm4gLUVGQVVM
VDsNCisJfSBlbHNlIHsNCisJCWVyciA9IGNvcHlfbXNnaGRyX2Zyb21fdXNlcihtc2dfc3lzLCBt
c2cpOw0KKwkJaWYgKGVycikNCisJCQlyZXR1cm4gZXJyOw0KKwl9DQogDQogCWVyciA9IC1FTVNH
U0laRTsNCiAJaWYgKG1zZ19zeXMtPm1zZ19pb3ZsZW4gPiBVSU9fTUFYSU9WKQ0KZGlmZiAtLWdp
dCBhL25ldC91bml4L2FmX3VuaXguYyBiL25ldC91bml4L2FmX3VuaXguYw0KaW5kZXggNTYxMTU2
My4uNTEyMmIyMiAxMDA2NDQNCi0tLSBhL25ldC91bml4L2FmX3VuaXguYw0KKysrIGIvbmV0L3Vu
aXgvYWZfdW5peC5jDQpAQCAtMTIzNiw2ICsxMjM2LDE1IEBAIHN0YXRpYyBpbnQgdW5peF9zb2Nr
ZXRwYWlyKHN0cnVjdCBzb2NrZXQgKnNvY2thLCBzdHJ1Y3Qgc29ja2V0ICpzb2NrYikNCiAJcmV0
dXJuIDA7DQogfQ0KIA0KK3N0YXRpYyB2b2lkIHVuaXhfc29ja19pbmhlcml0X2ZsYWdzKGNvbnN0
IHN0cnVjdCBzb2NrZXQgKm9sZCwNCisJCQkJICAgIHN0cnVjdCBzb2NrZXQgKm5ldykNCit7DQor
CWlmICh0ZXN0X2JpdChTT0NLX1BBU1NDUkVELCAmb2xkLT5mbGFncykpDQorCQlzZXRfYml0KFNP
Q0tfUEFTU0NSRUQsICZuZXctPmZsYWdzKTsNCisJaWYgKHRlc3RfYml0KFNPQ0tfUEFTU1NFQywg
Jm9sZC0+ZmxhZ3MpKQ0KKwkJc2V0X2JpdChTT0NLX1BBU1NTRUMsICZuZXctPmZsYWdzKTsNCit9
DQorDQogc3RhdGljIGludCB1bml4X2FjY2VwdChzdHJ1Y3Qgc29ja2V0ICpzb2NrLCBzdHJ1Y3Qg
c29ja2V0ICpuZXdzb2NrLCBpbnQgZmxhZ3MpDQogew0KIAlzdHJ1Y3Qgc29jayAqc2sgPSBzb2Nr
LT5zazsNCkBAIC0xMjcwLDYgKzEyNzksNyBAQCBzdGF0aWMgaW50IHVuaXhfYWNjZXB0KHN0cnVj
dCBzb2NrZXQgKnNvY2ssIHN0cnVjdCBzb2NrZXQgKm5ld3NvY2ssIGludCBmbGFncykNCiAJLyog
YXR0YWNoIGFjY2VwdGVkIHNvY2sgdG8gc29ja2V0ICovDQogCXVuaXhfc3RhdGVfbG9jayh0c2sp
Ow0KIAluZXdzb2NrLT5zdGF0ZSA9IFNTX0NPTk5FQ1RFRDsNCisJdW5peF9zb2NrX2luaGVyaXRf
ZmxhZ3Moc29jaywgbmV3c29jayk7DQogCXNvY2tfZ3JhZnQodHNrLCBuZXdzb2NrKTsNCiAJdW5p
eF9zdGF0ZV91bmxvY2sodHNrKTsNCiAJcmV0dXJuIDA7DQpkaWZmIC0tZ2l0IGEvbmV0L3dpcmVs
ZXNzL3JhZGlvdGFwLmMgYi9uZXQvd2lyZWxlc3MvcmFkaW90YXAuYw0KaW5kZXggYzRhZDc5NS4u
NjE3YTMxMCAxMDA2NDQNCi0tLSBhL25ldC93aXJlbGVzcy9yYWRpb3RhcC5jDQorKysgYi9uZXQv
d2lyZWxlc3MvcmFkaW90YXAuYw0KQEAgLTk1LDYgKzk1LDEwIEBAIGludCBpZWVlODAyMTFfcmFk
aW90YXBfaXRlcmF0b3JfaW5pdCgNCiAJc3RydWN0IGllZWU4MDIxMV9yYWRpb3RhcF9oZWFkZXIg
KnJhZGlvdGFwX2hlYWRlciwNCiAJaW50IG1heF9sZW5ndGgsIGNvbnN0IHN0cnVjdCBpZWVlODAy
MTFfcmFkaW90YXBfdmVuZG9yX25hbWVzcGFjZXMgKnZucykNCiB7DQorCS8qIGNoZWNrIHRoZSBy
YWRpb3RhcCBoZWFkZXIgY2FuIGFjdHVhbGx5IGJlIHByZXNlbnQgKi8NCisJaWYgKG1heF9sZW5n
dGggPCBzaXplb2Yoc3RydWN0IGllZWU4MDIxMV9yYWRpb3RhcF9oZWFkZXIpKQ0KKwkJcmV0dXJu
IC1FSU5WQUw7DQorDQogCS8qIExpbnV4IG9ubHkgc3VwcG9ydHMgdmVyc2lvbiAwIHJhZGlvdGFw
IGZvcm1hdCAqLw0KIAlpZiAocmFkaW90YXBfaGVhZGVyLT5pdF92ZXJzaW9uKQ0KIAkJcmV0dXJu
IC1FSU5WQUw7DQpAQCAtMTI5LDcgKzEzMyw4IEBAIGludCBpZWVlODAyMTFfcmFkaW90YXBfaXRl
cmF0b3JfaW5pdCgNCiAJCQkgKi8NCiANCiAJCQlpZiAoKHVuc2lnbmVkIGxvbmcpaXRlcmF0b3It
Pl9hcmcgLQ0KLQkJCSAgICAodW5zaWduZWQgbG9uZylpdGVyYXRvci0+X3J0aGVhZGVyID4NCisJ
CQkgICAgKHVuc2lnbmVkIGxvbmcpaXRlcmF0b3ItPl9ydGhlYWRlciArDQorCQkJICAgIHNpemVv
Zih1aW50MzJfdCkgPg0KIAkJCSAgICAodW5zaWduZWQgbG9uZylpdGVyYXRvci0+X21heF9sZW5n
dGgpDQogCQkJCXJldHVybiAtRUlOVkFMOw0KIAkJfQ0KZGlmZiAtLWdpdCBhL3NvdW5kL3BjaS9o
ZGEvcGF0Y2hfcmVhbHRlay5jIGIvc291bmQvcGNpL2hkYS9wYXRjaF9yZWFsdGVrLmMNCmluZGV4
IDFiNDNmZGUuLjkyYzkxM2QgMTAwNjQ0DQotLS0gYS9zb3VuZC9wY2kvaGRhL3BhdGNoX3JlYWx0
ZWsuYw0KKysrIGIvc291bmQvcGNpL2hkYS9wYXRjaF9yZWFsdGVrLmMNCkBAIC01Nzk4LDYgKzU3
OTgsOCBAQCBzdGF0aWMgY29uc3Qgc3RydWN0IHNuZF9wY2lfcXVpcmsgYWxjNjYyX2ZpeHVwX3Ri
bFtdID0gew0KIAlTTkRfUENJX1FVSVJLKDB4MTAyNSwgMHgwMzFjLCAiR2F0ZXdheSBOVjc5Iiwg
QUxDNjYyX0ZJWFVQX1NLVV9JR05PUkUpLA0KIAlTTkRfUENJX1FVSVJLKDB4MTAyNSwgMHgwMzhi
LCAiQWNlciBBc3BpcmUgODk0M0ciLCBBTEM2NjJfRklYVVBfQVNQSVJFKSwNCiAJU05EX1BDSV9R
VUlSSygweDEwM2MsIDB4MTYzMiwgIkhQIFJQNTgwMCIsIEFMQzY2Ml9GSVhVUF9IUF9SUDU4MDAp
LA0KKwlTTkRfUENJX1FVSVJLKDB4MTA0MywgMHgxNDc3LCAiQVNVUyBONTZWWiIsIEFMQzY2Ml9G
SVhVUF9BU1VTX01PREU0KSwNCisJU05EX1BDSV9RVUlSSygweDEwNDMsIDB4MWJmMywgIkFTVVMg
Tjc2VloiLCBBTEM2NjJfRklYVVBfQVNVU19NT0RFNCksDQogCVNORF9QQ0lfUVVJUksoMHgxMDQz
LCAweDg0NjksICJBU1VTIG1vYm8iLCBBTEM2NjJfRklYVVBfTk9fSkFDS19ERVRFQ1QpLA0KIAlT
TkRfUENJX1FVSVJLKDB4MTA1YiwgMHgwY2Q2LCAiRm94Y29ubiIsIEFMQzY2Ml9GSVhVUF9BU1VT
X01PREUyKSwNCiAJU05EX1BDSV9RVUlSSygweDE0NGQsIDB4YzA1MSwgIlNhbXN1bmcgUjcyMCIs
IEFMQzY2Ml9GSVhVUF9JREVBUEFEKSwNCmRpZmYgLS1naXQgYS9zb3VuZC9zb2MvY29kZWNzL3dt
X2h1YnMuYyBiL3NvdW5kL3NvYy9jb2RlY3Mvd21faHVicy5jDQppbmRleCAzNjQyZTA2Li5lNDRj
MGUzIDEwMDY0NA0KLS0tIGEvc291bmQvc29jL2NvZGVjcy93bV9odWJzLmMNCisrKyBiL3NvdW5k
L3NvYy9jb2RlY3Mvd21faHVicy5jDQpAQCAtNDE0LDYgKzQxNCw3IEBAIHN0YXRpYyBpbnQgaHBf
c3VwcGx5X2V2ZW50KHN0cnVjdCBzbmRfc29jX2RhcG1fd2lkZ2V0ICp3LA0KIAkJCQlodWJzLT5o
cF9zdGFydHVwX21vZGUpOw0KIAkJCWJyZWFrOw0KIAkJfQ0KKwkJYnJlYWs7DQogDQogCWNhc2Ug
U05EX1NPQ19EQVBNX1BSRV9QTUQ6DQogCQlzbmRfc29jX3VwZGF0ZV9iaXRzKGNvZGVjLCBXTTg5
OTNfQ0hBUkdFX1BVTVBfMSwNCmRpZmYgLS1naXQgYS9zb3VuZC9zb2Mvc29jLWRhcG0uYyBiL3Nv
dW5kL3NvYy9zb2MtZGFwbS5jDQppbmRleCBiNTE2NDg4Li4xZDgzYTQwIDEwMDY0NA0KLS0tIGEv
c291bmQvc29jL3NvYy1kYXBtLmMNCisrKyBiL3NvdW5kL3NvYy9zb2MtZGFwbS5jDQpAQCAtMTUy
Myw3ICsxNTIzLDcgQEAgc3RhdGljIHNzaXplX3QgZGFwbV93aWRnZXRfcG93ZXJfcmVhZF9maWxl
KHN0cnVjdCBmaWxlICpmaWxlLA0KIAkJCQl3LT5hY3RpdmUgPyAiYWN0aXZlIiA6ICJpbmFjdGl2
ZSIpOw0KIA0KIAlsaXN0X2Zvcl9lYWNoX2VudHJ5KHAsICZ3LT5zb3VyY2VzLCBsaXN0X3Npbmsp
IHsNCi0JCWlmIChwLT5jb25uZWN0ZWQgJiYgIXAtPmNvbm5lY3RlZCh3LCBwLT5zaW5rKSkNCisJ
CWlmIChwLT5jb25uZWN0ZWQgJiYgIXAtPmNvbm5lY3RlZCh3LCBwLT5zb3VyY2UpKQ0KIAkJCWNv
bnRpbnVlOw0KIA0KIAkJaWYgKHAtPmNvbm5lY3QpDQpkaWZmIC0tZ2l0IGEvc291bmQvdXNiL3Vz
eDJ5L3VzYnVzeDJ5YXVkaW8uYyBiL3NvdW5kL3VzYi91c3gyeS91c2J1c3gyeWF1ZGlvLmMNCmlu
ZGV4IGQ1NzI0ZDguLjEyMjY2MzEgMTAwNjQ0DQotLS0gYS9zb3VuZC91c2IvdXN4MnkvdXNidXN4
MnlhdWRpby5jDQorKysgYi9zb3VuZC91c2IvdXN4MnkvdXNidXN4MnlhdWRpby5jDQpAQCAtMjk5
LDE5ICsyOTksNiBAQCBzdGF0aWMgdm9pZCB1c1gyWV9lcnJvcl91cmJfc3RhdHVzKHN0cnVjdCB1
c1gyWWRldiAqdXNYMlksDQogCXVzWDJZX2NsaWVudHNfc3RvcCh1c1gyWSk7DQogfQ0KIA0KLXN0
YXRpYyB2b2lkIHVzWDJZX2Vycm9yX3NlcXVlbmNlKHN0cnVjdCB1c1gyWWRldiAqdXNYMlksDQot
CQkJCSBzdHJ1Y3Qgc25kX3VzWDJZX3N1YnN0cmVhbSAqc3Vicywgc3RydWN0IHVyYiAqdXJiKQ0K
LXsNCi0Jc25kX3ByaW50ayhLRVJOX0VSUg0KLSJTZXF1ZW5jZSBFcnJvciEoaGNkX2ZyYW1lPSVp
IGVwPSVpJXM7d2FpdD0laSxmcmFtZT0laSkuXG4iDQotIk1vc3QgcHJvcGFibHkgc29tZSB1cmIg
b2YgdXNiLWZyYW1lICVpIGlzIHN0aWxsIG1pc3NpbmcuXG4iDQotIkNhdXNlIGNvdWxkIGJlIHRv
byBsb25nIGRlbGF5cyBpbiB1c2ItaGNkIGludGVycnVwdCBoYW5kbGluZy5cbiIsDQotCQkgICB1
c2JfZ2V0X2N1cnJlbnRfZnJhbWVfbnVtYmVyKHVzWDJZLT5kZXYpLA0KLQkJICAgc3Vicy0+ZW5k
cG9pbnQsIHVzYl9waXBlaW4odXJiLT5waXBlKSA/ICJpbiIgOiAib3V0IiwNCi0JCSAgIHVzWDJZ
LT53YWl0X2lzb19mcmFtZSwgdXJiLT5zdGFydF9mcmFtZSwgdXNYMlktPndhaXRfaXNvX2ZyYW1l
KTsNCi0JdXNYMllfY2xpZW50c19zdG9wKHVzWDJZKTsNCi19DQotDQogc3RhdGljIHZvaWQgaV91
c1gyWV91cmJfY29tcGxldGUoc3RydWN0IHVyYiAqdXJiKQ0KIHsNCiAJc3RydWN0IHNuZF91c1gy
WV9zdWJzdHJlYW0gKnN1YnMgPSB1cmItPmNvbnRleHQ7DQpAQCAtMzI4LDEyICszMTUsOSBAQCBz
dGF0aWMgdm9pZCBpX3VzWDJZX3VyYl9jb21wbGV0ZShzdHJ1Y3QgdXJiICp1cmIpDQogCQl1c1gy
WV9lcnJvcl91cmJfc3RhdHVzKHVzWDJZLCBzdWJzLCB1cmIpOw0KIAkJcmV0dXJuOw0KIAl9DQot
CWlmIChsaWtlbHkoKHVyYi0+c3RhcnRfZnJhbWUgJiAweEZGRkYpID09ICh1c1gyWS0+d2FpdF9p
c29fZnJhbWUgJiAweEZGRkYpKSkNCi0JCXN1YnMtPmNvbXBsZXRlZF91cmIgPSB1cmI7DQotCWVs
c2Ugew0KLQkJdXNYMllfZXJyb3Jfc2VxdWVuY2UodXNYMlksIHN1YnMsIHVyYik7DQotCQlyZXR1
cm47DQotCX0NCisNCisJc3Vicy0+Y29tcGxldGVkX3VyYiA9IHVyYjsNCisNCiAJew0KIAkJc3Ry
dWN0IHNuZF91c1gyWV9zdWJzdHJlYW0gKmNhcHN1YnMgPSB1c1gyWS0+c3Vic1tTTkRSVl9QQ01f
U1RSRUFNX0NBUFRVUkVdLA0KIAkJCSpwbGF5YmFja3N1YnMgPSB1c1gyWS0+c3Vic1tTTkRSVl9Q
Q01fU1RSRUFNX1BMQVlCQUNLXTsNCmRpZmYgLS1naXQgYS9zb3VuZC91c2IvdXN4MnkvdXN4Mnlo
d2RlcHBjbS5jIGIvc291bmQvdXNiL3VzeDJ5L3VzeDJ5aHdkZXBwY20uYw0KaW5kZXggYTUxMzQw
Zi4uODNhOGI4ZCAxMDA2NDQNCi0tLSBhL3NvdW5kL3VzYi91c3gyeS91c3gyeWh3ZGVwcGNtLmMN
CisrKyBiL3NvdW5kL3VzYi91c3gyeS91c3gyeWh3ZGVwcGNtLmMNCkBAIC0yNDQsMTMgKzI0NCw4
IEBAIHN0YXRpYyB2b2lkIGlfdXNYMllfdXNicGNtX3VyYl9jb21wbGV0ZShzdHJ1Y3QgdXJiICp1
cmIpDQogCQl1c1gyWV9lcnJvcl91cmJfc3RhdHVzKHVzWDJZLCBzdWJzLCB1cmIpOw0KIAkJcmV0
dXJuOw0KIAl9DQotCWlmIChsaWtlbHkoKHVyYi0+c3RhcnRfZnJhbWUgJiAweEZGRkYpID09ICh1
c1gyWS0+d2FpdF9pc29fZnJhbWUgJiAweEZGRkYpKSkNCi0JCXN1YnMtPmNvbXBsZXRlZF91cmIg
PSB1cmI7DQotCWVsc2Ugew0KLQkJdXNYMllfZXJyb3Jfc2VxdWVuY2UodXNYMlksIHN1YnMsIHVy
Yik7DQotCQlyZXR1cm47DQotCX0NCiANCisJc3Vicy0+Y29tcGxldGVkX3VyYiA9IHVyYjsNCiAJ
Y2Fwc3VicyA9IHVzWDJZLT5zdWJzW1NORFJWX1BDTV9TVFJFQU1fQ0FQVFVSRV07DQogCWNhcHN1
YnMyID0gdXNYMlktPnN1YnNbU05EUlZfUENNX1NUUkVBTV9DQVBUVVJFICsgMl07DQogCXBsYXli
YWNrc3VicyA9IHVzWDJZLT5zdWJzW1NORFJWX1BDTV9TVFJFQU1fUExBWUJBQ0tdOw0KZGlmZiAt
LWdpdCBhL3Rvb2xzL3BlcmYvYnVpbHRpbi1zY2hlZC5jIGIvdG9vbHMvcGVyZi9idWlsdGluLXNj
aGVkLmMNCmluZGV4IDUxNzc5NjQuLjcxNGZjMzUgMTAwNjQ0DQotLS0gYS90b29scy9wZXJmL2J1
aWx0aW4tc2NoZWQuYw0KKysrIGIvdG9vbHMvcGVyZi9idWlsdGluLXNjaGVkLmMNCkBAIC0xNCw2
ICsxNCw3IEBADQogI2luY2x1ZGUgInV0aWwvZGVidWcuaCINCiANCiAjaW5jbHVkZSA8c3lzL3By
Y3RsLmg+DQorI2luY2x1ZGUgPHN5cy9yZXNvdXJjZS5oPg0KIA0KICNpbmNsdWRlIDxzZW1hcGhv
cmUuaD4NCiAjaW5jbHVkZSA8cHRocmVhZC5oPg0K


--=-7U4VAK7Vn306YuVIShpD--

--=-5Xbi80ZiWw58YThGko/+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIVAwUAUpglG+e/yOyVhhEJAQoBIw//YbYn14p9ZidwAGe+1XZpS/7JMBOirbyC
4Cbt4rdgsTBgvz5GyZq68pM/HGDDx9Gm8NH5hFqsdbLjMCXDImmf4WCCePog4QYj
C8eYPXZer8eRIazSWcf9AcC9tu+wAuq3rIpU2op8+WFmM7XxeppMi/dG9C/E/bY/
qEAv93yj7ROSf+qi0WjMGtW/JbCFF+PQKKa+kWub3oFBxvWT4j6x4sgg7E+pZzUC
ZPtnZakuxaBA+ezMHFvoxLYysgXqOvkbzqfhuabIGvqFt+5gfGcj0vrZFKtdJVX4
9/09WPLQKibtN9SOW3qEizu7BXLrsbdaOW9wRp3Tj55MO2bkg0iMcRHWgojGvib2
pYGg3G+Qx56wulIbsEG0dyIcJEf+kBKpM8rFyiOs+YurMiCRys2aoHHRw8jnldw9
M48NBTiRGJZgGk59xS270jJkz7DWeACprCMb70RaB+BmVKQuk7UWRVRSygMhczL6
TwP/7+0BpqxiYos5oN+/GF3kKwc9PlY6wVKgUxkYoVIAdzhoSKkYcBiW9eQ/9XzS
KHfFdFb66nTH7Gt+2muqorEbIgmCoc5kPmmPRoDmom5iiJ1I8PgOBVXakdgryJyi
CecbMIqcPMTzcBvtmf4QoOTlxsX+nh9EZh+pKa6zqilS52ybx/TuLGzofbG9iX3Y
8FakQz6jYu4=
=jihM
-----END PGP SIGNATURE-----

--=-5Xbi80ZiWw58YThGko/+--

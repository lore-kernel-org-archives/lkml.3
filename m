Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754621Ab3EKVpy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 May 2013 17:45:54 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:42011 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754365Ab3EKVpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 May 2013 17:45:51 -0400
Date: Sat, 11 May 2013 14:46:02 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.8.13
Message-ID: <20130511214602.GA19530@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xHFwDpU9dbj6ez1V"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.8.13 kernel.

NOTE, this is the LAST 3.8.y kernel release, please move to the 3.9.y
kernel series at this time.  It is end-of-life, dead, gone, buried, and
put way behind us never to be spoken of again.  Seriously, move on, it's
just not worth it anymore.

And for that specific two-letter hardware company that was insisting in
public that I would be maintaining the 3.8.y kernel as a long-term
kernel so that "you will do our maintenance work for us, for free,"
please see figure one.

The updated 3.8.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.8.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Makefile                                      |    2=20
 arch/arm/xen/enlighten.c                      |    2=20
 arch/arm64/mm/fault.c                         |    3=20
 arch/powerpc/include/asm/ppc-opcode.h         |    4=20
 arch/powerpc/kernel/traps.c                   |   10 +-
 arch/powerpc/mm/numa.c                        |    2=20
 arch/x86/kernel/cpu/perf_event_intel_lbr.c    |   27 +++++-
 arch/x86/kernel/cpu/perf_event_intel_uncore.c |   17 ++-
 arch/x86/mm/init.c                            |    5 +
 drivers/edac/edac_mc_sysfs.c                  |   12 +-
 drivers/gpu/drm/ast/ast_drv.h                 |    2=20
 drivers/gpu/drm/ast/ast_fb.c                  |   43 +++++++++-
 drivers/gpu/drm/ast/ast_ttm.c                 |    2=20
 drivers/gpu/drm/cirrus/cirrus_drv.h           |    2=20
 drivers/gpu/drm/cirrus/cirrus_fbdev.c         |   38 ++++++++
 drivers/gpu/drm/cirrus/cirrus_ttm.c           |    2=20
 drivers/gpu/drm/drm_gem.c                     |    4=20
 drivers/gpu/drm/drm_prime.c                   |   76 +++++++++--------
 drivers/gpu/drm/gma500/psb_irq.c              |    2=20
 drivers/gpu/drm/i915/i915_drv.h               |    2=20
 drivers/gpu/drm/i915/i915_gem.c               |   28 +++++-
 drivers/gpu/drm/i915/i915_gem_context.c       |    7 +
 drivers/gpu/drm/i915/i915_gem_stolen.c        |   81 +++++++++---------
 drivers/gpu/drm/i915/i915_reg.h               |    2=20
 drivers/gpu/drm/i915/intel_bios.c             |    6 -
 drivers/gpu/drm/i915/intel_bios.h             |    4=20
 drivers/gpu/drm/i915/intel_display.c          |   26 +++---
 drivers/gpu/drm/i915/intel_dp.c               |    5 -
 drivers/gpu/drm/i915/intel_dvo.c              |   13 ++-
 drivers/gpu/drm/i915/intel_lvds.c             |    9 +-
 drivers/gpu/drm/i915/intel_panel.c            |    7 +
 drivers/gpu/drm/i915/intel_pm.c               |    9 +-
 drivers/gpu/drm/i915/intel_sdvo.c             |    5 -
 drivers/gpu/drm/mgag200/mgag200_drv.h         |    2=20
 drivers/gpu/drm/mgag200/mgag200_fb.c          |   43 +++++++++-
 drivers/gpu/drm/mgag200/mgag200_ttm.c         |    4=20
 drivers/gpu/drm/radeon/atom.c                 |    6 -
 drivers/gpu/drm/radeon/atombios_crtc.c        |    3=20
 drivers/gpu/drm/radeon/evergreen.c            |  111 +++++++++++++++++++++=
++---
 drivers/gpu/drm/radeon/evergreen_reg.h        |    2=20
 drivers/gpu/drm/radeon/ni.c                   |    8 +
 drivers/gpu/drm/radeon/nid.h                  |    4=20
 drivers/gpu/drm/radeon/r100.c                 |   77 ++++++++++++------
 drivers/gpu/drm/radeon/r500_reg.h             |    2=20
 drivers/gpu/drm/radeon/r600_hdmi.c            |    4=20
 drivers/gpu/drm/radeon/radeon_atombios.c      |   21 +++-
 drivers/gpu/drm/radeon/radeon_kms.c           |    4=20
 drivers/gpu/drm/radeon/radeon_pm.c            |    6 +
 drivers/gpu/drm/radeon/radeon_ring.c          |    3=20
 drivers/gpu/drm/radeon/rs600.c                |   52 ++++++++++--
 drivers/gpu/drm/radeon/rv515.c                |   56 ++++++++++++-
 drivers/gpu/drm/radeon/si.c                   |    3=20
 drivers/gpu/drm/radeon/sid.h                  |    2=20
 drivers/infiniband/hw/cxgb4/qp.c              |   25 +++--
 drivers/iommu/amd_iommu.c                     |    3=20
 drivers/net/ethernet/ibm/ibmveth.c            |   23 ++---
 drivers/net/ethernet/intel/e1000e/ethtool.c   |   13 +++
 drivers/net/ethernet/intel/e1000e/netdev.c    |   80 ++++--------------
 drivers/net/ethernet/realtek/r8169.c          |    9 ++
 drivers/pci/pci-driver.c                      |    4=20
 drivers/pwm/pwm-spear.c                       |    6 -
 drivers/usb/host/xhci-ring.c                  |   23 +++--
 fs/autofs4/expire.c                           |    9 --
 fs/btrfs/delayed-ref.c                        |   24 +++--
 fs/btrfs/inode.c                              |   21 +++-
 fs/ext4/resize.c                              |    4=20
 fs/hugetlbfs/inode.c                          |   24 ++---
 fs/nfs/nfs4proc.c                             |    4=20
 include/drm/drmP.h                            |    5 -
 include/drm/drm_pciids.h                      |    5 +
 include/linux/blkdev.h                        |    2=20
 include/linux/hugetlb.h                       |   19 +++-
 ipc/shm.c                                     |    6 +
 kernel/audit_tree.c                           |    2=20
 kernel/trace/trace.c                          |   62 ++++++--------
 kernel/trace/trace_selftest.c                 |    9 +-
 mm/mmap.c                                     |    7 +
 net/ipv4/netfilter/ipt_rpfilter.c             |    8 +
 net/ipv6/netfilter/ip6t_NPT.c                 |    2=20
 net/ipv6/netfilter/ip6t_rpfilter.c            |    8 +
 net/netfilter/ipset/ip_set_core.c             |    3=20
 net/netfilter/ipset/ip_set_list_set.c         |   10 +-
 net/netfilter/ipvs/ip_vs_pe_sip.c             |    6 -
 net/netfilter/nf_conntrack_helper.c           |    4=20
 net/netfilter/nf_conntrack_netlink.c          |    3=20
 net/netfilter/nf_conntrack_sip.c              |    2=20
 net/netfilter/nf_nat_core.c                   |   40 +--------
 87 files changed, 902 insertions(+), 445 deletions(-)

Alex Deucher (20):
      drm/radeon: don't use get_engine_clock() on APUs
      drm/radeon: use frac fb div on RS780/RS880
      drm/radeon: fix typo in rv515_mc_resume()
      drm/radeon/dce6: add missing display reg for tiling setup
      drm/radeon: update wait_for_vblank for r5xx-r7xx
      drm/radeon: update wait_for_vblank for evergreen+
      drm/radeon: properly lock disp in mc_stop/resume for evergreen+
      drm/radeon: properly lock disp in mc_stop/resume for r5xx-r7xx
      drm/radeon: update wait_for_vblank for r1xx-r4xx
      drm/radeon: disable the crtcs in mc_stop (evergreen+) (v2)
      drm/radeon: add some new SI PCI ids
      drm/radeon/evergreen+: don't enable HPD interrupts on eDP/LVDS
      drm/radeon: cleanup properly if mmio mapping fails
      drm/radeon: fix hdmi mode enable on RS600/RS690/RS740
      drm/radeon: fix typo in si_select_se_sh()
      drm/radeon: disable the crtcs in mc_stop (r5xx-r7xx) (v2)
      drm/radeon: fix endian bugs in atom_allocate_fb_scratch()
      drm/radeon: fix possible segfault when parsing pm tables
      drm/radeon: add new richland pci ids
      drm/radeon: fix handling of v6 power tables

Anisse Astier (1):
      drm/gma500: fix backlight hotkeys behaviour on netbooks

Anton Blanchard (1):
      powerpc: Emulate non privileged DSCR read and write

Axel Lin (1):
      pwm: spear: Fix checking return value of clk_enable() and clk_prepare=
()

Benjamin Herrenschmidt (1):
      net/eth/ibmveth: Fixup retrieval of MAC address

Catalin Marinas (1):
      arm64: Ignore the 'write' ESR flag on cache maintenance faults

Chen Gang (1):
      kernel/audit_tree.c: tree will leak memory when failure occurs in aud=
it_trim_trees()

Chris Wilson (3):
      drm/i915: Fix detection of base of stolen memory
      drm/i915: Workaround incoherence between fences and LLC across multip=
le CPUs
      drm/i915: Use MLC (l3$) for context objects

Christian Lamparter (1):
      drm/i915: Add no-lvds quirk for Fujitsu Esprimo Q900

Daniel Vetter (2):
      drm/i915: Fix sdvo connector get_hw_state function
      drm/i915: Fixup Oops in the pipe config computation

Dave Airlie (4):
      drm/cirrus: deal with bo reserve fail in dirty update path
      drm/mgag200: deal with bo reserve fail in dirty update path
      drm/prime: keep a reference from the handle to exported dma-buf (v6)
      drm/ast: deal with bo reserve fail in dirty update path

David Jeffery (1):
      autofs - remove autofs dentry mount check

David M=FCller (1):
      drm/i915: Fall back to bit banging mode for DVO transmitter detection

Egbert Eich (1):
      drm/i915: Fix SDVO connector and encoder get_hw_state functions

Florian Westphal (4):
      netfilter: nf_nat: fix race when unloading protocol modules
      netfilter: nf_ct_helper: don't discard helper if it is actually the s=
ame
      netfilter: ctnetlink: don't permit ct creation with random tuple
      netfilter: xt_rpfilter: skip locally generated broadcast/multicast, t=
oo

Greg Kroah-Hartman (1):
      Linux 3.8.13

Hans Schillstrom (1):
      ipvs: ip_vs_sip_fill_param() BUG: bad check of return value

James Bottomley (1):
      block: fix max discard sectors limit

Jan-Simon M=F6ller (1):
      perf/x86/intel: Fix unintended variable name reuse

Jani Nikula (1):
      drm/i915: ensure single initialization and cleanup of backlight device

Jerome Glisse (1):
      drm/radeon: Always flush the VM

Jerry Hoemann (1):
      x86/mm: account for PGDIR_SIZE alignment

Joerg Roedel (1):
      iommu/amd: Properly initialize irq-table lock

Josef Bacik (2):
      Btrfs: compare relevant parts of delayed tree refs
      Btrfs: fix extent logging with O_DIRECT into prealloc

Jozsef Kadlecsik (2):
      netfilter: ipset: list:set: fix reference counter update
      netfilter: ipset: "Directory not empty" error message

Konstantin Khlebnikov (2):
      e1000e: fix runtime power management transitions
      e1000e: fix accessing to suspended device

Matthias Schiffer (1):
      netfilter: ip6t_NPT: Fix translation for non-multiple of 32 prefix le=
ngths

Naoya Horiguchi (1):
      hugetlbfs: fix mmap failure in unaligned size request

Patrick McHardy (1):
      netfilter: nf_ct_sip: don't drop packets with offsets pointing outsid=
e the packet

Paulo Zanoni (1):
      drm/i915: set CPT FDI RX polarity bits based on VBT

Peter Zijlstra (2):
      perf/x86/intel/lbr: Fix LBR filter
      perf/x86/intel/lbr: Demand proper privileges for PERF_SAMPLE_BRANCH_K=
ERNEL

Rafael J. Wysocki (1):
      PCI/PM: Clear state_saved during suspend

Sarah Sharp (1):
      xhci: Don't warn on empty ring for suspended devices.

Srivatsa S. Bhat (1):
      EDAC: Don't give write permission to read-only files

Stefan Bader (1):
      r8169: fix 8168evl frame padding.

Stefano Stabellini (1):
      xen/arm: actually pass a non-NULL percpu pointer to request_percpu_irq

Steven Rostedt (Red Hat) (1):
      tracing: Fix ftrace_dump()

Thadeu Lima de Souza Cascardo (1):
      RDMA/cxgb4: Fix SQ allocation when on-chip SQ is disabled

Theodore Ts'o (1):
      ext4: add check for inodes_count overflow in new resize ioctl

Trond Myklebust (1):
      NFSv4.x: Fix handling of partially delegated locks

Vaidyanathan Srinivasan (1):
      powerpc: fix numa distance for form0 device tree

Vince Weaver (1):
      perf/x86/intel: Add support for IvyBridge model 58 Uncore


--xHFwDpU9dbj6ez1V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRjrwaAAoJEDjbvchgkmk+5wcP/20hVmUtYijyFjOH83kTmi4Y
GYreJxCxf1SeDWHBiV7Z1auEhGSBnID8b4Wd4ak1+poxudhKkD7achBAGl7GUn+c
zi8ywjIhV/WfXmmiTfHPj9hpmrmN7wymtzNHUYC9OB5xozR6LE0KHHnnRYUAmPMW
Qr4lIuRLCUT5eRPEoCFWQwoVDRu0GmchhAOoXswW8VvXBGmaT0Y4nM0v3kXptGRn
sED8DfiBsqTlhWEVfx/XZdACHwHj+bI7GGtOpHwmVWr7y7zDr5jrhjG+X0fCtp1r
/urVbYTE5NhRE+Hjn+o2AFpXE2IYhGqyAtTeB/xLd7jPZ6xsEB641ueF+x5NkW4k
fQXO8+nkkNM0nYIxxyMZzn7uq0JILA6kzfjHcWXT5olDXEEGA2RgV1cnpH716QWO
3r7YzMQF8vY6kKRvnyrJaGRv2uKM8LHQ5fV1gw5M/1ROW9vwHGToXjDpnykCtsLF
Tnp54cbrUl3YZ4nR4n7Ux8jLU2/a/Xgcv1w9cIApHUIRto+utvszVhiDAfbO4BMB
KXqfEt8XZHyT6I8h49+6oqz8eovQNMHXmqLWjVPUqtV/p7cux9VcbYCE1X0UXiK/
cqnWQagEo9GYikKEaV8EOQ1ds/ljIg9mkniwWW91vhvDMx6K8f2tTkcYZGjfH4ZV
S9l/1iffSYaZ9XvmNdvn
=mvEj
-----END PGP SIGNATURE-----

--xHFwDpU9dbj6ez1V--

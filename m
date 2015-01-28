Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760716AbbA1CWI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 21:22:08 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41026 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755702AbbA1B2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 20:28:08 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: [PATCH 3.10 00/32] 3.10.67-stable review
Date: Tue, 27 Jan 2015 17:26:30 -0800
Message-Id: <20150128012627.081285723@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
User-Agent: quilt/0.63-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.10.67 release.
There are 32 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri Jan 30 01:26:04 UTC 2015.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.67-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.10.67-rc1

NeilBrown <neilb@suse.de>
    md/raid5: fetch_block must fetch all the blocks handle_stripe_dirtying wants.

Jan Kara <jack@suse.cz>
    ext4: fix warning in ext4_da_update_reserve_space()

Jan Kara <jack@suse.cz>
    quota: provide interface for readding allocated space into reserved space

Mathias Krause <minipli@googlemail.com>
    crypto: add missing crypto module aliases

Kees Cook <keescook@chromium.org>
    crypto: include crypto- module prefix in template

Kees Cook <keescook@chromium.org>
    crypto: prefix module autoloading with "crypto-"

Lars Ellenberg <lars.ellenberg@linbit.com>
    drbd: merge_bvec_fn: properly remap bvm->bi_bdev

David Vrabel <david.vrabel@citrix.com>
    Revert "swiotlb-xen: pass dev_addr to swiotlb_tbl_unmap_single"

Dan Carpenter <dan.carpenter@oracle.com>
    ipvs: uninitialized data with IP_VS_IPV6

Sasha Levin <sasha.levin@oracle.com>
    KEYS: close race between key lookup and freeing

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    sata_dwc_460ex: fix resource leak on error path

Andy Lutomirski <luto@amacapital.net>
    x86/asm/traps: Disable tracing and kprobes in fixup_bad_iret and sync_regs

Andy Lutomirski <luto@amacapital.net>
    x86, tls: Interpret an all-zero struct user_desc as "no segment"

Andy Lutomirski <luto@amacapital.net>
    x86, tls, ldt: Stop checking lm in LDT_empty

Nadav Amit <nadav.amit@gmail.com>
    KVM: x86: Fix of previously incomplete fix for CVE-2014-8480

Alexandre Demers <alexandre.f.demers@gmail.com>
    x86/tsc: Change Fast TSC calibration failed from error to info

K. Y. Srinivasan <kys@microsoft.com>
    x86, hyperv: Mark the Hyper-V clocksource as being continuous

Tobias Jakobi <tjakobi@math.uni-bielefeld.de>
    clocksource: exynos_mct: Fix bitmask regression for exynos4_mct_write

Oliver Hartkopp <socketcan@hartkopp.net>
    can: dev: fix crtlmode_supported check

Andrew Lunn <andrew@lunn.ch>
    bus: mvebu-mbus: fix support of MBus window 13

Fabio Estevam <fabio.estevam@freescale.com>
    ARM: dts: imx25: Fix PWM "per" clocks

Sasha Levin <sasha.levin@oracle.com>
    time: adjtimex: Validate the ADJ_FREQUENCY values

Sasha Levin <sasha.levin@oracle.com>
    time: settimeofday: Validate the values of tv from user

Joe Thornber <ejt@redhat.com>
    dm cache: share cache-metadata object across inactive and active DM tables

Brian King <brking@linux.vnet.ibm.com>
    ipr: wait for aborted command responses

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915: Fix mutex->owner inspection race under DEBUG_MUTEXES

Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>
    scripts/recordmcount.pl: There is no -m32 gcc option on Super-H anymore

Jason Lee Cragg <jcragg@gmail.com>
    ALSA: usb-audio: Add mic volume fix quirk for Logitech Webcam C210

David Jeffery <djeffery@redhat.com>
    libata: prevent HSM state change race between ISR and PIO

Jim Lin <jilin@nvidia.com>
    pinctrl: Fix two deadlocks

Johan Hovold <johan@kernel.org>
    gpio: sysfs: fix gpio device-attribute leak

Johan Hovold <johan@kernel.org>
    gpio: sysfs: fix gpio-chip device-attribute leak


-------------

Diffstat:

 Makefile                                   |   4 +-
 arch/arm/boot/dts/imx25.dtsi               |   8 +--
 arch/arm/crypto/aes_glue.c                 |   4 +-
 arch/arm/crypto/sha1_glue.c                |   2 +-
 arch/powerpc/crypto/sha1.c                 |   3 +-
 arch/s390/crypto/aes_s390.c                |   2 +-
 arch/s390/crypto/des_s390.c                |   4 +-
 arch/s390/crypto/ghash_s390.c              |   2 +-
 arch/s390/crypto/sha1_s390.c               |   2 +-
 arch/s390/crypto/sha256_s390.c             |   4 +-
 arch/s390/crypto/sha512_s390.c             |   4 +-
 arch/sparc/crypto/aes_glue.c               |   2 +-
 arch/sparc/crypto/camellia_glue.c          |   2 +-
 arch/sparc/crypto/crc32c_glue.c            |   2 +-
 arch/sparc/crypto/des_glue.c               |   2 +-
 arch/sparc/crypto/md5_glue.c               |   2 +-
 arch/sparc/crypto/sha1_glue.c              |   2 +-
 arch/sparc/crypto/sha256_glue.c            |   4 +-
 arch/sparc/crypto/sha512_glue.c            |   4 +-
 arch/x86/crypto/aes_glue.c                 |   4 +-
 arch/x86/crypto/aesni-intel_glue.c         |   2 +-
 arch/x86/crypto/blowfish_avx2_glue.c       |   4 +-
 arch/x86/crypto/blowfish_glue.c            |   4 +-
 arch/x86/crypto/camellia_aesni_avx2_glue.c |   4 +-
 arch/x86/crypto/camellia_aesni_avx_glue.c  |   4 +-
 arch/x86/crypto/camellia_glue.c            |   4 +-
 arch/x86/crypto/cast5_avx_glue.c           |   2 +-
 arch/x86/crypto/cast6_avx_glue.c           |   2 +-
 arch/x86/crypto/crc32-pclmul_glue.c        |   4 +-
 arch/x86/crypto/crc32c-intel_glue.c        |   4 +-
 arch/x86/crypto/fpu.c                      |   3 +
 arch/x86/crypto/ghash-clmulni-intel_glue.c |   2 +-
 arch/x86/crypto/salsa20_glue.c             |   4 +-
 arch/x86/crypto/serpent_avx2_glue.c        |   4 +-
 arch/x86/crypto/serpent_avx_glue.c         |   2 +-
 arch/x86/crypto/serpent_sse2_glue.c        |   2 +-
 arch/x86/crypto/sha1_ssse3_glue.c          |   2 +-
 arch/x86/crypto/sha256_ssse3_glue.c        |   2 +-
 arch/x86/crypto/sha512_ssse3_glue.c        |   2 +-
 arch/x86/crypto/twofish_avx2_glue.c        |   4 +-
 arch/x86/crypto/twofish_avx_glue.c         |   2 +-
 arch/x86/crypto/twofish_glue.c             |   4 +-
 arch/x86/crypto/twofish_glue_3way.c        |   4 +-
 arch/x86/include/asm/desc.h                |  20 ++++--
 arch/x86/kernel/cpu/mshyperv.c             |   1 +
 arch/x86/kernel/tls.c                      |  25 ++++++-
 arch/x86/kernel/traps.c                    |   4 +-
 arch/x86/kernel/tsc.c                      |   2 +-
 arch/x86/kvm/emulate.c                     |   4 +-
 crypto/842.c                               |   1 +
 crypto/aes_generic.c                       |   3 +-
 crypto/algapi.c                            |   4 +-
 crypto/ansi_cprng.c                        |   3 +-
 crypto/anubis.c                            |   1 +
 crypto/api.c                               |   4 +-
 crypto/arc4.c                              |   1 +
 crypto/authenc.c                           |   1 +
 crypto/authencesn.c                        |   1 +
 crypto/blowfish_generic.c                  |   3 +-
 crypto/camellia_generic.c                  |   3 +-
 crypto/cast5_generic.c                     |   3 +-
 crypto/cast6_generic.c                     |   3 +-
 crypto/cbc.c                               |   1 +
 crypto/ccm.c                               |   5 +-
 crypto/chainiv.c                           |   1 +
 crypto/cmac.c                              |   1 +
 crypto/crc32.c                             |   1 +
 crypto/cryptd.c                            |   1 +
 crypto/crypto_null.c                       |   6 +-
 crypto/ctr.c                               |   3 +-
 crypto/cts.c                               |   1 +
 crypto/deflate.c                           |   2 +-
 crypto/des_generic.c                       |   7 +-
 crypto/ecb.c                               |   1 +
 crypto/eseqiv.c                            |   1 +
 crypto/fcrypt.c                            |   1 +
 crypto/gcm.c                               |   7 +-
 crypto/ghash-generic.c                     |   3 +-
 crypto/hmac.c                              |   1 +
 crypto/khazad.c                            |   1 +
 crypto/krng.c                              |   3 +-
 crypto/lrw.c                               |   1 +
 crypto/lzo.c                               |   1 +
 crypto/md4.c                               |   2 +-
 crypto/md5.c                               |   1 +
 crypto/michael_mic.c                       |   1 +
 crypto/pcbc.c                              |   1 +
 crypto/pcrypt.c                            |   1 +
 crypto/rmd128.c                            |   1 +
 crypto/rmd160.c                            |   1 +
 crypto/rmd256.c                            |   1 +
 crypto/rmd320.c                            |   1 +
 crypto/salsa20_generic.c                   |   3 +-
 crypto/seed.c                              |   1 +
 crypto/seqiv.c                             |   1 +
 crypto/serpent_generic.c                   |   5 +-
 crypto/sha1_generic.c                      |   3 +-
 crypto/sha256_generic.c                    |   6 +-
 crypto/sha512_generic.c                    |   6 +-
 crypto/tea.c                               |   5 +-
 crypto/tgr192.c                            |   5 +-
 crypto/twofish_generic.c                   |   3 +-
 crypto/vmac.c                              |   1 +
 crypto/wp512.c                             |   5 +-
 crypto/xcbc.c                              |   1 +
 crypto/xts.c                               |   1 +
 crypto/zlib.c                              |   1 +
 drivers/ata/libata-sff.c                   |  12 ++++
 drivers/ata/sata_dwc_460ex.c               |  26 ++++----
 drivers/block/drbd/drbd_req.c              |   1 +
 drivers/bus/mvebu-mbus.c                   |  13 ++++
 drivers/clocksource/exynos_mct.c           |   4 +-
 drivers/crypto/padlock-aes.c               |   2 +-
 drivers/crypto/padlock-sha.c               |   8 +--
 drivers/crypto/ux500/cryp/cryp_core.c      |   4 +-
 drivers/crypto/ux500/hash/hash_core.c      |   8 +--
 drivers/gpio/gpiolib.c                     |  24 ++++---
 drivers/gpu/drm/i915/i915_gem.c            |   2 +-
 drivers/md/dm-cache-metadata.c             | 101 +++++++++++++++++++++++++++--
 drivers/md/raid5.c                         |   3 +-
 drivers/net/can/dev.c                      |   8 ++-
 drivers/pinctrl/core.c                     |   5 +-
 drivers/s390/crypto/ap_bus.c               |   1 +
 drivers/scsi/ipr.c                         |  92 ++++++++++++++++++++++++++
 drivers/scsi/ipr.h                         |   1 +
 drivers/xen/swiotlb-xen.c                  |   2 +-
 fs/ext4/ext4.h                             |   1 +
 fs/ext4/extents.c                          |   3 +-
 fs/ext4/mballoc.c                          |  21 ++++--
 fs/quota/dquot.c                           |  46 +++++++++++++
 fs/stat.c                                  |  11 +++-
 include/linux/crypto.h                     |  13 ++++
 include/linux/fs.h                         |   1 +
 include/linux/quotaops.h                   |  15 +++++
 include/linux/time.h                       |  13 ++++
 kernel/time.c                              |   4 ++
 kernel/time/ntp.c                          |   7 ++
 net/netfilter/ipvs/ip_vs_ftp.c             |  10 +--
 scripts/recordmcount.pl                    |   1 -
 security/keys/gc.c                         |   4 +-
 sound/usb/mixer.c                          |   1 +
 141 files changed, 613 insertions(+), 182 deletions(-)



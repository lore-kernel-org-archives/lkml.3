Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423000AbaDKQJk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 12:09:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56745 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754211AbaDKQJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 12:09:25 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: [PATCH 3.14 00/23] 3.14.1-stable review
Date: Fri, 11 Apr 2014 09:11:49 -0700
Message-Id: <20140411161200.236939691@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.14.1 release.
There are 23 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun Apr 13 16:11:46 UTC 2014.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.14.1-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.14.1-rc1

Ard Biesheuvel <ard.biesheuvel@linaro.org>
    crypto: ghash-clmulni-intel - use C implementation for setkey()

Finn Thain <fthain@telegraphics.com.au>
    m68k: Skip futex_atomic_cmpxchg_inatomic() test

Heiko Carstens <heiko.carstens@de.ibm.com>
    futex: Allow architectures to skip futex_atomic_cmpxchg_inatomic() test

Vineet Gupta <vgupta@synopsys.com>
    ARC: [nsimosci] Unbork console

Mischa Jonker <mjonker@synopsys.com>
    ARC: [nsimosci] Change .dts to use generic 8250 UART

Eyal Shapira <eyal@wizery.com>
    iwlwifi: mvm: rs: fix search cycle rules

Gilles Chanteperdrix <gilles.chanteperdrix@xenomai.org>
    net/at91_ether: avoid NULL pointer dereference

Sasha Levin <sasha.levin@oracle.com>
    rds: prevent dereference of a NULL device in rds_iw_laddr_check

Dan Carpenter <dan.carpenter@oracle.com>
    isdnloop: several buffer overflows

YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
    isdnloop: Validate NUL-terminated strings from user.

Mike Rapoport <mike.rapoport@ravellosystems.com>
    net: vxlan: fix crash when interface is created with no group

Daniel Pieczko <dpieczko@solarflare.com>
    Call efx_set_channels() before efx->type->dimension_resources()

Wei Liu <wei.liu2@citrix.com>
    xen-netback: disable rogue vif in kthread context

Pablo Neira <pablo@netfilter.org>
    netlink: don't compare the nul-termination in nla_strcmp

Hannes Frederic Sowa <hannes@stressinduktion.org>
    ipv6: some ipv6 statistic counters failed to disable bh

Paul Durrant <Paul.Durrant@citrix.com>
    xen-netback: BUG_ON in xenvif_rx_action() not catching overflow

Paul Durrant <Paul.Durrant@citrix.com>
    xen-netback: worse-case estimate in xenvif_rx_action is underestimating

Paul Durrant <Paul.Durrant@citrix.com>
    xen-netback: remove pointless clause from if statement

Linus Torvalds <torvalds@linux-foundation.org>
    futex: avoid race between requeue and wake

Borislav Petkov <bp@suse.de>
    x86/efi: Make efi virtual runtime map passing more robust

Borislav Petkov <bp@suse.de>
    x86, pageattr: Export page unmapping interface

Paul Moore <pmoore@redhat.com>
    selinux: correctly label /proc inodes in use before the policy is loaded

Takashi Iwai <tiwai@suse.de>
    Revert "ALSA: hda - Increment default stream numbers for AMD HDMI controllers"


-------------

Diffstat:

 Makefile                                   |  4 +-
 arch/arc/boot/dts/nsimosci.dts             | 12 ++--
 arch/arc/configs/nsimosci_defconfig        |  1 +
 arch/m68k/Kconfig                          |  1 +
 arch/s390/Kconfig                          |  1 +
 arch/x86/crypto/ghash-clmulni-intel_asm.S  | 29 ---------
 arch/x86/crypto/ghash-clmulni-intel_glue.c | 14 ++++-
 arch/x86/include/asm/efi.h                 |  3 +-
 arch/x86/include/asm/pgtable_types.h       |  2 +
 arch/x86/mm/pageattr.c                     | 44 +++++++++----
 arch/x86/platform/efi/efi.c                | 99 +++++++++++++++++++++++-------
 arch/x86/platform/efi/efi_32.c             |  7 ++-
 arch/x86/platform/efi/efi_64.c             | 32 +++++++++-
 drivers/isdn/isdnloop/isdnloop.c           | 23 ++++---
 drivers/net/ethernet/cadence/at91_ether.c  |  3 +
 drivers/net/ethernet/sfc/ef10.c            |  7 +++
 drivers/net/ethernet/sfc/efx.c             |  3 +-
 drivers/net/vxlan.c                        |  6 +-
 drivers/net/wireless/iwlwifi/mvm/rs.c      | 36 +++++------
 drivers/net/xen-netback/common.h           |  5 ++
 drivers/net/xen-netback/interface.c        | 11 ++++
 drivers/net/xen-netback/netback.c          | 49 +++++++++++++--
 include/linux/futex.h                      |  4 ++
 init/Kconfig                               |  7 +++
 kernel/futex.c                             | 42 +++++++++----
 lib/nlattr.c                               | 10 ++-
 net/ipv6/icmp.c                            |  2 +-
 net/ipv6/ip6_output.c                      |  4 +-
 net/ipv6/mcast.c                           | 11 ++--
 net/ipv6/ping.c                            |  4 +-
 net/rds/iw.c                               |  3 +-
 security/selinux/hooks.c                   | 36 ++++++++---
 sound/pci/hda/hda_intel.c                  |  4 +-
 33 files changed, 370 insertions(+), 149 deletions(-)



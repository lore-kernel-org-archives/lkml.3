Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757525Ab3IEU2n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 16:28:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52162 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412Ab3IEU2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 16:28:40 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [ 00/14] 3.4.61-stable review
Date: Thu,  5 Sep 2013 13:28:11 -0700
Message-Id: <20130905202614.354156084@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.4.61 release.
There are 14 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat Sep  7 20:25:41 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.61-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.4.61-rc1

Roland Dreier <roland@purestorage.com>
    SCSI: sg: Fix user memory corruption when SG_IO is interrupted by a signal

Nicholas Bellinger <nab@linux-iscsi.org>
    target: Fix trailing ASCII space usage in INQUIRY vendor+model

Lan Tianyu <tianyu.lan@intel.com>
    ACPI / EC: Add ASUSTEK L4R to quirk list in order to validate ECDT

Stanislaw Gruszka <sgruszka@redhat.com>
    iwl4965: fix rfkill set state regression

Helmut Schaa <helmut.schaa@googlemail.com>
    ath9k_htc: Restore skb headroom when returning skb to mac80211

Trond Myklebust <Trond.Myklebust@netapp.com>
    SUNRPC: Fix memory corruption issue on 32-bit highmem systems

Imre Deak <imre.deak@intel.com>
    drm/i915: ivb: fix edp voltage swing reg val

Jakob Bornecrantz <jakob@vmware.com>
    drm/vmwgfx: Split GMR2_REMAP commands if they are to large

Russ Anderson <rja@sgi.com>
    drivers/base/memory.c: fix show_mem_removable() to handle missing sections

Paul Bolle <pebolle@tiscali.nl>
    regmap: silence GCC warning

Eugene Surovegin <ebs@ebshome.net>
    powerpc/hvsi: Increase handshake timeout from 200ms to 400ms.

Paul Mackerras <paulus@samba.org>
    powerpc: Work around gcc miscompilation of __pa() on 64-bit

Takashi Iwai <tiwai@suse.de>
    ALSA: opti9xx: Fix conflicting driver object name

Dave Kleikamp <dave.kleikamp@oracle.com>
    jfs: fix readdir cookie incompatibility with NFSv4


-------------

Diffstat:

 Makefile                                      |  4 +-
 arch/powerpc/Kconfig                          |  1 +
 arch/powerpc/include/asm/page.h               | 10 +++++
 drivers/acpi/ec.c                             |  4 ++
 drivers/base/memory.c                         |  2 +
 drivers/base/regmap/regmap.c                  |  2 +-
 drivers/gpu/drm/i915/i915_reg.h               |  2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_gmr.c           | 58 ++++++++++++++++++---------
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c | 10 +++++
 drivers/net/wireless/iwlegacy/4965-mac.c      |  2 +-
 drivers/target/target_core_cdb.c              |  9 +++--
 drivers/tty/hvc/hvsi_lib.c                    |  4 +-
 fs/bio.c                                      | 20 ++++++---
 fs/jfs/jfs_dtree.c                            | 31 ++++++++++----
 net/sunrpc/xdr.c                              |  9 +++--
 sound/isa/opti9xx/opti92x-ad1848.c            |  8 +---
 16 files changed, 125 insertions(+), 51 deletions(-)



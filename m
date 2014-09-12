Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751901AbaILOkN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 10:40:13 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:45546 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750846AbaILOkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 10:40:11 -0400
Date: Fri, 12 Sep 2014 15:39:36 +0100
From: Will Deacon <will.deacon@arm.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        catalin.marinas@arm.com
Subject: [GIT PULL] arm64: couple of fixes for -rc5
Message-ID: <20140912143936.GI6871@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please can you pull these two arm64 fixes for -rc5? The IRQ migration fix
turned up late last time and there's also a TLS leaking issue that we
just fixed for arch/arm/ too.

To keep things interesting, I've signed the tag using my Yubikey from KS.
Given that it only supports 2048-bit keys, I've used a new subkey so you
may need to update your keyring to verify the signature.

Cheers,

Will

--->8

The following changes since commit 5e39977edf6500fd12f169e6c458d33b0ef62feb:

  Revert "arm64: cpuinfo: print info for all CPUs" (2014-09-01 15:55:22 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git tags/arm64-fixes

for you to fetch changes up to eb35bdd7bca29a13c8ecd44e6fd747a84ce675db:

  arm64: flush TLS registers during exec (2014-09-11 18:34:58 +0100)

----------------------------------------------------------------
arm64 fixes for -rc5

Just a couple of stragglers here:

  - Fix an issue migrating interrupts on CPU hotplug
  - Fix a potential information leak of TLS registers across an exec
    (Nathan has sent a corresponding patch for arch/arm/ to rmk)

----------------------------------------------------------------
Sudeep Holla (1):
      arm64: use irq_set_affinity with force=false when migrating irqs

Will Deacon (1):
      arm64: flush TLS registers during exec

 arch/arm64/kernel/irq.c        | 12 ++++--------
 arch/arm64/kernel/process.c    | 18 ++++++++++++++++++
 arch/arm64/kernel/sys_compat.c |  6 ++++++
 3 files changed, 28 insertions(+), 8 deletions(-)

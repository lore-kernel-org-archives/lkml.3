Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625AbaJWROu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 13:14:50 -0400
Received: from mail-yh0-f50.google.com ([209.85.213.50]:58539 "EHLO
	mail-yh0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721AbaJWROt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 13:14:49 -0400
Date: Thu, 23 Oct 2014 11:14:45 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vineet Gupta <vgupta@synopsys.com>,
        Harvey Harrison <harvey.harrison@gmail.com>,
        John Stultz <john.stultz@linaro.org>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Richard Guy Briggs <rgb@redhat.com>
Subject: [GIT PULL] Remove weak function declarations
Message-ID: <20141023171445.GB15847@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here are some changes to fix possible issues with "weak" functions.
They're not PCI-related; I just put them in my tree to get them into
linux-next for a few days.

I don't have any problem reports for these, so they're just potential
issues at this point, but I think it's worth including these changes in
v3.18 because the current behavior is so counter-intuitive.

Bjorn


The following changes since commit f114040e3ea6e07372334ade75d1ee0775c355e1:

  Linux 3.18-rc1 (2014-10-19 18:08:38 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git tags/remove-weak-declarations

for you to fetch changes up to 271a9c35158910496f6fc3a635c2ed85df6be3d9:

  uprobes: Remove "weak" from function declarations (2014-10-22 16:14:04 -0600)

----------------------------------------------------------------
The "weak" attribute is commonly used for the default version of a
function, where an architecture can override it by providing a strong
version.

Some header file declarations included the "weak" attribute.  That's
error-prone because it causes every implementation to be weak, with no
strong version at all, and the linker chooses one based on link order.

What we want is the "weak" attribute only on the *definition* of the
default implementation.  These changes remove "weak" from the declarations,
leaving it on the default definitions.

----------------------------------------------------------------
Bjorn Helgaas (7):
      audit: Remove "weak" from audit_classify_compat_syscall() declaration
      x86, intel-mid: Remove "weak" from function declarations
      clocksource: Remove "weak" from clocksource_default_clock() declaration
      vmcore: Remove "weak" from function declarations
      kgdb: Remove "weak" from kgdb_arch_pc() declaration
      memory-hotplug: Remove "weak" from memory_block_size_bytes() declaration
      uprobes: Remove "weak" from function declarations

Vineet Gupta (1):
      ARC: kgdb: generic kgdb_arch_pc() suffices

 arch/arc/kernel/kgdb.c                             |  5 -----
 arch/x86/platform/intel-mid/intel_mid_weak_decls.h |  7 +++----
 include/linux/audit.h                              |  2 +-
 include/linux/clocksource.h                        |  2 +-
 include/linux/crash_dump.h                         | 15 +++++++--------
 include/linux/kgdb.h                               |  2 +-
 include/linux/memory.h                             |  2 +-
 include/linux/uprobes.h                            | 14 +++++++-------
 8 files changed, 21 insertions(+), 28 deletions(-)

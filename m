Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756936AbaD1VLg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 17:11:36 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46236 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755410AbaD1VLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 17:11:34 -0400
From: Joseph Salisbury <joseph.salisbury@canonical.com>
To: linux-kernel@vger.kernel.org, benh@kernel.crashing.org, paulus@samba.org
Cc: linuxppc-dev@lists.ozlabs.org, anton@samba.org
Subject: [PATCH 0/3][RFC][v1] kconfig: powerpc: Make COMMAND_LINE_SIZE a kernel config option.  Increase COMMAND_LINE_SIZE for the powerpc architecture. 
Date: Mon, 28 Apr 2014 17:11:22 -0400
Message-Id: <cover.1398287636.git.joseph.salisbury@canonical.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm sending this out as a RFC to get feedback and see which way folks would like to go.  Patch 1 of this patch set makes COMMAND_LINE_SIZE a seperate config option for each architecture.  However, an alternative to that would be to create a single default size(Possibly 2048 to satisfy patchs 2 and 3 of this patch set) for COMMAND_LINE_SIZE in ~kernel/Kconfig or ~init/Kconfig and then allow the different architecures to either bump this size up or down if needed.  

This set of changes focus on COMMAND_LINE_SIZE.  An inital patch was created to increase the size of COMMAND_LINE_SIZE for the powerpc architecture.  However, after looking at the code, it appears powerpc does not actually use the define in the ppc headers but uses the common generic default.  It seems like having COMMAND_LINE_SIZE a kernel config options is a cleaner way to modify the value, instead of going through and chaning defines.  This applies to all architectures and not just powerpc.

The powerpc architecture uses asm-generic to set the value of COMMAND_LINE_SIZE, which should be changed to a kernel config option.

The size of COMMAND_LINE_SIZE for powerpc should be longer than 512 characters, as iscsi targets and cloud-init parameters are passed through the kernel command line. 

Joseph Salisbury (3):
  kconfig: Change COMMAND_LINE_SIZE to a kernel config option, which is
    now set per architecture.
  powerpc: Change the powerpc architecture to use Kconfig to set
    COMMAND_LINE_SIZE.
  powerpc: kconfig: Increase the size of COMMAND_LINE_SIZE to 2048 from
    512 for powerpc.

 arch/alpha/Kconfig                       | 6 ++++++
 arch/alpha/include/uapi/asm/setup.h      | 4 +++-
 arch/arc/Kconfig                         | 6 ++++++
 arch/arc/include/asm/setup.h             | 4 +++-
 arch/arm/Kconfig                         | 6 ++++++
 arch/arm/include/uapi/asm/setup.h        | 4 +++-
 arch/arm64/Kconfig                       | 6 ++++++
 arch/arm64/include/uapi/asm/setup.h      | 4 +++-
 arch/avr32/Kconfig                       | 6 ++++++
 arch/avr32/include/uapi/asm/setup.h      | 4 +++-
 arch/c6x/Kconfig                         | 6 ++++++
 arch/c6x/include/uapi/asm/setup.h        | 4 +++-
 arch/cris/Kconfig                        | 6 ++++++
 arch/cris/include/uapi/asm/setup.h       | 4 +++-
 arch/frv/Kconfig                         | 6 ++++++
 arch/frv/include/uapi/asm/setup.h        | 5 +++--
 arch/ia64/Kconfig                        | 6 ++++++
 arch/ia64/include/uapi/asm/setup.h       | 4 +++-
 arch/m32r/Kconfig                        | 6 ++++++
 arch/m32r/include/uapi/asm/setup.h       | 5 +++--
 arch/m68k/Kconfig                        | 6 ++++++
 arch/m68k/include/uapi/asm/setup.h       | 4 +++-
 arch/microblaze/Kconfig                  | 6 ++++++
 arch/microblaze/include/uapi/asm/setup.h | 4 +++-
 arch/mips/Kconfig                        | 6 ++++++
 arch/mips/include/uapi/asm/setup.h       | 5 +++--
 arch/mn10300/Kconfig                     | 6 ++++++
 arch/mn10300/include/uapi/asm/param.h    | 4 +++-
 arch/parisc/Kconfig                      | 6 ++++++
 arch/parisc/include/uapi/asm/setup.h     | 4 +++-
 arch/powerpc/Kconfig                     | 6 ++++++
 arch/powerpc/boot/ops.h                  | 5 ++++-
 arch/powerpc/include/asm/setup.h         | 2 --
 arch/powerpc/include/uapi/asm/setup.h    | 1 -
 arch/s390/Kconfig                        | 6 ++++++
 arch/s390/include/uapi/asm/setup.h       | 4 +++-
 arch/score/Kconfig                       | 6 ++++++
 arch/score/include/uapi/asm/setup.h      | 5 ++++-
 arch/sparc/Kconfig                       | 7 +++++++
 arch/sparc/include/uapi/asm/setup.h      | 7 ++-----
 arch/tile/Kconfig                        | 6 ++++++
 arch/tile/include/uapi/asm/setup.h       | 5 +++--
 arch/um/Kconfig.um                       | 6 ++++++
 arch/um/include/asm/setup.h              | 4 +++-
 arch/x86/Kconfig                         | 6 ++++++
 arch/x86/include/asm/setup.h             | 4 +++-
 arch/xtensa/Kconfig                      | 6 ++++++
 arch/xtensa/include/uapi/asm/setup.h     | 4 +++-
 include/uapi/asm-generic/setup.h         | 2 +-
 49 files changed, 210 insertions(+), 35 deletions(-)
 delete mode 100644 arch/powerpc/include/uapi/asm/setup.h

-- 
1.9.1


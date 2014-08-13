Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753174AbaHMOnx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 10:43:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39623 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753066AbaHMOnu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 10:43:50 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: ebiederm@xmission.com, hpa@zytor.com, sruffell@digium.com,
        kexec@lists.infradead.org, Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH 0/2] kexec: Introduce CONFIG_KEXEC_FILE for new syscall
Date: Wed, 13 Aug 2014 10:42:58 -0400
Message-Id: <1407940980-7100-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch series introduces a new config option CONFIG_KEXEC_FILE for
the newly introduce kexec syscall (kexec_file_load()). Now all the
code for new syscall compiles only if CONFIG_KEXEC_FILE=y.

This new option currently is available only on x86_64. Other arches
can enable it as as when support is added.

There is some code in new syscall which currently requires -mcmodel=large
gcc option and that option is supported only in gcc 4.4 onwards. So
old users of gcc complained about it. Now old gcc users should be
fine as long as they don't set CONFIG_KEXEC_FILE=y.

As a new option is introduced, now CONFIG_KEXEC does not have to
select CRYPTO. So I have put in a patch to remove select CRYPTO=y
from all the arches.

Thanks
Vivek

Vivek Goyal (2):
  kexec: Create a new config option CONFIG_KEXEC_FILE for new syscall
  kexec: Remove CONFIG_KEXEC dependency on crypto

 arch/arm/Kconfig                   |  2 --
 arch/ia64/Kconfig                  |  2 --
 arch/m68k/Kconfig                  |  2 --
 arch/mips/Kconfig                  |  2 --
 arch/powerpc/Kconfig               |  2 --
 arch/s390/Kconfig                  |  2 --
 arch/sh/Kconfig                    |  2 --
 arch/tile/Kconfig                  |  2 --
 arch/x86/Kbuild                    |  4 +---
 arch/x86/Kconfig                   | 18 ++++++++++++++----
 arch/x86/Makefile                  |  5 +----
 arch/x86/kernel/Makefile           |  2 +-
 arch/x86/kernel/crash.c            |  6 ++----
 arch/x86/kernel/machine_kexec_64.c | 11 +++++++++++
 arch/x86/purgatory/Makefile        |  5 +----
 kernel/kexec.c                     | 11 +++++++++++
 16 files changed, 42 insertions(+), 36 deletions(-)

-- 
1.9.0


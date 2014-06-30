Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756733AbaF3RyM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 13:54:12 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:16886 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754860AbaF3RyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 13:54:07 -0400
From: Daniel Kiper <daniel.kiper@oracle.com>
To: linux-efi@vger.kernel.org, linux-ia64@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        xen-devel@lists.xenproject.org
Cc: andrew.cooper3@citrix.com, boris.ostrovsky@oracle.com,
        david.vrabel@citrix.com, eshelton@pobox.com, fenghua.yu@intel.com,
        hpa@zytor.com, ian.campbell@citrix.com, jbeulich@suse.com,
        jeremy@goop.org, konrad.wilk@oracle.com, matt.fleming@intel.com,
        mingo@redhat.com, mjg59@srcf.ucam.org,
        stefano.stabellini@eu.citrix.com, tglx@linutronix.de,
        tony.luck@intel.com
Subject: [PATCH v7 00/10] xen: Add EFI support
Date: Mon, 30 Jun 2014 19:52:54 +0200
Message-Id: <1404150784-27921-1-git-send-email-daniel.kiper@oracle.com>
X-Mailer: git-send-email 1.7.10.4
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

This patch series adds EFI support for Xen dom0 guests.
It is based on Jan Beulich and Tang Liang work. I was
trying to take into account all previous comments,
however, if I missed something sorry for that.

Daniel

 arch/ia64/include/asm/io.h       |    1 +
 arch/x86/kernel/setup.c          |    4 +-
 arch/x86/platform/efi/efi.c      |  106 ++++++++++--------------
 arch/x86/xen/enlighten.c         |   15 ++++
 drivers/firmware/efi/efi.c       |   25 +++---
 drivers/xen/Kconfig              |    4 +
 drivers/xen/Makefile             |    3 +
 drivers/xen/efi.c                |  368 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/efi.h              |    4 +-
 include/xen/interface/platform.h |  123 ++++++++++++++++++++++++++++
 include/xen/xen-ops.h            |   11 +++
 11 files changed, 587 insertions(+), 77 deletions(-)

Daniel Kiper (10):
      arch/ia64: Define early_memunmap()
      efi: Use early_mem*() instead of early_io*()
      arch/x86: Do not access EFI memory map if it is not available
      efi: Introduce EFI_PARAVIRT flag
      arch/x86: Remove redundant set_bit(EFI_SYSTEM_TABLES) call
      arch/x86: Remove redundant set_bit(EFI_MEMMAP) call
      xen: Define EFI related stuff
      xen: Put EFI machinery in place
      arch/x86: Replace plain strings with constants
      arch/x86: Remove efi_set_rtc_mmss()


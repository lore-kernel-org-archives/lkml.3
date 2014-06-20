Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965893AbaFTVac (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 17:30:32 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:33429 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752746AbaFTVaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 17:30:30 -0400
From: Daniel Kiper <daniel.kiper@oracle.com>
To: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        xen-devel@lists.xenproject.org
Cc: andrew.cooper3@citrix.com, boris.ostrovsky@oracle.com,
        david.vrabel@citrix.com, eshelton@pobox.com, hpa@zytor.com,
        ian.campbell@citrix.com, jbeulich@suse.com, jeremy@goop.org,
        konrad.wilk@oracle.com, matt.fleming@intel.com, mingo@redhat.com,
        mjg59@srcf.ucam.org, stefano.stabellini@eu.citrix.com,
        tglx@linutronix.de
Subject: [PATCH v6 0/9] xen: Add EFI support
Date: Fri, 20 Jun 2014 23:29:19 +0200
Message-Id: <1403299768-9955-1-git-send-email-daniel.kiper@oracle.com>
X-Mailer: git-send-email 1.7.10.4
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

This patch series adds EFI support for Xen dom0 guests.
It is based on Jan Beulich and Tang Liang work. I was
trying to take into account all previous comments,
however, if I missed something sorry for that.

Daniel

 arch/x86/kernel/setup.c          |    4 +-
 arch/x86/platform/efi/efi.c      |  106 ++++++++++--------------
 arch/x86/xen/enlighten.c         |   24 ++++++
 drivers/firmware/efi/efi.c       |   25 +++---
 drivers/xen/Kconfig              |    4 +
 drivers/xen/Makefile             |    3 +
 drivers/xen/efi.c                |  367 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/efi.h              |    4 +-
 include/xen/interface/platform.h |  123 ++++++++++++++++++++++++++++
 9 files changed, 583 insertions(+), 77 deletions(-)

Daniel Kiper (9):
      efi: Use early_mem*() instead of early_io*()
      arch/x86: Do not access EFI memory map if it is not available
      efi: Introduce EFI_PARAVIRT flag
      arch/x86: Remove redundant set_bit(EFI_SYSTEM_TABLES) call
      arch/x86: Remove redundant set_bit(EFI_MEMMAP) call
      xen: Define EFI related stuff
      xen: Put EFI machinery in place
      arch/x86: Replace plain strings with constants
      arch/x86: Remove efi_set_rtc_mmss()


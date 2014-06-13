Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921AbaFMRCl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 13:02:41 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:34135 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753821AbaFMRBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 13:01:39 -0400
From: Daniel Kiper <daniel.kiper@oracle.com>
To: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        xen-devel@lists.xenproject.org
Cc: andrew.cooper3@citrix.com, boris.ostrovsky@oracle.com,
        david.vrabel@citrix.com, eshelton@pobox.com, hpa@zytor.com,
        ian.campbell@citrix.com, jbeulich@suse.com, jeremy@goop.org,
        konrad.wilk@oracle.com, matt.fleming@intel.com, mingo@redhat.com,
        mjg59@srcf.ucam.org, stefano.stabellini@eu.citrix.com,
        tglx@linutronix.de
Subject: [PATCH v5 0/7] xen: Add EFI support
Date: Fri, 13 Jun 2014 19:00:16 +0200
Message-Id: <1402678823-24589-1-git-send-email-daniel.kiper@oracle.com>
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

 arch/x86/kernel/setup.c          |    4 +-
 arch/x86/platform/efi/efi.c      |   77 ++++++++++-------
 arch/x86/xen/enlighten.c         |   24 ++++++
 drivers/firmware/efi/efi.c       |   26 +++---
 drivers/xen/Kconfig              |    4 +
 drivers/xen/Makefile             |    3 +
 drivers/xen/efi.c                |  374 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/efi.h              |    3 +-
 include/xen/interface/platform.h |  123 +++++++++++++++++++++++++++
 9 files changed, 595 insertions(+), 43 deletions(-)

Daniel Kiper (7):
      efi: Use early_mem*() instead of early_io*()
      efi: Introduce EFI_NO_DIRECT flag
      xen: Define EFI related stuff
      xen: Put EFI machinery in place
      arch/x86: Replace plain strings with constants
      arch/x86: Remove redundant set_bit() call
      arch/x86: Comment out efi_set_rtc_mmss()


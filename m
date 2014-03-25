Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383AbaCYU66 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 16:58:58 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:28505 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754954AbaCYU6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 16:58:53 -0400
From: Daniel Kiper <daniel.kiper@oracle.com>
To: linux-efi@vger.kernel.org, linux-ia64@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        xen-devel@lists.xenproject.org
Cc: boris.ostrovsky@oracle.com, david.vrabel@citrix.com, eshelton@pobox.com,
        fenghua.yu@intel.com, hpa@zytor.com, ian.campbell@citrix.com,
        jbeulich@suse.com, jeremy@goop.org, konrad.wilk@oracle.com,
        matt.fleming@intel.com, mingo@redhat.com,
        stefano.stabellini@eu.citrix.com, tglx@linutronix.de,
        tony.luck@intel.com
Subject: [PATCH v3 0/5] xen: Add EFI support
Date: Tue, 25 Mar 2014 21:57:51 +0100
Message-Id: <1395781076-12000-1-git-send-email-daniel.kiper@oracle.com>
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

Additionally, I attempted to leave all credits as is and
put SOB in relevant places. If I made any mistake drop me
a line and I will fix it in next version.

Feel free to play with it. I am looking forward for your comments.

Daniel

 arch/ia64/kernel/efi.c           |   30 ++++--
 arch/x86/kernel/setup.c          |    2 +-
 arch/x86/platform/efi/efi.c      |   20 ++--
 arch/x86/xen/enlighten.c         |   10 ++
 drivers/firmware/efi/efi.c       |   26 ++++++
 drivers/xen/Kconfig              |    3 +
 drivers/xen/Makefile             |    1 +
 drivers/xen/efi.c                |  425 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/efi.h              |   10 ++
 include/xen/interface/platform.h |  123 +++++++++++++++++++++++-
 10 files changed, 633 insertions(+), 17 deletions(-)

Daniel Kiper (5):
      efi: Add efi_init_ops variable
      efi: Export arch_tables variable
      x86: Call efi_memblock_x86_reserve_range() on native EFI platform only
      xen: Define EFI related stuff
      xen: Put EFI machinery in place


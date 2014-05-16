Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480AbaEPUnf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 16:43:35 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:48387 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920AbaEPUne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 16:43:34 -0400
From: Daniel Kiper <daniel.kiper@oracle.com>
To: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        xen-devel@lists.xenproject.org
Cc: boris.ostrovsky@oracle.com, david.vrabel@citrix.com, eshelton@pobox.com,
        hpa@zytor.com, ian.campbell@citrix.com, jbeulich@suse.com,
        jeremy@goop.org, konrad.wilk@oracle.com, matt.fleming@intel.com,
        mingo@redhat.com, mjg59@srcf.ucam.org,
        stefano.stabellini@eu.citrix.com, tglx@linutronix.de
Subject: [PATCH v4 0/5] xen: Add EFI support
Date: Fri, 16 May 2014 22:41:39 +0200
Message-Id: <1400272904-31121-1-git-send-email-daniel.kiper@oracle.com>
X-Mailer: git-send-email 1.7.10.4
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

This patch series adds EFI support for Xen dom0 guests.
It is based on Jan Beulich and Tang Liang work. I was
trying to take into account all previous comments,
however, if I missed something sorry for that.

I am still not sure what to do with /sys/firmware/efi/config_table,
/sys/firmware/efi/{fw_vendor,runtime,systab} files. On bare metal
they contain physical addresses of relevant structures. However,
in Xen case they does not make sens. So maybe they should contain
invalid values (e.g. 0) or should not appear at all on Xen (I prefer
last one). What do you think about that?

Daniel

 arch/x86/kernel/setup.c          |    6 +-
 arch/x86/platform/efi/efi.c      |   60 ++++++++++----
 arch/x86/xen/enlighten.c         |   26 ++++++
 drivers/xen/Kconfig              |    3 +
 drivers/xen/Makefile             |    1 +
 drivers/xen/efi.c                |  374 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/efi.h              |   13 +--
 include/xen/interface/platform.h |  123 +++++++++++++++++++++++++++
 8 files changed, 582 insertions(+), 24 deletions(-)

Daniel Kiper (5):
      efi: Introduce EFI_DIRECT flag
      xen: Define EFI related stuff
      xen: Put EFI machinery in place
      arch/x86: Replace plain strings with constants
      arch/x86: Remove redundant set_bit() call


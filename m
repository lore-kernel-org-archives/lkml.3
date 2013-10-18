Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752281Ab3JRIit (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 04:38:49 -0400
Received: from mga09.intel.com ([134.134.136.24]:52104 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752096Ab3JRIil (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 04:38:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,520,1378882800"; 
   d="scan'208";a="394840257"
From: "Chen, Gong" <gong.chen@linux.intel.com>
To: tony.luck@intel.com, bp@alien8.de, joe@perches.com,
        naveen.n.rao@linux.vnet.ibm.com, m.chehab@samsung.com
Cc: arozansk@redhat.com, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/9] Extended H/W error log driver
Date: Fri, 18 Oct 2013 04:23:35 -0400
Message-Id: <1382084624-10857-1-git-send-email-gong.chen@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH v3 1/9] ACPI, APEI, CPER: Fix status check during error printing
[PATCH v3 2/9] ACPI, CPER: Update cper info
[PATCH v3 3/9] bitops: Introduce a more generic BITMASK macro
[PATCH v3 4/9] ACPI, x86: Extended error log driver for x86 platform
[PATCH v3 5/9] DMI: Parse memory device (type 17) in SMBIOS
[PATCH v3 6/9] ACPI, APEI, CPER: Add UEFI 2.4 support for memory error
[PATCH v3 7/9] ACPI, APEI, CPER: Enhance memory reporting capability
[PATCH v3 8/9] ACPI, APEI, CPER: Cleanup CPER memory error output format
[PATCH v3 9/9] EDAC, GHES: Update ghes error record info

OK, this is the 3rd version. Hope it is the last one :-).

this version just updates some minors places and apply some Ack/Review
information. In this version I remove the last patch for trace interface.
Maybe it is time to build a new RAS trace interface to integrate all
RAS related error report interfaces now.

new output format as below:

dmesg output:

[  498.485536] {1}Hardware error detected on CPU45
[  498.485616] {1}It has been corrected by h/w and requires no further action
[  498.485655] {1}event severity: corrected
[  498.485660] {1} Error 0, type: corrected
[  498.485681] {1}  section_type: memory error
[  498.485686] {1}  physical_address: 0x000000207ff1a000
[  498.485697] {1}  DIMM location: Memriser7 CHANNEL A DIMM 0
[  498.485720] {2}Hardware error detected on CPU45
[  498.485728] {2}It has been corrected by h/w and requires no further action
[  498.485735] {2}event severity: corrected
[  498.485740] {2} Error 0, type: corrected
[  498.485748] {2}  section_type: memory error


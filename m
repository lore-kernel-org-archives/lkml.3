Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592Ab3GAPiw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 11:38:52 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:37376 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754212Ab3GAPiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 11:38:51 -0400
Subject: [PATCH v3 0/3] Firmware first mode for corrected errors
To: tony.luck@intel.com, bp@alien8.de
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Cc: ananth@in.ibm.com, masbock@linux.vnet.ibm.com, lcm@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        ying.huang@intel.com
Date: Mon, 01 Jul 2013 21:08:42 +0530
Message-ID: <20130701153728.6197.14022.stgit@localhost.localdomain>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13070115-2000-0000-0000-00000CB73821
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,
Here is the updated patchset which addresses all previous review comments. For
the third patch, I have also moved the soft-offline section in ghes.c into the
#ifdef block for APEI_MEMORY_FAILURE.

If there are no further comments, can you please queue this up for 3.11?


Thanks,
Naveen

---

Naveen N. Rao (3):
      mce: acpi/apei: Honour Firmware First for MCA banks listed in APEI HEST CMC
      mce: acpi/apei: Add a boot option to disable ff mode for corrected errors
      mce, acpi/apei: Soft-offline a page on firmware GHES notification


 Documentation/x86/x86_64/boot-options.txt |    5 +++
 arch/x86/include/asm/acpi.h               |    2 +
 arch/x86/include/asm/mce.h                |    3 ++
 arch/x86/kernel/acpi/boot.c               |    5 +++
 arch/x86/kernel/cpu/mcheck/mce-internal.h |    3 ++
 arch/x86/kernel/cpu/mcheck/mce.c          |   28 +++++++++++++++
 arch/x86/kernel/cpu/mcheck/mce_intel.c    |   42 ++++++++++++++++++-----
 drivers/acpi/apei/ghes.c                  |   12 +++++++
 drivers/acpi/apei/hest.c                  |   38 +++++++++++++++++++++
 include/linux/mm.h                        |    1 +
 mm/memory-failure.c                       |   53 +++++++++++++++++++----------
 11 files changed, 164 insertions(+), 28 deletions(-)

-- 


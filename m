Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754718AbaDSCxf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 22:53:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49022 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751782AbaDSCxb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 22:53:31 -0400
From: Myron Stowe <myron.stowe@redhat.com>
Subject: [PATCH v2 0/5] x86/PCI: Add AMD hostbridge support for newer AMD
	systems
To: bhelgaas@google.com, linux-pci@vger.kernel.org
Cc: suravee.suthikulpanit@amd.com, aravind.gopalakrishnan@amd.com,
        kim.naru@amd.com, andreas.herrmann3@amd.com, daniel@numascale.com,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        bp@suse.de, sp@numascale.com, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 18 Apr 2014 20:53:08 -0600
Message-ID: <20140419025308.2408.51252.stgit@amt.stowe>
In-Reply-To: <1394053603-3724-1-git-send-email-suravee.suthikulpanit@amd.com>
References: <1394053603-3724-1-git-send-email-suravee.suthikulpanit@amd.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the kernel only supports AMD hostbridges up to Family 11h.
This causes PCI numa_node information to be reported incorrectly
for newer Families with multiple sockets.

This patch series augments the logic to discover newer AMD hostbridge types
(Family 12h, 14h 15h and 16h).

Note:
    * Patch 1 and 2 are functional changes for newer AMD Families
    * Patch 3 is general clean up and restructuring
    * Patch 4 warns when BIOS has not supplied an ACPI _PXM method for a
      hostbridge and we "guess" a hostbridge's node value
    * Patch 5 removes the now redundant 'quirk_amd_nb_node'

-v2: This series was introduced by Suravee Suthikulanit but seems to have
     stalled.  I would like to get this moving again and eventually pulled
     upstream so I've taken Suravee's series and -
       o  Rebased the original three patches to v3.15-rc1,
       o  Added a warn if we "guess" a hostbridge's node value (patch 4),
       o  I believe with the additional Family support that
	  'quirk_amd_nb_node' is now redundant so I added patch 5 which
          removes it.

Reference:
  https://bugzilla.kernel.org/show_bug.cgi?id=72051

Myron Stowe (2):
      PCI: Remove redundant 'quirk_amd_nb_node'
      ACPI/PCI: Warn if we have to "guess" host bridge node information

Suravee Suthikulpanit (3):
      x86/PCI: Miscellaneous code clean up for early_fillup_mp_bus_info
      x86/PCI: Support additional MMIO range capabilities
      x86/PCI: Add support for generic AMD hostbridges


 arch/x86/kernel/quirks.c |   58 -------
 arch/x86/pci/acpi.c      |    6 +
 arch/x86/pci/amd_bus.c   |  409 ++++++++++++++++++++++++++++++----------------
 3 files changed, 271 insertions(+), 202 deletions(-)

-- 

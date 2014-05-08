Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755266AbaEHQop (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 12:44:45 -0400
Received: from mail-bn1blp0182.outbound.protection.outlook.com ([207.46.163.182]:32379
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755128AbaEHQon (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 12:44:43 -0400
X-WSS-ID: 0N59L62-08-6SM-02
X-M-MSG: 
From: <suravee.suthikulpanit@amd.com>
To: <bhelgaas@google.com>, <linux-pci@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>,
        Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>,
        Borislav Petkov <bp@suse.de>, "Robert Richter" <rric@kernel.org>,
        Daniel J Blueman <daniel@numascale.com>,
        Andreas Herrmann <herrmann.der.user@googlemail.com>,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
Subject: [PATCH V4 0/4] x86/pci Fix numa_node info for AMD hostbridge and misc clean up.
Date: Thu, 8 May 2014 11:44:17 -0500
Message-ID: <1399567461-15928-1-git-send-email-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 1.9.0
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(6009001)(428001)(199002)(189002)(74662001)(31966008)(50986999)(92566001)(21056001)(4396001)(53416003)(89996001)(88136002)(74502001)(87936001)(97736001)(46102001)(2009001)(87286001)(15975445006)(50226001)(86152002)(20776003)(62966002)(92726001)(76482001)(36756003)(85852003)(83072002)(77982001)(64706001)(77156001)(33646001)(83322001)(81542001)(84676001)(80022001)(50466002)(47776003)(79102001)(99396002)(44976005)(101416001)(68736004)(48376002)(19580395003)(81342001)(19580405001)(93916002)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1PR02MB120;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Forefront-PRVS: 0205EDCD76
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>

This in the V4 of the patch set which trys to fixed up numa_node for AMD hostbridges.
This topic was discussed in the following threads:

V1: https://lkml.org/lkml/2014/3/5/898
V2: https://lkml.org/lkml/2014/4/18/623
V3: https://lkml.org/lkml/2014/5/7/588

Change from V3:
Split up the changes in patch1 into two per Robert's suggestions. The second patch has 
no functional change. 

Change from V2:
As requested by Bjorn, the patch set will only add supports for family15h, and 
also deprecating the mechanism, as future platforms should be relying on the ACPI info.
He has also requested to keep the changes to the minimum. Therefore, the V2 patch 2 and 3
has been removed.

Suravee Suthikulpanit (2):
  Patch1: x86/PCI: Fix PCI root numa_node info on AMD family15h
  Patch2: x86/PCI: Clean up and mark early_root_info_init as deprecated

Myron Stowe (2):
  Patch3: ACPI/PCI: Warn if we have to "guess" host bridge node information
  Patch4: X86/PCI: Remove unnecessary 'quirk_amd_nb_node'

 arch/x86/kernel/quirks.c | 58 -------------------------------------
 arch/x86/pci/acpi.c      |  6 +++-
 arch/x86/pci/amd_bus.c   | 75 +++++++++++++++++++++++++++++-------------------
 3 files changed, 51 insertions(+), 88 deletions(-)

-- 
1.9.0


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751531AbaEGS7B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 14:59:01 -0400
Received: from mail-bn1blp0186.outbound.protection.outlook.com ([207.46.163.186]:16366
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751282AbaEGS67 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 14:58:59 -0400
X-WSS-ID: 0N57WQ3-08-TP1-02
X-M-MSG: 
From: <suravee.suthikulpanit@amd.com>
To: <bhelgaas@google.com>, <linux-pci@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>,
        Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>,
        Borislav Petkov <bp@suse.de>, "Robert Richter" <rric@kernel.org>,
        Daniel J Blueman <daniel@numascale.com>,
        Andreas Herrmann <herrmann.der.user@googlemail.com>,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
Subject: [PATCH V3 0/3] x86/pci Fix numa_node info for AMD hostbridge and misc clean up.
Date: Wed, 7 May 2014 13:58:44 -0500
Message-ID: <1399489127-6961-1-git-send-email-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 1.9.0
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(6009001)(428001)(189002)(199002)(77156001)(77982001)(33646001)(81542001)(83322001)(92726001)(62966002)(76482001)(79102001)(64706001)(83072002)(36756003)(85852003)(48376002)(19580395003)(19580405001)(81342001)(68736004)(86362001)(101416001)(93916002)(80022001)(84676001)(44976005)(47776003)(50466002)(99396002)(4396001)(53416003)(88136002)(74502001)(87936001)(89996001)(31966008)(50986999)(74662001)(92566001)(15975445006)(86152002)(20776003)(50226001)(21056001)(97736001)(2009001)(87286001)(46102001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1PR02MB120;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Forefront-PRVS: 0204F0BDE2
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>

This in the V3 of the patch set which trys to fixed up numa_node for AMD hostbridges.
This topic was discussed in the following threads:

V1: https://lkml.org/lkml/2014/3/5/898
V2: https://lkml.org/lkml/2014/4/18/623

Change from V2:
As requested by Bjorn, the patch set will only add supports for family15h, and 
also deprecating the mechanism, as future platforms should be relying on the ACPI info.
He has also requested to keep the changes to the minimum. Therefore, the V2 patch 2 and 3
has been removed.

Myron Stowe (2):
  ACPI/PCI: Warn if we have to "guess" host bridge node information
  PCI: Remove unnecessary 'quirk_amd_nb_node'

Suravee Suthikulpanit (1):
  x86/PCI: Fix PCI root numa_node info on AMD family15h

 arch/x86/kernel/quirks.c | 58 -------------------------------------
 arch/x86/pci/acpi.c      |  6 +++-
 arch/x86/pci/amd_bus.c   | 75 +++++++++++++++++++++++++++++-------------------
 3 files changed, 51 insertions(+), 88 deletions(-)

-- 
1.9.0


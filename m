Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751814AbaKKTRv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 14:17:51 -0500
Received: from mail-bl2on0123.outbound.protection.outlook.com ([65.55.169.123]:21047
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751086AbaKKTRt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 14:17:49 -0500
X-WSS-ID: 0NEW2XJ-08-F9X-02
X-M-MSG: 
From: <suravee.suthikulpanit@amd.com>
To: <bhelgaas@google.com>
CC: <liviu.dudau@arm.com>, <lorenzo.pieralisi@arm.com>, <will.deacon@arm.com>,
        <linux-pci@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
Subject: [PATCH V2 0/2] PCI: generic: Assiging msi-controller to PCI hostbridge
Date: Tue, 11 Nov 2014 13:17:32 -0600
Message-ID: <1415733454-24322-1-git-send-email-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 1.9.3
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(189002)(199003)(102836001)(106466001)(33646002)(84676001)(99396003)(120916001)(44976005)(50986999)(97736003)(31966008)(19580395003)(68736004)(19580405001)(53416004)(2351001)(229853001)(107046002)(46102003)(101416001)(110136001)(36756003)(86152002)(92726001)(92566001)(86362001)(93916002)(64706001)(20776003)(47776003)(77096003)(62966003)(77156002)(4396001)(50226001)(21056001)(48376002)(50466002)(105586002)(87936001)(87286001)(89996001)(104166001)(88136002)(95666004)(41533002);DIR:OUT;SFP:1102;SCL:1;SRVR:CO1PR02MB205;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB205;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB205;
X-Forefront-PRVS: 0392679D18
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB205;
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>

This patch set introduces a new callback function to allow PCI host drivers
to specify MSI controller to be used for the child buses / devices.

This is reabased from:
    git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git pci/host-generic

Changes from V1:
    - Adding "msi-parent" device tree binding in documentation.
    - Rebase the patch to get rid of artifacts from other precursor patch
      accidently applied to the developement tree. This should now apply cleanly
      to the pci/host-generic branch.

Suravee Suthikulpanit (2):
  PCI: Add new pci_ops for setting MSI parent for PCI bus
  PCI: generic: Add set_msi_parent callback

 Documentation/devicetree/bindings/pci/host-generic-pci.txt |  3 +++
 drivers/pci/host/pci-host-generic.c                        | 13 +++++++++++++
 drivers/pci/probe.c                                        |  3 +++
 include/linux/pci.h                                        |  1 +
 4 files changed, 20 insertions(+)

-- 
1.9.3


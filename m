Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756251AbaIRTik (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 15:38:40 -0400
Received: from mail-bn1on0134.outbound.protection.outlook.com ([157.56.110.134]:39006
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751253AbaIRTij (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 15:38:39 -0400
X-Greylist: delayed 172697 seconds by postgrey-1.27 at vger.kernel.org; Thu, 18 Sep 2014 15:38:39 EDT
X-WSS-ID: 0NC43WA-07-PP8-02
X-M-MSG: 
From: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
To: <bhelgaas@google.com>, <linux-pci@vger.kernel.org>, <tglx@linutronix.de>,
        <hpa@zytor.com>, <x86@kernel.org>, <bp@suse.de>,
        <dan.carpenter@oracle.com>, <dougthompson@xmission.com>,
        <bp@alien8.de>, <m.chehab@samsung.com>, <linux-edac@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
Subject: [PATCH 0/4] Add Fam15h Model60h support
Date: Thu, 18 Sep 2014 14:56:25 -0500
Message-ID: <1411070185-10137-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
X-Mailer: git-send-email 2.0.2
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(199003)(189002)(50226001)(90102001)(77096002)(88136002)(64706001)(19580395003)(104166001)(92726001)(2201001)(229853001)(20776003)(15975445006)(101416001)(50466002)(83072002)(89996001)(48376002)(87936001)(15202345003)(95666004)(4396001)(84676001)(62966002)(77156001)(106466001)(47776003)(74662003)(85306004)(31966008)(81342003)(21056001)(87286001)(107046002)(50986999)(36756003)(79102003)(83322001)(74502003)(85852003)(15395725005)(76482002)(105586002)(92566001)(81542003)(97736003)(77982003)(93916002)(86362001)(46102003)(44976005)(68736004)(80022003)(99396002)(53416004)(921003)(1121002)(83996005)(2101003)(6606295002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR02MB197;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 033857D0BD
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Aravind.Gopalakrishnan@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series is based on top of V5 patch regarding
Modify usage of amd64_read_dct_pci_cfg().
Link: http://marc.info/?l=linux-kernel&m=141079846507232&w=2

I had started work on above one earlier and could not test this patch
series before, so ended up sending it separately. I can meld it together
if that is desired.

Summary of new features in the processor:
 - DDR4 memory support
 - DDR3 LRDIMM support
 - Support for above are in Patches 3,4 of series.

Summary of patches in this series:
 - Patch 1: Add PCI device ID definitions
 - Patch 2: Add PCI IDs to NB tables as we need to cache Northbridges
            for later use in amd64_edac
 - Patch 3: F15hM60h adds support for DDR4 and DDR3 LRDIMMS. Adding them here.
 - Patch 4: Adds bulk of the code necessary to support F15hM60h.
            Also introduces a change to dbam_to_cs mapper functions.

Aravind Gopalakrishnan (4):
  pci_ids: Add PCI device IDs for F15h M60h
  x86, amd_nb: Add device IDs to NB tables for F15h M60h
  edac: Add DDR3 LRDIMM support, entries in edac_mem_types[]
  edac, amd64_edac: Add F15h M60h support

 arch/x86/kernel/amd_nb.c  |   2 +
 drivers/edac/amd64_edac.c | 226 ++++++++++++++++++++++++++++++++--------------
 drivers/edac/amd64_edac.h |  12 ++-
 drivers/edac/edac_mc.c    |   3 +
 include/linux/edac.h      |   2 +
 include/linux/pci_ids.h   |   2 +
 6 files changed, 178 insertions(+), 69 deletions(-)

-- 
2.0.2


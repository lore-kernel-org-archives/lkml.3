Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757438AbaJaDMm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 23:12:42 -0400
Received: from mail-bn1on0114.outbound.protection.outlook.com ([157.56.110.114]:34313
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751038AbaJaDMk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 23:12:40 -0400
X-WSS-ID: 0NEAGWY-07-7WR-02
X-M-MSG: 
From: Huang Rui <ray.huang@amd.com>
To: Felipe Balbi <balbi@ti.com>, Alan Stern <stern@rowland.harvard.edu>,
        "Bjorn Helgaas" <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Paul Zimmerman <Paul.Zimmerman@synopsys.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Jason Chang <jason.chang@amd.com>, Vincent Wan <vincent.wan@amd.com>,
        Tony Li <tony.li@amd.com>, <linux-usb@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Huang Rui <ray.huang@amd.com>
Subject: [PATCH v5 0/8] usb: dwc3: add support for AMD Nolan SoC
Date: Fri, 31 Oct 2014 11:11:11 +0800
Message-ID: <1414725079-11490-1-git-send-email-ray.huang@amd.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(164054003)(199003)(189002)(48376002)(85306004)(50466002)(19580395003)(89996001)(44976005)(68736004)(85852003)(50986999)(77096002)(97736003)(53416004)(120916001)(76482002)(99396003)(101416001)(21056001)(102836001)(62966002)(107046002)(229853001)(84676001)(87286001)(87936001)(88136002)(2171001)(106466001)(105586002)(4396001)(50226001)(95666004)(36756003)(20776003)(47776003)(64706001)(77156001)(92566001)(92726001)(33646002)(80022003)(46102003)(93916002)(104166001)(86362001)(31966008);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR02MB195;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB195;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 03818C953D
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Ray.Huang@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The series of patches add AMD Nolan (NL) SoC support for DesignWare USB3
OTG IP with PCI bus glue layer. This controller supported hibernation, LPM
erratum and used the 2.80a IP version and amd own phy. Current
implementation support both simulation and SoC platform. And already tested
with gadget zero and msc tool. It works well on file storage gadget.


These patches are rebased on balbi/testing/next, and only send the rest
ones which are not applied.

Changes from v4 -> v5
- Rebase rest ones which are not applied on testing/next.
- Fix some typos.
- Add comments of hibernation patch.

Changes from v3 -> v4
- Add comment on hibernation patch
- Fix typos of commit log and comments
- Remove WARN_ON for temporary solution of FPGA board
- Rename tx deemph to tx de-emphasis
- Add documentation under Documentation/devicetree/bindings/usb/dwc3.txt
- Check FPGA flag on usb3 and usb2 suspend phy quirk
- Refine description of PCI quirk patch
- Remove amd_nl_plat flag at dwc3 structure
- Make HIRD threshold configurable

Changes from v2 -> v3
- Confirmed these quirks will be needed in product level
- Move AMD configuration patch to the last one with all quirk flags
- Make all quirks as 1-bit field instead of single-bits on a 32-bit
  variable
- Add all quirks DeviceTree counterparts
- Make LPM erratum configurable
- Add PCI ID into pci_ids.h because it will be used both on PCI and DWC3
  device driver.

Changes from v1 -> v2
- Remove dual role function temporarily
- Add pci quirk to avoid to bind with xhci driver
- Distinguish between simulation board and soc
- Break down all the special quirks


Thanks,
Rui

Huang Rui (8):
  usb: dwc3: add Tx de-emphasis quirk
  usb: dwc3: add disable usb3 suspend phy quirk
  usb: dwc3: add disable usb2 suspend phy quirk
  PCI: Add support for AMD Nolan USB3 DRD
  PCI: Prevent xHCI driver from claiming AMD Nolan USB3 DRD device
  usb: dwc3: add support for AMD Nolan platform
  usb: dwc3: make HIRD threshold configurable
  usb: dwc3: point host-mode hibernation enablement not device-mode

 Documentation/devicetree/bindings/usb/dwc3.txt |  8 ++++
 drivers/pci/quirks.c                           | 20 ++++++++++
 drivers/usb/dwc3/core.c                        | 53 +++++++++++++++++++++++++-
 drivers/usb/dwc3/core.h                        | 21 ++++++++++
 drivers/usb/dwc3/dwc3-pci.c                    | 26 +++++++++++++
 drivers/usb/dwc3/gadget.c                      |  8 +---
 drivers/usb/dwc3/platform_data.h               |  8 ++++
 include/linux/pci_ids.h                        |  1 +
 8 files changed, 138 insertions(+), 7 deletions(-)

-- 
1.9.1


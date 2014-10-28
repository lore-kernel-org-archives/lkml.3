Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755017AbaJ1Lzz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 07:55:55 -0400
Received: from mail-by2on0113.outbound.protection.outlook.com ([207.46.100.113]:13776
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754934AbaJ1Lzu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 07:55:50 -0400
X-WSS-ID: 0NE5L4R-08-OAI-02
X-M-MSG: 
From: Huang Rui <ray.huang@amd.com>
To: Felipe Balbi <balbi@ti.com>, Alan Stern <stern@rowland.harvard.edu>,
        "Bjorn Helgaas" <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Paul Zimmerman <Paul.Zimmerman@synopsys.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Jason Chang <jason.chang@amd.com>, "Vincent Wan" <vincent.wan@amd.com>,
        Tony Li <tony.li@amd.com>, <linux-usb@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Huang Rui <ray.huang@amd.com>
Subject: [PATCH v3 00/19] usb: dwc3: add support for AMD Nolan SoC
Date: Tue, 28 Oct 2014 19:54:21 +0800
Message-ID: <1414497280-3126-1-git-send-email-ray.huang@amd.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset="yes"
Content-Transfer-Encoding: 8BIT
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(164054003)(189002)(199003)(97736003)(77156001)(36756003)(229853001)(87286001)(88136002)(2171001)(89996001)(46102003)(87936001)(80022003)(21056001)(104166001)(85852003)(76482002)(120916001)(95666004)(106466001)(62966002)(53416004)(50986999)(77096002)(107046002)(105586002)(68736004)(44976005)(19580405001)(50226001)(19580395003)(4396001)(93916002)(86362001)(102836001)(33646002)(20776003)(101416001)(50466002)(92566001)(47776003)(64706001)(92726001)(84676001)(85306004)(31966008);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR02MB197;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR02MB197;
X-Forefront-PRVS: 0378F1E47A
Authentication-Results: spf=none (sender IP is 165.204.84.222)
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


These patches are generated on balbi/testing/next

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


Patch 1:
- Enable hibernation

Patch 2:
- Distinguish between simulation board and SoC

Patch 3:
- Initialize platform data at pci glue layer

Patch 4 - 16:
- Break down all the special quirks

Patch 17:
- Add PCI device ID of AMD NL USB3 DRD

Patch 18:
- Add PCI quirk to prevent DRD to bind with xHCI driver

Patch 19:
- Add support AMD NL USB3 DRD for dwc3 driver

Patch set already passed all the MSC testing on simulation board with low
clock frequency, so the speed will slower than true SoC. Detailed result
without verbose debug option is below:

root@hr-bak:/home/ray/felipe/usb-tools# ./msc.sh -o /dev/sdb1
Starting test suite: 2014年 10月 28日 星期二 19:30:28 CST
test 0a: simple 4k read/write
test  0: sent       3.91 MB read       7.18 MB/s write       6.51 MB/s ... success
test 0b: simple 8k read/write
test  0: sent       7.81 MB read      11.26 MB/s write      10.40 MB/s ... success
test 0c: simple 16k read/write
test  0: sent      15.62 MB read      14.82 MB/s write      12.41 MB/s ... success
test 0d: simple 32k read/write
test  0: sent      31.25 MB read      21.52 MB/s write      17.43 MB/s ... success
test 0e: simple 64k read/write
test  0: sent      62.50 MB read      24.14 MB/s write      19.44 MB/s ... success
test 1: simple 1-sector read/write
test  1: sent     500.00 kB read       1.19 MB/s write       1.03 MB/s ... success
test 2: simple 8-sectors read/write
test  2: sent       3.91 MB read       7.14 MB/s write       6.13 MB/s ... success
test 3: simple 32-sectors read/write
test  3: sent      15.62 MB read      15.49 MB/s write      12.25 MB/s ... success
test 4: simple 64-sectors read/write
test  4: sent      31.25 MB read      19.98 MB/s write      17.44 MB/s ... success
test 5a: scatter/gather for 2-sectors buflen 4k
test  5: sent    1000.00 kB read       2.42 MB/s write       2.15 MB/s ... success
test 5b: scatter/gather for 2-sectors buflen 8k
test  5: sent    1000.00 kB read       2.39 MB/s write       2.09 MB/s ... success
test 5c: scatter/gather for 2-sectors buflen 16k
test  5: sent    1000.00 kB read       2.37 MB/s write       1.91 MB/s ... success
test 5d: scatter/gather for 2-sectors buflen 32k
test  5: sent    1000.00 kB read       2.36 MB/s write       1.90 MB/s ... success
test 5e: scatter/gather for 2-sectors buflen 64k
test  5: sent    1000.00 kB read       2.37 MB/s write       1.88 MB/s ... success
test 6a: scatter/gather for 8-sectors buflen 4k
test  6: sent       3.91 MB read       7.08 MB/s write       6.26 MB/s ... success
test 6b: scatter/gather for 8-sectors buflen 8k
test  6: sent       3.91 MB read       7.12 MB/s write       6.35 MB/s ... success
test 6c: scatter/gather for 8-sectors buflen 16k
test  6: sent       3.91 MB read       7.11 MB/s write       6.34 MB/s ... success
test 6d: scatter/gather for 8-sectors buflen 32k
test  6: sent       3.91 MB read       7.14 MB/s write       6.30 MB/s ... success
test 6e: scatter/gather for 8-sectors buflen 64k
test  6: sent       3.91 MB read       7.13 MB/s write       6.34 MB/s ... success
test 7a: scatter/gather for 32-sectors buflen 16k
test  7: sent      15.62 MB read      15.25 MB/s write      12.48 MB/s ... success
test 7b: scatter/gather for 32-sectors buflen 32k
test  7: sent      15.62 MB read      15.36 MB/s write      12.33 MB/s ... success
test 7c: scatter/gather for 32-sectors buflen 64k
test  7: sent      15.62 MB read      15.21 MB/s write      12.01 MB/s ... success
test 8a: scatter/gather for 64-sectors buflen 32k
test  8: sent      31.25 MB read      21.46 MB/s write      17.75 MB/s ... success
test 8b: scatter/gather for 64-sectors buflen 64k
test  8: sent      31.25 MB read      20.00 MB/s write      17.37 MB/s ... success
test 9: scatter/gather for 128-sectors buflen 64k
test  9: sent      62.50 MB read      22.34 MB/s write      19.13 MB/s ... success
test 10: read over the end of the block device
test 10: sent      62.01 MB read       0.00 MB/s write       0.00 MB/s ... success
test 11: lseek past the end of the block device
test 11: sent       0.00 B read       0.00 MB/s write       0.00 MB/s ... success
test 12: write over the end of the block device
test 12: sent       0.00 B read       0.00 MB/s write       0.00 MB/s ... success
test 13: write 1 sg, read 8 random size sgs
test 13: sent      62.50 MB read      22.91 MB/s write      19.63 MB/s ... success
test 14: write 8 random size sgs, read 1 sg
test 14: sent      62.50 MB read      23.84 MB/s write      19.25 MB/s ... success
test 15: write and read 8 random size sgs
test 15: sent      62.50 MB read      23.56 MB/s write      19.07 MB/s ... success
test 16a: read with heap allocated buffer
test 16: sent      62.50 MB read      22.42 MB/s write       0.00 MB/s ... success
test 16b: read with stack allocated buffer
test 16: sent      62.50 MB read      21.77 MB/s write       0.00 MB/s ... success
test 17a: write with heap allocated buffer
test 17: sent       0.00 B read       0.00 MB/s write      20.26 MB/s ... success
test 17b: write with stack allocated buffer
test 17: sent       0.00 B read       0.00 MB/s write      21.71 MB/s ... success
test 18a: write 0x00 and read it back
test 18: sent      62.50 MB read      22.36 MB/s write      19.00 MB/s ... success
test 18b: write 0xff and read it back
test 18: sent      62.50 MB read      21.25 MB/s write      17.80 MB/s ... success
test 18c: write 0x55 and read it back
test 18: sent      62.50 MB read      24.99 MB/s write      18.85 MB/s ... success
test 18d: write 0xaa and read it back
test 18: sent      62.50 MB read      22.74 MB/s write      19.07 MB/s ... success
test 18e: write 0x11 and read it back
test 18: sent      62.50 MB read      22.81 MB/s write      19.04 MB/s ... success
test 18f: write 0x22 and read it back
test 18: sent      62.50 MB read      22.37 MB/s write      18.90 MB/s ... success
test 18g: write 0x44 and read it back
test 18: sent      62.50 MB read      22.54 MB/s write      18.91 MB/s ... success
test 18h: write 0x88 and read it back
test 18: sent      62.50 MB read      22.31 MB/s write      19.05 MB/s ... success
test 18i: write 0x33 and read it back
test 18: sent      62.50 MB read      22.55 MB/s write      18.86 MB/s ... success
test 18j: write 0x66 and read it back
test 18: sent      62.50 MB read      22.60 MB/s write      18.85 MB/s ... success
test 18k: write 0x99 and read it back
test 18: sent      62.50 MB read      22.57 MB/s write      18.86 MB/s ... success
test 18l: write 0xcc and read it back
test 18: sent      62.50 MB read      22.54 MB/s write      18.83 MB/s ... success
test 18m: write 0x77 and read it back
test 18: sent      62.50 MB read      22.80 MB/s write      18.98 MB/s ... success
test 18n: write 0xbb and read it back
test 18: sent      62.50 MB read      22.87 MB/s write      18.79 MB/s ... success
test 18o: write 0xdd and read it back
test 18: sent      62.50 MB read      22.34 MB/s write      18.99 MB/s ... success
test 18p: write 0xee and read it back
test 18: sent      62.50 MB read      24.95 MB/s write      19.33 MB/s ... success
Test suite ended: 2014年 10月 28日 星期二 19:33:50 CST

Thanks,
Rui


Huang Rui (19):
  usb: dwc3: enable hibernation if to be supported
  usb: dwc3: add a flag to check if it is fpga board
  usb: dwc3: initialize platform data at pci glue layer
  usb: dwc3: add disscramble quirk
  usb: dwc3: add lpm erratum support
  usb: dwc3: add u2exit lfps quirk
  usb: dwc3: add P3 in U2 SS inactive quirk
  usb: dwc3: add request p1p2p3 quirk
  usb: dwc3: add delay p1p2p3 quirk
  usb: dwc3: add delay phy power change quirk
  usb: dwc3: add lfps filter quirk
  usb: dwc3: add rx_detect to polling lfps quirk
  usb: dwc3: add tx demphasis quirk
  usb: dwc3: set SUSPHY bit for all cores
  usb: dwc3: add disable usb3 suspend phy quirk
  usb: dwc3: add disable usb2 suspend phy quirk
  PCI: Add support for AMD Nolan USB3 DRD
  PCI: Add quirk to prevent AMD NL USB3 DRD to bind with xHCI driver
  usb: dwc3: add support for AMD NL platform

 drivers/pci/quirks.c             |  20 +++++
 drivers/usb/dwc3/core.c          | 158 ++++++++++++++++++++++++++++++++++++++-
 drivers/usb/dwc3/core.h          |  74 +++++++++++++++---
 drivers/usb/dwc3/dwc3-pci.c      |  28 +++++++
 drivers/usb/dwc3/gadget.c        |  13 ++++
 drivers/usb/dwc3/platform_data.h |  17 +++++
 include/linux/pci_ids.h          |   1 +
 7 files changed, 300 insertions(+), 11 deletions(-)

-- 
1.9.1


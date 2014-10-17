Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751601AbaJQJNa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 05:13:30 -0400
Received: from mail-bl2on0114.outbound.protection.outlook.com ([65.55.169.114]:56493
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751231AbaJQJN1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 05:13:27 -0400
X-Greylist: delayed 818 seconds by postgrey-1.27 at vger.kernel.org; Fri, 17 Oct 2014 05:13:26 EDT
X-WSS-ID: 0NDKZMH-08-TLJ-02
X-M-MSG: 
From: Huang Rui <ray.huang@amd.com>
To: Felipe Balbi <balbi@ti.com>, Alan Stern <stern@rowland.harvard.edu>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Paul Zimmerman <Paul.Zimmerman@synopsys.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Vincent Wan <vincent.wan@amd.com>, Tony Li <tony.li@amd.com>,
        <linux-usb@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Huang Rui <ray.huang@amd.com>
Subject: [PATCH v2 00/16] usb: dwc3: add support for AMD NL SoC
Date: Fri, 17 Oct 2014 16:53:25 +0800
Message-ID: <1413536021-4886-1-git-send-email-ray.huang@amd.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset="yes"
Content-Transfer-Encoding: 8BIT
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(189002)(199003)(164054003)(97736003)(50226001)(102836001)(53416004)(92726001)(86362001)(44976005)(62966002)(31966008)(20776003)(68736004)(101416001)(19580405001)(19580395003)(47776003)(92566001)(105586002)(77096002)(93916002)(84676001)(64706001)(36756003)(229853001)(87286001)(87936001)(88136002)(85306004)(85852003)(4396001)(120916001)(104166001)(77156001)(89996001)(80022003)(46102003)(95666004)(76482002)(107046002)(50466002)(99396003)(21056001)(50986999)(33646002)(106466001)(2171001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR02MB201;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR02MB201;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0367A50BB1
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Ray.Huang@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The series of patches add AMD NL SoC support for DesignWare USB3 OTG IP with
PCI bus glue layer. This controller supported hibernation, LPM erratum and used
the 2.80a IP version and amd own phy. Current implementation support both
simulation and SoC platform. And already tested with gadget zero and msc tool.
It works well on file storage gadget.


These patches are generated on balbi/testing/next

Changes from v1 -> v2
- remove dual role function temporarily
- add pci quirk to avoid to bind with xhci driver
- distinguish between simulation board and soc
- break down all the special quirks


Patch 1:
- add PCI device id into pci bus glue

Patch 2:
- add PCI quirk to avoid to bind with xhci

Patch 3:
- enable hibernation

Patch 4:
- distinguish between simulation board and soc

Patch 5:
- add quirks flag to be compatible for kinds of soc

Patch 6 - 16:
- as felipe's suggestion, break down all the special quirks of amd nl


Patch set already passed all the MSC testing, detailed result is below:

root@hr-ub:/home/ray/felipe/usb-tools# ./msc.sh -o /dev/sdb1
Starting test suite: 2014年 10月 09日 星期四 18:02:41 CST
test 0a: simple 4k read/write
test  0: sent       3.91 MB read       0.03 MB/s write       0.03 MB/s ... success
test 0b: simple 8k read/write
test  0: sent       7.81 MB read       6.15 MB/s write       5.96 MB/s ... success
test 0c: simple 16k read/write
test  0: sent      15.62 MB read      14.30 MB/s write      12.97 MB/s ... success
test 0d: simple 32k read/write
test  0: sent      31.25 MB read      18.26 MB/s write      17.10 MB/s ... success
test 0e: simple 64k read/write
test  0: sent      62.50 MB read      22.00 MB/s write      16.33 MB/s ... success
test 1: simple 1-sector read/write
test  1: sent     500.00 kB read       1.05 MB/s write       0.93 MB/s ... success
test 2: simple 8-sectors read/write
test  2: sent       3.91 MB read       6.52 MB/s write       6.10 MB/s ... success
test 3: simple 32-sectors read/write
test  3: sent      15.62 MB read      14.33 MB/s write      13.14 MB/s ... success
test 4: simple 64-sectors read/write
test  4: sent      31.25 MB read      17.79 MB/s write      16.38 MB/s ... success
test 5a: scatter/gather for 2-sectors buflen 4k
test  5: sent    1000.00 kB read       1.85 MB/s write       1.56 MB/s ... success
test 5b: scatter/gather for 2-sectors buflen 8k
test  5: sent    1000.00 kB read       1.91 MB/s write       1.63 MB/s ... success
test 5c: scatter/gather for 2-sectors buflen 16k
test  5: sent    1000.00 kB read       1.94 MB/s write       1.62 MB/s ... success
test 5d: scatter/gather for 2-sectors buflen 32k
test  5: sent    1000.00 kB read       1.93 MB/s write       1.64 MB/s ... success
test 5e: scatter/gather for 2-sectors buflen 64k
test  5: sent    1000.00 kB read       1.96 MB/s write       1.68 MB/s ... success
test 6a: scatter/gather for 8-sectors buflen 4k
test  6: sent       3.91 MB read       6.53 MB/s write       6.05 MB/s ... success
test 6b: scatter/gather for 8-sectors buflen 8k
test  6: sent       3.91 MB read       6.56 MB/s write       5.98 MB/s ... success
test 6c: scatter/gather for 8-sectors buflen 16k
test  6: sent       3.91 MB read       6.55 MB/s write       6.15 MB/s ... success
test 6d: scatter/gather for 8-sectors buflen 32k
test  6: sent       3.91 MB read       6.51 MB/s write       6.06 MB/s ... success
test 6e: scatter/gather for 8-sectors buflen 64k
test  6: sent       3.91 MB read       6.50 MB/s write       6.06 MB/s ... success
test 7a: scatter/gather for 32-sectors buflen 16k
test  7: sent      15.62 MB read      14.23 MB/s write      12.99 MB/s ... success
test 7b: scatter/gather for 32-sectors buflen 32k
test  7: sent      15.62 MB read      14.27 MB/s write      12.91 MB/s ... success
test 7c: scatter/gather for 32-sectors buflen 64k
test  7: sent      15.62 MB read      14.73 MB/s write      13.00 MB/s ... success
test 8a: scatter/gather for 64-sectors buflen 32k
test  8: sent      31.25 MB read      18.42 MB/s write      16.65 MB/s ... success
test 8b: scatter/gather for 64-sectors buflen 64k
test  8: sent      31.25 MB read      17.70 MB/s write      16.39 MB/s ... success
test 9: scatter/gather for 128-sectors buflen 64k
test  9: sent      62.50 MB read      21.14 MB/s write      16.07 MB/s ... success
test 10: read over the end of the block device
test 10: sent      62.01 MB read       0.00 MB/s write       0.00 MB/s ... success
test 11: lseek past the end of the block device
test 11: sent       0.00 B read       0.00 MB/s write       0.00 MB/s ... success
test 12: write over the end of the block device
test 12: sent       0.00 B read       0.00 MB/s write       0.00 MB/s ... success
test 13: write 1 sg, read 8 random size sgs
test 13: sent      62.50 MB read      21.61 MB/s write      16.21 MB/s ... success
test 14: write 8 random size sgs, read 1 sg
test 14: sent      62.50 MB read      22.52 MB/s write      18.61 MB/s ... success
test 15: write and read 8 random size sgs
test 15: sent      62.50 MB read      22.31 MB/s write      19.28 MB/s ... success
test 16a: read with heap allocated buffer
test 16: sent      62.50 MB read      21.69 MB/s write       0.00 MB/s ... success
test 16b: read with stack allocated buffer
test 16: sent      62.50 MB read      21.42 MB/s write       0.00 MB/s ... success
test 17a: write with heap allocated buffer
test 17: sent       0.00 B read       0.00 MB/s write      19.94 MB/s ... success
test 17b: write with stack allocated buffer
test 17: sent       0.00 B read       0.00 MB/s write      20.09 MB/s ... success
test 18a: write 0x00 and read it back
test 18: sent      62.50 MB read      21.94 MB/s write      16.96 MB/s ... success
test 18b: write 0xff and read it back
test 18: sent      62.50 MB read      19.89 MB/s write      15.51 MB/s ... success
test 18c: write 0x55 and read it back
test 18: sent      62.50 MB read      22.00 MB/s write      16.62 MB/s ... success
test 18d: write 0xaa and read it back
test 18: sent      62.50 MB read      21.81 MB/s write      16.53 MB/s ... success
test 18e: write 0x11 and read it back
test 18: sent      62.50 MB read      22.33 MB/s write      17.00 MB/s ... success
test 18f: write 0x22 and read it back
test 18: sent      62.50 MB read      21.66 MB/s write      16.44 MB/s ... success
test 18g: write 0x44 and read it back
test 18: sent      62.50 MB read      22.23 MB/s write      17.08 MB/s ... success
test 18h: write 0x88 and read it back
test 18: sent      62.50 MB read      21.54 MB/s write      16.17 MB/s ... success
test 18i: write 0x33 and read it back
test 18: sent      62.50 MB read      21.20 MB/s write      16.58 MB/s ... success
test 18j: write 0x66 and read it back
test 18: sent      62.50 MB read      21.82 MB/s write      16.13 MB/s ... success
test 18k: write 0x99 and read it back
test 18: sent      62.50 MB read      21.92 MB/s write      16.36 MB/s ... success
test 18l: write 0xcc and read it back
test 18: sent      62.50 MB read      22.37 MB/s write      16.74 MB/s ... success
test 18m: write 0x77 and read it back
test 18: sent      62.50 MB read      22.34 MB/s write      16.24 MB/s ... success
test 18n: write 0xbb and read it back
test 18: sent      62.50 MB read      21.82 MB/s write      16.23 MB/s ... success
test 18o: write 0xdd and read it back
test 18: sent      62.50 MB read      21.38 MB/s write      16.48 MB/s ... success
test 18p: write 0xee and read it back
test 18: sent      62.50 MB read      22.33 MB/s write      16.15 MB/s ... success
Test suite ended: 2014年 10月 09日 星期四 18:13:36 CST


Thanks,
Rui

Huang Rui (16):
  usb: dwc3: add AMD NL support
  pci: quirks: add quirk to avoid AMD NL to bind with xhci
  usb: dwc3: enable hibernation if to be supported
  usb: dwc3: add a flag to check if it is fpga board
  usb: dwc3: add quirks support to be compatible for kinds of SoCs
  usb: dwc3: add disscramble quirk
  usb: dwc3: add lpm erratum support
  usb: dwc3: add u2exit lfps quirk
  usb: dwc3: add P3 in U2 SS inactive quirk
  usb: dwc3: add request p1p2p3 quirk
  usb: dwc3: add delay p1p2p3 quirk
  usb: dwc3: add delay phy power change quirk
  usb: dwc3: add lfps filter quirk
  usb: dwc3: enable rx_detect to polling lfps quirk
  usb: dwc3: add tx demphasis quirk
  usb: dwc3: enable usb suspend phy

 drivers/pci/quirks.c             | 20 ++++++++++++
 drivers/usb/dwc3/core.c          | 66 +++++++++++++++++++++++++++++++++++++++-
 drivers/usb/dwc3/core.h          | 42 +++++++++++++++++++------
 drivers/usb/dwc3/dwc3-pci.c      | 26 ++++++++++++++++
 drivers/usb/dwc3/gadget.c        |  7 +++++
 drivers/usb/dwc3/platform_data.h | 16 ++++++++++
 6 files changed, 167 insertions(+), 10 deletions(-)

-- 
1.9.1


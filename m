Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864Ab3J2Lez (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 07:34:55 -0400
Received: from co1ehsobe001.messaging.microsoft.com ([216.32.180.184]:41679
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754795Ab3J2Lew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 07:34:52 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 4
X-BigFish: VS4(zzzz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6h1082kzd2iz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah107ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1e23h1fe8h1ff5h2218h2216h1155h)
From: Bharat Bhushan <r65777@freescale.com>
To: <alex.williamson@redhat.com>, <joro@8bytes.org>,
        <galak@kernel.crashing.org>, <scottwood@freescale.com>,
        <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-pci@vger.kernel.org>, <agraf@suse.de>,
        <stuart.yoder@freescale.com>
CC: Bharat Bhushan <bharat.bhushan@freescale.com>
Subject: [PATCH 0/5 RFC] vfio/pci: add interface to for MSI support with FSL PAMU
Date: Tue, 29 Oct 2013 16:57:42 +0530
Message-ID: <1383046062-16520-6-git-send-email-Bharat.Bhushan@freescale.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1383046062-16520-1-git-send-email-Bharat.Bhushan@freescale.com>
References: <1383046062-16520-1-git-send-email-Bharat.Bhushan@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bharat Bhushan <bharat.bhushan@freescale.com>

PAMU (FSL IOMMU) has a concept of primary window and subwindows.
Primary window corresponds to the complete guest iova address space
(including MSI space), with respect to IOMMU_API this is termed as
geometry. IOVA Base of subwindow is determined from the number of
subwindows (configurable using iommu API).
MSI I/O page must be within the geometry and maximum supported
subwindows, so MSI IO-page is setup just after guest memory iova space.

So first four patches are for defining the interface to get:
  - Number of MSI regions (which is number of MSI banks for powerpc)
  - MSI-region address range: Physical page which have the
    address/addresses used for generating MSI interrupt
    and size of the page.

Last Patch is for setting up MSI iova-base for vfio devices assigned
in msi subsystem, so that when msi-message will be composed then this
configured iova will be used. Earlier we were using iommu interface
for getting the configured iova which was not currect and
Alex Williamson suggeested this type of interface.

Bharat Bhushan (5):
  pci:msi: add weak function for returning msi region info
  powerpc: pci: Add arch specific msi region interface
  powerpc: msi: Extend the msi region interface to get info from
    fsl_msi
  pci: msi: expose msi region information functions
  vfio: setup iova-base for msi interrupts for vfio assigned device

 arch/powerpc/include/asm/machdep.h |   10 ++++
 arch/powerpc/kernel/msi.c          |   28 ++++++++++
 arch/powerpc/sysdev/fsl_msi.c      |  106 ++++++++++++++++++++++++++++++++++--
 arch/powerpc/sysdev/fsl_msi.h      |   19 ++++++-
 drivers/pci/msi.c                  |   34 ++++++++++++
 include/linux/msi.h                |   14 +++++
 include/linux/pci.h                |   21 +++++++
 7 files changed, 223 insertions(+), 9 deletions(-)



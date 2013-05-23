Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759302Ab3EWUJg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 16:09:36 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:61693 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759194Ab3EWUJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 16:09:31 -0400
Date: Thu, 23 May 2013 14:09:27 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, Bin Gao <bin.gao@linux.intel.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: [GIT PULL] PCI updates for v3.10
Message-ID: <20130523200927.GA10866@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here are some more fixes for v3.10.  The Moorestown update broke Intel
Medfield devices, so I reverted it.  The acpiphp change fixes a regression:
we broke hotplug notifications to host bridges when we split acpiphp into
the host-bridge related part and the endpoint-related part.

Bjorn


The following changes since commit f722406faae2d073cc1d01063d1123c35425939e:

  Linux 3.10-rc1 (2013-05-11 17:14:08 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git tags/pci-v3.10-fixes-2

for you to fetch changes up to f3f011750a18abc389ef1b0d504fbeeacf641919:

  Revert "x86/pci/mrst: Use configuration mechanism 1 for 00:00.0, 00:02.0, 00:03.0" (2013-05-20 10:20:21 -0600)

----------------------------------------------------------------
PCI updates for v3.10:

  Moorestown
      Revert "x86/pci/mrst: Use configuration mechanism 1 for 00:00.0, 00:02.0, 00:03.0"
  Hotplug
      PCI: acpiphp: Re-enumerate devices when host bridge receives Bus Check

----------------------------------------------------------------
Bjorn Helgaas (1):
      Revert "x86/pci/mrst: Use configuration mechanism 1 for 00:00.0, 00:02.0, 00:03.0"

Yinghai Lu (1):
      PCI: acpiphp: Re-enumerate devices when host bridge receives Bus Check

 arch/x86/pci/mrst.c                | 10 ++++------
 drivers/acpi/pci_root.c            |  4 +++-
 drivers/pci/hotplug/acpiphp_glue.c | 14 ++++++++++++++
 include/linux/pci-acpi.h           |  2 ++
 4 files changed, 23 insertions(+), 7 deletions(-)

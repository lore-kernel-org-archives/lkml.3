Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932081Ab3KWBax (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 20:30:53 -0500
Received: from mga09.intel.com ([134.134.136.24]:27197 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755807Ab3KWBaw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 20:30:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,755,1378882800"; 
   d="scan'208";a="432468439"
Date: Fri, 22 Nov 2013 18:30:51 -0700
From: Jon Mason <jon.mason@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] NTB bug fixes and features for v3.13
Message-ID: <20131123013051.GC24842@jonmason-lab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,
Below are a number of NTB bug fixes and features for v3.13.  Please
consider pulling them.

Thanks,
Jon

The following changes since commit 5e01dc7b26d9f24f39abace5da98ccbd6a5ceb52:

  Linux 3.12 (2013-11-03 15:41:51 -0800)

are available in the git repository at:

  git://github.com/jonmason/ntb.git tags/ntb-3.13

for you to fetch changes up to e8aeb60c389c2aa48d345bcf717f8cb7edf67680:

  NTB: Disable interrupts and poll under high load (2013-11-20 09:57:34 -0700)

----------------------------------------------------------------
NTB driver bug fixes to address a missed call to pci_enable_msix,
NTB-RP Link Up issue, Xeon Doorbell errata workaround, ntb_transport
link down race, and correct dmaengine_get/put usage.  Also, clean-ups
to remove duplicate defines and document a hardware errata.  Finally,
some changes to improve performance.

----------------------------------------------------------------
Alexander Gordeev (1):
      ntb: Fix missed call to pci_enable_msix()

Jon Mason (7):
      NTB: Xeon Doorbell errata workaround
      NTB: Fix NTB-RP Link Up
      NTB: Fix ntb_transport link down race
      NTB: correct dmaengine_get/put usage
      NTB: Document HW errata
      NTB: Enable Snoop on Primary Side
      NTB: Disable interrupts and poll under high load

Michael Opdenacker (1):
      NTB: remove duplicate defines

 drivers/ntb/ntb_hw.c        |  121 ++++++++++++++++++++++++++++++++++++-------
 drivers/ntb/ntb_hw.h        |    7 +--
 drivers/ntb/ntb_regs.h      |   16 +++---
 drivers/ntb/ntb_transport.c |   77 ++++++++++++++-------------
 4 files changed, 156 insertions(+), 65 deletions(-)

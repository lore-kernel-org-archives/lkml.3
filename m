Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884Ab3IFAco (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 20:32:44 -0400
Received: from mga14.intel.com ([143.182.124.37]:61060 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753097Ab3IFAcm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 20:32:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,850,1371106800"; 
   d="scan'208";a="356599187"
Date: Thu, 5 Sep 2013 17:32:42 -0700
From: Jon Mason <jon.mason@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] NTB bug fixes and features for v3.12
Message-ID: <20130906003241.GB9712@jonmason-lab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,
Below are a number of NTB bug fixes and features for v3.12.  Please
consider pulling them.

Thanks,
Jon

The following changes since commit 6e4664525b1db28f8c4e1130957f70a94c19213e:

  Linux 3.11 (2013-09-02 13:46:10 -0700)

are available in the git repository at:

  git://github.com/jonmason/ntb.git tags/ntb-3.12

for you to fetch changes up to 73f47cadfe29f98c48d7fbac4dd79d3e7979ee0b:

  ntb: clean up unnecessary MSI/MSI-X capability find (2013-09-05 11:08:01 -0700)

----------------------------------------------------------------
NTB driver bug fixes to address issues in NTB-RP enablement, spad,
debugfs, and USD/DSD identification.  Add a workaround on Xeon NTB
devices for b2bdoorbell errata.  Also, add new NTB driver features to
support 32bit x86, DMA engine support, and NTB-RP support.  Finally, a
few clean-ups and update to MAINTAINERS for the NTB git tree and wiki
location.

----------------------------------------------------------------
Jon Mason (16):
      NTB: Add Error Handling in ntb_device_setup
      NTB: Correct Number of Scratch Pad Registers
      NTB: Correct USD/DSD Identification
      NTB: Correct debugfs to work with more than 1 NTB Device
      NTB: Xeon Errata Workaround
      NTB: BWD Link Recovery
      NTB: Update Device IDs
      NTB: Enable 32bit Support
      NTB: Use DMA Engine to Transmit and Receive
      NTB: Rename Variables for NTB-RP
      NTB: NTB-RP support
      NTB: Remove References of non-B2B BWD HW
      NTB: Remove unused variable
      NTB: Comment Fix
      NTB: Update Version
      MAINTAINERS: Add Website and Git Tree for NTB

Yijing Wang (1):
      ntb: clean up unnecessary MSI/MSI-X capability find

 MAINTAINERS                 |    2 +
 drivers/ntb/Kconfig         |    2 +-
 drivers/ntb/ntb_hw.c        |  501 ++++++++++++++++++++++++++++++++++---------
 drivers/ntb/ntb_hw.h        |  105 +++++++--
 drivers/ntb/ntb_regs.h      |   50 +++--
 drivers/ntb/ntb_transport.c |  422 ++++++++++++++++++++++++++++--------
 6 files changed, 855 insertions(+), 227 deletions(-)

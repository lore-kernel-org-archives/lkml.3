Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856AbaDKDKh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 23:10:37 -0400
Received: from mga01.intel.com ([192.55.52.88]:10978 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754722AbaDKDKf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 23:10:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,838,1389772800"; 
   d="scan'208";a="511275847"
Date: Thu, 10 Apr 2014 20:08:48 -0700
From: Jon Mason <jon.mason@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] NTB bug fixes and features for v3.15
Message-ID: <20140411030848.GA7169@jonmason-lab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,
Below are a number of NTB bug fixes for v3.15.  Please consider
pulling them.

Thanks,
Jon

The following changes since commit 455c6fdbd219161bd09b1165f11699d6d73de11c:

  Linux 3.14 (2014-03-30 20:40:15 -0700)

are available in the git repository at:

  git://github.com/jonmason/ntb.git tags/ntb-3.15

for you to fetch changes up to f220baad08963a75c78c80cdc1c9e9492ca0eb2a:

  ntb: Use pci_enable_msix_range() instead of pci_enable_msix() (2014-04-07 10:59:20 -0700)

----------------------------------------------------------------
NTB driver bug fixes to address issues in list traversal, skb leak in
ntb_netdev, a typo, and a leak of msix entries in the error path.
Clean ups of the event handling logic, as well as a overall style
cleanup.  Finally, the driver was converted to use the new
pci_enable_msix_range logic (and the refactoring to go along with it).

----------------------------------------------------------------
Alexander Gordeev (4):
      ntb: Fix leakage of ntb_device::msix_entries[] array
      ntb: Use pci_msix_vec_count() to obtain number of MSI-Xs
      ntb: Split ntb_setup_msix() into separate BWD/SNB routines
      ntb: Use pci_enable_msix_range() instead of pci_enable_msix()

Jon Mason (4):
      ntb_netdev: Fix list_for_each_entry exit issue
      ntb_netdev: Fix skb free issue in open
      NTB: client event cleanup
      NTB: Code Style Clean-up

Roland Dreier (1):
      NTB: Fix typo in setting one translation register

 drivers/net/ntb_netdev.c    |   27 ++++++++++++++++++-------
 drivers/ntb/ntb_hw.c        |  192 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++------------------------------------------------------------------------------
 drivers/ntb/ntb_hw.h        |    8 ++------
 drivers/ntb/ntb_transport.c |   20 +++++++++----------
 include/linux/ntb.h         |   19 +++++++++++-------
 5 files changed, 150 insertions(+), 116 deletions(-)

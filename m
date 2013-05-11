Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756616Ab3EKBaD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 21:30:03 -0400
Received: from mga02.intel.com ([134.134.136.20]:32696 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754779Ab3EKBaB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 21:30:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,651,1363158000"; 
   d="scan'208";a="311576305"
Date: Fri, 10 May 2013 18:30:00 -0700
From: Jon Mason <jon.mason@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] NTB bug fixes for v3.10
Message-ID: <20130511013000.GD14820@jonmason-lab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,
Below are a number of NTB bug fixes for v3.10.  These correct a few
Smatch/Coverity errors, as well as addressing some other issues in the
NTB driver.

Thanks,
Jon

The following changes since commit c1be5a5b1b355d40e6cf79cc979eb66dafa24ad1:

  Linux 3.9 (2013-04-28 17:36:01 -0700)

are available in the git repository at:

  https://github.com/jonmason/ntb.git for-linus

for you to fetch changes up to 877b38d4f052a2927a900eb0733ad7d749bd0d00:

  NTB: Multiple NTB client fix (2013-05-10 14:33:45 -0700)

----------------------------------------------------------------
Dan Carpenter (2):
      ntb: off by one sanity checks
      NTB: fix pointer math issues

Jon Mason (8):
      NTB: variable dereferenced before check
      NTB: Handle 64bit BAR sizes
      NTB: Link toggle memory leak
      NTB: reset tx_index on link toggle
      NTB: Correctly handle receive buffers of the minimal size
      NTB: memcpy lockup workaround
      ntb_netdev: remove from list on exit
      NTB: Multiple NTB client fix

 drivers/net/ntb_netdev.c    |    2 +
 drivers/ntb/ntb_hw.c        |   10 +--
 drivers/ntb/ntb_transport.c |  175 ++++++++++++++++++++++++++++---------------
 3 files changed, 121 insertions(+), 66 deletions(-)

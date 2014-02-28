Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753783AbaB1Rto (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 12:49:44 -0500
Received: from mga09.intel.com ([134.134.136.24]:8847 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753134AbaB1Rtl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 12:49:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,563,1389772800"; 
   d="scan'208";a="464330113"
From: "David E. Box" <david.e.box@linux.intel.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Cc: "David E. Box" <david.e.box@linux.intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, srinivas.pandruvada@linux.intel.com,
        jacob.jun.pan@intel.com
Subject: [PATCH V4 0/2] x86: IOSF: Add loadable module support
Date: Fri, 28 Feb 2014 09:47:52 -0800
Message-Id: <1393609674-2999-1-git-send-email-david.e.box@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1393443617-8923-1-git-send-email-david.e.box@linux.intel.com>
References: <1393443617-8923-1-git-send-email-david.e.box@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "David E. Box" <david.e.box@linux.intel.com>

This patch series adds missing functionalty that mostly affected loadable
modules.

The first patch adds dummy functions to allow drivers not completely
dependant on the IOSF MBI driver to compile on systems that don't have it.

The second makes MBI driver built in.

Changes from V3:

	- Code is agreed to be small enough to not warrant forcing for
	  non-EXPERT only

Changes from V2:

	- Remove non linux style externs from iosf_mbi.h

Changes from V1:

	- Force default y for non-EXPERT to allow easier custom configuration
	  as suggested by hpa <hpa@zytor.com>
	- Add WARN() to dummy functions, other than iosf_mbi_available(), to
	  signal incorrect use as suggested by Alan <gnomes@lxorguk.ukuu.org.uk>
	  Also return EPERM in these functions
	- Splits single patch into two patch series

David E. Box (2):
  x86: IOSF: add dummy functions for loadable modules
  x86: IOSF: Change IOSF_MBI Kconfig to default y

 arch/x86/Kconfig                |    6 +-----
 arch/x86/include/asm/iosf_mbi.h |   33 +++++++++++++++++++++++++++++++++
 arch/x86/kernel/iosf_mbi.c      |    6 ++++++
 3 files changed, 40 insertions(+), 5 deletions(-)

-- 
1.7.10.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753731AbaBZToW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 14:44:22 -0500
Received: from mga02.intel.com ([134.134.136.20]:4302 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753139AbaBZToU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 14:44:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,549,1389772800"; 
   d="scan'208";a="462826214"
From: "David E. Box" <david.e.box@linux.intel.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Cc: "David E. Box" <david.e.box@linux.intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, srinivas.pandruvada@linux.intel.com,
        jacob.jun.pan@intel.com
Subject: [PATCH V3 0/2] x86: IOSF: Add loadable module support
Date: Wed, 26 Feb 2014 11:40:15 -0800
Message-Id: <1393443617-8923-1-git-send-email-david.e.box@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1393296442-12942-1-git-send-email-david.e.box@linux.intel.com>
References: <1393296442-12942-1-git-send-email-david.e.box@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "David E. Box" <david.e.box@linux.intel.com>

This patch series adds missing functionalty that mostly affected loadable
modules.

The first patch adds dummy functions to allow drivers not completely
dependant on the IOSF MBI driver to compile on systems that don't have it.

The second ensures the availabilty of the MBI driver in the kernel, limiting the
possibility of requiring a rebuild when new modules needing the MBI are added.

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

 arch/x86/Kconfig                |    5 +++--
 arch/x86/include/asm/iosf_mbi.h |   33 +++++++++++++++++++++++++++++++++
 arch/x86/kernel/iosf_mbi.c      |    6 ++++++
 3 files changed, 42 insertions(+), 2 deletions(-)

-- 
1.7.10.4


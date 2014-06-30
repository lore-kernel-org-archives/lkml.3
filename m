Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067AbaF3Cwz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 22:52:55 -0400
Received: from mga14.intel.com ([192.55.52.115]:65374 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753910AbaF3Cwx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 22:52:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,573,1400050800"; 
   d="scan'208";a="555057935"
Message-ID: <53B0D0FE.4050108@linux.intel.com>
Date: Mon, 30 Jun 2014 10:52:46 +0800
From: "Li, Aubrey" <aubrey.li@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@linux.intel.com>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        Adam Williamson <awilliam@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCHv3 0/3] x86: new Intel atom SOC power management controller
 driver
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Aubrey Li <aubrey.li@linux.intel.com>

The Power Management Controller (PMC) controls many of the power
management features present in the SoC. This driver provides the power
off functionality and s0ix residency control, also provides the SOC
device state and platform sleep state observation via debugfs.

v3:
- split the driver into tree pieces: the power off functionality, the
s0ix residency control, and the debugfs exports.

v2:
- allow pmc_atom and lpc_ich to work at the same time.

Aubrey Li (3):
  X86 platform: New Intel Atom SOC power management controller driver
  x86/pmc_atom: disable a few S0ix wake up events for S0ix residency
  x86/pmc_atom: expose PMC device state and platform sleep state

 arch/x86/Kconfig                |    4 +
 arch/x86/include/asm/pmc_atom.h |  107 +++++++++++++
 arch/x86/kernel/Makefile        |    1 +
 arch/x86/kernel/pmc_atom.c      |  321
+++++++++++++++++++++++++++++++++++++++
 4 files changed, 433 insertions(+)
 create mode 100644 arch/x86/include/asm/pmc_atom.h
 create mode 100644 arch/x86/kernel/pmc_atom.c

-- 
1.7.10.4

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751470AbaJDVon (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2014 17:44:43 -0400
Received: from outbound-smtp01.blacknight.com ([81.17.249.7]:35698 "EHLO
	outbound-smtp01.blacknight.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751380AbaJDVoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2014 17:44:19 -0400
From: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, davej@redhat.com,
        hmh@hmh.eng.br
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
Subject: [PATCH v2 0/2] Fix legacy_cache detect on Intel. Add Quark to legacy_cache, document TLB quirk
Date: Sat,  4 Oct 2014 22:43:55 +0100
Message-Id: <1412459037-26089-1-git-send-email-pure.logic@nexus-software.ie>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These two patches cover four things.

First add legacy_cache callback into init_intel() to enable calling of
intel_size_cache() re-enabling detection of PIII Tualatin cache size
and allowing Quark SoC X1000 hooked into this mechanism to similarly
report it's cache size.

Second adding of Quark SoC X1000 to the legacy_cache callback so that
it too will report correct cache size. In this case a 4-way set
associative cache with a 16 byte cache line and 256 lines per tag. 

Third add the Quark SoC X1000 string so that /proc/cpuinfo gives the
correct description of the processor in the "model name" field.

Finally documentation of early TLB flushing behaviour on Quark before
cpu_has_pge() has been switched off. For clarity the existing code works
fine on Quark. This change to setup.c documents the minutiae of why.

Bryan O'Donoghue (2):
  x86: Add cpu_detect_cache_sizes() to init_intel(), add Quark to
    legacy_cache
  x86: Quark: Comment setup_arch() to document TLB/PGE behaviour

 arch/x86/kernel/cpu/intel.c | 23 +++++++++++++++++++++--
 arch/x86/kernel/setup.c     |  9 +++++++++
 2 files changed, 30 insertions(+), 2 deletions(-)

-- 
1.9.1


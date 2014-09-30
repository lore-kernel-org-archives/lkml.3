Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751436AbaI3XmH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 19:42:07 -0400
Received: from outbound-smtp05.blacknight.com ([81.17.249.38]:45952 "EHLO
	outbound-smtp05.blacknight.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750833AbaI3XmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 19:42:06 -0400
From: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, davej@redhat.com,
        hmh@hmh.eng.br
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
Subject: [PATCH 0/2] x86: Quark: Add legacy_cache_size and TLB comments
Date: Wed,  1 Oct 2014 00:41:55 +0100
Message-Id: <1412120517-14738-1-git-send-email-pure.logic@nexus-software.ie>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First patch:
Quark X1000 contains a 16k 4-way set associative unified L1 cache
with 256 sets. The second patch gets Quark X1000 reporting 16k of
cache in-line with other legacy reporting processors like PIII Tualatin

Second patch:
Adds a comment to arch/x86/kernel/setup.c. Quark SoC X1000
advertises PGE via cpuid but doesn't infact implement the functionality
to support global pages in the TLB.
Linux will by default toggle CR4.PGE for processors that advertise PGE
A fix is already in place to ensure __flush_tlb() as opposed to
__flush_tlb_all() is called during normal operation.

Since __flush_tlb() just rewrites CR3 there's no need to take any further
action on Quark after writing CR3 in setup.c to flush the TLB. We comment
that behaviour. Note cpu_has_pge() will be nuked later in the boot but,
changing the value at this phase of the boot is considered harmful and so
instead we have agreed to comment the existing code

Bryan O'Donoghue (2):
  x86: Quark: Update cache reporting, add Quark SoC X1000 string
  x86: Quark: Comment setup_arch for TLB/PGE bugfix

 arch/x86/kernel/cpu/intel.c | 20 ++++++++++++++++++--
 arch/x86/kernel/setup.c     |  9 +++++++++
 2 files changed, 27 insertions(+), 2 deletions(-)

-- 
1.9.1


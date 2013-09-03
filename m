Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933281Ab3ICTd6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 15:33:58 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:33085 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932313Ab3ICTd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 15:33:56 -0400
Message-ID: <cover.1378235372.git.cmetcalf@tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Tue, 3 Sep 2013 15:09:32 -0400
Subject: [PATCH 0/3] tile prerequisites for KVM support
To: Gleb Natapov <gleb@redhat.com>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Jan Kiszka <jan.kiszka@siemens.com>
In-Reply-To: <20130903173931.GO10142@redhat.com>
References: <52091682.8020004@siemens.com>
  <201308122037.r7CKbo99011833@farm-0021.internal.tilera.com>
  <20130825113953.GN8218@redhat.com>
  <521AAED7.4080407@tilera.com>
  <20130826120445.GD8218@redhat.com>
  <52261D26.7060206@tilera.com>
  <20130903173931.GO10142@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The KVM support for tile requires additional review that is out of scope
for 3.12, but some of the changes included with the KVM code are really
just pre-requisite reorganization or re-parameterization of existing code.
Gleb Natapov had previously requested finer-grained KVM patches, and with
an eye toward simplifying eventual code review I realized there was
more that could be split out into separate patches.

Rather than making these changes part of the eventual KVM review, I've
split them out here into some smaller pieces that don't require review
by the KVM team, since they are essentially internal rework within the
tile architecture.  This will also simplify ongoing three-way merges.

I will defer the pull request for linux-tile for a few days in case
anyone has comments on this batch of changes.

Chris Metcalf (3):
  tile: clean up relocate_kernel_64 debug code
  tile: don't assume user privilege is zero
  tile: parameterize VA and PA space more cleanly

 arch/tile/include/asm/page.h          | 52 ++++++++++++++---------------------
 arch/tile/include/asm/pgtable_32.h    |  2 +-
 arch/tile/include/asm/pgtable_64.h    |  3 +-
 arch/tile/include/asm/processor.h     |  6 ++--
 arch/tile/include/asm/ptrace.h        |  2 +-
 arch/tile/kernel/head_32.S            |  4 +--
 arch/tile/kernel/head_64.S            |  6 ++--
 arch/tile/kernel/intvec_32.S          |  6 ++--
 arch/tile/kernel/intvec_64.S          | 31 +++++++++++++++------
 arch/tile/kernel/relocate_kernel_64.S |  9 ++++--
 arch/tile/kernel/setup.c              |  8 +++---
 arch/tile/kernel/stack.c              |  2 +-
 arch/tile/kernel/traps.c              |  2 +-
 arch/tile/kernel/vmlinux.lds.S        | 10 +++----
 arch/tile/mm/fault.c                  |  4 +--
 arch/tile/mm/init.c                   |  8 +++---
 16 files changed, 81 insertions(+), 74 deletions(-)

-- 
1.8.3.1


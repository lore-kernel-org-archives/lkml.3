Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751847Ab3CTOHg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 10:07:36 -0400
Received: from mail.skyhub.de ([78.46.96.112]:41213 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750799Ab3CTOHe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 10:07:34 -0400
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 0/6] x86, cpu: Expand ->x86_capability flags with bugs bitvector, v2
Date: Wed, 20 Mar 2013 15:07:22 +0100
Message-Id: <1363788448-31325-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.1.3.535.ga923c31
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

Hi,

this is v2, with some added functionality in patches 5 and 6. It all
looks pretty straight-forward and testing it in kvm (even with lying to
the guest it is running on a Cyrix) works, as well as on bare metal.

Comments and suggestions appreciated,

Thanks.

Borislav Petkov (6):
  x86, cpu: Expand cpufeature facility to include cpu bugs
  x86, cpu: Convert F00F bug detection
  x86, cpu: Convert FDIV bug detection
  x86, cpu: Convert Cyrix coma bug detection
  x86, cpu: Convert AMD Erratum 383
  x86, cpu: Convert AMD Erratum 400

 arch/x86/include/asm/cpufeature.h | 19 +++++++++++++++++++
 arch/x86/include/asm/processor.h  | 25 +------------------------
 arch/x86/kernel/alternative.c     |  2 +-
 arch/x86/kernel/cpu/amd.c         | 31 ++++++++++++++++++++++---------
 arch/x86/kernel/cpu/bugs.c        |  7 ++++---
 arch/x86/kernel/cpu/common.c      |  4 ++++
 arch/x86/kernel/cpu/cyrix.c       |  5 +++--
 arch/x86/kernel/cpu/intel.c       |  4 ++--
 arch/x86/kernel/cpu/proc.c        |  6 +++---
 arch/x86/kernel/process.c         |  2 +-
 arch/x86/kernel/setup.c           |  2 --
 arch/x86/kvm/svm.c                |  2 +-
 arch/x86/mm/fault.c               |  2 +-
 13 files changed, 62 insertions(+), 49 deletions(-)

-- 
1.8.1.3.535.ga923c31


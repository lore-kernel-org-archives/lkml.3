Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932140AbaGaGx1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 02:53:27 -0400
Received: from mail-ig0-f177.google.com ([209.85.213.177]:49296 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756059AbaGaGxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 02:53:24 -0400
Date: Wed, 30 Jul 2014 23:53:21 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
cc: Grant Likely <grant.likely@linaro.org>, Andi Kleen <ak@linux.intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Tony Luck <tony.luck@intel.com>,
        Yinghai Lu <yinghai@kernel.org>, Len Brown <len.brown@intel.com>,
        Jiang Liu <jiang.liu@linux.intel.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: [GIT PULL] x86, apic: Cleanups of obsoleted code
Message-ID: <alpine.DEB.2.02.1407302346450.17503@chino.kir.corp.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo, Peter, and Thomas,

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/rientjes/linux.git x86/apic

  # HEAD: c11645f83e72cbfcf1841a3a821123f3254b9922 x86, apic: Remove enable_apic_mode callback

or apply individually.  This branch is based on x86/apic.

Now that I've removed the summit and es7000 subarchitectures, and Peter
was able to remove NUMAQ, quite a bit of obsoleted code has been left
behind.

This cleans up the obsoleted code and generalizes the implementation.
---
 arch/x86/include/asm/apic.h           | 34 +++--------------------------
 arch/x86/include/asm/mpspec.h         |  2 --
 arch/x86/include/asm/smpboot_hooks.h  | 10 ++++-----
 arch/x86/kernel/apic/apic.c           | 13 -----------
 arch/x86/kernel/apic/apic_flat_64.c   | 16 --------------
 arch/x86/kernel/apic/apic_noop.c      | 23 +------------------
 arch/x86/kernel/apic/apic_numachip.c  |  8 -------
 arch/x86/kernel/apic/bigsmp_32.c      | 14 ------------
 arch/x86/kernel/apic/io_apic.c        | 16 --------------
 arch/x86/kernel/apic/probe_32.c       | 33 +---------------------------
 arch/x86/kernel/apic/x2apic_cluster.c |  8 -------
 arch/x86/kernel/apic/x2apic_phys.c    |  8 -------
 arch/x86/kernel/apic/x2apic_uv_x.c    |  8 -------
 arch/x86/kernel/mpparse.c             |  3 ---
 arch/x86/kernel/smpboot.c             |  8 -------
 15 files changed, 10 insertions(+), 194 deletions(-)

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550AbaLVUIA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 15:08:00 -0500
Received: from mga02.intel.com ([134.134.136.20]:63547 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755243AbaLVUH7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 15:07:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="432280343"
Subject: [PATCH 0/2] x86, mpx: Fixes for 3.19
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, x86@kernel.org, Dave Hansen <dave@sr71.net>
From: Dave Hansen <dave@sr71.net>
Date: Mon, 22 Dec 2014 12:08:03 -0800
Message-Id: <20141222200803.D316DA2A@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Lutomirski noticed that the current 3.19 code doesn't support
32-bit binaries on 64-bit kernels, but that it is not explicitly
disabled.

I've also noticed a small performance regression that MPX was causing
in some circumstances.  The fix is simple.

 include/asm/mmu_context.h |   20 +++++++++++++++++++-
 mm/mpx.c                  |    6 ++++++
 2 files changed, 25 insertions(+), 1 deletion(-)


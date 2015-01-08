Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755652AbbAHWaP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 17:30:15 -0500
Received: from mga09.intel.com ([134.134.136.24]:40810 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754692AbbAHWaO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 17:30:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,725,1413270000"; 
   d="scan'208";a="666724143"
Subject: [PATCH 0/3] x86, mpx: Fixes for 3.19
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, x86@kernel.org, luto@amacapital.net,
        Dave Hansen <dave@sr71.net>
From: Dave Hansen <dave@sr71.net>
Date: Thu, 08 Jan 2015 14:30:18 -0800
Message-Id: <20150108223018.A57DEE63@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a resend of stuff sent shortly before the holidays,
plus an addition to the prctl() code to make it more strict
about empty arguments.

Thanks for Andi Lutomirski and Michael Kerrisk for noticing
some of this stuff.

 * Explictly disable 32-bit binaries on 64-bit kernels
 * Fix possible performance regression at unmap time
 * Be strict about enforcing empty prctl() arguments

 arch/x86/include/asm/mmu_context.h |   20 +++++++++++++++++++-
 arch/x86/mm/mpx.c                  |    6 ++++++
 kernel/sys.c                       |    4 ++++
 3 files changed, 29 insertions(+), 1 deletion(-)


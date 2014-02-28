Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751716AbaB1AS2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 19:18:28 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:51713 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbaB1AS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 19:18:26 -0500
From: Andy Lutomirski <luto@amacapital.net>
To: Stefani Seibold <stefani@seibold.net>, X86 ML <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        John Stultz <john.stultz@linaro.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        andriy.shevchenko@linux.intel.com, Martin.Runge@rohde-schwarz.com,
        Andreas.Brief@rohde-schwarz.com, Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH v2 0/4] vDSO fixes, on top of tip/x86/vdso
Date: Thu, 27 Feb 2014 16:18:11 -0800
Message-Id: <cover.1393545985.git.luto@amacapital.net>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <CALCETrW_PHbDzn2S3NyGTSk4yqYjnpJbStCuLc_yBGdfspfFCA@mail.gmail.com>
References: <CALCETrW_PHbDzn2S3NyGTSk4yqYjnpJbStCuLc_yBGdfspfFCA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'd still like someone else to confirm that the 32-bit vDSO is working
on all common configurations before I'm happy with it, but this should
be a considerable improvement.

Someone who maintains the clock code should review the changes in:

    commit 0fc8a237cbe98a06962f5ea37d24fc2369e23c74
    Author: Stefani Seibold <stefani@seibold.net>
    Date:   Wed Feb 19 10:09:10 2014 +0100
    
        x86, vdso: Add 32-bit VDSO time support for the 64-bit kernel

very carefully.

There's still something extremely questionable about VDSO_PAGES in the
32-bit vDSO code.  It appears to be terminally screwed up, and AFAICS it
only works at all because none of the 32-bit vDSO images ever exceed
4096 bytes.

Note: Patch 4 fixes a bug that's present even in -linus, so it might
make sense to send it to Linus more quickly than the rest of this
series.

Changes from v1:
 - Adjust CFLAGS instead of using asmlinkage.
 - Add more fixes.

Andy Lutomirski (4):
  x86: Use the default ABI for the 32-bit vDSO
  x86: Inline the CLOCK_MONOTONIC vdso code
  x86: Patch alternatives in the 32-bit vDSO
  x86: Zero-pad the VVAR page

 arch/x86/include/asm/vdso.h    |  2 ++
 arch/x86/kernel/vmlinux.lds.S  |  5 +++++
 arch/x86/vdso/Makefile         |  2 +-
 arch/x86/vdso/vclock_gettime.c |  2 +-
 arch/x86/vdso/vdso32-setup.c   | 25 +++++++++++++------------
 arch/x86/vdso/vma.c            |  9 ++++++---
 6 files changed, 28 insertions(+), 17 deletions(-)

-- 
1.8.5.3


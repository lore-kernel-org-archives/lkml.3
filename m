Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191AbaH1SIT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 14:08:19 -0400
Received: from chiark.greenend.org.uk ([212.13.197.229]:45734 "EHLO
	chiark.greenend.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339AbaH1SIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 14:08:18 -0400
X-Greylist: delayed 2041 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 Aug 2014 14:08:18 EDT
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <21503.26648.443061.129344@chiark.greenend.org.uk>
Date: Thu, 28 Aug 2014 18:34:16 +0100
From: David Damerell <damerell@chiark.greenend.org.uk>
To: linux-kernel@vger.kernel.org
Subject: X86_RESERVE_LOW seems not to be respected in 3.13, 3.14
X-Mailer: VM 8.1.0 under 23.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On machines running older kernels (3.5.0, 3.2.0), /proc/iomem starts:
00000000-0000ffff : reserved

On machines running newer kernels (3.13.0, 3.14.9), it starts:
00000000-00000fff : reserved

and there is output from the low memory corruption checker:
 [    0.000000] Scanning 1 areas for low memory corruption
 [    0.436639] Scanning for low memory corruption every 60 seconds

even though one would expect that with default settings it would find
the first 64K all reserved and do nothing.

The systems involved all have:
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
CONFIG_X86_RESERVE_LOW=64

If I give the argument "memmap=64K$0x00000000" to the kernel, I get
the expected /proc/iomem result and there is no output from the low
memory corruption checker.

The relevant code in arch/x86/kernel/setup.c seems to have moved from
trim_bios_range() to trim_low_memory_range() (leaving behind an orphan
comment), which means it comes much later in setup_arch(), but beyond
that I'm lost.

Apologies in advance for whatever obvious thing I am missing.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423376Ab3FUQ0A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 12:26:00 -0400
Received: from relay1.sgi.com ([192.48.179.29]:32900 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423064Ab3FUQZ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 12:25:58 -0400
From: Nathan Zimmer <nzimmer@sgi.com>
Cc: holt@sgi.com, travis@sgi.com, nzimmer@sgi.com, rob@landley.net,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        yinghai@kernel.org, akpm@linux-foundation.org,
        gregkh@linuxfoundation.org, x86@kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC 0/2] Delay initializing of large sections of memory
Date: Fri, 21 Jun 2013 11:25:32 -0500
Message-Id: <1371831934-156971-1-git-send-email-nzimmer@sgi.com>
X-Mailer: git-send-email 1.8.2.1
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This rfc patch set delays initializing large sections of memory until we have
started cpus.  This has the effect of reducing startup times on large memory
systems.  On 16TB it can take over an hour to boot and most of that time
is spent initializing memory.

We avoid that bottleneck by delaying initialization until after we have 
started multiple cpus and can initialize in a multithreaded manner.
This allows us to actually reduce boot time rather then just moving around
the point of initialization.

Mike and I have worked on this set for a while, with him doing the most of the
heavy lifting, and are eager for some feedback.

Mike Travis (2):
  x86_64, mm: Delay initializing large portion of memory
  x86_64, mm: Reinsert the absent memory

 Documentation/kernel-parameters.txt |  15 ++
 arch/x86/Kconfig                    |  10 ++
 arch/x86/include/asm/e820.h         |  16 +-
 arch/x86/kernel/e820.c              | 292 +++++++++++++++++++++++++++++++++++-
 drivers/base/memory.c               |  83 ++++++++++
 include/linux/memory.h              |   5 +
 6 files changed, 413 insertions(+), 8 deletions(-)

-- 
1.8.2.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934213Ab3ECRgU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 13:36:20 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:61403 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760761Ab3ECRgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 13:36:18 -0400
From: Will Deacon <will.deacon@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: marc.zyngier@arm.com, linux-kernel@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>
Subject: [RFC PATCH 0/2] ARM: Remove any correlation between IPC and BogoMips value
Date: Fri,  3 May 2013 18:35:45 +0100
Message-Id: <1367602547-19322-1-git-send-email-will.deacon@arm.com>
X-Mailer: git-send-email 1.8.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

This small patch set may look a little over a month late, but there is a
serious reason for posting it.

When I moved the ARM delay loop over to using the architected timers
rather than the CPU spinning loop (which has all the problems associated
with cpu frequency scaling and what-not) I thought I was doing something
useful for the port. However, it turns out that a surprising number of
people have complained, and continue to complain, about the drop in
their `BogoMIPs score'.

After some education, they usually give in, but I figured it could be
solved by removing the reporting of this number to userspace altogether.
Unfortunately, that affects the output of /proc/cpuinfo, which I'm not
comfortable changing, so instead I've written this slightly tongue-in-cheek
series reporting obviously bogus values in those fields in the hope that
people don't interpret them as anything meaningful.

Comments welcome,

Will


Will Deacon (2):
  ARM: delay: print dummy values for bogomips
  init: calibrate: don't print out bogomips value on boot

 arch/arm/Kconfig.debug  | 48 ++++++++++++++++++++++++++++++++++++++++++++++++
 arch/arm/kernel/setup.c | 16 ++++++++--------
 arch/arm/kernel/smp.c   | 13 ++-----------
 init/calibrate.c        |  8 +++-----
 4 files changed, 61 insertions(+), 24 deletions(-)

-- 
1.8.2.2


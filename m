Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933176Ab3GDVHL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 17:07:11 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:44354 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752932Ab3GDVHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 17:07:10 -0400
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/3] Get defconfig to work with ARCH=um
Date: Fri,  5 Jul 2013 02:33:14 +0530
Message-Id: <1372971797-23518-1-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.3.1.643.gebeea52.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

  $ ARCH=um make defconfig
  $ ARCH=um make

does not work on 64-bit hosts, because the build-infrastructure is
hard-wired to pick a 32-bit defconfig when ARCH=um.  This series fixes
the problem.

[1/3] is somewhat unrelated to the series, and I happened to notice it
while reading.  12783aa07 (um: Switch to large mcmodel on x86_64,
2012-01-24) indicates that I did something stupid, but I don't know
what.

Thanks.

Ramkumar Ramachandra (3):
  arch/um/Makefile: remove dead code
  arch/um/configs: add defconfig for i386, x86_64
  arch/um: migrate to using defconfig in configs/

 arch/um/Kconfig.common                          |   5 -
 arch/um/Makefile                                |  20 +-
 arch/um/{defconfig => configs/i386_defconfig}   | 209 +++++++++++++-------
 arch/um/{defconfig => configs/x86_64_defconfig} | 250 +++++++++++++++---------
 arch/x86/um/Kconfig                             |   5 +
 5 files changed, 306 insertions(+), 183 deletions(-)
 copy arch/um/{defconfig => configs/i386_defconfig} (86%)
 rename arch/um/{defconfig => configs/x86_64_defconfig} (83%)

-- 
1.8.3.1.643.gebeea52.dirty


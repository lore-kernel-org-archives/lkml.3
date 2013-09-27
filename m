Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750871Ab3I0EVm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 00:21:42 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:65308 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729Ab3I0EVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 00:21:39 -0400
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Richard Weinberger <richard@nod.at>, Ingo Molnar <mingo@redhat.com>,
        Michal Marek <mmarek@suse.cz>,
        uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 0/2] More plesant User-Mode Linux build
Date: Fri, 27 Sep 2013 09:44:45 +0530
Message-Id: <1380255287-5818-1-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.4.299.gb3e7d24.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The first patch does the meat of the work of getting rid of the
bloated i386-specific defconfig and replacing it with two tiny ones,
and updating the Makefile/ Kconfig. SUBARCH is now auto-detected
correctly, and can be overridden on the command-line. I've tested both
the x86_64 kernel with an x86_64 userland, as well as the i386 kernel
with an i386 userland.

The second patch is just a related "while we're there".

Thanks.

Ramkumar Ramachandra (2):
  arch/um: make it work with defconfig and x86_64
  um/vdso: add .gitignore for a couple of targets

 arch/um/Kconfig.common           |   5 -
 arch/um/Makefile                 |  11 +
 arch/um/configs/i386_defconfig   |  76 ++++
 arch/um/configs/x86_64_defconfig |  75 ++++
 arch/um/defconfig                | 899 ---------------------------------------
 arch/x86/um/Kconfig              |   5 +
 arch/x86/um/vdso/.gitignore      |   2 +
 7 files changed, 169 insertions(+), 904 deletions(-)
 create mode 100644 arch/um/configs/i386_defconfig
 create mode 100644 arch/um/configs/x86_64_defconfig
 delete mode 100644 arch/um/defconfig
 create mode 100644 arch/x86/um/vdso/.gitignore

-- 
1.8.4.299.gb3e7d24.dirty


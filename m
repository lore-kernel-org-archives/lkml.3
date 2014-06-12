Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751248AbaFLSrw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 14:47:52 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:61636 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbaFLSru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 14:47:50 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: <hpa@zytor.com>, Kui Zhang <kuizhang@gmail.com>
Cc: x86@kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH 0/3] vDSO reference parser updates and Go workaround
Date: Thu, 12 Jun 2014 11:47:41 -0700
Message-Id: <cover.1402598632.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patches 1 and 2 update the vDSO reference parser.

Despite the late submission, this might be 3.16 material: it's just
documentation.  If I'd been more on top of this, I would have done it
for 3.15.  It's also probably worthwhile given that there is at least
one rather buggy vDSO parser in the wild.

Patch 3 makes "Hello world" as built by Go stop segfaulting.  It's
a performance regression for Go programs: it causes them to stop
finding any symbols in the vDSO, but that's a lot better than
segfaulting.  It has big-endian issues, though, and it's ugly,
and it should probably be disabled for x32.

Andy Lutomirski (3):
  doc,vdso: Rename vdso_test.c to vdso_standalone_test_x86.c
  doc,vdso: Make vDSO examples more portable
  x86,vdso: Hack to keep 64-bit Go programs working

 Documentation/vDSO/parse_vdso.c               |  59 ++++++------
 Documentation/vDSO/vdso_standalone_test_x86.c | 128 ++++++++++++++++++++++++++
 Documentation/vDSO/vdso_test.c                | 103 +++++----------------
 arch/x86/vdso/Makefile                        |   2 +-
 arch/x86/vdso/vdso-fakesections.c             |  20 ++++
 arch/x86/vdso/vdso2c.h                        |  21 ++++-
 6 files changed, 219 insertions(+), 114 deletions(-)
 create mode 100644 Documentation/vDSO/vdso_standalone_test_x86.c
 create mode 100644 arch/x86/vdso/vdso-fakesections.c

-- 
1.9.3


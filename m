Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678AbaFMAts (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 20:49:48 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:51176 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199AbaFMAtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 20:49:45 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: <hpa@zytor.com>, Kui Zhang <kuizhang@gmail.com>
Cc: x86@kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH v2 0/3] vDSO reference parser updates and Go workaround
Date: Thu, 12 Jun 2014 17:49:38 -0700
Message-Id: <cover.1402620327.git.luto@amacapital.net>
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
segfaulting.

Changes from v1:
 - Improve portability of the vdso parser.
 - Add an explicit ELFCLASS check in the vdso parser (why not?).
 - Fix x32 build.
 - Add a comment describing what the hack works around, why, and where the
   Go bug was introduced.

Andy Lutomirski (3):
  doc,vdso: Make vDSO examples more portable
  x86,vdso: Add PUT_LE to store little-endian values
  x86,vdso: Hack to keep 64-bit Go programs working

 Documentation/vDSO/parse_vdso.c               | 67 ++++++++++++++++-----------
 Documentation/vDSO/vdso_standalone_test_x86.c | 45 ++++++++++++------
 Documentation/vDSO/vdso_test.c                | 52 +++++++++++++++++++++
 arch/x86/vdso/Makefile                        | 18 +++----
 arch/x86/vdso/vdso-fakesections.c             | 32 +++++++++++++
 arch/x86/vdso/vdso2c.c                        | 19 ++++++--
 arch/x86/vdso/vdso2c.h                        | 23 +++++++--
 7 files changed, 199 insertions(+), 57 deletions(-)
 create mode 100644 Documentation/vDSO/vdso_test.c
 create mode 100644 arch/x86/vdso/vdso-fakesections.c

-- 
1.9.3


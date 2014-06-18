Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046AbaFRXAI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 19:00:08 -0400
Received: from mail-yh0-f47.google.com ([209.85.213.47]:63148 "EHLO
	mail-yh0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755408AbaFRXAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 19:00:03 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: Josh Boyer <jwboyer@fedoraproject.org>, "H. Peter Anvin" <hpa@zytor.com>
Cc: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH 0/5] x86,vdso: Restore a bunch of section headers
Date: Wed, 18 Jun 2014 15:59:45 -0700
Message-Id: <cover.1403129369.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series makes me sad.  It brings the 64-bit vdso back above 4kB,
like it was in 3.15.  It's also just silly, but it seems to be
needed to keep binutils happy when debugging the vdso.

Patch 5 isn't really necessary, and is likely not 3.16 material.
It's useful for testing the rest of this series, though.

Andy Lutomirski (5):
  x86,vdso: Discard the __bug_table section
  x86,vdso2c: Use better macros for ELF bitness
  x86,vdso: Improve the fake section headers
  x86,vdso: Remove some redundant in-memory section headers
  x86,vdso: Create .build-id links for unstripped vdso files

 arch/x86/vdso/Makefile                   |  13 +-
 arch/x86/vdso/vdso-fakesections.c        |  41 +++----
 arch/x86/vdso/vdso-layout.lds.S          |  64 +++++++---
 arch/x86/vdso/vdso.lds.S                 |   2 +
 arch/x86/vdso/vdso2c.c                   |  73 ++++++------
 arch/x86/vdso/vdso2c.h                   | 197 ++++++++++++++++++++++++++-----
 arch/x86/vdso/vdso32/vdso-fakesections.c |   1 +
 arch/x86/vdso/vdsox32.lds.S              |   2 +
 8 files changed, 279 insertions(+), 114 deletions(-)
 create mode 100644 arch/x86/vdso/vdso32/vdso-fakesections.c

-- 
1.9.3


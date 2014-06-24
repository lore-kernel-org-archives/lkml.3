Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755040AbaFXTva (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 15:51:30 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:54231 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754421AbaFXTuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 15:50:20 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH 0/2] x86: Build fixes for tip/x86/urgent
Date: Tue, 24 Jun 2014 12:50:07 -0700
Message-Id: <cover.1403639279.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <53A9C6EB.50900@zytor.com>
References: <53A9C6EB.50900@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For reasons that I don't quite understand, the current code to
disable branch profiling in the vdso wasn't working right.  Redo it
better.

Patch 2 is a sanity check: if that error happens, then something
is wrong with the vdso.

Andy Lutomirski (2):
  x86,vdso: Move DISABLE_BRANCH_PROFILING into the vdso makefile
  x86,vdso2c: Error out if DT_RELA is present

 arch/x86/vdso/Makefile         | 4 +++-
 arch/x86/vdso/vclock_gettime.c | 3 ---
 arch/x86/vdso/vdso2c.h         | 2 +-
 3 files changed, 4 insertions(+), 5 deletions(-)

-- 
1.9.3


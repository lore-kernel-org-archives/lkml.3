Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752110AbaFXLZL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 07:25:11 -0400
Received: from mail.skyhub.de ([78.46.96.112]:36198 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750806AbaFXLZJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 07:25:09 -0400
From: Borislav Petkov <bp@alien8.de>
To: X86 ML <x86@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/3] x86, CPU: Some more cleanups and rearrangements
Date: Tue, 24 Jun 2014 13:25:02 +0200
Message-Id: <1403609105-8332-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

Hi,

some more stuff from recently:

01 adds "bugs : " line to /proc/cpuinfo to show for which hw bugs of the
current CPU the kernel knows and possibly applies a workaround.

02 is a bit big but it is basically reorganizing code around and doing
small changes like replacing cpu_has_mp with the dynamic cpu_has call so
that we can remove the former.

03 does that.

Tested on a bunch of AMD and Intel machines.

Borislav Petkov (3):
  x86, CPU: Add bug flags to /proc/cpuinfo
  x86, AMD: Cleanup init_amd
  x86, CPU: Kill cpu_has_mp

 arch/x86/include/asm/cpufeature.h |  14 +-
 arch/x86/kernel/cpu/amd.c         | 339 ++++++++++++++++++--------------------
 arch/x86/kernel/cpu/mkcapflags.sh |  51 ++++--
 arch/x86/kernel/cpu/proc.c        |   8 +
 4 files changed, 214 insertions(+), 198 deletions(-)

-- 
2.0.0


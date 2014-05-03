Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752136AbaECNEy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2014 09:04:54 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:48595 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751012AbaECNEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2014 09:04:53 -0400
Date: Sat, 3 May 2014 14:04:47 +0100
From: Matt Fleming <matt@console-pimps.org>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] EFI changes for v3.16
Message-ID: <20140503130447.GW26088@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Folks, please queue the following change for v3.16 from Borislav that
uses the more strict kernel_fpu_{begin,end}() instead of the __*
verisons that won't catch buggy use in interrupt context.

The following changes since commit e33655a386ed3b26ad36fb97a47ebb1c2ca1e928:

  efivars: Add compatibility code for compat tasks (2014-04-17 13:53:53 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-next

for you to fetch changes up to baa916f39b50ad91661534652110df40396acda0:

  x86/efi: Check for unsafe dealing with FPU state in irq ctxt (2014-05-03 06:39:25 +0100)

----------------------------------------------------------------
 * Use the more strict FPU handling functions before invoking EFI
   services to catch misuse in irq context - Borislav Petkov

----------------------------------------------------------------
Borislav Petkov (1):
      x86/efi: Check for unsafe dealing with FPU state in irq ctxt

 arch/x86/include/asm/efi.h | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

-- 
Matt Fleming, Intel Open Source Technology Center

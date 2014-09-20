Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757597AbaITVXN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 17:23:13 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:62062 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755476AbaITVXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 17:23:12 -0400
From: Mathias Krause <minipli@googlemail.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Mathias Krause <minipli@googlemail.com>
Subject: [PATCH 0/3] x86, ptdump: a EFI related fix + enhancements
Date: Sat, 20 Sep 2014 23:22:19 +0200
Message-Id: <1411248142-28951-1-git-send-email-minipli@googlemail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series slightly simplifies (patch 2) and then enhances (patch 3)
the page table dump code to respect the page table attributes of the
whole page table walk when determining the effective access rights. It
also fixes the regression that the EFI runtime service mappings are no
longer visible when CONFIG_X86_ESPFIX64 is set (patch 1).

Please apply!


Mathias Krause (3):
  x86, ptdump: Add section for EFI runtime services
  x86, ptdump: Simplify page flag evaluation code
  x86, ptdump: Take parent page flags into account

 arch/x86/include/asm/pgtable_64_types.h |    2 +
 arch/x86/mm/dump_pagetables.c           |  175 +++++++++++------------
 arch/x86/platform/efi/efi_64.c          |    3 +-
 3 files changed, 90 insertions(+), 90 deletions(-)

-- 
1.7.10.4


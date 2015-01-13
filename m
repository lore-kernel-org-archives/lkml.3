Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467AbbAMVt2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 16:49:28 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:63900 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669AbbAMVt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 16:49:26 -0500
From: Andy Lutomirski <luto@amacapital.net>
To: x86@kernel.org, linux-kernel@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH 3.19 v4 0/2] x86, mpx: Instruction decoder fixes and hardening
Date: Tue, 13 Jan 2015 13:49:18 -0800
Message-Id: <cover.1421183147.git.luto@amacapital.net>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all-

Ingo and Thomas, I think this is in decent shape for x86/urgent now
if you think it's appropriate to apply at this point in the cycle.

Changes from v3:
 - Replaced MAX_INSN_SIZE with 15 in the decoder change.  (Masami)
   I'll send the patch for 3.20 to fix MAX_INSN_SIZE separately.

Changes from v2:
 - Dropped patch 1 (fixed in tip separately)
 - Fixed comment typoes in patch 2 (noticed by Dave)

Changes from v1:
 - Dropped the TIF_IA32 change -- let's defer that until at least 3.20.
 - Fixed the MPX decode short-circuit.  v1 was buggy.
 - Patch 3 is new.  It fixes a minor regression from the MPX work.

Andy Lutomirski (2):
  x86, mpx: Short-circuit the instruction decoder for unexpected opcodes
  x86: Enforce maximum instruction size in the instruction decoder

 arch/x86/lib/insn.c |  7 +++++++
 arch/x86/mm/mpx.c   | 25 ++++++++++++++++---------
 2 files changed, 23 insertions(+), 9 deletions(-)

-- 
2.1.0


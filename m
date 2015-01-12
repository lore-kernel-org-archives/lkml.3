Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883AbbALXET (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 18:04:19 -0500
Received: from mail-yk0-f169.google.com ([209.85.160.169]:59759 "EHLO
	mail-yk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169AbbALXER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 18:04:17 -0500
From: Andy Lutomirski <luto@amacapital.net>
To: x86@kernel.org, linux-kernel@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH 3.19 v2 0/3] x86, mpx: Instruction decoder fixes and hardening
Date: Mon, 12 Jan 2015 15:04:08 -0800
Message-Id: <cover.1421103159.git.luto@amacapital.net>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all-

Sorry, this is later than I had hoped to send this.  This series has
three minor fixes for mpx and the instruction decoder.

Changes from v1:
 - Dropped the TIF_IA32 change -- let's defer that until at least 3.20.
 - Fixed the MPX decode short-circuit.  v1 was buggy.
 - Patch 3 is new.  It fixes a minor regression from the MPX work.

Andy Lutomirski (3):
  x86: Fix off-by-one in the instruction decoder length checks
  x86, mpx: Short-circuit the instruction decoder for unexpected opcodes
  x86: Enforce MAX_INSN_SIZE in the instruction decoder

 arch/x86/lib/insn.c |  9 ++++++++-
 arch/x86/mm/mpx.c   | 25 ++++++++++++++++---------
 2 files changed, 24 insertions(+), 10 deletions(-)

-- 
2.1.0


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551AbaEUWHS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 18:07:18 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:47642 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753454AbaEUWHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 18:07:14 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <bp@alien8.de>, Jiri Kosina <jkosina@suse.cz>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH 0/3] x86_64: Merge (paranoid)?(zero|error)entry(_idt)?
Date: Wed, 21 May 2014 15:07:06 -0700
Message-Id: <cover.1400709717.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Inspired by the RET vs IRET discussion, I thought about how much of a
mess the current entry macros are and I shuddered at the thought of
trying to modify them.

This little series merges them all into one idtentry macro that has
arguments that specify all the various weird behaviors.  It has a major
benefit: you can now look at the code and see how, say, the
has_error_code and !has_error_code cases differ.

Andy Lutomirski (3):
  x86_64: Add missing 'DEFAULT_FRAME 0' entry annotations
  x86_64: Merge most 64-bit asm entry macros
  x86_64: Merge paranoidzeroentry_ist into idtentry

 arch/x86/kernel/entry_64.S | 185 ++++++++++++++++++++-------------------------
 1 file changed, 80 insertions(+), 105 deletions(-)

-- 
1.9.0


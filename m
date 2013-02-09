Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932606Ab3BIVXq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 16:23:46 -0500
Received: from mail.skyhub.de ([78.46.96.112]:45049 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932571Ab3BIVXp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 16:23:45 -0500
Date: Sat, 9 Feb 2013 22:23:42 +0100
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH 5/5] x86, head_32: Remove an old gcc2 fix
Message-ID: <20130209212342.GA5556@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
References: <1360439574-16122-1-git-send-email-bp@alien8.de>
 <1360439574-16122-6-git-send-email-bp@alien8.de>
 <af2ed3e1-3ac4-421c-b1a8-bfa243327ffb@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <af2ed3e1-3ac4-421c-b1a8-bfa243327ffb@email.android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 09, 2013 at 12:52:01PM -0800, H. Peter Anvin wrote:
> However... DF should have been cleared long before this...

How about we do this at the beginning of default_entry where we clear
EFLAGS too:

diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index fc56613224c3..8b2a8a824fc6 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -322,10 +322,11 @@ default_entry:
  * debugger if this code is traced. Best to initialize before switching to
  * protected mode.
  */
-
 	pushl $0
 	popfl
 
+	cld				# GCC wants DF=0 at all times
+
 /*
  * New page tables may be in 4Mbyte page mode and may be using the global pages.
  *
--

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--

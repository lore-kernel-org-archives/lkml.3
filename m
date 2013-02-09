Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932586Ab3BIUw3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 15:52:29 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45017 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932548Ab3BIUw2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 15:52:28 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <1360439574-16122-6-git-send-email-bp@alien8.de>
References: <1360439574-16122-1-git-send-email-bp@alien8.de> <1360439574-16122-6-git-send-email-bp@alien8.de>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 5/5] x86, head_32: Remove an old gcc2 fix
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sat, 09 Feb 2013 12:51:13 -0800
To: Borislav Petkov <bp@alien8.de>
CC: X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>
Message-ID: <85fca026-9940-470c-bb76-250901557513@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ALL versions of gcc want DF=0 at all times...

Borislav Petkov <bp@alien8.de> wrote:

>From: Borislav Petkov <bp@suse.de>
>
>gcc2 wants direction flag cleared but we don't support gcc2 anymore. So
>drop it. Original patch adding this was:
>
>commit 57d40092c375d2b6d34f814f5fb306967e22c4f5
>Author: linus1 <torvalds@linuxfoundation.org>
>Date:   Mon Nov 9 12:00:00 1992 -0600
>
>    [PATCH] Linux-0.98.4 (November 9, 1992)
>...
>
>Signed-off-by: Borislav Petkov <bp@suse.de>
>---
> arch/x86/kernel/head_32.S | 1 -
> 1 file changed, 1 deletion(-)
>
>diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
>index 75e96d7e4e5f..fc56613224c3 100644
>--- a/arch/x86/kernel/head_32.S
>+++ b/arch/x86/kernel/head_32.S
>@@ -463,7 +463,6 @@ is486:
> 	xorl %eax,%eax			# Clear LDT
> 	lldt %ax
> 
>-	cld			# gcc2 wants the direction flag cleared at all times
> 	pushl $0		# fake return address for unwinder
> 	jmp *(initial_code)
> 

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751117AbaALOWU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 09:22:20 -0500
Received: from mail-we0-f171.google.com ([74.125.82.171]:44005 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921AbaALOWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 09:22:15 -0500
MIME-Version: 1.0
In-Reply-To: <20140112120305.GA13076@gmail.com>
References: <1389054026-12947-1-git-send-email-paul.gortmaker@windriver.com>
	<tip-663b55b9b39fa9c848cca273ca4e12bf29b32c71@git.kernel.org>
	<20140112120305.GA13076@gmail.com>
Date: Sun, 12 Jan 2014 15:22:14 +0100
Message-ID: <CAFLxGvwRfBy__wRJnaDEkVAUPOgPi9ud06KdT=8bRND+Tu374w@mail.gmail.com>
Subject: Re: [tip:x86/cleanups] x86: Delete non-required instances of include <linux/init.h>
From: Richard Weinberger <richard.weinberger@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, paul.gortmaker@windriver.com,
        linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 12, 2014 at 1:03 PM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * tip-bot for Paul Gortmaker <tipbot@zytor.com> wrote:
>
>> Commit-ID:  663b55b9b39fa9c848cca273ca4e12bf29b32c71
>> Gitweb:     http://git.kernel.org/tip/663b55b9b39fa9c848cca273ca4e12bf29b32c71
>> Author:     Paul Gortmaker <paul.gortmaker@windriver.com>
>> AuthorDate: Mon, 6 Jan 2014 19:20:26 -0500
>> Committer:  H. Peter Anvin <hpa@zytor.com>
>> CommitDate: Mon, 6 Jan 2014 21:25:18 -0800
>>
>> x86: Delete non-required instances of include <linux/init.h>
>>
>> None of these files are actually using any __init type directives
>> and hence don't need to include <linux/init.h>.  Most are just a
>> left over from __devinit and __cpuinit removal, or simply due to
>> code getting copied from one driver to the next.
>>
>> [ hpa: undid incorrect removal from arch/x86/kernel/head_32.S ]
>>
>> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
>> Link: http://lkml.kernel.org/r/1389054026-12947-1-git-send-email-paul.gortmaker@windriver.com
>> Signed-off-by: H. Peter Anvin <hpa@zytor.com>
>
> FYI, this patch breaks the UML build:
>
> /home/mingo/tip/arch/x86/um/vdso/vdso.S: Assembler messages:
> /home/mingo/tip/arch/x86/um/vdso/vdso.S:2: Error: no such instruction: `__initdata'
> /home/mingo/tip/arch/x86/um/vdso/vdso.S:9: Error: no such instruction: `__finit'

Thanks for reporting this Ingo!
Feel free to CC me in future too. :)

UML's vdso fails to build because it uses __INITDATA and __FINIT.

Paul, please remove that hunk from your patch.
diff --git a/arch/x86/um/vdso/vdso.S b/arch/x86/um/vdso/vdso.S
index 1cb468a..4b4bd4c 100644
--- a/arch/x86/um/vdso/vdso.S
+++ b/arch/x86/um/vdso/vdso.S
@@ -1,4 +1,3 @@
-#include <linux/init.h>

 __INITDATA

-- 
Thanks,
//richard

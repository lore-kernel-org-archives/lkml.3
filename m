Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442Ab3HVPLx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 11:11:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56891 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753341Ab3HVPLw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 11:11:52 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <1377183186-8407-3-git-send-email-jcmvbkbc@gmail.com>
References: <1377183186-8407-1-git-send-email-jcmvbkbc@gmail.com> <1377183186-8407-3-git-send-email-jcmvbkbc@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 2/3] x86: don't use echo -e needlessly
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Thu, 22 Aug 2013 17:11:22 +0200
To: Max Filippov <jcmvbkbc@gmail.com>, linux-kernel@vger.kernel.org
CC: Sam Ravnborg <sam@ravnborg.org>, Guenter Roeck <linux@roeck-us.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org
Message-ID: <233f60e2-1706-42b0-8db1-13290fb7e459@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can we drop the /bin/?

Max Filippov <jcmvbkbc@gmail.com> wrote:
>-e is not needed to output strings without escape sequences.
>
>Cc: Thomas Gleixner <tglx@linutronix.de>
>Cc: Ingo Molnar <mingo@redhat.com>
>Cc: "H. Peter Anvin" <hpa@zytor.com>
>Cc: x86@kernel.org
>Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
>---
> arch/x86/Makefile |    2 +-
> 1 files changed, 1 insertions(+), 1 deletions(-)
>
>diff --git a/arch/x86/Makefile b/arch/x86/Makefile
>index 07639c6..7386e8a 100644
>--- a/arch/x86/Makefile
>+++ b/arch/x86/Makefile
>@@ -95,7 +95,7 @@ endif
> 
> ifdef CONFIG_X86_X32
> 	x32_ld_ok := $(call try-run,\
>-			/bin/echo -e '1: .quad 1b' | \
>+			/bin/echo '1: .quad 1b' | \
> 			$(CC) $(KBUILD_AFLAGS) -c -x assembler -o "$$TMP" - && \
> 			$(OBJCOPY) -O elf32-x86-64 "$$TMP" "$$TMPO" && \
> 			$(LD) -m elf32_x86_64 "$$TMPO" -o "$$TMP",y,n)

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.

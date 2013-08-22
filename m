Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586Ab3HVPRH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 11:17:07 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:48766 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753362Ab3HVPRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 11:17:05 -0400
MIME-Version: 1.0
In-Reply-To: <233f60e2-1706-42b0-8db1-13290fb7e459@email.android.com>
References: <1377183186-8407-1-git-send-email-jcmvbkbc@gmail.com>
	<1377183186-8407-3-git-send-email-jcmvbkbc@gmail.com>
	<233f60e2-1706-42b0-8db1-13290fb7e459@email.android.com>
Date: Thu, 22 Aug 2013 19:17:04 +0400
Message-ID: <CAMo8BfJGCKO650--+7ZOPEy8S4fPzUa92S7QGRmNBxRJfg3W0Q@mail.gmail.com>
Subject: Re: [PATCH 2/3] x86: don't use echo -e needlessly
From: Max Filippov <jcmvbkbc@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Sam Ravnborg <sam@ravnborg.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 22, 2013 at 7:11 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> Can we drop the /bin/?

Sure.

> Max Filippov <jcmvbkbc@gmail.com> wrote:
>>-e is not needed to output strings without escape sequences.
>>
>>Cc: Thomas Gleixner <tglx@linutronix.de>
>>Cc: Ingo Molnar <mingo@redhat.com>
>>Cc: "H. Peter Anvin" <hpa@zytor.com>
>>Cc: x86@kernel.org
>>Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
>>---
>> arch/x86/Makefile |    2 +-
>> 1 files changed, 1 insertions(+), 1 deletions(-)
>>
>>diff --git a/arch/x86/Makefile b/arch/x86/Makefile
>>index 07639c6..7386e8a 100644
>>--- a/arch/x86/Makefile
>>+++ b/arch/x86/Makefile
>>@@ -95,7 +95,7 @@ endif
>>
>> ifdef CONFIG_X86_X32
>>       x32_ld_ok := $(call try-run,\
>>-                      /bin/echo -e '1: .quad 1b' | \
>>+                      /bin/echo '1: .quad 1b' | \
>>                       $(CC) $(KBUILD_AFLAGS) -c -x assembler -o "$$TMP" - && \
>>                       $(OBJCOPY) -O elf32-x86-64 "$$TMP" "$$TMPO" && \
>>                       $(LD) -m elf32_x86_64 "$$TMPO" -o "$$TMP",y,n)

-- 
Thanks.
-- Max

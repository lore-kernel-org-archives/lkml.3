Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753106Ab3HVPJd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 11:09:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56861 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752631Ab3HVPJc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 11:09:32 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <1377183186-8407-4-git-send-email-jcmvbkbc@gmail.com>
References: <1377183186-8407-1-git-send-email-jcmvbkbc@gmail.com> <1377183186-8407-4-git-send-email-jcmvbkbc@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 3/3] raid6/test: replace echo -e with printf
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Thu, 22 Aug 2013 17:09:11 +0200
To: Max Filippov <jcmvbkbc@gmail.com>, linux-kernel@vger.kernel.org
CC: Sam Ravnborg <sam@ravnborg.org>, Guenter Roeck <linux@roeck-us.net>,
        NeilBrown <neilb@suse.de>,
        Jim Kukunas <james.t.kukunas@linux.intel.com>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>
Message-ID: <d44b178f-0c43-483d-80f5-9791573bc526@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: H. Peter Anvin <hpa@zytor.com>

Max Filippov <jcmvbkbc@gmail.com> wrote:
>-e is a non-standard echo option, echo output is
>implementation-dependent when it is used. Replace echo -e with printf
>as
>suggested by POSIX echo manual.
>
>Cc: NeilBrown <neilb@suse.de>
>Cc: Jim Kukunas <james.t.kukunas@linux.intel.com>
>Cc: "H. Peter Anvin" <hpa@zytor.com>
>Cc: Yuanhan Liu <yuanhan.liu@linux.intel.com>
>Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
>---
> lib/raid6/test/Makefile |    2 +-
> 1 files changed, 1 insertions(+), 1 deletions(-)
>
>diff --git a/lib/raid6/test/Makefile b/lib/raid6/test/Makefile
>index 087332d..73b0151 100644
>--- a/lib/raid6/test/Makefile
>+++ b/lib/raid6/test/Makefile
>@@ -28,7 +28,7 @@ ifeq ($(IS_X86),yes)
>                     gcc -c -x assembler - >&/dev/null &&	\
>                     rm ./-.o && echo -DCONFIG_AS_AVX2=1)
> else
>-        HAS_ALTIVEC := $(shell echo -e '\#include <altivec.h>\nvector
>int a;' |\
>+        HAS_ALTIVEC := $(shell printf '\#include <altivec.h>\nvector
>int a;\n' |\
>                          gcc -c -x c - >&/dev/null && \
>                          rm ./-.o && echo yes)
>         ifeq ($(HAS_ALTIVEC),yes)

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.

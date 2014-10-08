Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624AbaJHTyw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 15:54:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43332 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754121AbaJHTyu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 15:54:50 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <1412797764-11466-1-git-send-email-pefoley2@pefoley.com>
References: <1412797764-11466-1-git-send-email-pefoley2@pefoley.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCH] Documentation: fix vdso_standalone_test_x86 on 32-bit
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Wed, 08 Oct 2014 12:54:00 -0700
To: Peter Foley <pefoley2@pefoley.com>, linux-kernel@vger.kernel.org
CC: rdunlap@infradead.org, jkosina@suse.cz, luto@amacapital.net,
        jwboyer@fedoraproject.org, linux-doc@vger.kernel.org
Message-ID: <28BDD8F7-F896-4A3E-AED8-593737A39877@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This still has the cross-build problems, no?

On October 8, 2014 12:49:24 PM PDT, Peter Foley <pefoley2@pefoley.com> wrote:
>vdso_standalone_test_x86 needs -lgcc_s to build succesfully on 32bit.
>
>Signed-off-by: Peter Foley <pefoley2@pefoley.com>
>---
> Documentation/vDSO/Makefile | 3 +++
> 1 file changed, 3 insertions(+)
>
>diff --git a/Documentation/vDSO/Makefile b/Documentation/vDSO/Makefile
>index 2b99e57..5e5ad9f 100644
>--- a/Documentation/vDSO/Makefile
>+++ b/Documentation/vDSO/Makefile
>@@ -10,3 +10,6 @@ always := $(hostprogs-y)
> HOSTCFLAGS := -I$(objtree)/usr/include -std=gnu99
>HOSTCFLAGS_vdso_standalone_test_x86.o :=
>-fno-asynchronous-unwind-tables -fno-stack-protector
> HOSTLOADLIBES_vdso_standalone_test_x86 := -nostdlib
>+ifeq($(CONFIG_X86_32),y)
>+HOSTLOADLIBES_vdso_standalone_test_x86 += -lgcc_s
>+endif

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.

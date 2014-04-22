Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755009AbaDVJm0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 05:42:26 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:33154 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753688AbaDVJmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 05:42:22 -0400
Date: Tue, 22 Apr 2014 11:42:16 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Behan Webster <behanw@converseincode.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        dwmw2@infradead.org, pageexec@freemail.hu
Subject: Re: [PATCH] x86: LLVMLinux: Wrap -mno-80387 with cc-option
Message-ID: <20140422094215.GA10813@gmail.com>
References: <1398145227-25053-1-git-send-email-behanw@converseincode.com>
 <20140422060544.GA9133@gmail.com>
 <53560AF2.8000106@converseincode.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53560AF2.8000106@converseincode.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Behan Webster <behanw@converseincode.com> wrote:

> On 04/21/14 23:05, Ingo Molnar wrote:
> >* behanw@converseincode.com <behanw@converseincode.com> wrote:
> >
> >>From: Behan Webster <behanw@converseincode.com>
> >>
> >>Wrap -mno-80387 gcc options with cc-option so they don't break clang.
> >>
> >>Signed-off-by: Behan Webster <behanw@converseincode.com>
> >>---
> >>  arch/x86/Makefile | 4 +++-
> >>  1 file changed, 3 insertions(+), 1 deletion(-)
> >>
> >>diff --git a/arch/x86/Makefile b/arch/x86/Makefile
> >>index d1b7c37..ce6ad7e 100644
> >>--- a/arch/x86/Makefile
> >>+++ b/arch/x86/Makefile
> >>@@ -83,7 +83,9 @@ else
> >>          KBUILD_CFLAGS += -m64
> >>          # Don't autogenerate traditional x87, MMX or SSE instructions
> >>-        KBUILD_CFLAGS += -mno-mmx -mno-sse -mno-80387 -mno-fp-ret-in-387
> >>+        KBUILD_CFLAGS += -mno-mmx -mno-sse
> >>+        KBUILD_CFLAGS += $(call cc-option,-mno-80387)
> >>+        KBUILD_CFLAGS += $(call cc-option,-mno-fp-ret-in-387)
> >Is there a clang equivalent option that inhibits all things FPU opcode
> >generation by the compiler?
> Not that I've found yet. Still investigating.
> 
> >That's the general purpose of -no-80387.
> Yes, I understand what this is trying to accomplish. At this point
> I'd just like this new code not to break the use of clang with
> v3.15.

Agreed.

> I will submit another patch which adds similar functionality when
> compiled with clang once I have that answer.

Thanks!

	Ingo

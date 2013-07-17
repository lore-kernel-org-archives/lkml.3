Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756876Ab3GQS5P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 14:57:15 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:41083 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756066Ab3GQS5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 14:57:13 -0400
MIME-Version: 1.0
In-Reply-To: <tip-4df05f361937ee86e5a8c9ead8aeb6a19ea9b7d7@git.kernel.org>
References: <20130716183441.GA14232@www.outflux.net>
	<tip-4df05f361937ee86e5a8c9ead8aeb6a19ea9b7d7@git.kernel.org>
Date: Wed, 17 Jul 2013 11:57:13 -0700
X-Google-Sender-Auth: zb0eHmArJ-SW5x3_THd3TnP7VGw
Message-ID: <CAE9FiQV86WdgN3+3FOSSTUvNJ6TgH4zbYkWOS7EPPHwO2Rf2TQ@mail.gmail.com>
Subject: Re: [tip:x86/urgent] x86: Make sure IDT is page aligned
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>, PaX Team <pageexec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Cc: "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 16, 2013 at 3:33 PM, tip-bot for Kees Cook <tipbot@zytor.com> wrote:
> Commit-ID:  4df05f361937ee86e5a8c9ead8aeb6a19ea9b7d7
> Gitweb:     http://git.kernel.org/tip/4df05f361937ee86e5a8c9ead8aeb6a19ea9b7d7
> Author:     Kees Cook <keescook@chromium.org>
> AuthorDate: Tue, 16 Jul 2013 11:34:41 -0700
> Committer:  H. Peter Anvin <hpa@linux.intel.com>
> CommitDate: Tue, 16 Jul 2013 15:14:48 -0700
>
> x86: Make sure IDT is page aligned
>
> Since the IDT is referenced from a fixmap, make sure it is page aligned.
> Merge with 32-bit one, since it was already aligned to deal with F00F
> bug. Since bss is cleared before IDT setup, it can live there. This also
> moves the other *_idt_table variables into common locations.
>
> This avoids the risk of the IDT ever being moved in the bss and having
> the mapping be offset, resulting in calling incorrect handlers. In the
> current upstream kernel this is not a manifested bug, but heavily patched
> kernels (such as those using the PaX patch series) did encounter this bug.
>
> The tables other than idt_table technically do not need to be page
> aligned, at least not at the current time, but using a common
> declaration avoids mistakes.  On 64 bits the table is exactly one page
> long, anyway.
>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Link: http://lkml.kernel.org/r/20130716183441.GA14232@www.outflux.net
> Reported-by: PaX Team <pageexec@gmail.com>
> Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>

Hi, Peter,

Any reason for why following changelog get dropped?

---
v5:
 - add comments to all IDTs about alignment reasoning, suggested by Linus
v4:
 - rework using __page_aligned_bss, suggested by Yinghai LU
 - move all the other IDT variables as well, suggested by HPA
v3:
 - merge 32-bit and 64-bit idt_table definition
v2:
 - 32-bit was already aligned
---

That at least would help us to check if you apply the right version.

Yinghai

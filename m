Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161756Ab3DEHN2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 03:13:28 -0400
Received: from mail-bk0-f49.google.com ([209.85.214.49]:58152 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204Ab3DEHN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 03:13:27 -0400
Date: Fri, 5 Apr 2013 09:13:22 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Jarkko Sakkinen <jarkko.sakkinen@intel.com>,
        Matthew Garrett <mjg@redhat.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Eric Northup <digitaleric@google.com>,
        Dan Rosenberg <drosenberg@vsecurity.com>,
        Julien Tinnes <jln@google.com>, Will Drewry <wad@chromium.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 2/3] x86: build reloc tool for both 64 and 32 bit
Message-ID: <20130405071322.GC26889@gmail.com>
References: <1365106055-22939-1-git-send-email-keescook@chromium.org>
 <1365106055-22939-3-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365106055-22939-3-git-send-email-keescook@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Kees Cook <keescook@chromium.org> wrote:

> Add logic for 64-bit kernel relocations. Since there is no need to
> handle 32 and 64 bit at the same time, refactor away most of the 32/64
> bit ELF differences and split the build into producing two separate
> binaries. Additionally switches to using realloc instead of a two-pass
> approach.
> 
> Heavily based on work by Neill Clift and Michael Davidson.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Cc: Eric Northup <digitaleric@google.com>
> ---
>  arch/x86/boot/compressed/Makefile |    2 +-
>  arch/x86/realmode/rm/Makefile     |    2 +-
>  arch/x86/tools/.gitignore         |    3 +-
>  arch/x86/tools/Makefile           |   14 +-
>  arch/x86/tools/relocs.c           |  717 ++++++++++++++++++++++++++-----------
>  arch/x86/tools/relocs_32.c        |    1 +
>  arch/x86/tools/relocs_64.c        |    2 +
>  7 files changed, 533 insertions(+), 208 deletions(-)
>  create mode 100644 arch/x86/tools/relocs_32.c
>  create mode 100644 arch/x86/tools/relocs_64.c

This patch too is a bit large and it would be wise to split it into two 
steps: first the refactoring - which is non-functional and should not 
cause any problems in theory - then the change that switches to realloc.

Thanks,

	Ingo

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755632AbbAJWlZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 17:41:25 -0500
Received: from mail.skyhub.de ([78.46.96.112]:41873 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753999AbbAJWlX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 17:41:23 -0500
Date: Sat, 10 Jan 2015 23:41:20 +0100
From: Borislav Petkov <bp@alien8.de>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, X86 ML <x86@kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH 3/4] x86: open-code register save/restore in
 trace_hardirqs thunks
Message-ID: <20150110224120.GJ12218@pd.tnic>
References: <1420927210-19738-1-git-send-email-dvlasenk@redhat.com>
 <1420927210-19738-4-git-send-email-dvlasenk@redhat.com>
 <CA+55aFx54dhF7mU6NUTuCW2gP2XQt55XG-a3iDttSmijmdzbyw@mail.gmail.com>
 <CAK1hOcNgnZcF5fZjSSMr+RQQWLGBSjitErd4gj7JxgTMZPGTzQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAK1hOcNgnZcF5fZjSSMr+RQQWLGBSjitErd4gj7JxgTMZPGTzQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 10, 2015 at 11:35:58PM +0100, Denys Vlasenko wrote:
> I don't know either... it seems to be used after push_cfi
> *sometimes*, not always:
> 
> .macro op_safe_regs op
> ENTRY(\op\()_safe_regs)
>         CFI_STARTPROC
>         pushl_cfi %ebx
>         pushl_cfi %ebp
>         pushl_cfi %esi
>         pushl_cfi %edi
> 
> but
> 
> ENTRY(csum_partial)
>         CFI_STARTPROC
>         pushl_cfi %esi
>         CFI_REL_OFFSET esi, 0
>         pushl_cfi %ebx
>         CFI_REL_OFFSET ebx, 0
> 
> We need an expert to enlighten us.

I think Andy had it:

https://lkml.kernel.org/r/CALCETrUuJ8T%2BLp23uYezHvxAtF-L_20dOaD4aDxciE7xZqDK3w@mail.gmail.com

So we better hide that crap in the macro at least, like the rest of the
CFI gunk.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--

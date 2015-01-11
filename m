Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752020AbbAKKym (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 05:54:42 -0500
Received: from mail.skyhub.de ([78.46.96.112]:41248 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751744AbbAKKyj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 05:54:39 -0500
Date: Sun, 11 Jan 2015 11:54:36 +0100
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
Message-ID: <20150111105436.GA19421@pd.tnic>
References: <1420927210-19738-1-git-send-email-dvlasenk@redhat.com>
 <1420927210-19738-4-git-send-email-dvlasenk@redhat.com>
 <CA+55aFx54dhF7mU6NUTuCW2gP2XQt55XG-a3iDttSmijmdzbyw@mail.gmail.com>
 <CAK1hOcNgnZcF5fZjSSMr+RQQWLGBSjitErd4gj7JxgTMZPGTzQ@mail.gmail.com>
 <20150110224120.GJ12218@pd.tnic>
 <CAK1hOcMU0kV1M8dk-iOnTJuY3xtE+tmqqgzTxXnzzuDR2EOuLg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAK1hOcMU0kV1M8dk-iOnTJuY3xtE+tmqqgzTxXnzzuDR2EOuLg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 11, 2015 at 04:33:58AM +0100, Denys Vlasenko wrote:
> I understand Andy's post.
> My question is, what about places like this?
> 
> > .macro op_safe_regs op
> > ENTRY(\op\()_safe_regs)
> >         CFI_STARTPROC
> >         pushl_cfi %ebx
> >         pushl_cfi %ebp
> >         pushl_cfi %esi
> >         pushl_cfi %edi
> 
> Do we need to convert it to use macros which also do
> "CFI_REL_OFFSET reg, 0" thingy, or not?
> In either case: why?

What is different at those places to not use the CFI annotations?

Frankly speaking, I'm for dropping all that CFI ugliness completely.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--

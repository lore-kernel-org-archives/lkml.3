Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753717AbbALVDm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 16:03:42 -0500
Received: from mail.skyhub.de ([78.46.96.112]:46889 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752263AbbALVDk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 16:03:40 -0500
Date: Mon, 12 Jan 2015 22:03:27 +0100
From: Borislav Petkov <bp@alien8.de>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Denys Vlasenko <dvlasenk@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, X86 ML <x86@kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH] x86: introduce push/pop macros which generate
 CFI_REL_OFFSET and CFI_RESTORE
Message-ID: <20150112210326.GC27374@pd.tnic>
References: <1421017655-25561-1-git-send-email-dvlasenk@redhat.com>
 <20150112192314.GF3904@pd.tnic>
 <CALCETrXzEPKPFKBeKF3UMduNe1ViQTC6vULEySo_0XTJcK7Qkw@mail.gmail.com>
 <20150112193704.GG3904@pd.tnic>
 <CALCETrUVXGnqqtgw1eZRK5g0B+5vwGuvSV6dwnm5witA-fJWLQ@mail.gmail.com>
 <20150112201145.GH3904@pd.tnic>
 <CALCETrVto_uxTz30M8a4XyLk-UXTQXc3CsYxEKJkhmqH=FdvNA@mail.gmail.com>
 <54B42CF2.2030104@zytor.com>
 <CALCETrUiSEtJ-2MH9LQUnrkhE4=0WEzsiLQTvjNbE=CVqBoO2w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CALCETrUiSEtJ-2MH9LQUnrkhE4=0WEzsiLQTvjNbE=CVqBoO2w@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2015 at 12:26:38PM -0800, Andy Lutomirski wrote:
> Is the usage you have in mind something like:
> 
> pushq_cfi %r11 /* saves r11 */
> pushq_cfi $0 /* saves nothing */
> pushq_cfi %r11, savereg=rip /* saves rip */
> 
> I think I prefer the somewhat less magical:
> 
> pushq_reg_cfi %r11 /* saves r11 */
> pushq_reg_cfi %r11, savereg=rip /* saves rip */
> pushq_nounwind_cfi $0

But that's two macro names and the above one is one single which does
it all. And it's not like we're not looking at the definition of macros
when staring at the code anyway...

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--

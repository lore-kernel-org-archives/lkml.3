Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751862AbbAMMHe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 07:07:34 -0500
Received: from mail-qc0-f171.google.com ([209.85.216.171]:55883 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299AbbAMMHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 07:07:33 -0500
MIME-Version: 1.0
In-Reply-To: <CALCETrUiSEtJ-2MH9LQUnrkhE4=0WEzsiLQTvjNbE=CVqBoO2w@mail.gmail.com>
References: <1421017655-25561-1-git-send-email-dvlasenk@redhat.com>
 <20150112192314.GF3904@pd.tnic> <CALCETrXzEPKPFKBeKF3UMduNe1ViQTC6vULEySo_0XTJcK7Qkw@mail.gmail.com>
 <20150112193704.GG3904@pd.tnic> <CALCETrUVXGnqqtgw1eZRK5g0B+5vwGuvSV6dwnm5witA-fJWLQ@mail.gmail.com>
 <20150112201145.GH3904@pd.tnic> <CALCETrVto_uxTz30M8a4XyLk-UXTQXc3CsYxEKJkhmqH=FdvNA@mail.gmail.com>
 <54B42CF2.2030104@zytor.com> <CALCETrUiSEtJ-2MH9LQUnrkhE4=0WEzsiLQTvjNbE=CVqBoO2w@mail.gmail.com>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Tue, 13 Jan 2015 13:07:12 +0100
Message-ID: <CAK1hOcO8Tm5A0101SjTGZVk-ku_ZEOzMpOz3NgqxXT=U7meOtA@mail.gmail.com>
Subject: Re: [PATCH] x86: introduce push/pop macros which generate
 CFI_REL_OFFSET and CFI_RESTORE
To: Andy Lutomirski <luto@amacapital.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, X86 ML <x86@kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2015 at 9:26 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> I think I prefer the somewhat less magical:
>
> pushq_reg_cfi %r11 /* saves r11 */
> pushq_reg_cfi %r11, savereg=rip /* saves rip */
> pushq_nounwind_cfi $0
>
> Or something like that.

That's very close to my patch. With it:

pushq_cfi     - doesn't emit "register is saved" annotation, can be
used with non-register args.
pushq_cfi_reg - emits it

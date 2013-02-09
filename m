Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932402Ab3BIPKU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 10:10:20 -0500
Received: from mail-ob0-f179.google.com ([209.85.214.179]:47381 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760715Ab3BIPKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 10:10:17 -0500
MIME-Version: 1.0
In-Reply-To: <20130209092925.GA17728@pd.tnic>
References: <dee64752-850c-4d78-b703-f47a985bc13e@email.android.com>
	<CAGXu5jLAufTRm=sDST0br_WEkn4o0Hpjv2jDP2Na=cCvuM+MGg@mail.gmail.com>
	<1360355671.18083.18.camel@x230.lan>
	<CAGXu5jKo2PfMBO4A0ZgQcrPuj8OHNaff+CjAesOAWkZc0vB9+Q@mail.gmail.com>
	<51157C9C.6030501@zytor.com>
	<20130208230655.GB28990@pd.tnic>
	<1360366012.18083.21.camel@x230.lan>
	<5115A4CC.3080102@zytor.com>
	<1360373383.18083.23.camel@x230.lan>
	<CAGXu5j+xvJ3L5ejxtZ-Jw3F6rV7OsrE0_HZCGu_er0rH2_PwKA@mail.gmail.com>
	<20130209092925.GA17728@pd.tnic>
Date: Sat, 9 Feb 2013 07:10:16 -0800
X-Google-Sender-Auth: EqOWthEDL0DFHDoo6XMbfv5iwlA
Message-ID: <CAGXu5j+XTq6vyn176fHCDDgkLtVyBwEC8J3DUDVhy9z87ODF2Q@mail.gmail.com>
Subject: Re: [PATCH] x86: Lock down MSR writing in secure boot
From: Kees Cook <keescook@chromium.org>
To: Borislav Petkov <bp@alien8.de>, Kees Cook <keescook@chromium.org>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        linux-security-module <linux-security-module@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 9, 2013 at 1:29 AM, Borislav Petkov <bp@alien8.de> wrote:
> On Fri, Feb 08, 2013 at 10:45:35PM -0800, Kees Cook wrote:
>> Also, _reading_ MSRs from userspace arguably has utility that doesn't
>> compromise ring-0.
>
> And to come back to the original question: what is that utility, who
> would need it on a secure boot system and why?

I have used it for double-checking the state of VMX (is it disabled
and locked), and for making sure that XD isn't masked, checking
thermal stuff, etc. I'm not arguing to keep the MSR driver while in
secure mode, mind you, I was just pointing out that like /dev/mem
there could be some utility to keeping the read half around. That
said, it could also be seen as an info leak. *shrug* My goal was just
to make sure it wasn't writable in the secure boot mode.

-Kees

--
Kees Cook
Chrome OS Security

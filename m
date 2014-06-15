Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751998AbaFOTuk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 15:50:40 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:62429 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034AbaFOTuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 15:50:37 -0400
MIME-Version: 1.0
In-Reply-To: <9a4fb9c9-4b1c-4593-a99e-a2ef2325d55d@email.android.com>
References: <cover.1402769596.git.luto@amacapital.net>
	<21405.44257.742122.786960@gargle.gargle.HOWL>
	<20140615143500.GP179@brightrain.aerifal.cx>
	<539DD26B.3060709@zytor.com>
	<CALCETrXTpkto2gJBiFC4CR5D=Lqf2YfP5BBH02f8hFW+TUGqeA@mail.gmail.com>
	<539DDE9C.3010903@zytor.com>
	<CALCETrWLBCNiJArMRPuHbfhj6=ytnx_YqykzgCgZ+DYu34M1Mg@mail.gmail.com>
	<4ab91a07-c46c-485b-895d-b074d36624d6@email.android.com>
	<CALCETrV-ocpugRwL7rd4GDX-Y89L7So8_6BBjOUDeR4V8RSPEA@mail.gmail.com>
	<90c597c5-f77d-491e-b0b8-dde2027155b5@email.android.com>
	<CAKOQZ8zD7kyEmujCtTA8pm=wrM6vDJ5Yspfn1AkSydffhBus2g@mail.gmail.com>
	<9a4fb9c9-4b1c-4593-a99e-a2ef2325d55d@email.android.com>
Date: Sun, 15 Jun 2014 12:50:36 -0700
X-Google-Sender-Auth: 9ttN6UGTaOwXFPJNuWL2Am-SM0E
Message-ID: <CAKOQZ8z9r4Kw=0MNn29CMzD0-ZF=yCL2QfQp-oh==5MUcMQmuA@mail.gmail.com>
Subject: Re: [RFC 0/2] __vdso_findsym
From: Ian Lance Taylor <iant@golang.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Andi Kleen <andi@firstfloor.org>,
        Rich Felker <dalias@libc.org>,
        Mikael Pettersson <mikpelinux@gmail.com>, Russ Cox <rsc@golang.org>,
        Linux API <linux-api@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 15, 2014 at 12:31 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> The weak symbols are well-known names.  The __vdso symbols are strong.

I see.  But I don't understand how this is supposed to work.  When I
link a program against gettimeofday, I get a reference to gettimeofday
with version GLIBC_2.2.5.  After all, I only link against libc.so; I
don't link against the vDSO.  The VDSO provides gettimeofday with
version LINUX_2.6.  Since those versions don't match, the gettimeofday
reference in my executable will not be satisfied by the definition in
the vDSO.  So at dynamic link time my program is always going to be
linked with the gettimeofday in libc.so, which will in turn call the
gettimeofday in the vDSO.

Am I missing something that makes the definition of gettimeofday with
version LINUX_2.6 in the vDSO useful?

Ian



> On June 15, 2014 12:22:17 PM PDT, Ian Lance Taylor <iant@golang.org> wrote:
>>On Sun, Jun 15, 2014 at 12:14 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>>>
>>> If it doesn't, then you incur an additional indirection penalty.  The
>>strong __vdso symbol allows the libc wrapper to fall back to the vdso
>>implementation, the weak symbol allows three to be no wrapper at all.
>>This is good.
>>>
>>> The reason for changing ABI would be shifting types.  This is very
>>much how glibc manages transitions.
>>
>>The purpose of symbol versioning is so that symbols with well known
>>names, like stat, can continue to use those same names while changing
>>types.  Both old and new programs can continue to use the name stat
>>and continue to work even though they use different types.
>>
>>I don't see how this applies to the kernel VDSO.  Those symbols do not
>>use well-known names; they use names like __vdso_time.  If you change
>>the types used by those symbols, you can change the name as well.
>>What is the downside?
>>
>>Ian
>
> --
> Sent from my mobile phone.  Please pardon brevity and lack of formatting.

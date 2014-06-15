Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751511AbaFOTOn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 15:14:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41509 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750979AbaFOTOj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 15:14:39 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <CALCETrV-ocpugRwL7rd4GDX-Y89L7So8_6BBjOUDeR4V8RSPEA@mail.gmail.com>
References: <cover.1402769596.git.luto@amacapital.net> <21405.44257.742122.786960@gargle.gargle.HOWL> <20140615143500.GP179@brightrain.aerifal.cx> <539DD26B.3060709@zytor.com> <CALCETrXTpkto2gJBiFC4CR5D=Lqf2YfP5BBH02f8hFW+TUGqeA@mail.gmail.com> <539DDE9C.3010903@zytor.com> <CALCETrWLBCNiJArMRPuHbfhj6=ytnx_YqykzgCgZ+DYu34M1Mg@mail.gmail.com> <4ab91a07-c46c-485b-895d-b074d36624d6@email.android.com> <CALCETrV-ocpugRwL7rd4GDX-Y89L7So8_6BBjOUDeR4V8RSPEA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [RFC 0/2] __vdso_findsym
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sun, 15 Jun 2014 12:14:04 -0700
To: Andy Lutomirski <luto@amacapital.net>
CC: Andi Kleen <andi@firstfloor.org>, Rich Felker <dalias@libc.org>,
        Mikael Pettersson <mikpelinux@gmail.com>, Russ Cox <rsc@golang.org>,
        Linux API <linux-api@vger.kernel.org>, Ian Taylor <iant@golang.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>
Message-ID: <90c597c5-f77d-491e-b0b8-dde2027155b5@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If it doesn't, then you incur an additional indirection penalty.  The strong __vdso symbol allows the libc wrapper to fall back to the vdso implementation, the weak symbol allows three to be no wrapper at all.  This is good.

The reason for changing ABI would be shifting types.  This is very much how glibc manages transitions.



On June 15, 2014 11:54:10 AM PDT, Andy Lutomirski <luto@amacapital.net> wrote:
>On Sun, Jun 15, 2014 at 11:39 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>> Symbol versioning so we can rev the ABI and still provide backwards
>compatibility.  Weak symbols so the libc can override symbols if it
>considers it appropriate.  This is a good thing.
>
>Are we ever going to change, say, the __vdso_clock_gettime ABI without
>renaming the function?  If we want to preserve that ability, I can
>keep support for versions, but it seems odd.
>
>I don't buy the weak symbol argument at all.  We currently expose a
>strong symbol __vdso_clock_gettime and a weak alias clock_gettime.  I
>agree that, if glibc treats us as a real DSO, then clock_gettime can't
>be strong, but I don't see why it should exist at all (other than for
>backwards compatibility).
>
>--Andy

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752182AbaFOUxl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 16:53:41 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:40017 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176AbaFOUxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 16:53:38 -0400
MIME-Version: 1.0
In-Reply-To: <8607961d-b42a-4dba-a736-d3a8586ee42d@email.android.com>
References: <cover.1402769596.git.luto@amacapital.net> <21405.44257.742122.786960@gargle.gargle.HOWL>
 <20140615143500.GP179@brightrain.aerifal.cx> <539DD26B.3060709@zytor.com>
 <CALCETrXTpkto2gJBiFC4CR5D=Lqf2YfP5BBH02f8hFW+TUGqeA@mail.gmail.com>
 <539DDE9C.3010903@zytor.com> <CALCETrWLBCNiJArMRPuHbfhj6=ytnx_YqykzgCgZ+DYu34M1Mg@mail.gmail.com>
 <4ab91a07-c46c-485b-895d-b074d36624d6@email.android.com> <CALCETrV-ocpugRwL7rd4GDX-Y89L7So8_6BBjOUDeR4V8RSPEA@mail.gmail.com>
 <90c597c5-f77d-491e-b0b8-dde2027155b5@email.android.com> <CAKOQZ8zD7kyEmujCtTA8pm=wrM6vDJ5Yspfn1AkSydffhBus2g@mail.gmail.com>
 <9a4fb9c9-4b1c-4593-a99e-a2ef2325d55d@email.android.com> <CAKOQZ8z9r4Kw=0MNn29CMzD0-ZF=yCL2QfQp-oh==5MUcMQmuA@mail.gmail.com>
 <8607961d-b42a-4dba-a736-d3a8586ee42d@email.android.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Sun, 15 Jun 2014 13:53:17 -0700
Message-ID: <CALCETrVoOS913rUo288c6PhNtrWBZa9tSA6Ec=WUw1+SAU9ALw@mail.gmail.com>
Subject: Re: [RFC 0/2] __vdso_findsym
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ian Lance Taylor <iant@golang.org>, Andi Kleen <andi@firstfloor.org>,
        Rich Felker <dalias@libc.org>,
        Mikael Pettersson <mikpelinux@gmail.com>, Russ Cox <rsc@golang.org>,
        Linux API <linux-api@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 15, 2014 at 12:56 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> You can link against vdso.so if you want to; the kernel build provides an option to install that image.  Doesn't mean that any particular libc uses it.

I'd be rather surprised if anyone does this, given the generally
spotty state of vdso.so installation and that there's no such thing as
an ELF import library.

Also, the vdso's clock_gettime isn't actually compatible with
glibc/POSIX -- the return value and errno handling don't match.

--Andy

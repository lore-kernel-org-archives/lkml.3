Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140AbaFOGuR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 02:50:17 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:36760 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900AbaFOGuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 02:50:15 -0400
MIME-Version: 1.0
In-Reply-To: <539D1A28.7040107@zytor.com>
References: <cover.1402769596.git.luto@amacapital.net> <20140614213000.GO179@brightrain.aerifal.cx>
 <CALCETrX3Kv7VAfYau-79odKtRvME0-AzZB_xGUMPEHeas8AkaQ@mail.gmail.com>
 <539CDC6F.6010501@zytor.com> <539D1A28.7040107@zytor.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Sat, 14 Jun 2014 23:49:53 -0700
Message-ID: <CALCETrU47SPpiPbEWKOquy7dfBS01ctCirmZA=HH5Xa4jVy_4w@mail.gmail.com>
Subject: Re: [RFC 0/2] __vdso_findsym
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Rich Felker <dalias@libc.org>, Russ Cox <rsc@golang.org>,
        Linux API <linux-api@vger.kernel.org>, Ian Taylor <iant@golang.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 14, 2014 at 8:59 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 06/14/2014 04:36 PM, H. Peter Anvin wrote:
>>
>> Now, if we can do this without adding another page then that becomes
>> much more compelling IMO.  I suspect we can if you are already down to
>> 488 bytes.
>>
>
> (If it isn't already the case, was inteded to be part of that...)

It's down to 375 bytes now.  I'm not sure how to do better than that
without starting to hardcode variously nasty assumptions.

With CONFIG_PARAVIRT_CLOCK=y I think the 64-bit vdso is two pages
anyway.  With CONFIG_PARAVIRT_CLOCK=n, it's one page even with my
code.

(At some point I plan on tackling the paravirt clock code.  It's much
more complicated and much slower than it needs to be.)

--Andy

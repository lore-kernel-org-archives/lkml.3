Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946900Ab3BHTVo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 14:21:44 -0500
Received: from mail-oa0-f42.google.com ([209.85.219.42]:40295 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946800Ab3BHTVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 14:21:40 -0500
MIME-Version: 1.0
In-Reply-To: <1360351047.18083.14.camel@x230.lan>
References: <20130208191213.GA25081@www.outflux.net>
	<1360351047.18083.14.camel@x230.lan>
Date: Fri, 8 Feb 2013 11:21:39 -0800
X-Google-Sender-Auth: py96b-juF3P5zCbSyvsWkX7Fptk
Message-ID: <CAGXu5j+aXxQb_Jyn6G+JUdjNOF2EGo9pTw8dBYuZUTb+S1vWow@mail.gmail.com>
Subject: Re: [PATCH] x86: Lock down MSR writing in secure boot
From: Kees Cook <keescook@chromium.org>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "x86@kernel.org" <x86@kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
	<linux-security-module@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 8, 2013 at 11:17 AM, Matthew Garrett
<matthew.garrett@nebula.com> wrote:
> On Fri, 2013-02-08 at 11:12 -0800, Kees Cook wrote:
>> Writing to MSRs should not be allowed unless CAP_COMPROMISE_KERNEL is
>> set since it could lead to execution of arbitrary code in kernel mode.
>
> Willing to buy this, but do you have a description of one potential
> approach? We should probably also figure out what's writing to MSRs at
> the moment (anything other than energy_perf_bias?) and decide what the
> best thing to do there is.

Yes, change the SYSENTER entry point to where-ever you like. There are
examples already written:
http://grsecurity.net/~spender/msr32.c

IMO, _writing_ an MSR from userspace should be considered a bug. If
writing is needed, a kernel driver should be mediating the change.
wrmsr (and rdmsr) are ring-0 only for good reason. :)

-Kees

--
Kees Cook
Chrome OS Security

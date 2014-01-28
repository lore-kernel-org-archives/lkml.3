Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755631AbaA1UvK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 15:51:10 -0500
Received: from mail-oa0-f49.google.com ([209.85.219.49]:64924 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755315AbaA1UvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 15:51:08 -0500
MIME-Version: 1.0
In-Reply-To: <52E701BF.9040306@gmail.com>
References: <20140128003927.GA27319@www.outflux.net>
	<52E701BF.9040306@gmail.com>
Date: Tue, 28 Jan 2014 12:51:08 -0800
X-Google-Sender-Auth: 3T3TKGiQBaBQuXNO2BJeIBWkgWg
Message-ID: <CAGXu5jLbsx+H5NBY25XxH+cRSejJWZ2-v1fa2-GQ-y3VJa-h0A@mail.gmail.com>
Subject: Re: [PATCH] vsprintf: ignore arguments to %n
From: Kees Cook <keescook@chromium.org>
To: Ryan Mallon <rmallon@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Joe Perches <joe@perches.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Olof Johansson <olof@lixom.net>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        Daniel Borkmann <dborkman@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 27, 2014 at 5:02 PM, Ryan Mallon <rmallon@gmail.com> wrote:
> On 28/01/14 11:39, Kees Cook wrote:
>> If arguments are consumed without output when encountering %n, it
>> could be used to benefit or improve information leak attacks that were
>> exposed via a limited size buffer. Since %n is not used by the kernel,
>> there is no reason to make an info leak attack any easier.
>
> I was thinking more like the following. Print the warning if %n is
> detected in format_decode(), but otherwise just remove the handling of
> %n outright and treat it like any other invalid format specifier.
> Something like this completely untested patch. Thoughts?

I'd be totally fine with it. Minor typo in the comment before the
WARN_ONCE (should be "its" instead of "it"), but otherwise looks good.
Consider it:

Acked-by: Kees Cook <keescook@chromium.org>

It builds and boots fine for me, FWIW.

-Kees

-- 
Kees Cook
Chrome OS Security

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932120AbaA1Uxd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 15:53:33 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:56003 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755212AbaA1Uxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 15:53:32 -0500
Message-ID: <52E7FCF1.10705@gmail.com>
Date: Wed, 29 Jan 2014 07:54:41 +1300
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Joe Perches <joe@perches.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Olof Johansson <olof@lixom.net>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        Daniel Borkmann <dborkman@redhat.com>
Subject: Re: [PATCH] vsprintf: ignore arguments to %n
References: <20140128003927.GA27319@www.outflux.net>	<52E701BF.9040306@gmail.com> <CAGXu5jLbsx+H5NBY25XxH+cRSejJWZ2-v1fa2-GQ-y3VJa-h0A@mail.gmail.com>
In-Reply-To: <CAGXu5jLbsx+H5NBY25XxH+cRSejJWZ2-v1fa2-GQ-y3VJa-h0A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/01/14 09:51, Kees Cook wrote:

> On Mon, Jan 27, 2014 at 5:02 PM, Ryan Mallon <rmallon@gmail.com> wrote:
>> On 28/01/14 11:39, Kees Cook wrote:
>>> If arguments are consumed without output when encountering %n, it
>>> could be used to benefit or improve information leak attacks that were
>>> exposed via a limited size buffer. Since %n is not used by the kernel,
>>> there is no reason to make an info leak attack any easier.
>>
>> I was thinking more like the following. Print the warning if %n is
>> detected in format_decode(), but otherwise just remove the handling of
>> %n outright and treat it like any other invalid format specifier.
>> Something like this completely untested patch. Thoughts?
> 
> I'd be totally fine with it. Minor typo in the comment before the
> WARN_ONCE (should be "its" instead of "it"), but otherwise looks good.
> Consider it:
> 
> Acked-by: Kees Cook <keescook@chromium.org>
> 
> It builds and boots fine for me, FWIW.
> 
> -Kees
> 


It looks like your second version already got added to Andrew's mm tree.
I'm happy to repost mine with a fixed typo and proper signed-off by if
you'd rather use that version.

~Ryan
 

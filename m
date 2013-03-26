Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934918Ab3CZP4Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:56:25 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:57274 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934869Ab3CZP4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:56:21 -0400
MIME-Version: 1.0
In-Reply-To: <514F5480.6040501@suse.cz>
References: <20130320201554.GA18281@kroah.com>
	<kidd01$2o6$1@ger.gmane.org>
	<514F5480.6040501@suse.cz>
Date: Tue, 26 Mar 2013 08:56:20 -0700
X-Google-Sender-Auth: TsgTUvcHtq7o79jHfe3Ig1uj31c
Message-ID: <CAGXu5jJdbDabBjNoaZUeqCT6a6yHqHcQNnqXNM6T1S=bwig8Fw@mail.gmail.com>
Subject: Re: Build breakage in 3.8.4 [was: Linux 3.8.4]
From: Kees Cook <keescook@chromium.org>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Sebastian Gottschall <s.gottschall@dd-wrt.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 24, 2013 at 12:31 PM, Jiri Slaby <jslaby@suse.cz> wrote:
> On 03/20/2013 11:25 PM, Sebastian Gottschall wrote:
>
>> Am 20.03.2013 21:15, schrieb Greg KH:
>>> I'm announcing the release of the 3.8.4 kernel.
> ...
>>>        signal: always clear sa_restorer on execve
>> consider that this kernel is not compileable on mips targets due the
>> patch in kernel/signal.c
>>
>> SA_RESTORER is defined in mips, but sa_restorer does not exist on that
>> platform
>
> The same for ia64...
>
> kernel/signal.c: In function 'flush_signal_handlers':
> kernel/signal.c:441: error: 'struct sigaction' has no member named
> 'sa_restorer'
>
> Do we need this in 3.0, 3.4, 3.8 too?
> commit 522cff142d7d2f9230839c9e1f21a4d8bcc22a4a
> Author: Andrew Morton <akpm@linux-foundation.org>
> Date:   Wed Mar 13 14:59:34 2013 -0700
>
>     kernel/signal.c: use __ARCH_HAS_SA_RESTORER instead of SA_RESTORER
>
>     __ARCH_HAS_SA_RESTORER is the preferred conditional for use in 3.9 and
>     later kernels, per Kees.

Hrm, if so, we'll need to also backport the changes that aded
__ARCH_HAS_SA_RESTORER...

-Kees

>
> thanks,
> --
> js
> suse labs



--
Kees Cook
Chrome OS Security

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751175AbaBBCwS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 21:52:18 -0500
Received: from mail-vb0-f47.google.com ([209.85.212.47]:44528 "EHLO
	mail-vb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849AbaBBCwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 21:52:17 -0500
MIME-Version: 1.0
In-Reply-To: <CALCETrUEZiqQ7be5E7cBEmFEKqvwJ_eCxpE-hiGZ94Hkd4Q54Q@mail.gmail.com>
References: <CALCETrUEZiqQ7be5E7cBEmFEKqvwJ_eCxpE-hiGZ94Hkd4Q54Q@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Sat, 1 Feb 2014 18:51:56 -0800
Message-ID: <CALCETrX+crm9ubMqimSdzfALEniefKcAWZz3AhZ7zioy7dVKzQ@mail.gmail.com>
Subject: Re: Why is syscall auditing on with no rules?
To: Oleg Nesterov <oleg@redhat.com>, Steve Grubb <sgrubb@redhat.com>,
        Eric Paris <eparis@redhat.com>, linux-audit@redhat.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 1, 2014 at 6:32 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> On a stock Fedora installation:
>
> $ sudo auditctl -l
> No rules
>
> Nonetheless TIF_SYSCALL_AUDIT is set and the __audit_syscall_entry and
> __audit_syscall_exit account for >20% of syscall overhead according to
> perf.
>
> This sucks.  Unless I'm missing something, syscall auditing is *off*.
>
> How hard would it be to arrange for TIF_SYSCALL_AUDIT to be cleared
> when there are no syscall rules?
>
> (This is extra bad in kernels before 3.13, where the clear call for
> TIF_SYSCALL_AUDIT was completely missing.)

The current code seems to have really odd effects.  For example,
processes that are created before the very first auditctl -e 1 (or
auditd) invocation will never be subject to syscall auditing.  But
auditctl -e 1; auditctl -e 0 will cause all subsequently started
processes to have audit contexts allocated and therefore to be subject
to syscall auditing.

I doubt that this behavior is considered desirable.

--Andy

>
> --Andy



-- 
Andy Lutomirski
AMA Capital Management, LLC

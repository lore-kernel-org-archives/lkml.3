Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757159Ab3HGQ1X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 12:27:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57442 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756738Ab3HGQ1W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 12:27:22 -0400
Date: Wed, 7 Aug 2013 18:21:47 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andy Lutomirski <luto@amacapital.net>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Chen Gang <gang.chen@asianux.com>, Kees Cook <keescook@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>, holt@sgi.com,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] kernel/sys.c: return the current gid when error
	occurs
Message-ID: <20130807162147.GA31460@redhat.com>
References: <5200AD26.8070701@asianux.com> <5200AD67.1030109@asianux.com> <52015ADB.30408@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52015ADB.30408@mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06, Andy Lutomirski wrote:
>
> I assume that what the man page means is that the return value is
> whatever fsgid was prior to the call.  On error, fsgid isn't changed, so
> the return value is still "current".

Probably... Still

	On success, the previous value of fsuid is returned.
	On error, the current value of fsuid is returned.

looks confusing. sys_setfsuid() always returns the old value.

> (FWIW, this behavior is awful and is probably the cause of a security
> bug or three, since success and failure are indistinguishable.

At least this all looks strange.

I dunno if we can change this old behaviour. I won't be surprized
if someone already uses setfsuid(-1) as getfsuid().

And perhaps the man page should be changed. Add Michael.

Oleg.


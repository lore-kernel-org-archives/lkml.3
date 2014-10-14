Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660AbaJNGyB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 02:54:01 -0400
Received: from ozlabs.org ([103.22.144.67]:44502 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754161AbaJNGxy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 02:53:54 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andy Lutomirski <luto@amacapital.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Cc: Chuck Ebbert <cebbert.lkml@gmail.com>, Rob Landley <rob@landley.net>,
        Randy Dunlap <rdunlap@infradead.org>,
        Shuah Khan <shuah.kh@samsung.com>,
        Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH v5] init: Disable defaults if init= fails
In-Reply-To: <5c6381879bea68aebb13530442f1cf8a052be97f.1411958379.git.luto@amacapital.net>
References: <5c6381879bea68aebb13530442f1cf8a052be97f.1411958379.git.luto@amacapital.net>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Tue, 14 Oct 2014 11:17:09 +1030
Message-ID: <87fvercwaa.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Lutomirski <luto@amacapital.net> writes:
> If a user puts init=/whatever on the command line and /whatever
> can't be run, then the kernel will try a few default options before
> giving up.  If init=/whatever came from a bootloader prompt, then
> this is unexpected but probably harmless.  On the other hand, if it
> comes from a script (e.g. a tool like virtme or perhaps a future
> kselftest script), then the fallbacks are likely to exist, but
> they'll do the wrong thing.  For example, they might unexpectedly
> invoke systemd.
>
> This makes a failure to run the specified init= process be fatal.
>
> As a temporary measure, users can set CONFIG_INIT_FALLBACK=y to
> preserve the old behavior.  If no one speaks up, we can remove that
> option entirely after a release or two.
>
> Signed-off-by: Andy Lutomirski <luto@amacapital.net>

Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Andrew, please apply.

Thanks,
Rusty.

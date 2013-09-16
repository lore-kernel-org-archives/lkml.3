Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751306Ab3IPTPo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 15:15:44 -0400
Received: from science.horizon.com ([71.41.210.146]:20798 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751229Ab3IPTPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 15:15:43 -0400
Date: 16 Sep 2013 15:15:20 -0400
Message-ID: <20130916191520.8844.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: joe@perches.com, linux@horizon.com
Subject: Re: [PATCH 1/2] remove all uses of printf's %n
Cc: akpm@linux-foundation.org, dan.carpenter@oracle.com, JBeulich@suse.com,
        keescook@chromium.org, kosaki.motohiro@gmail.com,
        linux-kernel@vger.kernel.org, penguin-kernel@i-love.sakura.ne.jp,
        viro@zeniv.linux.org.uk
In-Reply-To: <1379354025.1934.19.camel@joe-AO722>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It'd be consistent with all the other %p<foo> types.
>
> vsnprintf is already weird enough with %p uses,
> there's absolutely no reason to stretch it further
> with yet another odd access/format style.

Well, all the other %p<foo> types actually *use* the void * argument.
They print the thing pointed to, just in different ways.

What I'm proposing is fundamentally different, and much more
"printf internals" specific.

I hate creating an interface that requires a dummy pointer argument.

This would already be quite different in , and I hate creating a
new interface that requires a dummy pointer argument.


One nonsensical combination that gcc does *not* complain about
is "%0-c".  (It does bitch about "%-0c", however.)

Is "%0-127c" too ugly to live?

Note that I could generalize it, and allow "%0-<width>" to mean
"left-align, with trailing padding to column <width>" for ANY format
specifier if that would help.  It's easy in the printf code to compute
the field width necessary to make that work.
ANSI C says that %0- is permitted and means the same thing as %-
(- overrides 0), but that could be bent.

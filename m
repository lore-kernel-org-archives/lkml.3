Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751999AbaI3MML (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 08:12:11 -0400
Received: from mail-oi0-f49.google.com ([209.85.218.49]:62371 "EHLO
	mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815AbaI3MMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 08:12:09 -0400
Date: Tue, 30 Sep 2014 07:12:04 -0500
From: Chuck Ebbert <cebbert.lkml@gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Rob Landley <rob@landley.net>, Randy Dunlap <rdunlap@infradead.org>,
        Shuah Khan <shuah.kh@samsung.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH v5] init: Disable defaults if init= fails
Message-ID: <20140930071204.551f0fef@as>
In-Reply-To: <5c6381879bea68aebb13530442f1cf8a052be97f.1411958379.git.luto@amacapital.net>
References: <5c6381879bea68aebb13530442f1cf8a052be97f.1411958379.git.luto@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Sep 2014 19:40:31 -0700
Andy Lutomirski <luto@amacapital.net> wrote:

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

I like it. Now users could even use:

 rdinit=foo init=bar

If foo fails, bar will be tried as a fallback, and nothing else after
that.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751357Ab3BPAyD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 19:54:03 -0500
Received: from mail-ve0-f173.google.com ([209.85.128.173]:43020 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733Ab3BPAyC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 19:54:02 -0500
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Fri, 15 Feb 2013 19:54:01 EST
MIME-Version: 1.0
In-Reply-To: <CAGDaZ_rqKR7Ea6SZ9JXmeVOvEBEk3gHaQEa1LAkzWxRHfJsHWw@mail.gmail.com>
References: <20130214053656.GS4503@ZenIV.linux.org.uk> <CA+55aFz1JjGSCdqXpVz3oH-PWFDE3Qdxt3EVxqC2i=nfLqf0Jw@mail.gmail.com>
 <20130215215946.GX4503@ZenIV.linux.org.uk> <CAGDaZ_pMLScoO811es3AZxzAnSiS5ixku-DeuEi4FwX8mNv3cQ@mail.gmail.com>
 <20130216000435.GY4503@ZenIV.linux.org.uk> <CAGDaZ_rqKR7Ea6SZ9JXmeVOvEBEk3gHaQEa1LAkzWxRHfJsHWw@mail.gmail.com>
From: Shentino <shentino@gmail.com>
Date: Fri, 15 Feb 2013 16:46:43 -0800
Message-ID: <CAGDaZ_p8Dm+Tco_famKmEzGpV6G+zo1xHLkA7LQCkzQJD_pxMA@mail.gmail.com>
Subject: Re: [RFC] SIGKILL vs. SIGSEGV on late execve() failures
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2013 at 4:38 PM, Shentino <shentino@gmail.com> wrote:
> On Fri, Feb 15, 2013 at 4:04 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>> How would you manage to have it masked at that point?  setup_new_exec()
>> is inevitable after success of flush_old_exec() and it will do
>> flush_signal_handlers() for us.
>
> I wouldn't know for sure but I read somewhere that even if execve
> resets handled signals, it didn't also say that ignored signals were
> also reset.  (Source: execve man page.)

Also, apologies for the terminology mix-up.  By masked, I mean that
the signal was ignored as directed by userspace a-la signal(SIGSEGV,
SIG_IGN).

Plus I *think* that signal ignore masks are preserved across an exec.

Again, I might just be a clueless newbie here.

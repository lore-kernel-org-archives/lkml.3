Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752425AbbACXUE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2015 18:20:04 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:65276 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750786AbbACXT7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2015 18:19:59 -0500
Message-ID: <54A8791B.6020001@nod.at>
Date: Sun, 04 Jan 2015 00:19:55 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>, Pavel Machek <pavel@ucw.cz>
CC: Jiri Kosina <jkosina@suse.cz>, Kees Cook <keescook@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>,
        Aaron Tomlin <atomlin@redhat.com>,
        DaeSeok Youn <daeseok.youn@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, vdavydov@parallels.com,
        Rik van Riel <riel@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Brad Spengler <spender@grsecurity.net>
Subject: Re: [PATCH] [RFC] Deter exploit bruteforcing
References: <20150102194616.GA27538@amd> <54A7103E.6020500@nod.at> <20150102222936.GA29018@amd> <alpine.LRH.2.00.1501022331060.30884@twin.jikos.cz> <20150102224646.GB29018@amd> <alpine.LNX.2.00.1501022348070.16297@pobox.suse.cz> <20150102225420.GC29018@amd> <54A72306.2050908@nod.at> <20150102230837.GA4482@amd> <54A7BA45.1050005@nod.at> <20150103223644.GB27979@amd> <CALCETrWBHJ52YjowqJ7S90bXvkw_B1VxbkSDKpyjwC1WYvGE3w@mail.gmail.com>
In-Reply-To: <CALCETrWBHJ52YjowqJ7S90bXvkw_B1VxbkSDKpyjwC1WYvGE3w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 04.01.2015 um 00:06 schrieb Andy Lutomirski:
> As an attempt to help end this particular line of debate: putting the
> sleep in glibc won't work.  The point isn't to make the crashed
> process crash more slowly; it's to limit the rate at which *new*
> siblings can be forked and crashed as a canary or ASLR brute-force
> probe.  IOW, adding a sleep call to glibc slows down the wrong thing.
> Also, trying to get libc to take action on a plain old segfault is a
> giant mess, because it involves mucking with signal handling, which
> glibc really has no business doing by default.

Thanks for pointing this out!

> Also, this patch is missing a bit, I think.  We really want to control
> the total rate of crashes.  This patch imposes a delay per crash, but
> AFAICS it would still be possible for an attacker to coerce a forking
> server to fork, say, 10k children, then probe all of them, then wait
> 30 seconds and repeat.

Sounds reasonable. This is exactly why I've extracted that feature from
grsecurity and posted it here on LKML.
Now we have the chance to make the feature better and can identify weak points.

Thanks,
//richard

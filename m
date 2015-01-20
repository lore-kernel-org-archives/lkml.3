Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178AbbATSGx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 13:06:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34434 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751241AbbATSGv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 13:06:51 -0500
Date: Tue, 20 Jan 2015 19:05:14 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Prarit Bhargava <prarit@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Fabian Frederick <fabf@skynet.be>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH] init/main.c: Simplify initcall_blacklisted()
Message-ID: <20150120180514.GA23205@redhat.com>
References: <1421454312-30505-1-git-send-email-linux@rasmusvillemoes.dk> <20150119191924.GA19153@redhat.com> <87y4oyb6sc.fsf@rustcorp.com.au> <54BE32D2.90301@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54BE32D2.90301@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20, Prarit Bhargava wrote:
>
> On 01/19/2015 08:05 PM, Rusty Russell wrote:
> > Oleg Nesterov <oleg@redhat.com> writes:
> >>
> >> If we want to optimize this... I am wondering if we can change
> >> initcall_blacklist()
> >>
> >> 	-	entry->buf = alloc_bootmem(strlen(str_entry) + 1);
> >> 	+	ebtry->fn = kallsyms_lookup_name(str_entry);
> >>
> >> and then change initcall_blacklisted() to just compare the pointers.
> >
> > That would make far, far more sense.  It would fail for modules of
> > course, but that might be OK.  Prarit, this was your code; does it
> > matter?
>
> It does actually matter to me.  I've been using it to blacklist modules at boot
> as well ... and it works really well :)  So I'm okay with the original patch but
> not the second suggested change.

Yes, I didn't know/realize that initcall_blacklist paramater can be
also used to disable the modules, thanks for correcting me.

But I'd say that initcall_blacklisted(mod->init) looks a bit strange,
I mean it would be probably better to use mod->name in this case, not
the "internal" name of this likely static function.

Perhaps even another kernel parameter makes sense for this, I dunno..
>From Documentation/kernel-parameters.txt:

	initcall_blacklist=  [KNL] Do not execute a comma-separated list of
			initcall functions.  Useful for debugging built-in
			modules and initcalls.

note that this only mentions built-in modules.

Nevermind, I was wrong anyway. Thanks!

Oleg.


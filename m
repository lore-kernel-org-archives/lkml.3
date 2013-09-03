Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757417Ab3ICCMR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 22:12:17 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:39735 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838Ab3ICCMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 22:12:16 -0400
X-Originating-IP: 50.43.39.152
Date: Mon, 2 Sep 2013 19:12:07 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Joe Perches <joe@perches.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>, David Howells <dhowells@redhat.com>,
        Andy Whitcroft <apw@canonical.com>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Wang Shilong <wangshilong1991@gmail.com>
Subject: Re: [Ksummit-2013-discuss] [PATCH] checkpatch: Add comment about
 updating Documentation/CodingStyle
Message-ID: <20130903021207.GA4045@leaf>
References: <1378138205.1953.66.camel@joe-AO722>
 <20130902181510.GA29787@leaf>
 <20130902181856.GB29787@leaf>
 <20130902153945.6d7e510c@samsung.com>
 <1378148367.1953.98.camel@joe-AO722>
 <13834.1378155023@warthog.procyon.org.uk>
 <1378156296.1953.117.camel@joe-AO722>
 <20130903003958.GA6855@localhost>
 <20130903013408.GA3437@leaf>
 <1378173165.1953.148.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378173165.1953.148.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 02, 2013 at 06:52:45PM -0700, Joe Perches wrote:
> On Mon, 2013-09-02 at 18:34 -0700, Josh Triplett wrote:
> > I'd suggest a couple more, which
> > *should* always make sense, and to the best of my knowledge don't tend
> > to generate false positives:
> > 
> > C99_COMMENTS
> 
> I don't have a problem with c99 comments.
> As far as I know, Linus doesn't either.
> 
> https://lkml.org/lkml/2012/4/16/473

That doesn't look like an endorsement so much as a statement that C99
comments are less awful than the net/ special-case comment style.

Documentation/CodingStyle chapter 8 says:
> Linux style for comments is the C89 "/* ... */" style.
> Don't use C99-style "// ..." comments.

If that no longer holds true, we should remove it from CodingStyle.  As
far as I know, though, it still holds.  In any case, it rarely comes up;
most kernel code doesn't use such comments.

> > CONFIG_EXPERIMENTAL
> > CVS_KEYWORD
> 
> OK, but <shrug>

Sure, I don't expect them to come up often.

> > ELSE_AFTER_BRACE
> 
> I wouldn't do this one.  I think
> there are some false positives here.

Oh?  What kinds of false positives have you seen?

In any case, fair enough.

> > GLOBAL_INITIALIZERS
> > INITIALISED_STATIC
> 
> Nor these.

I don't see an obvious way for those to have false positives.  What have
you seen?

> > INVALID_UTF8
> > LINUX_VERSION_CODE
> > MISSING_EOF_NEWLINE
> 
> OK I suppose.

Not particularly critical, but uncontroversial and no false positives.

> > PREFER_SEQ_PUTS
> > PRINTK_WITHOUT_KERN_LEVEL
> 
> There are a lot of these.
> I suggest no here.

I assume the bot only applies this to new patches, not to existing code,
in which case these seem completely reasonable.  New code should follow
these, even if we don't mass-fix existing code.

> > RETURN_PARENTHESES
> > SIZEOF_PARENTHESIS
> 
> It's in coding style, but some newish patches
> do avoid them.  It's a question about how noisy
> you want your robot to be.

These two seem reasonable to enforce on new code.  I agree that they
shouldn't trigger mass cleanups of existing code.

> > SPACE_BEFORE_TAB
> > TRAILING_SEMICOLON
> > TRAILING_WHITESPACE
> > USE_DEVICE_INITCALL

I didn't see any comment from you on these four.  Thoughts?

> > USE_RELATIVE_PATH
> 
> Having checkpatch tell people how to write changelogs
> I think not a great idea.

In general, sure, but that particular one seems OK.  In any case, not
particularly critical.

> > These *ought* to make sense, but I don't know their false positive rates:
> > 
> > HEXADECIMAL_BOOLEAN_TEST
> 
> That's a good one.  0 false positives.

Ah, good.

> > ALLOC_ARRAY_ARGS
> 
> Yes, this would be reasonable too.

Excellent.

> > CONSIDER_KSTRTO
> 
> I think orobably not.  This would be a cleanup thing.

Even if applied to new code only?  New code should use the right
functions to start with.

> > CONST_STRUCT
> 
> OK

Good to know; glad to hear it doesn't have false positives.

> > SPLIT_STRING
> 
> I suggest no but <shrug>

I can easily believe that it has too many false positives.  Let's leave
that one alone for now.

- Josh Triplett

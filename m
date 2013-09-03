Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759255Ab3ICCqx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 22:46:53 -0400
Received: from mga14.intel.com ([143.182.124.37]:4861 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754492Ab3ICCqw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 22:46:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,1011,1367996400"; 
   d="scan'208";a="390157562"
Date: Tue, 3 Sep 2013 10:46:40 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Joe Perches <joe@perches.com>
Cc: Josh Triplett <josh@joshtriplett.org>, David Howells <dhowells@redhat.com>,
        Andy Whitcroft <apw@canonical.com>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Wang Shilong <wangshilong1991@gmail.com>
Subject: Re: [Ksummit-2013-discuss] [PATCH] checkpatch: Add comment about
 updating Documentation/CodingStyle
Message-ID: <20130903024640.GA11168@localhost>
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
> 
> > CONFIG_EXPERIMENTAL
> > CVS_KEYWORD
> 
> OK, but <shrug>
> 
> > ELSE_AFTER_BRACE
> 
> I wouldn't do this one.  I think
> there are some false positives here.
> 
> > GLOBAL_INITIALIZERS
> > INITIALISED_STATIC
> 
> Nor these.
> 
> > INVALID_UTF8
> > LINUX_VERSION_CODE
> > MISSING_EOF_NEWLINE
> 
> OK I suppose.
> 
> > PREFER_SEQ_PUTS
> > PRINTK_WITHOUT_KERN_LEVEL
> 
> There are a lot of these.
> I suggest no here.
> 
> > RETURN_PARENTHESES
> > SIZEOF_PARENTHESIS
> 
> It's in coding style, but some newish patches
> do avoid them.  It's a question about how noisy
> you want your robot to be.

I'd prefer the robot to show up only when necessary. The coding style
warnings are good for the developers who actively run checkpatch.pl to
make their patch better. However most are probably not suitable for a
robot to send people unsolicited warnings.

> > SPACE_BEFORE_TAB
> > TRAILING_SEMICOLON
> > TRAILING_WHITESPACE
> > USE_DEVICE_INITCALL
> 
> > USE_RELATIVE_PATH
> 
> Having checkpatch tell people how to write changelogs
> I think not a great idea.
> 
> > These *ought* to make sense, but I don't know their false positive rates:
> > 
> > HEXADECIMAL_BOOLEAN_TEST
> 
> That's a good one.  0 false positives.
> 
> > ALLOC_ARRAY_ARGS
> 
> Yes, this would be reasonable too.
> 
> > CONSIDER_KSTRTO
> 
> I think orobably not.  This would be a cleanup thing.

Perhaps we can run it for a while, so that people at least come to
aware there is a kstrto() for use. :)

> > CONST_STRUCT
> 
> OK
> 
> > SPLIT_STRING
> 
> I suggest no but <shrug>

Thanks for both of your suggestions! I'll add the commonly agreed ones:

+INVALID_UTF8
+LINUX_VERSION_CODE
+MISSING_EOF_NEWLINE
+HEXADECIMAL_BOOLEAN_TEST
+ALLOC_ARRAY_ARGS
+CONST_STRUCT
+CONSIDER_KSTRTO

And remove the duplicate one (good catch, Josh!)

-KREALLOC_ARG_REUSE

Thanks,
Fengguang

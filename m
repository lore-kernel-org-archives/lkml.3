Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757176Ab3ICBeU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 21:34:20 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:37220 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752422Ab3ICBeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 21:34:18 -0400
X-Originating-IP: 50.43.39.152
Date: Mon, 2 Sep 2013 18:34:08 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Joe Perches <joe@perches.com>, David Howells <dhowells@redhat.com>,
        Andy Whitcroft <apw@canonical.com>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Wang Shilong <wangshilong1991@gmail.com>
Subject: Re: [Ksummit-2013-discuss] [PATCH] checkpatch: Add comment about
 updating Documentation/CodingStyle
Message-ID: <20130903013408.GA3437@leaf>
References: <20130902195056.GB32628@leaf>
 <9976.1378132260@warthog.procyon.org.uk>
 <1378138205.1953.66.camel@joe-AO722>
 <20130902181510.GA29787@leaf>
 <20130902181856.GB29787@leaf>
 <20130902153945.6d7e510c@samsung.com>
 <1378148367.1953.98.camel@joe-AO722>
 <13834.1378155023@warthog.procyon.org.uk>
 <1378156296.1953.117.camel@joe-AO722>
 <20130903003958.GA6855@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130903003958.GA6855@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 03, 2013 at 08:39:58AM +0800, Fengguang Wu wrote:
> On Mon, Sep 02, 2013 at 02:11:36PM -0700, Joe Perches wrote:
> > On Mon, 2013-09-02 at 21:50 +0100, David Howells wrote:
> > > Josh Triplett <josh@joshtriplett.org> wrote:
> > > 
> > > > > There are many checkpatch rules (like semicolons) that
> > > > > are not in CodingStyle.
> > > > 
> > > > It's a rule of thumb, not a mandate.  In *general*, checkpatch.pl should
> > > > not be enforcing style rules that aren't documented in CodingStyle.
> > > 
> > > Except that it becomes a mandate when someone runs it automatically against
> > > every one of your patches and then sends you an email for each patch it finds
> > > a checkpatch niggle against...
> > 
> > I think that any robot sending such checkpatch-only
> > emails should be disabled.
> > 
> > I know of 2 email robots.
> > 
> > Fengguang Wu's very useful build robot
> > sends out emails on build failures.
> > I think that's great.
> 
> Thanks! Yes I'm now running checkpatch these days because some people
> suggested to me that some of the checkpatch warnings do help catch
> real bugs.
> 
> However I do try to avoid upsetting people with maybe-subjective
> warnings. A checkpatch report will only be sent when a small fraction
> of error types are detected. Comments are very welcome on how to
> improve this list:
> 
> MEMSET
> IN_ATOMIC
> UAPI_INCLUDE
> MALFORMED_INCLUDE       
> SIZEOF_ADDRESS  
> KREALLOC_ARG_REUSE      
> EXECUTE_PERMISSIONS     
> ERROR:BAD_SIGN_OFF      
> LO_MACRO
> HI_MACRO
> CSYNC
> SSYNC
> HOTPLUG_SECTION
> INDENTED_LABEL
> INLINE_LOCATION
> STORAGE_CLASS
> USLEEP_RANGE
> UNNECESSARY_CASTS
> ALLOC_SIZEOF_STRUCT
> KREALLOC_ARG_REUSE
> USE_FUNC
> LOCKDEP
> EXPORTED_WORLD_WRITABLE
> WHITESPACE_AFTER_LINE_CONTINUATION
> MISSING_VMLINUX_SYMBOL
> NEEDLESS_IF
> PRINTF_L

Looks like you have KREALLOC_ARG_REUSE in that list twice.

Other than that, those look sensible.  I'd suggest a couple more, which
*should* always make sense, and to the best of my knowledge don't tend
to generate false positives:

C99_COMMENTS
CONFIG_EXPERIMENTAL
CVS_KEYWORD
ELSE_AFTER_BRACE
GLOBAL_INITIALIZERS
INITIALISED_STATIC
INVALID_UTF8
LINUX_VERSION_CODE
MISSING_EOF_NEWLINE
PREFER_SEQ_PUTS
PRINTK_WITHOUT_KERN_LEVEL
REDUNDANT_CODE
RETURN_PARENTHESES
SIZEOF_PARENTHESIS
SPACE_BEFORE_TAB
TRAILING_SEMICOLON
TRAILING_WHITESPACE
USE_DEVICE_INITCALL
USE_RELATIVE_PATH

These *ought* to make sense, but I don't know their false positive rates:

HEXADECIMAL_BOOLEAN_TEST
ALLOC_ARRAY_ARGS
CONSIDER_KSTRTO
CONST_STRUCT
SPLIT_STRING

The following almost always make sense, but only on patches not
yet applied to a tree:

PATCH_PREFIX
MODIFIED_INCLUDE_ASM
CORRUPTED_PATCH
NOT_UNIFIED_DIFF
MISSING_SIGN_OFF

- Josh Triplett

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751638AbaCaWUA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 18:20:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50500 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbaCaWT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 18:19:59 -0400
Date: Mon, 31 Mar 2014 15:19:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joe Perches <joe@perches.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 1/2] checkpatch: Expand parenthesis alignment test to
 declarations, functions and assignments
Message-Id: <20140331151957.e4a856ced0f1446135376e74@linux-foundation.org>
In-Reply-To: <1396303838.21529.68.camel@joe-AO722>
References: <bf056087fcb8139db3bbf6c187555ab64758f9d4.1396302777.git.joe@perches.com>
	<20140331150625.ca937ea946da5ce619efe2cf@linux-foundation.org>
	<1396303838.21529.68.camel@joe-AO722>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 Mar 2014 15:10:38 -0700 Joe Perches <joe@perches.com> wrote:

> On Mon, 2014-03-31 at 15:06 -0700, Andrew Morton wrote:
> > On Mon, 31 Mar 2014 14:58:07 -0700 Joe Perches <joe@perches.com> wrote:
> > 
> > > Currently the parenthesis alignment test works only on
> > > misalignments of if statements like
> > > 
> > > 	if (foo(bar,
> > > 			baz)
> > > 
> > > Expand the test to find misalignments like:
> > > 
> > > static inline int foo(int bar,
> > > 			int baz)
> > > 
> > > and
> > > 
> > > 	foo(bar,
> > > 			baz);
> > > 
> > > and
> > > 
> > > 	foo = bar(baz,
> > > 			qux);
> > > 
> > > Expand the $Inline keyword for __inline and __inline__ too.
> > > Add $Inline to $Declare so it also matches "static inline <foo>".
> > 
> > I'm having trouble understanding what this patch actually does.  Some
> > little examples would be nice.

?

> > I typed in this to play with:
> > 
> > void foo(int a,
> > 		int b)
> > {
> > }
> > 
> > but I experienced playus interruptus
> > 
> > akpm3:/usr/src/25> perl scripts/checkpatch.pl -f t.c
> > Global symbol "$c90_Keywords" requires explicit package name at scripts/checkpatch.pl line 2162.
> > Execution of scripts/checkpatch.pl aborted due to compilation errors.
> > 
> > System is Ubuntu 12.04.4 (ish).
> 
> You have to apply it to -next (your mm queue)

OK, the magic line was provided by
checkpatch-reduce-false-positives-for-missing-blank-line-after-declarations-test.patch,
which is marked "maybe merge, after I've played with it a bit".  I'll move
that hunk into
checkpatch-expand-parenthesis-alignment-test-to-declarations-functions-and-assignments.patch

--- a/scripts/checkpatch.pl~checkpatch-expand-parenthesis-alignment-test-to-declarations-functions-and-assignments-fix
+++ a/scripts/checkpatch.pl
@@ -304,6 +304,8 @@ our $Operators	= qr{
 			&&|\|\||,|\^|\+\+|--|&|\||$Arithmetic
 		  }x;
 
+our $c90_Keywords = qr{do|for|while|if|else|return|goto|continue|switch|default|case|break}x;
+
 our $NonptrType;
 our $NonptrTypeWithAttr;
 our $Type;
_


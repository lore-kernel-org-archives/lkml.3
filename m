Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751610AbaJOTuC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 15:50:02 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36258 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792AbaJOTuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 15:50:00 -0400
Date: Wed, 15 Oct 2014 12:50:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] checkpatch: Add error on use of attribute((weak))
 or __weak
Message-Id: <20141015125000.44353284288395e216659953@linux-foundation.org>
In-Reply-To: <1413402348.7484.8.camel@perches.com>
References: <cover.1413400022.git.joe@perches.com>
	<4391d882bb26278110d07b9a5e23ec44f5f8328a.1413400022.git.joe@perches.com>
	<20141015124225.01a4cad19c4f3a198efc996e@linux-foundation.org>
	<1413402348.7484.8.camel@perches.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Oct 2014 12:45:48 -0700 Joe Perches <joe@perches.com> wrote:

> On Wed, 2014-10-15 at 12:42 -0700, Andrew Morton wrote:
> > On Wed, 15 Oct 2014 12:32:08 -0700 Joe Perches <joe@perches.com> wrote:
> > 
> > > Using weak can have unintended link defects.
> > > Emit an error on its use.
> > 
> > Well, we don't want a warning about use of __weak in function
> > definitions.  Only in declarations.
> 
> Why is that?

Because the problem we're trying to detect is when __weak is used on a
declaration.

This is OK:

foo.h:
extern int foo(void);
foo.c:
int __weak foo(void)
{
	...
}

But this is not OK:

foo.h:
extern __weak int foo(void);
foo.c:
int __weak foo(void)
{
	...
}


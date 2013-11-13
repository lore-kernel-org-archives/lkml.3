Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759405Ab3KMSzK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 13:55:10 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42001 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756924Ab3KMSzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 13:55:06 -0500
Date: Wed, 13 Nov 2013 10:57:05 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: paulmck@linux.vnet.ibm.com, LKML <linux-kernel@vger.kernel.org>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH] rcu: Make struct rcu_head searchable
Message-Id: <20131113105705.c3fed1c5.akpm@linux-foundation.org>
In-Reply-To: <20131113131044.677cdc74@gandalf.local.home>
References: <20131113120225.3aacae13@gandalf.local.home>
	<20131113171205.GG4138@linux.vnet.ibm.com>
	<20131113131044.677cdc74@gandalf.local.home>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Nov 2013 13:10:44 -0500 Steven Rostedt <rostedt@goodmis.org> wrote:

> On Wed, 13 Nov 2013 09:12:05 -0800
> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> 
> > On Wed, Nov 13, 2013 at 12:02:25PM -0500, Steven Rostedt wrote:
> > > After wasting too much time trying to see where struct rcu_head was
> > > declared, I finally found it in include/linux/types.h as a define for
> > > callback_head!
> > > 
> > > To prevent other developers from wasting their precious time in
> > > searching for this structure, add a comment to help them find it!
> > > 
> > > Cc: Al Viro <viro@ZenIV.linux.org.uk>
> > > Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > > Signed-off-by: Steven "frustrated" Rostedt <rostedt@goodmis.org>
> > 
> > The cscope tool is your friend in this case, but nevertheless:
> 
> I use emacs, and the latest version of etags (or emacs) brings you to
> each use case before it gets you to the define (which is really
> annoying). Back in 2006 it use to work properly. I need to figure out
> what changed :-/

That irritates me too.  Fortunately I just invented

(grep "#define" tags && grep -v "#define" tags) > tags.new

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751926AbaLRWQJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 17:16:09 -0500
Received: from mail.kernel.org ([198.145.19.201]:51884 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751459AbaLRWQH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 17:16:07 -0500
Date: Thu, 18 Dec 2014 19:16:01 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org,
        Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@kernel.org>
Subject: Re: [PATCH] tools lib traceevent: Add support for IP address formats
Message-ID: <20141218221601.GG3150@kernel.org>
References: <1418915443-45707-1-git-send-email-dsahern@gmail.com>
 <20141218155255.GF3150@kernel.org>
 <20141218112715.42420caf@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141218112715.42420caf@gandalf.local.home>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Dec 18, 2014 at 11:27:15AM -0500, Steven Rostedt escreveu:
> On Thu, 18 Dec 2014 12:52:55 -0300
> Arnaldo Carvalho de Melo <acme@kernel.org> wrote:
> 
> > Em Thu, Dec 18, 2014 at 08:10:43AM -0700, David Ahern escreveu:
> > > Adds helper for following kernel formats:
> > >   %pi4 print an IPv4 address with leading zeros
> > >   %pI4 print an IPv4 address without leading zeros
> > >   %pi6 print an IPv6 address without colons
> > >   %pI6 print an IPv6 address with colons
> > >   %pI6c print an IPv6 address with colons
> > >   %pISpc print an IP address from a sockaddr

> > > Allows these formats to be used in tracepoints.

> > > Quite a bit of this is adapted from code in lib/vsprintf.c.

> > Can't we try as much as possible use that code directly? Something like
 
> Until we have a true shared library, please no. I'm still taking code
> from here and adding it manually to trace-cmd. And also sending patches
> to here from what I add to trace-cmd.
 
> I do not want this directly linked to the kernel code. Note, the kernel
> internals have no guaranteed API, where this does.

If using it directly is frowned upon, at least try to reduce the
differences when copying code, be it by keeping function ordering in the
source code, using the same file name and generally making it easier to
see if changes ocurred on the original file over time.

> > we do for lib/rbtree.c in tools/perf/, or like I did recently with
> > tools/lib/util/find_next_bit.c, i.e. retain at least this kind of
> > sharing:

> > diff -u tools/lib/util/find_next_bit.c  lib/find_next_bit.c
 
> Unless we convert code to trace_seq, I don't think this works. My
> patches to move seq_buf.c int lib/ have made it into the kernel.
> Perhaps we can copy the seq_buf.c code into tools/lib/traceevent, but
> that would take some work.

Well, I thought that what that code was doing was just taking a string,
looking for some specific %LETTER stuff, acting on it and returning the
formatted result, i.e. a vsprintf function, thus I ended up shortcutting
too fast to the conclusion that it was possible, my bad :-)

If take the time to look at the specifics I'll propose something more
concrete, meanwhile, are you ok with David's changes? May I process his
patch?

- Arnaldo

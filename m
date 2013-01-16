Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757255Ab3APSjG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 13:39:06 -0500
Received: from mail-gh0-f170.google.com ([209.85.160.170]:36616 "EHLO
	mail-gh0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756278Ab3APSjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 13:39:02 -0500
Date: Wed, 16 Jan 2013 15:38:55 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 07/10] perf sort: Check return value of strdup()
Message-ID: <20130116183855.GQ5826@ghostprotocols.net>
References: <1356599507-14226-1-git-send-email-namhyung@kernel.org>
 <1356599507-14226-8-git-send-email-namhyung@kernel.org>
 <20130111051745.GF3054@ghostprotocols.net>
 <1358066617.1594.10.camel@leonhard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1358066617.1594.10.camel@leonhard>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sun, Jan 13, 2013 at 05:43:37PM +0900, Namhyung Kim escreveu:
> Hi Arnaldo,
> 
> 2013-01-11 (금), 02:17 -0300, Arnaldo Carvalho de Melo:
> > Em Thu, Dec 27, 2012 at 06:11:44PM +0900, Namhyung Kim escreveu:
> > > From: Namhyung Kim <namhyung.kim@lge.com>
> > > 
> > > When setup_sorting() is called, 'str' is passed to strtok_r() but it's
> > > not checked to have a valid pointer.  As strtok_r() accepts NULL
> > > pointer on a first argument and use the third argument in that case,
> > > it can cause a trouble since our third argument, tmp, is not
> > > initialized.
> > 
> > Ok, but calling exit from here? Better to check it at the callers and
> > propagate the error, letting things like TUI/gui exit routines to
> > execute.
> 
> That's fine to me too, but currently setup_sorting() exits through
> usage_with_options() if sort_dimension__add() fails and I followed the
> convention here.  Making it to return will require changes to every
> callsites of the function.
> 
> If you think it's better to change, I can do it as well.

I think this is a good opportunity to do that :-)

I just grepped for 'setup_sorting' and we have some private ones in
builtin-kmem, for instance, that return a value and that value is
checked, etc. Good precendent :-)

- Arnaldo

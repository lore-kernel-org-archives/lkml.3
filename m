Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761424Ab3LITX7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 14:23:59 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:22663 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755833Ab3LITXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 14:23:55 -0500
Date: Mon, 9 Dec 2013 14:23:50 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 01/14] tools lib traceevent: Get rid of malloc_or_die()
 in show_error()
Message-ID: <20131209142350.5d23108c@gandalf.local.home>
In-Reply-To: <20131209191439.GG8098@ghostprotocols.net>
References: <1386567251-22751-1-git-send-email-namhyung@kernel.org>
	<1386567251-22751-2-git-send-email-namhyung@kernel.org>
	<20131209183009.GC8098@ghostprotocols.net>
	<20131209140342.5f72298f@gandalf.local.home>
	<20131209191439.GG8098@ghostprotocols.net>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Dec 2013 16:14:39 -0300
Arnaldo Carvalho de Melo <acme@ghostprotocols.net> wrote:

> Em Mon, Dec 09, 2013 at 02:03:42PM -0500, Steven Rostedt escreveu:
> > On Mon, 9 Dec 2013 15:30:09 -0300
> > Arnaldo Carvalho de Melo <acme@ghostprotocols.net> wrote:
> > 
> > 
> > > > +		error = malloc(MAX_ERR_STR_SIZE);
> > > > +		if (error == NULL) {
> > > > +			/* no memory */
> > > > +			*error_str = "failed to allocate memory";
> > > > +			return;
> > > 
> > > Can *error_str point to either malloc'ed or constant strings? Who
> > > releases the allocated memory?
> > > 
> > 
> > Good question. Perhaps we should have a flag that states if the string
> > is allocated or not. Or better yet, since the only reason it would be
> > pointing to a static string is if the string for error_str itself
> > failed to allocate. Then we could use a string within pevent for it:
> > 
> > static char *pevent_failed_error_alloc = "failed to allocate memory";
> > 
> > Then in the freeing of error str:
> > 
> > void pevent_free_error_str(error_str)
> > {
> > 	if (error_str != pevent_failed_error_alloc)
> > 		free(error_str);
> > }
> 
> That is a possibility, yes, then any other routine that works in such a
> way could check against this string, but what is wrong with returning a
> value to that function and checking against < 0?

Then everyone has to check if show_error() failed. Then report a bug if
it did. Egad, then we need to check if that error function failed, and
then that one and that one and that one :-)

-- Steve

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932541Ab3LITO4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 14:14:56 -0500
Received: from mail-yh0-f48.google.com ([209.85.213.48]:60434 "EHLO
	mail-yh0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932186Ab3LITOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 14:14:53 -0500
Date: Mon, 9 Dec 2013 16:14:39 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 01/14] tools lib traceevent: Get rid of malloc_or_die()
 in show_error()
Message-ID: <20131209191439.GG8098@ghostprotocols.net>
References: <1386567251-22751-1-git-send-email-namhyung@kernel.org>
 <1386567251-22751-2-git-send-email-namhyung@kernel.org>
 <20131209183009.GC8098@ghostprotocols.net>
 <20131209140342.5f72298f@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131209140342.5f72298f@gandalf.local.home>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Dec 09, 2013 at 02:03:42PM -0500, Steven Rostedt escreveu:
> On Mon, 9 Dec 2013 15:30:09 -0300
> Arnaldo Carvalho de Melo <acme@ghostprotocols.net> wrote:
> 
> 
> > > +		error = malloc(MAX_ERR_STR_SIZE);
> > > +		if (error == NULL) {
> > > +			/* no memory */
> > > +			*error_str = "failed to allocate memory";
> > > +			return;
> > 
> > Can *error_str point to either malloc'ed or constant strings? Who
> > releases the allocated memory?
> > 
> 
> Good question. Perhaps we should have a flag that states if the string
> is allocated or not. Or better yet, since the only reason it would be
> pointing to a static string is if the string for error_str itself
> failed to allocate. Then we could use a string within pevent for it:
> 
> static char *pevent_failed_error_alloc = "failed to allocate memory";
> 
> Then in the freeing of error str:
> 
> void pevent_free_error_str(error_str)
> {
> 	if (error_str != pevent_failed_error_alloc)
> 		free(error_str);
> }

That is a possibility, yes, then any other routine that works in such a
way could check against this string, but what is wrong with returning a
value to that function and checking against < 0?

- Arnaldo

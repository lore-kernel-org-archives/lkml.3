Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751483Ab3LKBza (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 20:55:30 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:23678 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751418Ab3LKBz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 20:55:28 -0500
Date: Tue, 10 Dec 2013 20:55:26 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 01/14] tools lib traceevent: Get rid of malloc_or_die()
 in show_error()
Message-ID: <20131210205526.567874b1@gandalf.local.home>
In-Reply-To: <87vbywi5j0.fsf@sejong.aot.lge.com>
References: <1386567251-22751-1-git-send-email-namhyung@kernel.org>
	<1386567251-22751-2-git-send-email-namhyung@kernel.org>
	<20131209183009.GC8098@ghostprotocols.net>
	<20131209140342.5f72298f@gandalf.local.home>
	<20131209191439.GG8098@ghostprotocols.net>
	<20131209142350.5d23108c@gandalf.local.home>
	<87mwk9jwcf.fsf@sejong.aot.lge.com>
	<20131209211410.01fcaebf@gandalf.local.home>
	<878uvtjo3r.fsf@sejong.aot.lge.com>
	<87zjo9i87p.fsf@sejong.aot.lge.com>
	<87vbywi5j0.fsf@sejong.aot.lge.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Dec 2013 09:40:35 +0900
Namhyung Kim <namhyung@kernel.org> wrote:


> >>> Perhaps call it
> >>>
> >>> 	pevent->filter_error_buffer
> >>>
> >>> ?
> >
> > Hmm.. thinking about it twice, if it's only for filter functions
> > wouldn't it be better moving it to event_filter rather than pevent?
> >
> > 	filter->error_buffer

Agreed.

> >
> 
> One more thinking, if we agree on converting to return error code, does
> pevent_filter_add_filter_str() also need to be changed not to receive
> the third "error_str" argument?

Yes, if we add the filter->error_buffer, we can remove it here.

> 
> And should we extend the error code to include the return value of
> pevent_filter_match() too?  If not, it seems we need to pass another
> argument to receive the actual error code in case of FILTER_ERROR.

I'm a bit confused on this. Perhaps it's something you added in your
patches. If what returns FILTER_ERROR?

> 
> I'm saying these here since they might require interface/signature
> change so will affect existing users like trace-cmd.

I'm OK if they change now. I'll have trace-cmd and other users adapt.
As each currently has their own copy. I've been updating trace-cmd with
what's in tools for a while now, and plan to continue doing that until
we have something that seems good for a public library.

-- Steve

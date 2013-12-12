Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752046Ab3LLBKM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 20:10:12 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:46308 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751831Ab3LLBKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 20:10:06 -0500
Date: Wed, 11 Dec 2013 20:10:02 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 01/14] tools lib traceevent: Get rid of malloc_or_die()
 in show_error()
Message-ID: <20131211201002.6236bcfd@gandalf.local.home>
In-Reply-To: <8761qwi0hq.fsf@sejong.aot.lge.com>
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
	<20131210205526.567874b1@gandalf.local.home>
	<8761qwi0hq.fsf@sejong.aot.lge.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Dec 2013 11:29:21 +0900
Namhyung Kim <namhyung@kernel.org> wrote:

> On Tue, 10 Dec 2013 20:55:26 -0500, Steven Rostedt wrote:
> > On Wed, 11 Dec 2013 09:40:35 +0900
> > Namhyung Kim <namhyung@kernel.org> wrote:
> >> And should we extend the error code to include the return value of
> >> pevent_filter_match() too?  If not, it seems we need to pass another
> >> argument to receive the actual error code in case of FILTER_ERROR.
> >
> > I'm a bit confused on this. Perhaps it's something you added in your
> > patches. If what returns FILTER_ERROR?
> 
> Well, I mean there are some cases which return FILTER_ERROR.  With my
> patch, test_filter() can failed with the error_str set like following:
> 
>  - invalid expression type
>  - must have number field
>  - invalid numeric argument type
>  - invalid numeric comparison type
>  - invalid string comparison type
>  - invalid operator type
>  - invalid argument type
> 
> To distinguish them, we either need to extend return value or another
> argument.  But the current return value of pevent_filter_match() was
> defined as FILTER_{MATCH,MISS,NOEXIST,NONE,ERROR}.
> 
> And also I want all user APIs share same return value/type as
> pevent_errno so that user can pass it our strerror function to see the
> error message.
> 
> So to use return value, we need to extend the error code to include all
> possible error cases above as well as normal cases (MATCH, MISS, ...).

Sure, lets add them to the list of pevent errnos.


> 
> >
> >> 
> >> I'm saying these here since they might require interface/signature
> >> change so will affect existing users like trace-cmd.
> >
> > I'm OK if they change now. I'll have trace-cmd and other users adapt.
> > As each currently has their own copy. I've been updating trace-cmd with
> > what's in tools for a while now, and plan to continue doing that until
> > we have something that seems good for a public library.
> 
> Okay, I'll cook the patch soon!
> 

My only concern with the libtraceevent API is that it still maintains
all the features that it currently has.

-- Steve

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751460Ab3LKC30 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 21:29:26 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:44685 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921Ab3LKC3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 21:29:24 -0500
X-AuditID: 9c930197-b7bdbae000000e78-a3-52a7ce02052f
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 01/14] tools lib traceevent: Get rid of malloc_or_die() in show_error()
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
Date: Wed, 11 Dec 2013 11:29:21 +0900
In-Reply-To: <20131210205526.567874b1@gandalf.local.home> (Steven Rostedt's
	message of "Tue, 10 Dec 2013 20:55:26 -0500")
Message-ID: <8761qwi0hq.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Dec 2013 20:55:26 -0500, Steven Rostedt wrote:
> On Wed, 11 Dec 2013 09:40:35 +0900
> Namhyung Kim <namhyung@kernel.org> wrote:
>> And should we extend the error code to include the return value of
>> pevent_filter_match() too?  If not, it seems we need to pass another
>> argument to receive the actual error code in case of FILTER_ERROR.
>
> I'm a bit confused on this. Perhaps it's something you added in your
> patches. If what returns FILTER_ERROR?

Well, I mean there are some cases which return FILTER_ERROR.  With my
patch, test_filter() can failed with the error_str set like following:

 - invalid expression type
 - must have number field
 - invalid numeric argument type
 - invalid numeric comparison type
 - invalid string comparison type
 - invalid operator type
 - invalid argument type

To distinguish them, we either need to extend return value or another
argument.  But the current return value of pevent_filter_match() was
defined as FILTER_{MATCH,MISS,NOEXIST,NONE,ERROR}.

And also I want all user APIs share same return value/type as
pevent_errno so that user can pass it our strerror function to see the
error message.

So to use return value, we need to extend the error code to include all
possible error cases above as well as normal cases (MATCH, MISS, ...).

>
>> 
>> I'm saying these here since they might require interface/signature
>> change so will affect existing users like trace-cmd.
>
> I'm OK if they change now. I'll have trace-cmd and other users adapt.
> As each currently has their own copy. I've been updating trace-cmd with
> what's in tools for a while now, and plan to continue doing that until
> we have something that seems good for a public library.

Okay, I'll cook the patch soon!

Thanks,
Namhyung

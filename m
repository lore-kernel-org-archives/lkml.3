Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751199Ab3LJFBr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 00:01:47 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:59056 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748Ab3LJFBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 00:01:46 -0500
X-AuditID: 9c93017e-b7bb9ae000000ec8-3a-52a6a0389d33
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
Date: Tue, 10 Dec 2013 14:01:44 +0900
In-Reply-To: <20131209211410.01fcaebf@gandalf.local.home> (Steven Rostedt's
	message of "Mon, 9 Dec 2013 21:14:10 -0500")
Message-ID: <878uvtjo3r.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Dec 2013 21:14:10 -0500, Steven Rostedt wrote:
> On Tue, 10 Dec 2013 11:03:44 +0900
> Namhyung Kim <namhyung@kernel.org> wrote:
>
>> What about returning error code rather than string?  This way we won't
>> worry about the allocation of the error string itself.
>> 
>> But the downside of it is loosing a positional info of the error.
>> Hmm.. what about using a static buffer in pevent for it then?
>
> A static buffer may be the solution. Never need to worry about
> allocating it on error, as it will already be allocated. And we can add
> APIs to print it nicely.
>
> Perhaps call it
>
> 	pevent->filter_error_buffer
>
> ?

Okay, I'll go with this.

Thanks,
Namhyung

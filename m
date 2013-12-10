Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752099Ab3LJCON (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 21:14:13 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:64592 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750858Ab3LJCOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 21:14:12 -0500
Date: Mon, 9 Dec 2013 21:14:10 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 01/14] tools lib traceevent: Get rid of malloc_or_die()
 in show_error()
Message-ID: <20131209211410.01fcaebf@gandalf.local.home>
In-Reply-To: <87mwk9jwcf.fsf@sejong.aot.lge.com>
References: <1386567251-22751-1-git-send-email-namhyung@kernel.org>
	<1386567251-22751-2-git-send-email-namhyung@kernel.org>
	<20131209183009.GC8098@ghostprotocols.net>
	<20131209140342.5f72298f@gandalf.local.home>
	<20131209191439.GG8098@ghostprotocols.net>
	<20131209142350.5d23108c@gandalf.local.home>
	<87mwk9jwcf.fsf@sejong.aot.lge.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Dec 2013 11:03:44 +0900
Namhyung Kim <namhyung@kernel.org> wrote:


> What about returning error code rather than string?  This way we won't
> worry about the allocation of the error string itself.
> 
> But the downside of it is loosing a positional info of the error.
> Hmm.. what about using a static buffer in pevent for it then?

A static buffer may be the solution. Never need to worry about
allocating it on error, as it will already be allocated. And we can add
APIs to print it nicely.

Perhaps call it

	pevent->filter_error_buffer

?

-- Steve

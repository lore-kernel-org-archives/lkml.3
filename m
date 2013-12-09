Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933911Ab3LIQlI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 11:41:08 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:4828 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932843Ab3LIQlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 11:41:01 -0500
Date: Mon, 9 Dec 2013 11:40:59 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCHSET 00/14] tools lib traceevent: Get rid of *die() calls
 from parse-filter.c
Message-ID: <20131209114059.552b9221@gandalf.local.home>
In-Reply-To: <20131209104718.GG1242@krava.brq.redhat.com>
References: <1386567251-22751-1-git-send-email-namhyung@kernel.org>
	<20131209104718.GG1242@krava.brq.redhat.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Dec 2013 11:47:18 +0100
Jiri Olsa <jolsa@redhat.com> wrote:

> On Mon, Dec 09, 2013 at 02:33:57PM +0900, Namhyung Kim wrote:
> > Hello,
> 
> SNIP
> 
> > 
> >  tools/lib/traceevent/event-parse.h  |   3 +-
> >  tools/lib/traceevent/parse-filter.c | 432 +++++++++++++++++++++++++-----------
> 
> I guess we have plans to actualy use parse-filter.c right? ;-)
> 
> AFAICS currently there's no user and could (should?) be omited
> from compilation
> 

There's no user in tools/ but there's users outside of tools. If this
is going to be a user space library, then I wouldn't hold it to the
same level that the main kernel has. That is, if there's no internal
users of an interface, that we do not support it.

This library did come from trace-cmd, and trace-cmd does use these
interfaces. I would like to have a single repository for the library,
but that wont happen if we don't support all the interfaces.

-- Steve

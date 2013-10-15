Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932895Ab3JOOc5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 10:32:57 -0400
Received: from mail-vb0-f44.google.com ([209.85.212.44]:54077 "EHLO
	mail-vb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932272Ab3JOOcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 10:32:55 -0400
Date: Tue, 15 Oct 2013 11:32:45 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 3/3] perf record: mmap output file
Message-ID: <20131015143245.GB9828@ghostprotocols.net>
References: <1381289214-24885-1-git-send-email-dsahern@gmail.com>
 <1381289214-24885-4-git-send-email-dsahern@gmail.com>
 <20131009055957.GA7664@gmail.com>
 <525D4B5F.4090005@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <525D4B5F.4090005@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Oct 15, 2013 at 08:04:15AM -0600, David Ahern escreveu:
> On 10/8/13 11:59 PM, Ingo Molnar wrote:
> > 2)

> > Yet another method would be to avoid the copies altogether via the splice
> > system-call - see:

> >	git grep splice kernel/trace/

> > To make splice low-overhead we'd have to introduce a mode to not mmap
> > the data part of the perf ring-buffer and splice the data straight
> > from the perf fd into a temporary pipe and over from the pipe into
> > the target file (or socket).

> I looked into splice and it was not clear it would be a good match.
> First, perf is setup to pull data from mmap's and there is not a 1:1
> association between mmap's and fd's (fd_in for splice). Second and

Jiri and PeterZ probaby will have comments here... ;-) :-)

Jiri even have patches, IIRC.

- Arnaldo

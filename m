Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757341Ab3EGG3y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 02:29:54 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:47078 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756170Ab3EGG3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 02:29:53 -0400
Date: Tue, 7 May 2013 08:29:47 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Stephane Eranian <eranian@google.com>
Cc: David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>, Mike Galbraith <efault@gmx.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH] perf record: handle death by SIGTERM
Message-ID: <20130507062947.GB17705@gmail.com>
References: <1367864663-1309-1-git-send-email-dsahern@gmail.com>
 <CABPqkBTj6Jt82mvVJKJxXaGnbD5GbW5mo4L71StOZuA=8MwDdw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBTj6Jt82mvVJKJxXaGnbD5GbW5mo4L71StOZuA=8MwDdw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stephane Eranian <eranian@google.com> wrote:

> This is a good fix. I have run into this infinite loop in perf report 
> many times.

Hm, perf record should really not assume much about the perf.data and 
should avoid infinite loops ...

So while making perf.data more consistent on SIGTERM is a nice fix, perf 
report should be fixed as well to detect loops and such.

Thanks,

	Ingo

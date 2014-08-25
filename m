Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755939AbaHYP4Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 11:56:25 -0400
Received: from mail.kernel.org ([198.145.19.201]:57387 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754766AbaHYP4X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 11:56:23 -0400
Date: Mon, 25 Aug 2014 12:56:13 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Borislav Petkov <bp@suse.de>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [RFC 00/10] perf pollfd series
Message-ID: <20140825155613.GA2849@kernel.org>
References: <1408741190-5123-1-git-send-email-acme@kernel.org>
 <20140825110431.GC11611@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140825110431.GC11611@krava.brq.redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Aug 25, 2014 at 01:04:31PM +0200, Jiri Olsa escreveu:
> fdarray name seems too generic for this object, fdpoll looks
> more suitable.. also given that the file name is poll.[ch] ;-)

I thought about 'struct pollfds', then thought that having 'poll' in the
name of the class and in its main routine, i.e. pollfds__poll, would be
too much.

I thought of it as an extensible array of file descriptors that right
now has just poll related operations, but could have some other
operations, perhaps the associated mmaps in evlist, for instance.

I ended up using poll.[ch] because struct pollfd came from poll.h, but
yeah, that is inconsistent with poll being just one of the operations
for an extensible array of file descriptors, so it should be renamed
accordingly to 'fdarray.[ch]'.

That was my reasoning.

I'm looking at the other comments, would send a fix for what Adrian
commented but thought about an optimization, will do that after lunch,
hopefully food will prevent me from adding more bugs 8-)

> anyway, except for what I've already commented:

> Acked-by: Jiri Olsa <jolsa@kernel.org>

Thanks!

- Arnaldo

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754991AbaIVVKe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 17:10:34 -0400
Received: from mail.kernel.org ([198.145.19.201]:55243 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752887AbaIVVKd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 17:10:33 -0400
Date: Mon, 22 Sep 2014 18:10:27 -0300
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
Subject: Re: [RFC 00/14] perf pollfd v3
Message-ID: <20140922211027.GA23362@kernel.org>
References: <1410358129-9965-1-git-send-email-acme@kernel.org>
 <20140911113336.GB13634@krava.brq.redhat.com>
 <20140911114825.GC13634@krava.brq.redhat.com>
 <20140911133029.GC10158@kernel.org>
 <20140911213638.GC1801@kernel.org>
 <20140918160455.GI2770@kernel.org>
 <20140922133526.GB18187@krava.brq.redhat.com>
 <20140922144949.GE32694@kernel.org>
 <20140922145133.GA18809@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140922145133.GA18809@krava.brq.redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Sep 22, 2014 at 04:51:33PM +0200, Jiri Olsa escreveu:
> On Mon, Sep 22, 2014 at 11:49:49AM -0300, Arnaldo Carvalho de Melo wrote:
> > Em Mon, Sep 22, 2014 at 03:35:26PM +0200, Jiri Olsa escreveu:
> > > On Thu, Sep 18, 2014 at 01:04:55PM -0300, Arnaldo Carvalho de Melo wrote:
> > > > Em Thu, Sep 11, 2014 at 06:36:38PM -0300, Arnaldo Carvalho de Melo escreveu:
> > > > https://git.kernel.org/cgit/linux/kernel/git/acme/linux.git/log/?h=perf/fdarray.v4

> > > > Its on top of my last perf/core branch, i.e. with builtin-record.c using
> > > > perf_evlist__mmap_consume() and it and builtin-trace.c doing one last
> > > > mmap_read loop to consume what is left after all fds for a mmap are
> > > > closed.

> > > > I'll wait a bit before reposting, probably Jiri will not be able to
> > > > comment this week, but I would like to at least post the URL for this
> > > > latest v4 kit.

> > > > Adrian, if you could take a look at it, would be really great :-)

> > > I checked the branch.. the last patch brakes the functionality
> > > of perf record for me

> > Breaks in what sense?

> perf record -p pid

> and killing the pid won't finish perf record

Should be ok now, after making sure record uses
perf_evlist__mmap_consume(), which does what you did in your proposed
fix, tried both killing it and letting it exit normally, i.e. a 'sleep 5s'
target.

Pushed
https://git.kernel.org/cgit/linux/kernel/git/acme/linux.git/log/?h=perf/fdarray.v6
after moving the changesets for trace and record to be done last,
waiting for all fds to be POLLHUP'ed and doing one last draining
mmap_read loop over the mmaps.

- Arnaldo

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756522Ab3K0PyS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 10:54:18 -0500
Received: from mail-bk0-f52.google.com ([209.85.214.52]:35515 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749Ab3K0PyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 10:54:16 -0500
Date: Wed, 27 Nov 2013 16:54:12 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: David Ahern <dsahern@gmail.com>, Adrian Hunter <adrian.hunter@intel.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Namhyung Kim <namhyung@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] tools/perf/util: Document and clean up readn() a bit
Message-ID: <20131127155412.GA26883@gmail.com>
References: <1385130268-10664-1-git-send-email-jolsa@redhat.com>
 <1385130268-10664-2-git-send-email-jolsa@redhat.com>
 <20131125192909.GA27323@ghostprotocols.net>
 <20131126175335.GA9300@gmail.com>
 <5295AFA3.6060007@intel.com>
 <20131127115746.GB10528@gmail.com>
 <52960D71.7010107@gmail.com>
 <20131127155017.GG1208@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131127155017.GG1208@krava.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jiri Olsa <jolsa@redhat.com> wrote:

> On Wed, Nov 27, 2013 at 08:19:13AM -0700, David Ahern wrote:
> > On 11/27/13, 4:57 AM, Ingo Molnar wrote:
> > >Okay, I thought this was an intentional 'all or nothing' interface -
> > >but looking at the readn() users they can tolerate partial results
> > >just fine.
> > 
> > I believe that is the intent -- an all or nothing interface.
> 
> all the users either checks the returned value with the size
> or do (ret < 0) and fail

so, a 'ret < 0' check would actually be sensitive to whether readn() 
is an all-or-nothing interface (today), or a partial interface (the 
suggestion).

So it appears keeping it all-or-nothing (i.e. my patch) is the right 
approach.

> and one instance in the read_attr does not check anything and 
> blindly hopes it will read all ;-)
> 
> I have similar patch that also change callers to use proper ssize_t 
> instead of int.. I can rebase and send it separately or combine it 
> with yours.. let me know

Sure ... I just noticed a few patterns. Feel free to use all (or none 
;-) of my patch in your series.

Thanks,

	Ingo

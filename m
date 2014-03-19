Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965329AbaCSOoW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 10:44:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10301 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932861AbaCSOoV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 10:44:21 -0400
Date: Wed, 19 Mar 2014 10:43:53 -0400
From: Don Zickus <dzickus@redhat.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 06/13] perf tools: Use tid in mmap/mmap2 events to find
 maps
Message-ID: <20140319144353.GC25953@redhat.com>
References: <1395177965-8879-1-git-send-email-acme@infradead.org>
 <1395177965-8879-7-git-send-email-acme@infradead.org>
 <532943A2.7040407@intel.com>
 <20140319131945.GW25953@redhat.com>
 <20140319133025.GF1449@krava.brq.redhat.com>
 <5329A94D.9060701@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5329A94D.9060701@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 19, 2014 at 04:27:25PM +0200, Adrian Hunter wrote:
> On 19.03.2014 15:30, Jiri Olsa wrote:
> > On Wed, Mar 19, 2014 at 09:19:45AM -0400, Don Zickus wrote:
> >> On Wed, Mar 19, 2014 at 09:13:38AM +0200, Adrian Hunter wrote:
> >>> On 18.03.2014 23:25, Arnaldo Carvalho de Melo wrote:
> >>>> From: Don Zickus <dzickus@redhat.com>
> >>>>
> >>>> Now that we can properly synthesize threads system-wide, make sure the
> >>>> mmap and mmap2 events use tids instead of pids to locate their maps.
> >>>
> >>> This is a good change but it cannot go yet because it is dependent on Jiri's
> >>> "perf tools: Share map groups within process" series.
> >>
> >> No it isn't. :-) Commit bfd66cc71a3f831ba7c2116d79416cfb8883f6cf is the
> >> reason why.  It synthesizes thread events to make this work correctly.
> > 
> > ok, I haven't realized this one was pulled in as well ;-)
> > it's ok then..
> 
> No, you mustn't split up the maps between threads.  We currently assume
> CLONE_VM is always used to create threads.

But that doesn't work when you try to synthesize threads which was the
problem I was trying to solve.

Cheers,
Don

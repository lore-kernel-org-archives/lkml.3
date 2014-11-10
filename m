Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857AbaKJMPf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 07:15:35 -0500
Received: from mail.kernel.org ([198.145.19.201]:48048 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752108AbaKJMPc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 07:15:32 -0500
Date: Mon, 10 Nov 2014 09:15:27 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Vince Weaver <vince@deater.net>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@redhat.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFD] perf syscall error handling
Message-ID: <20141110121527.GQ18464@kernel.org>
References: <alpine.DEB.2.10.1410302111150.2766@pianoman.cluster.toy>
 <20141031072109.GD12706@worktop.programming.kicks-ass.net>
 <20141031092713.GA23124@gmail.com>
 <20141031122824.GZ12020@console-pimps.org>
 <CABPqkBS0gKWyTc=TFpGxRwOQkAe1o5zXtWaUyHezpO53LhCqrQ@mail.gmail.com>
 <alpine.DEB.2.10.1411010130170.6256@pianoman.cluster.toy>
 <20141103162548.GB18464@kernel.org>
 <20141103165019.GY10501@worktop.programming.kicks-ass.net>
 <20141103170059.GC18464@kernel.org>
 <20141110102725.GA19309@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141110102725.GA19309@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Nov 10, 2014 at 11:27:25AM +0100, Ingo Molnar escreveu:
> 
> * Arnaldo Carvalho de Melo <acme@kernel.org> wrote:
> 
> > Em Mon, Nov 03, 2014 at 05:50:19PM +0100, Peter Zijlstra escreveu:
> > > On Mon, Nov 03, 2014 at 02:25:48PM -0200, Arnaldo Carvalho de Melo wrote:
> >  
> > > > The way that peterz suggested, i.e. returning information about which
> > > > perf_event_attr and which of the parameters was invalid/had issues could
> > > > help with fallbacking/capability querying, i.e. tooling may want to use
> > > > some features if available automagically, fallbacking to something else
> > > > when that fails.
> >  
> > > > We already do that to some degree in various cases, but for some if the
> > > > only way that becomes available to disambiguate some EINVAL return is a
> > > > string, code will start having strcmps :-\
> > 
> > > OK, so how about we do both, the offset+mask for the tools 
> > > and the string for the humans?
> > 
> > Yeah, tooling tries to provide the best it can with the 
> > offset+mask, and if doesn't manage to do anything smart with 
> > it, just show the string and hope that helps the user to figure 
> > out what is happening.
> 
> Almost: tooling should generally always consider the string as 
> well, for the (not so uncommon) case where there can be multiple 
> problems with the same field.
> 
> Really, I think the string will give the most bang for the buck, 
> because it's really simple and straightforward on the kernel side 
> (so that we have a good chance of achieving full coverage 
> relatively quickly), and later on we could still complicate it 
> all with offset+mask if there's really a need.
> 
> So lets start with an error string...

I don't have a problem with the order of introduction of new error
reporting mechanisms, or at least I can't think of one right now.

So if we introduce strings now then tools/perf/ will trow them to the
user when it still don't have fallbacks or any other UI indication of
such an error.

I wonder tho if we have any previous experience on some other project
(or even in the kernel?) and how userspace ended up using it, if just
presenting those strings to the user or if trying to parse it, etc,
anybody?

- Arnaldo

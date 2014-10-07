Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940AbaJGNk2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 09:40:28 -0400
Received: from mail.kernel.org ([198.145.19.201]:37284 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753216AbaJGNk0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 09:40:26 -0400
Date: Tue, 7 Oct 2014 10:40:21 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Jean Pihet <jean.pihet@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Fu Wei <fu.wei@linaro.org>, Robert Richter <rric@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, David Ahern <dsahern@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Matt Fleming <matt@console-pimps.org>
Subject: Re: perf & rasd integration plan
Message-ID: <20141007134021.GH14113@kernel.org>
References: <CAFrcx1kufO2yj7--UiL841Yp5Es5=WqjL__Yzg=-+nPV5XoohA@mail.gmail.com>
 <20141006150741.GB14113@kernel.org>
 <20141006151605.GE4372@pd.tnic>
 <20141006191227.GD14113@kernel.org>
 <20141006195349.GE20739@pd.tnic>
 <20141006212243.GE14113@kernel.org>
 <20141007112342.GC30146@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141007112342.GC30146@pd.tnic>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Oct 07, 2014 at 01:23:42PM +0200, Borislav Petkov escreveu:
> On Mon, Oct 06, 2014 at 06:22:43PM -0300, Arnaldo Carvalho de Melo wrote:
> > My preference would be for single object files, but the pressure to have
> > a written in stone library seems to just build up...
 
> Yeah, I think if we have an alternative way to easily integrate that
> functionality into external projects, we can avoid the need for a lib.
 
> ...
 
> > After doing a 'make perf-targz-src-pkg'

> > I.e. no kernel sources involved on the machines where I build test.

> > IOW, it is untangled from the kernel sources. As tools/lib/api/ should
> > as well.

> Ok, that actually sounds like something we should try:

> $ make perf-api-src-pkg

> which would spit a tgz with all the generic stuff perf carries. People
> would simply unpack it in their projects and build it.

> That would require somewhat stable function names so that updating is
> relatively painless and if visible functions change, some sort of a

Right, we now should always think that the great advantage of having
this code and its users in the same repo tree is going away, i.e. we
will not be able to improve the code by fixing mistakes that require
changing its users.

So we should export the bare minimum that tools advocate exporting, like
you guys are doing now by providing the code that shows how you use it.

> README file should say what and why.

Well, at that point we can't do that anymore, we will need instead to
add new methods while keeping the existing ones in place and with the
same semantics, at most for something really annoying to maintain we
will have to add annoying warnings telling that in a year or two
something will go away, it was deprecated, annoy the maintainer of your
tool to update their project.

> Sounds like a good alternative to a lib to me...

Yes, should be interesting to experiment with this, at the very least it
can be considered a step into the direction of a full blown library, if
we ever feel that it is strictly needed.
 
> > Well, the rasd experience is serving to show areas where there is
> > unnecessary entanglement (hists inside perf_event, etc, the ifdefs you
> > put in place).
 
> Yep.
 
> > I'm working to remove the ones that are in rasd.c, aiming to have a
> > tools/lib/api/ tree that can be used to build rasd and tools/perf/.

> > What I don't want to do is to simply straight more

       s/more/move/g

> > tools/perf/util/evlist.c to tools/lib/api/perf/, some untanglement work
> > is needed.
 
> Yep.

- Arnaldo

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911AbaJGONV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 10:13:21 -0400
Received: from mail.kernel.org ([198.145.19.201]:39168 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753305AbaJGONU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 10:13:20 -0400
Date: Tue, 7 Oct 2014 11:13:15 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Jean Pihet <jean.pihet@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Fu Wei <fu.wei@linaro.org>, Robert Richter <rric@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, David Ahern <dsahern@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Matt Fleming <matt@console-pimps.org>
Subject: Re: perf & rasd integration plan
Message-ID: <20141007141315.GJ14113@kernel.org>
References: <20141006150741.GB14113@kernel.org>
 <20141006151605.GE4372@pd.tnic>
 <20141006191227.GD14113@kernel.org>
 <20141006195349.GE20739@pd.tnic>
 <20141006212243.GE14113@kernel.org>
 <20141007112342.GC30146@pd.tnic>
 <20141007134021.GH14113@kernel.org>
 <20141007134912.GE30146@pd.tnic>
 <20141007135531.GI14113@kernel.org>
 <20141007140229.GF30146@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141007140229.GF30146@pd.tnic>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Oct 07, 2014 at 04:02:29PM +0200, Borislav Petkov escreveu:
> On Tue, Oct 07, 2014 at 10:55:31AM -0300, Arnaldo Carvalho de Melo wrote:
> > So you say that if we change a method, say, perf_evlist__open() to
> > accept a new argument, or change the type of one of its arguments,
> > with a good reason, it is acceptable and with just a change in the
> > README explaining why the build fails, which helps in finding how to fix
> > it in a particular project using these "source libraries" then it would
> > be ok?
 
> Right, exactly.
 
> Updating the perf bits used in another project will require a
> recompilation anyway so adjusting stuff here and there should not be of
> issue.
 
> > That would be fine with me.
 
> Yeah.
 
> > We should take care to make sure that the build _fails_ in such cases,
> > i.e.avoid changing the semantic of the Nth argument but keeping its
> > type kind of changes.
 
> Yep.
 
> > At some point there will be no more reasons to change things, and that
> > will be noticed by how long since the last change was made to a
> > particular class, at that point we may well think about making library
> > type promises.
 
> I was about to say the same thing - once the code doesn't change anymore
> and gets even boring, doing the library promise is probably pretty easy.

Ok, at some point we need to make sure this gets into tools/lib/api/README.
 
> See, no need for you to get over to LCE: we're practically done :-)

Nah, there is much more than this at LCE, I'm sure, I'll try again next
time.
 
> We'll run the proposal in jolsa's timeslot again and make sure to poke
> holes in it. But it looks good from where I'm standing.

Thanks!
 
> Btw, did we just solve the compatibility problem of libraries by
> delivering source libraries first!?!

For me one of the points of having tools/ is to try and make kernel
developers try to do userspace muck, dirtying the hands trying to use
the same discipline used in the kernel proper, using code as unchanged
as possible from the kernel proper, etc.

If we now are moving to share code in a way that keeps what is nice in
having code and its users in the same repo, like the kernel guys have
with subsystems and its drivers while allowing to do it in different
repos, that is a good thing indeed.
 
> Haha.

While having fun even! Good deal.

- Arnaldo

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754329Ab3LCPWR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 10:22:17 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:15594 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752988Ab3LCPWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 10:22:14 -0500
Date: Tue, 3 Dec 2013 10:22:08 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Josh Boyer <jwboyer@fedoraproject.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Arjan van de Ven <arjan@linux.intel.com>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [RFC] Packaging libtraceevent.so
Message-ID: <20131203102208.1d9bf444@gandalf.local.home>
In-Reply-To: <87txeqmpzp.fsf@sejong.aot.lge.com>
References: <20131202140322.4ad6a151@gandalf.local.home>
	<87txeqmpzp.fsf@sejong.aot.lge.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 03 Dec 2013 15:02:18 +0900
Namhyung Kim <namhyung@kernel.org> wrote:

> Hi Steve,
> 
> (also add Jiri to CC list, hi!)

Ug, I thought I added him, but looking at my email, I must have thought
I did but did not. :-/

> 
> On Mon, 2 Dec 2013 14:03:22 -0500, Steven Rostedt wrote:
> > Hi all!
> >
> > The question has recently come up in Fedora about packaging the
> > libtraceevent.so library. Currently there's 4 users of it:
> >
> >  1) perf
> >  2) trace-cmd
> >  3) powertop
> >  4) rasdaemon
> >
> > But each have their own copy of the code.
> >
> > Both perf and trace-cmd are the major developers of the package, and I
> > would recommend that they continue using the *.a version, but for those
> > tools that are simple users of the library, it would probably make
> > sense to have them use libtraceevent.so and remove their copies from
> > the code (powertop and rasdaemon).
> >
> > The question that I'm posing here is, what currently needs to be done
> > to have this happen?
> 
> I think the most important thing is error handling.  The filter parser
> code still has some calls to die().  It should be converted to return
> error and appropriate error messages IMHO.  But I didn't check it'd
> affect to the end-user APIs though.

Yep that should be cleaned up as well.

> 
> And it needs to add plugin APIs before the public release.

I agree with that too.

> 
> >
> > Is the API stable enough for a release?
> 
> Well, afaics the plugin unregister API should pass pevent as an argument
> so that it can unregister individual event/function handlers in it.
> 
> Other than that I think it's pretty stable. :)

OK, lets work on getting these minor things fixed and get it ready for
a public library.

-- Steve

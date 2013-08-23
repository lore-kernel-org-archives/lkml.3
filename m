Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755803Ab3HWRGj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 13:06:39 -0400
Received: from smtpauth03h.mfg.siteprotect.com ([64.26.60.134]:33049 "EHLO
	smtpauth03.mfg.siteprotect.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754654Ab3HWRGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 13:06:37 -0400
Date: Fri, 23 Aug 2013 13:07:54 -0400 (EDT)
From: Vince Weaver <vince@deater.net>
X-X-Sender: vince@pianoman.cluster.toy
To: Borislav Petkov <bp@alien8.de>
cc: Robert Richter <rric@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Vince Weaver <vincent.weaver@maine.edu>
Subject: Re: [PATCH v3 12/12] [RFC] perf, persistent: ioctl functions to
 control persistency
In-Reply-To: <20130823113400.GA20310@nazgul.tnic>
Message-ID: <alpine.DEB.2.02.1308231255330.7482@pianoman.cluster.toy>
References: <1377180807-12758-1-git-send-email-rric@kernel.org> <1377180807-12758-13-git-send-email-rric@kernel.org> <alpine.DEB.2.02.1308221404090.26486@pianoman.cluster.toy> <20130823091128.GA19548@nazgul.tnic> <20130823094556.GB10223@rric.localhost>
 <20130823104441.GD10223@rric.localhost> <20130823113400.GA20310@nazgul.tnic>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-CTCH-Spam: Unknown
X-CTCH-RefID: str=0001.0A02020A.5217969D.00AF,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Aug 2013, Borislav Petkov wrote:

> On Fri, Aug 23, 2013 at 12:44:41PM +0200, Robert Richter wrote:
> > On 23.08.13 11:45:56, Robert Richter wrote:
> > > On 23.08.13 11:11:28, Borislav Petkov wrote:
> > > > On Thu, Aug 22, 2013 at 02:18:06PM -0400, Vince Weaver wrote:
> > > > >   PERF_EVENT_IOC_MAKE_PERSISTENT
> > > > >   PERF_EVENT_IOC_UNPERSIST
> > 
> > Maybe this?
> > 
> >  PERF_EVENT_IOC_PERSIST
> >  PERF_EVENT_IOC_UNPERSIST
> 
> No, ATTACH/DETACH actually describes what you do with the fds and is
> most generic. "PERSIST*" is a special use case of attaching/detaching
> events.

I agree with what Robert said elsewhere in this thread:
 "The problem with detach/attach is more that it's actually more
  logically to attach first and afterwards detach. This is not the case
  here, it's vise versa."

My main confusion is that with some other performance tools, such as PAPI,
"attach" specifically means to take an event and attach it to a 
process (much like the -p option to strace or gdb) or a cpu.  Now 
perf_event handles this differently (you do that at open time) but I still 
think it gets things backwards.

Since ATTACH is usually a transitive verb in English I'd think the name 
should specify what two things are being attached.  

If I had not read the man-page fragment and saw a
   result=ioctl(fd,PERF_EVENT_IOC_ATTACH,0);
I'd have no clue what it was doing (attach?  attach to what?)
wheras if I saw
   result=ioctl(fd,PERF_EVENT_IOC_UNPERSIST,0);
it's a little more clearer and also indicates that the ioctl is only
valid if you're dealing with a persistent event.

Vince

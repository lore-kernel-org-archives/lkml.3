Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964830Ab3GEP2Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 11:28:16 -0400
Received: from mail-gh0-f169.google.com ([209.85.160.169]:47826 "EHLO
	mail-gh0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757399Ab3GEP2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 11:28:14 -0400
Date: Fri, 5 Jul 2013 11:28:08 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Jiri Olsa <jolsa@redhat.com>
cc: Peter Zijlstra <peterz@infradead.org>,
        Vince Weaver <vincent.weaver@maine.edu>, linux-kernel@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Stephane Eranian <eranian@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: perf/Documentation/ABI -- add some documentation for perf_event
 sysfs usage
In-Reply-To: <20130704220233.GA11319@krava.redhat.com>
Message-ID: <alpine.DEB.2.10.1307051119410.27475@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1307031527390.12584@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1307032308040.13409@vincent-weaver-1.um.maine.edu> <20130704090253.GJ18898@dyad.programming.kicks-ass.net> <20130704220233.GA11319@krava.redhat.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Jul 2013, Jiri Olsa wrote:

> On Thu, Jul 04, 2013 at 11:02:53AM +0200, Peter Zijlstra wrote:
> > On Wed, Jul 03, 2013 at 11:14:40PM -0400, Vince Weaver wrote:

> > >    Documentation/ABI/testing/sysfs-bus-event_source-devices-events
> > > 
> > > Should the ldlat value be fixed to be hex?  Or should we ammend the ABI
> > > document to allow decimal?
> > 
> > I don't see a good reason not to allow decimal as well. Jolsa?
> 
> yep, no technical problem with decimal
> 
> hum, the doc mentions 'event' term only, which IS hex only AFAICS ;-)
> 
> I think this docs should be updated and either describe all
> allowed terms or be generic enough to cover all of them.

So you're saying the official kernel ABI should be "whatever the 
userspace perf tool happens to accept"?

That's not really useful, especially as perf doesn't distinguish between
event strings read from sysfs and those passed on the perf command line.
The ABI documentation in effect ends up being a pointer to a mostly 
incomprehensible lex/yacc file.

I think we should just remove the 
   Documentation/ABI/testing/sysfs-bus-event_source-devices-events
file as it's misleading.  Userspace broke and no one cares.

It's not even easy to audit all places in the kernel that create the sysfs 
event files because each architecture does it differently.  And there's no 
sane way to unit test this on a new kernel release because the values 
printed depend on the hardware you have, so without a full range of all 
families of cpus for all architectures you never know when someone has 
added a decimal value, or started depending on { characters, etc.

This is the problem with perf in the tools directory, any other user of 
the ABI is eternally second-class.

Vince



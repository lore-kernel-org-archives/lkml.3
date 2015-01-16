Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755551AbbAPMb1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 07:31:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45909 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751506AbbAPMb0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 07:31:26 -0500
Date: Fri, 16 Jan 2015 13:30:13 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Will Deacon <will.deacon@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>, Jiri Olsa <jolsa@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alexis Berlemont <alexis.berlemont@gmail.com>,
        Andi Kleen <ak@linux.intel.com>, Anton Blanchard <anton@samba.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Borislav Petkov <bp@alien8.de>, Borislav Petkov <bp@suse.de>,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Florian Fainelli <florian@openwrt.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        "msalter@redhat.com" <msalter@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "S. Lockwood-Childs" <sjl@vctlabs.com>,
        Sam Ravnborg <sam@ravnborg.org>, Sasha Levin <sasha.levin@oracle.com>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Subject: Re: [PATCHv2 00/36] perf tools: New build framework
Message-ID: <20150116123013.GB15672@krava.brq.redhat.com>
References: <1421326532-25660-1-git-send-email-jolsa@kernel.org>
 <20150116113921.GL7091@arm.com>
 <20150116121214.GI21809@leverpostej>
 <20150116122221.GN7091@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150116122221.GN7091@arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 16, 2015 at 12:22:21PM +0000, Will Deacon wrote:
> On Fri, Jan 16, 2015 at 12:12:14PM +0000, Mark Rutland wrote:
> > On Fri, Jan 16, 2015 at 11:39:22AM +0000, Will Deacon wrote:
> > > On Thu, Jan 15, 2015 at 12:54:56PM +0000, Jiri Olsa wrote:
> > > > hi,
> > > > I'm following up on latest post from Alexis:
> > > >   http://marc.info/?l=linux-kernel&m=141427580405357&w=2
> > > > 
> > > > v2 changes:
> > > >   - build Makefiles librarized and moved to 'tools/build' [Ingo]
> > > >   - several minor fixies [Namhyung]
> > > >   - tested on other archs now - x86_64, i386, powerpc
> > > >   - moved tools/lib/* under new build framework to show
> > > >     that it's possible ;-)
> > > >     included traceevent/lockdep maintainers to get the feedback
> > > >   - omitted last 2 patches
> > > > 
> > > > The patchset is also available in:
> > > >   git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git
> > > >   perf/build
> > > > 
> > > > All tests/make tests passed.
> > > > 
> > > > Any feedback from ARM guys would be great ;-)
> > > 
> > > [adding Mark Rutland to Cc]
> > 
> > Cheers.
> > 
> > I just tried a cross-build for arm, and that blew up when trying to do
> > something with arch/arm/util/libperf-in.o (log below). I bisected that
> > to f169fbc4c59dd9d4 "perf build: Add arch x86 objects building". I'm
> > looking into why now.
> 
> I get a similar failure doing a native arm64 build. I think the problem is
> because the arch/ files for arm and arm64 aren't always required (i.e. there
> are configurations where nothing is built under there) and, consequently,
> libperf-in.o isn't actually needed and we try to link against something that
> doesn't exist.

exactly ;-) I'll spin v3 shortly..

thanks,
jirka

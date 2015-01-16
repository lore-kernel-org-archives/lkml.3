Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755937AbbAPORL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 09:17:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57769 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751465AbbAPORJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 09:17:09 -0500
Date: Fri, 16 Jan 2015 15:15:52 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Will Deacon <Will.Deacon@arm.com>, Jiri Olsa <jolsa@kernel.org>,
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
        Ingo Molnar <mingo@kernel.org>,
        "msalter@redhat.com" <msalter@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "S. Lockwood-Childs" <sjl@vctlabs.com>,
        Sam Ravnborg <sam@ravnborg.org>, Sasha Levin <sasha.levin@oracle.com>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Subject: Re: [PATCHv2 00/36] perf tools: New build framework
Message-ID: <20150116141552.GB23967@krava.brq.redhat.com>
References: <1421326532-25660-1-git-send-email-jolsa@kernel.org>
 <20150116113921.GL7091@arm.com>
 <20150116121214.GI21809@leverpostej>
 <20150116122221.GN7091@arm.com>
 <20150116123013.GB15672@krava.brq.redhat.com>
 <20150116124349.GA23967@krava.brq.redhat.com>
 <20150116134910.GA22569@leverpostej>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150116134910.GA22569@leverpostej>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 16, 2015 at 01:49:10PM +0000, Mark Rutland wrote:
> Hi,
> 
> [...]
> 
> > > > > I just tried a cross-build for arm, and that blew up when trying to do
> > > > > something with arch/arm/util/libperf-in.o (log below). I bisected that
> > > > > to f169fbc4c59dd9d4 "perf build: Add arch x86 objects building". I'm
> > > > > looking into why now.
> > > > 
> > > > I get a similar failure doing a native arm64 build. I think the problem is
> > > > because the arch/ files for arm and arm64 aren't always required (i.e. there
> > > > are configurations where nothing is built under there) and, consequently,
> > > > libperf-in.o isn't actually needed and we try to link against something that
> > > > doesn't exist.
> > > 
> > > exactly ;-) I'll spin v3 shortly..
> > 
> > this fixes the issue for me
> > 
> > jirka
> > 
> > 
> > ---
> > diff --git a/tools/build/Makefile.build b/tools/build/Makefile.build
> > index d35b66014992..396b33b124d1 100644
> > --- a/tools/build/Makefile.build
> > +++ b/tools/build/Makefile.build
> > @@ -52,7 +52,7 @@ quiet_cmd_cc_s_c = AS       $@
> >  
> >  # Link agregate command
> >  quiet_cmd_ld_multi = LD       $@
> > -      cmd_ld_multi = $(LD) -r -o $@ $^
> > +      cmd_ld_multi = $(LD) -r -o $@ $(wildcard $^)
> >  
> >  # Build rules
> >  $(OUTPUT)%.o: %.c FORCE
> > 
> 
> Unfortunately that doesn't seem to be sufficient for me when
> cross-compiling. It looks like it supresses the warning from Make, but
> then LD explodes anyway because it wasn't provided any input files (log
> below).

argh.. right, when there are no source objects at all :-\ fix is comming ;-)

thanks,
jirka

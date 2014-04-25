Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704AbaDYINC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 04:13:02 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:52440 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441AbaDYIMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 04:12:07 -0400
Date: Fri, 25 Apr 2014 10:12:01 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jean Pihet <jean.pihet@linaro.org>,
        Josh Boyer <jwboyer@fedoraproject.org>,
        Masanari Iida <standby24x7@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [GIT PULL 0/4] perf/urgent fixes
Message-ID: <20140425081201.GA24787@gmail.com>
References: <1398252682-17185-1-git-send-email-jolsa@redhat.com>
 <20140423131433.GB23224@gmail.com>
 <20140423134910.GD11124@krava.brq.redhat.com>
 <20140424063630.GC1104@gmail.com>
 <20140424114700.GE1110@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140424114700.GE1110@krava.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jiri Olsa <jolsa@redhat.com> wrote:

> SNIP
> 
> > 
> > Okay, so the problem is that we don't have a simple binary-state 
> > feature in this case, but three possible states: 'libunwind', or 
> > 'libdw-dwarf-unwind', or 'OFF', right?
> > 
> > If so then the solution would be to replace those 3 last lines with 
> > just this line:
> > 
> >      ...        DWARF unwind library: [ libunwind ]
> > 
> > Where 'libunwind' is printed in green (like the 'on' lines are 
> > printed). If there's no suitable library available then output:
> > 
> >      ...        DWARF unwind library: [ OFF ]
> > 
> > Because the user looking at the output is really only interested in 
> > 'is an unwind library available', and maybe in 'which one'.
> > 
> > Is there preference between library choices? I.e. is 'libunwind' 
> > preferred over 'libdw-dwarf-unwind', or the other way around? If yes 
> > then if we pick an inferior library we could print it in yellow color 
> > - and only use green if it's the 'best' choice.
> > 
> > That way the color codes also still keep working: red means problem, 
> > green means OK, yellow something inbetween.
> 
> sounds good.. TODO list updated ;-)
> 
> > 
> > But in any case we should try to keep the 'one feature, one line' 
> > fundamental output concept.
> > 
> > ( Under V=1 we can output whatever details might be useful to
> >   developers, there's no restriction on what to output there. )
> 
> thats what we put VF for.. maybe we should for verbose
> features code detection output for V=1 as well

Yeah, I think it's only rarely needed, so might make sense to merge it 
into V=1.

Thanks,

	Ingo

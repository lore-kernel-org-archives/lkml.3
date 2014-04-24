Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756616AbaDXLrz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 07:47:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18032 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753573AbaDXLrv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 07:47:51 -0400
Date: Thu, 24 Apr 2014 13:47:00 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
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
Message-ID: <20140424114700.GE1110@krava.brq.redhat.com>
References: <1398252682-17185-1-git-send-email-jolsa@redhat.com>
 <20140423131433.GB23224@gmail.com>
 <20140423134910.GD11124@krava.brq.redhat.com>
 <20140424063630.GC1104@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140424063630.GC1104@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SNIP

> 
> Okay, so the problem is that we don't have a simple binary-state 
> feature in this case, but three possible states: 'libunwind', or 
> 'libdw-dwarf-unwind', or 'OFF', right?
> 
> If so then the solution would be to replace those 3 last lines with 
> just this line:
> 
>      ...        DWARF unwind library: [ libunwind ]
> 
> Where 'libunwind' is printed in green (like the 'on' lines are 
> printed). If there's no suitable library available then output:
> 
>      ...        DWARF unwind library: [ OFF ]
> 
> Because the user looking at the output is really only interested in 
> 'is an unwind library available', and maybe in 'which one'.
> 
> Is there preference between library choices? I.e. is 'libunwind' 
> preferred over 'libdw-dwarf-unwind', or the other way around? If yes 
> then if we pick an inferior library we could print it in yellow color 
> - and only use green if it's the 'best' choice.
> 
> That way the color codes also still keep working: red means problem, 
> green means OK, yellow something inbetween.

sounds good.. TODO list updated ;-)

> 
> But in any case we should try to keep the 'one feature, one line' 
> fundamental output concept.
> 
> ( Under V=1 we can output whatever details might be useful to
>   developers, there's no restriction on what to output there. )

thats what we put VF for.. maybe we should for verbose
features code detection output for V=1 as well

jirka

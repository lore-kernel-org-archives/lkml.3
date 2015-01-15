Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755655AbbAOQcj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 11:32:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37440 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755605AbbAOQcf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 11:32:35 -0500
Date: Thu, 15 Jan 2015 17:31:10 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alexis Berlemont <alexis.berlemont@gmail.com>,
        Andi Kleen <ak@linux.intel.com>, Anton Blanchard <anton@samba.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Borislav Petkov <bp@alien8.de>, Borislav Petkov <bp@suse.de>,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Florian Fainelli <florian@openwrt.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Mark Salter <msalter@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "S. Lockwood-Childs" <sjl@vctlabs.com>,
        Sam Ravnborg <sam@ravnborg.org>, Sasha Levin <sasha.levin@oracle.com>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCHv2 00/36] perf tools: New build framework
Message-ID: <20150115163110.GE17228@krava.brq.redhat.com>
References: <1421326532-25660-1-git-send-email-jolsa@kernel.org>
 <54B7E5E0.50702@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54B7E5E0.50702@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2015 at 09:08:00AM -0700, David Ahern wrote:
> On 1/15/15 5:54 AM, Jiri Olsa wrote:
> >Since it's actually small portion of kbuild that perf needs,
> >I realized it's actually better to steal it than 'reconfigure'
> >kbuild to be usable for perf.
> >
> >Also this patchset is kind of incremental version of the latest:
> >   perf tools: Add kbuild support into Makefile.kbuild
> >so it should be easier to review.
> >
> >NOTE I couldn't find any copyright/credit messages in the kbuild
> >system, but would be happy to include it if someone suggests one.
> >
> >The stolen parts are in files:
> >   Makefile.kbuild
> >   Build.include
> >
> >The idea and more details are explained in the 'Documentation/Build'
> >file. The basic idea is the same as in kbuild system, with some minor
> >changes to allow for multiple binaries build definitions.
> >
> >User provides 'Build' files with objects definitions like:
> >   perf-y += perf.o
> >   perf-y += builtin-bench.o
> >   ...
> >
> >   libperf-y += util/
> >   ...
> >
> 
> It is not obvious to me how this works. Users provide a .config file for
> building perf? Or do users provide Build files like you state above? If it
> is a .config file then what if a .config file is not present is it auto
> generated using the current autoprobing?

so far users provide 'Build' files, which defines list of objects
to be built for specific outputs, like following Build file:

---
perf-y += perf.o
perf-y += builtin-bench.o

libperf-y += util/
---

means that build framework's output will be 2 files:

  - 'perf-in.o'    that contains (links) perf.o and builtin-bench.o objects
  - 'libperf-in.o' that contains (links) whatever is defined under 'util/'


also user can provide '.config-detected' file that will get included
into the Makefile.build to get the environment changed and refer to it
in the 'Build' files

I'll update docs with more details..

jirka

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754329Ab3LELG0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 06:06:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22384 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752475Ab3LELGX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 06:06:23 -0500
Date: Thu, 5 Dec 2013 12:05:30 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Dongsheng Yang <yangds.fnst@cn.fujitsu.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [GIT PULL 00/38] perf/core improvements and fixes
Message-ID: <20131205110530.GD21600@krava.brq.redhat.com>
References: <1386187622-2928-1-git-send-email-acme@infradead.org>
 <20131205100429.GC16749@gmail.com>
 <20131205103707.GC21600@krava.brq.redhat.com>
 <20131205105344.GD20283@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131205105344.GD20283@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 05, 2013 at 11:53:44AM +0100, Ingo Molnar wrote:

SNIP

> 
> I saw it again on a system by running two parallel build jobs:
> 
>   D=/tmp/perf-1; mkdir -p $D; while make O=$D install; do make O=$D clean; done
>   D=/tmp/perf-2; mkdir -p $D; while make O=$D install; do make O=$D clean; done
> 
> one failed with:
> 
>   BUILD    PLUGIN plugin_kmem.so
> make[2]: *** [sub-make] Error 2
> make[1]: *** [/tmp/perf-1/libtraceevent.a] Error 2
> make[1]: *** Waiting for unfinished jobs....
>   BUILD    PLUGIN plugin_kvm.so
> 
> the other with:
> 
>   CC FPIC  plugin_cfg80211.o
>   CC       /tmp/perf-2/builtin-help.o
>   CC       /tmp/perf-2/builtin-sched.o
> plugin_sched_switch.o: file not recognized: File truncated
> collect2: error: ld returned 1 exit status
> make[3]: *** [plugin_sched_switch.so] Error 1  BUILD    PLUGIN plugin_function.so
> 
> 
> and that's clearly the new plugin code.

yes, I reproduced... looks like 'plugins' target is racing
with 'install_plugins' target.. both ending up building
same objects at the same time

working on fix

thanks,
jirka

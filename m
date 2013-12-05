Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225Ab3LELOv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 06:14:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24270 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752228Ab3LELOt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 06:14:49 -0500
Date: Thu, 5 Dec 2013 12:13:54 +0100
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
Message-ID: <20131205111354.GE21600@krava.brq.redhat.com>
References: <1386187622-2928-1-git-send-email-acme@infradead.org>
 <20131205100429.GC16749@gmail.com>
 <20131205103707.GC21600@krava.brq.redhat.com>
 <20131205105344.GD20283@gmail.com>
 <20131205105914.GA20558@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131205105914.GA20558@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 05, 2013 at 11:59:14AM +0100, Ingo Molnar wrote:
> 
> * Ingo Molnar <mingo@kernel.org> wrote:
> 
> > > never saw that one.. starting your test on 24 CPUs server now
> > 
> > I saw it again on a system by running two parallel build jobs:
> > 
> >   D=/tmp/perf-1; mkdir -p $D; while make O=$D install; do make O=$D clean; done
> >   D=/tmp/perf-2; mkdir -p $D; while make O=$D install; do make O=$D clean; done
> 
> I'm running it now with the previous perf/core - no failures so far, 
> after dozens of build passes.
> 

could you please try attached change? working for me so far..

thanks,
jirka


---
diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index ca3b87d..9a8cf37 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -722,7 +722,7 @@ $(LIBTRACEEVENT)-clean:
 	$(call QUIET_CLEAN, libtraceevent)
 	@$(MAKE) -C $(TRACE_EVENT_DIR) O=$(OUTPUT) clean >/dev/null
 
-install-traceevent-plugins:
+install-traceevent-plugins: $(LIBTRACEEVENT)
 	$(QUIET_SUBDIR0)$(TRACE_EVENT_DIR) $(LIBTRACEEVENT_FLAGS) install_plugins
 
 LIBLK_SOURCES = $(wildcard $(LK_PATH)*.[ch])

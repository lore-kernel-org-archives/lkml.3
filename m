Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870Ab3LZUK3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 15:10:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3510 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753359Ab3LZUK2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 15:10:28 -0500
Date: Thu, 26 Dec 2013 21:10:07 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 0/9] tools: Factor traceevent/perf Makefile
Message-ID: <20131226201007.GA1213@krava.brq.redhat.com>
References: <1387460527-15030-1-git-send-email-jolsa@redhat.com>
 <20131226133842.GA30980@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131226133842.GA30980@ghostprotocols.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 26, 2013 at 10:38:42AM -0300, Arnaldo Carvalho de Melo wrote:
> Em Thu, Dec 19, 2013 at 02:41:58PM +0100, Jiri Olsa escreveu:
> > hi,
> > sending out the change to introduce single:
> >   INSTALL trace_plugins
> > build output line. Some more code factoring was needed.
> > 
> > Also updated the tests/make install tests to check for
> > installed plugins.
> 
> Ok, better now, applied, but can you take a look at:
> 
> [acme@ssdandy linux]$ make O=/tmp/build/perf -C tools/perf/ install-bin
> make: Entering directory `/home/acme/git/linux/tools/perf'
>   BUILD:   Doing 'make -j8' parallel build
>   GEN      perf-archive
>   SUBDIR   /home/acme/git/linux/tools/lib/traceevent/
> make[3]: Nothing to be done for `plugins'.
> make[2]: Nothing to be done for `plugins'.
>   INSTALL  GTK UI
>   INSTALL  binaries
>   INSTALL  libexec
>   INSTALL  perf-archive
>   INSTALL  perl-scripts
>   INSTALL  python-scripts
>   INSTALL  perf_completion-script
>   INSTALL  tests
> make: Leaving directory `/home/acme/git/linux/tools/perf'
> [acme@ssdandy linux]$
> 
> Removing those two "Nothing to be done" lines, please?

never happy, are we? ;-) looks like change below
would do.. I'll check/test more and send out.

jirka


---
diff --git a/tools/scripts/Makefile.include b/tools/scripts/Makefile.include
index 8abbef1..555de0b 100644
--- a/tools/scripts/Makefile.include
+++ b/tools/scripts/Makefile.include
@@ -55,7 +55,7 @@ descend = \
 	+mkdir -p $(OUTPUT)$(1) && \
 	$(MAKE) $(COMMAND_O) subdir=$(if $(subdir),$(subdir)/$(1),$(1)) $(PRINT_DIR) -C $(1) $(2)
 
-QUIET_SUBDIR0  = +$(MAKE) $(COMMAND_O) -C # space to separate -C and subdir
+QUIET_SUBDIR0  = +$(MAKE) $(COMMAND_O) -s -C # space to separate -C and subdir
 QUIET_SUBDIR1  =
 
 ifneq ($(findstring $(MAKEFLAGS),s),s)

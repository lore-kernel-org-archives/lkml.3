Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753714AbbAOQZY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 11:25:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54805 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751579AbbAOQZX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 11:25:23 -0500
Date: Thu, 15 Jan 2015 17:24:35 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Alexis Berlemont <alexis.berlemont@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 05/36] perf build: Disable make's built-in rules and
 variables
Message-ID: <20150115162435.GD17228@krava.brq.redhat.com>
References: <1421326532-25660-1-git-send-email-jolsa@kernel.org>
 <1421326532-25660-6-git-send-email-jolsa@kernel.org>
 <54B7E441.6040803@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54B7E441.6040803@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2015 at 09:01:05AM -0700, David Ahern wrote:
> On 1/15/15 5:55 AM, Jiri Olsa wrote:
> 
> >diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
> >index 1f71a32aea78..dd49b40e203b 100644
> >--- a/tools/perf/Makefile.perf
> >+++ b/tools/perf/Makefile.perf
> >@@ -84,6 +84,10 @@ ifneq ($(OUTPUT),)
> >  #$(info Determined 'OUTPUT' to be $(OUTPUT))
> >  endif
> >
> >+# Do not use make's built-in rules and variables
> >+# (this increases performance and avoids hard-to-debug behaviour);
> >+MAKEFLAGS += -rR
> >+
> >  $(OUTPUT)PERF-VERSION-FILE: ../../.git/HEAD
> >  	@$(SHELL_PATH) util/PERF-VERSION-GEN $(OUTPUT)
> >  	@touch $(OUTPUT)PERF-VERSION-FILE
> 
> Does this depend on any prior patch? Was not obvious to me. Adding just this
> patch to a fresh build and it blows up.
> 
> $ vi Makefile.perf
> - add line above
> $ mkdir /tmp/junk2
> $ make O=/tmp/junk2
> ...
>  CC       /tmp/junk2/fs/debugfs.o
>   CC       /tmp/junk2/fs/fs.o
>   CC       /tmp/junk2/fd/array.o
> /bin/sh: .event-parse.d: command not found
> /bin/sh: .trace-seq.d: command not found
> /bin/sh: .event-plugin.d: command not found
> make[3]: *** [.event-parse.d] Error 127
> make[3]: *** Waiting for unfinished jobs....
> ...
> 
> This is on a Fedora 16 host.

oops, I've cut it out of the framework changes to make
it simpler, but looks like traceevent library depends
on builtin rules, I'll check..

thanks,
jirka

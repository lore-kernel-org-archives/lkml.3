Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821AbaFJSQo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 14:16:44 -0400
Received: from mail.kernel.org ([198.145.19.201]:35487 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752607AbaFJSQn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 14:16:43 -0400
Date: Tue, 10 Jun 2014 15:16:36 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Don Zickus <dzickus@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Kyle McMartin <kyle@mcmartin.ca>
Subject: perf tools: MULTILIB install issues. was Re: [PATCH 1/2] perf tools:
 Emit more precise message for missing glibc static library
Message-ID: <20140610181636.GA2794@kernel.org>
References: <1402063909-13859-1-git-send-email-acme@kernel.org>
 <1402063909-13859-2-git-send-email-acme@kernel.org>
 <20140610155031.GS177152@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140610155031.GS177152@redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Jun 10, 2014 at 11:50:31AM -0400, Don Zickus escreveu:
> I am hijacking your thread for another Makefile problem.  It seems like
> you were doing some cleanups here, so I wanted to throw another problem at
> you. :-)

Yeah, I skimmed that discussion about our home grown autoconf
replacement 8-)
 
> It seems the fedora-kernel guys found a multilib packaging problem and
> posted a patch to clean it up.  It is from Kyle McMartin
> (copy-n-pasted).
 
> +++ b/tools/perf/config/Makefile
> @@ -621,8 +621,12 @@ endif
>  ifeq ($(IS_X86_64),1)
>  lib = lib64
>  else
> +ifdef MULTILIBDIR
> +lib = $(MULTILIBDIR)
> +else
>  lib = lib
>  endif
> +endif
>  libdir = $(prefix)/$(lib)
 
>  # Shell quote (do not use $(call) to accommodate ancient setups);

> Not sure if this is the right way to do this or if you had a better
> solution.

I'm unsure as well, but it looks like something that suits the needs of
distros, right? Anyone?

- Arnaldo

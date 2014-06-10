Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752675AbaFJPvG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 11:51:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9727 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752494AbaFJPvE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 11:51:04 -0400
Date: Tue, 10 Jun 2014 11:50:31 -0400
From: Don Zickus <dzickus@redhat.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 1/2] perf tools: Emit more precise message for missing
 glibc static library
Message-ID: <20140610155031.GS177152@redhat.com>
References: <1402063909-13859-1-git-send-email-acme@kernel.org>
 <1402063909-13859-2-git-send-email-acme@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402063909-13859-2-git-send-email-acme@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo,

I am hijacking your thread for another Makefile problem.  It seems like
you were doing some cleanups here, so I wanted to throw another problem at
you. :-)

It seems the fedora-kernel guys found a multilib packaging problem and
posted a patch to clean it up.  It is from Kyle McMartin (copy-n-pasted).

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 802cf54..7f30bfa 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -621,8 +621,12 @@ endif
 ifeq ($(IS_X86_64),1)
 lib = lib64
 else
+ifdef MULTILIBDIR
+lib = $(MULTILIBDIR)
+else
 lib = lib
 endif
+endif
 libdir = $(prefix)/$(lib)

 # Shell quote (do not use $(call) to accommodate ancient setups);

Not sure if this is the right way to do this or if you had a better
solution.

Cheers,
Don


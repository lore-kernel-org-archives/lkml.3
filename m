Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758071AbaEKNQB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 09:16:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56308 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751045AbaEKNP6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 09:15:58 -0400
Date: Sun, 11 May 2014 15:15:42 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] perf tools: Use tid for finding thread
Message-ID: <20140511131542.GA2272@krava.brq.redhat.com>
References: <1399429566-15587-1-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399429566-15587-1-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2014 at 11:26:06AM +0900, Namhyung Kim wrote:
> I believe that passing pid (instead of tid) as the 3rd arg of the
> machine__find*_thread() was to find a main thread so that it can
> search proper map group for symbols.  However with the map sharing
> patch applied, it now can do it in any thread.
> 
> It fixes a bug when each thread has different name, it only reports a
> main thread for samples in other threads.

and breaks tests 14 and 26 ;-)

...
14: Test matching and linking multiple hists               : FAILED!
15: Try 'use perf' in python, checking link problems       : Ok
16: Test breakpoint overflow signal handler                : Ok
17: Test breakpoint overflow sampling                      : Ok
18: Test number of exit event of a simple workload         : Ok
19: Test software clock events have valid period values    : Ok
20: Test converting perf time to TSC                       : Ok
21: Test object code reading                               : Ok
22: Test sample parsing                                    : Ok
23: Test using a dummy software event to keep tracking     : Ok
24: Test parsing with no sample_id_all bit set             : Ok
25: Test dwarf unwind                                      : Ok
26: Test filtering hist entries                            : FAILED!
...

jirka

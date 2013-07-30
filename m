Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755127Ab3G3N2w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 09:28:52 -0400
Received: from mail-qc0-f176.google.com ([209.85.216.176]:60402 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754007Ab3G3N2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 09:28:50 -0400
Date: Tue, 30 Jul 2013 10:28:39 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        Jeremy Eder <jeder@redhat.com>
Subject: Re: [PATCH 01/17] perf util: Save pid-cmdline mapping into tracing
 header
Message-ID: <20130730132839.GA2607@ghostprotocols.net>
References: <1375175954-798-1-git-send-email-namhyung@kernel.org>
 <1375175954-798-2-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375175954-798-2-git-send-email-namhyung@kernel.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Jul 30, 2013 at 06:18:58PM +0900, Namhyung Kim escreveu:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> Current trace info data lacks the saved cmdline mapping which is
> needed for pevent to find out the comm of a task.  Add this and bump
> up the version number so that perf can determine its presence when
> reading.

Can't we get this from the PERF_RECORD_COMM synthesized at the beginning
of the session + the kernel generated ones for new threads?

We would just call machine__find_thread() and use thread->comm, etc, no?

- Arnaldo

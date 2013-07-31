Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759980Ab3GaOH4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 10:07:56 -0400
Received: from mail-ve0-f176.google.com ([209.85.128.176]:46421 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759802Ab3GaOHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 10:07:55 -0400
Date: Wed, 31 Jul 2013 11:07:46 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung.kim@lge.com>
Cc: Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        Jeremy Eder <jeder@redhat.com>
Subject: Re: [PATCH 01/17] perf util: Save pid-cmdline mapping into tracing
 header
Message-ID: <20130731140746.GA3614@ghostprotocols.net>
References: <1375175954-798-1-git-send-email-namhyung@kernel.org>
 <1375175954-798-2-git-send-email-namhyung@kernel.org>
 <20130730132839.GA2607@ghostprotocols.net>
 <51F85FAA.2090400@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <51F85FAA.2090400@lge.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Jul 31, 2013 at 09:51:54AM +0900, Namhyung Kim escreveu:
> 2013-07-30 오후 10:28, Arnaldo Carvalho de Melo 쓴 글:
> >Em Tue, Jul 30, 2013 at 06:18:58PM +0900, Namhyung Kim escreveu:
> >>Current trace info data lacks the saved cmdline mapping which is
> >>needed for pevent to find out the comm of a task.  Add this and bump
> >>up the version number so that perf can determine its presence when
> >>reading.

> >Can't we get this from the PERF_RECORD_COMM synthesized at the beginning
> >of the session + the kernel generated ones for new threads?

> >We would just call machine__find_thread() and use thread->comm, etc, no?

> Yes, I think it's doable.  However it needs an additional perf event
> only to generate the COMM events.  So I decided not to do it and

I don't think this is a problem, its in line with Ingo's suggestion of a
new perf ioctl to ask the kernel to generate PERF_RECORD_MMAP events for
existing threads.

- Arnaldo

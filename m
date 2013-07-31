Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758703Ab3GaAv6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 20:51:58 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:43182 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753638Ab3GaAv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 20:51:56 -0400
X-AuditID: 9c93016f-b7b50ae0000021a9-05-51f85faa510e
Message-ID: <51F85FAA.2090400@lge.com>
Date: Wed, 31 Jul 2013 09:51:54 +0900
From: Namhyung Kim <namhyung.kim@lge.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        Jeremy Eder <jeder@redhat.com>
Subject: Re: [PATCH 01/17] perf util: Save pid-cmdline mapping into tracing
 header
References: <1375175954-798-1-git-send-email-namhyung@kernel.org> <1375175954-798-2-git-send-email-namhyung@kernel.org> <20130730132839.GA2607@ghostprotocols.net>
In-Reply-To: <20130730132839.GA2607@ghostprotocols.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo,

2013-07-30 오후 10:28, Arnaldo Carvalho de Melo 쓴 글:
> Em Tue, Jul 30, 2013 at 06:18:58PM +0900, Namhyung Kim escreveu:
>> From: Namhyung Kim <namhyung.kim@lge.com>
>>
>> Current trace info data lacks the saved cmdline mapping which is
>> needed for pevent to find out the comm of a task.  Add this and bump
>> up the version number so that perf can determine its presence when
>> reading.
>
> Can't we get this from the PERF_RECORD_COMM synthesized at the beginning
> of the session + the kernel generated ones for new threads?
>
> We would just call machine__find_thread() and use thread->comm, etc, no?

Yes, I think it's doable.  However it needs an additional perf event 
only to generate the COMM events.  So I decided not to do it and reused 
saved cmdline info from ftrace.  But IIUC it also has a problem of 
possible information loss due to the size of table.

Thanks,
Namhyung


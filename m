Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757024AbaAGCtG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 21:49:06 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:51545 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755273AbaAGCtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 21:49:04 -0500
X-AuditID: 9c93017d-b7b66ae000006a2a-4e-52cb6b1df64f
Message-ID: <52CB6B1B.4050705@lge.com>
Date: Tue, 07 Jan 2014 11:48:59 +0900
From: Namhyung Kim <namhyung.kim@lge.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] tools lib traceevent: Add state member to struct
 trace_seq
References: <1387445666-7821-1-git-send-email-namhyung@kernel.org> <20140103132425.GC1190@krava.brq.redhat.com> <871u0lftbh.fsf@sejong.aot.lge.com> <20140106143828.GF1183@krava.brq.redhat.com> <20140106094521.2deb8232@gandalf.local.home>
In-Reply-To: <20140106094521.2deb8232@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steve and Jiri,

2014-01-06 PM 11:45, Steven Rostedt wrote:
> On Mon, 6 Jan 2014 15:38:28 +0100
> Jiri Olsa <jolsa@redhat.com> wrote:
>
>
>>> I just thought that it's not so important to print message so keeps the
>>> error internally until it gets printed.  But I can be wrong as usual...
>>
>> I think that if she manages to get one of those errors
>> the perf would fail soon anyway.. so it feels better
>> to print it out immediately.
>
> Yeah, using a trace_seq after it has been destroyed is a critical
> failure, and a major bug. A print to the user console should not be a
> problem here. And actually, crashing is not that bad either, as glibc
> does the same with using free() of a freed pointer.
>
> But as this error is major, an unwanted print is minor.

OK, I'll add the WARN_ONCE in the TRACE_SEQ_CHECK then.

Thanks,
Namhyung


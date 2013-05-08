Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751523Ab3EHF1p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 01:27:45 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:43889 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724Ab3EHF1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 01:27:44 -0400
X-AuditID: 9c930197-b7c1fae000001854-f7-5189e24cf5c0
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 09/14] perf ftrace: Add 'record' sub-command
References: <1366705872-12132-1-git-send-email-namhyung@kernel.org>
	<1366705872-12132-10-git-send-email-namhyung@kernel.org>
	<20130424141241.GG971@krava.brq.redhat.com>
	<87bo939lgt.fsf@sejong.aot.lge.com>
	<87mws8990n.fsf@sejong.aot.lge.com>
	<20130506120411.GA6035@krava.brq.redhat.com>
Date: Wed, 08 May 2013 14:27:40 +0900
In-Reply-To: <20130506120411.GA6035@krava.brq.redhat.com> (Jiri Olsa's message
	of "Mon, 6 May 2013 14:04:11 +0200")
Message-ID: <8761yu82ib.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On Mon, 6 May 2013 14:04:11 +0200, Jiri Olsa wrote:
> On Mon, May 06, 2013 at 10:44:56AM +0900, Namhyung Kim wrote:
>> Hi Jiri,
>> 
>> Sorry for late reply.  I've been busy these days.
>> 
>> On Thu, 25 Apr 2013 15:24:18 +0900, Namhyung Kim wrote:
>> > But it looks there's a race between cond_wait() and cond_broatcast().
>> > I'll take a look at that.
>> 
>> I think the problem is that a recorder can be blocked if it received a
>> broadcast signal before calling cond_wait().  So I modified the code to
>> place signaling ready_cond and waiting start_cond in the same cs.
>> 
>> Does the patch below fix your problem?
>
> yes.. without the patch I get lockup in like 10 minutes
> with the patch the test is now ok for almost an hour..

Many thanks for your test!

Namhyung

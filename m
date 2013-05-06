Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641Ab3EFDWh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 May 2013 23:22:37 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:38083 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752538Ab3EFDWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 May 2013 23:22:36 -0400
Message-ID: <518721F4.6050603@gmail.com>
Date: Sun, 05 May 2013 21:22:28 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 09/14] perf ftrace: Add 'record' sub-command
References: <1366705872-12132-1-git-send-email-namhyung@kernel.org> <1366705872-12132-10-git-send-email-namhyung@kernel.org> <20130424141241.GG971@krava.brq.redhat.com> <87bo939lgt.fsf@sejong.aot.lge.com> <517A84B2.40209@gmail.com> <87ehdk98g6.fsf@sejong.aot.lge.com>
In-Reply-To: <87ehdk98g6.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/5/13 7:57 PM, Namhyung Kim wrote:
> Hi David,
>
> On Fri, 26 Apr 2013 07:44:18 -0600, David Ahern wrote:
>> On 4/25/13 12:24 AM, Namhyung Kim wrote:
>>> But it looks there's a race between cond_wait() and cond_broatcast().
>>> I'll take a look at that.
>>
>> Why not use eventfd or a pipe for the signalling instead?
>
> Thanks for your feedback!
>
> I didn't have an idea of using eventfd for this case.  Does it helpful
> to prevent such a deadlock like this?

I have used it to replace pthread_cond_wait / 
pthread_cond_{signal,broadcast} -- lighter and faster. It was added in 
2.6.27 I believe, so will be available for any system that supports perf 
(record side). For people compiling perf against say RHEL5 (e.g. 
analysis) you will need a check as to whether it exists.

David


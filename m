Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063Ab3LBO2g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 09:28:36 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:57350 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668Ab3LBO2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 09:28:34 -0500
Message-ID: <529C990E.8000303@gmail.com>
Date: Mon, 02 Dec 2013 07:28:30 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>, acme@ghostprotocols.net,
        Ingo Molnar <mingo@kernel.org>
CC: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Jiri Olsa <jolsa@redhat.com>,
        Stephane Eranian <eranian@google.com>,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH 1/2] perf sched: Introduce timehist command - v2
References: <1385943795-11761-1-git-send-email-dsahern@gmail.com>	<1385943795-11761-2-git-send-email-dsahern@gmail.com> <871u1vptty.fsf@sejong.aot.lge.com>
In-Reply-To: <871u1vptty.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/2/13, 12:58 AM, Namhyung Kim wrote:
>>             time cpu  task name[tid/pid]    b/n time sch delay  run time
>>    ------------- ---- -------------------- --------- --------- ---------
>>     79371.874569 [11] gcc[31949]               0.014     0.000     1.148
>>     79371.874591 [10] gcc[31951]               0.000     0.000     0.024
>>     79371.874603 [10] migration/10[59]         3.350     0.004     0.011
>>     79371.874604 [11] <idle>                   1.148     0.000     0.035
>>     79371.874723 [05] <idle>                   0.016     0.000     1.383
>>     79371.874746 [05] gcc[31949]               0.153     0.078     0.022
>> ...
>>
>> Times are in msec.usec.
>
> Hmm.. I'm not sure this is right.  It probably confuse users since
> timehist_time_str() still uses "sec.usec" format and it looks not
> natural for me to use "msec".
>
> Yeah, I see perf stat uses "msec.usec" for result of clock events but
> AFAICT it also shows the unit explicitly.  And perf stat -I uses
> "sec.nsec" format and perf script also uses "sec.usec" format so there's
> a little consistency here.
>
> I think this "msec.usec" format fits well for the scheduling events but
> in general "sec.usec" format looks better IMHO.

Arnaldo / Ingo: any thoughts on the units here? sec.usec versus msec.usec?

David


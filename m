Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754249Ab3KKOpQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 09:45:16 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:40265 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754140Ab3KKOpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 09:45:09 -0500
Message-ID: <5280ED55.3080107@gmail.com>
Date: Mon, 11 Nov 2013 07:44:37 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Namhyung Kim <namhyung@kernel.org>, Pekka Enberg <penberg@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@redhat.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>, Arun Sharma <asharma@fb.com>
Subject: Re: [RFC/PATCHSET 00/14] perf report: Add support to accumulate hist
 periods (v2)
References: <20131101092759.GC27063@gmail.com> <87bo1zz4mu.fsf@sejong.aot.lge.com> <20131105074650.GA2855@gmail.com> <87txfrxlq8.fsf@sejong.aot.lge.com> <20131105115802.GA12045@gmail.com> <87ppqex8tj.fsf@sejong.aot.lge.com> <20131106083046.GA4655@gmail.com> <87r4atx51i.fsf@sejong.aot.lge.com> <20131106114701.GA20249@gmail.com> <527A613A.20404@gmail.com> <20131111121900.GD21397@gmail.com>
In-Reply-To: <20131111121900.GD21397@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/13, 5:19 AM, Ingo Molnar wrote:
>
> In what way is call-graph profiling utilized typically?
>
> Is it system-wide, i.e. something like:
>
> 	perf record -a -g sleep 10
>
> ? If yes then that would explain why scalability problems rarely surfaced,
> it takes a longer user-space profile to get to the event counts where
> scalability started hurting.

Both. But not time periods long enough to generate GB sized files 
(limitations in the product). I get various reports of hung commands 
(usually perf-not terminated properly (now fixed) or the file is 
corrupted on transfer), but noone has complained to me about perf-report 
appearing to hang or for 20-30 minutes to generate a result.

David

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753560Ab3KKMTP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 07:19:15 -0500
Received: from mail-ea0-f181.google.com ([209.85.215.181]:60128 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753059Ab3KKMTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 07:19:05 -0500
Date: Mon, 11 Nov 2013 13:19:00 +0100
From: Ingo Molnar <mingo@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>, Pekka Enberg <penberg@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@redhat.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>, Arun Sharma <asharma@fb.com>
Subject: Re: [RFC/PATCHSET 00/14] perf report: Add support to accumulate hist
 periods (v2)
Message-ID: <20131111121900.GD21397@gmail.com>
References: <20131101092759.GC27063@gmail.com>
 <87bo1zz4mu.fsf@sejong.aot.lge.com>
 <20131105074650.GA2855@gmail.com>
 <87txfrxlq8.fsf@sejong.aot.lge.com>
 <20131105115802.GA12045@gmail.com>
 <87ppqex8tj.fsf@sejong.aot.lge.com>
 <20131106083046.GA4655@gmail.com>
 <87r4atx51i.fsf@sejong.aot.lge.com>
 <20131106114701.GA20249@gmail.com>
 <527A613A.20404@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <527A613A.20404@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Ahern <dsahern@gmail.com> wrote:

> On 11/6/13, 4:47 AM, Ingo Molnar wrote:
> >I'm not too worried about call-graph 'legacies': it generates such huge
> >perf.data files which is parsed so slowly at the moment that there's very
> >little user base ... Anyone who absolutely needs call-graph profiling uses
> >SysProf which performs well.
> 
> Actually, perf with callchains is used quite heavily on my products.
> One of the selling points of perf.

That's nice to hear :)

In what way is call-graph profiling utilized typically?

Is it system-wide, i.e. something like:

	perf record -a -g sleep 10

? If yes then that would explain why scalability problems rarely surfaced, 
it takes a longer user-space profile to get to the event counts where 
scalability started hurting.

Thanks,

	Ingo

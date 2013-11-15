Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754607Ab3KOGEF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 01:04:05 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:50119 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998Ab3KOGD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 01:03:56 -0500
X-AuditID: 9c930179-b7ba7ae000000e31-d2-5285b94a4364
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 10/10] perf tests: Use lower sample_freq in sw clock event period test
References: <1384201353-23863-1-git-send-email-acme@infradead.org>
	<1384201353-23863-11-git-send-email-acme@infradead.org>
	<5281D3B8.2030104@intel.com>
	<20131112144101.GF11239@ghostprotocols.net>
Date: Fri, 15 Nov 2013 15:03:54 +0900
In-Reply-To: <20131112144101.GF11239@ghostprotocols.net> (Arnaldo Carvalho de
	Melo's message of "Tue, 12 Nov 2013 11:41:01 -0300")
Message-ID: <87k3gaurp1.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo,

On Tue, 12 Nov 2013 11:41:01 -0300, Arnaldo Carvalho de Melo wrote:
> Em Tue, Nov 12, 2013 at 09:07:36AM +0200, Adrian Hunter escreveu:
>> -#define NR_LOOPS  1000000
>> +#define NR_LOOPS  10000000
>
> Lower frequency, need to generate more noise, ugh. Adding that, but I
> think this test needs to be reworked, Namhyung?

Hmm.. We might go back to use the default frequency of 4000 (or 1000)
and make the loop based on time like using alarm or setitimer.

Or we can add an outer loop which doubles the inner loop counter if no
samples are collected.

What do you think?

Thanks,
Namhyung

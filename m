Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750901Ab3LPFOl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 00:14:41 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:63418 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741Ab3LPFOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 00:14:40 -0500
X-AuditID: 9c93016f-b7cc5ae000007121-e9-52ae8c3f81af
From: Namhyung Kim <namhyung@kernel.org>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: linux-kernel@vger.kernel.org, Chad Paradis <chad.paradis@umit.maine.edu>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [patch v3] perf tools: perf list broken on ARM
References: <alpine.DEB.2.10.1312101439590.7745@vincent-weaver-1.um.maine.edu>
	<87a9g8i1ea.fsf@sejong.aot.lge.com>
	<alpine.DEB.2.10.1312141516120.15216@vincent-weaver-1.um.maine.edu>
Date: Mon, 16 Dec 2013 14:14:39 +0900
In-Reply-To: <alpine.DEB.2.10.1312141516120.15216@vincent-weaver-1.um.maine.edu>
	(Vince Weaver's message of "Sat, 14 Dec 2013 15:25:18 -0500 (EST)")
Message-ID: <87ob4hgyww.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vince,

On Sat, 14 Dec 2013 15:25:18 -0500 (EST), Vince Weaver wrote:
> OK, here's an updated version that reuses evsel and hopefully doesn't leak 
> memory like the previous patch I posted.
>
>
> "perf list" listing of hardware events doesn't work on older ARM devices.
> The change enabling event detection:
>
>  commit b41f1cec91c37eeea6fdb15effbfa24ea0a5536b
>  Author: Namhyung Kim <namhyung.kim@lge.com>
>  Date:   Tue Aug 27 11:41:53 2013 +0900
>
>      perf list: Skip unsupported events
>
>
> uses the following code in tools/perf/util/parse-events.c:
>
>         struct perf_event_attr attr = {
>                 .type = type,
>                 .config = config,
>                 .disabled = 1,
>                 .exclude_kernel = 1,
>         };
>
> On ARM machines pre-dating the Cortex-A15 this doesn't work, as
> these machines don't support .exclude_kernel.  So starting with 3.12
> "perf list" does not report any hardware events at all on older
> machines (seen on Rasp-Pi, Pandaboard, Beagleboard, etc).
>
> This version of the patch makes changes suggested by Namhyung Kim
> to check for EACCESS and retry (instead of just dropping
> the exclude_kernel) so we can properly handle machines where 
> /proc/sys/kernel/perf_event_paranoid is set to 2.
>
> Reported-by: Chad Paradis <chad.paradis@umit.maine.edu>
> Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>

Acked-by: Namhyung Kim <namhyung@kernel.org>

Thanks,
Namhyung

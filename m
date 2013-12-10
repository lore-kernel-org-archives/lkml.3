Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751944Ab3LJCLo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 21:11:44 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:53096 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805Ab3LJCLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 21:11:43 -0500
X-AuditID: 9c93017e-b7bb9ae000000ec8-b6-52a6785d68c9
From: Namhyung Kim <namhyung@kernel.org>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: linux-kernel@vger.kernel.org, Chad Paradis <chad.paradis@umit.maine.edu>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [patch] perf tools: perf list broken on ARM
References: <alpine.DEB.2.10.1312091646100.2337@vincent-weaver-1.um.maine.edu>
Date: Tue, 10 Dec 2013 11:11:41 +0900
In-Reply-To: <alpine.DEB.2.10.1312091646100.2337@vincent-weaver-1.um.maine.edu>
	(Vince Weaver's message of "Mon, 9 Dec 2013 16:58:35 -0500 (EST)")
Message-ID: <87iouxjvz6.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vince,

On Mon, 9 Dec 2013 16:58:35 -0500 (EST), Vince Weaver wrote:
> Hello,
>
> "perf list" listing of hardware events doesn't work on older ARM devices.
> The change enabling event detection:
>
> commit b41f1cec91c37eeea6fdb15effbfa24ea0a5536b
> Author: Namhyung Kim <namhyung.kim@lge.com>
> Date:   Tue Aug 27 11:41:53 2013 +0900
>
>     perf list: Skip unsupported events
>
>
> uses the following code in tools/perf/util/parse-events.c:
>
>        struct perf_event_attr attr = {
>                .type = type,
>                .config = config,
>                .disabled = 1,
>                .exclude_kernel = 1,
>        };
>
> On ARM machines pre-dating the Cortex-A15 this doesn't work, as
> these machines don't support .exclude_kernel.  So starting with 3.12
> "perf list" does not report any hardware events at all on older
> machines (seen on Rasp-Pi, Pandaboard, Beagleboard, etc).
>
> If we drop the "exclude_kernel" attribute events are properly reported.

Okay, the reason I set the bit was consideration of a very strict
perf_event_paranoid setting (-2).

So maybe we can try it again with the bit cleared after a failure, or
checking the paranoid setting first.

Thanks,
Namhyung

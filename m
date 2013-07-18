Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754423Ab3GRHqI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 03:46:08 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:50918 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531Ab3GRHqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 03:46:06 -0400
X-AuditID: 9c93017d-b7b45ae000000e34-16-51e79d3c680f
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 05/23] perf tests: Add simple session read/write test
References: <1374083403-14591-1-git-send-email-jolsa@redhat.com>
	<1374083403-14591-6-git-send-email-jolsa@redhat.com>
Date: Thu, 18 Jul 2013 16:46:03 +0900
In-Reply-To: <1374083403-14591-6-git-send-email-jolsa@redhat.com> (Jiri Olsa's
	message of "Wed, 17 Jul 2013 19:49:45 +0200")
Message-ID: <87fvvcwbt0.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Jul 2013 19:49:45 +0200, Jiri Olsa wrote:
> Adding simple session read/write test to keep up
> with file format changes.
>
[SNIP]

> +	session = perf_session__new(file, O_RDONLY, false, false, &tool);
> +	TEST_ASSERT_VAL("failed to create session", session);
> +
> +	TEST_ASSERT_VAL("failed to process events", session);
> +		perf_session__process_events(session, &tool);

Did you mean

	TEST_ASSERT_VAL("failed to process events",
		perf_session__process_events(session, &tool));
?


Thanks,
Namhyung

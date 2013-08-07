Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755789Ab3HGIWY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 04:22:24 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:49587 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139Ab3HGIWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 04:22:21 -0400
X-AuditID: 9c930179-b7c53ae000000457-c5-520203bbc8be
From: Namhyung Kim <namhyung@kernel.org>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH V9 08/14] perf tools: move struct ip_event
References: <1375719994-26482-1-git-send-email-adrian.hunter@intel.com>
	<1375719994-26482-9-git-send-email-adrian.hunter@intel.com>
Date: Wed, 07 Aug 2013 17:22:19 +0900
In-Reply-To: <1375719994-26482-9-git-send-email-adrian.hunter@intel.com>
	(Adrian Hunter's message of "Mon, 5 Aug 2013 19:26:28 +0300")
Message-ID: <87pptpykp0.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  5 Aug 2013 19:26:28 +0300, Adrian Hunter wrote:
> struct ip_event assumes fixed positions for ip, pid
> and tid.  That is no longer true with the addition of
> PERF_SAMPLE_IDENTIFIER.
>
> struct ip_event is no longer used except by hists_link.c.
> Move it there.

I think you can just get rid of ip_event and fill sample->ip/pid from
fake_common_samples directly.  The reason of using ip_event was because
it's used in perf_event__preprocess_sample() but you've removed it. :)

Thanks,
Namhyung

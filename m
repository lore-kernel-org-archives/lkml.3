Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932230AbaCQHZT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 03:25:19 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:56988 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753379AbaCQHZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 03:25:17 -0400
X-AuditID: 9c93017e-b7cf9ae000004b4b-c7-5326a35bb29d
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Don Zickus <dzickus@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH 5/5] perf tools: Share process map groups within process threads
References: <1394805606-25883-1-git-send-email-jolsa@redhat.com>
	<1394805606-25883-6-git-send-email-jolsa@redhat.com>
Date: Mon, 17 Mar 2014 16:25:15 +0900
In-Reply-To: <1394805606-25883-6-git-send-email-jolsa@redhat.com> (Jiri Olsa's
	message of "Fri, 14 Mar 2014 15:00:06 +0100")
Message-ID: <871ty1thgk.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Mar 2014 15:00:06 +0100, Jiri Olsa wrote:
> +	if (!mg) {
> +		struct thread *leader = thread__get_leader(thread);
> +
> +		if (!leader)
> +			return NULL;
> +
> +		if (leader->mg)
> +			mg = leader->mg;
> +		else
> +			mg = thread__map_groups_alloc(leader);
> +
> +		if (leader != thread)
> +			thread->mg = mg;
> +
> +		mg->refcnt++;

What's the value of mg->refcnt here in case of leader != thread and
leader->mg was not allocated originally?  I think it's 1 - but shouldn't
it be 2 since it's referenced from both of leader and the thread now?

Thanks,
Namhyung

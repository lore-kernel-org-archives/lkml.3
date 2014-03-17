Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756293AbaCQHN4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 03:13:56 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:64027 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756118AbaCQHNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 03:13:55 -0400
X-AuditID: 9c93016f-b7b09ae000000557-51-5326a0b142f9
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Don Zickus <dzickus@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH 3/5] perf tools: Allocate thread map_groups dynamicaly
In-Reply-To: <1394805606-25883-4-git-send-email-jolsa@redhat.com> (Jiri Olsa's
	message of "Fri, 14 Mar 2014 15:00:04 +0100")
References: <1394805606-25883-1-git-send-email-jolsa@redhat.com>
	<1394805606-25883-4-git-send-email-jolsa@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
Date: Mon, 17 Mar 2014 16:13:53 +0900
Message-ID: <87d2hlthzi.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Mar 2014 15:00:04 +0100, Jiri Olsa wrote:
> Moving towards sharing map groups within a process threads.
>
> Because of this we need the map groups to be dynamically
> allocated. No other functional change is intended in here.
> @@ -664,7 +664,7 @@ void thread__find_addr_map(struct thread *thread,
>  	al->cpumode = cpumode;
>  	al->filtered = false;
>  
> -	if (machine == NULL) {
> +	if ((machine == NULL) || (mg == NULL)) {
>  		al->map = NULL;
>  		return;
>  	}

What about the kernel threads?  I guess they're not using thread->mg but
machine->kmaps instead?

Thanks,
Namhyung
